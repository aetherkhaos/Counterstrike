---
id: B01.M28-delivery
title: MITRE D3FEND CAD — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B01
module_type: lecture
source_status: draft
review_required: true
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# MITRE D3FEND CAD — Delivery requirements

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
  count: 0
  applicability: not_applicable
  applicability_reason: Lecture Module; no range engineer required
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

## Artifact applicability

| Family | State | Reason / owner |
| --- | --- | --- |
| Lecture content guide / decks / lesson plan | required | lecture source |
| Homework | not_applicable | module_type is lecture |
| Student brief | not_applicable | not a sequenced student-work Module of this type |
| Student guide | not_applicable | not a student-guide Module |
| Instructor guide | not_applicable | facilitation is in the content guide or not required |
| Answer key | not_applicable | not graded |
| Quiz | not_applicable | no quiz |
| Rubric | not_applicable | no rubric |
| Setup guide | not_applicable | no Module-local prep |
| Verification runbook | not_applicable | no Module-local prep |
| Work aid | not_applicable | optional |
