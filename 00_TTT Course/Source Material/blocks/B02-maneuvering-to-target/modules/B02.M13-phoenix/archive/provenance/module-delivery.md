---
id: B02.M13-delivery
title: Phoenix — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B02
module_type: lab
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# Phoenix — Delivery requirements

## Environment
Shared VulnHub / Vulhub target stack. Do not copy compose or image files into this Module.

- Deploy tree: `environments/pcte_vulnhub_targets/`
- Instructor walkthrough source: `instructor-guide.md` in this Module
- Default proof-of-access key: `T3_FLAG` in that stack's `.env`

Students receive only the city codename and assigned subnet `192.168.12.0/24`.

## Equipment and bandwidth deltas
What this Module adds beyond the Course baseline in
`course/requirements/equipment-recommendations.md`.

```yaml
equipment:
- item: Assigned city subnet 192.168.12.0/24
  delta: shared VulnHub / Vulhub stack; already provisioned
  applicability: required
```

## Personnel

```yaml
personnel:
  - role: instructor
    count: 1
    ratio: "20:1"
    qualifications: []
    applicability: required
  - role: range_engineer
    count: 1
    applicability: conditional
    applicability_reason: "Required when the shared VulnHub stack needs deploy, reset, or NIC passthrough support"
  - role: auditor
    count: 0
    applicability: not_applicable
    applicability_reason: "Not used by this course"
  - role: oversight_officer
    count: 0
    applicability: not_applicable
    applicability_reason: "Not used by this course"
```

Instructors who already hold a listed qualification count toward that role.

## PCTE range
Range consumption beyond Course ops-station VMs. Portal names live in
`course/operations/pcte-range-specifications.md`.

```yaml
pcte:
  stack_refs:
  - stack_id: city-vulnhub
    applicability: required
```

## Artifact applicability

| Family | State | Reason / owner |
| --- | --- | --- |
| Lecture content guide / decks / lesson plan | not_applicable | not a lecture Module |
| Homework | not_applicable | module_type is lab |
| Student brief | required | sequenced student work |
| Student guide | not_applicable | brief is the student tasking |
| Instructor guide | not_applicable | instructor path is walkthrough.md |
| Answer key | required | graded flag submission |
| Quiz | required | Moodle flag quiz |
| Rubric | not_applicable | flag value is binary credit |
| Setup guide | not_applicable | shared stack; deploy lives in environments/pcte_vulnhub_targets |
| Verification runbook | not_applicable | shared stack readiness is environment-wide, not Module-local |
| Work aid | not_applicable | optional |
