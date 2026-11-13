---
id: B01.M20-ig
title: Navigator Demonstration — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B01
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

# Navigator Demonstration — Instructor Guide

## Objective and context

Extracted in-lecture drill from [`B01.M19`](../../content-guide.md) Slide 8. Students open ATT&CK Navigator, watch a live FSB Center 18 layer, then build a layer for the APT their team was assigned. Slide notes stay in the parent content guide; this file is the facilitation SoT for the generated lesson plan.

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "The Navigator is how we visualize an intrusion. I am going to build a layer live — you should have this tool open on your own workstation too."
- **Do:** Write on the board: one layer per intrusion; overlay later to see overlaps; export for briefs and hand-off.
- **Ask (Q):** What product will you have at the end of these 20 minutes?
- **Expected Response (A):** A Navigator layer for the assigned APT. Not a finished intrusion-mapping table — that is B01.M21.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "The Navigator is how we visualize an intrusion. I am going to build a layer live — you should have this tool open on your own workstation too."
- **Show:** Parent Slide 8. Live-open https://mitre-attack.github.io/attack-navigator/.
- **Do:** Confirm every station can create a new layer before you color techniques.
- **Ask (Q):** What product will you have at the end of these 20 minutes?
- **Expected Response (A):** A Navigator layer for the assigned APT. Not a finished intrusion-mapping table — that is B01.M21.

## Instructor resources and pre-class preparation

- Projector and student workstations that can open ATT&CK Navigator
- Parent lecture [`B01.M19` content guide](../../content-guide.md) at Slide 8
- Live tab: https://mitre-attack.github.io/attack-navigator/
- FSB Center 18 techniques from the B01.M09 / B01.M17 worked example (color 6–8 live)
- Assigned APT list from the B01.M13 SALUTE teams

## Student resources and environment

- Student brief: [`student-brief.md`](./student-brief.md)
- ATT&CK Navigator in the browser
- Assigned APT from the earlier SALUTE teams
- No additional student kit

## Facilitation flow

### Step 1: Open Navigator and a new layer (4 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "ATT&CK Navigator is the canonical tool for visualizing observed TTPs. Build a layer per intrusion; overlay layers to see overlaps across actors. Export layers for briefs and for hand-off to intel or defenders."
- **Show:** https://mitre-attack.github.io/attack-navigator/. Create a new layer so students see the empty matrix.
- **Do:** Have every student open Navigator and create a new layer. Troubleshoot stations that cannot load the site before you start coloring.
- **Ask (Q):** Why a layer per intrusion instead of one shared class layer?
- **Expected Response (A):** Overlay later to see overlaps across actors. Each team's APT stays its own layer.

### Step 2: Instructor live layer — FSB Center 18 (6 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "I am coloring 6–8 techniques that map to the FSB Center 18 example from the planning block. Watch how a layer becomes a pattern, not a random heatmap."
- **Show:** Color techniques on the projected layer. Keep the mapping tied to the worked-example behavior, not a guess list.
- **Do:** Build the live layer. Do not complete the Slide 9 evidence table here — that is B01.M21.
- **Ask (Q):** What does a colored cell mean in this demo?
- **Expected Response (A):** Observed or instructor-justified TTP for this intrusion, not "they might do this." Avoid the what-if game from the parent lecture.

### Step 3: Student layers — assigned APT (10 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "Create your own Navigator layer for the APT your team was assigned. You have the remainder of this drill. We will use these layers in the mapping lab next."
- **Show:** Students work; projector stays on Navigator for anyone who needs the UI path again.
- **Do:** Timebox the remainder of the 20-minute parent-slide drill. Collect or have students save the layer for B01.M21. Then return to the parent lecture.
- **Ask (Q):** Can you export or keep this layer so the mapping lab can use it?
- **Expected Response (A):** Yes — export for briefs and hand-off. The next drill (B01.M21) adds analytical justification per technique.

## Lesson summary

- Navigator visualizes observed TTPs as one layer per intrusion.
- The instructor live-build used FSB Center 18; students built a layer for their assigned APT.
- Next in the parent sequence: B01.M21 maps an intrusion with justification; B01.M22 states mission and EMLCOA from the layer.

## Questions and check on learning

- **Ask (Q):** What is ATT&CK Navigator for in this course?
- **Expected Response (A):** Visualize observed TTPs, overlay actors, export for briefs and hand-off. It does not replace evidence.
- **Ask (Q):** What product did this drill collect?
- **Expected Response (A):** A Navigator layer for the assigned APT, ready for the mapping lab.

## Related artifacts

- Parent lecture: [`../../content-guide.md`](../../content-guide.md)
- Student brief: [`student-brief.md`](./student-brief.md)
- Next drill: [`../B01.M21-intrusion-mapping/`](../B01.M21-intrusion-mapping/)
