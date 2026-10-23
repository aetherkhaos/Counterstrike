# Ferret and Fowl Student Brief

## Objective

This module develops adaptive enumeration in environments with resource starvation and frequent state resets. Students should maintain evidence quality while operating under unstable execution conditions and strict time pressure.

## Context

You will work in low-resource and reset-prone systems where timing and adaptation matter. Use disciplined prioritization to collect high-value evidence quickly and maintain traceable flag-recovery chains under unstable conditions.

## Tasks

### The Starving System (Low Resources)

### Environment

A low-resource VM is provided (for example 128-256 MB RAM and/or one vCPU). Student access is through an intentionally constrained shell listener, and command execution may fail intermittently.

Expected flags: 6.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`ferret-51`|20.30.40.51|N/A|N/A|Netcat shell (TCP 2222)|

### Tasks

1. Establish constrained-session context and validate unstable execution behavior.
2. Recover all six lab flags from native host evidence categories: process/schedule, logs, user/account, port/service, configuration, and encrypted relay analysis.
3. For the encrypted relay objective, discover the correct decryption key from native host evidence, decrypt the large artifact, and recover the flag from plaintext.
4. Record the evidence path for each flag and include at least one adaptation example from a failed/interrupted attempts.

#### Clues and constraints

- One flag is tied to scheduled execution behavior rather than always-on process state.
- One flag is tied to an operations-style log entry related to transient failure/recovery; follow maintenance/scheduler naming from cron into `/var/log` rather than searching blindly.
- One flag is associated with a non-login account and related home/user artifacts.
- One flag can be inferred from standard SSH service metadata on port `22`.
- One flag is in a small runtime configuration containing recovery-oriented key/value settings.
- One flag requires decrypting a large encrypted relay artifact; the matching key material is discoverable from normal host-side operational artifacts.

#### Report and submission

Submit all six recovered flags, the exact evidence source for each, and a short explanation of how you adapted to unreliable execution and memory pressure. Follow instructor assessment criteria for final format.

### The Unstable System (Frequent Resets)

### Environment

The host resets frequently and powers off without warning. Each reboot changes the SSH port. This lab uses the same five evidence categories as Boar and Bull and Ferret and Fowl, but requires rapid recovery under reboot pressure.

Expected flags: 6 total, including five primary flags and one composite bonus flag.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`fowl-52`|20.30.40.52|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 2200-2299, rotating)|

### Tasks

1. Scan TCP ports 2200-2299 to identify the current SSH listener before each session.
2. Connect and prioritize high-yield evidence collection before the next reset.
3. Recover all five primary flags from process/schedule, log, user/account, port/service, and configuration evidence.
4. Collect telemetry segments 1 through 5 from the same reboot cycle.
5. Reconstruct the composite bonus flag from the five ordered segments.

#### Clues and constraints

- Each primary flag source includes the flag value and a telemetry line (for example `telemetry segment N of 5: <base64 data>`).
- All five telemetry segments must come from the same boot cycle; mixed-cycle segments produce corrupt output.
- Discovery methodology is consistent with Boar and Bull and Ferret and Fowl, but artifact locations and formats differ.
- Runtime bootstrap metadata may reference encrypted-secret inputs, but flags are recovered from native process/log/user/port/config evidence artifacts.
- Battery/failure narrative signals are operationally relevant and should guide prioritization.

#### Report and submission

Submit all five primary flags, the reconstructed composite flag, the evidence source for each, and a brief explanation of time-management strategy under reset pressure.

### Composite reconstruction reference

```
# 1) Concatenate segments 1 through 5 in order with no separators.
FULL="<segment1><segment2><segment3><segment4><segment5>"
# 2) Decode and decompress.
echo "$FULL" | base64 -d | gunzip
# 3) Output contains the composite flag value.
```

## Deliverables / Evidence

- Submit six flags for The Starving System and six outcomes for The Unstable System (five primary plus composite), with exact evidence source for each.
- Include adaptation evidence for unstable execution and reset pressure.
- Document the ordered reconstruction process used for the composite objective.

## Constraints

