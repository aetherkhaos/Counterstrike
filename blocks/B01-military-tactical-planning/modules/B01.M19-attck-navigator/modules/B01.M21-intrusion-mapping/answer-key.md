---
id: B01.M21-key
title: Intrusion Mapping — Instructor Answer Key
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

# Intrusion Mapping — Instructor Answer Key

## Objective and starting context

Teams map five logs and justify each technique. The log text is on the student deck and in the parent content guide. The deck's first data row shows `T1092` with the justification "it looked like it." That row is the weak example, not the key. A later D3FEND slide labels the same email log `T1091`. That label does not match an email-gateway fact. Technique calls below are generated from the log text.

## Expected product

A Navigator layer and a table: observed fact and source, behavior, technique or sub-technique, confidence, and a competing interpretation.

## Acceptable answers

- Email with a `.lnk` attachment: T1566.001 Spearphishing Attachment. Competing: T1204.002 User Execution: Malicious File, if they separate delivery from execution. Do not accept T1091 or T1092 for this log. Those are removable-media behaviors, and log 4 is where removable media shows up.
- `mshta.exe` executing a URL on a `.ru` domain: T1218.005 Mshta. T1071.001 Web Protocols is acceptable when the justification is the protocol, not the signed binary. The deck uses T1071.001 as a later starter; accept it only with that reason.
- PowerShell with `Invoke-Expression` and Base64: T1059.001 PowerShell. T1027 or a decode technique may sit beside it. It does not replace T1059.001.
- `PteroLNK.vbs` querying WMI for disks whose mediatype is null: T1120 Peripheral Device Discovery. The deck's later table agrees. T1047 Windows Management Instrumentation is the mechanism, not the discovery behavior.
- `PteroPSDoor.ps1` reading office documents and writing them under `%LOCALAPPDATA%\vector`: T1005 Data from Local System. Add T1074.001 Local Data Staging when they cite the staging directory. The deck's later table uses T1005.

"It looked like it" fails the row even if the technique number is lucky.

## Grading checkpoints

- Accept: fact, behavior, technique, and confidence on every row.
- Do not accept: a layer with no justification table, or removable-media techniques on the email log.
