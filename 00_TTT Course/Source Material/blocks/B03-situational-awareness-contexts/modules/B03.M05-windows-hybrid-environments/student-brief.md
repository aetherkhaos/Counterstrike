---
id: B03.M05.student-handout
title: Emu and Ewe Student Brief
artifact_type: student_brief
audience: student
block: B03
module_type: lab
legacy_aliases:
- week3_repo/docs/student-handout-module-4.md
- legacy/week3/labs/L3.5_Windows_and_Hybrid_Environments
- B04.M16
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
# Emu and Ewe Student Brief

## Objective

This module develops evidence-first operations in Windows and mixed-interface environments. Students should establish context quickly, determine host function from artifacts, operate under execution constraints, and validate both workflow outcomes and cleanup actions.

## Context

You will complete two hybrid-environment labs that require Windows-native evidence collection, constrained workflow execution, and context transitions across mixed interfaces. Prioritize observable host artifacts over assumptions.

## Constraints

- Begin with native tooling and host evidence before custom scripts/binaries.
- Follow required workflow/path sequencing when challenges enforce specific execution routes.
- For cleanup objectives, target only discovered artifacts tied to challenge activity.
- Puppet scripts and simspace accounts are range management tools, they are out of scope for this exercise.

## Tasks

### Windows Operations Orientation (Five Challenges)

### Environment

A Windows Server environment is provided with Defender and UAC enabled. Student access is provided as `badguy` over WinRM using `evil-winrm` (TCP 5985) unless your range card provides rotated credentials.

Expected flags: 5.

### Access

| Hostname (expected) | IP address  | Username | Password             | Connection                         |
| ------------------- | ----------- | -------- | -------------------- | ---------------------------------- |
| `emu-41`            | 20.30.40.41 | `badguy` | `1qaz2wsx!QAZ@WSX`   | `evil-winrm` / WinRM (TCP 5985)    |

From the ops station:

```bash
evil-winrm -i 20.30.40.41 -u badguy -p '1qaz2wsx!QAZ@WSX'
```

Default values are for initial access only. If your instructor or range card provides different host, credential, or port values, use those assigned values. After connecting, confirm host and session context with commands such as `hostname`, `whoami`, and `Get-Location`; challenge-specific paths, workflow rules, and flag evidence must be discovered from target artifacts.

### Tasks

Use built-in Windows tools first (`Get-ChildItem`, `Get-Content`, `Get-Service`, `Get-ScheduledTask`, `schtasks`, `whoami`, `icacls`, `wevtutil`, `Select-String`). Custom script/binary use is permitted only where a challenge requires it.

Begin with a situational-awareness baseline that includes Defender and UAC posture before challenge-specific hunting.

1. **Challenge 1 - Secret discovery:** identify the currently valid operational secret among decoy values and recover the associated flag.
2. **Challenge 2 - System function determination:** establish the host's true operational role using correlated evidence from at least two artifact types.
3. **Challenge 3 - Constrained custom execution:** discover and use the host wrapper flow to execute a student PowerShell payload through the required path.
4. **Challenge 4 - Infiltration/exfiltration workflow:** place an inbound artifact into the host workflow and recover the resulting outbound artifact.
5. **Challenge 5 - IOC reduction with verification:** clean residue created by your earlier challenge work (session/execution log lines, leftover approved-bin payload, processed-transfer metadata, and flag-bearing workflow outputs after you have recorded those flags), then run the host verification script under `tasks` and confirm post-cleanup status.

#### Clues and constraints

- After baseline SA, use environment clues such as `ALLUSERSPROFILE` / `ProgramData` to find non-default operational directories before guessing flag files.
- Review Defender/UAC posture for context. If exclusion paths are present, they may corroborate an operational root; if Antimalware is off or exclusions are empty, continue with ProgramData enumeration.
- Challenge 1: distinguish currently valid secrets from stale/decoy values using state evidence, not the first credential-like string you find.
- Challenge 2: correlate at least two independent artifact types (for example task, service, config, or report). Do not trust a single benign service or display-name label.
- Challenge 3: host documentation names the wrapper and allowed execution path after you discover those artifacts; wrong paths prevent objective completion. Successful wrapper use leaves execution/session residue you will need later.
- Challenge 4: inbound naming rules are strict (pattern documented on the host); incorrect names do not process. Successful transfer processing leaves processed-file and outbound residue you will need later.
- Challenge outcomes commonly create or reveal follow-on flag files that must be located.
- Challenge 5: cleanup targets are residue from Challenges 2–4 (logs, leftover payload, processed-transfer metadata, flag-bearing outputs). Discover those from host evidence tied to your prior actions; do not use broad destructive deletion.

