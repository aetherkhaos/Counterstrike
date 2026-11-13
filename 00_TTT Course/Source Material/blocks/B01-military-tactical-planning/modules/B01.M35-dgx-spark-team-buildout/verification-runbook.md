---
id: B01.M35-verify
title: DGX Spark Team Buildout — Verification
artifact_type: verification_runbook
audience: builder
block: B01
module_type: group_activity
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: verification_runbook_v1
sensitivity: instructor_only
---

# DGX Spark Team Buildout — Verification

Confirm the instructor support stack from [`setup-guide.md`](setup-guide.md)
before students start [`student-guide.md`](student-guide.md). Range-wide Spark
provisioning still lives in `environments/dgx_spark_stack`.

## Ready

1. Instructor support stack is up (Traefik, trust, DNS, registry/models) per the setup guide.
2. Students can reach the assigned team workspace without repo access.
3. [`stack/`](stack/) still matches the documented end-state used for instructor comparison.

## Reset

Follow the teardown/reset notes in the setup guide. Do not copy range automation into this Module folder.
