# Break Harvest Collection

## Student Brief

**Effect category:** `degrade` / `disrupt` / `deny` (reversible preferred). **Duration:** About 2.5 hours. **Platform:** Instructor-built harvest cell. Issued foothold: `relay@172.16.2.10` on port `2222` (Moodle `access_key`).

## Operational Context

**Blue Team Handoff (prior DCO cell).** The prior cell supported DCO at Lunovia’s regional power generation plant during a review of blackstart readiness. Engineering partners were exchanging revised islanding studies, creating a steady flow of documents through the defended network. Available reporting suggests the APT wants to understand regional generation dependencies; an intercepted tasking reference to an N-1 assessment supports that judgment.

A defended host was observed sending mail-shaped traffic toward `172.16.2.10`. The cell recovered an SSH private key and validated access as `relay` on port `2222`; Moodle issues that key as `access_key`. A leftover web admin surface appeared capable of command execution, but the cell did not evaluate it.

Take the seat, map how collection moves, and break it cleanly while preserving access for later work. Hunt leadership wants the collection broken for a remediation window — speed matters less than cleanliness.

**Foothold re-entry path (ops station → remote target):**

1. **SSH key foothold on custom port 2222.** Download the private key named `access_key` from Moodle, place it on your ops station, then:
    
    ```
    chmod 600 access_key
    ssh -i access_key -p 2222 relay@172.16.2.10
    ```
    
    If you saved the file somewhere other than your current directory, pass that full path to both commands.
    
2. Validate target context before tasking:
    
    ```
    hostname && whoami && pwd
    ```
    

**The Vantage Point:** From this seat you can see staging, schedules, leftover configs, and logs that show how objects move. Watch long enough to see objects appear or leave. Peer connections and access logs may reveal more of the collection path. You are authorized against collection you can reach from this foothold **and any further access justified by evidence you discover**. Do not invent logins to unpublished addresses.

**The Counter-Strike Opportunity:** Map how collection occurs end-to-end from what you can see, then achieve a solid **degrade, disrupt, or deny** against that pipeline long enough that new partner take stops moving. Prefer reversible actions that leave your issued foothold intact.

## Authority (Notional)

- **Authorized effect:** `degrade` / `disrupt` / `deny` against the harvest collection path you can reach from this seat (and any further access justified by evidence on the cell).
- **Authorized surfaces:** services, schedules, and data paths under `/srv/relay/` and related configs on the issued seat; any further access you earn from discoverable evidence, used to stop collection.
- **Not authorized:** Destruction of log evidence, permanent key wipe without instructor go, implants/callbacks, logging into a host you cannot justify from evidence on the issued seat.
- **Authority ceiling:** Anything outside the above needs a verbal go from the instructor acting as Mission Commander.

## Specific Tasks

1. Re-enter the issued foothold. Validate hostname, user, and working directory.
2. Enumerate how collection is occurring. Produce a short inventory of:
    - Processes / services that accept or stage harvest objects.
    - Scheduled execution that moves or encrypts staged objects.
    - Evidence of how objects leave staging (connections, logs, clearing cadence).
3. Observe live cadence long enough to establish a baseline (objects appear or leave staging without you planting them).
4. Select a collection effect that satisfies the authority above. Prefer reversible `degrade` / `disrupt` / `deny`.
5. Execute the action. Validate by waiting at least one collection cycle and showing that new take stops progressing (evidence you can prove from your seats).
6. Write the five-line effect report (effect, action, predicted response, observed result, burn-risk reassessment). Note whether the issued foothold still works.

## Commander's Guidance

- For this lab, reversible **degrade/disrupt/deny** actions are preferred.
- Preserve the issued foothold for later work.

## Deliverables

Submit to the instructor:

1. **Enumeration summary** — how collection works from your evidence; processes / timers / configs; any further access you earned and how.
2. **Burn-risk / reversibility note** — one paragraph on why your action sits where it does.
3. **Five-line effect report** — effect, action, predicted adversary response, observed result, burn-risk reassessment.
4. **Validation log** — before/after evidence that collection stopped progressing.

## Success Criteria

- You mapped the collection path from the issued foothold with concrete evidence.
- After your action, at least one full cycle shows collection stopped or clearly failed (not mere silence without a cause you can name).
- The effect report names `degrade`, `disrupt`, or `deny` exactly.
- The issued foothold still works after the effect (or you document the burn tradeoff).
- You did not require instructor-issued Windows credentials for this session.

