---
id: B04.M05-ig
title: C2 Tool Evaluation Peer Handoff — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B04
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

# C2 Tool Evaluation Peer Handoff — Instructor Guide

## Objective and context

Facilitation SoT for the generated lesson plan. Students individually evaluate one offensive C2 framework on the exploitation range they already built (Kali ops, chosen redirector, Windows target), document it to the peer-handoff standard, then swap so a peer must install and complete a minimal validation task from the dossier alone on **that peer's own cell**.

There is no classic discovery-to-flag walkthrough. Grade dossier reproducibility and peer-execute success using [`rubric.md`](./rubric.md). Grading crosswalk, dispute handling, and troubleshooting live in [`answer-key.md`](./answer-key.md). Pre-class staging lives in [`setup-guide.md`](./setup-guide.md).

C2 Matrix / shortlist is a lab selection aid, not lecture content.

## Instructor resources and pre-class

Use the pre-class staging checklist in [`setup-guide.md`](./setup-guide.md):

- Shortlist packages staged (Sliver, Mythic, Havoc, Covenant, or the live legal set)
- Share readable from student ops stations / test VMs
- Peer pairing roster published
- Rubric and peer review form ready
- Isolation briefed: no targeting classmate IP blocks
- Students reminded to power down unused rehearsal VMs

Do not project dossier answers or demo the C2 during the peer-execute window.

## Student resources

- Student brief and [`supporting-documents/L4.0.b Peer Review Form.md`](./supporting-documents/L4.0.b%20Peer%20Review%20Form.md)
- Assigned vSphere folder and the exploitation range already built (Kali ops, redirector, Windows)
- Instructor-staged package path only — no live internet pull

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "The product is a dossier a peer can execute without you. If they need you in the room, the docs failed."
- **Do:** Post pairing roster, RAM/IP constraints, and the sealed-dossier rule.
- **Ask (Q):** What is forbidden during the peer-execute window?
- **Expected Response (A):** Live author coaching. Instructor answers only environment-breakage questions.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "The product is a dossier a peer can execute without you. If they need you in the room, the docs failed."
- **Show:** Student-brief Part A/B and the peer review form.
- **Do:** Confirm vCenter console access and staged share paths before the author window.
- **Ask (Q):** What is forbidden during the peer-execute window?
- **Expected Response (A):** Live author coaching. Instructor answers only environment-breakage questions.

## Facilitation flow

### Step 1: Select framework (20 min)

- **Say:** "One framework per student. Use the cell you already built. Do not deploy a new server-and-target pair."
- **Show:** Approved shortlist from the setup guide. Force diversity across the room if needed.
- **Do:** Confirm unique frameworks where possible. Record share paths.
- **Ask (Q):** May a student download a framework during class?
- **Expected Response (A):** No. Final pick must map to a staged package.

### Step 2: Author window (70 min)

- **Say:** "Install the teamserver on Kali, build a beacon, run it on Windows so the callback traverses the redirector, task it, then write the dossier. No peer help yet."
- **Show:** Dossier sections in the student brief.
- **Do:** Circulate for environment faults only. Do not write their employment workflow.
- **Ask (Q):** What must the dossier let a peer do?
- **Expected Response (A):** Install the teamserver on Kali, build/deploy a beacon on Windows with callback through the redirector, and complete the named validation task.

### Step 3: Seal and swap (15 min)

- **Say:** "Exchange dossiers and installer paths only. Start the execute clock."
- **Show:** Peer review form. No author coaching.
- **Do:** Collect a copy or snapshot of sealed dossiers if grading disputes are likely.
- **Ask (Q):** What may the instructor answer during execute?
- **Expected Response (A):** Environment breakage only (ISO/share down, pool exhausted).

### Step 4: Peer execute (50 min)

- **Say:** "Reviewer uses only the dossier and approved media, on their own cell."
- **Show:** PH-5 success standard in the rubric (install + beacon + tasking).
- **Do:** Stop cross-student targeting immediately. Do not demo the C2 for a stuck reviewer.
- **Ask (Q):** What evidence proves peer success?
- **Expected Response (A):** The peer completed install, beacon build/deploy, and teamserver tasking under sealed-dossier rules.

### Step 5: Review forms, hotwash, teardown (25 min)

- **Say:** "Capture gaps. Revise the dossier if time remains. Then listeners down and VMs off."
- **Show:** Hotwash notes requirement and teardown steps.
- **Do:** Verify no leftover teamservers on shared networks.
- **Ask (Q):** What two roles is each student graded in?
- **Expected Response (A):** Author (dossier) and reviewer (peer-execute form).

## Timing

Protect the 180-minute window. Author work must finish with a sealed dossier before peer execute starts.

## Common stalls

- RAM pressure from VMs you are not using for this test — power them down.
- Share not reachable — fix connectivity; do not authorize internet pulls.
- Listener bind conflicts — keep services inside the student `/29`.
- Peer stuck on OS basics — point to dossier prerequisites; do not demo the C2.

## Lesson summary

- Documentation is the operational product; peer-execute is the test.
- Closed-environment discipline (RAM, IP, staged media) carries into later effects products.

## Questions and check on learning

- **Ask (Q):** What product does this lab collect, and what must not appear in the evidence?
- **Expected Response (A):** Dossier, peer review form, hotwash notes, and a RAM/IP resource note. Do not put answer-key coaching into student screenshots.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Setup: [`setup-guide.md`](./setup-guide.md)
- Rubric: [`rubric.md`](./rubric.md)
- Peer review form: [`supporting-documents/L4.0.b Peer Review Form.md`](./supporting-documents/L4.0.b%20Peer%20Review%20Form.md)
- Answer key: [`answer-key.md`](./answer-key.md)
