---
id: B03.M05.lab-4.2-answer-key
title: Lab 4.2 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-4.2-answer-key.md
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
  - SYSTEM-level native Windows context validation before retrieving restricted artifacts.

Primary access method: split-port raw TCP shell from the student operations station to the assigned target. Accept `nc`, `ncat`, `socat`, or equivalent TCP client tooling. The default range card exposes `ewe-42` at `20.30.40.42` with TCP `4420` as the lower input lane and TCP `4421` as the higher output/error lane. If values are rotated, grade against the assigned host and the configured Hiera values, not the defaults below.

## Access

| Hostname (expected) | IP address  | Username | Password | Connection |
| ------------------- | ----------- | -------- | -------- | ---------- |
| `ewe-42`            | 20.30.40.42 | N/A      | N/A      | Two manual TCP sessions: TCP 4420 lower input lane first, then TCP 4421 higher output/error lane |

If the instructor or range card provides a different host or port pair, use those assigned values.

## Flag Reference

| Challenge | Code word key | Hiera key | Default value |
| --- | --- | --- | --- |
| 1 (Session wiring) | `challenge1_flag` | `cs_ops::lab_4_2::flags::challenge1_flag` | `FORKLINE-TRACE` |
| 2 (Boundary proof + pivot) | `challenge2_flag` | `cs_ops::lab_4_2::flags::challenge2_flag` | `BOUNDARY-LENS` |
| 3 (ADS discovery) | `challenge3_flag` | `cs_ops::lab_4_2::flags::challenge3_flag` | `STREAM-CACHE` |
| 4 (SYSTEM context) | `challenge4_flag` | `cs_ops::lab_4_2::flags::challenge4_flag` | `ELEVATED-ROOT` |

## Flag Output Locations (Default Build)

These locations are instructor reference values. Students should reach them through the discovery steps in the walkthrough, not from prior knowledge of this table.

| Challenge | Where the flag is written on-system | How it gets written |
| --- | --- | --- |
| 1 | `/opt/system-health/bin/flag.txt` | Puppet deploys a code-word file in the split-shell working directory. |
| 2 | `C:\ProgramData\DeviceCache\reports\session-index.txt` | Puppet seeds Windows artifact; Linux hint file points to it. |
| 3 | `C:\ProgramData\DeviceCache\reports\inventory.dat:diagcache` | Puppet writes the flag into an NTFS alternate data stream. |
| 4 | `C:\ProgramData\DeviceCache\store\health.index` | Puppet writes the flag and applies restricted ACLs. |

## Environment and Tunables (Quick Table)

| Area | Hiera key(s) | Defaults used in walkthrough |
| --- | --- | --- |
| Split entry ports | `cs_ops::lab_4_2::ports::*` | `4420` input, `4421` output/error |
| Windows remote exposure | `cs_ops::lab_4_2::portproxy::*` | listen `0.0.0.0`, WSL iface `eth0`, firewall rule `Lab4.2 Split Bridge 4420-4421` |
| Bridge task account | `cs_ops::lab_4_2::challenge1::autostart_task_user` | `SYSTEM` |
| Bridge task password | `cs_ops::lab_4_2::challenge1::autostart_task_password` | Required when task user is non-`SYSTEM` (defaults to `cs_ops::base::hunter_password`) |
| WSL distro targeting | `cs_ops::lab_4_2::challenge1::wsl_distribution` | `DEFAULT` resolves current default distro and launcher still passes `--distribution` explicitly |
| WSL executable path | `cs_ops::lab_4_2::challenge1::wsl_executable` | `C:\Windows\System32\wsl.exe` |
| Bridge rearm delay | `cs_ops::lab_4_2::challenge1::rearm_delay_seconds` | `90` seconds before relistening after bridge exit/disconnect |
| Artifact locations | `cs_ops::lab_4_2::paths::*` | `C:\ProgramData\DeviceCache\...`, `/opt/system-health/...` |
| ADS stream name | `cs_ops::lab_4_2::challenge3::ads_stream_name` | `diagcache` |
| SYSTEM context marker | `cs_ops::lab_4_2::challenge4::required_owner` | `SYSTEM` |

## Target Access Enablement

- Environment type: hybrid Windows VM with WSL2 and Windows `portproxy` forwarding to a WSL-hosted split-port bridge.
- Primary student method: split-port raw TCP shell using two manual TCP client sessions.
- Student fallback methods: none. Connection sequencing is part of objective validation; do not replace it with RDP, WinRM, SSH, or a wrapper shell for student grading.
- Instructor management access: RDP or WinRM to the Windows VM is acceptable for pre-demo checks, reset, and troubleshooting only.
- Target-side enablement: `cs_ops::lab_4_2` creates Windows and WSL artifact directories, seeds challenge artifacts, deploys the Python bridge and PowerShell launcher, registers the autostart scheduled task, configures Windows `portproxy`, and opens the configured inbound firewall ports.
- Ops-station requirements: `nc`, `ncat`, `socat`, or equivalent TCP client tooling capable of holding two independent sessions open.
- Network assumptions: the assigned target host is reachable from the student ops station on the configured lower input port and higher output/error port.
- Access validation: connect lower lane first and higher lane second, send `echo stdout_probe`, and confirm the output appears on the higher lane.
- Reset/cleanup: restart the VM or rerun the bridge launcher task after the configured rearm delay; for persistent lab drift, reapply Puppet for `cs_ops::lab_4_2` from a clean baseline.