- Prioritize high-yield evidence first in unstable or reset-prone sessions.
- Keep telemetry segments from a single reboot cycle for composite reconstruction.
- Capture at least one failed/interrupted attempt and the adaptation used to recover.

## Success Criteria

You successfully complete this Module when all objectives are recovered under resource/reset pressure with traceable evidence, timing discipline, and correct composite reconstruction.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Ferret and Fowl — Instructor Answer Key

## lab 5.1 answer key

# Lab 5.1 - Low Resources with Unreliable Exec - Answer Key (Instructor Only)

Use this for live delivery. The grading objective is complete flag recovery under unstable execution conditions, not exhaustive root-cause analysis of every limit.

## Objective Framing

Students work from a constrained listener session (TCP `2222`, commonly via `nc`) where command execution can fail intermittently. They earn credit by adapting and recovering all six flags, including the encrypted relay objective.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`ferret-51`|20.30.40.51|N/A|N/A|Netcat shell (TCP 2222)|

If the instructor or range card provides a different target or port, use those assigned values.

## Flag Reference

|Flag ID|Expected evidence source|Hiera key|Default value|
|---|---|---|---|
|`process_flag`|cron entry (`/etc/cron.d/system-maint`)|`cs_ops::lab_5_1::flags::process_flag`|`EMBER-SWITCH`|
|`log_flag`|maintenance log (`/var/log/maintenance/agent.log`)|`cs_ops::lab_5_1::flags::log_flag`|`DUSK-THREAD`|
|`user_flag`|`opssync` account metadata and note file|`cs_ops::lab_5_1::flags::user_flag`|`MINT-LATTICE`|
|`port_flag`|SSH banner path from `sshd_config` and banner content (`/etc/ssh/issue.net`)|`cs_ops::lab_5_1::flags::port_flag`|`RIVER-PATH`|
|`config_flag`|recovery-agent runtime config (`/etc/recovery-agent/default.conf`)|`cs_ops::lab_5_1::flags::config_flag`|`STONE-VAULT`|
|`crypto_flag`|decrypted relay payload + correlated campaign key evidence|`cs_ops::lab_5_1::flags::crypto_flag`|`EMBER-LOCKBOX`|

Related implementation/tunable paths:

- `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_5_1.pp`
- `environments/week3_repo/vms/puppet/data/nodes/lab_5_1.yaml`
- `cs_ops::lab_5_1::student_shell` (`port`, `listen_address`, `service_name`)
- `cs_ops::lab_5_1::random_exec` (`enabled`, `deny_percent`, `time_bucket_seconds`, `cg_fragment`)
- `cs_ops::lab_5_1::ransomware` (`campaign_id`, `key_alias`, `decrypt_key`, `payload_size_mb`)

## Recommended Instructor Walkthrough

### 1. Connect the constrained listener and run situational awareness baseline

From the ops station:

```
nc <target-ip> 2222
```

If `nc` is unavailable:

```
socat - TCP:<target-ip>:2222
```

