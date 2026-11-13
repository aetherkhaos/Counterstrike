---
id: B03.M06.lab-5.1-answer-key
title: Lab 5.1 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-5.1-answer-key.md
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
# Lab 5.1 - Low Resources with Unreliable Exec - Answer Key (Instructor Only)

Use this for live delivery. The grading objective is complete flag recovery under unstable execution conditions, not exhaustive root-cause analysis of every limit.

## Objective Framing

Students work from a constrained listener session (TCP `2222`, commonly via `nc`) where command execution can fail intermittently. They earn credit by adapting and recovering all six flags, including the encrypted relay objective.

## Access

| Hostname (expected) | IP address  | Username | Password | Connection              |
| ------------------- | ----------- | -------- | -------- | ----------------------- |
| `ferret-51`         | 20.30.40.51 | N/A      | N/A      | Netcat shell (TCP 2222) |

If the instructor or range card provides a different target or port, use those assigned values.

## Flag Reference

| Flag ID | Expected evidence source | Hiera key | Default value |
|--------|---------------------------|-----------|---------------|
| `process_flag` | cron entry (`/etc/cron.d/system-maint`) | `cs_ops::lab_5_1::flags::process_flag` | `EMBER-SWITCH` |
| `log_flag` | maintenance log (`/var/log/maintenance/agent.log`) | `cs_ops::lab_5_1::flags::log_flag` | `DUSK-THREAD` |
| `user_flag` | `opssync` account metadata and note file | `cs_ops::lab_5_1::flags::user_flag` | `MINT-LATTICE` |
| `port_flag` | SSH banner path from `sshd_config` and banner content (`/etc/ssh/issue.net`) | `cs_ops::lab_5_1::flags::port_flag` | `RIVER-PATH` |
| `config_flag` | recovery-agent runtime config (`/etc/recovery-agent/default.conf`) | `cs_ops::lab_5_1::flags::config_flag` | `STONE-VAULT` |
| `crypto_flag` | decrypted relay payload + correlated campaign key evidence | `cs_ops::lab_5_1::flags::crypto_flag` | `EMBER-LOCKBOX` |

Related implementation/tunable paths:
- `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_5_1.pp`
- `environments/week3_repo/vms/puppet/data/nodes/lab_5_1.yaml`
- `cs_ops::lab_5_1::student_shell` (`port`, `listen_address`, `service_name`)
- `cs_ops::lab_5_1::random_exec` (`enabled`, `deny_percent`, `time_bucket_seconds`, `cg_fragment`)
- `cs_ops::lab_5_1::ransomware` (`campaign_id`, `key_alias`, `decrypt_key`, `payload_size_mb`)

## Recommended Instructor Walkthrough

### 1. Connect the constrained listener and run situational awareness baseline

From the ops station:

```bash
nc <target-ip> 2222
```

If `nc` is unavailable:

```bash
socat - TCP:<target-ip>:2222
```

Run this from the student session before deep triage:

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

```bash
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

```text
*/8 * * * * root env MAINT_TOKEN="EMBER-SWITCH" /usr/bin/logger -t maint-check heartbeat >/dev/null 2>&1
```

How students know this value:
- Schedule evidence is found by triaging standard cron/timer locations, manually reviewing likely jobs, then optionally filtering only after concrete clues appear.
- Record the maint naming now (`system-maint`, `MAINT_TOKEN`, `maint-check`); Step 3 uses that bridge into logs.

### 3. Recover `log_flag` by following maintenance naming from cron into `/var/log`

Do not treat `/var/log` as a blind haystack. Step 2 already exposed maintenance/scheduler naming; use that to justify the next directory:

```bash
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

```text
[2026-01-10 03:41:00] recovery scheduler resumed after transient fault DUSK-THREAD
[2026-01-10 03:44:10] exfil relay campaign RAVEN-BRIDGE staged archive /var/spool/recovery/outbound/telemetry-archive.enc
```

How students know this value:
- Cron evidence (`system-maint` / `maint-check`) justifies looking under `/var/log` for a non-default `maintenance` directory (same name-correlation pattern as Lab 1.1 `syswatch`).
- The student clue (“transient failure/recovery”) matches wording already in `agent.log`; use it to recognize the right line after the file is found, not as a first-pass recursive grep for the flag token.
- Cron’s `logger -t maint-check` may also appear in syslog; the graded artifact is the operations `agent.log` line carrying `log_flag`.

### 4. Recover `user_flag` by enumerating accounts

List all accounts from the name service (local and any configured backends):

```bash
getent passwd
```

Expected excerpt — the flag is already plain in the `opssync` GECOS/comment field:

```text
opssync:x:1003:1003:Auxiliary sync operator MINT-LATTICE:/home/opssync:/bin/bash
```

Optional corroboration only (same token; not required to discover the flag):

```bash
ls -la /home/opssync
cat /home/opssync/notice.txt
```

Expected `cat /home/opssync/notice.txt` output:

```text
MINT-LATTICE
```

How students know this value:
- Full `getent passwd` is the standard way to enumerate accounts regardless of where they are stored.
- The non-login ops-style account stands out on review; its comment field carries `user_flag` without further filtering.
- Home-directory reads are optional confirmation after that line is already visible.

