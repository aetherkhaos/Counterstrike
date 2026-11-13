---
id: B04.M16-ig
title: Effects Advisor Agent — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B04
module_type: lab
source_status: authored
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# Effects Advisor Agent — Instructor Guide

## Objective and context

Facilitation SoT for the generated lesson plan. Command-complete walkthroughs stay in the answer key. Effects Advisor Agent.

## Instructor resources and pre-class

- n8n is already at `http://localhost:5678` on each student VM. Chroma is already in that compose. Heartbeat is `http://127.0.0.1:8000/api/v2/heartbeat`.
- The team gateway already serves LiteLLM alias `embed` (`ollama/qwen3-embedding:0.6b`). Students do not add a model server.
- `<team-domain>` in the brief is that team's `BASE_DOMAIN` from **DGX Spark team access**.
- Publish the local primary alias. Both chat and embeddings call team LiteLLM.
- Classroom projector and screen; whiteboard for the opening contract
- Parent or sibling briefs listed in this Module folder
- Live tabs and references already named in this file's header
- Do not project flags, tokens, or answer-key values

## Student resources

- Student brief, student guide, or homework file in this Module folder when present
- Assigned range, workstation, or lab stack named in the student-facing file
- No extra kit beyond what the student-facing file already lists

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Effects Advisor Agent: students execute the assigned lab workflow and collect the stated deliverable."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The student-facing deliverable. Do not put flags, tokens, or answer-key values in screenshots or the lesson plan.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Effects Advisor Agent: students execute the assigned lab workflow and collect the stated deliverable."
- **Show:** The student brief objective and assigned scope.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The student-facing deliverable. Do not put flags, tokens, or answer-key values in screenshots or the lesson plan.

## Facilitation flow

### Step 1: Add Workflow (40 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md` — do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Step 2: Code (40 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md` — do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief or guide, not an answer-key value.

### Step 3: Code (40 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student-facing file for the task; live walkthrough in `answer-key.md` — do not read flag values aloud unless grading.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief or guide, not an answer-key value.

## Lesson summary

- Effects Advisor Agent is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The student-facing deliverable. Do not put flags, tokens, or answer-key values in screenshots or the lesson plan.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Answer key / walkthrough: [`answer-key.md`](./answer-key.md)