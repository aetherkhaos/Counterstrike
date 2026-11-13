---
id: B01.M08-delivery
title: EAC0014 Runspace Debugging — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B01
module_type: demo
source_status: draft
review_required: true
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# EAC0014 Runspace Debugging — Delivery requirements

## Equipment and bandwidth deltas
What this Module adds beyond the Course baseline in
`course/requirements/equipment-recommendations.md`.

```yaml
equipment:
- item: Windows victim with PowerShell 5.1+ and local administrator
  delta: Enter-PSHostProcess defender session; not a Course ops-station VM
  applicability: required
- item: Instructor Empire / Starkiller compose kit
  delta: Module lab_env under B01.M08-runspace-debugging
  applicability: required
```

## Personnel

```yaml
personnel:
- role: instructor
  count: 1
  ratio: '20:1'
  qualifications: []
  applicability: required
- role: range_engineer
  count: 1
  applicability: conditional
  applicability_reason: Required when this Module's environment needs a range engineer
- role: auditor
  count: 0
  applicability: not_applicable
  applicability_reason: Not used by this course
- role: oversight_officer
  count: 0
  applicability: not_applicable
  applicability_reason: Not used by this course
```

Instructors who already hold a listed qualification count toward that role.

## Delivery duration
Instructional length for this Module. The delivery schedule renderer
uses `duration_minutes` for calendar block size. Edit this value here,
not in `delivery-schedule.md`.

```yaml
delivery:
  duration_minutes: 60
  duration_notes: Filled from delivery-schedule ingest
```

## PCTE range
Range consumption beyond Course ops-station VMs. Portal names live in
`course/operations/pcte-range-specifications.md`. Local instructor kit today;
PCTE when fielded.

```yaml
pcte:
  stack_refs:
  - stack_id: b01-runspace-demo
    applicability: conditional
```

## Artifact applicability

| Family | State | Reason / owner |
| --- | --- | --- |
| Lecture content guide / decks / lesson plan | not_applicable | not a lecture Module |
| Homework | not_applicable | module_type is demo |
| Student brief | not_applicable | instructor-operated demo; students observe |
| Student guide | not_applicable | not a student-guide Module |
| Instructor guide | required | facilitation / live walkthrough |
| Answer key | not_applicable | not graded |
| Quiz | not_applicable | no quiz |
| Rubric | not_applicable | no rubric |
| Setup guide | conditional | prep lives in Module `lab_env/` |
| Verification runbook | conditional | required when a canonical setup guide exists |
| Work aid | not_applicable | optional |

## Instructor pre-class

Compose, offline image load, and Defender detail live in
[`PowerShell Runspace Debugging/lab_env/README.md`](PowerShell%20Runspace%20Debugging/lab_env/README.md).
Live walkthrough: [`RunspaceDebugging.md`](RunspaceDebugging.md).

### Starkiller — listener, stager, beacon

1. On the ops station, open Starkiller at **`https://127.0.0.1:1337`** (or `http://127.0.0.1:1337` if HTTPS never loads). Accept the self-signed cert.
2. **Clipboard rule:** do not open Starkiller via the LAN or ops-station IP. The UI will not copy the stager one-liner to the clipboard unless the browser is on `127.0.0.1`.
3. Log in: `empireadmin` / `password123`.
4. Create HTTP listener `http-demo`:
   - **Host** = IP the **Windows victim** can reach (not `127.0.0.1`; Compose does not inject `LISTENER_HOST` from `.env`).
   - **Port** = `8080` (or `LISTENER_PORT`).
   - Bind `0.0.0.0`.
5. **Stagers → multi/launcher → Language: powershell → Listener: http-demo → Generate.** Copy the one-liner (works because the browser is on loopback).
6. Run that one-liner on the Windows victim. Confirm the **agent/beacon** checks in and `shell whoami` is honest before class.

If the callback IP was wrong, kill/recreate `http-demo` and generate a **new** stager. Old launchers still have the old Host.

### Windows victim — Defender and Window A

If Defender realtime is on, turn it **off** for this demo so the stager survives. Check and disable steps are in the lab_env README.

**Window A** (Part 1 script; run during the live demo, not before class), after copying files to `Desktop\Runspace-Demo`:

```text
cd Desktop\Runspace-Demo
powershell.exe -ExecutionPolicy Bypass -File .\RunspaceDebugging.ps1
```
