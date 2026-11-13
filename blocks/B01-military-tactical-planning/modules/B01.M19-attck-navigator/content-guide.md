---
id: B01.M19
title: MITRE ATT&CK and Navigator
artifact_type: content_guide
audience: instructor
block: B01
module_type: lecture
legacy_aliases:
- legacy/week1/content-guides/3. ATT&CK to D3FEND and ENGAGE Content Guide.md
- ingest/incoming/Instructor_Lesson_1.6_MITRE_ATTCK_and_Navigator.pptx
- B01.M13
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
- path: ingest/archive/3496647f3e9c_Instructor_Lesson_1.6_MITRE_ATTCK_and_Navigator.pptx
  sha256: 3496647f3e9c00dd26f3032a566f187589d9877ccc17059625489d517e1f679d
- path: ingest/archive/71947e721a20_Student_Lesson_1.6_MITRE_ATTCK_and_Navigator.pptx
  sha256: 71947e721a209692a2e40d4a8837b4ccb292c91324d35de5c52cad813dc80d8d
---

# MITRE ATT&CK and Navigator — Content Guide

**Source:** prior lecture notes
**Audience:** CPT operators mapping observed behavior to ATT&CK.
**Duration:** ~2 hours (lecture + Navigator demonstration + mapping practical).
**References:**

- prior lecture notes
- CISA Best Practices for MITRE ATT&CK Mapping
- https://attack.mitre.org/ and ATT&CK Navigator (https://mitre-attack.github.io/attack-navigator/)
- https://lolbas-project.github.io/ and https://gtfobins.org/

## Instructor resources and pre-class

- Classroom projector and screen; workstations that can open ATT&CK Navigator
- Whiteboard for DRAW-D withdraw reminder and SIEM-rule gaps
- Instructor copy of CISA Best Practices for MITRE ATT&CK Mapping
- Live tabs: https://attack.mitre.org/, https://mitre-attack.github.io/attack-navigator/, https://lolbas-project.github.io/, https://gtfobins.org/
- Nested briefs for `B01.M20` (Navigator demonstration), `B01.M21` (intrusion mapping), and `B01.M22` (mission/EMLCOA back-brief)
- Evidence-to-behavior tables students already produced

## Student resources

- Student workstations with ATT&CK Navigator
- Evidence-to-behavior table (keep open)
- Nested student briefs for `B01.M20`–`B01.M22`
- CISA ATT&CK mapping best-practices PDF as the mapping reference
- No additional student kit beyond Navigator and the intrusion evidence set on Slide 9

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "ATT&CK gives us a shared vocabulary for observed adversary behavior. Navigator lets us organize that evidence into a pattern we can analyze and hand off."
- **Do:** Draw Evidence → ATT&CK Navigator Layer → Mission and EMLCOA on the board. Tell students to keep their evidence-to-behavior table open.
- **Ask (Q):** What evidence-to-behavior product do you already have that this lesson will map?
- **Expected Response (A):** Steer toward the evidence-to-behavior table. ATT&CK does not replace that evidence.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "ATT&CK gives us a shared vocabulary for observed adversary behavior. Navigator lets us organize that evidence into a pattern we can analyze and hand off."
- **Show:** The three-step flow and the lesson objectives.
- **Do:** Keep evidence-to-behavior tables open on student stations.
- **Ask (Q):** What evidence-to-behavior product do you already have that this lesson will map?
- **Expected Response (A):** Steer toward the evidence-to-behavior table. ATT&CK does not replace that evidence.

---

### Slide 1: MITRE ATT&CK and Attack Navigator (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk MITRE ATT&CK and Attack Navigator in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 2: Lesson Objectives (5 min)

By the end of this lesson you will be able to:
- Recall the purpose for which the MITRE ATT&CK model was created
- Map adversary activity using the MITRE ATT&CK Navigator
- Determine an adversary's mission and EMLCOA using attack navigator and mapped data

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "ATT&CK gives us a shared vocabulary for observed adversary behavior. Navigator lets us organize that evidence into a pattern we can analyze and hand off."
- **Show:** the figure on the slide and the lesson objectives. This hour covers eyes on, the Navigator map, and the EMLCOA. Later hours take the same chain into D3FEND, ENGAGE, and the handoff out of blue space.
- **Do:** Ask students to keep their evidence-to-behavior table open.
- **Ask (Q):** Keep your evidence-to-behavior table open. What will ATT&CK add to it?
- **Expected Response (A):** Shared vocabulary for observed behavior and a Navigator pattern for analysis and handoff. It does not replace evidence.

