---
id: B04.M21-ig
title: Poison Harvest Collection — Instructor Guide
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

# Poison Harvest Collection — Instructor Guide

## Objective and context

Temporary **M08-shaped** placeholder on the harvest cell. Restore the pipeline after M20 break demos. **Issue** file-index access (`svc.harvest` / `Harvest!Relay01` @ `172.16.4.20`). Students learn triage/`KEEP_EXT` filter parameters, then poison take while keeping collection running. Direct sync-node SSH stays denied; keyword-bait reverse-shell attach from mail-relay is optional stretch. The retired Module is archived at [B04.M08](../../archive/B04.M08-false-information-injection/).

**Handoff intel clues (instructor only):** The M20 Blue Team Handoff planted three contextual terms — `blackstart`, `islanding`, and `N-1` — as distributed DCO observations for critical thinking. The M21 student brief only reminds teams to use prior blue reporting for credible deceptive take; it does **not** repeat those terms or require embedding them. Filter and sidecar discovery remain a sufficient path to graded success. Sync-node keyword reaction **exists**: when curated take matching those terms reaches the actor, sync-node stages a resilient reverse shell onto mail-relay loopback `:1337` (`nc` attach, no password) for ~30 min with cwd `/opt/relay/` and landing clue `princess_peach.txt`. Treat attach as **stretch/bonus** — do not spoil the port, peer IP, or peach token in the brief; coach discovery from `ss` / peer delta after a priority bait. Direct SSH to sync-node still fails.

Walkthrough: [`answer-key.md`](./answer-key.md). Shared range docs: M20 [`instructor-range-breakdown.md`](../B04.M20-break-harvest-collection/supporting-documents/instructor-range-breakdown.md) and [README](../../../../environments/b04_temp_harvest_cell/README.md).

## Dual opening

### Option 1 (Interactive / Whiteboard)

- **Say:** "Yesterday stop. Today poison. You are told how onto the indexer. Read what they keep, then plant take they will trust."
- **Do:** Confirm brief lists both IPs and Windows password. Confirm snapshots restored after M20.
- **Ask (Q):** What proves deceive instead of deny?
- **Expected Response (A):** Pipeline still moves objects; poisoned kept/outbox evidence exists.

### Option 2 (Slide)

- **Say:** Same as Option 1.
- **Show:** Tasks — filter map, plant, validate, five-line report.
- **Do:** Confirm Moodle `access_key` still valid.
- **Ask (Q):** What proves deceive instead of deny?
- **Expected Response (A):** Pipeline still moves objects; poisoned kept/outbox evidence exists.

## Instructor resources and pre-class

1. Restore harvest-cell snapshots after M20 effects ([RESET.md](../../../../environments/b04_temp_harvest_cell/RESET.md)).
2. Smoke pipeline + both student seats per [`setup-guide.md`](./setup-guide.md).
3. Issue Windows credentials in the student brief (already written). Leave sync-node unpublished.

## Facilitation flow

### Step 1: Re-enter both seats (15 min)

- **Say:** "Relay key still works. Indexer password is in the packet today."
- **Ask (Q):** Why issue Windows now instead of making them re-earn Spooler / PrintNightmare?
- **Expected Response (A):** Poison hour needs filter intel on the worker; access is no longer the skill gate.

### Step 2: Learn filters (25 min)

- **Say:** "Read `harvest_worker.py` and a real outbox JSON. Write keep vs drop and sidecar fields."
- **Do:** If stuck, ask what extensions appear under `kept` vs `dropped`.
- **Ask (Q):** Why will a `.log` honey file fail as primary poison?
- **Expected Response (A):** Keep filter drops non-office extensions from curated zip.

### Step 3: Design and plant (40 min)

- **Say:** "Two patterns minimum. Keep the pipeline up. Log every name."
- **Do:** Block teams that disable HarvestIndex "to make room" for poison.
- **Ask (Q):** Where do you place objects if you want the worker to triage them?
- **Expected Response (A):** Paths that re-enter the mail→pickup→decrypt path, or carefully shaped outbox/sidecar edits justified in the report.

### Step 4: Validate and report (25 min)

- **Say:** "Show before/after outbox or JSON. Show a legitimate tick still happening."
- **Do:** Grade filter map + poison inventory + evidence + five-line report.

## Timing

About 120 minutes. Protect pipeline-up rule.

## Common stalls

- Planting only noise extensions that always drop — push keep-list study.
- Stopping services — redirect to M20 vocabulary vs today's deceive.
- Asking for a published sync-node login — deny direct SSH; if they baited keywords, coach listener discovery on the relay instead of handing `.30`.

## Lesson summary

Filter-aware poison beats blind drops. Keep collection alive so the adversary drinks the bad take.

## Questions and check on learning

- **Ask (Q):** Name one keep-rule and one sidecar field you used.
- **Expected Response (A):** e.g. `.docx` kept; `kept`/`dropped` or `note`/`sha256` in JSON.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Setup: [`setup-guide.md`](./setup-guide.md)
- Verify: [`verification-runbook.md`](./verification-runbook.md)
- Answer key: [`answer-key.md`](./answer-key.md)
