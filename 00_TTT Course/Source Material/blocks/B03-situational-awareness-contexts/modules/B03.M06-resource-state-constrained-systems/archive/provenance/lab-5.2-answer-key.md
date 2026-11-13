---
id: B03.M06.lab-5.2-answer-key
title: Lab 5.2 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-5.2-answer-key.md
- B04.M17
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: course_internal
---
# Lab 5.2 — Unstable System (Battery Drain) — Answer Key (Instructor Only)

Use this as a live walkthrough. The grading objective is flag recovery under frequent reboots, plus reconstruction of the composite flag from per-cycle telemetry segments.

## Objective Framing

Students connect to a system that appears to have a dying battery. It reboots every few minutes, and the SSH port changes (range 2200–2299) on each cycle. The five primary evidence categories mirror B03.M02 Lab 1.1 and B03.M06 Lab 5.1 (process, log, user, port, config), but locations differ and every flag artifact includes a base64 telemetry segment. Collecting all five segments from the same boot cycle allows reconstruction of a sixth composite flag.

## Access

| Hostname (expected) | IP address  | Username | Password         | Connection                          |
| ------------------- | ----------- | -------- | ---------------- | ----------------------------------- |
| `fowl-52`           | 20.30.40.52 | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 2200-2299, rotating)       |

If the instructor or range card provides a different login or port range, use those assigned values.

## Flag Reference

| Flag ID | Expected evidence source | Hiera key | Default value |
|---------|--------------------------|-----------|---------------|
| `process_flag` | telemetry env file (`/etc/default/power-health`) and timer-spawned process environment | `cs_ops::lab_5_2::flags::process_flag` | `DRIFT-BEACON` |
| `log_flag` | power manager event log (`/var/log/power-manager/health.log`) | `cs_ops::lab_5_2::flags::log_flag` | `STATIC-PULSE` |
| `user_flag` | `pwrmgr` home artifact (`/home/pwrmgr/.health-note`) | `cs_ops::lab_5_2::flags::user_flag` | `COPPER-NEEDLE` |
| `port_flag` | SSH banner shown at login (`/etc/ssh/issue.power`) | `cs_ops::lab_5_2::flags::port_flag` | `GLASS-RELAY` |
| `config_flag` | power management policy (`/etc/power-manager/runtime-policy.conf`) | `cs_ops::lab_5_2::flags::config_flag` | `CARBON-LATTICE` |
| `composite_flag` | reconstructed from all five base64 telemetry segments | `cs_ops::lab_5_2::flags::composite_flag` | `PHANTOM-NEXUS` |

Additional tunables:
- `cs_ops::lab_5_2::reboot_minutes` — minutes between boot and hard reboot (default `5`).
- `cs_ops::lab_5_2::battery_start_pct` — simulated starting battery percentage (default `15`).
- `cs_ops::lab_5_2::port_range` — SSH port rotation range (default `min: 2200`, `max: 2299`).
- `cs_ops::lab_5_2::crypto` — encrypted runtime-secret settings (`cipher`, `kdf_iterations`, `key_value`).
- `cs_ops::lab_5_2::boot_order` — systemd ordering gates (`puppet_service_unit`, `ssh_service_unit`, `sshd_service_unit`).

Related implementation paths:
- `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_5_2.pp`
- `environments/week3_repo/vms/puppet/data/nodes/lab_5_2.yaml`

## Implementation Reference

- **Boot-init service** (`power-bootstrap.service`): oneshot that runs on each boot, picks a random SSH port, generates the per-cycle gzipped composite payload, splits it into five base64 segments, and writes all flag artifacts with their segments.
- **Secret handling**: primary/composite flags are encrypted at rest in `runtime.secrets.enc` (path tunable via Hiera). Bootstrap decrypts with `runtime.key`, then deletes `runtime.key` after successful decrypt. Puppet restores the correct key only once per reboot using a `/dev/shm` sentinel.
- **Battery-sim service** (`power-watchdog.service`): runs after boot-init, simulates battery drain from `battery_start_pct` to 0% over `reboot_minutes`, writes to `/dev/kmsg` (dmesg), journal (`upower`/`acpid`/`systemd-logind` tags), wall messages at critical thresholds, and triggers `sysrq b` at 0%.
- **Telemetry timer** (`power-health.timer`): fires every 2 minutes; the associated service runs `sleep 45` with `PROCESS_FLAG`, `TELEMETRY_SEGMENT_INDEX`, and `TELEMETRY_SEGMENT` in its environment (visible via `ps eww` or `/proc/PID/environ`).
- **Fake `acpi`** (`/usr/local/bin/acpi`): reads `/run/powerd/BAT0` and outputs standard `acpi -b` format.
- **Mounted power-supply simulation** (`/sys/class/power_supply`): boot-init prepares a simulated power-supply tree under `/run/powerd/sysfs/power_supply` and bind-mounts it onto `/sys/class/power_supply` so direct sysfs checks align with the battery-drain scenario.
- **Startup order:** `puppet.service` (or override) -> `power-bootstrap.service` -> `ssh.service`/`sshd.service` -> `power-watchdog.service`.
- **Maintenance:** To stop reboots temporarily, `systemctl mask power-watchdog.service`, or disable `power-bootstrap.service`. To find the current SSH port after a reboot: `cat /run/powerd/ssh_port` or re-scan.

