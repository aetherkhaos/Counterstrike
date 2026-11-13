---
id: B04.M20-range-breakdown
title: Break Harvest Collection — Instructor Range Breakdown
artifact_type: reference
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: work_aid_v1
sensitivity: instructor_only
environments:
- environments/b04_temp_harvest_cell
---

# Instructor Range Breakdown

Instructor-only cheat sheet for the temporary harvest cell (B04.M20–M21). Do **not** publish `blue-victim` `172.16.1.2` or threat-actor `sync-node` `172.16.5.30` to students. Do **not** put Windows password in the M20 brief. Full deploy: [README.md](../../../../environments/b04_temp_harvest_cell/README.md) / [BUILD.md](../../../../environments/b04_temp_harvest_cell/BUILD.md).

## Pipeline (one line)

`blue-victim` (empty HarvestData → generate keep/drop → SMTP) → `mail-relay` encrypt to pickup → `file-index` pulls/decrypts/triages **all** pickup `.enc` to outbox (remote-rm) → `sync-node` (threat actor) final collect.

## Access by Module

| Module | Issued | Earned / denied |
| --- | --- | --- |
| M20 break | mail-relay only | file-index via pickup observation → Spooler enum → PrintNightmare (`printop` / `Printop!01` → SYSTEM); direct sync-node SSH denied |
| M21 poison | mail-relay + file-index creds stated | graded on outbox poison; keyword bait → reverse-shell stretch via mail-relay `nc` |

## blue-victim

**Hostname:** `blue-victim`  
**IP:** `172.16.1.2`  
**OS:** Windows  
**Student access:** No  

**Purpose:** Victim-org source. `C:\Share\HarvestData` is empty at rest. Each tick `Simspace_Generator` writes mixed keep/drop files (plus any manual drops), `collection.ps1` zips and SMTP-submits (`PROCESS-HARVEST`) to `mail-relay:2525`, then wipes all share children.

### Files on disc

| Artifact | Live path | Why it is here |
| --- | --- | --- |
| `generate.ps1` | `C:\Simspace_Generator\generate.ps1` | Mixed keep/drop feeder (outside share) |
| `collection.ps1` | `C:\ProgramData\HarvestCollect\bin\collection.ps1` | Generate → zip → SMTP → empty share |
| share staging | `C:\Share\HarvestData\` | Empty at rest; populated only during collect |
| task | `\Microsoft\Windows\Servicing\HarvestCollect` | Keeps collection ticking |

---

## mail-relay

**Hostname:** `mail-relay`  
**IP:** `172.16.2.10`  
**OS:** Ubuntu 22.04 LTS server  
**Student access:** Yes (`relay` :2222, leftover :8080)  

**Purpose:** Mail stager. Accepts mail-like objects, rule-checks, encrypts zip to pickup. Does **not** push to Windows.

### Files on disc

| Artifact | Live path | Why it is here |
| --- | --- | --- |
| `smtp_sink.py` | `/usr/local/sbin/smtp_sink.py` (:2525) | Receives victim mail into incoming |
| `mail_process.py` | `/usr/local/sbin/mail_process.py` | Real processor → `/srv/relay/pickup/*.enc` |
| `mail-process` cron | `/etc/cron.d/mail-process` | Schedules real processor |
| `harvest.cfg` | `/etc/harvest.cfg` | Stale DocHarvest / py3.11 / `D:\Harvest` lie |
| `harvest-forward` | `/etc/cron.d/harvest-forward` | No-op lie (not the mover) |
| leftover + nginx | `:8080` → 8081 | Prior-team hole / fallback |
| incoming / pickup | `/srv/relay/incoming/`, `/srv/relay/pickup/` | Spool and encrypted pickup |
| transit key | `/etc/relay/transit.key` | Teaching XOR key (`HarvestTransitKey01`) |
| `reviewer` | `/home/reviewer/.ssh/authorized_keys` | Actor stage key only (`id_stage.pub`); `-R` to `127.0.0.1:1337` |

---

## file-index

**Hostname:** `file-index`  
**IP:** `172.16.4.20`  
**OS:** Windows Server 2019 Desktop Experience (vulnerable gold for PrintNightmare)  
**Student access:** M20 earned (PrintNightmare → SYSTEM); M21 issued (`svc.harvest` / `Harvest!Relay01`)  

**Purpose:** Indexer / collection management. Pulls all `.enc` from mail pickup each tick, decrypts, triages zip (keep office-like extensions in `KEEP_EXT`), writes curated package + JSON for the actor, and remote-rms each processed pickup object.

**M20 earn surface:** Print Spooler + PointAndPrint misconfig; null-session enum; bootstrap user `printop` / `Printop!01` (Users only) → PrintNightmare → SYSTEM.

### Files on disc

| Artifact | Live path | Why it is here |
| --- | --- | --- |
| `harvest_worker.py` | `C:\ProgramData\Harvest\bin\harvest_worker.py` | Pull all + decrypt + triage each; drain pickup |
| `normalize_v3.ps1` | `C:\ProgramData\Harvest\bin\normalize_v3.ps1` | Legacy helper retained |
| `transit.key` / `id_pull` | `C:\ProgramData\Harvest\bin\` | Match mail transit key; SFTP to user `pull` |
| inbox / outbox | `C:\ProgramData\Harvest\inbox`, `outbox` | Pull staging; actor-ready take |
| shares | `Harvest`, `HarvestOut` | Inbox; outbox for sync-node |
| task | `\Microsoft\Windows\Servicing\HarvestIndex` | Runs worker ~15 min |
| Spooler | Print Spooler service | PrintNightmare lab surface |
| `printop` | local Users account (`Printop!01`) | Auth bootstrap for remote Spooler exploit |

**Handoff lie:** `D:\Harvest` must **not** exist. Runtime Python **3.8.10**.

---

## sync-node (emulated threat actor)

**Hostname:** `sync-node`  
**IP:** `172.16.5.30`  
**OS:** Debian 12 minimal  
**Student access:** No direct SSH (sshd deny; ufw deny incoming when available). Keyword hit stages reverse shell on mail-relay `127.0.0.1:1337` (`nc` attach).  

**Purpose:** Finishes the collection loop. Pulls curated outbox packages from `\\file-index\HarvestOut` into `/opt/relay/collected/`. On `blackstart` / `islanding` / `N-1` in curated take, stages operator reverse-shell channel for follow-on work.

### Files on disc

| Artifact | Live path | Why it is here |
| --- | --- | --- |
| `actor-collect.sh` | `/opt/relay/actor-collect.sh` | SMB final collect |
| `actor-collect-loop.sh` | `/opt/relay/actor-collect-loop.sh` | Collect + keyword react; cron every 30 min |
| `actor-keyword-react.sh` | `/opt/relay/actor-keyword-react.sh` | Keyword scan; socat PTY binder; SSH `-R` to mail-relay |
| cron | `/etc/cron.d/actor-collect` | Schedules actor pull |
| collected/ | `/opt/relay/collected/` | Actor-held take |
| `princess_peach.txt` | `/opt/relay/princess_peach.txt` | Landing clue in reverse-shell cwd |
| stage key | `/opt/relay/state/id_stage` | Actor→`reviewer@mail-relay` (configure-only) |
