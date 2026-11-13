---
id: B04.M14-ig
title: Agent Reinforcement — Instructor Guide
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

# Agent Reinforcement — Instructor Guide

## Objective and context

Students fork the saved happy-path workflow and harden it. A CTI 500 or bad JSON must not crash the run. Branch A stays on the local primary model. Branch B cross-checks the cloud frontier model. The run emits one structured indicator. Command-complete walkthroughs, the retry demo, and the observed label table stay in the answer key.

The schedule slot is 60 minutes. The student brief is about 2.5 hours. The parts below follow the brief.

## Instructor resources and pre-class

- n8n is already at `http://localhost:5678` on each student VM. Students use the personal account on that instance. They do not log into a shared team n8n.
- Publish the cloud frontier model id on **DGX Spark team access** before class. Branch B uses that id through team LiteLLM. Do not leave Branch B on a leftover alias.
- The course pack attaches `clean_malicious.log`, `ambiguous.log`, and `intel_fail_trigger.log` as File resources on this lab. Students copy them into the host directory mounted at `/lab_data`. The workflow path is `/lab_data/<file>`.
- `<team-domain>` in the brief is that team's `BASE_DOMAIN` from **DGX Spark team access**. CTI is `https://cti.<team-domain>`.
- Confirm n8n returns 200, LiteLLM lists the local primary alias and the published frontier id, and CTI returns 200 for `198.51.100.44` and 500 for `203.0.113.250`. Commands are in the answer key situational-awareness block.
- Classroom projector and screen; whiteboard for the opening contract.
- Do not project the LiteLLM key, the CTI bearer token, or answer-key outputs.

## Student resources

- Student brief in this Module folder
- Personal n8n at `http://localhost:5678`
- The three Moodle logs, copied into `/lab_data`
- LiteLLM URL and frontier model id from **DGX Spark team access**

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "The happy path already classifies a log. Today a lookup can fail and a model can return junk. The run still has to finish, and a second model has to be allowed to disagree."
- **Do:** Put three outcomes on the board: CTI 500 still finishes, bad JSON retries then stops, disagreement sets `needs_human_review`.
- **Ask (Q):** Which workflow do you edit, and which one do you leave alone?
- **Expected Response (A):** Edit only the duplicate named `Agent-Reinforcement-[LastName]`. Leave `Build an Agentic Workflow-[LastName]` as it is.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "The happy path already classifies a log. Today a lookup can fail and a model can return junk. The run still has to finish, and a second model has to be allowed to disagree."
- **Show:** The student brief task list and the three-file expect table.
- **Do:** Confirm each station can open n8n and that the original workflow still runs before anyone duplicates it.
- **Ask (Q):** Which workflow do you edit, and which one do you leave alone?
- **Expected Response (A):** Edit only the duplicate named `Agent-Reinforcement-[LastName]`. Leave `Build an Agentic Workflow-[LastName]` as it is.

## Facilitation flow

### Part 1: Fork the happy-path workflow. (10 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Duplicate keeps the credentials. Work only in the copy. Confirm the original is still in the list."
- **Show:** Student brief task 1. Workflow menu → Duplicate, then rename to `Agent-Reinforcement-[LastName]`.
- **Do:** Reject in-place edits of `Build an Agentic Workflow-[LastName]`.
- **Ask (Q):** Why duplicate instead of rebuilding the nodes?
- **Expected Response (A):** Duplicate keeps the credentials and the existing graph. The original stays as the untouched happy path.

### Part 2: Let a CTI 500 continue. (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Continue On Fail adds a second output so a 500 does not stop the run. The 500 is on the per-IP call, not on the seeded lookup."
- **Show:** Student brief task 2. Success goes to `Set Intel OK` (`intel_unavailable` false). Error goes to `Set Intel Error` (`intel_unavailable` true). Both enter `Merge CTI paths` in Append mode. `Set Intel Status` runs after the aggregate on either path.
- **Do:** If a successful lookup throws `No path back to node`, the format node is reading the error-only Set. Point it at `Set Intel Status`. Live commands and the fail-trigger test are in the answer key.
- **Ask (Q):** Why must `Set Intel Status` run on a good lookup and on a 500?
- **Expected Response (A):** Later steps read that node. An error-only Set has no path on a successful lookup.

### Part 3: Cap bad JSON on the local primary. (35 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Branch A stays on the local primary. Timeout caps the wait on a shared queue. The error item is only the error, so the retry count has to live in workflow static data."
- **Show:** Student brief task 3. Timeout `60000` ms. Continue On Fail on `SI Triage Agent` and `Parse SI Output`. `Set Retry Count` is on the wire into the agent only. `Retries Left?` is `retry_count` smaller than `2`. True increments and returns to the agent. False is `Set SI Error` and does not loop.
- **Do:** First-use: **Continue (using error output)** is the second connector, not a setting that swallows the error. `$getWorkflowStaticData('global')` survives the loop, which is why `Set Retry Count` sets the count back to `0` at the start. Prove the cap by replacing `Parse SI Output` with `throw new Error('not json');`. The agent runs three times, then `classification` is `ERROR`. Restore `JSON.parse` before the three-file runs. Asking the model for prose is a weak check because the retry sentence tells it to return JSON.
- **Ask (Q):** What does `retry_count` 0, then 1, then 2 mean?
- **Expected Response (A):** The first failure retries, the second retries, and the third stops. That is the original try plus two retries.

