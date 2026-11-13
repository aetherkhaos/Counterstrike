---
id: B02.M16-ig
title: Web-to-SQL Group Exercise — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B02
module_type: group_activity
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# Web-to-SQL Group Exercise — Instructor Guide

## Objective and context

Facilitation SoT for the generated lesson plan. Command-complete walkthroughs stay in the answer key. This is the Block 2 group activity (Monday afternoon and Tuesday). Teams chain SQL injection on the web tier into database-tier root and document the access path. A team that finishes early may use the remaining time on optional B02.M15.

**Companion docs:**

- [`student-brief.md`](student-brief.md) — given to students at lab start.
- [`supporting-documents/L2.13 Web-to-SQL Instructor Hints.md`](supporting-documents/L2.13%20Web-to-SQL%20Instructor%20Hints.md) — progressive hints for teams that stall; release one phase at a time.
- [`answer-key.md`](answer-key.md) — full discovery-to-root walkthrough.
- Raw OPAL instructor exploit notes were an upstream source; they are not part of the canonical Module package.

## Instructor resources and pre-class

- Classroom projector and screen; whiteboard for the opening contract
- Confirm live-action stack `b02-web-to-sql` is up and stations can ping-scan `200.200.200.1` before start
- Progressive hint sheet ready; do not project flags or the full chain
- Do not project flags, tokens, or answer-key values

## Student resources

- Student brief in this Module folder
- Live-action stack `b02-web-to-sql`; known website IP is in the brief (`200.200.200.1`)
- No extra kit beyond what the student-facing file already lists

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "You start with website IP 200.200.200.1, positioned as if coming from the internet. The product is a documented access chain to the backend, not a flag dump."
- **Do:** Put the starting website IP on the board. Keep the hint sheet instructor-only.
- **Ask (Q):** What must the write-up contain besides flags?
- **Expected Response (A):** A tier-by-tier access chain another operator could follow, with evidence for each transition.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "You start with website IP 200.200.200.1, positioned as if coming from the internet. The product is a documented access chain to the backend, not a flag dump."
- **Show:** The student brief starting point and deliverables.
- **Do:** Confirm stations can ping-scan `200.200.200.1` from the live-action range before the first teaching row.
- **Ask (Q):** What must the write-up contain besides flags?
- **Expected Response (A):** A tier-by-tier access chain another operator could follow, with evidence for each transition.

## Facilitation flow

### Step 1: Host discovery (20 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 2: Service enumeration (15 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 3: Vulnerability discovery (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 4: Web shell upload (20 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 5: Credential discovery on the web tier (15 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 6: Pivot to the database tier (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 7: Database-tier enumeration (20 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 8: MariaDB to a reverse shell (20 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens. Teams who recover the mysql-user flag may come to you; walk docker-gcc load/compile from the hint sheet only — do not hand PwnKit source or delivery.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 9: Privilege escalation (PwnKit) (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

### Step 10: Objective confirmation (10 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md`. Release instructor hints one phase at a time if a team stalls. Do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief, not an answer-key value.

## Lesson summary

- Web-to-SQL is executed as a generated lesson plan from this file.
- The live chain is in the answer key; hints release one phase at a time.
- Next Module in the Block sequence continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The documented access chain and three flags. Do not put answer-key values in screenshots or the lesson plan.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Instructor hints: [`supporting-documents/L2.13 Web-to-SQL Instructor Hints.md`](./supporting-documents/L2.13%20Web-to-SQL%20Instructor%20Hints.md)
- Answer key / walkthrough: [`answer-key.md`](./answer-key.md)
