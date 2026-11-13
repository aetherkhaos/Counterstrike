---
id: B03.M07-ig
title: On-Target Group Assessment — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B03
module_type: assessment
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# On-Target Group Assessment — Instructor Guide

## Objective and context

Culminating on-target assessment. Teams apply the full tactical planning process, then enumerate, gain authorized access, and survey adversary terrain. Grade planning completeness, access discipline (wait for commander decision), survey quality, briefs, and individual contribution using [`rubric.md`](./rubric.md). Expected products and grading checkpoints live in [`answer-key.md`](./answer-key.md).

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Two phases. Phase 1 is plan and a decision-point brief. Do not touch adversary infrastructure until the commander approves an access vector."
- **Do:** Hand out EIS Group Seraph-3, Seraph-3 Threat Hunt Report, network map, hunt notes, and the tactical planning student guide. Form teams of four.
- **Ask (Q):** What must you wait for before attempting access?
- **Expected Response (A):** Commander decision after the Phase 1 brief of concrete initial-access options.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Two phases. Phase 1 is plan and a decision-point brief. Do not touch adversary infrastructure until the commander approves an access vector."
- **Show:** Student-brief timeline and Phase 1/2 deliverable lists.
- **Do:** Confirm every team can open the five start-of-day inputs.
- **Ask (Q):** What must you wait for before attempting access?
- **Expected Response (A):** Commander decision after the Phase 1 brief of concrete initial-access options.

## Instructor resources and pre-class preparation

Before assessment start:

1. Confirm students have:
   - [`student-brief.md`](./student-brief.md)
   - [`supporting-documents/it-wks1-hunt-notes.md`](./supporting-documents/it-wks1-hunt-notes.md)
   - [`supporting-documents/Tactical_Planning_Part_2.md`](./supporting-documents/Tactical_Planning_Part_2.md)
   - EIS Group Seraph-3 / Seraph-3 Threat Hunt Report / network map as issued for this class
2. Prepare one rubric copy per student or LMS entry ([`rubric.md`](./rubric.md)).
3. Assign teams of four when possible.
4. Post the mission statement, commander’s intent (purpose / key tasks / end state), and the wait-for-decision rule.
5. Set visible time boxes for both work phases and both 10-minute brief windows.
6. Confirm live range access for Phase 2 (after approval only).

## Student resources and environment

- Scenario packet and hunt notes listed above
- Issued tactical planning worksheets
- Live adversary infrastructure **after** commander approval
- Laptops for packet/CAD/briefs; do not require extra installs beyond the assigned range

## Facilitation flow

### Step 1: In-brief and team formation (15 min)

- **Say:** Read the issued **mission** (interdict IOT deny/degrade collection) and the **commander’s intent** (purpose, key tasks, end state). Intent purpose is broader than the mission “IOT.” No access until the commander decides.
- **Show:** Five start-of-day inputs. Timeline 0800–1700 from the student brief.
- **Do:** Form teams. Answer scope questions. Repeat: no access before Phase 1 decision.
- **Ask (Q):** What products are due at the end of Phase 1?
- **Expected Response (A):** METT-TC through tasks, ATT&CK/D3FEND/ENGAGE pairings, CAD, SOM/FSP/tasks, and concrete access vectors for a commander decision.

### Step 2: Phase 1 work (180 min)

- **Say:** "Build the input side of the planning process. Access vectors must be evidence-based, not platitudes."
- **Show:** Student-brief Phase 1 list. Expected packet standards in the answer key.
- **Do:** Circulate. Stop any team that starts exploitation. Push RFIs instead of invented certainty.
- **Ask (Q):** Where do destination clues for later access come from?
- **Expected Response (A):** Hunt notes, threat report, and prior planning and on-target evidence — not instructor spoilers.

### Step 3: Phase 1 briefs and commander decision (50 min)

- **Say:** "Ten minutes (8+2). Brief the exploitation plan with concrete technical detail and wait for the decision."
- **Show:** AC-1 rubric row: wait for commander decision before attempting access.
- **Do:** Approve, redirect, or withhold access per team. Record the authorized vector.
- **Ask (Q):** What happens if a team already has a shell before this brief?
- **Expected Response (A):** AC-1 fails. Stop them and score the gate.

### Step 4: Phase 2 work — access and survey (150 min)

- **Say:** "Execute only the approved vector. Survey adversary terrain and update the plan."
- **Show:** Phase 2 AAR T-code list and graphical depiction requirement.
- **Do:** Range-fault support only. Do not complete their exploit. Require planning-product updates from survey.
- **Ask (Q):** What must change after survey?
- **Expected Response (A):** SOM/tasks and commander options, not just a screenshot of a prompt.

### Step 5: Phase 2 briefs and hot wash (90 min)

- **Say:** "Commander-ready execution brief: exploitation plan, SOM, FSP, tasks, and confidence in stopping the bleeding."
- **Show:** Visual aid expectation (CAD + map). Collect packets and contribution notes.
- **Do:** Q&A across teammates. Score TW-1 from observation plus packet.
- **Ask (Q):** Which survey finding changed the plan?
- **Expected Response (A):** A named terrain or access fact, tied to an updated task or option.

## Timing

- 0800–0815 — In-brief, scenario hand-out, team formation
- 0815–1115 — Phase 1 work
- 1115–1205 — Phase 1 team briefs
- 1205–1300 — Lunch / instructor feedback
- 1300–1530 — Phase 2 work
- 1530–1630 — Phase 2 team briefs
- 1630–1700 — Hot wash / packet collection

## Common stalls

- Jumping to access before the Phase 1 decision
- Vague access talk with no technical evidence
- Framework names without ATT&CK→D3FEND/ENGAGE pairing or CAD
- One-person brief; other members invisible
- Survey that does not update SOM/tasks

## Lesson summary

This assessment validates enumeration, initial access, and situational awareness **inside** the tactical planning process. Access without an updated commander product is incomplete.

## Questions and check on learning

- **Ask (Q):** Why is the Phase 1 access brief a decision point rather than a start-work whistle?
- **Expected Response (A):** The commander must approve the vector; unauthorized access fails AC-1.
- **Ask (Q):** What T-code families must the Phase 2 AAR name?
- **Expected Response (A):** Initial access, code execution, privilege escalation, defense impairment/stealth, situational awareness, collection/exfil, and C2/interact — only those the team actually used.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Rubric: [`rubric.md`](./rubric.md)
- Hunt notes: [`supporting-documents/it-wks1-hunt-notes.md`](./supporting-documents/it-wks1-hunt-notes.md)
- Answer key: [`answer-key.md`](./answer-key.md)
