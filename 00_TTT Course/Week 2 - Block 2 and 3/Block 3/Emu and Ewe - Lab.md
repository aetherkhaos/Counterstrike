# Emu and Ewe Student Brief

## Objective

This module develops evidence-first operations in Windows and mixed-interface environments. Students should establish context quickly, determine host function from artifacts, operate under execution constraints, and validate both workflow outcomes and cleanup actions.

## Context

You will complete two hybrid-environment labs that require Windows-native evidence collection, constrained workflow execution, and context transitions across mixed interfaces. Prioritize observable host artifacts over assumptions.

## Tasks

### Windows Operations Orientation (Five Challenges)

### Environment

A Windows Server environment is provided with Defender and UAC enabled. Student access is provided as `badguy` over WinRM using `evil-winrm` (TCP 5985) unless your range card provides rotated credentials.

Expected flags: 5.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`emu-41`|20.30.40.41|`badguy`|`1qaz2wsx!QAZ@WSX`|`evil-winrm` / WinRM (TCP 5985)|

From the ops station:

```
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

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`ewe-42`|20.30.40.42|N/A|N/A|Two manual TCP sessions: TCP 4420 lower input lane first, then TCP 4421 higher output/error lane|

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

## Constraints

- Begin with native tooling and host evidence before custom scripts/binaries.
- Follow required workflow/path sequencing when challenges enforce specific execution routes.
- For cleanup objectives, target only discovered artifacts tied to challenge activity.

## Success Criteria

You successfully complete this Module when challenge outcomes are recovered with validated evidence, required workflow constraints are respected, and mixed-interface transitions are explained clearly.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Emu and Ewe — Instructor Answer Key

## lab 4.1 answer key

# Lab 4.1 — Windows Operations Orientation — Answer Key (Instructor Only)

Use this as a live walkthrough. Students start with Windows access as `badguy` over `evil-winrm` and must complete five independent challenges that measure practical host orientation under realistic friction.

Implementation references:

- Puppet class: `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_4_1.pp`
- Default node data: `environments/week3_repo/vms/puppet/data/nodes/lab_4_1.yaml`

## Objectives and Starting Context

- Host baseline includes UAC controls; Defender is intended when WinDefend/AM can run (exclusions then corroborate the operational root).
- Challenge 1 discovery does **not** require Defender exclusions: start from SA env `ALLUSERSPROFILE` → `ProgramData` → `WindowsTelemetry`.
- Students must locate flags while proving they can:
    - identify active secrets in noisy artifacts,
    - infer true host function from corroborated evidence,
    - execute custom tooling through constrained paths,
    - complete ingress/egress workflow actions,
    - complete multi-mode cleanup against action-derived artifacts and verify end state.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`emu-41`|20.30.40.41|`badguy`|`1qaz2wsx!QAZ@WSX`|`evil-winrm` / WinRM (TCP 5985)|

If the instructor or range card provides a different login, use those assigned values.

## Target Access Enablement

- Environment type: Windows Server lab VM with UAC enabled; Defender/WinDefend enabled when the range allows (optional exclusion corroboration).
- Offline Defender validation after Puppet: `Get-MpComputerStatus` should show AM/RTP when healthy; `Get-MpPreference | Select-Object -ExpandProperty ExclusionPath` should include `C:\ProgramData\WindowsTelemetry\approved-bin`. If AM stays False, Challenge 1 still proceeds via ProgramData.
- Primary student entry method: `evil-winrm` (interactive WinRM shell) to TCP 5985.
- Fallback methods: none for the default demo. Use RDP (TCP 3389) only if the range card explicitly assigns it.
- Ops-station requirements: Kali (or equivalent) with `evil-winrm` installed; reachable path to `20.30.40.41:5985`.
- Target-side enablement: WinRM listening and the `badguy` account provisioned for the range build (credentials may be Hiera/range-rotated).
- Network assumptions: ops station can reach host TCP 5985; do not assume RDP is required for grading.
- Credential handling: use Access-table or range-card values; do not hard-code rotated secrets into student notes beyond the assigned Access table.
- Access validation: after connect, `hostname`, `whoami`, and `Get-Location` must match the expected Windows host and `badguy` session before challenge work.

## Flag Reference

|Challenge|Code word key|Hiera key|Default value|
|---|---|---|---|
|1 (Secret discovery)|`secret_flag`|`cs_ops::lab_4_1::flags::secret_flag`|`MORNING-EMBER`|
|2 (System function)|`function_flag`|`cs_ops::lab_4_1::flags::function_flag`|`HARBOR-CIPHER`|
|3 (Tool execution)|`tool_exec_flag`|`cs_ops::lab_4_1::flags::tool_exec_flag`|`FALCON-NOVA`|
|4 (Infil/exfil)|`infil_exfil_flag`|`cs_ops::lab_4_1::flags::infil_exfil_flag`|`RIVER-SHADOW`|
|5 (IOC cleanup)|`ioc_cleanup_flag`|`cs_ops::lab_4_1::flags::ioc_cleanup_flag`|`SILENT-ORBIT`|

## Flag Output Locations (Default Build)

|Challenge|Where the flag is written on-system|How it gets written|
|---|---|---|
|1|`C:\ProgramData\WindowsTelemetry\profiles\active-sync.ini`|Puppet writes the active secret artifact directly.|
|2|`C:\ProgramData\WindowsTelemetry\reports\normalized-sync.log`|Collector script writes report output.|
|3|`C:\ProgramData\WindowsTelemetry\logs\approved-tool.log`|Wrapper script appends execution proof lines.|
|4|`C:\ProgramData\WindowsTelemetry\transfer\outbound\sync-bundle.txt`|Transfer processor script writes outbound artifact.|
|5|`C:\ProgramData\WindowsTelemetry\reports\cleanup-status.txt`|Cleanup verification script writes verification results.|

Instructor note:

- In this lab, flags are primarily recovered from files generated or updated by challenge workflows (not guaranteed to print to console). If paths are rotated in Hiera, grade against the configured equivalents.

## Environment and Tunables (Quick Table)

|Area|Hiera key(s)|Defaults used in walkthrough|
|---|---|---|
|Root path set|`cs_ops::lab_4_1::paths::*`|`C:\ProgramData\WindowsTelemetry\...`|
|Challenge 2 task|`cs_ops::lab_4_1::challenge2::task_*`|`ProfileSyncTelemetry`, every 15 min|
|Challenge 2 service metadata|`cs_ops::lab_4_1::challenge2::service_*`|`ProfileSyncBroker` / `Profile Sync Broker`|
|Challenge 3 gate|`cs_ops::lab_4_1::challenge3::*`|allow path `...\approved-bin`, blocked `C:\Users\Public`, `C:\Temp`|
|Challenge 4 naming rule|`cs_ops::lab_4_1::challenge4::required_name_pattern`|`ops-*.dat`|
|Challenge 5 cleanup targets|`cs_ops::lab_4_1::challenge5::*`|remove required line markers, remove tracked files, remove configured flag files|

## Recommended Instructor Walkthrough

### 1. Connect and run situational awareness baseline

From the ops station, land the WinRM session:

```
evil-winrm -i 20.30.40.41 -u badguy -p '1qaz2wsx!QAZ@WSX'
```

Connect notes:

- `evil-winrm` opens an interactive WinRM shell to the target.
- `-i` is the target IP, `-u` / `-p` are the Access-table credentials (quote the password for shell safety).
- Expected default identity after connect: `badguy` on `emu-41` (or the range-rotated equivalents).

Inside the evil-winrm session (PowerShell-capable), collect the SA baseline before challenge hunting:

```
Get-Date
hostname
whoami
whoami /all
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
query user
$env:ComSpec
[Environment]::GetEnvironmentVariables('Process').GetEnumerator() | Sort-Object Name | Select-Object -First 20
Get-CimInstance Win32_Process -Filter "ProcessId=$PID" | Select-Object ProcessId,ParentProcessId,Name,CommandLine
tasklist
Get-NetTCPConnection -State Listen,Established | Select-Object -First 40 LocalAddress,LocalPort,RemoteAddress,RemotePort,State,OwningProcess
Get-NetUDPEndpoint | Select-Object -First 40 LocalAddress,LocalPort,OwningProcess
```

Expected findings:

- Student can prove current host time, principal, token privileges, and OS version before objective work.
- Baseline process and TCP/UDP socket evidence is captured for later challenge comparisons.
- Session is WinRM/`badguy`, not an assumed RDP desktop unless the range card assigned RDP.
- In the sorted process environment, call out `ALLUSERSPROFILE=C:\ProgramData`. That is ordinary Windows shared-data context and the first place to look for non-user operational trees after a brief Defender/UAC posture check.

Teaching point: this is the standard "first 5 minutes" triage routine and should happen before challenge-specific hunting. Hold Challenge 1 file reads until after Step 2 posture, then return to `ProgramData` enumeration.

---

### 2. Enumerate Defender and UAC posture

```
Get-MpComputerStatus | Select-Object AMServiceEnabled,RealTimeProtectionEnabled
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' |
  Select-Object ConsentPromptBehaviorUser,PromptOnSecureDesktop