## Constraints

- Start from the issued foothold at `172.16.2.10`.
- Do not target classmate ranges.
- Do not invent logins to hosts you cannot justify from evidence on the issued seat.
- Do not target `10.10.0.0/16` — PCTE control range; off limits.
- Do not use accounts named `simspace` or `simspace management` (any capitalization or spacing variants if encountered).
- If the password `Simspace1!Simspace1!` is found, do not use it to gain or expand access in any way.

# Break Harvest Collection — Instructor Answer Key

## Objective and starting context

Students start with a **mail-relay-only** handoff (`access_key` → `relay@172.16.2.10:2222`). They map the four-host harvest pipeline from evidence on that seat, optionally earn file-index by discovering `172.16.4.20` from pickup/peer evidence, enumerating Spooler, authenticating as `printop` / `Printop!01`, and escalating via PrintNightmare to **SYSTEM**. They execute a reversible **degrade/disrupt/deny** against collection and preserve the foothold. Sync-node logins must fail. `svc.harvest` password is **not** in the student brief.

Build contract: `environments/b04_temp_harvest_cell/README.md`.

## Flag / reference table

|Item|Source|Default|
|---|---|---|
|Intake host|Live|`mail-relay` / `172.16.2.10`|
|Intake SSH|Handoff|`relay` port `2222`, Moodle `access_key`|
|Leftover exec|Discoverable (not in student brief)|`admin` / `relayadmin` on `:8080` → root-backed allow-list helper|
|Indexer IP (discover)|Pickup / `ss` / auth logs|`172.16.4.20`|
|Spooler bootstrap|Null-session / RID enum|`printop` / `Printop!01` (Users only)|
|M20 landing|PrintNightmare|SYSTEM|
|Windows service user|Instructor / M21 issued|`svc.harvest` / `Harvest!Relay01`|
|Packet share (wrong)|`/etc/harvest.cfg`|`D:\Harvest`|
|Live worker|Windows|`C:\ProgramData\Harvest\bin\harvest_worker.py`|
|Real mail processor|`/etc/cron.d/mail-process`|`mail_process.py` → pickup|
|Cron lie|`/etc/cron.d/harvest-forward`|No-op|
|Victim source|Instructor only|`blue-victim` / `172.16.1.2`|
|Threat actor|Instructor only|`sync-node` / `172.16.5.30` (direct SSH denied; keyword reverse-shell is M21 stretch)|

No Hiera flags. Grade the four student deliverables. Do not commit PrintNightmare PoCs to this repo; stage offline on Kali.

## Initial situational awareness

On the ops station, then inside mail-relay after login:

```
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

```
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

```
# on mail-relay
ss -tuln | grep 8080
systemctl cat leftover_exec
# or: cat /etc/systemd/system/leftover_exec.service
# or: grep -E 'EXEC_|USER|PASSWORD|admin|relayadmin' /usr/local/sbin/leftover_exec.py
```

**Expected credential evidence:** unit env `EXEC_USER=admin` / `EXEC_PASS=relayadmin`; script defaults match if env is missing. `/admin` responds without auth (`harvest admin`); `/admin/exec` requires Basic auth.

**First-use:** `-u` is HTTP Basic auth. The helper runs as **root** via systemd, but only allow-listed commands: `hostname`, `whoami`, `pwd`, `id`, `ls`, `cat`, `tail`, `grep`, `ps`, `ss`, `date`, `echo`. It is elevated read/triage via curl, not a free `systemctl` shell.

Once found (from ops station or relay):

```
curl -u admin:relayadmin "http://172.16.2.10:8080/admin"
curl -u admin:relayadmin "http://172.16.2.10:8080/admin/exec?cmd=hostname"
curl -u admin:relayadmin "http://172.16.2.10:8080/admin/exec?cmd=cat%20/etc/systemd/system/leftover_exec.service"
```

**Transition:** handoff → listener on 8080 → nginx proxy to localhost helper → cleartext unit/script creds → optional elevated reach for effects that plain `relay` cannot do cleanly (service/cron/key write still need a path beyond the allow-list or another seat).

### 2. Map collection on the relay

