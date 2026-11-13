---
id: B04.M20-setup
title: Break Harvest Collection — Setup Guide
artifact_type: setup_guide
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: setup_guide_v1
sensitivity: instructor_only
environments:
- environments/b04_temp_harvest_cell
---

# Break Harvest Collection — Setup Guide

## When this applies

Before the break-collection session on the temporary harvest cell (M07-shaped placeholder).

## Prerequisites

- Local hypervisor (vSphere, VMware Workstation, or equivalent)
- Preferred images and per-host install steps: [environments/b04_temp_harvest_cell/BUILD.md](../../../../environments/b04_temp_harvest_cell/BUILD.md)
- Contract, accounts, and copy list: [environments/b04_temp_harvest_cell/README.md](../../../../environments/b04_temp_harvest_cell/README.md)
- Moodle file resource `access_key` from this Module's `moodle_artifacts/access_key`

## Pre-class steps

1. Build all four hosts from [BUILD.md](../../../../environments/b04_temp_harvest_cell/BUILD.md): `blue-victim` (`172.16.1.2`), `mail-relay`, `file-index`, `sync-node` (threat actor).
2. Run each host configure script (mail → file-index → authorize `pull` → blue-victim → sync-node → authorize `reviewer` with `id_stage.pub`). Copy `transit.key`, `id_pull.pub`, and `id_stage.pub` as BUILD wiring states.
3. Confirm file-index Print Spooler is running, `printop` exists (Users only), and null-session / RID enum from Kali can list local users. Smoke PrintNightmare → SYSTEM with your offline PoC (do not commit exploits to the repo).
4. Issue Moodle `access_key` from this Module's `moodle_artifacts/access_key`. It must match `/root/staging/access_key` on `mail-relay`. SSH listen **2222** for students (keep **22** for `pull`). A successful `mail-relay/configure.sh` rotates that key; replace `moodle_artifacts/access_key` from the new staging file before the next course pack.
5. Confirm leftover exec + nginx on `:8080`, SMTP sink on `:2525`, `mail-process` cron (real), `harvest-forward` no-op (lie).
6. Confirm Windows shares `Harvest` / `HarvestOut`, Python **3.8.10**, `HarvestIndex` task. Confirm `D:\Harvest` does **not** exist.
7. Confirm blue-victim `HarvestCollect` and sync-node `/etc/cron.d/actor-collect` + `actor-keyword-react.sh`. Confirm direct student SSH to `172.16.5.30` fails. Confirm `reviewer` auth on mail-relay for keyword reverse-shell.
8. Snapshot all four VMs.
9. Between sessions without snapshot revert: run instructor [range-reset](./range-reset/README.md) soft-clean scripts on each host (not for students).
10. Student brief lists **mail-relay `172.16.2.10` only**. Do **not** post `svc.harvest` password, `printop`, `172.16.1.2`, or `172.16.5.30`.

## Missing Moodle `access_key`

If Moodle has no `access_key` file (or the instructor needs a replacement), recover first; regenerate only if the private key is gone.

### Recover (preferred)

1. Console or SSH as root to `mail-relay` (`172.16.2.10`).
2. If `/root/staging/access_key` exists, copy it over this Module's `moodle_artifacts/access_key` and upload that file to Moodle as `access_key`.

```bash
# on mail-relay as root (console preferred)
ls -l /root/staging/access_key /root/staging/access_key.pub /root/staging/relay.pub
# from instructor station — use gold-image root (or your build admin) and that account's password when scp/ssh prompts
scp root@172.16.2.10:/root/staging/access_key ./access_key
chmod 600 access_key
# key auth only — no password for relay@
ssh -i access_key -p 2222 relay@172.16.2.10 'hostname; whoami'
```

### Regenerate (only if private key is gone)

1. On the instructor station:

```bash
ssh-keygen -t ed25519 -f access_key -N "" -C relay@mail-relay
```

2. On `mail-relay`, install the new public key and restage:

```bash
install -d -m 700 -o relay -g relay /home/relay/.ssh
install -m 600 -o relay -g relay access_key.pub /home/relay/.ssh/authorized_keys
install -d -m 700 /root/staging
cp access_key.pub /root/staging/access_key.pub
cp /home/relay/.ssh/authorized_keys /root/staging/relay.pub
cp access_key /root/staging/access_key
chmod 600 /root/staging/access_key
```

3. Upload the new private key to Moodle as `access_key`.
4. Smoke with key auth only (no password): `ssh -i access_key -p 2222 relay@172.16.2.10 'hostname; whoami'`.

Regenerating invalidates any previously issued Moodle key; re-issue to students.

## Related verification

[`verification-runbook.md`](./verification-runbook.md)

## Related range cheat sheet

[`instructor-range-breakdown.md`](./supporting-documents/instructor-range-breakdown.md)