```

Expected findings:

- Record AM/RTP state. On some live builds (including current `emu-41` evidence) `AMServiceEnabled` / `RealTimeProtectionEnabled` may be **False**.
- `ExclusionPath` may be empty when Antimalware is disabled — that is **not** a dead end for Challenge 1.
- If an exclusion under `C:\ProgramData\WindowsTelemetry\...` **is** present, treat it as strong corroboration of the same operational root, not the only path in.
- UAC values should align with lab defaults or instructor overrides (default `ConsentPromptBehaviorUser` is `5`).

Teaching point: Defender/UAC is posture context. The required jump into Challenge 1 is Step 1 env → `ProgramData` listing → non-default `WindowsTelemetry`.

Instructor note (connection to Challenge 1):

- Required bridge: `ALLUSERSPROFILE` → `Get-ChildItem C:\ProgramData` → spot `WindowsTelemetry` → enumerate `profiles`.
- Optional corroboration only: if `ExclusionPath` names `...\WindowsTelemetry\...`, use it to reinforce the same root and sibling dirs (`profiles`, `config`, `logs`, `reports`).

---

### 3. Discover the active secret (Challenge 1)

Student packet tasking: identify the currently valid operational secret among decoy values and recover the associated flag.

Where students start / why:

1. Step 1 env already showed `ALLUSERSPROFILE=C:\ProgramData`.
2. `Get-ChildItem 'C:\ProgramData'` surfaces the non-default `WindowsTelemetry` tree among ordinary Microsoft folders.
3. Enumerate `profiles` under that root; compare active vs decoy files and use the rotation marker to decide which secret is currently valid.
4. If Step 2 returned a Defender exclusion under `WindowsTelemetry`, treat it as optional corroboration of the same root — not a prerequisite.

Goal: find the active secret source and reject stale/decoy values.

Flag write location (default):

- `C:\ProgramData\WindowsTelemetry\profiles\active-sync.ini`

Why this action matters:

- Challenge tasking says "find the currently valid secret," not "find any secret-like string."
- The ProgramData → WindowsTelemetry walk gives a defensible starting scope from native SA evidence; from there students must validate current vs stale values using state evidence.

Suggested commands:

```
Get-ChildItem 'C:\ProgramData'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\profiles'
Get-Content 'C:\ProgramData\WindowsTelemetry\profiles\active-sync.ini'
Get-Content 'C:\ProgramData\WindowsTelemetry\profiles\legacy-access.txt'
Get-Content 'C:\ProgramData\WindowsTelemetry\profiles\temp-note.txt'
Get-Content 'C:\ProgramData\WindowsTelemetry\profiles\rotation-state.json'
```

Expected findings:

- `active-sync.ini` contains status `active` and the flag.
- decoy files contain stale/deprecated values.
- marker file identifies which profile is current.

Expected `active-sync.ini` output:

```
[sync]
label=profile_master_token
value=VX-ALPHA-9341
status=active
objective_flag=MORNING-EMBER
```

Expected `rotation-state.json` output:

```
{
  "active_profile": "profile_master_token",
  "rotation_state": "current",
  "last_rotation": "2026-03-30T11:15:00Z"
}
```

Flag recovered:

- `MORNING-EMBER`

How students know this is valid:

- The active label in marker JSON matches the secret file label.
- Decoy files explicitly indicate deprecated/stale state.
- The `WindowsTelemetry` root is justified by Step 1 `ALLUSERSPROFILE` → `ProgramData` listing (Defender exclusion is optional corroboration when present); the `profiles` listing then exposes the candidate and decoy files.

Grading checkpoint:

- Require the flag plus one sentence explaining why active source is authoritative.

Instructor note (what to listen for):

- Strong student rationale references the earlier baseline observation (for example exclusion-root discovery) and then explains why the marker file establishes authority.
- Weak rationale only reports the first credential-like value found.

---

### 4. Infer true system function (Challenge 2)

Student packet tasking: establish the host's true operational role using correlated evidence from at least two artifact types; do not trust a single benign service/display label.

Where students start / why:

- Challenge 1 already justified the `WindowsTelemetry` root. From there, list sibling directories `config`, `reports`, and `logs`.
- Correlate scheduled-task and service evidence with config/report content. Treat a single benign display name or decoy audit line as non-authoritative when stronger execution/config evidence disagrees.

Goal: determine that the host is operating as a credential-harvest normalization hub despite benign-looking labels.

Flag write location (default):

- `C:\ProgramData\WindowsTelemetry\reports\normalized-sync.log`

Why this action matters:

- This challenge measures correlation discipline: students must not trust a single benign label (service display name or one audit log line) when stronger execution/config evidence says otherwise.

Suggested commands:

```
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\config'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\reports'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\logs'
schtasks /query /tn ProfileSyncTelemetry /fo LIST /v
Get-Service ProfileSyncBroker | Format-List Name,DisplayName,Status
sc.exe qc ProfileSyncBroker
Get-Content 'C:\ProgramData\WindowsTelemetry\config\profile-sync.json'
Get-Content 'C:\ProgramData\WindowsTelemetry\reports\normalized-sync.log'
Get-Content 'C:\ProgramData\WindowsTelemetry\logs\compliance-audit.log'
```

Expected findings:

- Scheduled task launches `Invoke-ProfileSync.ps1` with config/report parameters.
- Service metadata appears benign (`Profile Sync Broker`) but binary path points to telemetry bridge script with config reference.
- Config/report content indicates credential-material normalization behavior.
- Decoy audit log claims inventory-only behavior and should be treated as non-authoritative.

Expected `profile-sync.json` output:

```
{
  "role": "Profile Synchronization and Audit Telemetry",
  "collector_mode": "profile-normalization",
  "source_patterns": ["Credentials", "Login Data", "Vault"],
  "output_profile": "ops_sync_v3",
  "decoy_mode": "compliance-only"
}
```

Expected `normalized-sync.log` excerpt:

```
[<timestamp>] pipeline_stage=normalization
[<timestamp>] source_type=credential_material
[<timestamp>] objective_flag=HARBOR-CIPHER
```

Expected `compliance-audit.log` output:

```
Audit profile sweep completed. Inventory only. No credential material processed.
```

How students know these paths:

- Challenge 1 established the `WindowsTelemetry` root. From there, `config`, `reports`, and `logs` are sibling directories surfaced by directory enumeration.
- The scheduled task and service command lines point to `Invoke-ProfileSync.ps1`, the config path, and the report path; the decoy log is reviewed only to compare weaker claims against stronger execution/config evidence.

Flag recovered:

- `HARBOR-CIPHER` from `normalized-sync.log`

Required function conclusion:

- Acceptable: "This system is staging/normalizing harvested credential artifacts for operator consumption."

Grading checkpoint:

- Require the flag plus at least two independent evidence sources (for example task + config, or service path + report).

---

### 5. Execute through the constrained tool path (Challenge 3)

Student packet tasking: discover and use the host wrapper flow to execute a student PowerShell payload through the required path.

Where students start / why:

- Challenge 1 already justified `C:\ProgramData\WindowsTelemetry`. From there, list `approved-bin` and `tools` (and read host README under the allow lane).
- If Step 2 returned a Defender exclusion under `...\approved-bin`, treat it as optional corroboration of the same allow path — not a prerequisite when AM is disabled.
- Wrong paths (`C:\Users\Public`, `C:\Temp`) fail the gate; success requires the approved path.

Goal: run a custom tool through approved execution lane.

Flag write location (default):

- `C:\ProgramData\WindowsTelemetry\logs\approved-tool.log`

Why this action matters:

- Students are practicing adaptation under host controls. The grading objective is operational decision quality (choose an allowed path), not just whether a script can run somewhere.

How students know the required path:

- README under approved-bin and wrapper naming in host artifacts indicate gate expectations. Challenge 1 ProgramData discovery already placed students under `WindowsTelemetry`; `approved-bin` is a sibling of `profiles`. A Step 2 exclusion to that path is optional corroboration when present.

Suggested walkthrough:

```
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\approved-bin'
Get-Content 'C:\ProgramData\WindowsTelemetry\approved-bin\README.txt'
Get-Content 'C:\ProgramData\WindowsTelemetry\tools\Invoke-ApprovedTool.ps1' -TotalCount 80
Set-Content 'C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1' 'Write-Output "student tool ok"'
powershell -NoProfile -ExecutionPolicy Bypass -File 'C:\ProgramData\WindowsTelemetry\tools\Invoke-ApprovedTool.ps1' -ToolPath 'C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1'
Get-Content 'C:\ProgramData\WindowsTelemetry\logs\approved-tool.log'
```

Expected findings:

- Tool execution from non-approved locations yields denial lines in proof log.
- Execution from approved path yields `status=executed` and the flag.

Expected `README.txt` output:

```
Use Invoke-ApprovedTool.ps1 with a custom script placed in this directory.
```

Expected `approved-tool.log` excerpt:

```
[<timestamp>] status=executed tool=C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1 objective_flag=FALCON-NOVA
```

How students know the wrapper is safe to run:

- The wrapper path comes from the approved-bin README and `tools` directory enumeration.
- A brief script review shows it accepts `-ToolPath`, checks the allowed root, logs proof, and records cleanup targets; instructors should have students inspect that behavior before executing it.

Flag recovered:

- `FALCON-NOVA`

Grading checkpoint:

- Require the flag plus proof that the tool actually executed through allowed path (log line or equivalent).

---

### 6. Complete infiltration and exfiltration (Challenge 4)

Student packet tasking: place an inbound artifact into the host workflow and recover the resulting outbound artifact.

Where students start / why:

- Under the known `WindowsTelemetry` root, enumerate `transfer` and its children (`incoming`, `processed`, `outbound`, decoy drop if present).
- Read `INSTRUCTIONS.txt` in the ingress directory for the required inbound naming pattern before dropping a file.
- Locate and briefly inspect the transfer processor, run it (or wait for the scheduled task), then recover the outbound artifact that proves both halves of the workflow.

Goal: place inbound artifact and retrieve processed outbound artifact.

Flag write location (default):

- `C:\ProgramData\WindowsTelemetry\transfer\outbound\sync-bundle.txt`

Why this action matters:

- This forces students to prove both halves of a workflow. Finding only an outbound file without demonstrating inbound trigger action does not show control of host process flow.

How students know naming rule:

- Ingress instructions file states expected pattern (`ops-*.dat` by default).

Suggested walkthrough:

```
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\transfer'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\transfer\incoming'
Get-Content 'C:\ProgramData\WindowsTelemetry\transfer\incoming\INSTRUCTIONS.txt'
Get-Content 'C:\ProgramData\WindowsTelemetry\tasks\Invoke-TransferProcessor.ps1' -TotalCount 80
Set-Content 'C:\ProgramData\WindowsTelemetry\transfer\incoming\ops-briefing.dat' 'inbound payload'
powershell -NoProfile -ExecutionPolicy Bypass -File 'C:\ProgramData\WindowsTelemetry\tasks\Invoke-TransferProcessor.ps1'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\transfer\processed'
Get-Content 'C:\ProgramData\WindowsTelemetry\transfer\outbound\sync-bundle.txt'
```

Expected findings:

- Validly named file is copied into processed queue.
- Outbound artifact includes ingress filename and the flag.
- Decoy drop path does not trigger processing.

Expected `INSTRUCTIONS.txt` output:

```
Place inbound file using naming pattern: ops-*.dat
```

Expected `sync-bundle.txt` excerpt after processing:

```
ingress_file=ops-briefing.dat
processed_path=C:\ProgramData\WindowsTelemetry\transfer\processed\ops-briefing.dat
objective_flag=RIVER-SHADOW
```

How students know the action is valid:

- Transfer root enumeration exposes `incoming`, `processed`, and `outbound`, and the `INSTRUCTIONS.txt` file provides the naming rule.
- The processor script is a custom lab workflow, so a minimal review should confirm it consumes matching inbound files, writes processed/output artifacts, and records timestamp state for later cleanup.

Flag recovered:

- `RIVER-SHADOW`

Grading checkpoint:

- Require evidence of both inbound placement and outbound retrieval, not just final file read.

---

### 7. Verify multi-mode cleanup (Challenge 5)

Student packet tasking: perform required cleanup actions (line removal, file removal, timestamp manipulation, and scoped flag-file cleanup) and validate post-cleanup criteria.

Where students start / why:

- Challenge 5 is residue cleanup from work already done in Challenges 2–4, then host verification. Do not reverse-engineer the obfuscated verifier first.
- Re-list the operational tree students already know (`logs`, `reports`, `approved-bin`, `transfer\processed`, `tasks`), read the dirty artifacts, clean them, then run `Test-CleanupState.ps1` and read `cleanup-status.txt`.

Goal: erase specific evidence produced by earlier student actions, then pass the host verifier in one run.

Flag write location (default):

- `C:\ProgramData\WindowsTelemetry\reports\cleanup-status.txt`

Why this action matters:

- This challenge measures disciplined anti-forensics under constraints, not broad destruction.
- Every cleanup target maps to a prior student action; instructors should teach that cause→artifact→action chain, not a magic checklist.

#### Cause map (prior student action → dirt → clean state)

|Check|Prior student action that created the dirt|Artifact to clean|Clean means|
|---|---|---|---|
|c1|Challenge 3: ran `Invoke-ApprovedTool.ps1` successfully; wrapper appended an IOC-style line|`logs\session-trace.log` line containing `cleanup_ioc=wrapper-executed`|That line is gone; the log file still exists|
|c2|Challenge 3: student created and executed `approved-bin\student-tool.ps1` through the wrapper; wrapper recorded that path|Leftover payload file (corroborated in `reports\cleanup-delete-targets.txt`)|Tracked payload path(s) deleted|
|c3|Challenge 4: student dropped inbound file and ran the transfer processor; processor copied to `transfer\processed\...` and recorded MTIME|Processed file named in `reports\cleanup-timestamp-target.txt`|`LastWriteTimeUtc` no longer matches recorded ticks|
|c4|Challenges 2–4: student recovered flags from workflow outputs that still contain `objective_flag=`|Default: `reports\normalized-sync.log`, `logs\approved-tool.log`, `transfer\outbound\sync-bundle.txt`|Those flag-bearing files are deleted after the flags are recorded|

Instructor note on c4: wiping flag carriers after collection is scored lab anti-forensics, not a realistic “only delete the implant” SOP. Call that out so students understand why this category feels different from c1–c3.

#### Discovery before edits

```
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\logs'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\reports'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\approved-bin'
Get-ChildItem 'C:\ProgramData\WindowsTelemetry\transfer\processed'
Get-Content 'C:\ProgramData\WindowsTelemetry\logs\session-trace.log'
Get-Content 'C:\ProgramData\WindowsTelemetry\reports\cleanup-delete-targets.txt'
Get-Content 'C:\ProgramData\WindowsTelemetry\reports\cleanup-timestamp-target.txt'
Get-Content 'C:\ProgramData\WindowsTelemetry\tasks\Test-CleanupState.ps1' -TotalCount 40
```

Teaching point: `Test-CleanupState.ps1` is a usage/safety glance only (obfuscated). Target selection comes from the cause map and the dirty files above.

Expected pre-cleanup snippets (after Challenges 3–4 succeeded):

```
# session-trace.log — caused by Challenge 3 wrapper success
[<timestamp>] cleanup_ioc=wrapper-executed tool=C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1 mode=path-gate
```

```
# cleanup-delete-targets.txt — caused by Challenge 3 recording the tool path it executed
C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1
```

```
# cleanup-timestamp-target.txt — caused by Challenge 4 processor writing baseline MTIME for the processed file
target_path=C:\ProgramData\WindowsTelemetry\transfer\processed\ops-briefing.dat
recorded_ticks=<ticks>
recorded_time_utc=<timestamp>
source_ingress=C:\ProgramData\WindowsTelemetry\transfer\incoming\ops-briefing.dat
```

#### Cleanup actions (each tied to the prior cause)

**c1 — remove wrapper IOC line from session log**

- Caused by: Challenge 3 successful `Invoke-ApprovedTool.ps1` run (wrapper wrote `cleanup_ioc=wrapper-executed` into `session-trace.log`).
- Keep a `session-trace.log` present at the end; only strip the IOC line. Do not leave the log missing (verifier fails if the path is gone).
- Under evil-winrm, in-place PowerShell rewrite of the same file and `%TEMP%` one-liners often fail. Use `findstr /V` to a sibling `.tmp`, delete the original `.log`, then `move` the `.tmp` into place:

```
findstr /V "cleanup_ioc=wrapper-executed" "C:\ProgramData\WindowsTelemetry\logs\session-trace.log" > "C:\ProgramData\WindowsTelemetry\logs\session-trace.tmp"
del "C:\ProgramData\WindowsTelemetry\logs\session-trace.log"
move /Y "C:\ProgramData\WindowsTelemetry\logs\session-trace.tmp" "C:\ProgramData\WindowsTelemetry\logs\session-trace.log"
```

`findstr /V` prints lines that do **not** contain the search string. If the shell is pure PowerShell and `del`/`move /Y` misbehave, use the same three steps via `cmd /c` or `Remove-Item` / `Move-Item -Force`.

**c2 — delete leftover Challenge 3 payload**

- Caused by: Challenge 3 student action of creating `student-tool.ps1` under `approved-bin` and executing it through the wrapper (wrapper also listed that path in `cleanup-delete-targets.txt`).
- Delete the payload you dropped; the tracker file is corroboration, not a separate mystery target.

```
Remove-Item 'C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1' -Force
```

**c3 — timestomp Challenge 4 processed transfer file**

- Caused by: Challenge 4 student action of placing the inbound file and running the transfer processor (processor copied ingress → `transfer\processed\ops-briefing.dat` and recorded that file’s UTC ticks).
- Change MTIME so it no longer matches the recorded baseline (classic timestomp / anti-forensics on the artifact you just created).

```
$f = Get-Item 'C:\ProgramData\WindowsTelemetry\transfer\processed\ops-briefing.dat'
$f.LastWriteTime = (Get-Date).AddDays(-2)
```

**c4 — wipe flag-bearing workflow outputs after flags are recorded**

- Caused by:
    - Challenge 2 collector writing `objective_flag=` into `reports\normalized-sync.log`,
    - Challenge 3 wrapper writing `objective_flag=` into `logs\approved-tool.log`,
    - Challenge 4 processor writing `objective_flag=` into `transfer\outbound\sync-bundle.txt`.
- Record those flag values first, then delete the carriers so the verifier cannot re-read them on disk.

```
Remove-Item 'C:\ProgramData\WindowsTelemetry\reports\normalized-sync.log' -Force
Remove-Item 'C:\ProgramData\WindowsTelemetry\logs\approved-tool.log' -Force
Remove-Item 'C:\ProgramData\WindowsTelemetry\transfer\outbound\sync-bundle.txt' -Force
```

#### Verify

```
powershell -NoProfile -ExecutionPolicy Bypass -File 'C:\ProgramData\WindowsTelemetry\tasks\Test-CleanupState.ps1'
Get-Content 'C:\ProgramData\WindowsTelemetry\reports\cleanup-status.txt'
```

Expected findings:

- Verification shows all categories satisfied (`c1=0`, `c2=0`, `c3=0`, `c4=0`).
- The flag appears only when all four pass in the same run.
- Any unmet category leaves that `cN=1`.

Expected `cleanup-status.txt` after success:

```
timestamp=<timestamp>
c1=0
c2=0
c3=0
c4=0
objective_flag=SILENT-ORBIT
```

Flag recovered:

- `SILENT-ORBIT`

Grading checkpoint:

- Require the flag plus evidence for all four categories, each tied to the prior cause:
    - c1 line removal after Challenge 3 wrapper IOC,
    - c2 deletion of Challenge 3 payload,
    - c3 MTIME change on Challenge 4 processed file,
    - c4 removal of Challenge 2/3/4 flag-bearing outputs after flags were recorded.
- Accept equivalent command sequences if evidence shows the same state transitions.

### 8. Close with the host-purpose summary

Students should be able to conclude that this is a Windows operations host providing at least:

- UAC (and Defender when the range enables it) as posture context; optional exclusion paths may corroborate the operational root but are not required for discovery
- Shared operational data under `ProgramData\WindowsTelemetry` recoverable from SA env → directory enumeration
- Noisy telemetry/profile artifacts that require distinguishing active secrets from decoys
- A credential-normalization / profile-sync function recoverable from corroborated service, task, and report evidence
- A constrained execution path for approved tooling
- Ingress/egress workflow artifacts and a multi-mode cleanup verification surface

That is the picture this lab is trying to build: context first, then challenge-specific key terrain, with flags tied to evidence rather than path memorization.

## Troubleshooting and Confirmation

If a fresh Emu deploy does not match this key, or Challenge 5 has removed the workflow files and Puppet will not reseed them, the host repair commands are in B03 range host recovery (`course/operations/b03-range-host-recovery.md`).

- If `evil-winrm` fails, confirm the ops-station path, target IP, TCP 5985, and Access-table credentials versus any range-rotated values. Treat RDP as fallback only when the range card assigns it.
- If `AMServiceEnabled` / `RealTimeProtectionEnabled` are False or `ExclusionPath` is empty, do **not** stall Challenge 1. Use Step 1 `ALLUSERSPROFILE` → `Get-ChildItem C:\ProgramData` → `WindowsTelemetry`. Puppet is intended to enable Defender and seed the exclusion on a healthy deploy; restore that optional pivot only after WinDefend/AM is actually running.
- If Defender blocks a tool or script when AM is enabled, treat that as lab friction. Use exclusion or ProgramData evidence to locate the operational root; do not disable Defender.
- If students cannot find Challenge 1 artifacts, have them re-list `C:\ProgramData`, then sibling directories under `WindowsTelemetry` (`profiles`, `config`, `logs`, `reports`) before guessing paths.
- If `Invoke-ApprovedTool.ps1` fails with `Missing expression after ','` near `'C:\Temp',`, that is a Windows PowerShell 5.1 parse error from a trailing comma in the `$blockedRoots = @(...)` array (Puppet template bug). On a live host before redeploy, remove the trailing comma after the last blocked path so the array closes like `'C:\Temp'` then `)`, then re-run the wrapper. Fixed builds render the array without a trailing comma.
- If Challenge 5 c1 line cleanup fails under evil-winrm with in-place `Get-Content | Set-Content` on `session-trace.log`, use `findstr /V` to a sibling `.tmp`, delete the original `.log`, then `move` the `.tmp` to `session-trace.log` (do not delete the `.tmp` before the move).
- If a scheduled task has not fired, students may run the lab script directly when the handout permits it.
- If recovered flag strings or paths differ from this key, grade the Hiera values for that run, not the defaults table.

## Acceptable Answers / Alternate Paths

- Equivalent built-in commands are acceptable (`Get-ScheduledTask` vs `schtasks`, `Select-String` vs manual reads).
- If a scheduled task has not fired recently, students may run the lab script directly from PowerShell when permitted by the handout.
- If a single artifact path is overridden in Hiera, grade against the configured path set rather than default filenames.

## Final Grading Guidance

Full credit:

- all five flags recovered, and
- each challenge includes short evidence-backed explanation, and
- Challenge 2 conclusion correctly identifies credential-normalization function, and
- Challenge 5 satisfies all cleanup categories (line removal, tracked file removal, timestamp update, and configured flag-file removal).

Partial credit:

- flag recovered but weak/no evidence explanation,
- correct logic but wrong path due to stale notes,
- one challenge incomplete with otherwise valid methodology.

## lab 4.2 answer key

# Lab 4.2 — Through the Looking Glass (Split-Port Hybrid) — Answer Key (Instructor Only)

Use this as a live walkthrough. Students start with an ambiguous split-port shell entry and must complete four evidence-driven challenges across Linux and Windows boundaries.

Implementation references:

- Puppet class: `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_4_2.pp`
- Default node data: `environments/week3_repo/vms/puppet/data/nodes/lab_4_2.yaml`

## Objectives and Starting Context

- Students are told the assigned target host and the two sequential TCP ports from the range card.
- Students are not told upfront that the shell is WSL-backed or which challenge paths, stream names, files, or privileged context markers matter.
- Students must connect manually to the lower port first and the higher port second:
    - lower port receives input,
    - higher port receives stdout and stderr.
- Students must demonstrate:
    - stream attribution discipline,
    - boundary discovery by evidence,
    - Windows interop usage from Linux-side context,
    - alternate data stream discovery,
    - elevated native Windows context validation (identity and ACL) before retrieving restricted artifacts.

Primary access method: split-port raw TCP shell from the student operations station to the assigned target. Accept `nc`, `ncat`, `socat`, or equivalent TCP client tooling. The default range card exposes `ewe-42` at `20.30.40.42` with TCP `4420` as the lower input lane and TCP `4421` as the higher output/error lane. If values are rotated, grade against the assigned host and the configured Hiera values, not the defaults below.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`ewe-42`|20.30.40.42|N/A|N/A|Two manual TCP sessions: TCP 4420 lower input lane first, then TCP 4421 higher output/error lane|

If the instructor or range card provides a different host or port pair, use those assigned values.

## Flag Reference

|Challenge|Code word key|Hiera key|Default value|
|---|---|---|---|
|1 (Session wiring)|`challenge1_flag`|`cs_ops::lab_4_2::flags::challenge1_flag`|`FORKLINE-TRACE`|
|2 (Boundary proof + pivot)|`challenge2_flag`|`cs_ops::lab_4_2::flags::challenge2_flag`|`BOUNDARY-LENS`|
|3 (ADS discovery)|`challenge3_flag`|`cs_ops::lab_4_2::flags::challenge3_flag`|`STREAM-CACHE`|
|4 (Elevated Windows context)|`challenge4_flag`|`cs_ops::lab_4_2::flags::challenge4_flag`|`ELEVATED-ROOT`|

## Flag Output Locations (Default Build)

These locations are instructor reference values. Students should reach them through the discovery steps in the walkthrough, not from prior knowledge of this table.

|Challenge|Where the flag is written on-system|How it gets written|
|---|---|---|
|1|`/opt/system-health/bin/flag.txt`|Puppet deploys a code-word file in the split-shell working directory.|
|2|`C:\ProgramData\DeviceCache\reports\session-index.txt`|Puppet seeds Windows artifact; Linux hint file points to it.|
|3|`C:\ProgramData\DeviceCache\reports\inventory.dat:diagcache`|Puppet writes the flag into an NTFS alternate data stream.|
|4|`C:\ProgramData\DeviceCache\store\health.index`|Puppet writes the flag and applies ACLs. Live access is elevated-admin readable (SYSTEM and Administrators Read).|

## Environment and Tunables (Quick Table)

|Area|Hiera key(s)|Defaults used in walkthrough|
|---|---|---|
|Split entry ports|`cs_ops::lab_4_2::ports::*`|`4420` input, `4421` output/error|
|Windows remote exposure|`cs_ops::lab_4_2::portproxy::*`|listen `0.0.0.0`, WSL iface `eth0`, firewall rule `Lab4.2 Split Bridge 4420-4421`|
|Bridge task account|`cs_ops::lab_4_2::challenge1::autostart_task_user`|`wsl` on this clone. A `SYSTEM` principal does not keep the WSL bridge up.|
|Bridge task password|`cs_ops::lab_4_2::challenge1::autostart_task_password`|Required for the non-`SYSTEM` `wsl` task user (Windows local `wsl` password).|
|WSL distro targeting|`cs_ops::lab_4_2::challenge1::wsl_distribution`|`Ubuntu`. The scheduled-task arguments must include `-WslDistribution Ubuntu`.|
|WSL executable path|`cs_ops::lab_4_2::challenge1::wsl_executable`|`C:\Windows\System32\wsl.exe`|
|Bridge rearm delay|`cs_ops::lab_4_2::challenge1::rearm_delay_seconds`|`90` seconds only if the bridge process exits. A student disconnect does not wait; the same process accepts the next pair.|
|Artifact locations|`cs_ops::lab_4_2::paths::*`|`C:\ProgramData\DeviceCache\...`, `/opt/system-health/...`|
|ADS stream name|`cs_ops::lab_4_2::challenge3::ads_stream_name`|`diagcache`|
|Seeded owner marker|`cs_ops::lab_4_2::challenge4::required_owner`|File body still contains `owner_required=SYSTEM`. Grade the live Windows token and ACL, not that string alone.|

## Target Access Enablement

- Environment type: hybrid Windows VM with WSL2 and Windows `portproxy` forwarding to a WSL-hosted split-port bridge.
- Primary student method: split-port raw TCP shell using two manual TCP client sessions.
- Student fallback methods: none. Connection sequencing is part of objective validation; do not replace it with RDP, WinRM, SSH, or a wrapper shell for student grading.
- Instructor management access: RDP or WinRM to the Windows VM is acceptable for pre-demo checks, reset, and troubleshooting only.
- Target-side enablement: `cs_ops::lab_4_2` creates Windows and WSL artifact directories, seeds challenge artifacts, deploys the Python bridge and PowerShell launcher, registers the autostart scheduled task, configures Windows `portproxy`, and opens the configured inbound firewall ports.
- Ops-station requirements: `nc`, `ncat`, `socat`, or equivalent TCP client tooling capable of holding two independent sessions open.
- Network assumptions: the assigned target host is reachable from the student ops station on the configured lower input port and higher output/error port.
- Access validation: connect lower lane first and higher lane second, send `echo stdout_probe`, and confirm the output appears on the higher lane.
- Reset/cleanup: restart the VM or rerun the bridge launcher task after the configured rearm delay. Do not blindly reapply Puppet on this clone: class defaults restore a `SYSTEM` task without `-WslDistribution Ubuntu`, and that principal does not keep the WSL bridge up.

## Instructor Pre-Demo Confirmation

Goal: confirm the split-port bridge is active and inspect custom tooling before relying on it in a live demo.

Run these checks from an instructor Windows session on the target VM:

```
Get-Content 'C:\ProgramData\cs_ops\lab_4_2_applied'
Get-Content 'C:\ProgramData\DeviceCache\tools\Start-SplitBridge.ps1' -TotalCount 120
Get-Content 'C:\ProgramData\DeviceCache\tools\split-io-bridge.py' -TotalCount 120
Get-ScheduledTask -TaskName 'DeviceCacheSplitBridge' |
  Select-Object TaskName, State, @{n='User';e={$_.Principal.UserId}}, @{n='RunLevel';e={$_.Principal.RunLevel}}