```
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

```
# on mail-relay — peer evidence
ss -tn | grep -E '172\.16\.4\.|ESTAB'
# optional: auth / syslog for pull@ from 172.16.4.20
```

**How they know `172.16.4.20`:** discoverable from live collection behavior on the issued seat (pickup drain + peer sockets / logs), not a planted credential file.

From ops station:

```
nmap -p 135,445,5985 172.16.4.20
rpcdump.py 172.16.4.20 | grep -i spool
enum4linux -a 172.16.4.20
# or rpcclient / lookupsid-style RID cycling against null session
```

**How they know `printop`:** null-session / SAMR enum of local users (`RestrictAnonymous=0`). Password is the common CapitalizedUsername`!01` variant (`Printop!01`) after weak-local spray — not literal username=password (Server complexity blocks that).

Then run the staged offline PrintNightmare PoC (CVE-2021-1675 / CVE-2021-34527 class) authenticated as `printop` / `Printop!01` against `172.16.4.20` → **SYSTEM** shell. Confirm Spooler was the surface; do not hand students the PoC path in the brief.

On SYSTEM (or equivalent):

```
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

|Action|Effect flavor|Validation|
|---|---|---|
|Stop/disable `smtp_sink`|deny intake|No new `/srv/relay/incoming/` mail|
|Disable `/etc/cron.d/mail-process` or stop encrypt|disrupt|Pickup stops getting new `.enc`|
|Empty/choke pickup + block `pull` key|degrade|Indexer cannot pull; outbox goes quiet|
|Disable `HarvestIndex` task (earned SYSTEM)|deny indexer|Outbox stops new `*_curated.zip`|

Prefer reversible. Preserve `relay` SSH.

Leftover nginx is optional: not required to map the pipeline; useful when teams want elevated reach for stronger break actions that plain `relay` (group `harvest`/`adm`) cannot do cleanly (for example service/cron/`transit.key` write). The curl allow-list itself is elevated read — grade creative privilege use, not a pasted board password.

Pre-execution (custom scripts): if students edit `mail_process.py`, have them `head` it first and explain the change.

### Instructor concepts (not issued to students)

Coaching / grading reference only — how a Mission Commander might expect `deny` / `disrupt` / `degrade` (ENGAGE Affect / Disable) to look. Students invent their own path; do not hand this list out.

**Mail-relay (issued seat)**

|Flavor|How it might be done|Validation cue|
|---|---|---|
|Deny|Stop or disable `smtp_sink` (or block `:2525` if permitted) so victim SMTP never lands|No new `/srv/relay/incoming/`|
|Disrupt|Disable `/etc/cron.d/mail-process` or break the encrypt step so `.eml` piles without new `.enc`|Pickup stagnant; incoming grows|
|Disrupt|Reversible swap/corrupt of `/etc/relay/transit.key` (backup first) so pull may still copy but decrypt fails on the indexer|Worker errors; outbox quiet while pickup may still move|
|Degrade|Choke pickup (truncate, ACL, empty) or remove `pull` from `authorized_keys` so the indexer starves without killing SMTP|Pickup sticks; HarvestOut slows|
|Degrade|Narrow `mail_process.py` marker/rules so only some mail becomes `.enc`|Fewer `.enc` vs baseline; partial take still appears|

**File-index (earned SYSTEM)**

|Flavor|How it might be done|Validation cue|
|---|---|---|
|Deny|Disable `HarvestIndex` so no new curated packages form|Outbox frozen|
|Disrupt|Break/remove `id_pull` or indexer `transit.key` so the worker cannot pull/decrypt|Inbox/outbox quiet; pickup stacks on mail-relay|
|Disrupt|Break `HarvestOut` share ACL so the threat-actor collect fails while local outbox may still write|Local outbox may grow; sync-node `/opt/relay/collected` stagnates (instructor check)|
|Degrade|Hollow `KEEP_EXT` (empty keep set) so the worker still runs but curated zips are empty/useless|Sidecar `kept` empty; actor gets hollow packages|
|Degrade|Quarantine/move outbox objects faster than actor cadence so the final hop drinks little|Outbox churn; collected sparse|

Stopping Spooler as the primary effect is high burn-risk (kills the PrintNightmare earn path) — not preferred. Prefer reversible changes that leave `relay` SSH intact.

### 6. Validate one cycle

```
# on mail-relay — before/after listing
ls -la /srv/relay/incoming /srv/relay/pickup
# wait >= blue-victim cadence (~10 min)
ls -la /srv/relay/incoming /srv/relay/pickup
```

If on file-index (SYSTEM):

```
Get-ChildItem C:\ProgramData\Harvest\outbox
Start-Sleep -Seconds 120
Get-ChildItem C:\ProgramData\Harvest\outbox
```

