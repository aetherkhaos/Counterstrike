---
id: B01.M35-rubric
title: DGX Spark Team Buildout — Blank Student Rubric
artifact_type: rubric
audience: student
block: B01
module_type: group_activity
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
- xlsx
template_profile: rubric_v1
sensitivity: course_internal
---

# Lab L1.7b - Blank Student Rubric

**Student:** ______________________________  
**Team:** _________________________________  
**Instructor:** ____________________________  
**Date:** __________________________________

Use one copy per student. Each row uses fixed performance-level points:
Poor = 1, Marginal = 2, Acceptable = 3, Exemplary = 4. Record any row or category
weighting in the placeholders below or in the LMS, but keep the rubric table at
five columns. Suggested category weights are host and catalog evidence 25%,
gateway and comparison 25%, cloud model and secrets 20%, filesystem tool 15%,
and teamwork 15%. Row IDs map to the
grading checkpoints in the instructor answer key.

| Instructor question | Poor (1 pt) | Marginal (2 pts) | Acceptable (3 pts) | Exemplary (4 pts) |
| --- | --- | --- | --- | --- |
| **SA-1 (Weight: ___). Did the student show the chat and LiteLLM pages for this team's domain after installing the classroom root?** | No page evidence. Score: 1 | One page, or a certificate warning was clicked through. Score: 2 | Both pages load for this team's domain with the classroom root installed. Score: 3 | The student can say why a warning after that install is a fault. Score: 4 |
| **CK-1 (Weight: ___). Did the student list the gateway models and mark two small local chat ids?** | No model list. Score: 1 | A list with the key visible, or the small ids are not marked. Score: 2 | Redacted `/v1/models` output with two small `ollama/` chat ids marked, and the parameter count named for each. Score: 3 | The student can say an id is local because it starts with `ollama/`, and small because the count before `b` is 4 or 8 billion. Score: 4 |
| **CK-7 (Weight: ___). Did the student ask several other local models the same prompt and note what each one did?** | No other local models tried. Score: 1 | A different prompt, or no note on what each model did. Score: 2 | Same prompt, several other `ollama/` ids, and a note on what each one did. Score: 3 | The student can tie a difference to the parameter counts on those ids. Score: 4 |
| **CK-2 (Weight: ___). Did the student match those local ids to Open WebUI replies?** | No gateway listing and no chat evidence. Score: 1 | One of the two, or the key is visible in the packet. Score: 2 | The marked `ollama/` ids match the Open WebUI replies, and the key is redacted. Score: 3 | The student can say the cloud model was absent from the list until they added it. Score: 4 |
| **CK-3 (Weight: ___). Did the student compare two small models in Open WebUI through LiteLLM?** | No comparison, or the UI was never pointed at LiteLLM. Score: 1 | One model only, or two large models loaded together. Score: 2 | Same prompt, two small chat models, and a stated difference. Score: 3 | The student ties the difference to the parameter counts they read from those two ids. Score: 4 |
| **CK-4 (Weight: ___). Did the student show an Open WebUI answer from the cloud model on that student's account?** | Cloud model missing. Score: 1 | The team added it in the admin UI, but this student has no chat evidence. Score: 2 | This student's Open WebUI account shows an answer from that model. Score: 3 | The student can say the cloud call leaves the lab network and the local calls do not. Score: 4 |
| **CK-5 (Weight: ___). Did the student show the team poem file and name the workstation it was written on?** | No file. Score: 1 | A file exists somewhere else, or the student cannot show the path. Score: 2 | `poem.txt` is in the home directory of the workstation that registered the filesystem server, and the student can name that path. Score: 3 | The student can explain that LiteLLM on the DGX called the tool on that workstation. Score: 4 |
| **SS-1 (Weight: ___). Did the student keep the cloud model key and access-page secrets out of the packet?** | A token or key is in the packet or a screenshot. Score: 1 | A secret is partly visible or redaction is inconsistent. Score: 2 | Secrets are absent from the packet. Score: 3 | The student can say where those values live and why they are not submitted. Score: 4 |
| **CH-1 (Weight: ___). Did the student diagram the request path, including the workstation tool?** | No diagram or the path cannot be traced. Score: 1 | Diagram omits the gateway or the workstation. Score: 2 | Diagram shows browser, Open WebUI, LiteLLM, the model, and the workstation file. Score: 3 | The explanation is specific enough for another operator to repeat the path. Score: 4 |
| **TW-1 (Weight: ___). Did the student make a visible individual contribution to the team build?** | Contribution not visible in build, evidence, or brief. Score: 1 | Contribution limited or mostly passive. Score: 2 | Contribution visible and tied to a stage, task, or evidence artifact. Score: 3 | Contribution materially improved the team's build or troubleshooting. Score: 4 |
| **TW-2 (Weight: ___). Did the student collaborate, adapt to feedback, and handle Q&A on owned work?** | Could not explain owned work or resisted coordination. Score: 1 | Answered basics but struggled to separate facts from assumptions. Score: 2 | Coordinated, incorporated feedback, and answered with evidence. Score: 3 | Helped the team resolve issues and strengthened the handoff in Q&A. Score: 4 |

**Instructor notes:**  
______________________________________________________________________________  
______________________________________________________________________________  
______________________________________________________________________________

**Raw score:** __________ / 44  
**Weighted total:** __________ / __________