## Instructor Pre-Demo Confirmation

Goal: confirm the split-port bridge is active and inspect custom tooling before relying on it in a live demo.

Run these checks from an instructor Windows session on the target VM:

```text
Get-Content 'C:\ProgramData\cs_ops\lab_4_2_applied'
Get-Content 'C:\ProgramData\DeviceCache\tools\Start-SplitBridge.ps1' -TotalCount 120
Get-Content 'C:\ProgramData\DeviceCache\tools\split-io-bridge.py' -TotalCount 120
Get-ScheduledTask -TaskName 'DeviceCacheSplitBridge'
netstat -ano | findstr ":4420"
netstat -ano | findstr ":4421"
netsh interface portproxy show v4tov4
Get-NetFirewallRule -DisplayName 'Lab4.2 Split Bridge 4420-4421'
```

First-use notes:

- `Get-Content` reads concise text files or script previews. Here it verifies the Puppet marker and lets instructors inspect the PowerShell launcher and Python bridge before students use them.
- `Get-ScheduledTask` confirms the bridge is registered to start automatically. The default task name comes from `cs_ops::lab_4_2::challenge1::autostart_task_name`.
- `netstat -ano` confirms TCP listeners and owning PIDs for the configured split ports.
- `netsh interface portproxy show v4tov4` confirms Windows forwards the externally reachable ports to the active WSL address.
- `Get-NetFirewallRule` confirms the inbound firewall rule exists for the configured port pair. The default display name comes from Hiera and may be rotated.

Expected findings:

- Lab marker file exists and names the target host where Puppet applied.
- Launcher configures Windows portproxy and firewall state, resolves the WSL distribution, and starts the WSL bridge.
- Python bridge accepts one input connection and one output connection, then launches `/bin/bash -i` in the configured working directory.
- Both default ports show listening sockets, and `portproxy` includes forwarding entries for `0.0.0.0:4420` and `0.0.0.0:4421`.

Instructor teaching point: if students connect to only one port, they may type commands but not see complete command feedback.

## Recommended Instructor Walkthrough

### 1. Connect the split-port shell and run situational awareness baseline

Goal: establish operating context before challenge grading or split-port troubleshooting.

Student-side setup from the operations station:

```text
# Session A: lower input lane, using assigned host and lower port.
nc <assigned_target_ip_or_hostname> 4420

# Session B: higher output/error lane, using assigned host and higher port.
nc <assigned_target_ip_or_hostname> 4421
```

How students know these values:

- The target host and initial port pair come from the range card. They are access values, not challenge solutions.
- The lower/higher lane roles come from the student handout and are confirmed behaviorally: commands typed into the lower lane produce output on the higher lane only after both sessions are connected.

Run these commands by typing them into Session A and reading the output from Session B:

```text
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

```text
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

```text
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

```text
stdout_probe
/opt/system-health/bin
total ...
... flag.txt
ls: cannot access '/does/not/exist': No such file or directory
flag=FORKLINE-TRACE
```

Expected `cat flag.txt` output:

```text
flag=FORKLINE-TRACE
```

Grading checkpoint:

- Require the flag plus evidence that stdout and stderr were observed from the higher port lane.
- Accept rotated flag values if the student shows the same directory enumeration and split-lane evidence.

---

### 3. Prove the Linux/Windows boundary (Challenge 2)

Goal: identify environment by evidence and perform a Linux-to-Windows path pivot from a discovered hint.

Discovery-first sequence:

```text
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

```text
Linux version ... microsoft-standard-WSL2 ...
```

Expected `cat ../state/flag-hint.txt` output:

```text
The flag for challenge 2 is in C:\ProgramData\DeviceCache\reports\session-index.txt
```

Expected `cat /mnt/c/ProgramData/DeviceCache/reports/session-index.txt` output:

```text
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

```text
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

```text
inventory snapshot generated
challenge3_note=objective is stored in an NTFS alternate data stream on this file
```

Expected stream enumeration snippet:

```text
Stream     Length
------     ------
:$DATA         ...
diagcache      ...
```

Expected ADS output:

```text
flag=STREAM-CACHE
```

Alternate discovery path:

```text
powershell.exe -NoProfile -Command "cmd /c dir /r C:\ProgramData\DeviceCache\reports"
```

Use this alternate if students know Windows `dir /r`; it should still follow the same evidence chain: reports directory observed, base file read, stream metadata enumerated, then stream content retrieved.

Grading checkpoint:

- Require the flag and explicit evidence showing stream enumeration or another valid ADS discovery method.
- Do not require the default stream name if Hiera rotated `cs_ops::lab_4_2::challenge3::ads_stream_name`; require that the student used the stream name discovered on the host.

---

### 5. Transition to SYSTEM context (Challenge 4)

