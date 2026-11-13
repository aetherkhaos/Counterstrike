---
id: B04.M13-ig
title: Build Agentic Workflow Lab — Instructor Guide
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

# Build Agentic Workflow Lab — Instructor Guide

## Objective and context

Facilitation SoT for the generated lesson plan. Command-complete walkthroughs stay in the answer key. Build Agentic Workflow Lab.

## Instructor resources and pre-class

- n8n is preinstalled from `environments/b04_m13_student_n8n/` at `http://localhost:5678` on each student VM. `N8N_RESTRICT_FILE_ACCESS_TO` is unset on purpose.
- Point students at that VM for this run. The same steps apply on a classroom VM and on a PCTE HWIL VM.
- LiteLLM is the team DGX. The URL and key are on **DGX Spark team access**. Do not project the key.
- The VM must reach team LiteLLM and the class CTI API.

## Student resources

- Student brief, student guide, or homework file in this Module folder when present
- Assigned range, workstation, or lab stack named in the student-facing file
- No extra kit beyond what the student-facing file already lists

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Build Agentic Workflow Lab: students execute the assigned lab workflow and collect the stated deliverable."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The student-facing deliverable. Do not put flags, tokens, or answer-key values in screenshots or the lesson plan.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Build Agentic Workflow Lab: students execute the assigned lab workflow and collect the stated deliverable."
- **Show:** The student brief objective and assigned scope.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The student-facing deliverable. Do not put flags, tokens, or answer-key values in screenshots or the lesson plan.

## Facilitation flow

### Step 1: Confirm access and student-facing tasking (80 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student brief or student guide for this step. Answer key stays instructor-only.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Step 2: Execute the student-facing workflow (80 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student brief or student guide for this step. Answer key stays instructor-only.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** The extract node timed out. What shows the model was still writing?
- **Expected Response (A):** The streamed completion showed reasoning tokens, and the capped run keeps the team slot busy for about 20 seconds after the node has already failed.

### Step 3: Collect the deliverable without exposing keys (80 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Work this step from the student-facing file. Evidence first; do not skip to the answer key."
- **Show:** Student brief or student guide for this step. Answer key stays instructor-only.
- **Do:** Timebox this step. Troubleshoot access and tool readiness. Do not project flags or tokens.
- **Ask (Q):** What evidence tells you this step is done?
- **Expected Response (A):** A student-facing artifact or observation already named in the brief or guide, not an answer-key value.

## Thinking-model timeout

`ollama/qwen3.5:4b` writes its reasoning before the answer. The lab syslog extract is about 700 tokens. With thinking left on and no token cap, Ollama generates until the model stops or the 262144 context fills. In the live walkthrough that completion passed 73000 tokens at about 68 per second. n8n reported a timeout. LiteLLM held the upstream connection, so generation continued after the node had failed. `ollama stop` does not interrupt a completion that is already running.

Students induce a bounded copy of that failure. One student at a time: the team has one model slot. They stream a 120-token completion and see reasoning text instead of the requested word. They then execute the extract node with **Max Tokens** `1500` and **Timeout** `10000`. The node times out at 10 seconds. The slot frees itself about 10 seconds later. They set **Extra Body** to `{"think": false}` and **Max Tokens** to `500`, then execute again. Expect `172.20.2.14` and `198.51.100.44`.

If a student clears the token cap, the slot does not free itself. On the team host, `ollama ps` lists what is resident:

```bash
cd /opt/stack/student-spark
docker compose exec -T ollama ollama ps
```

A model that stays loaded after the n8n node has failed is still generating. `n_gen` in the Ollama log is how many tokens this completion has produced. If that number keeps rising, the runner is still in the same request:

```bash
docker compose logs --tail 5 ollama
```

Stop that runner. `ollama stop` only unloads the model after the current completion ends.

```bash
docker compose exec -T ollama sh -c 'kill $(pidof llama-server)'
```

`pidof llama-server` is the process holding the slot. Killing it frees the slot. The Ollama service stays up. The student then applies the Extra Body and Max Tokens settings above.

## Lesson summary

- Build Agentic Workflow Lab is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** The student-facing deliverable. Do not put flags, tokens, or answer-key values in screenshots or the lesson plan.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Student guide: [`student-guide.md`](./student-guide.md)