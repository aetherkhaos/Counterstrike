---
id: B01.M36-ig
title: Planning Group Assessment — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B01
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

# Planning Group Assessment — Instructor Guide

## Objective and context

Use this as the facilitation guide for the Week 1 culminating assessment. The goal is not to force every team into one identical answer. The goal is to verify that students can reason from mission, enemy, terrain, evidence, and doctrine into a disciplined commander-ready plan.

Instructor note: This requires live infrastructure. Student outputs are planning artifacts, CAD products, and commander briefs.

Expected products, sample EMLCOA/CG/CV language, and rubric mapping stay in [`answer-key.md`](./answer-key.md).

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "This is the Week 1 culminating assessment. You are graded on evidence-based reasoning, usable planning products, and team execution — not on naming the most tools."
- **Do:** Post the mission and commander’s intent. Assign teams of four when possible. Set visible time boxes for both work phases and both brief windows.
- **Ask (Q):** What products are due, and what must teams not do during the assessment?
- **Expected Response (A):** Phase 1 packet, Phase 2 execution products, CAD graph, commander briefs, and a team contribution note. Do not execute live actions.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "This is the Week 1 culminating assessment. You are graded on evidence-based reasoning, usable planning products, and team execution — not on naming the most tools."
- **Show:** The student brief deliverables and the two-phase model.
- **Do:** Confirm every team can open the threat intelligence sheet and network map before Phase 1 work starts.
- **Ask (Q):** What products are due, and what must teams not do during the assessment?
- **Expected Response (A):** Phase 1 packet, Phase 2 execution products, CAD graph, commander briefs, and a team contribution note. Do not execute live actions.

## Instructor resources and pre-class preparation

Before assessment start:

1. Confirm students have access to:
   - `L1.8 Student Brief.md`.
   - `supporting-documents/L1.8 Threat Actor Intelligence Sheet - Amber Tide.md`.
   - `supporting-documents/L1.8 Lunovia Network Map.png`.
   - Tactical planning worksheets.
   - ATT&CK, D3FEND, ENGAGE, and CAD reference material already used in Week 1.
2. Prepare one blank packet or shared workspace per team for:
   - Mission analysis.
   - METT-TC.
   - SALUTE.
   - DRAW-D.
   - Friendly and enemy OCOKA-W.
   - EMLCOA.
   - CG/CV.
   - ATT&CK-to-D3FEND/ENGAGE mapping.
   - CAD graph.
   - SOM, FSP, and task list.
3. Prepare one copy of `L1.8 Blank Student Rubric.md` per student or per LMS grading entry.
4. Assign teams of four when possible. Teams of three or five are acceptable.
5. Post the mission and commander’s intent from the student brief. Minimum mission text:

```text
On order, Counterstrike teams interdict Varenskian collection on the Lunovia Network IOT deny or degrade the adversary’s ability to collect intelligence.
```

6. Set visible time boxes for both work phases and both brief windows.
7. Remind students that the assessment is graded on evidence-based reasoning, usable planning products, and team execution, not on naming the most tools.
8. Do not repackage prior lectures, general scenario background, or previously issued framework handouts as L1.8 supporting documents. Students may use them as references, but the exercise-specific support packet should remain limited to the local threat intelligence sheet and network map.

## Student resources and environment

This assessment does not use:

- a range VM;
- an ops-station-to-target foothold;
- a remote shell;
- a C2 server;
- live malware;
- Docker, local services, or cloud accounts.

Students operate from scenario materials, lecture notes, planning worksheets, and team-produced artifacts. If they use laptops, they are only for reading files, drafting packets, drawing graphs, and preparing briefs.

Do not require internet access. Do not require students to install software. If a team cannot access a reference site, provide the relevant ATT&CK, D3FEND, ENGAGE, or CAD handout already used during the week.

## Facilitation flow

### Step 1: In-brief and team formation (15 min)

- **Say:** Open with the issued mission (interdict IOT deny/degrade collection) and commander’s intent (purpose, key tasks, end state). Explain the two-phase model.
- **Show:** Student brief, local threat intelligence sheet, and local network map.
- **Do:** Form teams. Answer scope questions (fixed facts vs assumptions, CAD depth, multiple options, RFIs).
- **Ask (Q):** What facts are fixed versus assumed?
- **Expected Response (A):** Fixed facts come from the L1.8 student brief, local threat intelligence sheet, and local network map. Assumptions and RFIs are acceptable when clearly labeled.

Open with the issued mission and commander’s intent. Explain the two-phase model. Emphasize that students are being assessed on disciplined planning and commander-ready communication.

Expected student questions:

- What facts are fixed versus assumed?
- How detailed should the CAD graph be?
- Are teams allowed to identify multiple candidate options?
- How should RFIs be handled?

Instructor response: fixed facts come from the L1.8 student brief, local threat intelligence sheet, and local network map. Assumptions and RFIs are acceptable when clearly labeled. CAD should support the plan rather than become a standalone art project.

### Step 2: Phase 1 work — METT-TC to CV (180 min)

- **Say:** "Build the Phase 1 packet from mission analysis through CG/CV. Do not jump to D3FEND or ENGAGE yet."
- **Show:** Worksheets listed in the pre-class checklist. Expected packet standards are in the answer key.
- **Do:** Protect the three-hour work window. Circulate; correct unsupported leaps before briefs.
- **Ask (Q):** What must a strong Phase 1 packet include before you brief?
- **Expected Response (A):** Mission analysis, SALUTE/DRAW-D, friendly and enemy OCOKA-W, EMLCOA, and a specific CG/CV pair.

