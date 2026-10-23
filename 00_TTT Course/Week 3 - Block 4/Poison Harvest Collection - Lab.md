# Poison Harvest Collection

## Student Brief

**Effect category:** `deceive` / `manipulate`. **Duration:** About 2 hours. **Platform:** Instructor-built Lunovia harvest cell (live continuation). Issued seats: `172.16.2.10` and `172.16.4.20`.

## Operational Context

**Mission context:** This session **continues the live harvest cell** from the prior break session — the range is **not** reset. You still hold the foothold on `172.16.2.10`. Leadership appetite has shifted from "stop them" to "poison them" — make the adversary act on **bad take** while remediation continues on the blue side. Use the prior blue reporting to make the deceptive take credible to this harvest cell. Think critically about **why this APT is collecting here**; well-chosen deceptive take informed by that motive can produce more interesting results than generic honey files.

**Foothold re-entry (ops station → remote targets):**

1. **Issued foothold (still available):** Moodle `access_key` on port 2222 to `relay@172.16.2.10`. Validate with `hostname && whoami && pwd`.
    
2. **Windows host (issued this session):** OpenSSH or WinRM as `svc.harvest` with password `Harvest!Relay01` to `172.16.4.20`. Validate:
    
    ```
    hostname; whoami; pwd
    ```
    

**The Vantage Point:** On `172.16.4.20` you can read the harvest worker, watch inbox/outbox, and see JSON sidecars that record what the adversary **kept** vs **dropped**. That filter set is how you poison well — plant objects that survive triage or corrupt metadata the actor will trust.

**The Counter-Strike Opportunity:** Learn the collection parameters (keep-list / sidecar fields), then plant deceptive content so curated outbox packages mislead the actor. Keep the pipeline **running** — a break or outage is not today’s effect category. Craft take that fits the actor’s collection motive; precision beats volume.

## Mission Commander Guidance (Provided)

- **Command intent:** Broad `deceive` / `manipulate` against harvested evidence so adversary decisions are based on corrupted take.
- **Commander-approved battlespace:** Staging you already know on `172.16.2.10`, plus inbox/outbox and worker-visible metadata on `172.16.4.20`.
- **Commander input on methods:** Plausible office-like honey files that pass the keep filter, misleading sidecar/JSON fields, or curated-zip content shaping are on the table when they improve deception — especially when the content would matter to an actor collecting against this plant.
- **Commander red lines:** Do not destroy the pipeline (`deny`/`disrupt`/`degrade` as the primary outcome), do not wipe logs for cover, do not implant callbacks.
- **Execution expectation:** Log every planted object in plaintext for reconstruction.

## Specific Tasks

1. Re-enter both issued seats. Validate hostname, user, and working directory on each.
2. **Learn the filters.** On `172.16.4.20`, inspect the harvest worker and recent outbox JSON. Record:
    - Which extensions or object types are kept vs dropped.
    - Which sidecar fields (name, size, sha256, notes) an analyst would trust.
3. Baseline one curated package (or sidecar) before you plant anything.
4. Design at least two poison patterns that respect the keep filter (or intentionally exercise a drop path only if you can still show a deceive effect in kept metadata). Examples to consider:
    - Plausible office filenames that seed false attribution.
    - Misleading size/hash/note fields in a sidecar you can influence.
    - Content inside a kept office-like object that would mislead an analyst reading the take.
5. Plant the poison so it progresses through triage into outbox (or clearly appears in `kept` metadata).
6. Validate: show poisoned objects in outbox/sidecar evidence. Confirm legitimate collection still ticks.
7. Write the five-line effect report (effect, action, predicted response, observed result, burn-risk reassessment).

## Constraints and Rules of Engagement

- **Preserve the pipeline.** If you stop collection, you produced a break effect, not poison — grade fails the deceive/manipulate criteria.
- **Bounded volume.** Do not plant more than 50 honey objects. Precision over flood.
- **Log your payloads.** Every planted name and intended deceive effect must appear in the report.

## Deliverables

1. **Filter map** — keep vs drop rules and sidecar fields you used.
2. **Poison inventory** — what you planted and why each survives (or shapes) triage.
3. **Before/after evidence** — outbox listing and/or JSON excerpts showing poison landed; proof pipeline still ticks.
4. **Five-line effect report** — names `deceive` or `manipulate`.

## Success Criteria

- At least two poisoned objects or metadata effects visible in outbox/sidecar evidence.
- Pipeline still functional (new legitimate activity continues).
- Effect report correctly names `deceive` or `manipulate`, not break vocabulary.
- You used the issued seat on `172.16.4.20` to learn filters before planting.

