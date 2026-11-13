---
id: B04.M20-key
title: Break Harvest Collection — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Break Harvest Collection — Instructor Answer Key

## Objective and starting context

Students start with a **mail-relay-only** handoff (`access_key` → `relay@172.16.2.10:2222`). They map the four-host harvest pipeline from evidence on that seat, optionally earn file-index by discovering `172.16.4.20` from pickup/peer evidence, enumerating Spooler, authenticating as `printop` / `Printop!01`, and escalating via PrintNightmare to **SYSTEM**. They execute a reversible **degrade/disrupt/deny** against collection and preserve the foothold. Sync-node logins must fail. `svc.harvest` password is **not** in the student brief.

Build contract: `environments/b04_temp_harvest_cell/README.md`.

## Flag / reference table

| Item | Source | Default |
| --- | --- | --- |
| Intake host | Live | `mail-relay` / `172.16.2.10` |
| Intake SSH | Handoff | `relay` port `2222`, Moodle `access_key` |
| Leftover exec | Discoverable (not in student brief) | `admin` / `relayadmin` on `:8080` → root-backed allow-list helper |
| Indexer IP (discover) | Pickup / `ss` / auth logs | `172.16.4.20` |
| Spooler bootstrap | Null-session / RID enum | `printop` / `Printop!01` (Users only) |
| M20 landing | PrintNightmare | SYSTEM |
| Windows service user | Instructor / M21 issued | `svc.harvest` / `Harvest!Relay01` |
| Packet share (wrong) | `/etc/harvest.cfg` | `D:\Harvest` |
| Live worker | Windows | `C:\ProgramData\Harvest\bin\harvest_worker.py` |
| Real mail processor | `/etc/cron.d/mail-process` | `mail_process.py` → pickup |
| Cron lie | `/etc/cron.d/harvest-forward` | No-op |
| Victim source | Instructor only | `blue-victim` / `172.16.1.2` |
| Threat actor | Instructor only | `sync-node` / `172.16.5.30` (direct SSH denied; keyword reverse-shell is M21 stretch) |

No Hiera flags. Grade the four student deliverables. Do not commit PrintNightmare PoCs to this repo; stage offline on Kali.

## Initial situational awareness

On the ops station, then inside mail-relay after login:

```bash
date -u
hostname
whoami
id
pwd
uname -a
ps aux
ss -tulpen
```

**Why this matters:** Prove the seat is `mail-relay` / `relay`, not a classmate box, before changing collection.

**Expected findings:** Ubuntu 22.04; user `relay` in groups `harvest` and `adm`; listeners include sshd 2222, nginx 8080, smtp_sink 2525.

## Instructor live walkthrough

### 1. Primary intake SSH

```bash
chmod 600 access_key
ssh -i access_key -p 2222 relay@172.16.2.10
hostname && whoami && pwd
```

`-i` selects the Moodle private key; `-p 2222` matches the handoff port.

Expected: `mail-relay`, `relay`, `/home/relay`.

### 1b. Optional leftover nginx path (not required to map)

Not issued in the student brief. The Blue Team Handoff only notes an unevaluated web admin surface. Students who dig can recover cleartext Basic-auth creds on-box and use a **root-backed** helper for elevated read/triage that can support stronger deny/disrupt/degrade actions. Mapping collection as `relay` alone is still enough.

**How they notice it:** After SSH, `ss -tulpen` / `ps` show nginx listening on `:8080` (and the handoff already flagged a leftover web admin).

**Where nginx is hosted:** site config `/etc/nginx/sites-available/harvest` (enabled under `sites-enabled`). nginx listens on `0.0.0.0:8080` and **proxies** to `leftover_exec` on `127.0.0.1:8081`.

**How they recover creds (as `relay`, no sudo):**

```bash
# on mail-relay
ss -tuln | grep 8080
systemctl cat leftover_exec
# or: cat /etc/systemd/system/leftover_exec.service
# or: grep -E 'EXEC_|USER|PASSWORD|admin|relayadmin' /usr/local/sbin/leftover_exec.py
```

**Expected credential evidence:** unit env `EXEC_USER=admin` / `EXEC_PASS=relayadmin`; script defaults match if env is missing. `/admin` responds without auth (`harvest admin`); `/admin/exec` requires Basic auth.

**First-use:** `-u` is HTTP Basic auth. The helper runs as **root** via systemd, but only allow-listed commands: `hostname`, `whoami`, `pwd`, `id`, `ls`, `cat`, `tail`, `grep`, `ps`, `ss`, `date`, `echo`. It is elevated read/triage via curl, not a free `systemctl` shell.