## Recommended Instructor Walkthrough

### 1. Discover the rotating SSH port, connect, and run situational awareness baseline

From the student workstation:

```bash
nmap -sS -p 2200-2299 <target-ip> --open
ssh -p <discovered-port> badguy@<target-ip>
```

Expected findings:
- Exactly one port in the 2200–2299 range is open (SSH). The port changes after every reboot.

Run immediately after login:

```bash
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
ps aux | sed -n '1,40p'
free -h
acpi
ss -tulpen
ss -tunap
```

Why this matters:
- Anchors remote time, identity, shell/process context, and OS/runtime details.
- `acpi` shows simulated battery status — students observe the battery draining and can estimate remaining time.
- `ss -tulpen` confirms SSH is on the discovered port; no other unexpected listeners.
- Students must work fast; the system will hard-reboot when the battery simulation reaches 0%.

Expected `acpi` output (example at ~12%):

```text
Battery 0: Discharging, 12%, 00:03:00 remaining
```

Teaching point:
- Port scanning is the first obstacle each cycle. Students should script this for efficiency across reboots.

### 2. Recover `port_flag` (segment 4 of 5)

The SSH banner is displayed at connection time. Students can also read it from disk:

```bash
grep '^Banner ' /etc/ssh/sshd_config
cat /etc/ssh/issue.power
```

Expected `cat /etc/ssh/issue.power` output:

```text
Power management endpoint GLASS-RELAY
--- telemetry segment 4 of 5 ---
<base64 data>
```

How students know this value (transition reasoning):
- From Step 1, students already know SSH is the active entry point on the rotating port. Standard SSH-service triage is to inspect `sshd_config`, which directly reveals the banner file path.
- The banner shown at login and the configured `Banner` path are two independent evidence sources that converge on the same token/segment location.

### 3. Discover the timer path and inspect unit definitions for `process_flag`

After the SSH-facing artifact, pivot to host-side schedulers. `systemctl list-timers` is the systemd equivalent of cron triage from earlier labs. Inspect the linked timer and service once in this step. This is discovery, not process-flag recovery.

```bash
systemctl list-timers --all --no-pager
systemctl cat power-health.timer --no-pager -l
systemctl cat power-health.service --no-pager -l
```

`systemctl list-timers` shows scheduled units. `--all` includes timers that have not fired yet; `--no-pager` keeps output on the terminal during a short session. `systemctl cat` prints the unit file systemd loaded, including drop-ins.

Expected `list-timers` findings:
- `power-health.timer` is active and firing frequently (`OnUnitActiveSec=2min` is visible from NEXT/LAST).
- Mapping: `power-health.timer` -> `power-health.service`.

Expected `systemctl cat power-health.timer` output:

```text
# /etc/systemd/system/power-health.timer
[Unit]
Description=Power telemetry collection timer

[Timer]
OnBootSec=30
OnUnitActiveSec=2min
Unit=power-health.service

[Install]
WantedBy=timers.target
```

Expected `systemctl cat power-health.service` output:

```text
# /etc/systemd/system/power-health.service
[Unit]
Description=Power telemetry collection

[Service]
Type=oneshot
EnvironmentFile=/etc/default/power-health
ExecStart=/bin/sh -c 'exec env PROCESS_FLAG="$PROCESS_FLAG" TELEMETRY_SEGMENT="$TELEMETRY_SEGMENT" sleep 45'
```

How students know this value (transition reasoning):
- Recurring activity is the next hunt family after the login banner (process/schedule), matching B03.M02 Lab 1.1 and B03.M06 Lab 5.1.
- Timer -> service -> `EnvironmentFile=/etc/default/power-health` is the evidence-backed path for the next read. Do not guess that path.

