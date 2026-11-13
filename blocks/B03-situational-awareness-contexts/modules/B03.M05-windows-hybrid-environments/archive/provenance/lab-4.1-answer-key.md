---
id: B03.M05.lab-4.1-answer-key
title: Lab 4.1 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-4.1-answer-key.md
- B04.M16
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: course_internal
---
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

| Hostname (expected) | IP address  | Username | Password           | Connection                      |
| ------------------- | ----------- | -------- | ------------------ | ------------------------------- |
| `emu-41`            | 20.30.40.41 | `badguy` | `1qaz2wsx!QAZ@WSX` | `evil-winrm` / WinRM (TCP 5985) |

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

| Challenge | Code word key | Hiera key | Default value |
| --- | --- | --- | --- |
| 1 (Secret discovery) | `secret_flag` | `cs_ops::lab_4_1::flags::secret_flag` | `MORNING-EMBER` |
| 2 (System function) | `function_flag` | `cs_ops::lab_4_1::flags::function_flag` | `HARBOR-CIPHER` |
| 3 (Tool execution) | `tool_exec_flag` | `cs_ops::lab_4_1::flags::tool_exec_flag` | `FALCON-NOVA` |
| 4 (Infil/exfil) | `infil_exfil_flag` | `cs_ops::lab_4_1::flags::infil_exfil_flag` | `RIVER-SHADOW` |
| 5 (IOC cleanup) | `ioc_cleanup_flag` | `cs_ops::lab_4_1::flags::ioc_cleanup_flag` | `SILENT-ORBIT` |

## Flag Output Locations (Default Build)

| Challenge | Where the flag is written on-system | How it gets written |
| --- | --- | --- |
| 1 | `C:\ProgramData\WindowsTelemetry\profiles\active-sync.ini` | Puppet writes the active secret artifact directly. |
| 2 | `C:\ProgramData\WindowsTelemetry\reports\normalized-sync.log` | Collector script writes report output. |
| 3 | `C:\ProgramData\WindowsTelemetry\logs\approved-tool.log` | Wrapper script appends execution proof lines. |
| 4 | `C:\ProgramData\WindowsTelemetry\transfer\outbound\sync-bundle.txt` | Transfer processor script writes outbound artifact. |
| 5 | `C:\ProgramData\WindowsTelemetry\reports\cleanup-status.txt` | Cleanup verification script writes verification results. |

Instructor note:

- In this lab, flags are primarily recovered from files generated or updated by challenge workflows (not guaranteed to print to console). If paths are rotated in Hiera, grade against the configured equivalents.

## Environment and Tunables (Quick Table)

| Area | Hiera key(s) | Defaults used in walkthrough |
| --- | --- | --- |
| Root path set | `cs_ops::lab_4_1::paths::*` | `C:\ProgramData\WindowsTelemetry\...` |
| Challenge 2 task | `cs_ops::lab_4_1::challenge2::task_*` | `ProfileSyncTelemetry`, every 15 min |
| Challenge 2 service metadata | `cs_ops::lab_4_1::challenge2::service_*` | `ProfileSyncBroker` / `Profile Sync Broker` |
| Challenge 3 gate | `cs_ops::lab_4_1::challenge3::*` | allow path `...\approved-bin`, blocked `C:\Users\Public`, `C:\Temp` |
| Challenge 4 naming rule | `cs_ops::lab_4_1::challenge4::required_name_pattern` | `ops-*.dat` |
| Challenge 5 cleanup targets | `cs_ops::lab_4_1::challenge5::*` | remove required line markers, remove tracked files, remove configured flag files |

## Recommended Instructor Walkthrough

### 1. Connect and run situational awareness baseline

From the ops station, land the WinRM session:

```bash
evil-winrm -i 20.30.40.41 -u badguy -p '1qaz2wsx!QAZ@WSX'
```

Connect notes:

- `evil-winrm` opens an interactive WinRM shell to the target.
- `-i` is the target IP, `-u` / `-p` are the Access-table credentials (quote the password for shell safety).
- Expected default identity after connect: `badguy` on `emu-41` (or the range-rotated equivalents).

Inside the evil-winrm session (PowerShell-capable), collect the SA baseline before challenge hunting:

```text
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

```text
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

```text
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

```text
[sync]
label=profile_master_token
value=VX-ALPHA-9341
status=active
objective_flag=MORNING-EMBER
```

Expected `rotation-state.json` output:

```json
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

```text
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

```json
{
  "role": "Profile Synchronization and Audit Telemetry",
  "collector_mode": "profile-normalization",
  "source_patterns": ["Credentials", "Login Data", "Vault"],
  "output_profile": "ops_sync_v3",
  "decoy_mode": "compliance-only"
}
```

Expected `normalized-sync.log` excerpt:

```text
[<timestamp>] pipeline_stage=normalization
[<timestamp>] source_type=credential_material
[<timestamp>] objective_flag=HARBOR-CIPHER
```

Expected `compliance-audit.log` output:

```text
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

```text
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

```text
Use Invoke-ApprovedTool.ps1 with a custom script placed in this directory.
```

Expected `approved-tool.log` excerpt:

```text
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

```text
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

```text
Place inbound file using naming pattern: ops-*.dat
```

Expected `sync-bundle.txt` excerpt after processing:

```text
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