### Step 3: Phase 1 briefs and feedback (50 min)

- **Say:** "Eight minutes plus two minutes of Q&A. Brief enemy mission, key terrain, EMLCOA, CG/CV, and top RFIs."
- **Show:** The five-item brief list.
- **Do:** Ask one evidence question per team. Correct unsupported leaps before Phase 2.
- **Ask (Q):** Which piece of evidence most strongly supports your EMLCOA?
- **Expected Response (A):** A named fact from the threat sheet or network map, not a generic APT claim.

Each team briefs for 8 minutes with 2 minutes of Q&A. Require teams to brief:

1. Enemy mission and current activity.
2. Key terrain.
3. EMLCOA.
4. CG/CV.
5. Top assumptions and RFIs.

Useful instructor questions:

- Which piece of evidence most strongly supports your EMLCOA?
- What would the enemy likely do if the first recommended action became visible?
- What makes your CV actionable rather than just descriptive?
- Which RFI would most change your Phase 2 plan?

During feedback, correct unsupported leaps before teams proceed to options development.

### Step 4: Phase 2 work — exploitation plan to tasks (165 min)

- **Say:** "Map behavior to ATT&CK before selecting D3FEND or ENGAGE. CAD must support the plan, not become a standalone art project."
- **Show:** Answer-key expected Phase 2 products. Rubric rows for framework integration.
- **Do:** Protect the 2.5–3 hour window including CAD.
- **Ask (Q):** What must each option statement include?
- **Expected Response (A):** Goal, expected effect on the CV, risk, authority, and evidence requirement.

### Step 5: Phase 2 briefs and hot wash (60 min)

- **Say:** "Brief the exploitation plan, pairings, CAD, SOM, FSP, tasks, and remaining risk."
- **Show:** The seven-item brief list.
- **Do:** Collect packets and contribution notes. If time permits, project one strong CAD graph and one strong task-purpose statement.
- **Ask (Q):** Which option best preserves friendly freedom of maneuver?
- **Expected Response (A):** The option that shapes or observes the CV without unnecessarily revealing defender awareness or disrupting required government services.

Each team briefs for 8 minutes with 2 minutes of Q&A. Require teams to brief:

1. Exploitation plan and major ATT&CK mappings.
2. D3FEND/ENGAGE pairings and why they target the CV.
3. CAD graph and what it proves.
4. SOM phases.
5. FSP requirements and deconfliction.
6. Role-based tasks and measures.
7. Confidence and remaining risk.

Useful instructor questions:

- Which option best preserves friendly freedom of maneuver?
- Which option is most likely to spook the adversary, and how did you control that risk?
- What authority is required before the team acts?
- What evidence would prove the plan is working?
- Which task would you execute first if the commander approved the plan?

Close by collecting packets and contribution notes. If time permits, project one strong CAD graph and one strong task-purpose statement for the class debrief.

## Timing

- In-brief and team formation: 15 min
- Phase 1 work: approximately 3 hours
- Phase 1 briefs and feedback: 50 min
- Phase 2 work: approximately 2.5–3 hours
- Phase 2 briefs and hot wash: 60 min

Protect briefing time. Set visible time boxes for both work phases and both brief windows.

## Common stalls

- Jumping straight to a tool or block action before completing EMLCOA and CG/CV.
- Treating ATT&CK as a checklist rather than a behavior mapping tool.
- Naming D3FEND or ENGAGE options without explaining the intended effect.
- Drawing a CAD graph that does not support the plan.
- Ignoring persona-layer terrain and stakeholder impact.
- Recommending disruptive action without authority, risk, or adversary reaction analysis.
- Producing a strong group packet while one or more students make no visible contribution.
- Briefing technical detail without commander-level decision logic.

### Teams Stall During Phase 1

Prompt them back to the operational baseline:

```text
What do you know?
What do you assess?
What assumption are you making?
What RFI would reduce the largest risk?
```

### Teams Cannot Choose a CG/CV

Ask whether the CV can shape Phase 2 actions:

```text
If this is the enemy's vulnerability, what can the friendly force observe, shape, deny, degrade, exploit, or hand off?
```

### Teams Jump to D3FEND or ENGAGE Too Early

Require the behavior trace:

```text
What observed behavior maps to ATT&CK, and why does that behavior make this D3FEND or ENGAGE option relevant?
```

### Teams Produce Weak CAD Graphs

Have them explain one edge at a time:

```text
What evidence proves this agent performed this action?
What artifact or condition makes the countermeasure relevant?
What would change if this edge were removed?
```

### Individual Contribution Is Unclear

Use Q&A and the contribution note to confirm each student's role:

```text
Which part of the packet did you own, what evidence did you rely on, and what changed after team feedback?
```

## Lesson summary

This assessment validates the Week 1 outcome: students can convert scenario evidence and doctrine into a disciplined tactical plan. It requires them to move from METT-TC through enemy analysis, terrain analysis, EMLCOA, CG/CV, exploitation planning, framework mapping, CAD, SOM, FSP, and tasks while producing a commander-ready handoff product.

## Questions and check on learning

- **Ask (Q):** What would the enemy likely do if the first recommended action became visible?
- **Expected Response (A):** Shift infrastructure, reattempt access, accelerate collection, or reinforce through alternate paths — drawn from DRAW-D / EMLCOA, not from a generic "they leave."
- **Ask (Q):** What authority is required before the team acts?
- **Expected Response (A):** The authority named in the option statement; teams must not imply live disruptive action during the assessment.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Rubric: [`rubric.md`](./rubric.md)
- Answer key: [`answer-key.md`](./answer-key.md)
