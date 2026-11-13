---
id: B04.M23-ig
title: Partner Handoff Package — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# Partner Handoff Package — Instructor Guide

## Objective and context

Temporary **M11-shaped** placeholder. Students continue the live harvest cell after break/poison work. Commander framing: other effects remain under consideration; **execution is on hold** (political). Grade the six-section Access Guide package, access accuracy, back-brief, and one **staged** C2 beacon. Students choose the host among seats they already hold and explain why that host is the right place for a beacon. The package must let a cold partner start, task, and remove that beacon. A live check-in is not required and is not graded. **Do not** run the partner RAT / implant path from archived [B04.M11](../../archive/B04.M11-handoff-partner-rat-deploy/). This Module replaces that lab on the sequence. Do not pick the beacon host for them.

Walkthrough / grading checklist: [`answer-key.md`](./answer-key.md). Range: [`../../../../environments/b04_temp_harvest_cell/README.md`](../../../../environments/b04_temp_harvest_cell/README.md).

## Dual opening

### Option 1 (Interactive / Whiteboard)

- **Say:** "Other effects are on hold. Your product is a partner handoff package — access path, posture, tempo, tasking, rollback — plus one C2 beacon staged on a host you already hold. Explain why that host. Leave every file a partner needs to run and task it. No other fires today. A check-in is not required."
- **Do:** Confirm briefs list `172.16.2.10` and `172.16.4.20`. Confirm the cell was **not** snapshot-reset after poison work unless a team bricked a seat.
- **Ask (Q):** What is authorized today?
- **Expected Response (A):** Information `handoff` plus one staged beacon on a host they already hold. Document recommended effects but do not execute them. A live check-in is not required.

### Option 2 (Slide)

- **Say:** Same as Option 1.
- **Show:** Six Access Guide sections from the student brief, plus the beacon host, rationale, and partner-usable kit.
- **Do:** Confirm Moodle `access_key` still valid.
- **Ask (Q):** What is authorized today?
- **Expected Response (A):** Information `handoff` plus one staged beacon on a host they already hold. Document recommended effects but do not execute them. A live check-in is not required.

## Instructor resources and pre-class

1. Harvest cell still reachable from prior sessions (no routine reset between poison and this handoff).
2. Issue / confirm Moodle `access_key` and Windows `svc.harvest` / `Harvest!Relay01` for teams that still need the indexer seat.
3. Do not stage a course beacon, partner RAT binary, or callback listener. Students bring a beacon they can generate and place it themselves.

## Facilitation flow

### Step 1: Hold contract (5 min)

- **Say:** "Political hold on other effects. Package for Partner Bravo (or your partner designation), including one staged beacon and everything needed to use it. Five-minute back-brief at the end."
- **Ask (Q):** When may you execute a new effect?
- **Expected Response (A):** Only with explicit verbal go from the instructor as Mission Commander. Staging one beacon on a host they already hold is the authorized exception. A live check-in is not required.

### Step 2: Re-enter and document (35 min)

- **Say:** "Prove every seat you claim. Fill all six sections. Stage one beacon on a host you already hold and say why that host. Leave the file and the kit a partner needs to start, task, and remove it. Vague posture or a generic host reason fails."
- **Do:** Nudge incomplete access stories (key path, port, user, how leftover was found if used) and incomplete beacon kits (binary, config, listener or callback, path, account, start, task, removal). Do not pick the host. Do not hand PrintNightmare or sync-node paths. Do not require a check-in.
- **Ask (Q):** What must a cold partner have to re-enter and use the beacon without you?
- **Expected Response (A):** Exact access story, current posture, rollback, the beacon host and why it was chosen, and every file and fact needed to start, task, and remove that beacon.

### Step 3: Back-brief and collect (15 min)

- **Say:** "Five minutes. Six sections plus the beacon you left behind. Then stop — stack belongs to the partner narrative."
- **Do:** Grade from the answer-key checklist. Fail teams that executed new effects without a go, staged more than one beacon, or omitted the files a partner needs to use the beacon. Do not fail a missing check-in.

## Timing

About 60 minutes. Protect the hold on other effects, the single staged beacon, and foothold preservation.

## Common stalls

- Writing "SSH to the box" without port/key/user detail.
- Listing effects they wish they had run instead of live posture.
- Asking which host to use for the beacon — they choose among seats they already hold; require a specific reason. Do not pick it.
- Staging the beacon with no binary, config, listener, path, account, start steps, or tasking steps — the package is not usable.
- Asking to deploy a second implant or to run the partner RAT path — one staged beacon only; redirect extra fires back to the hold.
- Asking for sync-node or unpublished hosts — deny.

## Lesson summary

Information handoff under a political pause is still an effect category. Incomplete packages force rediscovery; a beacon without the files to use it is not a handoff. Complete packages preserve continuity.

## Questions and check on learning

- **Ask (Q):** Name the six Access Guide sections, and what else the package must contain for the beacon.
- **Expected Response (A):** Target identity; access story; current posture; adversary tempo; partner tasking; rollback plan. Also the beacon host and why it was chosen, plus binary, config, listener or callback, path, account, start steps, tasking steps, and removal. A live check-in is not required.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Answer key: [`answer-key.md`](./answer-key.md)