## Constraints

- Stay on `172.16.2.10` and `172.16.4.20`.
- Do not target classmate ranges.
- Do not require a local hypervisor replica for this session.
- Do not target `10.10.0.0/16` — PCTE control range; off limits.
- Do not use accounts named `simspace` or `simspace management` (any capitalization or spacing variants if encountered).
- If the password `Simspace1!Simspace1!` is found, do not use it to gain or expand access in any way.

# Poison Harvest Collection — Instructor Answer Key

## Objective and starting context

Pipeline restored after M20. Students are **issued** mail-relay (`access_key`) and file-index (`svc.harvest` / `Harvest!Relay01` @ `172.16.4.20`). They learn triage filters from `harvest_worker.py` / outbox JSON, plant deceive/manipulate poison that survives keep rules, and prove the pipeline still ticks. Direct sync-node SSH is denied; grade primary success on outbox/sidecar evidence. Keyword bait → reverse-shell attach is stretch/bonus.

Range: `environments/b04_temp_harvest_cell/README.md`.

## Flag / reference table

|Item|Source|Default|
|---|---|---|
|Intake|Handoff|`relay@172.16.2.10:2222`|
|Indexer|Handoff|`svc.harvest` / `Harvest!Relay01` @ `172.16.4.20`|
|Keep filter|`harvest_worker.py`|`KEEP_EXT = {".docx", ".xlsx", ".pdf", ".pptx", ".doc", ".xls"}`|
|Outbox|Windows|`C:\ProgramData\Harvest\outbox\*_curated.zip` + `.json`|
|Sidecar fields|Worker|`kept`, `dropped`, `sha256`, `note`, `source_enc`, ...|
|Keyword selectors|Handoff terms|`blackstart`, `islanding`, `N-1` (in curated zip / JSON)|
|Priority reverse shell|Instructor|mail-relay `nc 127.0.0.1 1337` → sync-node bash cwd `/opt/relay/` (~30 min)|
|Landing clue|`/opt/relay/princess_peach.txt`|`THANK YOU MARIO! YOUR QUEST IS NOW OVER.`|
|Victim / actor|Instructor only|`172.16.1.2` / `172.16.5.30` — no direct student SSH|

## Initial situational awareness

Both seats after login:

```
# mail-relay
hostname && whoami && pwd
ls -la /srv/relay/incoming /srv/relay/pickup
```

```
# file-index
hostname; whoami; pwd
Get-ChildItem C:\ProgramData\Harvest -Recurse | Select-Object -First 40
Get-ScheduledTask -TaskName HarvestIndex
```

**Why this matters:** Poison requires a live indexer seat and a ticking worker; break leftovers from M20 must be rolled back first.

## Instructor live walkthrough

### 1. Confirm issued Windows seat

```
ssh svc.harvest@172.16.4.20
```

Password from brief: `Harvest!Relay01`. **How students know:** M21 handoff states it (unlike M20).

### 2. Learn filter parameters

```
Select-String -Path C:\ProgramData\Harvest\bin\harvest_worker.py -Pattern "KEEP_EXT|kept|dropped|triage"
Get-Content C:\ProgramData\Harvest\bin\harvest_worker.py | Select-Object -First 30
Get-ChildItem C:\ProgramData\Harvest\outbox\*.json | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { Get-Content $_.FullName }
```

**First-use:** `Select-String` finds keep-list without dumping the whole file; students should still read the triage function once.

Expected teaching point: only office-like extensions enter curated zip; others land under `dropped` in the sidecar. Sidecar `note` explains actor-facing intent.

### 3. Baseline

Record one current outbox JSON `kept`/`dropped` counts and newest curated zip name before planting.

### 4. Acceptable poison paths (examples)

Prefer actions that keep HarvestIndex and mail-process running:

|Pattern|How|Evidence|
|---|---|---|
|Office honey via victim share / mail path|Place `.docx`/`.xlsx`/`.pdf` named for false attribution into a path that re-enters SMTP→pickup (instructor may allow planting into a staging zip students can encrypt if they earned that skill)|Appears under sidecar `kept`|
|Direct outbox/sidecar shape|Edit or plant a curated zip + JSON that an actor would pull|New outbox objects with misleading `kept` names/notes|
|Inbox plant + wait for worker|Drop keep-extension objects where worker will re-package if design supports|New curated package|