(Get-ScheduledTask -TaskName 'DeviceCacheSplitBridge').Actions | Format-List Execute, Arguments
netstat -ano | findstr ":4420"
netstat -ano | findstr ":4421"
netsh interface portproxy show v4tov4
Get-NetFirewallRule -DisplayName 'Lab4.2 Split Bridge 4420-4421'
```

First-use notes:

- `Get-Content` reads concise text files or script previews. Here it verifies the Puppet marker and lets instructors inspect the PowerShell launcher and Python bridge before students use them.
- `Get-ScheduledTask` confirms the bridge is registered to start automatically. On this clone the principal is `wsl`, RunLevel is Highest, and the action arguments include `-WslDistribution Ubuntu`. The default task name comes from `cs_ops::lab_4_2::challenge1::autostart_task_name`.
- `netstat -ano` confirms TCP listeners and owning PIDs for the configured split ports.
- `netsh interface portproxy show v4tov4` confirms Windows forwards the externally reachable ports to the active WSL address.
- `Get-NetFirewallRule` confirms the inbound firewall rule exists for the configured port pair. The default display name comes from Hiera and may be rotated.

Expected findings:

- Lab marker file exists and names the target host where Puppet applied.
- Scheduled task `DeviceCacheSplitBridge` is `wsl` / Highest, and arguments include `-File "...\Start-SplitBridge.ps1" -WslDistribution Ubuntu`.
- Launcher configures Windows portproxy and firewall state, targets the Ubuntu WSL distribution, and starts the WSL bridge.
- Python bridge accepts one input connection and one output connection, then launches `/bin/bash -i` in the configured working directory. After that client disconnects, the same process accepts the next pair.
- Both default ports show listening sockets, and `portproxy` includes forwarding entries for `0.0.0.0:4420` and `0.0.0.0:4421`.

Instructor teaching point: if students connect to only one port, they may type commands but not see complete command feedback.

## Recommended Instructor Walkthrough

### 1. Connect the split-port shell and run situational awareness baseline

Goal: establish operating context before challenge grading or split-port troubleshooting.

Student-side setup from the operations station:

```
# Session A: lower input lane, using assigned host and lower port.
nc <assigned_target_ip_or_hostname> 4420