Once found (from ops station or relay):

```bash
curl -u admin:relayadmin "http://172.16.2.10:8080/admin"
curl -u admin:relayadmin "http://172.16.2.10:8080/admin/exec?cmd=hostname"
curl -u admin:relayadmin "http://172.16.2.10:8080/admin/exec?cmd=cat%20/etc/systemd/system/leftover_exec.service"
```

**Transition:** handoff → listener on 8080 → nginx proxy to localhost helper → cleartext unit/script creds → optional elevated reach for effects that plain `relay` cannot do cleanly (service/cron/key write still need a path beyond the allow-list or another seat).

### 2. Map collection on the relay

```bash
ps -ef | head -n 40
ss -tulpen
ls -la /srv/relay /etc/relay /etc/cron.d
cat /etc/harvest.cfg
cat /etc/cron.d/harvest-forward
cat /etc/cron.d/mail-process
ls -la /srv/relay/incoming /srv/relay/pickup
sleep 90
ls -la /srv/relay/incoming /srv/relay/pickup
ss -tn
```

**How they know `/etc/harvest.cfg`:** leftover hunt notes / ordinary `/etc` triage. **Transition:** packet claims local DocHarvest cron; live files show no-op forward + real `mail-process`.

Expected: `.eml` / `.enc` appear or leave without student plant; `harvest-forward` is a lie; pickup clears when file-index pulls.

### 3. Discover indexer IP, then earn SYSTEM (optional path)

Watch pickup clear and correlate with established connections or auth logs pointing at `172.16.4.20`.

```bash
# on mail-relay — peer evidence
ss -tn | grep -E '172\.16\.4\.|ESTAB'
# optional: auth / syslog for pull@ from 172.16.4.20
```

**How they know `172.16.4.20`:** discoverable from live collection behavior on the issued seat (pickup drain + peer sockets / logs), not a planted credential file.

From ops station:

```bash
nmap -p 135,445,5985 172.16.4.20
rpcdump.py 172.16.4.20 | grep -i spool
enum4linux -a 172.16.4.20
# or rpcclient / lookupsid-style RID cycling against null session
```

**How they know `printop`:** null-session / SAMR enum of local users (`RestrictAnonymous=0`). Password is the common CapitalizedUsername`!01` variant (`Printop!01`) after weak-local spray — not literal username=password (Server complexity blocks that).

Then run the staged offline PrintNightmare PoC (CVE-2021-1675 / CVE-2021-34527 class) authenticated as `printop` / `Printop!01` against `172.16.4.20` → **SYSTEM** shell. Confirm Spooler was the surface; do not hand students the PoC path in the brief.

On SYSTEM (or equivalent):

```powershell
hostname; whoami
Get-ScheduledTask -TaskName HarvestIndex
Get-Content C:\ProgramData\Harvest\bin\harvest_worker.py -TotalCount 40
Get-SmbShare
```

Expected: host `file-index`; identity `NT AUTHORITY\SYSTEM` (or SYSTEM-equivalent); worker + `HarvestIndex` + Harvest shares visible.

### 4. Confirm sync-node is not a direct seat

Any student SSH attempt to `172.16.5.30` should fail (auth denied / filtered). Do not require them to try; if they do, the failure is the finding. Keyword reverse-shell attach from mail-relay is an **M21 stretch**, not an M20 success criterion.

### 5. Acceptable break actions (examples)

Any one of these (or equivalent) is enough if validated:

| Action | Effect flavor | Validation |
| --- | --- | --- |
| Stop/disable `smtp_sink` | deny intake | No new `/srv/relay/incoming/` mail |
| Disable `/etc/cron.d/mail-process` or stop encrypt | disrupt | Pickup stops getting new `.enc` |
| Empty/choke pickup + block `pull` key | degrade | Indexer cannot pull; outbox goes quiet |
| Disable `HarvestIndex` task (earned SYSTEM) | deny indexer | Outbox stops new `*_curated.zip` |

Prefer reversible. Preserve `relay` SSH.

Leftover nginx is optional: not required to map the pipeline; useful when teams want elevated reach for stronger break actions that plain `relay` (group `harvest`/`adm`) cannot do cleanly (for example service/cron/`transit.key` write). The curl allow-list itself is elevated read — grade creative privilege use, not a pasted board password.

