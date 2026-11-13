---
id: B04.M21-setup
title: Poison Harvest Collection — Setup Guide
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

# Poison Harvest Collection — Setup Guide

## When this applies

Before the poison-collection session. Same four-host harvest cell as M20. Restore snapshots after any break-collection effects.

## Prerequisites

- Harvest cell built per [BUILD.md](../../../../environments/b04_temp_harvest_cell/BUILD.md)
- M20 setup complete once: [../B04.M20-break-harvest-collection/setup-guide.md](../B04.M20-break-harvest-collection/setup-guide.md)
- Moodle `access_key` still valid for `relay`

## Pre-class steps

1. Revert or reset the four VMs after M20 ([RESET.md](../../../../environments/b04_temp_harvest_cell/RESET.md)).
2. Smoke end-to-end pipeline (victim → mail → indexer outbox → actor collect).
3. Confirm student seats: mail-relay SSH 2222; file-index OpenSSH/WinRM as `svc.harvest` / `Harvest!Relay01`.
4. Confirm student brief **states** Windows credentials (unlike M20).
5. Confirm sync-node direct SSH still fails; `reviewer` / `id_stage.pub` still authorized for keyword reverse-shell stretch.
6. Snapshot clean state before class.

No local-hypervisor replica seats are required for this Module.

## Related verification

[`verification-runbook.md`](./verification-runbook.md)

## Related range cheat sheet

[../B04.M20-break-harvest-collection/supporting-documents/instructor-range-breakdown.md](../B04.M20-break-harvest-collection/supporting-documents/instructor-range-breakdown.md)
