---
id: B04.M19-key
title: Effects Group Assessment — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B04
module_type: assessment
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Effects Group Assessment — Instructor Answer Key

## Objective and starting context

Grading reference for the effects group assessment. Facilitation and timing live in [`instructor-guide.md`](instructor-guide.md). Score with [`rubric.md`](rubric.md) **after** automatic-fail and major-penalty gates.

Each team begins with authorized redirector access. There is no single required effect. Grade mission relevance, rehearsal discipline, execution evidence, BDA honesty, and SHINY HAMMER handling.

## Flag / reference table

| Item | Source | Notes |
| --- | --- | --- |
| Starting access | Instructor / range card | Authorized adversary redirector in greyspace |
| Mission | Student brief | Disrupt Varenskian operations from authorized redirector access IOT deny/degrade FoM against Lunovia |
| Commander’s intent | Student brief | Purpose / key tasks / end state; SHINY HAMMER protection plus a measurable effect |
| Protected operation | Student brief | OPERATION SHINY HAMMER — paraphrase detection required |
| Effect vocabulary | Student brief | deny, degrade, disrupt, deceive, manipulate, reconnoiter, handoff |
| Pre-execution check | Student brief | Must be approved before live effect |
| Grading instrument | `rubric.md` | EF-1–EF-7 plus gates |

No Hiera flag. Grade packets, logs, and briefs.

## Initial situational awareness

On the ops station and again on the redirector **after access validation** (not before approval to execute effects):

```bash
date -u
hostname
whoami
id
pwd
uname -a
ps aux
ss -tulpen
```

Expected findings: team is on the authorized redirector, not a classmate host; listeners and processes match the prior on-target survey enough to plan monitoring locations (staging, logs, queues, forwarders).

## Instructor live walkthrough

Expected instructor flow (not a single exploit):

1. **Gates first.** Automatic fail: destructive/out-of-scope action; fabricated evidence; confirmed SHINY HAMMER data with no commander alert. Major penalty: keyword-only monitoring; preventable loss of redirector access; execution before approval; broad unrelated deletion.

2. **Phase 1 products.** Updated METT-TC/EMLCOA/CG/CV from prior blocks; named effect tied to CV; SOM/FSP/tasks with rollback; BDA plan that separates MoP/MoE; SHINY HAMMER monitoring that names locations **and** a semantic/contextual method.

3. **Phase 2 rehearsal.** Must test access, comms, abort, BDA collection, and alerting — not only a verbal walkthrough. Written pre-execution check approved by instructor-as-commander.

4. **Phase 3 execution.** In-scope effect with before/after evidence; access preserved; monitoring log; if a hit: metadata, delete, immediate alert.

5. **Briefs.** Planned effect vs achieved; rehearsal finding that changed execution; BDA confidence; SHINY HAMMER result; follow-on recommendation.

### Acceptable SHINY HAMMER detection (not exhaustive)

Accept methods that would catch paraphrases, summaries, euphemisms, and adjacent operational details from the student-brief **protected-operation background** (littoral / choke-point / 48-hour pulse / radar and missile batteries / port repair / host-nation training, and similar) without relying only on the string `SHINY HAMMER`. Keyword lists may be a **component**, not the whole method. Do not require an agentic workflow; it is one valid approach.

### Acceptable primary effects

Any doctrine-named effect that is authorized, scoped to the redirector access, measurable, and compatible with continued monitoring. Do not require a specific TTP.

## Troubleshooting / confirmation

- Team wants to execute at the end of Phase 1: withhold; rehearsal is required.
- Monitoring plan is a grep for `SHINY HAMMER`: send back; major penalty if they execute that way.
- BDA lists only commands run: push for adversary-change claims and uncertainty.
- Access lost: if preventable, major penalty; if environment fault, do not double-penalize EF-4/EF-6 for the outage interval.
- Confirmed protected data not alerted: automatic fail.

## Grading checkpoints

Recommended order: gates → planning brief → rehearsal notes → execution/BDA evidence → monitoring log → briefs/AAR.

| Rubric | Weight | Evidence | Acceptable standard |
| --- | --- | --- | --- |
| EF-1 | 15 | Planning brief | Mission-relevant effect grounded in CG/CV and redirector terrain |
| EF-2 | 20 | SOM/FSP/tasks | Executable, deconflicted, rollback present |
| EF-3 | 15 | Rehearsal notes + signed check | Sequence tested; execution only after approval |
| EF-4 | 15 | Before/after evidence | Intended effect in scope; access preserved |
| EF-5 | 10 | BDA | MoP vs MoE, confidence, follow-on |
| EF-6 | 20 | Monitoring log | More than keyword search; correct delete/alert handling |
| EF-7 | 5 | Briefs + AAR | Commander-focused; multiple teammates visible |

Score EF-1–EF-5 from the primary effect path; score EF-6 separately. A strong primary effect does not offset weak protected-information handling.
