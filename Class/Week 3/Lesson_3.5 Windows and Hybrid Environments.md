# Module 4: Windows and Hybrid Environments - Student Handout

## Objective

This module develops evidence-first operations in Windows and mixed-interface environments. Establish context quickly, determine host function from artifacts, operate under execution constraints, and validate both workflow outcomes and cleanup actions.

## Lab 4.1 - Windows Operations Orientation (Five Challenges)

### Environment

A Windows Server environment is provided with Defender and UAC enabled. Student access is provided as `badguy` over RDP or WinRM.

Expected flags: 5.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`emu-41`|`20.30.40.41`|`badguy`|`badGuy!QAZ1qaz`|RDP (TCP 3389) and/or WinRM (TCP 5985), per range setup|

### Tasks

Use built-in Windows tools first (`Get-ChildItem`, `Get-Content`, `Get-Service`, `Get-ScheduledTask`, `schtasks`, `whoami`, `icacls`, `wevtutil`, `Select-String`). Custom script/binary use is permitted only where a challenge requires it.

1. **Challenge 1 - Secret discovery:** Identify the currently valid operational secret among decoy values and recover the associated flag.
2. **Challenge 2 - System function determination:** Establish the host's true operational role using correlated evidence from at least two artifact types.
3. **Challenge 3 - Constrained custom execution:** Discover and use the host wrapper flow to execute a student PowerShell payload through the required path.
4. **Challenge 4 - Infiltration/exfiltration workflow:** Place an inbound artifact into the host workflow and recover the resulting outbound artifact.
5. **Challenge 5 - IOC reduction with verification:** Perform required cleanup actions (line removal, file removal, timestamp manipulation, and scoped flag-file cleanup) and validate post-cleanup criteria.

### Clues and Constraints

- Challenge outcomes commonly create or reveal follow-on flag files that must be located.
- Some workflow rules are strict (for example required wrapper path or inbound naming pattern); incorrect paths/patterns prevent objective completion.
- Cleanup targets must be discovered from host evidence created by prior challenge activity, not broad destructive deletion.

### Report and Submission

For each challenge, submit: (1) recovered flag, (2) one to two key commands, and (3) a brief evidence-validity explanation. Ensure final reporting includes:

- Challenge 1: valid-secret source and flag.
- Challenge 2: system-function conclusion, evidence chain, and flag.
- Challenge 3: constrained execution method and flag.
- Challenge 4: ingress evidence, egress evidence, and flag.
- Challenge 5: cleanup evidence for required action types plus final flag.

## Lab 4.2 - Through the Looking Glass (Split-Port Hybrid)

### Environment

A shell-like interface is exposed over two sequential TCP ports on one host. Session setup and lane attribution are part of the assessment.

Expected flags: 4.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`ewe-42`|`20.30.40.42`|N/A|N/A|Two manual TCP sessions: lower port first, then higher port|

### Tasks

1. Establish dual-port session wiring by connecting lower port first (input lane) and higher port second (output/error lane).
2. Prove I/O attribution with command evidence that distinguishes stdout and stderr lane behavior.
3. Determine underlying environment type from host artifacts and complete required hint-based retrieval steps.
4. Recover hidden data objective content from `inventory.dat`.
5. Transition from initial shell context into native meterpreter context, complete required elevation objective, and recover elevated-context flag.

### Clues and Constraints

- Standard terminal tools (`nc`, `ncat`, `socat`, or equivalent) are expected for initial session handling.
- No wrapper is provided for initial access; connection sequencing is part of objective validation.
- Environment identification must be artifact-driven, not assumption-based.

### Report and Submission

For each challenge, submit: (1) recovered flag, (2) one to three key commands, and (3) a brief evidence-validity explanation. Ensure final reporting includes:

- Challenge 1: I/O attribution proof and flag.
- Challenge 2: environment conclusion, evidence chain, and flag.
- Challenge 3: hidden-data recovery evidence and flag.
- Challenge 4: transition/elevated-context evidence and flag.