Run this from the student session before deep triage:

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
cat /etc/os-release
who
w
ps aux | sed -n '1,40p'
free -h
ss -tulpen
ss -tunap
```

Why this matters:

- Anchors remote time, host identity, user/session state, shell context, and OS/runtime details.
- Captures active users plus listening/established TCP+UDP sockets.
- Creates a stable baseline before transient exec failures start affecting output quality.
- Failed or truncated commands are still evidence of the resource constraint.

Walkthrough flag order matches the student clue list and Flag Reference: process → log → user → port → config → crypto.

### 2. Recover `process_flag` by discovering scheduler artifacts

Do not jump directly to one file; show where scheduled jobs can live, then manually review likely candidates before filtering:

```
cat /etc/crontab
ls -l /etc/cron.d
ls -l /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly
ls -l /var/spool/cron /var/spool/cron/crontabs
systemctl list-timers --all --no-pager
# Manual review first: read full content of suspicious scheduler files.
cat /etc/cron.d/system-maint
# Optional after review: if many files are noisy, narrow with a targeted search
# based on strings already observed in candidate files.
# grep -R -nE '<observed-token-1>|<observed-token-2>' /etc/crontab /etc/cron.d /var/spool/cron /var/spool/cron/crontabs 2>/dev/null
```

Expected `cat /etc/cron.d/system-maint` output:

```
*/8 * * * * root env MAINT_TOKEN="EMBER-SWITCH" /usr/bin/logger -t maint-check heartbeat >/dev/null 2>&1
```

How students know this value:

- Schedule evidence is found by triaging standard cron/timer locations, manually reviewing likely jobs, then optionally filtering only after concrete clues appear.
- Record the maint naming now (`system-maint`, `MAINT_TOKEN`, `maint-check`); Step 3 uses that bridge into logs.

### 3. Recover `log_flag` by following maintenance naming from cron into `/var/log`

Do not treat `/var/log` as a blind haystack. Step 2 already exposed maintenance/scheduler naming; use that to justify the next directory:

```
ls -ld /var/log
ls -l /var/log
# Optional after the listing if noise is high and Step 2 names are already known:
# ls -l /var/log | grep -i maint
ls -l /var/log/maintenance
# Manual review first: read the operations log the directory listing exposes.
cat /var/log/maintenance/agent.log
# Optional after review: filter by terms from the student clue or lines already seen.
# grep -nEi 'transient|recovery|fault' /var/log/maintenance/agent.log
```

Expected `cat /var/log/maintenance/agent.log` output:

```
[2026-01-10 03:41:00] recovery scheduler resumed after transient fault DUSK-THREAD
[2026-01-10 03:44:10] exfil relay campaign RAVEN-BRIDGE staged archive /var/spool/recovery/outbound/telemetry-archive.enc
```

How students know this value:

- Cron evidence (`system-maint` / `maint-check`) justifies looking under `/var/log` for a non-default `maintenance` directory (same name-correlation pattern as Lab 1.1 `syswatch`).
- The student clue (“transient failure/recovery”) matches wording already in `agent.log`; use it to recognize the right line after the file is found, not as a first-pass recursive grep for the flag token.
- Cron’s `logger -t maint-check` may also appear in syslog; the graded artifact is the operations `agent.log` line carrying `log_flag`.

### 4. Recover `user_flag` by enumerating accounts

List all accounts from the name service (local and any configured backends):

```
getent passwd
```

Expected excerpt — the flag is already plain in the `opssync` GECOS/comment field:

```
opssync:x:1003:1003:Auxiliary sync operator MINT-LATTICE:/home/opssync:/bin/bash
```

Optional corroboration only (same token; not required to discover the flag):

```
ls -la /home/opssync
cat /home/opssync/notice.txt
```

Expected `cat /home/opssync/notice.txt` output:

```
MINT-LATTICE
```

How students know this value:

- Full `getent passwd` is the standard way to enumerate accounts regardless of where they are stored.
- The non-login ops-style account stands out on review; its comment field carries `user_flag` without further filtering.
- Home-directory reads are optional confirmation after that line is already visible.

### 5. Recover `port_flag` from SSH service metadata

Start from standard SSH config discovery (Step 1 `ss` already showed a listener on port `22`):

```
cat /etc/ssh/sshd_config
# Optional after manual review: narrow to the active SSH settings.
grep -E '^(Port|Banner)\b' /etc/ssh/sshd_config
ss -tulpen | grep ':22'
cat /etc/ssh/issue.net
```

Expected `cat /etc/ssh/issue.net` output:

```
Remote maintenance endpoint token RIVER-PATH
```

How students know this value:

- `Banner` path is discoverable in standard `sshd_config`, then validated from the referenced file. The `grep` is optional noise reduction after students have established that `sshd_config` is the authoritative SSH service config.

### 6. Recover `config_flag` by surveying `/etc` first

Start with directory-level clues, manually identify suspicious entries, then inspect the most relevant config:

```
ls -l /etc
# Manual review: look for service-style names that stand out (for example
# recovery-agent). Optional only if /etc listing is too noisy:
# ls -l /etc | grep -Ei '<observed-clue-1>|<observed-clue-2>'
ls -l /etc/recovery-agent
cat /etc/recovery-agent/default.conf
```

Expected `cat /etc/recovery-agent/default.conf` output:

```
RETRY_WINDOW=5
RECOVERY_TOKEN=STONE-VAULT
KEY_INDEX=/var/lib/recovery-agent/key-cache.db
```

How students know this value:

- `/etc` discovery reveals a service-style config directory (`recovery-agent`) and naturally leads to runtime token settings.
- Keep this directory in view for Steps 7–8 (transfer profile and decrypt tool paths live here too).

### 7. Inspect crypto evidence before execution

Continue from Step 6 `/etc/recovery-agent` discovery and gather campaign/key/tool metadata:

```
cat /etc/recovery-agent/transfer.conf
cat /var/lib/recovery-agent/key-cache.db
```

Expected `cat /etc/recovery-agent/transfer.conf` output:

```
CAMPAIGN_ID=RAVEN-BRIDGE
KEY_ALIAS=sync-relay
KEY_DB=/var/lib/recovery-agent/key-cache.db
PAYLOAD_FILE=/var/spool/recovery/outbound/telemetry-archive.enc
DECRYPT_TOOL=/usr/local/bin/incident-decrypt
```

Expected `cat /var/lib/recovery-agent/key-cache.db` excerpt:

```
campaign_id,key_alias,key_material,last_seen
RAVEN-BRIDGE,sync-relay,q7v9c2u4m1r8t6p3,2026-01-10T03:42:11Z
```

How students know these values:

- `transfer.conf` is a native runtime profile that exposes campaign, key DB, payload, and tool path.
- Key material is discoverable by correlating `CAMPAIGN_ID` and `KEY_ALIAS` with a row in the key database.

### 8. Recover `crypto_flag` with pre-execution inspection and adaptive execution

Before running a custom binary/script, inspect usage and do a quick script sanity check:

```
tool="$(awk -F= '/^DECRYPT_TOOL=/{print $2}' /etc/recovery-agent/transfer.conf)"
file "$tool"
sed -n '1,120p' "$tool"
# Instructor note: read this section with students and call out:
# - argparse flags (`--input`, `--key`, `--mode`, `--search`)
# - default bulk execution path vs legacy compatibility stream mode
"$tool" --help
```

Assemble `--input` and `--key` from Step 7 (`PAYLOAD_FILE` + RAVEN-BRIDGE / `sync-relay` key material). Run bulk first:

```
incident-decrypt --input /var/spool/recovery/outbound/telemetry-archive.enc --key q7v9c2u4m1r8t6p3
```

Expected teaching point:

- Full decrypted output is far too large for the constrained session and typically kills or floods the buffer.
- Do not invent a filter string. Step 6 already showed `RECOVERY_TOKEN=STONE-VAULT` in `default.conf`, and `--help`/source already showed `--search`. Search on the observed term `token`:

```
incident-decrypt --input /var/spool/recovery/outbound/telemetry-archive.enc --key q7v9c2u4m1r8t6p3 --search token
```

Expected filtered output:

```
2026-01-10T03:44:31Z campaign=RAVEN-BRIDGE stream=relay outcome=decrypted evidence_token=EMBER-LOCKBOX
```

If bulk still OOMs before filtering helps, use stream mode with the same evidence-backed search string:

```
incident-decrypt --input /var/spool/recovery/outbound/telemetry-archive.enc --key q7v9c2u4m1r8t6p3 --mode stream --search token
```

How students know this command structure:

- `DECRYPT_TOOL` and `PAYLOAD_FILE` come from `transfer.conf`.
- Key material comes from key DB correlation to `CAMPAIGN_ID`/`KEY_ALIAS`, not a decoy campaign row.
- `--search` comes from pre-execution inspection (`--help` / source), not from the answer key.
- The search string `token` is justified by Step 6 `RECOVERY_TOKEN=...`, not by knowing the plaintext field will be named `evidence_token=`.

### 9. Close with the host-purpose summary

Students should be able to conclude that this is a resource-starved Linux host providing at least:

- A constrained non-SSH listener on TCP `2222` with intermittent exec failures
- Scheduler and maintenance-log evidence tied by naming (`system-maint` → `/var/log/maintenance`)
- A non-login ops account, SSH banner metadata on port `22`, and recovery-agent runtime config
- An encrypted relay objective that requires inspecting tools and inputs before execution

That is the picture this lab is trying to build: keep evidence quality while adapting to failed commands, then recover all six flags in clue order.

## Troubleshooting and Confirmation

Use this section when demos fail intermittently or learners ask for confirmation evidence.

### A) Confirm constrained-shell service identity and cgroup limits

Run as `root` (or `sudo`) on the target VM:

```
svc="$(systemctl list-units --type=service --all --no-legend | awk '/remote-assist-shell/{print $1; exit}')"
pid="$(systemctl show -p MainPID --value "$svc")"
cg="$(awk -F: 'NR==1{print $3}' "/proc/$pid/cgroup")"
echo "service=$svc pid=$pid cgroup=$cg"
systemctl show "$svc" -p MemoryMax -p MemoryHigh -p MemoryCurrent
for f in memory.max memory.high memory.current memory.events; do
  p="/sys/fs/cgroup$cg/$f"
  [ -r "$p" ] && { echo "--- $f ---"; cat "$p"; }
