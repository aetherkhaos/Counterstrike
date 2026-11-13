---
id: B04.M19-delivery
title: Effects Group Assessment — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B04
module_type: assessment
source_status: draft
review_required: true
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# Effects Group Assessment — Delivery requirements

## Equipment and bandwidth deltas
What this Module adds beyond the Course baseline in
`course/requirements/equipment-recommendations.md`.

This Module adds no equipment or bandwidth beyond the Course baseline.

```yaml
equipment: []
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
  duration_minutes: 435
  duration_notes: Filled from delivery-schedule ingest
```


## PCTE range
Range consumption beyond Course ops-station VMs. Portal names live in
`course/operations/pcte-range-specifications.md`.

```yaml
pcte:
  stack_refs:
  - stack_id: dcora-live-action
    applicability: required
```

## Artifact applicability

| Family | State | Reason / owner |
| --- | --- | --- |
| Lecture content guide / decks / lesson plan | not_applicable | not a lecture Module |
| Homework | not_applicable | module_type is assessment |
| Student brief | required | graded brief |
| Student guide | not_applicable | not a student-guide Module |
| Instructor guide | required | facilitation |
| Answer key | required | graded Module |
| Quiz | conditional | use when the assessment is a quiz |
| Rubric | required | graded Module |
| Setup guide | not_applicable | no Module-local prep |
| Verification runbook | not_applicable | no Module-local prep |
| Work aid | not_applicable | optional |