Expected after a good break: no new progressing objects tied to the broken hop.

### 7. Five-line report check

Must name `degrade`, `disrupt`, or `deny`; state action; predicted vs observed; burn-risk (especially if leftover or SYSTEM was used).

## Troubleshooting / confirmation

|Symptom|Check|
|---|---|
|SSH refused|port 2222; `chmod 600`; authorized_keys|
|No baseline tick|blue-victim task; smtp_sink; mail-process; pull key|
|Cannot find indexer IP|watch pickup clear; `ss -tn`; auth logs for `pull`|
|Enum misses `printop`|RestrictAnonymous / RestrictAnonymousSAM / RestrictNullSessAccess on file-index|
|PrintNightmare fails|Spooler running; PointAndPrint + RestrictDriverInstallationToAdministrators=0; vulnerable gold image; PoC auth as `printop` / `Printop!01`|
|Students ask for `svc.harvest` password|Redirect to Spooler enum path; password is M21-only|
|Sync-node login works|Re-run sync configure harden; ufw/sshd deny|
|Effect bricks foothold|Snapshot restore; mark burn-risk miss|

Reset: `environments/b04_temp_harvest_cell/RESET.md`.

## Grading checkpoints

| Deliverable             | Acceptable                                                                                                                 |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Enumeration summary     | Pipeline map from evidence; real processor vs DocHarvest lie; optional pivot path documented (IP discovery + Spooler earn) |
| Burn-risk note          | Reversibility and foothold impact addressed                                                                                |
| Five-line effect report | Correct doctrinal effect name; action matches evidence                                                                     |
| Validation log          | Before/after proof collection stopped progressing                                                                          |
| Discipline              | No graded sync-node shell; `svc.harvest` not assumed from M20 handoff                                                      |


# Instructor Range Breakdown

Instructor-only cheat sheet for the temporary harvest cell (B04.M20–M21). Do **not** publish `blue-victim` `172.16.1.2` or threat-actor `sync-node` `172.16.5.30` to students. Do **not** put Windows password in the M20 brief. Full deploy: README.md (not in this Moodle backup) / BUILD.md (not in this Moodle backup).

## Pipeline (one line)

`blue-victim` (empty HarvestData → generate keep/drop → SMTP) → `mail-relay` encrypt to pickup → `file-index` pulls/decrypts/triages **all** pickup `.enc` to outbox (remote-rm) → `sync-node` (threat actor) final collect.

## Access by Module

|Module|Issued|Earned / denied|
|---|---|---|
|M20 break|mail-relay only|file-index via pickup observation → Spooler enum → PrintNightmare (`printop` / `Printop!01` → SYSTEM); direct sync-node SSH denied|
|M21 poison|mail-relay + file-index creds stated|graded on outbox poison; keyword bait → reverse-shell stretch via mail-relay `nc`|

## blue-victim

**Hostname:** `blue-victim`  
**IP:** `172.16.1.2`  
**OS:** Windows  
**Student access:** No

**Purpose:** Victim-org source. `C:\Share\HarvestData` is empty at rest. Each tick `Simspace_Generator` writes mixed keep/drop files (plus any manual drops), `collection.ps1` zips and SMTP-submits (`PROCESS-HARVEST`) to `mail-relay:2525`, then wipes all share children.

### Files on disc