done
```

Expected findings:

- `MemoryMax`/`MemoryHigh` from `systemctl show` match `memory.max`/`memory.high`.
- `MemoryCurrent` and `memory.current` move with workload.
- `memory.events` increments `high` and/or `max` during stressed runs.

Example evidence:

```
service=remote-assist-shell.service pid=68826 cgroup=/system.slice/remote-assist-shell.service
MemoryCurrent=6205440
MemoryHigh=4194304
MemoryMax=6291456
```

Teaching note:

- `free` shows host memory, not cgroup-visible limits, so it is not sufficient proof by itself.

### B) Optional stress probe and retry pattern

Run this from the constrained student session, then re-check cgroup counters above:

```
python3 -c 'a=[]; [a.append(bytearray(1024*1024)) for _ in range(256)]'
```

Use lightweight retries during live instruction:

```
for f in /etc/ssh/issue.net /etc/cron.d/system-maint /var/log/maintenance/agent.log /etc/recovery-agent/default.conf /home/opssync/notice.txt; do
  for i in 1 2 3 4 5; do
    cat "$f" && break || sleep 1
  done
done
```

Expected behavior:

- Some attempts may fail with `Resource temporarily unavailable`.
- Short retries on small, targeted reads usually recover complete evidence.

### C) `incident-decrypt` failures

- If the tool throws `TypeError: unsupported operand type(s) for |: 'type' and 'NoneType'`, the deployed script used Python 3.10-only `str | None` annotations on an older `python3`. Redeploy the fixed module file (`Optional[str]`) via Puppet, or replace `/usr/local/lib/cs-ops/lab_5_1_ransom_decrypt.py` with the corrected source.
- If decrypt runs but output is garbage / no usable lines, the key is wrong. Correlate `CAMPAIGN_ID` / `KEY_ALIAS` from `transfer.conf` to the matching row in `key-cache.db` (default: RAVEN-BRIDGE / `sync-relay` → `q7v9c2u4m1r8t6p3`). Do not use decoy campaign keys.
- If bulk decrypt floods or kills the constrained-session buffer, re-run with `--search token`. That string is justified by Step 6 `RECOVERY_TOKEN=...` plus `--search` from pre-exec help/source—not by jumping to `evidence_token=`.

## Grading Checkpoints

Full credit:

- Student recovers all six exact flag values.
- Student demonstrates retry-aware workflow for unstable execution.
- Student demonstrates adaptive low-memory handling for encrypted relay decryption/search.
- Student cites native evidence sources for each flag.

Partial credit:

- Four to five correct flags with clear evidence and reasonable adaptation.
- Correct workflow but incomplete encrypted-relay retrieval due to instability.

Low credit:

- One to three flags with weak/no evidence.
- Focuses on environment complaints without objective completion.

## Acceptable Answers

- Require exact match for each flag token unless instructors intentionally rotate values in Hiera.
- Accept direct file evidence or equivalent command output that proves the same value.

## lab 5.2 answer key

# Lab 5.2 — Unstable System (Battery Drain) — Answer Key (Instructor Only)

Use this as a live walkthrough. The grading objective is flag recovery under frequent reboots, plus reconstruction of the composite flag from per-cycle telemetry segments.

## Objective Framing

Students connect to a system that appears to have a dying battery. It reboots every few minutes, and the SSH port changes (range 2200–2299) on each cycle. The five primary evidence categories mirror B03.M02 Lab 1.1 and B03.M06 Lab 5.1 (process, log, user, port, config), but locations differ and every flag artifact includes a base64 telemetry segment. Collecting all five segments from the same boot cycle allows reconstruction of a sixth composite flag.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`fowl-52`|20.30.40.52|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 2200-2299, rotating)|

If the instructor or range card provides a different login or port range, use those assigned values.

## Flag Reference

|Flag ID|Expected evidence source|Hiera key|Default value|
|---|---|---|---|
|`process_flag`|telemetry env file (`/etc/default/power-health`) and timer-spawned process environment|`cs_ops::lab_5_2::flags::process_flag`|`DRIFT-BEACON`|
|`log_flag`|power manager event log (`/var/log/power-manager/health.log`)|`cs_ops::lab_5_2::flags::log_flag`|`STATIC-PULSE`|
|`user_flag`|`pwrmgr` home artifact (`/home/pwrmgr/.health-note`)|`cs_ops::lab_5_2::flags::user_flag`|`COPPER-NEEDLE`|
|`port_flag`|SSH banner shown at login (`/etc/ssh/issue.power`)|`cs_ops::lab_5_2::flags::port_flag`|`GLASS-RELAY`|
|`config_flag`|power management policy (`/etc/power-manager/runtime-policy.conf`)|`cs_ops::lab_5_2::flags::config_flag`|`CARBON-LATTICE`|
|`composite_flag`|reconstructed from all five base64 telemetry segments|`cs_ops::lab_5_2::flags::composite_flag`|`PHANTOM-NEXUS`|

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

```
nmap -sS -p 2200-2299 <target-ip> --open
ssh -p <discovered-port> badguy@<target-ip>
```

Expected findings:

- Exactly one port in the 2200–2299 range is open (SSH). The port changes after every reboot.

Run immediately after login:

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

```
Battery 0: Discharging, 12%, 00:03:00 remaining
```

Teaching point:

- Port scanning is the first obstacle each cycle. Students should script this for efficiency across reboots.

### 2. Recover `port_flag` (segment 4 of 5)

The SSH banner is displayed at connection time. Students can also read it from disk:

```
grep '^Banner ' /etc/ssh/sshd_config
cat /etc/ssh/issue.power
```

Expected `cat /etc/ssh/issue.power` output:

```
Power management endpoint GLASS-RELAY
--- telemetry segment 4 of 5 ---
<base64 data>
```

How students know this value (transition reasoning):

- From Step 1, students already know SSH is the active entry point on the rotating port. Standard SSH-service triage is to inspect `sshd_config`, which directly reveals the banner file path.
- The banner shown at login and the configured `Banner` path are two independent evidence sources that converge on the same token/segment location.

### 3. Discover the timer path for `process_flag`

```
systemctl list-timers --all --no-pager
systemctl cat power-health.service --no-pager -l
```

Expected `systemctl cat power-health.service` excerpt:

```
[Service]
Type=oneshot
EnvironmentFile=/etc/default/power-health
ExecStart=/bin/sh -c 'exec env PROCESS_FLAG="$PROCESS_FLAG" TELEMETRY_SEGMENT="$TELEMETRY_SEGMENT" sleep 45'
```

How students know this value (transition reasoning):

- After validating the SSH-facing artifact in Step 2, students pivot to host-side schedulers for recurring activity. `systemctl list-timers` is the systemd equivalent of cron triage used in earlier labs.
- Timer/unit inspection exposes `EnvironmentFile=/etc/default/power-health`, which justifies the later static environment-file read in Step 6.
- This step is intentionally a discovery pivot, not the final process-flag recovery, so the demo avoids reading the same flag artifact twice.

### 4. Pivot from flag hunt to timer investigation workflow

At this point, students already identified `power-health` while recovering `process_flag`. Now model a full incident-style flow: enumerate scheduler state, inspect unit definitions, trace referenced files, and only then branch to logs/users/config.

```
systemctl list-timers -l --no-pager
```

Expected findings:

- `power-health.timer` is active and firing frequently (`OnUnitActiveSec=2min` behavior is visible from NEXT/LAST timing).
- The paired unit mapping (`power-health.timer` -> `power-health.service`) gives the direct investigation target.

How students know this value (transition reasoning):

- Step 3 already confirmed a timer-backed service exists; the next investigative move is to measure cadence and map timer -> service before expanding scope.
- In general operations work, recurring behavior is validated from scheduler state first, then traced into its execution unit.

### 5. Inspect the timer and service unit definitions

```
systemctl cat power-health.timer --no-pager -l
systemctl cat power-health.service --no-pager -l
```

Expected `systemctl cat power-health.timer` output:

```
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