### 4. Recover `process_flag` (segment 1 of 5) from the referenced environment file

```bash
cat /etc/default/power-health
```

Expected output:

```text
PROCESS_FLAG=DRIFT-BEACON
TELEMETRY_SEGMENT_INDEX=1
TELEMETRY_SEGMENT=H4sI...
TELEMETRY_SEGMENT_1_OF_5=H4sI...
```

Segment 1 of the concatenated blob starts with `H4sI`. That prefix is the usual gzip-then-base64 signature (`1f 8b 08`). Note it here; Step 9 uses it during reconstruction. Do not gunzip a single segment.

Optional runtime confirmation while the timer job is active (`PROCESS_FLAG` is already named in `ExecStart`):

```bash
ps eww | grep PROCESS_FLAG
```

How students know this value (transition reasoning):
- Step 3 produced a concrete `EnvironmentFile` path, so reading `/etc/default/power-health` follows from unit evidence.
- The optional `ps eww` check confirms the static file matches the live process environment.

### 5. Follow the `/etc` evidence trail from timer artifacts to policy/config

Start broad, then narrow:

```bash
find /etc -type d -name '*power*'
stat /etc/default/power-health /etc/power-manager
find /etc/power-manager -ls
```

Expected findings:
- `/etc/power-manager` exists and is updated in the same boot window as timer artifacts.
- Contents include `runtime-policy.conf`, `runtime.conf`, and encrypted/key material files.

How students know this value (transition reasoning):
- From Step 4, students hold one confirmed `/etc` power artifact. Enumerate nearby config namespaces before targeting specific files.
- `find` + `stat` + directory listing justifies which config files belong to this boot cycle.

### 6. Recover `config_flag` (segment 5 of 5); note bootstrap crypto (not the composite path)

```bash
cat /etc/power-manager/runtime-policy.conf
cat /etc/power-manager/runtime.conf
```

Expected `cat /etc/power-manager/runtime-policy.conf` output:

```text
# Power management policy
SHUTDOWN_THRESHOLD=5
DRAIN_RATE=normal
POWER_TOKEN=CARBON-LATTICE
TELEMETRY_SEGMENT_INDEX=5
TELEMETRY_SEGMENT=<base64 data>
TELEMETRY_SEGMENT_5_OF_5=<base64 data>
```

Expected `cat /etc/power-manager/runtime.conf` output:

```text
# Lab 5.2 boot configuration (managed by Puppet — do not edit)
SECRET_BUNDLE_FILE=/etc/power-manager/runtime.secrets.enc
SECRET_KEY_FILE=/etc/power-manager/runtime.key
SECRET_CIPHER=aes-256-cbc
SECRET_KDF_ITERATIONS=200000
```

Instructor note: `runtime.conf` is bootstrap context. It explains how `power-bootstrap` decrypts runtime secrets at boot. It is not required to recover any of the six flags, and it is not the composite reconstruction path. Do not decrypt `runtime.secrets.enc` for the composite flag. Composite recovery uses the five telemetry segments only.

How students know this value (transition reasoning):
- Step 5 established `/etc/power-manager` as the adjacent config root, so `runtime-policy.conf` and `runtime.conf` are evidence-selected targets.
- Policy content yields `config_flag` and segment 5. `runtime.conf` is adjacent metadata, not the next flag source.

### 7. Pivot to runtime outputs and recover `log_flag` (segment 2 of 5)

```bash
ls -lart /var/log
ls -lart /var/log/power-manager/
cat /var/log/power-manager/health.log
```

Expected `cat /var/log/power-manager/health.log` output:

```text
[2026-04-13T14:23:45Z] power-manager[1234]: battery subsystem initialized
[2026-04-13T14:23:45Z] power-manager[1234]: UPS health check completed — token STATIC-PULSE
[2026-04-13T14:23:45Z] power-manager[1234]: telemetry segment 2/5: <base64 data>
```

How students know this value (transition reasoning):
- After static/unit analysis in Steps 3-6, the next standard move is runtime verification in logs to confirm what executed this cycle.
- `/var/log/power-manager/health.log` follows the same service-family naming already seen in timer and config artifacts.
- The initial `/var/log` listing is the broad triage step; read `health.log` only after the power-manager log directory is discovered.

### 8. Pivot to service-account artifacts and recover `user_flag` (segment 3 of 5)