Accept either path if the report shows filter-aware design and pipeline-up proof. Prefer filter study before plant.

Pre-execution: if students run custom scripts, have them print usage/`Get-Help` equivalent and sanity-check paths first.

### Instructor concepts (not issued to students)

Coaching / grading reference only — how `deceive` / `manipulate` (ENGAGE Affect) might be done given that **sync-node only sees post-triage product** (`KEEP_EXT` curated zip + JSON sidecar). Anything that never reaches `kept` / outbox fails poison intent. Students invent their own path; do not hand this list out.

|Concept|How it might be done|Why it fits post-parse|
|---|---|---|
|Keep-ext honey content|Plant `.docx` / `.xlsx` / `.pdf` (etc.) with false narrative (attribution, timelines, fake decisions)|Lands in sidecar `kept` and inside the curated zip the actor pulls|
|Name-shape for trust|Use office-like names that look like high-value weekly product|Survives keep filter and biases human review of the package|
|Sidecar / metadata deceive|After a live tick, edit or plant JSON (`kept` names, `note`, provenance fields)|Actor may trust sidecar without opening every blob|
|Curated-zip swap / augment|Replace or add keep-ext members in outbox `*_curated.zip` while tasks stay running|Directly shapes what actor-collect drinks|
|Dilution|Flood many keep-ext decoys so real victim take is buried in volume|Pipeline still ticks; attention / priority is manipulated|
|Selective filter manipulate|Temporarily shrink `KEEP_EXT` so only planted types admit (higher burn; near-degrade)|Worker still “ticks,” but real classes never reach the actor|

**Weak / non-viable for poison intent** (grade as break or failed deceive if this is the primary play):

- Corrupt `.enc` or wrong transit alone → decrypt fail (M20-style break, not poison)
- Plant only non-`KEEP_EXT` objects → sidecar `dropped` only; actor never consumes them
- Kill `HarvestIndex` / `mail-process` → pipeline stop is a break effect, not M21 poison
- Drop-path noise alone as “poison” → may support a filter-map story; not primary actor-facing take

### 5. Validate pipeline still ticks

Wait one blue-victim / HarvestIndex cycle. Confirm new legitimate activity (new `.enc` processed or new curated package) alongside poison evidence.

### 6. Sync-node / keyword stretch (optional)

Do **not** require a sync-node shell for primary grade. Direct SSH to `172.16.5.30` must still fail.

**Stretch path (instructor demo / bonus):** plant keep-ext poison whose filename or body includes `blackstart`, `islanding`, or `N-1` so it survives triage into curated zip. Wait one actor collect (~30 min) or trigger `/opt/relay/actor-collect-loop.sh` on the actor console. On mail-relay:

```
# baseline then delta after bait cycle
ss -lntp
ss -tnp
# expect new loopback LISTEN :1337 and peer 172.16.5.30 while window is open
nc 127.0.0.1 1337
```

**Expected on attach:** interactive bash; cwd `/opt/relay/`; `hostname` → `sync-node`; `cat princess_peach.txt` → `THANK YOU MARIO! YOUR QUEST IS NOW OVER.`; Ctrl+C does not kill the listener; disconnect and `nc` again reconnects. **How students know the port:** discovery from `ss`, not the brief. **How they know peer `.30`:** connection evidence on the relay after the hit — never published as a login target.

## Troubleshooting / confirmation

|Symptom|Check|
|---|---|
|No outbox movement|Snapshot not restored; HarvestIndex stopped; pull key; mail-process|
|Poison only in `dropped`|Wrong extension; re-read `KEEP_EXT`|
|Students disable worker|Fail deceive criteria; restore task|
|Ask for sync-node login|Deny direct SSH; if keyword bait was used, coach `ss` / `nc` on mail-relay|
|No `:1337` after bait|Keyword never reached curated zip; `id_stage.pub` not on reviewer; window expired; actor-keyword-react logs under `/opt/relay/state/`|

## Grading checkpoints

| Deliverable           | Acceptable                                                     |
| --------------------- | -------------------------------------------------------------- |
| Filter map            | States keep extensions and at least one sidecar field          |
| Poison inventory      | ≥2 patterns; each tied to filter reasoning                     |
| Before/after evidence | Poison in outbox/sidecar; legitimate tick continues            |
| Five-line report      | `deceive` or `manipulate`; payloads logged                     |
| Discipline            | Pipeline not primary-killed; direct sync-node SSH not required |
| Stretch (optional)    | Keyword bait → `nc` attach → peach token / sync-node hostname  |