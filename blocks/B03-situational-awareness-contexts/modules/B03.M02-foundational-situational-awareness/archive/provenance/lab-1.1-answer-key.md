---
id: B03.M02.lab-1.1-answer-key
title: Lab 1.1 Answer Key
artifact_type: answer_key
audience: instructor
block: B03
legacy_aliases:
- week3_repo/docs/assessment/lab-1.1-answer-key.md
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
# Lab 1.1 — Linux Server — Answer Key (Instructor Only)

Use this as a live walkthrough. The goal is to start with only the access and tasking given to students, enumerate the host in a sensible order, and naturally uncover all five flags plus the required artifact answers.

Walkthrough commands are the **B03.M01 Situational Awareness, Execution Environments, and User Context** lecture SA baseline, not a closed list from the student packet. The packet is task-level. For additional enumeration commands, use that lecture, ATT&CK Discovery (TA0007), and Linux man pages. Do not treat this key as the only valid command set.

## Access

| Hostname (expected) | IP address  | Username | Password         | Connection   |
| ------------------- | ----------- | -------- | ---------------- | ------------ |
| `boar-11`           | 20.30.40.11 | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 22) |

If the instructor or range card provides a different login, use those assigned values.

## Flag Reference

| Flag ID | Default location in the default build | Hiera key | Default value (if key omitted) |
|--------|----------------------------------------|-----------|--------------------------------|
| `process_flag` | `/etc/cron.d/syswatch_backup` and, while running, the cron-created process environment | `cs_ops::lab_1_1::flags::process_flag` | `IRON-LANTERN` |
| `log_flag` | `/var/log/syswatch/app.log` | `cs_ops::lab_1_1::flags::log_flag` | `COBALT-TRACE` |
| `user_flag` | `/home/svc_backup/flag.txt` and the `svc_backup` account comment | `cs_ops::lab_1_1::flags::user_flag` | `VELVET-ANCHOR` |
| `port_flag` | Apache response header `X-SysWatch-Status` on localhost-only metrics vhost `127.0.0.1:8081` | `cs_ops::lab_1_1::flags::port_flag` | `SIGNAL-HARBOR` |
| `config_flag` | `connection_secret` in `/var/www/html/db_config.txt` | `cs_ops::lab_1_1::flags::config_flag` | `QUARTZ-VEIL` |

Set each flag under `cs_ops::lab_1_1::flags` in Hiera, for example in `environments/week3_repo/vms/puppet/data/nodes/lab_1_1.yaml`. Defaults are defined in `environments/week3_repo/vms/puppet/modules/cs_ops/manifests/lab_1_1.pp`.

Relevant HTTP-header tunables:
- `cs_ops::lab_1_1::port_flag_header_name` defaults to `X-SysWatch-Status`.
- `cs_ops::lab_1_1::metrics_bind_address` defaults to `127.0.0.1`.
- `cs_ops::lab_1_1::metrics_port` defaults to `8081`.
- `cs_ops::lab_1_1::apache_metrics_site_name` defaults to `syswatch-metrics`, rendered at `/etc/apache2/sites-available/syswatch-metrics.conf` in the default build.

## Recommended Instructor Walkthrough

### 1. Connect and run situational awareness baseline

Connect with the Access table (or range-rotated credentials), then collect the B03.M01 Linux SA baseline before objective-specific enumeration:

```bash
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

```text
<student-user> : <student-user> sudo
```

Expected `sudo -l` excerpt (wording varies by sudoers policy; the point is that sudo is allowed):

```text
User <student-user> may run the following commands on <hostname>:
    (ALL : ALL) ALL
```

### 2. Enumerate processes first

```bash
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

```bash
ps eww -u root
```

Why:
- The cron job exports `PROCESS_FLAG` into the process environment. `ps eww` can expose it if the job is active at that moment.

### 3. Check scheduled tasks and recover the process flag

```bash
ls -lah /etc/cron.d
cat /etc/cron.d/syswatch_backup
```

Why:
- The student packet tasks review of scheduled execution, including cron. `ls /etc/cron.d` is the standard Linux drop-in path from ordinary admin practice, not a packet-named file.
- This is the most reliable way to answer who runs the custom job, when it runs, and what it executes.
- Students know to read `/etc/cron.d/syswatch_backup` only after the directory listing exposes it as a non-default, purpose-named scheduler artifact. Additional cron locations (`/etc/crontab`, user `crontab -l`, `/etc/cron.*`) are in `man cron` / `man crontab`.

Expected `cat /etc/cron.d/syswatch_backup` output:

```text
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

```bash
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

```text
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

```bash
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

```text
svc_backup:x:<uid>:<gid>:Backup service account - VELVET-ANCHOR:/home/svc_backup:/bin/bash
```

Expected `cat /home/svc_backup/flag.txt` output:

```text
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

```bash
ss -tulpn
```

Why:
- `ss -tulpn` is the B03.M01 Linux listener baseline. `-t` TCP, `-u` UDP, `-l` listening, `-p` process, `-n` numeric ports. `ss -lntup` from the lecture, or `netstat` if `ss` is missing, is equivalent.
- Remote scanning should only show the externally reachable service on port `80`; it should not retrieve the port flag because the metrics vhost is bound to loopback.
- Once students SSH into the host, local `ss` evidence should show Apache also listening on `127.0.0.1:8081`.
- Hold the loopback listener for Step 7. Hold port `80` / Apache for Step 9 web-root reconnaissance.

Expected `ss -tulpn` excerpt:

```text
LISTEN ... 0.0.0.0:80        0.0.0.0:*    users:(("apache2",...
LISTEN ... 127.0.0.1:8081    0.0.0.0:*    users:(("apache2",...
```

Expected findings:
- Port `22` should be SSH.
- Port `80` should be the externally reachable Apache HTTPD site in the default build.
- `127.0.0.1:8081` should be an Apache metrics portal only available from the host itself after login.

### 7. Look deeper into HTTP response metadata and recover the port flag

```bash
curl -i http://127.0.0.1:8081/
```

Why:
- Step 6 `ss` already proved a localhost-only HTTP listener on `127.0.0.1:8081`. The loopback address and port come from that listener evidence, not from the answer key.
- `curl -i` includes response headers. The port flag is in Apache-provided header metadata, not in a remotely scannable banner or the public HTML page body.

Expected `curl -i http://127.0.0.1:8081/` output snippet:

```text
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

```bash
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

```bash
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

```text
-rw-r----- 1 root root ... /var/www/html/db_config.txt
```

Expected `cat` as the student (no sudo):

```text
cat: /var/www/html/db_config.txt: Permission denied
```

Expected `curl -i http://127.0.0.1/db_config.txt` snippet when Apache cannot read the file:

```text
HTTP/1.1 403 Forbidden
```

Expected `sudo cat /var/www/html/db_config.txt` output:

```text
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
