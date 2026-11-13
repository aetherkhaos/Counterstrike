---
id: B04.M25-setup
title: Threat-Rep Mission Rehearsal Lab — Setup Guide
artifact_type: setup_guide
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: true
output_formats:
- docx
- pdf
template_profile: setup_guide_v1
sensitivity: instructor_only
environments:
- environments/effects_lab_env
---

# Threat-Rep Mission Rehearsal Lab — Setup Guide

## When this applies

Before the threat-rep rehearsal. Students deploy their own VMs on the
shared vSphere pool; cadre stages catalog media and pool access.

## Prerequisites

- Shared cluster contract: [environments/effects_lab_env/vsphere/README.md](../../../../environments/effects_lab_env/vsphere/README.md)
- Instructor answer-key for gold configs: [answer-key.md](./answer-key.md)
- Student brief issued: [student-brief.md](./student-brief.md)

## What students build vs what cadre provides

| Role | Who builds | Cadre provides |
| --- | --- | --- |
| Kali ops | Student | Kali ISO / thin template in catalog |
| Redirector (A/B/C) | Student | Ubuntu LTS, Debian, Rocky or Alma ISOs/templates |
| Windows target | Student | Windows ISO/template with RDP available; OpenSSH optional |
| Networking | Student (inside `/29`) | Gateway/DNS posted; DHCP half protected |
| Folder / pool | Cadre | Per-student folder + ~50 GB pool |

## Pre-class checklist

1. Confirm each student folder and resource pool exist; ~50 GB concurrent cap enforced.
2. Confirm catalog media for Ubuntu LTS, Debian, Rocky **or** AlmaLinux, Kali, and Windows.
3. Post gateway/DNS for `172.16.45.0/24` static half; issue `/29` slips.
4. Verify students can open vCenter UI + Remote Console from ops stations.
5. Print or link the student brief.
6. Keep [answer-key.md](./answer-key.md) instructor-only — do not publish to Moodle student resources.
7. Optional: pre-build one private gold cell of Option A for instructor live demo (power off when not demonstrating to save RAM).

## Addressing reminder

- Static student hosts: assigned `/29` inside `172.16.45.0/24` only.
- Do not place student statics in `172.16.44.0/24` (DHCP).
- Redirector dual-home: both addresses should stay inside the student block unless the cadre documents a sanctioned private link pattern for this pilot.

## After class

- Collect deliverables listed in the student brief.
- Power off abandoned student VMs / demo gold cell.
- Capture which options students chose and the common failure modes.
