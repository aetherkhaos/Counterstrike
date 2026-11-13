---
id: B04.M18-ig
title: Adversary Agent CounterStrike — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# Adversary Agent CounterStrike — Instructor Guide

## Objective and context

Students develop counter-strike techniques against a replica of an adversary n8n tasking system. The replica is the exported workflows plus the operations station. Inference is the course DGX Spark stack, using `llama3.1:8b` for tasking and `qwen3.5:4b` for file summaries. Command-complete walkthroughs stay in the answer key.

## Instructor resources and pre-class

- Classroom projector and screen; whiteboard for the opening contract
- Student brief and answer key in this Module folder
- Mint a new `n8n-auth` cookie before this Module. The step is on the pre-course checklist and in the replica Quick Start. A cookie from a previous offering does not carry forward.
- Confirm the replica workflows are active and team1 answers for `ollama/llama3.1:8b` and `ollama/qwen3.5:4b`
- Do not project the cookie, the operator password, or the inference key

## Student resources

- Student brief for this Module
- Ops station with a browser and `curl`
- The `n8n-auth` value printed in that brief
- No local model install on the ops station

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "On a recent mission, a hunt cell exported these adversary workflows. This range is that replica. Today you develop the techniques. The live-system operation comes later."
- **Do:** Put the three workflow names and the two model tags on the board. Confirm the cookie opens the UI before the first curl.
- **Ask (Q):** What are you doing today, and what are you not doing today?
- **Expected Response (A):** Developing techniques against the replica. Not running the operation on the live system.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "On a recent mission, a hunt cell exported these adversary workflows. This range is that replica. Today you develop the techniques. The live-system operation comes later."
- **Show:** The student brief mission context and the service address table.
- **Do:** Confirm each station can open the n8n UI with the cookie and reach the webhook proxy health check.
- **Ask (Q):** What are you doing today, and what are you not doing today?
- **Expected Response (A):** Developing techniques against the replica. Not running the operation on the live system.

## Facilitation flow

### Part 1: Open the operator session and map the three workflows. (40 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "The captured session cookie is how you open the UI as the adversary operator. Each student has their own copy of the workflows. Point both model nodes at your team's LiteLLM host and key before you send traffic. Then map the workflows."
- **Show:** Student brief Part 1, including the teamX replacement. Live walkthrough in `answer-key.md`.
- **Do:** Help with the cookie if the UI stays on the sign-in page. Confirm both code nodes no longer say `teamX` or `TEAM_LITELLM_KEY`. Do not issue a password.
- **Ask (Q):** Why does a production webhook require the workflow to be active?
- **Expected Response (A):** n8n serves `/webhook/...` only for active workflows.

### Part 2: Walk the check-in dispatcher. (30 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "A check-in with an empty queue returns a survey task. The execution log shows whether Postgres had a pending task."
- **Show:** The check-in curl in the student brief and the dispatcher execution.
- **Do:** If the response is already `collect`, `reboot`, or `delete_self`, decide whether to reset the queue before the class continues.
- **Ask (Q):** Why does the workflow claim a task before returning it?
- **Expected Response (A):** So a second check-in does not receive the same task.

### Part 3: Walk survey analysis and tasking. (70 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "The survey workflow asks `llama3.1:8b` for a task decision, then queues only reboot, collect, or delete_self."
- **Show:** A no-task survey, then one survey that should queue a collect.
- **Do:** Have students read the LLM node output and the follow-up check-in, not only the webhook JSON.
- **Ask (Q):** What is the difference between the model text and the payload stored for the implant?
- **Expected Response (A):** The model text is the raw response. The stored payload is what the workflow parsed and is willing to queue.

### Part 4: Walk file summary and the updates feed. (40 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "The collection workflow asks `qwen3.5:4b` for a four-line summary, stores the original, and appends the summary to the updates page. The adversary side reads that page regularly and opens the original when the summary marks sensitivity high."
- **Show:** The collection curl, the summary node, and the newest card on the updates page, including Open original file.
- **Do:** Confirm the new card is present. A callback comes from the opened original, not from the summary text.
- **Ask (Q):** Why keep the original file when a summary already exists?
- **Expected Response (A):** The summary is an interpretation. The original is the artifact to re-check, and it is what gets opened when sensitivity is high.

### Part 5: Steer tasking with implant telemetry. (70 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Change the webhook JSON only. Leave the workflows as they are. Two attempts need to change a queued task or a published summary."
- **Show:** The evidence table in the student brief.
- **Do:** Require a follow-up check-in before anyone claims the implant would have received the task.
- **Ask (Q):** Why is the follow-up check-in required?
- **Expected Response (A):** The survey workflow queues the task. The check-in workflow is what would deliver it.

### Part 6: Try a response outside the workflow contract. (40 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Push the model toward a task type or a format the workflow did not ask for. Then see whether the workflow accepts, drops, or ignores that output."
- **Show:** The novelty checks in the student brief.
- **Do:** Separate model behavior from what the workflow stored or published.
- **Ask (Q):** Is a tricked model enough to change implant behavior?
- **Expected Response (A):** No. The workflow still has to parse, accept, store, and deliver that output.

## Lesson summary

- The range is a replica of exported adversary workflows. Today was technique development.
- Untrusted survey and collection fields can move the two small models.
- The workflow allow-list and parser still decide what becomes implant tasking or a published summary.

## Questions and check on learning

- **Ask (Q):** What did the hunt cell recover, and what did this range keep from that mission?
- **Expected Response (A):** An operator API key, used to export the workflows. This range has those workflows and the operations station.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Answer key / walkthrough: [`answer-key.md`](./answer-key.md)
- Replica setup and cookie mint: [`environments/b04_l45_adversary_agent/README.md`](../../../../environments/b04_l45_adversary_agent/README.md)
