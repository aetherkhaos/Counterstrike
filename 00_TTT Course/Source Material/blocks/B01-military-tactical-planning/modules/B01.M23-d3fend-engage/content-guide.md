---
id: B01.M23
title: MITRE D3FEND and ENGAGE
artifact_type: content_guide
audience: instructor
block: B01
module_type: lecture
legacy_aliases:
- legacy/week1/content-guides/5. MITRE ENGAGE Content Guide.md
- legacy/week1/content-guides/3. ATT&CK to D3FEND and ENGAGE Content Guide.md
- ingest/incoming/Instructor_Lesson_1.7_MITRE_D3FEND_ENGAGE.pptx
- B01.M17
source_kind: markdown
render_mode: generate
source_status: canonical
review_required: false
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
provenance:
- path: ingest/archive/f1c049ad274f_Instructor_Lesson_1.7_MITRE_D3FEND_ENGAGE.pptx
  sha256: f1c049ad274fbadd3e8e7910e5b750c6d9dc80818e22d92ec0d67951719e97e7
- path: ingest/archive/2aaa394bfcdc_Student_Lesson_1.7_MITRE_D3FEND_ENGAGE.pptx
  sha256: 2aaa394bfcdc083d6166a3caacdd95a6b8268bfc1016bcec0a9a796bfdba0dd0
---

# MITRE D3FEND and ENGAGE — Content Guide

**Source:** prior lecture notes
**Audience:** CPT operators with an evidence-backed ATT&CK Navigator layer.
**Duration:** ~2.5 hours (framework instruction, mapping exercises, commander-options work, and demonstration).
**References:**

- prior lecture notes
- https://d3fend.mitre.org/
- https://engage.mitre.org/matrix/
- https://engage.mitre.org/wp-content/uploads/2022/04/EngageHandbook-v1.0.pdf
- https://attack.mitre.org/mitigations/enterprise/ (cited by EAC0018 Security Controls)

## Instructor resources and pre-class

- Classroom projector and screen; workstations that can open D3FEND and ENGAGE
- Whiteboard for honeypot/canary capture, 2X/39 deconfliction questions, and RFIs
- Live tabs: https://d3fend.mitre.org/, https://engage.mitre.org/matrix/, Engage Handbook PDF, https://attack.mitre.org/mitigations/enterprise/
- Nested briefs for `B01.M24` (D3FEND mapping), `B01.M25` (ENGAGE technique drills), `B01.M26` (paired commander options), and `B01.M27` (2X/39 integration)
- Navigator layers and EMLCOA products students already produced
- Optional runspace walkthrough callback on Slide 14 only; do not re-run a full demo unless the class needs a refresher

## Student resources

- Student workstations with D3FEND, ENGAGE matrix, and exported Navigator layers
- Nested student briefs for `B01.M24`–`B01.M27`
- Engage Handbook PDF as the ENGAGE reference
- Analytical-justification table and EMLCOA (keep open)
- No additional student kit beyond the Navigator layer and the nested briefs

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "ATT&CK describes the adversary. D3FEND organizes defensive countermeasures. ENGAGE organizes ways to expose, affect, or elicit adversary behavior. We use all three to build options, not to decorate a brief."
- **Do:** Draw the three-framework triangle on the board: ATT&CK at the apex, D3FEND and ENGAGE at the base, "Commander's Option Space" in the center. Tell teams to reopen the Navigator layer and EMLCOA they already have.
- **Ask (Q):** What Navigator and EMLCOA products do you already have that this lesson will convert?
- **Expected Response (A):** Steer toward the evidence-backed Navigator layer and EMLCOA. This lesson converts that into D3FEND and ENGAGE options.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "ATT&CK describes the adversary. D3FEND organizes defensive countermeasures. ENGAGE organizes ways to expose, affect, or elicit adversary behavior. We use all three to build options, not to decorate a brief."
- **Show:** The objectives and framework triangle.
- **Do:** Have teams reopen the Navigator layer and EMLCOA they already have.
- **Ask (Q):** What Navigator and EMLCOA products do you already have that this lesson will convert?
- **Expected Response (A):** Steer toward the evidence-backed Navigator layer and EMLCOA. This lesson converts that into D3FEND and ENGAGE options.

---

### Slide 1: MITRE D3FEND and ENGAGE (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk MITRE D3FEND and ENGAGE in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 2: Lesson Objectives (7 min)

By the end of this lesson you will be able to:

Understand and apply the MITRE frameworks to produce and provide options to a commander.
- Recall the purpose for which the MITRE D3FEND and ENGAGE models were created
- Map adversary ATT&CK to D3FEND and Engage options using the respective matrices
- Define and build paired sets of of options with amplifying information for any ATT&CK-mapped intrusion

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "ATT&CK describes the adversary. D3FEND organizes defensive countermeasures. ENGAGE organizes ways to expose, affect, or elicit adversary behavior. We use all three to build options, not to decorate a brief."
- **Show:** The objectives and framework triangle. The lesson-overview figure from the student deck, the figure on the slide, is the same six-step chain (eyes on, map ATT&CK, build EMLCOA, map D3FEND/ENGAGE, blue-space options, out of blue-space). Keep it with this opening slide.
- **Do:** Have teams reopen the Navigator layer and EMLCOA they already have.
- **Ask (Q):** What Navigator and EMLCOA products do you already have that this lesson will convert?
- **Expected Response (A):** Evidence-backed Navigator layer and EMLCOA. This lesson converts that into D3FEND and ENGAGE options.

### Slide 3: Lesson Overview (4 min)

- In this lesson you will be presented with the knowledge highlighted below to develop your analytical skills via the following sections:

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s03-0-0c2bc274f756.png`@0.124,0.155,0.826,0.764
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Lesson Overview in the order it is written.
- **Show:** The figure on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 4: Avoid the "What If" Game (4 min)

**Avoid the "What If" Game**
- Once an adversary has root/system, they can theoretically do anything
- Do **not** default to the most destructive EMLCOA
- Consider the adversary's authority and intent — T10 vs. T50 equivalents
- Intelligence-collection units rarely destroy; destructive units rarely dwell

Revisit

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** Walk Avoid the "What If" Game in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 5: Step 4: Mapping ATT&CK to D3FEND and ENGAGE (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Step 4: Mapping ATT&CK to D3FEND and ENGAGE in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 6: Mapping ATT&CK to D3FEND and ENGAGE (15 min)

- D3FEND sits on the same ontology as ATT&CK — there is a formal mapping
- For every technique on your Navigator layer, identify matching D3FEND defensive techniques
- ENGAGE covers deception and adversary engagement options

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s06-0-16cef25bf302.png`@0.222,0.385,0.566,0.550
- **Image Prompt:** No image required for this slide.
- **Say:** "The mapping narrows the defensive option space, but it does not make the decision. Terrain, evidence, mission, and risk determine which countermeasure is viable."
- **Show:** The figure on the slide.
- **Do:** Teams map three Navigator techniques to D3FEND options. Timebox: **15 minutes**. Nested drill: B01.M24.
- **Ask (Q):** Why is a D3FEND mapping not yet a commander's decision?
- **Expected Response (A):** Mapping narrows the option space. Terrain, evidence, mission, and risk determine which countermeasure is viable.

### Slide 7: MITRE D3FEND (4 min)

D3FEND: describes remedial / defensive techniques against adversary TTPs
- A framework with an encoded countermeasure knowledge base and graph. The graph contains semantically rigorous types and relations that define both the key concepts in the cybersecurity countermeasure domain and the relations necessary to link those concepts to each other.

**D3FEND**

Remedial & Defensive Actions

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s07-0-964ccea7b6ab.png`@0.233,0.400,0.660,0.452
- **Image Prompt:** No image required for this slide.
- **Say:** "The mapping narrows the defensive option space, but it does not make the decision. Terrain, evidence, mission, and risk determine which countermeasure is viable."
- **Show:** The figure on the slide.
- **Do:** Teams map three Navigator techniques to D3FEND options. Timebox: **15 minutes**. Nested drill: B01.M24.
- **Ask (Q):** Why is a D3FEND mapping not yet a commander's decision?
- **Expected Response (A):** Mapping narrows the option space. Terrain, evidence, mission, and risk determine which countermeasure is viable.

### Slide 8: The D3FEND Matrix (4 min)

- https://d3fend.mitre.org/

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s08-0-d400203e08c4.png`@0.190,0.324,0.620,0.562
- **Image Prompt:** No image required for this slide.
- **Say:** "The mapping narrows the defensive option space, but it does not make the decision. Terrain, evidence, mission, and risk determine which countermeasure is viable."
- **Show:** The figure on the slide.
- **Do:** Teams map three Navigator techniques to D3FEND options. Timebox: **15 minutes**. Nested drill: B01.M24.
- **Ask (Q):** Why is a D3FEND mapping not yet a commander's decision?
- **Expected Response (A):** Mapping narrows the option space. Terrain, evidence, mission, and risk determine which countermeasure is viable.

