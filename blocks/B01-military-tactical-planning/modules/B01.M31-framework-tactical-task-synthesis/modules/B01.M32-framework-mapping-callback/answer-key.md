---
id: B01.M32-key
title: Framework Mapping Callback — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B01
module_type: group_activity
legacy_aliases: []
source_status: derived-from-render
review_required: true
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Framework Mapping Callback — Instructor Answer Key

## Objective and starting context

This drill is the tactical-task column on the synthesis table. Source: the task lists and the blank cells on the synthesis deck. The verbs below are generated acceptable fills, not a single official answer.

## Expected product

One tactical task for the attack, one for the defend option, and one for the engage option, on at least the rows the team briefs.

## Acceptable answers

Five-log table, attack column:

- Email attachment or removable-media execution: Reconnoiter is weak; Exploit is acceptable when they mean gaining access. A collection-oriented read of later logs is not this row.
- Web or `mshta` command path: Exploit, or Interdict only if they are describing their own later action. Do not accept Attack by Fire as a synonym for HTTP.
- PowerShell: Exploit is acceptable for the adversary. Degrade or Disrupt is the defend or engage task, not the attack task.
- Disk discovery: Reconnoiter.
- Local document read and stage: Exploit, or a collection purpose stated as the enemy's task. Deny is a friendly task on this row, not the adversary's.

Defend column, using the deck's starters where it printed them:

- Host and file controls (`D3-HCI`, `D3-IOPR`, `D3-PFV`, `D3-FPA`): Protect or Screen.
- Script analysis (`D3-PSA`, `D3-SEA`): a friendly reconnoiter of the endpoint, or Protect if they are blocking execution. Ask which.

Engage column:

- EAC0005 lures: Deceive. Influence is acceptable when they explain the cost-value change.
- EAC0016 network manipulation: Disrupt or Degrade.
- EAC0014 software manipulation: Degrade or Deceive, matching whether they mislead output or just slow the script.
- Isolation onto a decoy subnet: Fix or Contain. Canalize is acceptable when the point is to leave one path open.

A blank with the reason "this task does not translate" is acceptable when they say why.

## Grading checkpoints

- Accept: the task matches the side of the row (adversary, defense, or engagement).
- Do not accept: the same verb pasted into every cell.
