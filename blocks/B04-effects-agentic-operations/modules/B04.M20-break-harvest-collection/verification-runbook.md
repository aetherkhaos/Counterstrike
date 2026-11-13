---
id: B04.M20-verify
title: Break Harvest Collection — Verification
artifact_type: verification_runbook
audience: builder
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: verification_runbook_v1
sensitivity: instructor_only
environments:
- environments/b04_temp_harvest_cell
---

# Break Harvest Collection — Verification

Instructor-only. Run from Kali/ops station unless noted. Paste commands in order. Cadence: blue-victim ~**10 min**, file-index ~**15 min**, sync-node ~**30 min**.

Do **not** put Windows passwords on the student board for M20.

SSH key path: prefer `keys/access_key` or `$HOME/keys/access_key` (Moodle `access_key` on the station). Examples below use `keys/access_key`.

## 0. Instructor credentials

| Use | Value |
| --- | --- |
| Moodle SSH key | `access_key` (key auth; **no password**) |
| Leftover HTTP | user `admin` / password `relayadmin` |
| Spooler bootstrap | user `printop` / password `Printop!01` |
| Windows service (optional) | user `svc.harvest` / password `Harvest!Relay01` |

Hosts: mail-relay `172.16.2.10`, file-index `172.16.4.20`, sync-node `172.16.5.30`, blue-victim `172.16.1.2` (no student path).

---

## 1. Mail-relay student path

```bash
nc -zv 172.16.2.10 2222
nc -zv 172.16.2.10 2525
nc -zv 172.16.2.10 8080
```

**Expect:** all three ports open.

```bash
# HTTP basic: admin / relayadmin
curl -s -u admin:relayadmin http://172.16.2.10:8080/admin
curl -s -u admin:relayadmin "http://172.16.2.10:8080/admin/exec?cmd=hostname"
```

**Expect:** `harvest admin` (or similar) and hostname `mail-relay`.

```bash
# SSH key only — no password (Moodle access_key on this station)
chmod 600 keys/access_key
ssh -i keys/access_key -p 2222 relay@172.16.2.10 'hostname; whoami; cat /etc/cron.d/harvest-forward; test -f /etc/cron.d/mail-process && echo mail-process-ok; test ! -f /etc/relay/windows-ingest.cfg && echo no-ingest-cfg; ls -la /srv/relay/incoming /srv/relay/pickup'
```

**Expect:** `mail-relay` / `relay`; harvest-forward is a no-op lie; `mail-process-ok`; `no-ingest-cfg`.

---

## 2. Pipeline movement

From the relay seat (same key; **no password**):

```bash
ssh -i keys/access_key -p 2222 relay@172.16.2.10 'ls -la /srv/relay/incoming /srv/relay/pickup; ss -tn | head -n 40'
```

**Expect:** over time, `.eml` then `.enc` activity; established peers may include `172.16.4.20` (file-index pull). Wait up to ~**10 min** for a victim tick if queues are empty.