### Slide 9: Let’s start: Mapping ATT&CK to D3FEND (4 min)

- **Practical Application: **Map an ATT&CK to D3FEND
- **Objective: **Map an adversaries attack using the defend matrix
- **Instructions:**

Take each of your techniques from the earlier ATT&CK Navigator and map it to a D3FEND counterpart.

https://d3fend.mitre.org/

**Column titles:**

|  | Attack | Defend |
| --- | --- | --- |
| Log 1 (Email Gateway): An email is delivered with a .lnk attachment. | T1091: Replication Through Removable Media |  |
| Log 2 (Sysmon Event 1): mshta.exe is observed executing a URL hosted on a .ru domain. | T1071.001: Web Protocols (HTTP) |  |
| Log 3 (Sysmon Event 1): powershell.exe is observed running a command containing Invoke-Expression and a Base64 encoded string. | T1059.001: PowerShell |  |
| Log 4 (EDR Log): PteroLNK.vbs is observed querying WMI for win32_logicaldisk where mediatype=null. | T1120: Peripheral Device Discovery |  |
| Log 5 (File Auditing): PteroPSDoor.ps1 is observed reading files with extensions .docx, .xlsx, and .pdf from a user's Desktop and writing them to a staging directory in %LOCALAPPDATA%\vector. | T1005: Data from Local System |  |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "The mapping narrows the defensive option space, but it does not make the decision. Terrain, evidence, mission, and risk determine which countermeasure is viable."
- **Show:** The figure on the slide.
- **Do:** Teams map three Navigator techniques to D3FEND options. Timebox: **15 minutes**. Nested drill: B01.M24.
- **Ask (Q):** Why is a D3FEND mapping not yet a commander's decision?
- **Expected Response (A):** Mapping narrows the option space. Terrain, evidence, mission, and risk determine which countermeasure is viable.

### Slide 10: MITRE ENGAGE (1 min)

**ENGAGE**

Active Deception & Shaping