### 5. Recover `port_flag` from SSH service metadata

Start from standard SSH config discovery (Step 1 `ss` already showed a listener on port `22`):

```bash
cat /etc/ssh/sshd_config
# Optional after manual review: narrow to the active SSH settings.
grep -E '^(Port|Banner)\b' /etc/ssh/sshd_config
ss -tulpen | grep ':22'
cat /etc/ssh/issue.net
```

Expected `cat /etc/ssh/issue.net` output:

```text
Remote maintenance endpoint token RIVER-PATH
```

How students know this value:
- `Banner` path is discoverable in standard `sshd_config`, then validated from the referenced file. The `grep` is optional noise reduction after students have established that `sshd_config` is the authoritative SSH service config.

### 6. Recover `config_flag` by surveying `/etc` first

Start with directory-level clues, manually identify suspicious entries, then inspect the most relevant config:

```bash
ls -l /etc
# Manual review: look for service-style names that stand out (for example
# recovery-agent). Optional only if /etc listing is too noisy:
# ls -l /etc | grep -Ei '<observed-clue-1>|<observed-clue-2>'
ls -l /etc/recovery-agent
cat /etc/recovery-agent/default.conf
```

Expected `cat /etc/recovery-agent/default.conf` output:

```text
RETRY_WINDOW=5
RECOVERY_TOKEN=STONE-VAULT
KEY_INDEX=/var/lib/recovery-agent/key-cache.db
```

How students know this value:
- `/etc` discovery reveals a service-style config directory (`recovery-agent`) and naturally leads to runtime token settings.
- Keep this directory in view for Steps 7–8 (transfer profile and decrypt tool paths live here too).

### 7. Inspect crypto evidence before execution

Continue from Step 6 `/etc/recovery-agent` discovery and gather campaign/key/tool metadata:

```bash
cat /etc/recovery-agent/transfer.conf
cat /var/lib/recovery-agent/key-cache.db
```

Expected `cat /etc/recovery-agent/transfer.conf` output:

```text
CAMPAIGN_ID=RAVEN-BRIDGE
KEY_ALIAS=sync-relay
KEY_DB=/var/lib/recovery-agent/key-cache.db
PAYLOAD_FILE=/var/spool/recovery/outbound/telemetry-archive.enc
DECRYPT_TOOL=/usr/local/bin/incident-decrypt
```

Expected `cat /var/lib/recovery-agent/key-cache.db` excerpt:

```text
campaign_id,key_alias,key_material,last_seen
RAVEN-BRIDGE,sync-relay,q7v9c2u4m1r8t6p3,2026-01-10T03:42:11Z
```

How students know these values:
- `transfer.conf` is a native runtime profile that exposes campaign, key DB, payload, and tool path.
- Key material is discoverable by correlating `CAMPAIGN_ID` and `KEY_ALIAS` with a row in the key database.

### 8. Recover `crypto_flag` with pre-execution inspection and adaptive execution

Before running a custom binary/script, inspect usage and do a quick script sanity check:

```bash
tool="$(awk -F= '/^DECRYPT_TOOL=/{print $2}' /etc/recovery-agent/transfer.conf)"
file "$tool"
sed -n '1,120p' "$tool"
# Instructor note: read this section with students and call out:
# - argparse flags (`--input`, `--key`, `--mode`, `--search`)
# - default bulk execution path vs legacy compatibility stream mode
"$tool" --help
```

Assemble `--input` and `--key` from Step 7 (`PAYLOAD_FILE` + RAVEN-BRIDGE / `sync-relay` key material). Run bulk first:

```bash
incident-decrypt --input /var/spool/recovery/outbound/telemetry-archive.enc --key q7v9c2u4m1r8t6p3
```

Expected teaching point:
- Full decrypted output is far too large for the constrained session and typically kills or floods the buffer.
- Do not invent a filter string. Step 6 already showed `RECOVERY_TOKEN=STONE-VAULT` in `default.conf`, and `--help`/source already showed `--search`. Search on the observed term `token`:

```bash
incident-decrypt --input /var/spool/recovery/outbound/telemetry-archive.enc --key q7v9c2u4m1r8t6p3 --search token
```

Expected filtered output:

```text
2026-01-10T03:44:31Z campaign=RAVEN-BRIDGE stream=relay outcome=decrypted evidence_token=EMBER-LOCKBOX
```

If bulk still OOMs before filtering helps, use stream mode with the same evidence-backed search string:

```bash
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

```bash
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

```text
service=remote-assist-shell.service pid=68826 cgroup=/system.slice/remote-assist-shell.service
MemoryCurrent=6205440
MemoryHigh=4194304
MemoryMax=6291456
```

Teaching note:
- `free` shows host memory, not cgroup-visible limits, so it is not sufficient proof by itself.

### B) Optional stress probe and retry pattern

Run this from the constrained student session, then re-check cgroup counters above:

```bash
python3 -c 'a=[]; [a.append(bytearray(1024*1024)) for _ in range(256)]'
```

Use lightweight retries during live instruction:

```bash
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
