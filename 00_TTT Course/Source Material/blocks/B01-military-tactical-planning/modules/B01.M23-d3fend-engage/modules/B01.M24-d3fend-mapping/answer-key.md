---
id: B01.M24-key
title: D3FEND Mapping — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B01
module_type: group_activity
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# D3FEND Mapping — Instructor Answer Key

## Objective and starting context

Teams map already-chosen ATT&CK techniques to D3FEND. Source: parent content guide slide 2 and the student-deck worksheet. The deck pre-fills some attack labels and, on the later option slide, some D3 codes. Those codes are starters. The live matrix is the authority. The companion mapping poster has garbled captions and is not this key.

## Expected product

For each technique, one or more D3FEND techniques the team can open on the matrix, plus whether each option is feasible in the terrain they actually have.

## Acceptable answers

Grade the lookup, not a single code.

- Email `.lnk` delivery. If the team corrected the technique to T1566.001, accept inbound-content or user-execution countermeasures they can show on the matrix. If they keep the deck's T1091 removable-media label, accept only a defense they can defend for removable media, and tell them the email log does not support that technique. The deck's starter string `D3-HCI D3-IOPR D3-PFV` is a menu, not proof.
- `mshta` or web protocol. The deck leaves the defend cell blank on one slide and does not lock a code. Accept a matrix technique aimed at the script host or at the web protocol, with a feasibility note.
- PowerShell `Invoke-Expression`. The deck starts `D3-PSA` and `D3-SEA`. Accept those when the team can say what each watches. Accept another process or script countermeasure they can open on the matrix.
- WMI disk discovery. The deck leaves the defend cell blank. Accept a discovery or script-host countermeasure tied to T1120, not a generic "more logging" line.
- Local document collection. The deck starts `D3-FPA`. Accept it when they tie file-access patterns to the staging directory. Accept another file-access countermeasure they can show.

One-to-many is normal. A mapping is not yet a commander's decision.

## Grading checkpoints

- Accept: a code or name the team can point to, plus a feasibility sentence.
- Do not accept: a code copied from the poster or the starter cell that they cannot explain.