```
# /etc/systemd/system/power-health.service
[Unit]
Description=Power telemetry collection

[Service]
Type=oneshot
EnvironmentFile=/etc/default/power-health
ExecStart=/bin/sh -c 'exec env PROCESS_FLAG="$PROCESS_FLAG" TELEMETRY_SEGMENT="$TELEMETRY_SEGMENT" sleep 45'
```

How students know this value (transition reasoning):

- Step 4 identified `power-health.timer` and its linked service; this directly justifies inspecting those exact unit definitions.
- `EnvironmentFile=` and `ExecStart=` provide evidence-backed pivots to the next commands instead of guessing file paths.

### 6. Recover `process_flag` (segment 1 of 5) from the referenced environment file

```
cat /etc/default/power-health
```

Expected output:

```
PROCESS_FLAG=DRIFT-BEACON
TELEMETRY_SEGMENT_INDEX=1
TELEMETRY_SEGMENT=<base64 data>
TELEMETRY_SEGMENT_1_OF_5=<base64 data>
```

Optional runtime confirmation while timer job is active:

```
ps eww | grep PROCESS_FLAG
```

How students know this value (transition reasoning):

- Step 5 produced a concrete `EnvironmentFile` path, so reading `/etc/default/power-health` follows directly from collected unit evidence.
- The optional `ps eww` check confirms runtime alignment between static unit config and live process environment.