Pre-execution (custom scripts): if students edit `mail_process.py`, have them `head` it first and explain the change.

### Instructor concepts (not issued to students)

Coaching / grading reference only — how a Mission Commander might expect `deny` / `disrupt` / `degrade` (ENGAGE Affect / Disable) to look. Students invent their own path; do not hand this list out.

**Mail-relay (issued seat)**

| Flavor | How it might be done | Validation cue |
| --- | --- | --- |
| Deny | Stop or disable `smtp_sink` (or block `:2525` if permitted) so victim SMTP never lands | No new `/srv/relay/incoming/` |
| Disrupt | Disable `/etc/cron.d/mail-process` or break the encrypt step so `.eml` piles without new `.enc` | Pickup stagnant; incoming grows |
| Disrupt | Reversible swap/corrupt of `/etc/relay/transit.key` (backup first) so pull may still copy but decrypt fails on the indexer | Worker errors; outbox quiet while pickup may still move |
| Degrade | Choke pickup (truncate, ACL, empty) or remove `pull` from `authorized_keys` so the indexer starves without killing SMTP | Pickup sticks; HarvestOut slows |
| Degrade | Narrow `mail_process.py` marker/rules so only some mail becomes `.enc` | Fewer `.enc` vs baseline; partial take still appears |

**File-index (earned SYSTEM)**

| Flavor | How it might be done | Validation cue |
| --- | --- | --- |
| Deny | Disable `HarvestIndex` so no new curated packages form | Outbox frozen |
| Disrupt | Break/remove `id_pull` or indexer `transit.key` so the worker cannot pull/decrypt | Inbox/outbox quiet; pickup stacks on mail-relay |
| Disrupt | Break `HarvestOut` share ACL so the threat-actor collect fails while local outbox may still write | Local outbox may grow; sync-node `/opt/relay/collected` stagnates (instructor check) |
| Degrade | Hollow `KEEP_EXT` (empty keep set) so the worker still runs but curated zips are empty/useless | Sidecar `kept` empty; actor gets hollow packages |
| Degrade | Quarantine/move outbox objects faster than actor cadence so the final hop drinks little | Outbox churn; collected sparse |

Stopping Spooler as the primary effect is high burn-risk (kills the PrintNightmare earn path) — not preferred. Prefer reversible changes that leave `relay` SSH intact.

### 6. Validate one cycle

```bash
# on mail-relay — before/after listing
ls -la /srv/relay/incoming /srv/relay/pickup
# wait >= blue-victim cadence (~10 min)
ls -la /srv/relay/incoming /srv/relay/pickup
```

If on file-index (SYSTEM):

```powershell
Get-ChildItem C:\ProgramData\Harvest\outbox
Start-Sleep -Seconds 120
Get-ChildItem C:\ProgramData\Harvest\outbox
```

Expected after a good break: no new progressing objects tied to the broken hop.

### 7. Five-line report check

Must name `degrade`, `disrupt`, or `deny`; state action; predicted vs observed; burn-risk (especially if leftover or SYSTEM was used).

## Troubleshooting / confirmation

| Symptom | Check |
| --- | --- |
| SSH refused | port 2222; `chmod 600`; authorized_keys |
| No baseline tick | blue-victim task; smtp_sink; mail-process; pull key |
| Cannot find indexer IP | watch pickup clear; `ss -tn`; auth logs for `pull` |
| Enum misses `printop` | RestrictAnonymous / RestrictAnonymousSAM / RestrictNullSessAccess on file-index |
| PrintNightmare fails | Spooler running; PointAndPrint + RestrictDriverInstallationToAdministrators=0; vulnerable gold image; PoC auth as `printop` / `Printop!01` |
| Students ask for `svc.harvest` password | Redirect to Spooler enum path; password is M21-only |
| Sync-node login works | Re-run sync configure harden; ufw/sshd deny |
| Effect bricks foothold | Snapshot restore; mark burn-risk miss |

Reset: `environments/b04_temp_harvest_cell/RESET.md`.

## Grading checkpoints

| Deliverable | Acceptable |
| --- | --- |
| Enumeration summary | Pipeline map from evidence; real processor vs DocHarvest lie; optional pivot path documented (IP discovery + Spooler earn) |
| Burn-risk note | Reversibility and foothold impact addressed |
| Five-line effect report | Correct doctrinal effect name; action matches evidence |
| Validation log | Before/after proof collection stopped progressing |
| Discipline | No graded sync-node shell; `svc.harvest` not assumed from M20 handoff |
