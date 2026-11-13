# Harvest cell soft reset (instructor) — B04.M20

Per-host cleanup scripts for a **clean operational start** between sessions. They wipe queues, **all local users’ command histories**, clue-bearing logs, temp/recent spoilers, and common break residue, then re-check services/tasks.

**True factory restore** remains hypervisor **snapshot revert**. Use these scripts when snapshots are unavailable or you only need a soft clean.

Do **not** hand these to students or put them in the student brief.

## Scripts

| Host | Script | Run as |
| --- | --- | --- |
| mail-relay `172.16.2.10` | `mail-relay-reset.sh` | root |
| file-index `172.16.4.20` | `file-index-reset.ps1` | Administrator |
| blue-victim `172.16.1.2` | `blue-victim-reset.ps1` | Administrator |
| sync-node `172.16.5.30` | `sync-node-reset.sh` | root |

## How to run

Suggested order: mail-relay → file-index → blue-victim → sync-node (any order is fine for soft clean).

**Linux**

```bash
cd /path/to/uploaded/range-reset
sh ./mail-relay-reset.sh   # or sync-node-reset.sh
```

**Windows (elevated PowerShell)**

```powershell
cd C:\path\to\uploaded\range-reset
powershell -ExecutionPolicy Bypass -File .\file-index-reset.ps1
# or .\blue-victim-reset.ps1
```

Expect `=== RESULT: OK ===`. Delete the uploaded script/folder from the host afterward.

## What they do / do not do

**Do:**
- Clear harvest queues / collected store
- Clear shell histories for **root and every `/home/*`** (bash/zsh/python/vim/etc.) on Linux
- Clear PowerShell histories for **all** `C:\Users\*` profiles on Windows
- Truncate clue logs (auth/syslog/nginx/wtmp on Linux); scrub Recent/jump lists and TEMP spoiler-named files on Windows
- Keep only canonical files under `/root/staging` (`access_key`, pubs); remove other staging clutter
- Restore Relay `authorized_keys` from `/root/staging/relay.pub` when present
- Re-enable stopped services and disabled Harvest tasks; print PASS/FAIL checks

**Do not:** rotate `access_key`; recreate users; re-bake packages; lock root on sync-node; remove `C:\Simspace_Generator\generate.ps1`; remove gold lab binaries.

If gold binaries or cron files are missing, re-run that host’s `configure.*` from [environments/b04_temp_harvest_cell](../../../../../environments/b04_temp_harvest_cell/).

## After reset

1. Confirm Moodle `access_key` still matches Relay (`relay.pub` / `/root/staging/access_key`). Re-issue from the host only if keys drifted.
2. Smoke: allow up to ~10 min (victim), ~15 min (file-index), ~30 min (sync-node) for a curated package to appear in `/opt/relay/collected/`.

Full cell reset notes: [RESET.md](../../../../../environments/b04_temp_harvest_cell/RESET.md).