### 7. Follow the `/etc` evidence trail from timer artifacts to policy/config

Start broad, then narrow:

```
find /etc -type d -name '*power*'
stat /etc/default/power-health /etc/power-manager
find /etc/power-manager -ls
```

Expected findings:

- `/etc/power-manager` exists and is updated in the same boot window as timer artifacts.
- Contents include `runtime-policy.conf`, `runtime.conf`, and encrypted/key material files.

How students know this value (transition reasoning):

- From Step 6, students now hold one confirmed `/etc` power artifact; standard investigation practice is to enumerate nearby config namespaces before targeting specific files.
- `find` + `stat` + directory listing builds justification for which config files are related in the current boot cycle.

### 8. Recover `config_flag` (segment 5 of 5) and capture crypto context

```
cat /etc/power-manager/runtime-policy.conf
cat /etc/power-manager/runtime.conf
```

Expected `cat /etc/power-manager/runtime-policy.conf` output:

```
# Power management policy
SHUTDOWN_THRESHOLD=5
DRAIN_RATE=normal
POWER_TOKEN=CARBON-LATTICE
TELEMETRY_SEGMENT_INDEX=5
TELEMETRY_SEGMENT=<base64 data>
TELEMETRY_SEGMENT_5_OF_5=<base64 data>
```