```bash
getent passwd
getent passwd pwrmgr
ls -lart /home/pwrmgr/
cat /home/pwrmgr/.health-note
```

Expected `getent passwd pwrmgr` excerpt:
- Account `pwrmgr` exists with home `/home/pwrmgr` and non-login shell.

Expected `cat /home/pwrmgr/.health-note` output:

```text
COPPER-NEEDLE
--- telemetry segment 3 of 5 ---
<base64 data>
```

How students know this value (transition reasoning):
- Steps 3-7 establish a service-driven workflow; a normal next pivot is owning/related service accounts and their local artifacts.
- `getent passwd` narrows to `pwrmgr`, and the discovered home directory justifies checking `.health-note` for the user-domain segment.
- The `pwrmgr` account is also present in Hiera defaults, but students should justify it from `getent passwd` during the live walkthrough.

### 9. Reconstruct the composite flag

A long demo of Steps 2-8 often spans reboots. All five telemetry segments must come from **one boot cycle**. Mixing segments from earlier steps with a later login yields decode/decompression errors.

Reconnect one last time and recapture all five known artifacts in one sitting. This is a timed collection pass, not a rediscovery hunt. Paths are already justified by Steps 2-8.

```bash
nmap -sS -p 2200-2299 <target-ip> --open
ssh -p <discovered-port> badguy@<target-ip>
cat /etc/default/power-health
cat /var/log/power-manager/health.log
cat /home/pwrmgr/.health-note
cat /etc/ssh/issue.power
cat /etc/power-manager/runtime-policy.conf
```

Copy the five segment strings and their indices before leaving the host. Do not mix these values with notes from earlier steps.

Expected recapture sources (same as Steps 2, 4, 6, 7, and 8):
- Segment 1: `/etc/default/power-health` (`TELEMETRY_SEGMENT_INDEX=1`; blob starts with `H4sI`)
- Segment 2: `/var/log/power-manager/health.log` (`telemetry segment 2/5`)
- Segment 3: `/home/pwrmgr/.health-note` (`telemetry segment 3 of 5`)
- Segment 4: `/etc/ssh/issue.power` (`telemetry segment 4 of 5`)
- Segment 5: `/etc/power-manager/runtime-policy.conf` (`TELEMETRY_SEGMENT_INDEX=5`)

Concatenate in index order (1 through 5). Segment indices discovered in each source provide the sequence.

```bash
P1="<segment 1 from /etc/default/power-health>"
P2="<segment 2 from /var/log/power-manager/health.log>"
P3="<segment 3 from /home/pwrmgr/.health-note>"
P4="<segment 4 from /etc/ssh/issue.power>"
P5="<segment 5 from /etc/power-manager/runtime-policy.conf>"
FULL="${P1}${P2}${P3}${P4}${P5}"
printf '%s' "$FULL" | cut -c1-4
```

`cut -c1-4` prints the first four characters of the rebuilt blob. Expected: `H4sI`. That prefix is visible on segment 1 alone and on the concatenated string. It is the common gzip-then-base64 signature, not plaintext base64.

Decode only, then identify the bytes before decompressing:

```bash
printf '%s' "$FULL" | base64 -d > /tmp/telemetry.bin
file /tmp/telemetry.bin
xxd -l 8 /tmp/telemetry.bin
```

`base64 -d` decodes the concatenated alphabet to raw bytes (`-d` = decode). `file` reports the observed format. `xxd -l 8` hex-dumps the first 8 bytes so the magic is visible without paging a full dump.

Expected `file` output:

```text
/tmp/telemetry.bin: gzip compressed data
```

Expected `xxd` excerpt:

```text
00000000: 1f8b 08.. .... ....
```

`1f 8b` is the gzip magic; `08` is the deflate method. That is the evidence for `gunzip`. If `file` is missing, the `xxd` magic is sufficient.

```bash
gunzip -c /tmp/telemetry.bin
```

`gunzip` inflates a gzip member. `-c` writes plaintext to stdout and leaves `/tmp/telemetry.bin` in place. Use it here because the decoded bytes are gzip, not the `BOOT_TS`/`COMPOSITE_FLAG` text.

Expected output:

```text
BOOT_TS=2026-04-13T14:23:45Z
COMPOSITE_FLAG=PHANTOM-NEXUS
```

