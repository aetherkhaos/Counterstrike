---
id: B04.M25-verify
title: Threat-Rep Mission Rehearsal Lab — Verification Runbook
artifact_type: verification_runbook
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: true
output_formats:
- docx
- pdf
template_profile: verification_runbook_v1
sensitivity: instructor_only
environments:
- environments/effects_lab_env
---

# Threat-Rep Mission Rehearsal Lab — Verification Runbook

## Purpose

Pre-class smoke checks for the shared vSphere threat-rep lab. Students
build their own cells; cadre verifies catalog, pool access, and optionally one
gold Option A path.

## Checks

### 1. Catalog and pool access

| Check | Pass criteria |
| --- | --- |
| Student folder visible | Ops station can open assigned folder in vCenter |
| Resource pool | Concurrent RAM policy ~50 GB still documented/enforced |
| ISOs/templates | Ubuntu LTS, Debian, Rocky or Alma, Kali, Windows present |
| Console | Remote Console opens a powered-on template or gold VM |

### 2. Addressing

| Check | Pass criteria |
| --- | --- |
| Gateway/DNS posted | Students can configure statics in `172.16.45.0/24` |
| DHCP half untouched | No cadre statics in `172.16.44.0/24` for this lab |
| `/29` slips | One unique block per student/team |

### 3. Optional gold Option A spot-check (instructor cell only)

Use [answer-key.md](./answer-key.md) Option A steps on a private instructor
folder — not a student IP.

| Check | Pass criteria |
| --- | --- |
| PHP surface | Request-parameter command execution returns command output |
| Private hop | From redirector, RDP or SSH to Windows succeeds |
| Pass-back | Windows beacon/session reaches Kali **via** redirector forwarder |
| Evidence | Listener on Kali and connection/forwarder logs on redirector both show activity |

### 4. Document handoff

| Check | Pass criteria |
| --- | --- |
| Student brief | Brief with A/B/C cards issued |
| Answer key | Not linked on student Moodle surface |
| Lecture parity | Option slides match brief option cards |

## Failure triage

| Failure | Action |
| --- | --- |
| Missing ISO | Stage from facility library before class; do not send students to internet download |
| Console fails | Escalate to range engineer; do not invent unmanaged jump hosts |
| Gold pass-back fails | Verify dual NIC order, forwarder bind address, Windows default gateway toward redirector |
| Student claims green without middle hop | Fail path fidelity; require redirector evidence |

## Sign-off

- [ ] Catalog ready
- [ ] Pools/folders ready
- [ ] Addressing posted
- [ ] Optional gold Option A verified (if demonstrating)
- [ ] Student brief / instructor key separation confirmed
