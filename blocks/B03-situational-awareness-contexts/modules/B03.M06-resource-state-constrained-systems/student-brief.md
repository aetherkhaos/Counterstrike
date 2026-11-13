---
id: B03.M06.student-handout
title: Ferret and Fowl Student Brief
artifact_type: student_brief
audience: student
block: B03
module_type: lab
legacy_aliases:
- week3_repo/docs/student-handout-module-5.md
- legacy/week3/labs/L3.6_Resource_and_State-Constrained_Systems
- B04.M17
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---
# Ferret and Fowl Student Brief

## Objective

This module develops adaptive enumeration in environments with resource starvation and frequent state resets. Students should maintain evidence quality while operating under unstable execution conditions and strict time pressure.

## Context

You will work in low-resource and reset-prone systems where timing and adaptation matter. Use disciplined prioritization to collect high-value evidence quickly and maintain traceable flag-recovery chains under unstable conditions.

## Constraints

- Prioritize high-yield evidence first in unstable or reset-prone sessions.
- Keep telemetry segments from a single reboot cycle for composite reconstruction.
- Capture at least one failed/interrupted attempt and the adaptation used to recover.
- Puppet scripts and simspace accounts are range management tools, they are out of scope for this exercise.

## Tasks

### The Starving System (Low Resources)

### Environment

A low-resource VM is provided (for example 128-256 MB RAM and/or one vCPU). Student access is through an intentionally constrained shell listener, and command execution may fail intermittently.

Expected flags: 6.

### Access


| Hostname (expected) | IP address  | Username | Password | Connection              |
| ------------------- | ----------- | -------- | -------- | ----------------------- |
| `ferret-51`         | 20.30.40.51 | N/A      | N/A      | Netcat shell (TCP 2222) |


### Tasks

1. Establish constrained-session context and validate unstable execution behavior.
2. Recover all six lab flags from native host evidence categories: process/schedule, logs, user/account, port/service, configuration, and encrypted relay analysis.
3. For the encrypted relay objective, discover the correct decryption key from native host evidence, decrypt the large artifact, and recover the flag from plaintext.
4. Record the evidence path for each flag and include at least one adaptation example from a failed/interrupted attempts.

#### Clues and constraints

- One flag is tied to scheduled execution behavior rather than always-on process state.
- One flag is tied to an operations-style log entry related to transient failure/recovery; follow maintenance/scheduler naming from cron into `/var/log` rather than searching blindly.
- One flag is associated with a non-login account and related home/user artifacts.
- One flag can be inferred from standard SSH service metadata on port `22`.
- One flag is in a small runtime configuration containing recovery-oriented key/value settings.
- One flag requires decrypting a large encrypted relay artifact; the matching key material is discoverable from normal host-side operational artifacts.

#### Report and submission

Submit all six recovered flags, the exact evidence source for each, and a short explanation of how you adapted to unreliable execution and memory pressure. Follow instructor assessment criteria for final format.

### The Unstable System (Frequent Resets)

### Environment

The host resets frequently and powers off without warning. Each reboot changes the SSH port. This lab uses the same five evidence categories as Boar and Bull and Ferret and Fowl, but requires rapid recovery under reboot pressure.

Expected flags: 6 total, including five primary flags and one composite bonus flag.

### Access


| Hostname (expected) | IP address  | Username | Password         | Connection                    |
| ------------------- | ----------- | -------- | ---------------- | ----------------------------- |
| `fowl-52`           | 20.30.40.52 | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 2200-2299, rotating) |


### Tasks

1. Scan TCP ports 2200-2299 to identify the current SSH listener before each session.
2. Connect and prioritize high-yield evidence collection before the next reset.
3. Recover all five primary flags from process/schedule, log, user/account, port/service, and configuration evidence.
4. Collect telemetry segments 1 through 5 from the same reboot cycle.
5. Reconstruct the composite bonus flag from the five ordered segments.

#### Clues and constraints

- Each primary flag source includes the flag value and a telemetry line (for example `telemetry segment N of 5: <base64 data>`).
- All five telemetry segments must come from the same boot cycle; mixed-cycle segments produce corrupt output.
- Discovery methodology is consistent with Boar and Bull and Ferret and Fowl, but artifact locations and formats differ.
- Runtime bootstrap metadata may reference encrypted-secret inputs, but flags are recovered from native process/log/user/port/config evidence artifacts.
- Battery/failure narrative signals are operationally relevant and should guide prioritization.

#### Report and submission

Submit all five primary flags, the reconstructed composite flag, the evidence source for each, and a brief explanation of time-management strategy under reset pressure.

### Composite reconstruction reference

```bash
# 1) Concatenate segments 1 through 5 in order with no separators.
FULL="<segment1><segment2><segment3><segment4><segment5>"
# 2) Decode and decompress.
echo "$FULL" | base64 -d | gunzip
# 3) Output contains the composite flag value.
```

## Deliverables / Evidence

- Submit six flags for The Starving System and six outcomes for The Unstable System (five primary plus composite), with exact evidence source for each.
- Include adaptation evidence for unstable execution and reset pressure.
- Document the ordered reconstruction process used for the composite objective.

## Success Criteria

You successfully complete this Module when all objectives are recovered under resource/reset pressure with traceable evidence, timing discipline, and correct composite reconstruction.