|Artifact|Live path|Why it is here|
|---|---|---|
|`generate.ps1`|`C:\Simspace_Generator\generate.ps1`|Mixed keep/drop feeder (outside share)|
|`collection.ps1`|`C:\ProgramData\HarvestCollect\bin\collection.ps1`|Generate → zip → SMTP → empty share|
|share staging|`C:\Share\HarvestData\`|Empty at rest; populated only during collect|
|task|`\Microsoft\Windows\Servicing\HarvestCollect`|Keeps collection ticking|

---

## mail-relay

**Hostname:** `mail-relay`  
**IP:** `172.16.2.10`  
**OS:** Ubuntu 22.04 LTS server  
**Student access:** Yes (`relay` :2222, leftover :8080)

**Purpose:** Mail stager. Accepts mail-like objects, rule-checks, encrypts zip to pickup. Does **not** push to Windows.

### Files on disc

|Artifact|Live path|Why it is here|
|---|---|---|
|`smtp_sink.py`|`/usr/local/sbin/smtp_sink.py` (:2525)|Receives victim mail into incoming|
|`mail_process.py`|`/usr/local/sbin/mail_process.py`|Real processor → `/srv/relay/pickup/*.enc`|
|`mail-process` cron|`/etc/cron.d/mail-process`|Schedules real processor|
|`harvest.cfg`|`/etc/harvest.cfg`|Stale DocHarvest / py3.11 / `D:\Harvest` lie|
|`harvest-forward`|`/etc/cron.d/harvest-forward`|No-op lie (not the mover)|
|leftover + nginx|`:8080` → 8081|Prior-team hole / fallback|
|incoming / pickup|`/srv/relay/incoming/`, `/srv/relay/pickup/`|Spool and encrypted pickup|
|transit key|`/etc/relay/transit.key`|Teaching XOR key (`HarvestTransitKey01`)|
|`reviewer`|`/home/reviewer/.ssh/authorized_keys`|Actor stage key only (`id_stage.pub`); `-R` to `127.0.0.1:1337`|

---

## file-index

**Hostname:** `file-index`  
**IP:** `172.16.4.20`  
**OS:** Windows Server 2019 Desktop Experience (vulnerable gold for PrintNightmare)  
**Student access:** M20 earned (PrintNightmare → SYSTEM); M21 issued (`svc.harvest` / `Harvest!Relay01`)

**Purpose:** Indexer / collection management. Pulls all `.enc` from mail pickup each tick, decrypts, triages zip (keep office-like extensions in `KEEP_EXT`), writes curated package + JSON for the actor, and remote-rms each processed pickup object.

**M20 earn surface:** Print Spooler + PointAndPrint misconfig; null-session enum; bootstrap user `printop` / `Printop!01` (Users only) → PrintNightmare → SYSTEM.

### Files on disc

|Artifact|Live path|Why it is here|
|---|---|---|
|`harvest_worker.py`|`C:\ProgramData\Harvest\bin\harvest_worker.py`|Pull all + decrypt + triage each; drain pickup|
|`normalize_v3.ps1`|`C:\ProgramData\Harvest\bin\normalize_v3.ps1`|Legacy helper retained|
|`transit.key` / `id_pull`|`C:\ProgramData\Harvest\bin\`|Match mail transit key; SFTP to user `pull`|
|inbox / outbox|`C:\ProgramData\Harvest\inbox`, `outbox`|Pull staging; actor-ready take|
|shares|`Harvest`, `HarvestOut`|Inbox; outbox for sync-node|
|task|`\Microsoft\Windows\Servicing\HarvestIndex`|Runs worker ~15 min|
|Spooler|Print Spooler service|PrintNightmare lab surface|
|`printop`|local Users account (`Printop!01`)|Auth bootstrap for remote Spooler exploit|

**Handoff lie:** `D:\Harvest` must **not** exist. Runtime Python **3.8.10**.

---

## sync-node (emulated threat actor)

**Hostname:** `sync-node`  
**IP:** `172.16.5.30`  
**OS:** Debian 12 minimal  
**Student access:** No direct SSH (sshd deny; ufw deny incoming when available). Keyword hit stages reverse shell on mail-relay `127.0.0.1:1337` (`nc` attach).

**Purpose:** Finishes the collection loop. Pulls curated outbox packages from `\\file-index\HarvestOut` into `/opt/relay/collected/`. On `blackstart` / `islanding` / `N-1` in curated take, stages operator reverse-shell channel for follow-on work.

### Files on disc

| Artifact                 | Live path                           | Why it is here                                         |
| ------------------------ | ----------------------------------- | ------------------------------------------------------ |
| `actor-collect.sh`       | `/opt/relay/actor-collect.sh`       | SMB final collect                                      |
| `actor-collect-loop.sh`  | `/opt/relay/actor-collect-loop.sh`  | Collect + keyword react; cron every 30 min             |
| `actor-keyword-react.sh` | `/opt/relay/actor-keyword-react.sh` | Keyword scan; socat PTY binder; SSH `-R` to mail-relay |
| cron                     | `/etc/cron.d/actor-collect`         | Schedules actor pull                                   |
| collected/               | `/opt/relay/collected/`             | Actor-held take                                        |
| `princess_peach.txt`     | `/opt/relay/princess_peach.txt`     | Landing clue in reverse-shell cwd                      |
| stage key                | `/opt/relay/state/id_stage`         | Actor→`reviewer@mail-relay` (configure-only)           |