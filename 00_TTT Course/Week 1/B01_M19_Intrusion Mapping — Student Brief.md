## Objective

Map five observed logs to ATT&CK and justify each choice.

## Context

Use ATT&CK Navigator. For each log, record the technique and a justification that names the observed fact.

1. Email gateway: an email arrives with a `.lnk` attachment.
2. Sysmon Event 1: `mshta.exe` executes a URL on a `.ru` domain.
3. Sysmon Event 1: `powershell.exe` runs a command with `Invoke-Expression` and Base64.
4. EDR: `PteroLNK.vbs` queries WMI for `win32_logicaldisk` where mediatype is null.
5. File audit: `PteroPSDoor.ps1` reads `.docx`, `.xlsx`, and `.pdf` files and writes them under `%LOCALAPPDATA%\vector`.

## Tasks

1. Build a Navigator layer for these logs.
2. For each technique state the observed fact and source, the behavior, the technique or sub-technique, and your confidence including a competing interpretation.

## Deliverables / Evidence

An exported Navigator layer and a justification table.

## Constraints

"It looked like it" is not a justification. Do not jump to a defensive action.

## Success Criteria

Every row cites a log, names a technique the log can support, and states confidence.