---
id: B04.M21-verify
title: Poison Harvest Collection — Verification
artifact_type: verification_runbook
audience: builder
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: verification_runbook_v1
sensitivity: instructor_only
environments:
- environments/b04_temp_harvest_cell
---

# Poison Harvest Collection — Verification

Reuse the shared cell checks in [../B04.M20-break-harvest-collection/verification-runbook.md](../B04.M20-break-harvest-collection/verification-runbook.md), plus:

## M21-specific preflight

- [ ] Snapshots restored after M20 break effects
- [ ] Student brief includes file-index `172.16.4.20` and `svc.harvest` / `Harvest!Relay01`
- [ ] `HarvestIndex` task running; outbox receiving curated zip + JSON
- [ ] `KEEP_EXT` still present in `harvest_worker.py` (filter intel intact)
- [ ] Sync-node direct SSH still fails from Kali
- [ ] `reviewer` authorized on mail-relay (`/home/reviewer/.ssh/authorized_keys` from sync-node `id_stage.pub`)
- [ ] Keyword reverse-shell smoke: keep-ext bait with `blackstart` (or `islanding` / `N-1`) → after actor collect, mail-relay `ss -lntp` shows `127.0.0.1:1337`; `nc 127.0.0.1 1337` lands bash cwd `/opt/relay/` with `princess_peach.txt`

## Quick student-path smoke

```bash
ssh -i access_key -p 2222 relay@172.16.2.10 'hostname; whoami'
ssh svc.harvest@172.16.4.20 'powershell -NoProfile -Command "hostname; whoami; Select-String -Path C:\ProgramData\Harvest\bin\harvest_worker.py -Pattern KEEP_EXT"'
```

Expected: both seats work; `KEEP_EXT` line visible for filter study.

## Keyword reverse-shell smoke (instructor)

```bash
# on sync-node console after placing a keyword-bearing curated zip under /opt/relay/collected/
/opt/relay/actor-keyword-react.sh
# on mail-relay as relay (or root)
ss -lntp | grep 1337
nc 127.0.0.1 1337
# hostname; pwd; cat princess_peach.txt
# Ctrl+C should not kill listener; exit and nc again should reconnect
```

## Reset

[RESET.md](../../../../environments/b04_temp_harvest_cell/RESET.md)
