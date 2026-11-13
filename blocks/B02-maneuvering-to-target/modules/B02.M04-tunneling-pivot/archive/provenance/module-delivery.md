---
id: B02.M04-delivery
title: Tunneling and Pivot — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B02
module_type: lab
source_status: draft
review_required: true
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# Tunneling and Pivot — Delivery requirements

## Equipment and bandwidth deltas
What this Module adds beyond the Course baseline in
`course/requirements/equipment-recommendations.md`.

```yaml
equipment:
- item: Dual-homed web host plus internal-only SSH pivot host
  delta: copy-to-VM kit in environments/b02_tunneling_pivot
  applicability: required
```

## Personnel

```yaml
personnel:
- role: instructor
  count: 1
  ratio: '20:1'
  qualifications: []
  applicability: required
- role: range_engineer
  count: 1
  applicability: conditional
  applicability_reason: Required when this Module's environment needs a range engineer
- role: auditor
  count: 0
  applicability: not_applicable
  applicability_reason: Not used by this course
- role: oversight_officer
  count: 0
  applicability: not_applicable
  applicability_reason: Not used by this course
```

Instructors who already hold a listed qualification count toward that role.

## Delivery duration
Instructional length for this Module. The delivery schedule renderer
uses `duration_minutes` for calendar block size. Edit this value here,
not in `delivery-schedule.md`.

```yaml
delivery:
  duration_minutes: 60
  duration_notes: Filled from delivery-schedule ingest
```


## PCTE range
Range consumption beyond Course ops-station VMs. Portal names live in
`course/operations/pcte-range-specifications.md`.

```yaml
pcte:
  stack_refs:
  - stack_id: b02-tunneling-pivot
    applicability: required
```

## Artifact applicability

| Family | State | Reason / owner |
| --- | --- | --- |
| Lecture content guide / decks / lesson plan | not_applicable | not a lecture Module |
| Homework | not_applicable | module_type is lab |
| Student brief | required | sequenced student work |
| Student guide | not_applicable | not a student-guide Module |
| Instructor guide | required | facilitation |
| Answer key | not_applicable | not graded |
| Quiz | not_applicable | no quiz |
| Rubric | not_applicable | no rubric |
| Setup guide | required | deploy kit in `environments/b02_tunneling_pivot/`; Module README is the copy-to-VM map |
| Verification runbook | not_applicable | instructor projection status page in the deploy kit |
| Work aid | not_applicable | optional |