# Session B: higher output/error lane, using assigned host and higher port.
nc <assigned_target_ip_or_hostname> 4421
```

How students know these values:

- The target host and initial port pair come from the range card. They are access values, not challenge solutions.
- The lower/higher lane roles come from the student handout and are confirmed behaviorally: commands typed into the lower lane produce output on the higher lane only after both sessions are connected.

Run these commands by typing them into Session A and reading the output from Session B:

```
date -u
hostname
whoami
id
pwd
echo "$SHELL"
ps -p $$ -o pid,ppid,args=
env | sort | sed -n '1,20p'
uname -a
cat /proc/version
who 2>/dev/null || true
w 2>/dev/null || true
ps aux | sed -n '1,25p'
ss -tulpen 2>/dev/null || netstat -tulpen
ss -tunap 2>/dev/null || netstat -tunap
```

First-use notes:

- `date -u` records UTC time so evidence can be correlated with logs without local time-zone confusion.
- `hostname`, `whoami`, `id`, and `pwd` establish host identity, current user, group context, and working directory.
- `echo "$SHELL"` and `ps -p $$ -o pid,ppid,args=` identify the current shell and parent process. The `$$` variable is the current shell PID.
- `env | sort | sed -n '1,20p'` samples environment variables without dumping everything. `sort` stabilizes output, and `sed -n '1,20p'` prints the first twenty lines only.
- `uname -a` and `cat /proc/version` are Linux runtime checks. They often reveal WSL or Microsoft kernel clues in this lab.
- `who` and `w` show active users when the commands are available; `2>/dev/null || true` keeps the baseline from failing noisily if the utilities are absent or quiet.
- `ps aux | sed -n '1,25p'` gives a broad process sample before narrowing to specific processes.
- `ss -tulpen` and `ss -tunap` show listening and established TCP/UDP sockets; `netstat` is an acceptable fallback if `ss` is unavailable.

Expected `cat /proc/version` snippet:

```
Linux version ... microsoft-standard-WSL2 ...
```

Expected findings:

- Students can show shell/runtime evidence consistent with Linux-side context.
- The current working directory is expected to be `/opt/system-health/bin` in the default build.
- Process/socket evidence is available for both listening and established network state.
- WSL boundary clues are visible from OS/version output and later justify Windows path translation.

Teaching point: require this baseline first so stream-attribution mistakes and unsupported path assumptions are easier to debug and grade consistently.

---

### 2. Attribute session streams (Challenge 1)

Goal: prove the student understands split-port behavior and can collect output-channel evidence.

Discovery-first sequence:

```
echo stdout_probe
pwd
ls -la
ls /does/not/exist
cat flag.txt
```

How students know each value:

- `echo stdout_probe` is a harmless stdout test chosen by the student. Seeing the text on the higher lane proves normal output flows to Session B.
- `pwd` reveals the working directory before any file path is assumed.
- `ls -la` is justified by `pwd`: students enumerate the current directory first and observe `flag.txt` as a visible candidate file.
- `ls /does/not/exist` intentionally names a path expected not to exist. The error text appears on the higher lane and proves stderr is also routed there.
- `cat flag.txt` is justified only after `ls -la` exposes `flag.txt` in the current directory.

Expected output snippet:

```
stdout_probe
/opt/system-health/bin
total ...
... flag.txt
ls: cannot access '/does/not/exist': No such file or directory
flag=FORKLINE-TRACE
```

Expected `cat flag.txt` output:

```
flag=FORKLINE-TRACE
```

Grading checkpoint:

- Require the flag plus evidence that stdout and stderr were observed from the higher port lane.
- Accept rotated flag values if the student shows the same directory enumeration and split-lane evidence.

---

### 3. Prove the Linux/Windows boundary (Challenge 2)

Goal: identify environment by evidence and perform a Linux-to-Windows path pivot from a discovered hint.

Discovery-first sequence:

```
uname -a
cat /proc/version
ls -la /mnt
pwd
ls -la ..
ls -la ../state
find /opt/system-health -maxdepth 3 -type f -readable -print
cat ../state/flag-hint.txt
ls -la /mnt/c/ProgramData
ls -la /mnt/c/ProgramData/DeviceCache
ls -la /mnt/c/ProgramData/DeviceCache/reports
cat /mnt/c/ProgramData/DeviceCache/reports/session-index.txt
```

How students know each value:

- `uname -a`, `cat /proc/version`, and `ls -la /mnt` establish that this is Linux-side execution with a mounted Windows `C:` drive before any Windows path translation is attempted.
- `pwd` reveals the current `/opt/system-health/bin` location. From there, checking `..` is ordinary parent-directory triage, not prior knowledge of `/opt/system-health/state`.
- `../state` is discoverable as a sibling directory under the observed `/opt/system-health` root.
- `find /opt/system-health -maxdepth 3 -type f -readable -print` is a bounded readable-file inventory under the already discovered root. It exposes the hint file without searching the whole host.
- `cat ../state/flag-hint.txt` is justified after the bounded inventory shows that file.
- The Windows path inside the hint tells students the authoritative artifact location. WSL evidence justifies translating `C:\ProgramData\DeviceCache\reports\session-index.txt` to `/mnt/c/ProgramData/DeviceCache/reports/session-index.txt`.

Expected `cat /proc/version` snippet:

```
Linux version ... microsoft-standard-WSL2 ...
```

Expected `cat ../state/flag-hint.txt` output:

```
The flag for challenge 2 is in C:\ProgramData\DeviceCache\reports\session-index.txt
```

Expected `cat /mnt/c/ProgramData/DeviceCache/reports/session-index.txt` output:

```
objective=boundary-confirmation
flag=BOUNDARY-LENS
note=recovered from Windows path discovered via Linux hint file
```

Expected findings:

- Kernel/version evidence indicates WSL-backed Linux context.
- `/mnt/c` proves the Windows drive is accessible from Linux.
- The Linux-side hint names the Windows-side artifact.
- The student retrieves the flag only after translating the hinted Windows path through observed WSL mount behavior.

Grading checkpoint:

- Require the flag plus one Linux boundary artifact and one Windows artifact in the evidence chain.
- Do not give full credit for a bare `cat /mnt/c/...` command with no WSL or hint evidence.

---

### 4. Discover the NTFS alternate data stream (Challenge 3)

Goal: prove the student can recover hidden content stored in an alternate data stream, not just the base file body.

Discovery-first sequence:

```
ls -la /mnt/c/ProgramData/DeviceCache/reports
cat /mnt/c/ProgramData/DeviceCache/reports/inventory.dat
powershell.exe -NoProfile -Command "Get-ChildItem -Path 'C:\ProgramData\DeviceCache\reports' -Force | Format-Table Name,Length,Mode"
powershell.exe -NoProfile -Command "Get-Item -Path 'C:\ProgramData\DeviceCache\reports\inventory.dat' -Stream * | Format-Table Stream,Length"
powershell.exe -NoProfile -Command "Get-Content -Path 'C:\ProgramData\DeviceCache\reports\inventory.dat' -Stream 'diagcache'"
```

First-use notes:

- `inventory.dat` is not presupposed; it is discovered by enumerating the `reports` directory that Challenge 2 already revealed.
- `cat .../inventory.dat` reads the base stream first. The content tells students the objective is stored in an NTFS alternate data stream on that file.
- `powershell.exe -NoProfile -Command` runs a Windows-native command from the Linux-side shell. `-NoProfile` avoids user profile scripts changing command behavior, and `-Command` supplies the command to execute.
- `Get-ChildItem -Force` provides Windows-side directory confirmation, including hidden items if present.
- `Get-Item -Stream *` enumerates stream metadata. This is how students learn the stream name; they should not guess `diagcache`.
- `Get-Content -Stream 'diagcache'` is justified only after stream enumeration shows `diagcache`. If the stream name is rotated, students should use the observed stream name from `Get-Item -Stream *`.

Expected `cat /mnt/c/ProgramData/DeviceCache/reports/inventory.dat` output:

```
inventory snapshot generated
challenge3_note=objective is stored in an NTFS alternate data stream on this file
```

Expected stream enumeration snippet:

```
Stream     Length
------     ------
:$DATA         ...
diagcache      ...
```

Expected ADS output:

```
flag=STREAM-CACHE
```

Alternate discovery path:

```
powershell.exe -NoProfile -Command "cmd /c dir /r C:\ProgramData\DeviceCache\reports"
```

Use this alternate if students know Windows `dir /r`; it should still follow the same evidence chain: reports directory observed, base file read, stream metadata enumerated, then stream content retrieved.

Grading checkpoint:

- Require the flag and explicit evidence showing stream enumeration or another valid ADS discovery method.
- Do not require the default stream name if Hiera rotated `cs_ops::lab_4_2::challenge3::ads_stream_name`; require that the student used the stream name discovered on the host.

---

### 5. Transition to elevated Windows context (Challenge 4)

Goal: move from Linux-side shell context into native Windows command execution, validate elevated Windows identity and ACL evidence, and retrieve restricted file content from a discovered Windows artifact root.

Current implementation note: this lab implementation exposes Windows command execution through `powershell.exe` from the split shell. The bridge scheduled task runs as the Windows `wsl` account so WSL interop inherits that elevated-admin token (`ewe-42\wsl` on the default host), not `NT AUTHORITY\SYSTEM`. A SYSTEM task principal does not keep the WSL bridge up on this image. Grade native Windows execution, elevated-admin identity (`whoami` / `whoami /all`), ACL evidence, and discovered restricted-artifact retrieval. Do not require `nt authority\system`.

Discovery-first sequence:

```
powershell.exe -NoProfile -Command "whoami"
powershell.exe -NoProfile -Command "whoami /all"
powershell.exe -NoProfile -Command "Get-ChildItem -Path 'C:\ProgramData\DeviceCache' -Force | Format-Table Name,Mode"
powershell.exe -NoProfile -Command "Get-ChildItem -Path 'C:\ProgramData\DeviceCache\store' -Force | Format-Table Name,Length,Mode"
powershell.exe -NoProfile -Command "Get-Acl -Path 'C:\ProgramData\DeviceCache\store\health.index' | Format-List Owner,AccessToString"
powershell.exe -NoProfile -Command "Get-Content -Path 'C:\ProgramData\DeviceCache\store\health.index'"
```

How students know each value:

- `powershell.exe` is justified by the WSL boundary evidence from Challenge 2 and by the course expectation to test native Windows interop from a Linux-side context.
- `whoami` confirms the Windows identity returned by native Windows execution. On this clone that identity is the elevated local admin that started the WSL bridge (`ewe-42\wsl` when the host is `ewe-42`).
- `whoami /all` expands identity evidence to groups and privileges. Require `BUILTIN\Administrators` and High Mandatory Level (or equivalent elevated-admin proof), not `nt authority\system`.
- `C:\ProgramData\DeviceCache` is known from the Challenge 2 hint and Challenge 3 reports path. Enumerating that root is ordinary Windows artifact triage.
- `store` is discovered as a sibling directory during root enumeration.
- `health.index` is discovered by enumerating `store`.
- `Get-Acl` is run before `Get-Content` so students can explain why the current Windows token satisfies the file ACL.

Expected `Get-ChildItem 'C:\ProgramData\DeviceCache'` snippet:

```
Name     Mode
----     ----
reports  d-----
runtime  d-----
store    d-----
tools    d-----
```

Expected `Get-ChildItem 'C:\ProgramData\DeviceCache\store'` snippet:

```
Name          Length Mode
----          ------ ----
health.index  ...    -a----
```

Expected `whoami` output:

```
ewe-42\wsl
```

Expected `whoami /all` snippet:

```
User Name  SID
========== =============================================
ewe-42\wsl S-1-5-21-...