#### Report and submission

For each challenge, submit: (1) recovered flag, (2) one to two key commands, and (3) a brief evidence-validity explanation. Ensure final reporting includes:
- Challenge 1: valid-secret source and flag.
- Challenge 2: system-function conclusion, evidence chain, and flag.
- Challenge 3: constrained execution method and flag.
- Challenge 4: ingress evidence, egress evidence, and flag.
- Challenge 5: cleanup evidence for required action types plus final flag.

### Through the Looking Glass (Split-Port Hybrid)

### Environment

A shell-like interface is exposed over two sequential TCP ports on one host. Session setup and lane attribution are part of the assessment.

Expected flags: 4.

### Access

| Hostname (expected) | IP address  | Username | Password | Connection                                                                                   |
| ------------------- | ----------- | -------- | -------- | -------------------------------------------------------------------------------------------- |
| `ewe-42`            | 20.30.40.42 | N/A      | N/A      | Two manual TCP sessions: TCP 4420 lower input lane first, then TCP 4421 higher output/error lane |

Default split-port values are `4420` for command input and `4421` for output/error. Keep both sessions open, send commands through the lower port, and read stdout/stderr from the higher port. If your range card provides a different sequential port pair, use the assigned lower port first and higher port second. After both lanes are connected, establish shell context with commands such as `hostname`, `whoami`, `pwd`, and `id`; environment type and objective details must be proven from target evidence.

### Tasks

1. Establish dual-port session wiring by connecting lower port first (input lane) and higher port second (output/error lane).
2. Prove I/O attribution with command evidence that distinguishes stdout and stderr lane behavior.
3. Determine underlying environment type from host artifacts and complete required hint-based retrieval steps.
4. Recover hidden data objective content from a discovered inventory artifact. If ordinary file content does not fully explain the objective, carefully review file-system attributes and metadata for clues about hidden data.
5. Transition from the initial shell context into native Windows command execution, validate elevated Windows identity and access-control evidence, and recover the restricted-context flag.

#### Clues and constraints

- Standard terminal tools (`nc`, `ncat`, `socat`, or equivalent) are expected for initial session handling.
- No wrapper is provided for initial access; connection sequencing is part of objective validation.
- Environment identification must be artifact-driven, not assumption-based.
- Treat the assigned host and port pair as access information. Treat files, directories, stream names, and privilege requirements as facts to discover from the target.
- Begin broad: record time, host, user, current directory, shell/process context, operating-system evidence, and listening/established sockets before narrowing to challenge artifacts.
- When a challenge points to hidden data, inspect the ordinary file content first, then review file-system attributes and metadata before deciding how to retrieve it.
- Before reading restricted artifacts, collect identity, group/privilege, directory listing, and ACL evidence showing why your current context satisfies the required access level.

#### Report and submission

For each challenge, submit: (1) recovered flag, (2) one to three key commands, and (3) a brief evidence-validity explanation. Ensure final reporting includes:
- Challenge 1: I/O attribution proof and flag.
- Challenge 2: environment conclusion, evidence chain, and flag.
- Challenge 3: hidden-data recovery evidence and flag.
- Challenge 4: transition/elevated Windows-context evidence and flag.

## Deliverables / Evidence

- Submit all flags from Windows Operations Orientation and Through the Looking Glass with one to three key commands/actions per objective.
- Provide evidence validity notes for secret discovery, role determination, constrained execution, workflow transfer, and cleanup verification.
- Include transition evidence for split-port I/O attribution and elevated Windows-context validation.

## Success Criteria

You successfully complete this Module when challenge outcomes are recovered with validated evidence, required workflow constraints are respected, and mixed-interface transitions are explained clearly.
