---
id: B01.M31
title: Back to MITRE ATT&CK
artifact_type: content_guide
audience: instructor
block: B01
module_type: group_activity
legacy_aliases:
- legacy/week1/content-guides/6. Back to MITRE ATT&CK Content Guide.md
- B01.M26
source_status: canonical
review_required: false
provenance:
- path: ingest/archive/9a6ee7809f48_Putting_it_all_together_lab.pptx
  sha256: 9a6ee7809f48a07466b2193084b6abe2ef5155684e1f80f89d4d99b7cb328078
output_formats:
- pptx_instructor
- pptx_student
template_profile: content_guide_v1
sensitivity: course_internal
---

# Back to MITRE ATT&CK — Content Guide

**Source:** Student deck reconciled into this guide.
**Audience:** CPT operators who have practiced ATT&CK, D3FEND, and ENGAGE and are ready to wire them back to tactical tasks.
**Duration:** ~45 minutes (synthesis exercise and back-brief)
**References:**

- https://attack.mitre.org/resources/
- https://mitre-attack.github.io/attack-navigator/
- https://d3fend.mitre.org/
- Tactical-task handout
- Team Navigator layers, D3FEND maps, and paired option sheets

---

### Slide 1: Back to Tactical Tasks Lab Putting it all together (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** "You could not meaningfully map frameworks to tactical tasks until you had practiced all three frameworks. You have now."
- **Show:** the figure on the slide.
- **Do:** Map MITRE ATT&CK, D3FEND, and ENGAGE techniques to tactical tasks in this hour. Nested drill: B01.M32.

### Slide 2: Lesson Overview (4 min)

- In this lesson you will be presented with the knowledge highlighted below to develop your analytical skills via the following sections:

**Instructor Notes:**

- **Figures:** `slides/source-figures/M31-s02-0-53549a983fcb.png`@0.174,0.224,0.710,0.689
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Lesson Overview in the order it is written.
- **Show:** The figure on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 3: Mission (5 min)

Deny or degrade the FSB Center 18's ability to collect intelligence from network X in order to preserve friendly freedom of maneuver in cyberspace.

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Take your tactical-task verdicts and wire them into the frameworks you now know. You will not fill out every row—some tactical tasks still do not translate, and that is a valid verdict."
- **Show:** The four-column template with the sample row on the projector.
- **Do:** Timebox: **25 minutes** team work + **5 minutes per team** to back-brief one row of their table. Keep the tables — they become the reference sheet each team carries into later briefing. Nested drill: B01.M32.

### Slide 4: Tactical Task Mapping (4 min)

**Column titles:**

| Attack Technique | Tactical Task | D3FEND Option (D3) | Tactical Task | Engage Option (EAC) | Tactical Task | Required Analysis |
| --- | --- | --- | --- | --- | --- | --- |
| T1078 Valid Accounts |  | D3-SCA Script Analysis |  | EAC0005 Lures (Honey Creds) |  | Goal: Expose Expected Effect: High-fidelity alert Risk: Very Low |
| T1059 Command & Script Interpreter |  | D3-SCA Script Analysis |  | EAC0014 Software Manipulation |  | Goal: Affect Expected Effect: Degrade workflow Risk: Low |
| T1021 Remote Services |  | D3-NI Network Isolation |  | EAC0020 Isolation (Decoy Subnet) |  | Goal: Elicit Expected Effect: Capture TTPs Risk: Moderate (Spillover) |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Take your tactical-task verdicts and wire them into the frameworks you now know. You will not fill out every row—some tactical tasks still do not translate, and that is a valid verdict."
- **Show:** The four-column template with the sample row on the projector.
- **Do:** Timebox: **25 minutes** team work + **5 minutes per team** to back-brief one row of their table. Keep the tables — they become the reference sheet each team carries into later briefing. Nested drill: B01.M32.

### Slide 5: Tactical Tasks (4 min)

- Enemy-Oriented Tactical Tasks:
  - Each Enemy-Oriented tactical task that has an asterisk next to it is a tactical task with multiple classifications and applications.