BUILTIN\Administrators ... Enabled group, Group owner
Mandatory Label\High Mandatory Level
```

Expected ACL snippet:

```
Owner          : BUILTIN\Administrators
AccessToString : NT AUTHORITY\SYSTEM Allow  Read, Synchronize
                 BUILTIN\Administrators Allow  Read, Synchronize
```

Expected flag output:

```
flag=ELEVATED-ROOT
owner_required=SYSTEM
```

The `owner_required=SYSTEM` line is seeded file text. Grade the live token and ACL. Do not fail a student who shows elevated-admin identity and then reads the file.

Expected findings:

- The student proves native Windows command execution from the Linux-side shell.
- The student presents elevated-admin evidence with `whoami` / `whoami /all`.
- Directory and ACL enumeration explain why the restricted artifact is readable under that token.

Grading checkpoint:

- Require the flag plus elevated Windows identity and ACL evidence, not just file path knowledge.
- Do not require `nt authority\system`.
- Require a discovery chain from the previously identified Windows root to `store` to `health.index`.

### 6. Close with the host-purpose summary

Students should be able to conclude that this host is a hybrid Windows/WSL operations surface providing at least:

- A split-port shell that requires both TCP lanes for a usable session
- Linux-side context with a recoverable Windows boundary (`/mnt/c`, `powershell.exe`, WSL clues)
- Windows artifacts under an operational ProgramData root, including an NTFS alternate data stream
- Elevated native Windows context (identity and ACL) as a requirement for a restricted file, not just a path to type

That is the picture this lab is trying to build: prove the session wiring, prove the boundary, then recover Windows artifacts with the matching execution context.

## Troubleshooting and Confirmation

If a fresh Ewe deploy does not match this key, the host repair commands are in B03 range host recovery (`course/operations/b03-range-host-recovery.md`).

- If typing appears to do nothing, confirm both lanes are connected. Session A should connect to the lower input port, and Session B should connect to the higher output/error port.
- If output appears in the same terminal where commands are typed, the student may be using a different service or a tool that merged streams. Reconnect with two plain TCP sessions.
- If either port refuses connections, have an instructor confirm the scheduled task, listener state, portproxy entries, and firewall rule with the pre-demo checks. A live bridge does not need the rearm delay between students.
- If `uname` or `/proc/version` does not show WSL clues, require students to collect alternative boundary evidence such as `/mnt/c`, `powershell.exe -NoProfile -Command "whoami"`, or Windows path accessibility before proceeding.
- If `/mnt/c` is missing, the WSL distro or mount configuration is not in the expected lab state. Instructors should reset/reapply the VM rather than giving students direct paths.
- If `Get-Item -Stream *` does not show an extra stream, verify the ADS seed step ran and that the target file is on NTFS, not copied to a filesystem that strips streams.
- If `Get-Content -Stream` fails with access or stream-not-found errors, have students re-run stream enumeration and use the observed stream name.
- If `powershell.exe` `whoami` is `nt authority\system`, the bridge task was reverted to a SYSTEM principal; that configuration does not keep the WSL bridge up on this image. Restore the `wsl` / `-WslDistribution Ubuntu` task before students start.
- If the restricted file is readable, still require `whoami` / `whoami /all` and `Get-Acl` so students show why the current elevated-admin token matches the ACL. Do not require SYSTEM identity.

## Acceptable Answers / Alternate Paths

- Any equivalent TCP client tooling is acceptable (`nc`, `ncat`, `socat`, terminal emulators).
- Equivalent evidence commands are acceptable if they prove the same workflow and context transitions.
- If ports, paths, stream names, task names, or flags are rotated in Hiera, grade against the configured values for that run and require students to show how those values were discovered from range-card access data or target evidence.
- Students may use Windows-native commands through `cmd.exe /c` where they prove the same artifact chain as the PowerShell commands shown above.

## Final Grading Guidance

Full credit:

- all four flags recovered,
- each challenge includes a short evidence-backed explanation,
- Challenge 1 includes both stdout and stderr lane proof,
- Challenge 2 includes both Linux boundary evidence and Windows artifact evidence,
- Challenge 3 shows explicit ADS metadata discovery and stream retrieval,
- Challenge 4 includes native Windows execution proof, elevated-admin identity evidence, ACL evidence, and discovered restricted-artifact retrieval.

Partial credit:

- flag recovered with weak context evidence,
- strong methodology but stale path assumptions,
- one challenge incomplete with otherwise correct workflow.