Expected `cat /etc/power-manager/runtime.conf` output:

```
# Lab 5.2 boot configuration (managed by Puppet — do not edit)
SECRET_BUNDLE_FILE=/etc/power-manager/runtime.secrets.enc
SECRET_KEY_FILE=/etc/power-manager/runtime.key
SECRET_CIPHER=aes-256-cbc
SECRET_KDF_ITERATIONS=200000
```

How students know this value (transition reasoning):

- Step 7 established `/etc/power-manager` as the adjacent config root, so `runtime-policy.conf` and `runtime.conf` are evidence-selected targets, not instructor shortcuts.
- Policy content yields `config_flag`/segment 5, while runtime crypto settings explain where protected material lives and why multiple config files matter.

### 9. Pivot to runtime outputs and recover `log_flag` (segment 2 of 5)

```
ls -lart /var/log
ls -lart /var/log/power-manager/
cat /var/log/power-manager/health.log
```

Expected `cat /var/log/power-manager/health.log` output:

```
[2026-04-13T14:23:45Z] power-manager[1234]: battery subsystem initialized
[2026-04-13T14:23:45Z] power-manager[1234]: UPS health check completed — token STATIC-PULSE
[2026-04-13T14:23:45Z] power-manager[1234]: telemetry segment 2/5: <base64 data>
```