### Part 4: Cross-check with the cloud frontier model. (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Branch B is a different strategy on the published frontier id, not a second copy of the same prompt. Same LiteLLM credential. Turn off Use Responses API or a reasoning model can spend the budget before the JSON object is written."
- **Show:** Student brief task 4. Duplicate to `SI Triage Agent (Frontier)`. Merge both parses by position. `Compare Branches` sets `needs_human_review` when the classifications differ. Keep `Is Threat Malicious?` and feed it Branch A.
- **Do:** Identical prompts on both branches are a fail: `needs_human_review` never fires. Do not point Branch B at vLLM or at an expired alias.
- **Ask (Q):** What does `needs_human_review: true` mean for the operator?
- **Expected Response (A):** The two models disagreed. A person decides. Higher confidence is not automatically the answer.

### Part 5: Emit the structured indicator. (15 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "The final item has to match the shape in the brief. Full STIX validity is not the bar. `confidence` has to be a number."
- **Show:** Student brief task 5, `Format Structured Output`. The extension carries `intel_unavailable`, `needs_human_review`, `branch_classifications`, and `source_artifact`.
- **Do:** `crypto.randomUUID()` throws in this code sandbox. The indicator id is built from `Date.now()` and `Math.random()`, as in the brief.
- **Ask (Q):** Which classification and confidence land on the indicator?
- **Expected Response (A):** Branch A, the local primary. Branch B is the cross-check, not the value written into `confidence`.

### Part 6: Run the three logs. (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Change the path in `Read Syslog File` and run the whole workflow once per file. Save each JSON output."
- **Show:** Student brief task 6 expect table.
- **Do:** Grade the flags in the expected-outputs section, not a single model's wording. `ambiguous.log` passes when the labels differ. `intel_fail_trigger.log` passes when the run finishes and `intel_unavailable` is true.
- **Ask (Q):** Which file is the CTI 500 check, and what must be true?
- **Expected Response (A):** `intel_fail_trigger.log`. The run completes with `intel_unavailable: true`.

### Part 7: Export and reflect. (15 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Export the copy, screenshot the canvas, and write where the branches disagreed and which one you trust."
- **Show:** Student brief deliverables. Export name `Agent-Reinforcement-[LastName].json`.
- **Do:** A strong reflection cites one disagreement and compares the rationales. "The frontier model is always right" with no evidence is weak.
- **Ask (Q):** What four things do you turn in?
- **Expected Response (A):** The canvas screenshot, the exported workflow JSON, three structured outputs, and the one-paragraph reflection.

## Expected outputs

Grade these flags. A different frontier model can pick different words. The observed label table in the answer key is an example, not the required wording.

| Input | Pass when |
| --- | --- |
| `clean_malicious.log` | Branches agree. `intel_unavailable` is false. |
| `ambiguous.log` | Classifications differ, so `needs_human_review` is true. |
| `intel_fail_trigger.log` | The run finishes. `intel_unavailable` is true. |
| Forced bad parse | `SI Triage Agent` runs three times, then `classification` is `ERROR` and `confidence` is `0`. Restore the parser afterward. |

Each saved output matches the task 5 shape: `type` `indicator`, numeric `confidence`, and a `cs_ops_week4` extension with the four fields above.

## Troubleshooting

Keep this separate from the walkthrough. Details and the restore-the-parser demo are in the answer key under the retry section and Common mistakes.

| What you see | What to check |
| --- | --- |
| Original workflow was edited | Student worked in place. They need a duplicate, and the original still in the list. |
| Run dies on a CTI 500 | Continue On Fail is missing on the per-IP HTTP node, or the error output is not wired to `Set Intel Error`. |
| `No path back to node` on a good lookup | A later node reads the error-only Set. Point it at `Set Intel Status`. |
| Retry never stops | `Retries Left?` is not `retry_count` smaller than `2`, or the false path wires back to the agent. |
| `No path back to referenced node` on the retry count | A Set node is reading its own last value. Use the Code nodes and workflow static data from the brief. |
| Second and third prompts lack the invalid-JSON sentence | `retry_count` is not traveling on the item. `Set Retry Count` has to copy the syslog and CTI fields onto the item. |
| Branch B matches Branch A on every file | The frontier node still has the primary prompt, or it is still on the local primary model. |
| Parse fails on the frontier branch with a cut-off number | **Use Responses API** is still on. Turn it off so the JSON object is written. |
| `crypto is not defined` | The code sandbox has no `crypto`. Use the id expression in the brief. |
| `confidence` is a string, or the extension is missing | The format node did not follow the task 5 shape. |
| `intel_fail_trigger.log` was skipped | That file is the 500 check. The other two logs do not set `intel_unavailable`. |

## Lesson summary

- A failed lookup and a bad model response still have to produce a finished record.
- The local primary is the value that is written. The frontier model is the disagreement check.
- `needs_human_review` is the point where a person decides.

## Questions and check on learning

- **Ask (Q):** What still finishes the run when CTI returns 500 or the model returns junk?
- **Expected Response (A):** Continue On Fail, a retry cap, and `Set SI Error` so the merge is not left waiting. Disagreement is marked for a person; it does not delete the record.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Answer key / walkthrough: [`answer-key.md`](./answer-key.md)
