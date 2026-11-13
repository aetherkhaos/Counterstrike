---
id: B02.M04-verify
title: Tunneling and Pivot — Verification
artifact_type: verification_runbook
audience: builder
block: B02
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
- classroom-shared
- city-vulnhub
---

# Tunneling and Pivot — Verification

Do not duplicate the build steps in [`pcte-setup.md`](../../../../environments/b02_tunneling_pivot/pcte-setup.md). These checks confirm the class status page and targets are ready. Ops stations are on `city-vulnhub`. The shared web host and browser VM are on `classroom-shared`.

## Preflight

- Deploy kit present in [`environments/b02_tunneling_pivot/`](../../../../environments/b02_tunneling_pivot/)
- A city-stack ops station reaches the shared web VM at `172.16.172.110`
- A listener on the ops station does not receive a new session started from the shared web host (NAT on the external-subnet link)
- New sessions from ops stations to `172.16.172.111` are dropped by the forward filter
- Chromium/Chrome on the browser VM with “Always use secure connections” off

## Post-deploy checks

1. Open [`status/status.html`](../../../../environments/b02_tunneling_pivot/status/status.html) on the browser VM.
2. Assigned cells start **red** (no listener).
3. From the browser VM, confirm Apache/PHP on the web root as in the PCTE setup guide.
4. Confirm ops-station SSH to the browser VM times out, and SSH to that host through the web server succeeds.

## Go/no-go

| Check | Go | No-go |
| --- | --- | --- |
| Status page in Chromium | Cells poll plain HTTP | Firefox / HTTPS-first; cells stay yellow/red while `curl http://` works |
| Tile states | Red at start; yellow = listener without image; image = success | All cells stuck yellow after a known-good JPEG listener |
| Port plan | Unique port per student in `14000–14019` | Colliding ports |

## Student-path smoke

One instructor demo path is in [`answer-key.md`](./answer-key.md). After that path, the assigned cell shows the image.

## Reset / clean-start confirmation

- Status grid back to red on unused ports
- Student listeners and forwards torn down on both targets
- Uploads directory on target 1 cleared of student webshells if reusing the VM