| Check | Prior student action that created the dirt | Artifact to clean | Clean means |
| --- | --- | --- | --- |
| c1 | Challenge 3: ran `Invoke-ApprovedTool.ps1` successfully; wrapper appended an IOC-style line | `logs\session-trace.log` line containing `cleanup_ioc=wrapper-executed` | That line is gone; the log file still exists |
| c2 | Challenge 3: student created and executed `approved-bin\student-tool.ps1` through the wrapper; wrapper recorded that path | Leftover payload file (corroborated in `reports\cleanup-delete-targets.txt`) | Tracked payload path(s) deleted |
| c3 | Challenge 4: student dropped inbound file and ran the transfer processor; processor copied to `transfer\processed\...` and recorded MTIME | Processed file named in `reports\cleanup-timestamp-target.txt` | `LastWriteTimeUtc` no longer matches recorded ticks |
| c4 | Challenges 2–4: student recovered flags from workflow outputs that still contain `objective_flag=` | Default: `reports\normalized-sync.log`, `logs\approved-tool.log`, `transfer\outbound\sync-bundle.txt` | Those flag-bearing files are deleted after the flags are recorded |

Instructor note on c4: wiping flag carriers after collection is scored lab anti-forensics, not a realistic “only delete the implant” SOP. Call that out so students understand why this category feels different from c1–c3.

#### Discovery before edits

```text
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

```text
# session-trace.log — caused by Challenge 3 wrapper success
[<timestamp>] cleanup_ioc=wrapper-executed tool=C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1 mode=path-gate
```

```text
# cleanup-delete-targets.txt — caused by Challenge 3 recording the tool path it executed
C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1
```

```text
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

```text
findstr /V "cleanup_ioc=wrapper-executed" "C:\ProgramData\WindowsTelemetry\logs\session-trace.log" > "C:\ProgramData\WindowsTelemetry\logs\session-trace.tmp"
del "C:\ProgramData\WindowsTelemetry\logs\session-trace.log"
move /Y "C:\ProgramData\WindowsTelemetry\logs\session-trace.tmp" "C:\ProgramData\WindowsTelemetry\logs\session-trace.log"
```

`findstr /V` prints lines that do **not** contain the search string. If the shell is pure PowerShell and `del`/`move /Y` misbehave, use the same three steps via `cmd /c` or `Remove-Item` / `Move-Item -Force`.

**c2 — delete leftover Challenge 3 payload**

- Caused by: Challenge 3 student action of creating `student-tool.ps1` under `approved-bin` and executing it through the wrapper (wrapper also listed that path in `cleanup-delete-targets.txt`).
- Delete the payload you dropped; the tracker file is corroboration, not a separate mystery target.

```text
Remove-Item 'C:\ProgramData\WindowsTelemetry\approved-bin\student-tool.ps1' -Force
```

**c3 — timestomp Challenge 4 processed transfer file**

- Caused by: Challenge 4 student action of placing the inbound file and running the transfer processor (processor copied ingress → `transfer\processed\ops-briefing.dat` and recorded that file’s UTC ticks).
- Change MTIME so it no longer matches the recorded baseline (classic timestomp / anti-forensics on the artifact you just created).

```text
$f = Get-Item 'C:\ProgramData\WindowsTelemetry\transfer\processed\ops-briefing.dat'
$f.LastWriteTime = (Get-Date).AddDays(-2)
```

**c4 — wipe flag-bearing workflow outputs after flags are recorded**

- Caused by:
  - Challenge 2 collector writing `objective_flag=` into `reports\normalized-sync.log`,
  - Challenge 3 wrapper writing `objective_flag=` into `logs\approved-tool.log`,
  - Challenge 4 processor writing `objective_flag=` into `transfer\outbound\sync-bundle.txt`.
- Record those flag values first, then delete the carriers so the verifier cannot re-read them on disk.

```text
Remove-Item 'C:\ProgramData\WindowsTelemetry\reports\normalized-sync.log' -Force
Remove-Item 'C:\ProgramData\WindowsTelemetry\logs\approved-tool.log' -Force
Remove-Item 'C:\ProgramData\WindowsTelemetry\transfer\outbound\sync-bundle.txt' -Force
```

#### Verify

```text
powershell -NoProfile -ExecutionPolicy Bypass -File 'C:\ProgramData\WindowsTelemetry\tasks\Test-CleanupState.ps1'
Get-Content 'C:\ProgramData\WindowsTelemetry\reports\cleanup-status.txt'
```

Expected findings:

- Verification shows all categories satisfied (`c1=0`, `c2=0`, `c3=0`, `c4=0`).
- The flag appears only when all four pass in the same run.
- Any unmet category leaves that `cN=1`.

Expected `cleanup-status.txt` after success:

```text
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

- If `evil-winrm` fails, confirm the ops-station path, target IP, TCP 5985, and Access-table credentials versus any range-rotated values. Treat RDP as fallback only when the range card assigns it.
- If `AMServiceEnabled` / `RealTimeProtectionEnabled` are False or `ExclusionPath` is empty, do **not** stall Challenge 1. Use Step 1 `ALLUSERSPROFILE` → `Get-ChildItem C:\ProgramData` → `WindowsTelemetry`. Puppet is intended to enable Defender and seed the exclusion on a healthy deploy; restore that optional pivot only after WinDefend/AM is actually running.
- If Defender blocks a tool or script when AM is enabled, treat that as lab friction. Use exclusion or ProgramData evidence to locate the operational root; do not disable Defender.
- If students cannot find Challenge 1 artifacts, have them re-list `C:\ProgramData`, then sibling directories under `WindowsTelemetry` (`profiles`, `config`, `logs`, `reports`) before guessing paths.
- If `Invoke-ApprovedTool.ps1` fails with `Missing expression after ','` near `'C:\Temp',`, that is a Windows PowerShell 5.1 parse error from a trailing comma in the `$blockedRoots = @(...)` array (Puppet template bug). On a live host before redeploy, remove the trailing comma after the last blocked path so the array closes like `  'C:\Temp'` then `)`, then re-run the wrapper. Fixed builds render the array without a trailing comma.
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