ENGAGE: describes **actively interacting** with the adversary in blue-space
- Is a framework for planning and discussing adversary engagement operations that empowers you to engage your adversaries and achieve your cybersecurity goals
- Three goals
  - Expose
  - Affect
  - Elicit

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s10-0-76dea227a811.png`@0.771,0.807,0.219,0.126; `slides/source-figures/M23-s10-1-50a1c51f17a1.png`@0.842,0.840,0.014,0.025
- **Image Prompt:** No image required for this slide.
- **Say:** "You already have ATT&CK and D3FEND in your head. ENGAGE is the third leg. ATT&CK describes what the adversary does. D3FEND is what we do to prevent, detect, or evict them. ENGAGE is what we do to **shape** them — deceive, elicit, direct. Together, the D3 codes and the EAC codes are the bare-minimum menu you bring to the commander. Bare minimum — because the goal is not to recite techniques. The goal is to pick the ones that actually work in this environment against this adversary toward this mission."
- **Show:** The triangle graphic; https://engage.mitre.org/matrix/ on the projector.
- **Do:** Quick poll: "Who has run a honeypot in anger?" "Who has fed fake credentials?" Calibrate depth based on responses. Tell them: "That intuition you already have — ENGAGE is the doctrine that organizes it."
- **Ask (Q):** Who has run a honeypot in anger? Who has fed fake credentials?
- **Expected Response (A):** Facilitation-only poll. Use responses to calibrate depth. That intuition is what ENGAGE organizes.

### Slide 11: The Three ENGAGE Goals (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s11.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "ENGAGE organizes around three goals. Expose finds adversaries we did not see. Affect bends their cost-value math. Elicit pulls out TTPs and intent we could not have gotten any other way. Every time you pick an EAC technique, you owe an answer to this question: which goal does this advance?"
- **Show:** Each tile; link each goal back to how it would plug into a commander's brief.
- **Do:** Ask each team: "From your Block 2 EMLCOA against FSB Center 18 — would Expose, Affect, or Elicit matter **most** for that mission?" Accept three or four answers with one-line justification.
- **Ask (Q):** From your Block 2 EMLCOA against FSB Center 18, would Expose, Affect, or Elicit matter most?
- **Expected Response (A):** Accept three or four answers with one-line justification. Every EAC must trace to one of the three goals.

### Slide 12: Expose (3 min)

**Two Operational Approaches**
- **Collect**: gather logs, traffic, artifacts that expose adversary activity at the intersection of denial, deception, and adversary-engagement tech
- **Detect**: produce **high-fidelity** alerts (tripwires, lures, custom decoders, alerts from malware detonation)

**Example: Unique Leaked Credentials**

Planting unique, fake credentials inside or outside the network guarantees that any authentication attempt generates an immediate, 100% confidence signal revealing exactly where and when credentials were stolen.

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s12-0-74f10fa26889.png`@0.107,0.736,0.841,0.154; `slides/source-figures/M23-s12-1-2bc20b94ad28.png`@0.125,0.795,0.020,0.036
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Expose in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 13: Affect (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s13.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "Affect is the category that moves the adversary's cost-value math. Prevention stops them. Direction steers them — the subtlety here is that you can tighten *some* controls while loosening others, which nudges them toward the terrain you want them in. Disruption degrades the value of what they are getting — throttled exfil, lied-to discovery output, planted misinformation that their analysts have to sort out."
- **Show:** The three approaches; call out that Direction is the most *active* of the three.
- **Do:** Example drill: "Adversary is exfiltrating 10 GB of data over a primary C2 channel. Give me one Prevention, one Direction, and one Disruption option for the commander." Accept answers; refine as needed.
- **Ask (Q):** Adversary is exfiltrating 10 GB over a primary C2 channel. Give one Prevention, one Direction, and one Disruption option.
- **Expected Response (A):** Facilitation. Refine toward cost-value: stop the channel, steer the adversary, or degrade the value of what they collect.

### Slide 14: Elicit (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s14.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "Elicit is the deepest form of engagement. Reassurance makes the environment *feel real* — accounts with histories, files with sensible timestamps, system activity that matches a working user. Motivating makes the environment *worth attacking* — unpatched services, weak passwords, juicy-looking data. The goal is the same: get them to reveal more about themselves than they would have otherwise."
- **Show:** The two-panel comparison.
- **Do:** Tie back: "Elicit is how you design an environment so the adversary reveals more than they would on live production terrain."
- **Ask (Q):** How do reassurance and motivating change what you observe?
- **Expected Response (A):** Steer toward dangles and self-infected environments designed to observe.

### Slide 15: ENGAGE Techniques (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s15.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "These are the techniques we will actually work with. The codes are opaque at first — EAC0005, EAC0023 — just like ATT&CK T-numbers were the first time you saw them. They become second nature. We are going to group them by primary goal and walk each one."
- **Show:** The figure on the slide.
- **Do:** Tell students to bookmark the matrix. You will reference it throughout this hour.
- **Ask (Q):** Why bookmark the ENGAGE matrix now?
- **Expected Response (A):** EAC codes in this hour become second nature like T-numbers.

### Slide 16: Deception-Heavy Techniques (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s16.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "These four are your deception palette. Lures *elicit a specific action*. Pocket Litter *supports the narrative* — it does not aim to make them do one specific thing. Information Manipulation is the art of concealing and revealing; a revealed fiction that the adversary believes cements the environment, and one they disbelieve erodes it. Introduced Vulnerabilities are the intentional magnets."
- **Show:** the figure on the slide, the labeled mock desktop.
- **Do:** Quick team drill: "Take the EMLCOA you already wrote. Which of these four would have the highest payoff against FSB Center 18?" Capture one answer per team. Nested drill: B01.M25.
- **Ask (Q):** Take the EMLCOA you already wrote. Which of these four would have the highest payoff against FSB Center 18?
- **Expected Response (A):** Facilitation. One answer per team. Lures elicit a specific action; Pocket Litter supports the narrative.

### Slide 17: Environment-Shaping Techniques (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s17.pptx
- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** "These five are how you reshape the terrain the adversary is operating in. Isolation keeps them boxed in. Attack Vector Migration physically moves their payload into your sandbox. Network Manipulation and Software Manipulation change what they see when they look. Security Controls is where you tighten what should be tight and — selectively — loosen what you want them to walk into. Two-way nuance on Security Controls: completely turning off Windows Defender tips them off; turning it off for a single share may not."
- **Show:** Each technique; linger on the Security Controls nuance.
- **Do:** Ask the room: "If you leave Windows Defender off on an entire host, what does a serious adversary think?" Drive toward "this is a trap" as the likely adversary read.
- **Ask (Q):** If you leave Windows Defender off on an entire host, what does a serious adversary think?
- **Expected Response (A):** Steer toward "this is a trap." Completely turning off Defender tips them off.

### Slide 18: Hardware & Peripheral Techniques (7 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s18.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "Hardware and peripheral techniques get skipped often in pure cloud environments but matter a lot when you are on-prem or when you are running a controlled engagement in a physical space. Hardware Manipulation preserves operational safety — no hot mic, no camera capturing the background. Peripheral Management is how you introduce or deny USBs, Wi-Fi adapters, and other devices as engagement surface."
- **Show:** The figure on the slide.
- **Do:** Prompt: "Your team is running a controlled malware-detonation in a shared SCIF. Which of these two is non-negotiable?" Expected answer: Hardware Manipulation.
- **Ask (Q):** Your team is running a controlled malware-detonation in a shared SCIF. Which of these two is non-negotiable?
- **Expected Response (A):** Hardware Manipulation. No hot mic, no camera capturing the background.

### Slide 19: The ENGAGE Matrix (4 min)

- https://engage.mitre.org/matrix/?

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s19-0-32a220cfdcef.png`@0.101,0.306,0.895,0.452
- **Image Prompt:** No image required for this slide.
- **Say:** Walk ENGAGE Matrix in the order it is written.
- **Show:** The figure on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 20: Step 5: Providing Blue-Space Options to the Commander (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Step 5: Providing Blue-Space Options to the Commander in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 21: Providing Blue-Space Options to the Commander (30 min)

- Your commander wants options, not just analysis
- Each option states:
  - The D3FEND Action and ENGAGE Action (**paired set**)
  - The expected effect on the adversary's CoG / CV
  - The risk (operational, legal, civil)
  - The authority required
- If every option says "install more logging," you did not think hard enough

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "The deliverable out of this hour is a paired set — a D3 option and an EAC option — for each technique you already mapped. Think of it as the minimum viable option sheet. The commander may pick neither, but they will always be able to see *both* the harden-side and the engage-side move."
- **Show:** The worksheet template; hand out as a printable. The small mark on that worksheet slide is the figure on the slide.
- **Do:** Reunite teams. Timebox: **30 minutes** to produce the paired option sheet for at least three of their Navigator techniques. Back-brief **one pairing per team**. Nested drill: B01.M26.
- **Ask (Q):** What is the bare-minimum option set you bring to the commander for each Navigator technique?
- **Expected Response (A):** One D3 option and one EAC option, each with goal, expected effect, risk, and authority. Nested drill: B01.M26.

### Slide 22: Mapping ENGAGE into an Option Set (4 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s22.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "The deliverable out of this hour is a paired set — a D3 option and an EAC option — for each technique you already mapped. Think of it as the minimum viable option sheet. The commander may pick neither, but they will always be able to see *both* the harden-side and the engage-side move."
- **Show:** The worksheet template; hand out as a printable. The small mark on that worksheet slide is the figure on the slide.
- **Do:** Reunite teams. Timebox: **30 minutes** to produce the paired option sheet for at least three of their Navigator techniques. Back-brief **one pairing per team**. Nested drill: B01.M26.
- **Ask (Q):** What is the bare-minimum option set you bring to the commander for each Navigator technique?
- **Expected Response (A):** One D3 option and one EAC option, each with goal, expected effect, risk, and authority. Nested drill: B01.M26.

### Slide 23: Let’s start: Mapping ENGAGE into an Option Set (10 min)

- **Practical Application:** Add ENGAGE options into our DEFEND options and conduct additional analysis
- **Objective: **Use an adversaries ATT&CK and provide a paired set (a D3 option and an EAC option)
- **Instructions:**

Take each of your techniques from the D3FEND Exercise and add an Engage option. For each option pair also state: Goal (Expose/Affect/Elicit), expected effect on CoG/CV, Risk

**Column titles:**

|  | Attack | Defend | Engage |  |
| --- | --- | --- | --- | --- |
| Log 1 (Email Gateway) | T1091 | D3-HCI D3-IOPR D3-PFV |  | Goal: Expected Effect: Risk: |
| Log 2 (Sysmon Event 1) | T1071.001 |  |  | Goal: Expected Effect: Risk: |
| Log 3 (Sysmon Event 1): | T1059.001 | D3-PSA D3-SEA |  | Goal: Expected Effect: Risk: |
| Log 4 (EDR Log): | T1120 |  |  | Goal: Expected Effect: Risk: |
| Log 5 (File Auditing): | T1005 | D3-FPA |  | Goal: Expected Effect: Risk: |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "The deliverable out of this hour is a paired set — a D3 option and an EAC option — for each technique you already mapped. Think of it as the minimum viable option sheet. The commander may pick neither, but they will always be able to see *both* the harden-side and the engage-side move."
- **Show:** The worksheet template; hand out as a printable. The small mark on that worksheet slide is the figure on the slide.
- **Do:** Reunite teams. Timebox: **30 minutes** to produce the paired option sheet for at least three of their Navigator techniques. Back-brief **one pairing per team**. Nested drill: B01.M26.
- **Ask (Q):** What is the bare-minimum option set you bring to the commander for each Navigator technique?
- **Expected Response (A):** One D3 option and one EAC option, each with goal, expected effect, risk, and authority. Nested drill: B01.M26.

### Slide 24: The 2X / 39 Conversation (15 min)

**Instructor Notes:**

- **Manual slide:** slides/manual/B01.M23-s24.pptx
- **Image Prompt:** No image required for this slide.
- **Say:** "An ENGAGE action can begin as defense and become a collection opportunity. Define the intelligence requirement, staff relationship, and ownership-transition trigger before execution."
- **Show:** The three integration headings and ownership questions.
- **Do:** Open discussion, timebox **15 minutes**. Capture the deconfliction questions students raise on the whiteboard — these become RFIs for the home-unit intel shop. Nested drill: B01.M27.
- **Ask (Q):** For an ENGAGE option that begins as defense, what three integration questions must you answer before execution?
- **Expected Response (A):** Who owns the data; who exploits and reports it; what trigger changes ownership. Nested drill: B01.M27.

### Slide 25: Step 6: Moving Out of Blue-Space (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Step 6: Moving Out of Blue-Space in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 26: Moving Out of Blue-Space (7 min)

- If the commander picks an option that blue-space cannot execute — now what?
- This is the DCO-RA hand-off point
- Course roadmap: Week 2-3 build the tradecraft you need to actually execute out-of-blue-space options
- You will revisit this block after Week 2 tradecraft and again after Week 3

**Instructor Notes:**

- **Figures:** `slides/source-figures/M23-s26-0-8cc41059e1a2.png`@0.298,0.570,0.497,0.377
- **Image Prompt:** No image required for this slide.
- **Say:** "When blue-space options cannot achieve the required effect, the output of this lesson becomes a disciplined handoff—not an unsupported leap."
- **Show:** The figure on the slide.
- **Do:** Ask each team which one of its options cannot execute from blue space.
- **Ask (Q):** Which one of your options cannot execute from blue space, and what capability does it require?
- **Expected Response (A):** Facilitation. State handoff condition, evidence package, risk, and required capability.

### Slide 27: Lesson Summary (4 min)

You should now be able to:

Understand and apply the MITRE frameworks to produce and provide options to a commander.
- Recall the purpose for which the MITRE D3FEND and ENGAGE models were created
- Map adversary ATT&CK to D3FEND and Engage options using the respective matrices
- Define and build paired sets of of options with amplifying information for any ATT&CK-mapped intrusion

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** Walk Lesson Summary in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

## Lesson summary

- ATT&CK describes the adversary; D3FEND organizes harden/detect/evict options; ENGAGE organizes expose/affect/elicit options.
- Mapping to D3FEND or ENGAGE narrows the option space; terrain, evidence, mission, and risk decide what is viable.
- Nested `B01.M24` maps ATT&CK to D3FEND; `B01.M25` drills ENGAGE techniques; `B01.M26` produces paired D3+EAC options; `B01.M27` deconflicts 2X/39 ownership.
- Graph the same activity, evidence, and selected response in D3FEND CAD.

## Questions and check on learning

- **Ask (Q):** What does each of ATT&CK, D3FEND, and ENGAGE contribute to a commander's option set?
- **Expected Response (A):** ATT&CK describes the adversary. D3FEND organizes harden/detect/evict. ENGAGE organizes expose/affect/elicit.
- **Ask (Q):** What is the bare-minimum pairing you bring for each Navigator technique?
- **Expected Response (A):** One D3 option and one EAC option, each with goal, expected effect, risk, and authority.
- **Ask (Q):** What three questions must you answer before an ENGAGE action that may become collection?
- **Expected Response (A):** Who owns the data; who exploits and reports it; what trigger changes ownership.