| Ambush | Attack by Fire | Block | Breach* |
| --- | --- | --- | --- |
| Bypass | Canalize | Contain | Corrupt |
| Deceive | Defeat | Degrade | Deny |
| Destroy | Disrupt | Exploit | Feint |
| Fix | Influence* | Interdict | Isolate |
| Neutralize | Penetrate | Reconnoiter* | Support by Fire |
| Suppress |  |  |  |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** Walk Tactical Tasks in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 6: Tactical Tasks (4 min)

- Friendly-Oriented Tactical Tasks:

| Cover | Disengage | Displace |
| --- | --- | --- |
| Exfiltrate | Follow and Assume | Follow and Support |
| Guard | Protect | Screen |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** Walk Tactical Tasks in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 7: Tactical Tasks (4 min)

- Terrain-Oriented Tactical Tasks:
          - Each Terrain-Oriented tactical task that has an asterisk next to it is a tactical task with multiple classifications and applications.

| Breach* | Clear | Control |
| --- | --- | --- |
| Cordon | Occupy | Reconnoiter* |
| Retain | Secure | Seize |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** Walk Tactical Tasks in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 8: Tactical Tasks Mapping (4 min)

**Column titles:**

| Attack | Tactical Task | Defend | Tactical Task | Engage | Tactical Task |
| --- | --- | --- | --- | --- | --- |
| T1091 |  | D3-HCI D3-IOPR D3-PFV |  | EAC0005 EAC0007 |  |
| T1071.001 |  |  |  | EAC0016 |  |
| T1059.001 |  | D3-PSA D3-SEA |  |  |  |
| T1120 |  |  |  |  |  |
| T1005 |  | D3-FPA |  | ENG0006: |  |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "If we rushed any part of the mapping workflow, now is the time to go back. The three failure modes I see most often are confidence inflation, lazy parent-technique picks where sub-technique was warranted, and layers that assume telemetry the unit does not actually have. Fix those now. Also check the risk column. Not every option is extremely high."
- **Show:** The figure on the slide.
- **Do:** Optional live-fix. Accept the time cost — it is cheaper to fix here than during a later assessment window.

### Slide 9: Risk (5 min)

The combination of probability and consequence levels determines the initial risk assessment for a potential threat, which then allows for risk judgment

**Instructor Notes:**

- **Figures:** `slides/source-figures/M31-s09-0-c18f98b69dd0.png`@0.500,0.293,0.455,0.508
- **Image Prompt:** No image required for this slide.
- **Say:** "If we rushed any part of the mapping workflow, now is the time to go back. The three failure modes I see most often are confidence inflation, lazy parent-technique picks where sub-technique was warranted, and layers that assume telemetry the unit does not actually have. Fix those now. Also check the risk column. Not every option is extremely high."
- **Show:** The figure on the slide.
- **Do:** Optional live-fix. Accept the time cost — it is cheaper to fix here than during a later assessment window.

### Slide 10: Putting it all together (3 min)

- **Practical Application:** Translate tactical tasks into the Cyber Domain Part II
- **Objective: **Use an adversaries ATT&CK and our developed paired option sets and map them to an appropriate tactical task.
- **Instructions:**

Using the table we have been building (and all the information), the exercises from your tactical planning module and the tactical task listings fill in the table on the previous slide. Some tactical tasks may not translate. This is also the time to clean up everything that we have worked up to this point from Tactical planning, and the MITRE modules.

SALUTE, DRAW-D, OCOKAW, and Exploitation Plan are good?

Verify your ATT&CK parent to sub-techniques - did you select T1059.001 vice T1059

Is every risk at the appropriate level? Is everything extremely high?

Is your ATT&CK navigator layer clean, how about your D3FEND CAD?

Be prepared to present your products and justify your analysis

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** Walk Putting it all together in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 11: Lesson Summary (5 min)



- ATT&CK, D3FEND, and ENGAGE are now wired into tactical-task doctrine
- Each team leaves with a one-page mapping table and a cleaned Navigator layer
- Keep the synthesis artifact

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "You now have tactical tasks, METT-TC, EMLCOA, COG/CV, ATT&CK, D3FEND, ENGAGE, and CAD tied into one coherent toolkit."
- **Show:** The closed-loop diagram from Slide 1 one more time, with every node checked off.
- **Do:** Collect tables. Keep the synthesis artifact for later commander briefing.