How students know this value (transition reasoning):

- After static/unit analysis in Steps 5-8, the next standard move is runtime verification in logs to confirm what actually executed this cycle.
- `/var/log/power-manager/health.log` is justified by the same service family naming already observed in timer and config artifacts.
- The initial `/var/log` listing is the broad triage step; reading `health.log` comes only after the power-manager log directory is discovered.

### 10. Pivot to service-account artifacts and recover `user_flag` (segment 3 of 5)

```
getent passwd
getent passwd pwrmgr
ls -lart /home/pwrmgr/
cat /home/pwrmgr/.health-note
```

Expected `getent passwd pwrmgr` excerpt:

- Account `pwrmgr` exists with home `/home/pwrmgr` and non-login shell.

Expected `cat /home/pwrmgr/.health-note` output:

```
COPPER-NEEDLE
--- telemetry segment 3 of 5 ---
<base64 data>
```

How students know this value (transition reasoning):

- Steps 5-9 establish a service-driven workflow; a normal next pivot is identifying owning/related service accounts and their local artifacts.
- `getent passwd` narrows to `pwrmgr`, and the discovered home directory evidence justifies checking `.health-note` for the user-domain segment.
- The `pwrmgr` account is also present in Hiera defaults as a service-style account, but students should justify it from `getent passwd` output during the live walkthrough.

### 11. Reconstruct the composite flag

After collecting all five segments from the **same** boot cycle, concatenate them in order (1 through 5) and decode.

Example with explicit variables (matching this walkthrough sequence):

```
P1="<segment 1 from /etc/default/power-health>"
P2="<segment 2 from /var/log/power-manager/health.log>"
P3="<segment 3 from /home/pwrmgr/.health-note>"
P4="<segment 4 from /etc/ssh/issue.power>"
P5="<segment 5 from /etc/power-manager/runtime-policy.conf>"
FULL="${P1}${P2}${P3}${P4}${P5}"
echo "$FULL" | base64 -d | gunzip
```

Expected output:

```
BOOT_TS=2026-04-13T14:23:45Z
COMPOSITE_FLAG=PHANTOM-NEXUS
```

Teaching point:

- The payload is gzipped and boot-specific. Mixing segments from different reboot cycles yields decode/decompression errors, so students must preserve same-cycle discipline.
- Segment order is justified by prior evidence collection: segment indices discovered in each source provide the reconstruction sequence (1 -> 5).

### 12. Observe battery simulation evidence

Students can investigate why the system keeps rebooting:

```
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

```
[  ...] ACPI: Battery Slot [BAT0] (battery present)
[  ...] ACPI: Battery [BAT0]: design capacity 4400 mAh
[  ...] ACPI: Battery [BAT0]: discharging, capacity=12% remaining=6019mWh rate=15201mW
```

Expected `cat /sys/class/power_supply/README.md` output:

```
Battery telemetry in this path is intentionally simulated for Lab 5.2.
Your validation is correct: the exercise expects you to treat this state as operationally real.
```

Expected journal entries include `upower` daemon messages showing battery percentage decreasing and `systemd-logind` critical-threshold warnings.

Teaching point:

- Understanding the reboot mechanism is not required for flag recovery, but investigating it demonstrates strong situational awareness. The battery simulation writes realistic ACPI kernel messages, upower journal entries, and wall warnings.

### 13. Close with the host-purpose summary

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
- If composite reconstruct fails (gzip/decode errors), students mixed cycles or used the wrong segment order. Re-collect all five segments from one login.
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