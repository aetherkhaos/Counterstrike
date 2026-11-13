---
id: B03.M03.lab-2.1-answer-key
title: Lab 2.1 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-2.1-answer-key.md
- B04.M14
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: course_internal
---
# Lab 2.1 — Chroot Jail from Constrained Shell — Answer Key (Instructor Only)

Use this as a live walkthrough. Students begin from the same constrained shell entry point, prove the chroot context from evidence, adapt to missing tools, and recover four flags through filesystem inspection, compressed/binary clue handling, loopback services, and `/proc` process context.

## Access

| Hostname (expected) | IP address  | Username            | Password | Connection                                   |
| ------------------- | ----------- | ------------------- | -------- | -------------------------------------------- |
| `collie-21`         | 20.30.40.21 | N/A (shell service) | N/A      | TCP shell service (default often TCP `4444`) |

If the instructor or range card provides a different target or port, use those assigned values.

## Flag Reference

| Flag ID | Default recovery source | Hiera key | Default value |
|--------|--------------------------|-----------|---------------|
| `hidden_flag` | Decode encoded content from a clue file in the starting directory using the custom decoder named in the compressed usage note | `cs_ops::lab_2_1::flags::hidden_flag` | `SHADOW-LOCKET` |
| `parsing_flag` | Reconstruct from keep-state file references listed in `/opt/lab21/notes/fragments.txt` | `cs_ops::lab_2_1::flags::parsing_flag` plus `cs_ops::lab_2_1::parsing_fragments` | `FRACTAL-LENS` |
| `loopback_flag` | Response from the host loopback TCP service after sending `1234` to `127.0.0.1:4545` | `cs_ops::lab_2_1::flags::loopback_flag` | `ORBIT-CIRCUIT` |
| `procfs_flag` | Response from the host loopback TCP service after sending the parent-process token from `/proc/$PPID/environ` to `127.0.0.1:4646` | `cs_ops::lab_2_1::flags::procfs_flag` | `KESTREL-THREAD` |

Related tunables:

| Setting | Purpose | Default |
|---------|---------|---------|
| `cs_ops::lab_2_1::hidden_flag_file_name` | File name created in the starting directory for hidden-flag decode input | `cache.id` |
| `cs_ops::lab_2_1::hidden_flag_encoded` | Encoded value stored in that file; it should decode to `hidden_flag` | `ZOHKVD-SVJRLA` |
| `cs_ops::lab_2_1::loopback_flag_port` | Loopback service for the fixed-input flag | `4545` |
| `cs_ops::lab_2_1::procfs_flag_port` | Loopback service for the parent-environment token flag | `4646` |
| `cs_ops::lab_2_1::paths` | README, clue chain, decoder, compressed note, and fragment-reference paths | See `environments/week3_repo/vms/puppet/data/nodes/lab_2_1.yaml` |

## Recommended Instructor Walkthrough

### 1. Connect using the constrained shell path

From the instructor attack host:

```bash
nc <target-ip> 4444
```

If `nc` is unavailable:

```bash
socat - TCP:<target-ip>:4444
```

Why this matters:
- This mirrors the student starting point exactly: no SSH login, no pre-built TTY.
- The lab rewards context discovery after access, not credential guessing.

### 2. Establish situational awareness baseline

Run:

```bash
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

```bash
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

```bash
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

```bash
find / -maxdepth 2 -type f 2>/dev/null
grep -R "flag" /opt 2>/dev/null
ls -la
sed -n '1,120p' README.first
```

Why this matters:
- `find`, `grep`, and `file` are intentionally absent in the jail.
- The student handout no longer gives flag-specific clues; `README.first` is the student-facing instruction surface after access.

Expected `sed -n '1,120p' README.first` output:

```text
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

```bash
ls -la /usr/share/doc/base-files
sed -n '1,120p' /usr/share/doc/base-files/runtime-notes
```

Expected output:

```text
Runtime package note
The maintenance cache map is stored at /var/lib/dpkg/info/.cache.map.
Strip NUL bytes from it to reveal NEXT_HINT.
```

Why this matters:
- This replaces the old direct `.cache` clue. Students must follow a file in another accessible directory before reaching the binary artifact.
- The note tells them to expect non-text data, so blindly dumping the file is not the only reasonable path.

### 7. Extract the embedded string from the binary-looking file

Run:

```bash
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

```text
NEXT_HINT=/var/log/apt/term.log.1.gz
```

How students know this command is justified:
- Step 6 `runtime-notes` explicitly says to strip NUL bytes and look for `NEXT_HINT`.
- `tr` is part of the limited baseline toolset and can delete a specific byte value without `strings`, `grep`, or `file`.

### 8. Read the compressed usage note and inspect the decoder

Run:

```bash
gzip -dc /var/log/apt/term.log.1.gz
command -v restore-cache
sed -n '1,120p' "$(command -v restore-cache)"
ls -la
sed -n '1,5p' cache.id
```

Expected compressed note:

```text
Cache recovery usage
The decoder command is on PATH as restore-cache.
Example: restore-cache cache.id
```

Expected decoder excerpt:

```sh
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