### Slide 3: Lesson Overview (4 min)

- In this lesson you will be presented with the knowledge highlighted below to develop your analytical skills via the following sections:

**Instructor Notes:**

- **Figures:** `slides/source-figures/M19-s03-0-0c2bc274f756.png`@0.124,0.155,0.826,0.764
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Lesson Overview in the order it is written.
- **Show:** The figure on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 4: Step 1: Eyes on the Adversary (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Step 1: Eyes on the Adversary in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 5: Eyes on the Adversary (5 min)

- Assume the hunt was successful — you have a foothold watching them
- Your first job is do not spook them
- If you spook them, you collapse your own option space
- Remember DRAW-D: their **withdraw** condition shapes everything

**Instructor Notes:**

- **Figures:** `slides/source-figures/M19-s05-0-7ba098890b52.jpg`@0.476,0.144,0.400,0.711
- **Image Prompt:** No image required for this slide.
- **Say:** "This course assumes the hunt has been successful. You are watching them. The first discipline is operational — do not alert them. If you do, you will have temporarily shut down their operation and permanently failed your recon mission."
- **Show:** The concealment graphic; point to the dashed line.
- **Do:** Connect back to DRAW-D from Block 2: "Remember how we said 'withdraw' was the DRAW-D cell that matters most? This is why."
- **Ask (Q):** Why does the DRAW-D withdraw cell shape everything once you have eyes on the adversary?
- **Expected Response (A):** If you spook them you collapse option space and fail recon. Do not break concealment.

### Slide 6: Eyes on the Adversary (5 min)

- **Avoid the "What If" Game**
  - Once an adversary has root/system, they can theoretically do anything
  - Do **not** default to the most destructive EMLCOA
  - Consider the adversary's authority and intent — T10 vs. T50 equivalents
  - Intelligence-collection units rarely destroy; destructive units rarely dwell

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "It is tempting to assume the adversary will do the worst thing they are capable of. Resist that. Intelligence units collect, they do not usually wipe. Destructive units wipe, they do not usually dwell. Your EMLCOA should reflect who the adversary actually is, not who they could theoretically be."
- **Show:** The bullets.
- **Do:** Ask the room: "For FSB Center 18 from yesterday, destructive or not?" Use the answer to reinforce the point.
- **Ask (Q):** For FSB Center 18 from the prior block, destructive or not — and why?
- **Expected Response (A):** Steer toward collection, not wipe. Do not default to the most destructive EMLCOA just because they have root.

### Slide 7: Step 2: Mapping ATT&CK Into Raw Data (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Step 2: Mapping ATT&CK Into Raw Data in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 8: Mapping ATT&CK Into Raw Data (5 min)

- Before we map, we must know what data we have
- Pull up your friendly OCOKA-W "Observation" row
- Data sources drive what techniques you can see at all
- CISA has published the canonical methodology for this

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Mapping ATT&CK is not guessing what technique it looks like. It is tying observable evidence to a technique with analytical justification. And you cannot do that without knowing your own collection — which is why we did OCOKA-W first."
- **Show:** CISA Best Practices for MITRE ATT&CK Mapping — point to the title page.
- **Do:** Remind the class this doc is the reference. They will see it three more times in the next three slides.
- **Ask (Q):** Why did we do OCOKA-W Observation before mapping ATT&CK?
- **Expected Response (A):** Data sources drive which techniques you can see. Mapping ties observable evidence to a technique with justification.

### Slide 9: Mapping ATT&CK Into Raw Data (5 min)

**Option 1: Start From the Data Source**
- You have a data source (Windows Events, Sysmon, EDR, netflow, etc.) — now reason forward
- Ask:
  - What is the object of focus? (file, driver, process, registry key)
  - What action is being performed on the object? (read, write, execute)
  - What techniques require this activity?
  - What substantiating activity would narrow the technique?
- Substantiation examples: known tools (impacket, mimikatz), LOLBAS/GTFOBins use, protocol/port signatures, obfuscation evidence, unexpected behavior on a specific device type

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Option 1 is the most common path for us. You have a log. You ask what the adversary was touching, how they were touching it, and what set of techniques fits. Then you narrow with substantiating evidence — a known tool, a specific LOLBAS, a weird port, an obfuscation pattern."
- **Show:** Live-open https://lolbas-project.github.io/ and https://gtfobins.org/. Click into one LOLBAS entry to demonstrate.
- **Do:** Walk a concrete example — e.g., a PowerShell invocation with encoded command → T1059.001 with T1027 (Obfuscated Files or Information).
- **Ask (Q):** Given encoded PowerShell, what do you ask about object, action, techniques, and substantiation?
- **Expected Response (A):** Walk T1059.001 with T1027 as the taught example. Substantiation can be known tools, LOLBAS/GTFOBins, ports, obfuscation.

### Slide 10: Mapping ATT&CK Into Raw Data (5 min)

**Option 2: Start From Tools or Attributes**
- You saw a specific command, artifact, or tool — broaden the aperture
- Example: registry key under HKLM\Software\Microsoft\Windows\CurrentVersion\Run → T1547.001 (Registry Run Keys / Startup Folder)
- From there, related techniques often apply — e.g., masquerading legitimate entries → T1036
- Use one observation as the seed; explore the neighborhood

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Option 2 starts from a specific tool or artifact. Mimikatz seen on disk — you are now in the credential access neighborhood. A Run key added — T1547.001, and probably masquerading, T1036. One good observation is the seed for the rest of the mapping."
- **Show:** Live-open https://attack.mitre.org/ and navigate T1547.001 → related techniques.
- **Do:** Ask a student to name one tool they have seen in the wild. Map it live, together, on screen.
- **Ask (Q):** Name one tool you have seen in the wild. What ATT&CK neighborhood does it seed?
- **Expected Response (A):** Facilitation only. Map it live. Example in the notes: Run key → T1547.001 and likely T1036.

### Slide 11: Mapping ATT&CK Into Raw Data (5 min)

**Option 3: Start From Analytics**
- Detection rules in a SIEM already encode technique-level logic
- Open-source sources:
  - Sigma (standardized SIEM rule syntax)
  - MITRE CAR (Cyber Analytics Repository)
  - Examples: "LSASS Access from Non-System Account" → credential dumping (T1003)
- Use the rule's logic to find more techniques nearby

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Option 3 starts from your detections. If you have a rule that fires on LSASS access from a non-system account, that rule is telling you the neighborhood to look in — credential dumping, probably Mimikatz or an impacket variant. Follow the rule to the technique to the data source to the adjacent techniques."
- **Show:** One CAR page and one Sigma rule on GitHub — short, just enough to see the structure.
- **Do:** Ask: "Which of your current SIEM rules map cleanly to an ATT&CK technique?" Answers here often surface gaps.
- **Ask (Q):** Which of your current SIEM rules map cleanly to an ATT&CK technique?
- **Expected Response (A):** Facilitation only. Answers often surface gaps. Example: LSASS access from non-system → T1003.

### Slide 12: Mapping ATT&CK Into Raw Data (20 min)

- ATT&CK Navigator is the canonical tool for visualizing observed TTPs
- Build a layer per intrusion; overlay layers to see overlaps across actors
- Export layers for briefs and for hand-off to intel or defenders

**Demo: ATT&CK Navigator**

**https://mitre-attack.github.io/attack-navigator/**

**ATT&CK**

Describes Adversary TTPs

**Instructor Notes:**

- **Figures:** `slides/source-figures/M19-s12-0-941e158eff23.png`@0.514,0.350,0.464,0.427
- **Image Prompt:** No image required for this slide.
- **Say:** "The Navigator is how we visualize an intrusion. I am going to build a layer live — you should have this tool open on your own workstation too."
- **Show:** The figure on the slide.
- **Do:** Have each student create their own Navigator layer for the APT their team already worked. Timebox: **20 minutes**. Timebox: **20 minutes**.
- **Ask (Q):** After 20 minutes, can you show a Navigator layer for the APT your team was assigned?
- **Expected Response (A):** Nested demo: B01.M20. Build a layer; overlay later. Instructor colors 6–8 FSB Center 18 techniques live.

### Slide 13: Mapping ATT&CK Into Raw Data (50 min)

- **Practical Application: **Map an Intrusion to an ATT&CK navigator layer
- **Objective: **Map the Adversary's attack onto an attack navigator layer
- **Instructions:**Using the **https://mitre-attack.github.io/attack-navigator/** produce a navigator Layer AND an analytical justification for each technique listed below

**Column titles:**

|  | Attack | Justification |
| --- | --- | --- |
| Log 1 (Email Gateway): An email is delivered with a .lnk attachment. | T1092: | it looked like it |
| Log 2 (Sysmon Event 1): mshta.exe is observed executing a URL hosted on a .ru domain. |  |  |
| Log 3 (Sysmon Event 1): powershell.exe is observed running a command containing Invoke-Expression and a Base64 encoded string. | T####: Name listed here | We observed encoded #### in Sysmon Event 1 Doing this and that consistent with T####.### |
| Log 4 (EDR Log): PteroLNK.vbs is observed querying WMI for win32_logicaldisk where mediatype=null. |  |  |
| Log 5 (File Auditing): PteroPSDoor.ps1 is observed reading files with extensions .docx, .xlsx, and .pdf from a user's Desktop and writing them to a staging directory in %LOCALAPPDATA%\vector. |  |  |

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "This is where you earn the mapping. You get an intrusion narrative. You produce a Navigator layer. You justify each technique — not just 'it looked like T1059,' but 'we observed encoded PowerShell in Event 4104 invoking an external URL, consistent with T1059.001 and T1105.'"
- **Show:** Demonstrate one evidence-to-technique row, then leave the required fields visible.
- **Do:** Timebox: **45–60 minutes**. Back-brief each team in **5 minutes** with Navigator shared to the projector. Challenge unsupported mappings and reward calibrated confidence.
- **Ask (Q):** For each mapped technique, what four fields must you state?
- **Expected Response (A):** Observed fact and source; behavior it supports; technique/sub-technique; confidence and competing interpretations. Nested drill: B01.M21. Challenge unsupported mappings.

### Slide 14: Step 3: Determine the Adversary's Mission and EMLCOA (1 min)

**Instructor Notes:**

- **Slide role:** section
- **Image Prompt:** No image required for this slide.
- **Say:** Walk Step 3: Determine the Adversary's Mission and EMLCOA in the order it is written.
- **Show:** The points on the slide.
- **Do:** Ask one student to restate the point in their own words.
- **Ask (Q):** What is the operational point of this slide?
- **Expected Response (A):** A restatement of the on-slide point. Do not require a scored answer.

### Slide 15: Determine the Adversary's Mission and EMLCOA (8 min)

- Use the ATT&CK layer you just built as evidence
- Ask: what mission requires this set of techniques?
- Build the EMLCOA straight from the technique pattern
- Name actions on contact based on DRAW-D — do not default to destructive

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Now you take the layer and work backward. This cluster of techniques is not random — it is a mission. What mission? State it as an EMLCOA and defend the statement with the techniques on the layer."
- **Show:** The Navigator layer from the lab.
- **Do:** Team back-brief: each team takes 2 minutes to state the EMLCOA their layer implies.
- **Ask (Q):** What mission does your layer imply, stated as an EMLCOA?
- **Expected Response (A):** Work backward from the technique pattern. Do not default to destructive. Nested drill: B01.M22. Two minutes per team.

### Slide 16: Lesson Summary (7 min)

You should now be able to:
- Recall the purpose for which the MITRE ATT&K model was created
- Map adversary activity using the MITRE ATT&K Navigator
- Determine an Adversary's Mission and EMLCOA using ATT&K navigator and mapped data

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "You now have an evidence-backed layer and an assessment of what mission that pattern serves. Convert the same layer into options for the commander."
- **Show:** One team layer and its analytical-justification table.
- **Do:** Save exported layers.
- **Ask (Q):** What two products hand off to D3FEND and ENGAGE mapping?
- **Expected Response (A):** An evidence-backed Navigator layer and a mission/EMLCOA assessment. Those convert into D3FEND and ENGAGE options.

## Lesson summary

- ATT&CK is a shared vocabulary for observed adversary behavior; it does not replace evidence.
- Map from data sources, tools/attributes, or analytics, then substantiate. Navigator organizes the pattern.
- Nested `B01.M20` demonstrates Navigator; `B01.M21` maps an intrusion; `B01.M22` states mission and EMLCOA from the layer.
- Convert the same layer into D3FEND and ENGAGE options.

## Questions and check on learning

- **Ask (Q):** Why must mapping start from observable evidence rather than a "what if" destructive EMLCOA?
- **Expected Response (A):** Root/system does not make wipe the likely course. Intelligence units collect; DRAW-D withdraw still shapes recon.
- **Ask (Q):** What are the three CISA mapping entry points taught here?
- **Expected Response (A):** Data source; tools or attributes; analytics (Sigma / CAR).
- **Ask (Q):** What two products hand off to D3FEND and ENGAGE mapping?
- **Expected Response (A):** Exported Navigator layer plus an analytical-justification table, and a mission/EMLCOA stated from that pattern.