Goal: move from Linux-side shell context into native Windows command execution, validate SYSTEM-level context, and retrieve restricted file content from a discovered Windows artifact root.

Current implementation note: this lab implementation exposes Windows command execution through `powershell.exe` from the split shell. It does not define a separate Meterpreter handoff in the Puppet class. If an instructor adds a range-specific Meterpreter transition, grade the same evidence requirements: native Windows execution, SYSTEM context proof, ACL evidence, and discovered restricted artifact retrieval.

Discovery-first sequence:

```text
powershell.exe -NoProfile -Command "whoami"
powershell.exe -NoProfile -Command "whoami /all"
powershell.exe -NoProfile -Command "Get-ChildItem -Path 'C:\ProgramData\DeviceCache' -Force | Format-Table Name,Mode"
powershell.exe -NoProfile -Command "Get-ChildItem -Path 'C:\ProgramData\DeviceCache\store' -Force | Format-Table Name,Length,Mode"
powershell.exe -NoProfile -Command "Get-Acl -Path 'C:\ProgramData\DeviceCache\store\health.index' | Format-List Owner,AccessToString"
powershell.exe -NoProfile -Command "Get-Content -Path 'C:\ProgramData\DeviceCache\store\health.index'"
```

How students know each value:

- `powershell.exe` is justified by the WSL boundary evidence from Challenge 2 and by the course expectation to test native Windows interop from a Linux-side context.
- `whoami` confirms the Windows identity returned by native Windows execution.
- `whoami /all` expands identity evidence to groups and privileges. This is needed because the objective requires SYSTEM-level native Windows context, not only file path knowledge.
- `C:\ProgramData\DeviceCache` is known from the Challenge 2 hint and Challenge 3 reports path. Enumerating that root is ordinary Windows artifact triage.
- `store` is discovered as a sibling directory during root enumeration.
- `health.index` is discovered by enumerating `store`.
- `Get-Acl` is run before `Get-Content` so students can explain why access depends on SYSTEM context.

Expected `Get-ChildItem 'C:\ProgramData\DeviceCache'` snippet:

```text
Name     Mode
----     ----
reports  d-----
runtime  d-----
store    d-----
tools    d-----
```

Expected `Get-ChildItem 'C:\ProgramData\DeviceCache\store'` snippet:

```text
Name          Length Mode
----          ------ ----
health.index  ...    -a----
```

Expected ACL snippet:

```text
Owner          : ...
AccessToString : NT AUTHORITY\SYSTEM Allow  Read...
```

Expected flag output:

```text
flag=ELEVATED-ROOT
owner_required=SYSTEM
```

Expected findings:

- The student proves native Windows command execution from the Linux-side shell.
- The student presents effective-context evidence with `whoami /all`.
- Directory and ACL enumeration explain why the restricted artifact matters and why SYSTEM-level native Windows context is part of the objective.

Grading checkpoint:

- Require the flag plus evidence of SYSTEM-level access, not just file path knowledge.
- Require a discovery chain from the previously identified Windows root to `store` to `health.index`.

### 6. Close with the host-purpose summary

Students should be able to conclude that this host is a hybrid Windows/WSL operations surface providing at least:
- A split-port shell that requires both TCP lanes for a usable session
- Linux-side context with a recoverable Windows boundary (`/mnt/c`, `powershell.exe`, WSL clues)
- Windows artifacts under an operational ProgramData root, including an NTFS alternate data stream
- SYSTEM-level native Windows context as a requirement for a restricted file, not just a path to type

That is the picture this lab is trying to build: prove the session wiring, prove the boundary, then recover Windows artifacts with the matching execution context.

## Troubleshooting and Confirmation

- If typing appears to do nothing, confirm both lanes are connected. Session A should connect to the lower input port, and Session B should connect to the higher output/error port.
- If output appears in the same terminal where commands are typed, the student may be using a different service or a tool that merged streams. Reconnect with two plain TCP sessions.
- If either port refuses connections, wait the configured rearm delay, then have an instructor confirm the scheduled task, listener state, portproxy entries, and firewall rule with the pre-demo checks.
- If `uname` or `/proc/version` does not show WSL clues, require students to collect alternative boundary evidence such as `/mnt/c`, `powershell.exe -NoProfile -Command "whoami"`, or Windows path accessibility before proceeding.
- If `/mnt/c` is missing, the WSL distro or mount configuration is not in the expected lab state. Instructors should reset/reapply the VM rather than giving students direct paths.
- If `Get-Item -Stream *` does not show an extra stream, verify the ADS seed step ran and that the target file is on NTFS, not copied to a filesystem that strips streams.
- If `Get-Content -Stream` fails with access or stream-not-found errors, have students re-run stream enumeration and use the observed stream name.
- If the restricted file can be read without SYSTEM-context evidence, grade cautiously and inspect ACL state with `Get-Acl`; the intended objective requires SYSTEM context proof.

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
- Challenge 4 includes native Windows execution proof, SYSTEM context evidence, ACL evidence, and discovered restricted-artifact retrieval.

Partial credit:

- flag recovered with weak context evidence,
- strong methodology but stale path assumptions,
- one challenge incomplete with otherwise correct workflow.