```text
cache.id
README.first
notes
```

Expected `sed -n '1,5p' cache.id` output:

```text
ZOHKVD-SVJRLA
```

Why this matters:
- The compressed file gives an example, but students still need to verify the helper before executing it.
- The filename in the sample usage matches a file in the starting directory, guiding students to pass that name.

Recover the flag:

```bash
restore-cache cache.id
```

Expected output:

```text
SHADOW-LOCKET
```

Flag recovered:
- `hidden_flag` = `SHADOW-LOCKET` by default.

### 9. Recover the reconstruction flag from distributed file references

Run:

```bash
sed -n '1,120p' /opt/lab21/notes/fragments.txt
```

Expected output:

```text
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

```bash
sed -n '1,20p' /etc/apt/preferences.d/00-cache-state
sed -n '1,20p' /usr/share/doc/bash/inputrc.sample
sed -n '1,20p' /var/lib/dpkg/info/base-files.list.d
sed -n '1,20p' /var/tmp/.font-unix-cache
sed -n '1,20p' /usr/share/common-licenses/.runtime-index
```

Expected output excerpts:

```text
fragment=FRA
fragment=CTAL
fragment=-LENS
fragment=DECOY-
fragment=IGNORE
```

Assemble the keep-state fragments in slot order:

```bash
p01="$(sed -n 's/^fragment=//p' /etc/apt/preferences.d/00-cache-state)"
p02="$(sed -n 's/^fragment=//p' /usr/share/doc/bash/inputrc.sample)"
p03="$(sed -n 's/^fragment=//p' /var/lib/dpkg/info/base-files.list.d)"
printf '%s%s%s\n' "$p01" "$p02" "$p03"
```

Expected output:

```text
FRACTAL-LENS
```

Flag recovered:
- `parsing_flag` = `FRACTAL-LENS` by default.

### 10. Recover the loopback TCP flag

Return to the Step 5 `README.first` line: query the loopback-only TCP service at `127.0.0.1:4545` and send exactly `1234` followed by a newline. That is how students know the address, port, and payload. Step 2 `ss`/`netstat` cannot prove this listener; those tools are missing in the jail, and a remote scan from Kali will not see a `127.0.0.1` bind.

The login shell is `/bin/sh`. `sh` cannot open `/dev/tcp`. `/bin/bash` is in the chroot. `/dev/tcp/HOST/PORT` is a bash built-in, not a real file: opening it creates a TCP client. `nc` is typically missing too, so bash is the reliable sender.

```bash
bash -c 'exec 3<>/dev/tcp/127.0.0.1/4545; printf "1234\n" >&3; head -n 1 <&3'
```

First-use notes:
- `bash -c '...'` runs one bash snippet from the `sh` jail shell.
- `exec 3<>/dev/tcp/127.0.0.1/4545` attaches file descriptor `3` read/write (`<>`) to a TCP client socket on loopback port `4545`.
- `printf "1234\n" >&3` writes the README payload to that socket.
- `head -n 1 <&3` reads one line of the service response.

If `nc` happens to be present, this is also acceptable:

```bash
printf '1234\n' | nc 127.0.0.1 4545
```

Expected response:

```text
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

```bash
echo $PPID
```

Expected: a numeric PID (value varies per session). That number is the parent of this interactive `sh`. The token is in the parent environment (the bind-shell/socat service), not in this shell’s own `env`.

Read that parent environment. `/proc/<pid>/environ` is NUL-separated; `tr` turns NULs into newlines so it is readable:

```bash
tr '\0' '\n' < /proc/$PPID/environ
```

Expected environment excerpt:

```text
LAB21_SESSION_TOKEN=toortoor
```

Capture the token, then reuse the Step 10 `/dev/tcp` pattern against port **4646**, sending the token plus newline (not `1234`):

```bash
TOKEN="$(tr '\0' '\n' < /proc/$PPID/environ | sed -n 's/^LAB21_SESSION_TOKEN=//p')"
bash -c 'exec 3<>/dev/tcp/127.0.0.1/4646; printf "%s\n" "'"$TOKEN"'" >&3; head -n 1 <&3'
```

How students know these values:
- Path `/proc/$PPID/environ`, variable `LAB21_SESSION_TOKEN`, host `127.0.0.1`, and port `4646` come from `README.first`.
- The `bash -c` / `/dev/tcp` method is the same adaptation as Step 10 because `nc`/`ss` are still unavailable.

Expected service response:

```text
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