**Fail if pickup accumulates forever** (new `.enc` every ~10 min with no shrink after HarvestIndex ticks). That means pull auth or the indexer is stuck — see [Pipeline backlog triage](#pipeline-backlog-triage) below.

Optional indexer shares (password on the command line):

```bash
# password: Harvest!Relay01
smbclient "//172.16.4.20/Harvest" -U 'svc.harvest%Harvest!Relay01' -c 'ls'
smbclient "//172.16.4.20/HarvestOut" -U 'svc.harvest%Harvest!Relay01' -c 'ls'
```

**Expect:** shares list; outbox may show `*_curated.zip` / `.json` within ~**15 min** of pickup activity. Pickup count should shrink after each successful worker run (processed `.enc` removed as `pull`).

Sync-node final store is **not on Kali**. Path `/opt/relay/collected` exists only on **sync-node console** as root (`172.16.5.30`):

```bash
# on sync-node console as root — no remote password in this path
ls -la /opt/relay/collected
# or force one actor pull now:
/opt/relay/actor-collect.sh
ls -la /opt/relay/collected
```

**Expect:** curated objects appear within ~**30 min** after outbox has packages (actor cron), or immediately after the manual script.

### Pipeline backlog triage

If pickup stacks and `Harvest` / `HarvestOut` stay empty:

1. **Authorize pull** on mail-relay as root (BUILD step often skipped):

```bash
ls -l /root/staging/id_pull.pub /home/pull/.ssh/authorized_keys
# If pub missing: copy from file-index C:\ProgramData\Harvest\bin\id_pull.pub → /root/staging/id_pull.pub
install -d -m 700 -o pull -g pull /home/pull/.ssh
install -m 600 -o pull -g pull /root/staging/id_pull.pub /home/pull/.ssh/authorized_keys
```

2. **On file-index console** as Administrator: confirm `id_pull` + `transit.key`; `HarvestIndex` not Disabled; **`svc.harvest` can read `id_pull`** (task runs as that account — preauth resets every ~15 min usually mean a bad ACL); optionally run worker once:

```powershell
Get-ScheduledTask -TaskName HarvestIndex | Format-List TaskName,State
# Private key is exclusive to svc.harvest; Administrators may see Access Denied on icacls.
# Repair (as Admin) matches configure.ps1 / file-index-reset.ps1:
# takeown /F C:\ProgramData\Harvest\bin\id_pull /A
# icacls C:\ProgramData\Harvest\bin\id_pull /inheritance:r
# icacls C:\ProgramData\Harvest\bin\id_pull /grant:r "svc.harvest:(F)"
# icacls C:\ProgramData\Harvest\bin\id_pull /remove "NT AUTHORITY\SYSTEM"
# icacls C:\ProgramData\Harvest\bin\id_pull /remove "BUILTIN\Administrators"
# icacls C:\ProgramData\Harvest\bin\id_pull /remove "Administrator"
# icacls C:\ProgramData\Harvest\bin\id_pull /setowner "svc.harvest"
& "C:\Program Files\Python38\python.exe" C:\ProgramData\Harvest\bin\harvest_worker.py
Get-ChildItem C:\ProgramData\Harvest\inbox, C:\ProgramData\Harvest\outbox
```

3. **Re-check from Kali:** pickup shrinks; `HarvestOut` lists `*_curated.zip`. Then sync-node console: `ls -la /opt/relay/collected`.

---

## 3. PrintNightmare surface viable (M20 earn)

From Kali:

```bash
nmap -p 135,445 172.16.4.20
# Spooler RPC (prefer packaged / module form if rpcdump.py is not on PATH)
impacket-rpcdump 172.16.4.20 2>/dev/null | grep -i spool \
  || python3 -m impacket.examples.rpcdump 172.16.4.20 2>/dev/null | grep -i spool \
  || rpcdump.py 172.16.4.20 2>/dev/null | grep -i spool \
  || echo "rpcdump unavailable — rely on CME printop + Spooler console check"
# null session often fails; use authenticated enum
enum4linux -a -u printop -p 'Printop!01' 172.16.4.20
```

**Expect:** 135/445 open; Spooler-related RPC when tooling is present; local user list includes `printop`.

```bash
# password: Printop!01 — primary remote proof for M20 earn
crackmapexec smb 172.16.4.20 -u printop -p 'Printop!01'
# or: smbclient "//172.16.4.20/IPC$" -U 'printop%Printop!01' -c 'exit'
```

**Expect:** authentication succeeds (printop is Users-only, not admin).

Spooler + policy checks: file-index gold often has **OpenSSH Client only** (no `sshd`). Prefer **file-index console** as Administrator:

```powershell
Get-Service Spooler | Format-List Status,StartType
(Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa).RestrictAnonymous
(Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers').RestrictDriverInstallationToAdministrators
```

Optional remote (only if sshd is listening; password prompted = **`Harvest!Relay01`**):

```bash
ssh svc.harvest@172.16.4.20 "powershell -NoProfile -Command \"Get-Service Spooler | Format-List Status,StartType; (Get-ItemProperty HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Lsa).RestrictAnonymous; (Get-ItemProperty 'HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows NT\\Printers').RestrictDriverInstallationToAdministrators\""
```

**Expect:** Spooler `Running` / Automatic; `RestrictAnonymous` = `0`; `RestrictDriverInstallationToAdministrators` = `0` (lab surface).

Offline PrintNightmare PoC (do **not** commit exploits to the course repo):

```text
Auth as printop / Printop!01 against 172.16.4.20 → SYSTEM shell.
```

**Expect:** SYSTEM foothold; Spooler was the surface.

---

## 4. Sync-node deny

```bash
# BatchMode — no password prompt; expect failure
ssh -o BatchMode=yes -o ConnectTimeout=5 root@172.16.5.30 true; echo exit:$?
```

**Expect:** non-zero exit (auth denied / filtered / unreachable). Students must not get a useful shell here.

---

## 5. After reset

- Soft clean: [range-reset/README.md](./range-reset/README.md)
- Hard factory: [RESET.md](../../../../environments/b04_temp_harvest_cell/RESET.md) (snapshots)

Re-run sections **1–3** before releasing students. After M20 effects, restore snapshots before M21 poison.