Teaching point:
- Base64 is obvious from the segment alphabet. Gzip is not labeled on the five artifacts; it is inferred from `H4sI` and from `1f 8b` after decode.
- The payload is boot-specific. Same-cycle recapture in this step is what makes reconstruction succeed after a long walkthrough.
- `BOOT_TS` in the decompressed plaintext matches the log timestamp from the same cycle.

### 10. Observe battery simulation evidence

Students can investigate why the system keeps rebooting:

```bash
acpi
cat /sys/class/power_supply/README.md
cat /sys/class/power_supply/BAT0/status
cat /sys/class/power_supply/BAT0/capacity
cat /sys/class/power_supply/AC*/online
dmesg | grep -i battery
journalctl -t upower --no-pager
journalctl -t systemd-logind --no-pager
```

Expected `dmesg` excerpt:

```text
[  ...] ACPI: Battery Slot [BAT0] (battery present)
[  ...] ACPI: Battery [BAT0]: design capacity 4400 mAh
[  ...] ACPI: Battery [BAT0]: discharging, capacity=12% remaining=6019mWh rate=15201mW
```

Expected `cat /sys/class/power_supply/README.md` output:

```text
Battery telemetry in this path is intentionally simulated for Lab 5.2.
Your validation is correct: the exercise expects you to treat this state as operationally real.
```

Expected journal entries include `upower` daemon messages showing battery percentage decreasing and `systemd-logind` critical-threshold warnings.

Teaching point:
- Understanding the reboot mechanism is not required for flag recovery, but investigating it demonstrates strong situational awareness. The battery simulation writes realistic ACPI kernel messages, upower journal entries, and wall warnings.

### 11. Close with the host-purpose summary

Students should be able to conclude that this is an unstable Linux host providing at least:
- Rotating SSH on `2200–2299` with a short battery-simulated reboot cycle
- The same five evidence families as B03.M02 Lab 1.1 and B03.M06 Lab 5.1 (process, log, user, port, config), each carrying a same-cycle telemetry segment
- A composite flag that only reconstructs from one boot cycle’s segments
- Operational battery/ACPI evidence that explains the reboot pressure without being required for flag credit

That is the picture this lab is trying to build: scan, login, collect fast, keep same-cycle discipline, then reconstruct.

## Troubleshooting and Confirmation

- If no SSH port is open in `2200–2299`, wait for the current reboot cycle to finish and rescan. The port changes every boot.
- If SSH fails after a scan hit, the host may have rebooted between scan and connect. Rescan and use Access-table credentials (`badguy`) versus any range-rotated values.
- If the session dies mid-collection, restart from Step 1. Do not mix telemetry segments from different boot cycles.
- If composite reconstruct fails (gzip/decode errors), segments were mixed across boots or concatenated out of index order. Repeat the Step 9 recapture: reconnect once, recapture all five segments, then decode and inspect magic bytes before `gunzip`.
- If `base64 -d` yields binary that `file`/`xxd` do not identify as gzip (`1f 8b`), the concatenation is incomplete or out of order. Recapture from one login and confirm segment 1 / `$FULL` starts with `H4sI`.
- Decrypting `runtime.secrets.enc` is not a composite-flag path. Return to the five telemetry segments.
- If `acpi` or `/sys/class/power_supply` looks empty, confirm the battery simulation services are running (`power-bootstrap`, `power-watchdog`) rather than treating the host as a normal laptop.
- If recovered flag strings differ from this key, grade the Hiera values for that run, not the defaults table.

## Grading Checkpoints

Full credit:
- Student recovers all five primary flag values with correct evidence sources.
- Student reconstructs the composite flag from all five segments collected in one boot cycle.
- Student demonstrates efficient port-scanning and fast-enumeration workflow under time pressure.

Partial credit:
- Three to four primary flags with clear evidence, but composite flag not recovered (segments from mixed cycles or incomplete collection).
- All five primary flags recovered but composite reconstruction attempted incorrectly.

Low credit:
- One to two flags with weak or no evidence.
- No attempt at composite flag recovery.
- Focuses only on battery investigation without objective completion.

## Acceptable Answers

- Require exact string match for each flag token unless instructors intentionally override values in Hiera.
- Accept either direct file evidence or equivalent command output (for example `ps eww` output for `process_flag`, login banner capture for `port_flag`).
- For the composite flag, accept any working reconstruction method (piped commands, script, manual concatenation) as long as the final value matches.
- Students who identify the battery simulation mechanism (fake acpi, sysrq reboot, systemd services) earn situational-awareness credit even if not explicitly required.
