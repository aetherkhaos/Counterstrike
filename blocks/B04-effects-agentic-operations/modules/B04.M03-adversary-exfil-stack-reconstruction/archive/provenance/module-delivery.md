---
id: B04.M03-delivery
title: Adversary Exfil Stack Reconstruction — Delivery requirements
artifact_type: module_delivery
audience: shared
block: B04
module_type: lab
source_status: draft
review_required: true
output_formats:
- docx
- pdf
template_profile: module_delivery_v1
sensitivity: course_internal
---

# Adversary Exfil Stack Reconstruction — Delivery requirements

## Equipment and bandwidth deltas
What this Module adds beyond the Course baseline in
`course/requirements/equipment-recommendations.md`.

```yaml
equipment:
- item: Week 4 lab_env / vSphere target stack
  delta: shared adversary/agentic environment in environments/effects_lab_env
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
| Setup guide | not_applicable | range-wide setup in environments/effects_lab_env |
| Verification runbook | not_applicable | range-wide setup in environments/effects_lab_env |
| Work aid | not_applicable | optional |
