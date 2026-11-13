---
id: B02.M04-setup
title: Tunneling and Pivot — Setup Guide
artifact_type: setup_guide
audience: instructor
block: B02
module_type: lab
legacy_aliases:
- legacy/week2/labs/L2.11_Tunneling_Pivot/README.md
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: setup_guide_v1
sensitivity: instructor_only
---

# Tunneling and Pivot — Setup Guide

## When this applies

Pre-class preparation for this lab. Students sit on a `city-vulnhub` ops station and share the web host and browser VM on live-action stack `classroom-shared`. The PCTE build sequence lives in [`environments/b02_tunneling_pivot/pcte-setup.md`](../../../../environments/b02_tunneling_pivot/pcte-setup.md). This package does not create VMs. A NAT router on the external-subnet link between the stacks drops new sessions the shared target opens back to an ops station.

## Prerequisites

Follow that runbook. It starts with generic host checks, then VyOS 1.5, then one archive copied into the range. Address defaults live in [`config/lab-addresses.env.example`](../../../../environments/b02_tunneling_pivot/config/lab-addresses.env.example).

## Pre-class steps

1. Build and place files using [`pcte-setup.md`](../../../../environments/b02_tunneling_pivot/pcte-setup.md).
2. Pass [`verification-runbook.md`](./verification-runbook.md) before students start.
3. Assign each student or team one port in `14000–14019`.

## Related verification

Go/no-go: [`verification-runbook.md`](./verification-runbook.md).
