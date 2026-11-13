---
id: B04.M21-key
title: Poison Harvest Collection — Instructor Answer Key
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

# Poison Harvest Collection — Instructor Answer Key

## Objective and starting context

Pipeline restored after M20. Students are **issued** mail-relay (`access_key`) and file-index (`svc.harvest` / `Harvest!Relay01` @ `172.16.4.20`). They learn triage filters from `harvest_worker.py` / outbox JSON, plant deceive/manipulate poison that survives keep rules, and prove the pipeline still ticks. Direct sync-node SSH is denied; grade primary success on outbox/sidecar evidence. Keyword bait → reverse-shell attach is stretch/bonus.

Range: `environments/b04_temp_harvest_cell/README.md`.

## Flag / reference table

| Item | Source | Default |
| --- | --- | --- |
| Intake | Handoff | `relay@172.16.2.10:2222` |
| Indexer | Handoff | `svc.harvest` / `Harvest!Relay01` @ `172.16.4.20` |
| Keep filter | `harvest_worker.py` | `KEEP_EXT = {".docx", ".xlsx", ".pdf", ".pptx", ".doc", ".xls"}` |
| Outbox | Windows | `C:\ProgramData\Harvest\outbox\*_curated.zip` + `.json` |
| Sidecar fields | Worker | `kept`, `dropped`, `sha256`, `note`, `source_enc`, ... |
| Keyword selectors | Handoff terms | `blackstart`, `islanding`, `N-1` (in curated zip / JSON) |
| Priority reverse shell | Instructor | mail-relay `nc 127.0.0.1 1337` → sync-node bash cwd `/opt/relay/` (~30 min) |
| Landing clue | `/opt/relay/princess_peach.txt` | `THANK YOU MARIO! YOUR QUEST IS NOW OVER.` |
| Victim / actor | Instructor only | `172.16.1.2` / `172.16.5.30` — no direct student SSH |

## Initial situational awareness

Both seats after login:

```bash
# mail-relay
hostname && whoami && pwd
ls -la /srv/relay/incoming /srv/relay/pickup
```

```powershell
# file-index
hostname; whoami; pwd
Get-ChildItem C:\ProgramData\Harvest -Recurse | Select-Object -First 40
Get-ScheduledTask -TaskName HarvestIndex
```

**Why this matters:** Poison requires a live indexer seat and a ticking worker; break leftovers from M20 must be rolled back first.

## Instructor live walkthrough

### 1. Confirm issued Windows seat

```bash
ssh svc.harvest@172.16.4.20
```

Password from brief: `Harvest!Relay01`. **How students know:** M21 handoff states it (unlike M20).

### 2. Learn filter parameters

```powershell
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

| Pattern | How | Evidence |
| --- | --- | --- |
| Office honey via victim share / mail path | Place `.docx`/`.xlsx`/`.pdf` named for false attribution into a path that re-enters SMTP→pickup (instructor may allow planting into a staging zip students can encrypt if they earned that skill) | Appears under sidecar `kept` |
| Direct outbox/sidecar shape | Edit or plant a curated zip + JSON that an actor would pull | New outbox objects with misleading `kept` names/notes |
| Inbox plant + wait for worker | Drop keep-extension objects where worker will re-package if design supports | New curated package |

Accept either path if the report shows filter-aware design and pipeline-up proof. Prefer filter study before plant.

Pre-execution: if students run custom scripts, have them print usage/`Get-Help` equivalent and sanity-check paths first.

### Instructor concepts (not issued to students)

Coaching / grading reference only — how `deceive` / `manipulate` (ENGAGE Affect) might be done given that **sync-node only sees post-triage product** (`KEEP_EXT` curated zip + JSON sidecar). Anything that never reaches `kept` / outbox fails poison intent. Students invent their own path; do not hand this list out.

| Concept | How it might be done | Why it fits post-parse |
| --- | --- | --- |
| Keep-ext honey content | Plant `.docx` / `.xlsx` / `.pdf` (etc.) with false narrative (attribution, timelines, fake decisions) | Lands in sidecar `kept` and inside the curated zip the actor pulls |
| Name-shape for trust | Use office-like names that look like high-value weekly product | Survives keep filter and biases human review of the package |
| Sidecar / metadata deceive | After a live tick, edit or plant JSON (`kept` names, `note`, provenance fields) | Actor may trust sidecar without opening every blob |
| Curated-zip swap / augment | Replace or add keep-ext members in outbox `*_curated.zip` while tasks stay running | Directly shapes what actor-collect drinks |
| Dilution | Flood many keep-ext decoys so real victim take is buried in volume | Pipeline still ticks; attention / priority is manipulated |
| Selective filter manipulate | Temporarily shrink `KEEP_EXT` so only planted types admit (higher burn; near-degrade) | Worker still “ticks,” but real classes never reach the actor |

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

```bash
# baseline then delta after bait cycle
ss -lntp
ss -tnp
# expect new loopback LISTEN :1337 and peer 172.16.5.30 while window is open
nc 127.0.0.1 1337
```

**Expected on attach:** interactive bash; cwd `/opt/relay/`; `hostname` → `sync-node`; `cat princess_peach.txt` → `THANK YOU MARIO! YOUR QUEST IS NOW OVER.`; Ctrl+C does not kill the listener; disconnect and `nc` again reconnects. **How students know the port:** discovery from `ss`, not the brief. **How they know peer `.30`:** connection evidence on the relay after the hit — never published as a login target.

## Troubleshooting / confirmation

| Symptom | Check |
| --- | --- |
| No outbox movement | Snapshot not restored; HarvestIndex stopped; pull key; mail-process |
| Poison only in `dropped` | Wrong extension; re-read `KEEP_EXT` |
| Students disable worker | Fail deceive criteria; restore task |
| Ask for sync-node login | Deny direct SSH; if keyword bait was used, coach `ss` / `nc` on mail-relay |
| No `:1337` after bait | Keyword never reached curated zip; `id_stage.pub` not on reviewer; window expired; actor-keyword-react logs under `/opt/relay/state/` |

## Grading checkpoints

| Deliverable | Acceptable |
| --- | --- |
| Filter map | States keep extensions and at least one sidecar field |
| Poison inventory | ≥2 patterns; each tied to filter reasoning |
| Before/after evidence | Poison in outbox/sidecar; legitimate tick continues |
| Five-line report | `deceive` or `manipulate`; payloads logged |
| Discipline | Pipeline not primary-killed; direct sync-node SSH not required |
| Stretch (optional) | Keyword bait → `nc` attach → peach token / sync-node hostname |
