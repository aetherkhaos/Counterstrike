---
id: B03.M05-delivery
title: Windows and Hybrid Environments — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B03
module_type: lab
source_status: draft
review_required: true
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# Windows and Hybrid Environments — Delivery requirements

## Equipment and bandwidth deltas
What this Module adds beyond the Course baseline in
`course/requirements/equipment-recommendations.md`.

```yaml
equipment:
- item: Constrained-target VMs
  delta: assigned hosts from environments/week3_repo
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
  duration_minutes: 75
  duration_notes: Filled from delivery-schedule ingest
```


## PCTE range
Range consumption beyond Course ops-station VMs. Portal names live in
`course/operations/pcte-range-specifications.md`.

```yaml
pcte:
  stack_refs:
  - stack_id: week3-constrained
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
| Answer key | required | graded lab |
| Quiz | not_applicable | no quiz |
| Rubric | not_applicable | no rubric |
| Setup guide | not_applicable | range-wide setup in environments/week3_repo |
| Verification runbook | not_applicable | range-wide setup in environments/week3_repo |
| Work aid | not_applicable | optional |
