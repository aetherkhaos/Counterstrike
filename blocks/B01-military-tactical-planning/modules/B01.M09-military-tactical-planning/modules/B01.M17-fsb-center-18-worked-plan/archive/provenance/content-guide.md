---
id: B01.M17
title: FSB Center 18 Worked Plan
artifact_type: content_guide
audience: instructor
block: B01
module_type: group_activity
related_to: B01.M09
source_status: canonical
review_required: false
template_profile: content_guide_v1
sensitivity: course_internal
legacy_aliases:
- B01.M11
---

# FSB Center 18 Worked Plan

This Module was previously an embedded exercise in [B01.M09 Military Tactical Planning](../B01.M09-military-tactical-planning/content-guide.md). Complete it in sequence immediately after that lecture.

### Slide 29: Worked Example — Mission and SALUTE

- Mission: **Deny or degrade FSB Center 18's ability to collect intelligence from Network X in order to preserve friendly freedom of maneuver in cyberspace**
- **Size:** FSB-resourced; exact manpower is an RFI
- **Activity:** cyberespionage and rapid document collection
- **Location:** occupied Crimea physically; global infrastructure and Ukrainian networks logically
- **Unit:** FSB Center 18, Military Unit 64829
- **Time:** ongoing
- **Equipment:** obfuscated scripts, droppers, weaponizers, stealers, backdoors, and SOCKS proxies

**Instructor Notes:**

- **Image Prompt:** The planning pipeline overlaid on a simple FSB Center 18 actor card.
- **Say:** "This is an instructor worked example. Industry calls the cluster Gamaredon; our planning unit is FSB Center 18. That distinction changes how we state assumptions, attribution, and support relationships."
- **Show:** `../../references/Threat Actor Reports/cyberespionage-gamaredon-way.pdf`, especially the toolchain section.
- **Do:** Walk each SALUTE line. Mark unsupported manpower and infrastructure details as RFIs.
### Slide 30: Worked Example — Toolchain and DRAW-D

- Initial access: weaponized LNK/HTA files and removable media
- Collection: PteroSteal, PteroCookie, PteroSig, PteroGram, and document-focused tooling
- Persistence/reinforcement: weaponized templates, scheduled tasks, redundant backdoors
- **Defend/Reinforce:** resilient third-party services and potential handoff to more capable support
- **Attack:** destructive capability is possible, but intelligence collection is the observed mission
- **Withdraw:** full withdrawal is unlikely; redundant/self-propagating access complicates it
- **Delay:** obfuscation and compromise volume slow defenders

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "DRAW-D is evidence plus bounded inference. The observed mission is collection. Do not make destructive action the EMLCOA merely because root access makes it technically possible."
- **Show:** Link each conclusion to the report evidence or label it an assumption.
- **Do:** Teams receive **15 minutes** to challenge one DRAW-D conclusion and write the RFI that would resolve it.
### Slide 31: Worked Example — Friendly Resources and Terrain

- Organic team: 3 host analysts, 3 network analysts, 1 all-source analyst, 1 counter-strike operator, 1 malware analyst
- Direct support: 1 supporting operations element
- Friendly observation: endpoint telemetry, event logs, network boundary visibility
- Enemy key terrain: user workstations, file servers, persistence locations, and document access
- Avenues: spear-phishing, weaponized removable media, and LNK execution
- Treat every visibility or support claim as a planning assumption until confirmed

**Instructor Notes:**

- **Image Prompt:** A small team roster beside physical/logical/persona terrain layers.
- **Say:** "A concrete roster prevents imaginary capabilities from entering the plan. Terrain is not a host inventory; it is what enables or constrains each side's mission."
- **Show:** Contrast friendly and enemy key terrain.
- **Do:** Ask teams to identify one resource shortfall and one terrain conclusion that would change the plan.
### Slide 32: Worked Example — EMLCOA

- Mission: continuously collect sensitive data to satisfy Russian intelligence requirements
- Current activity: repeated script-based access, document theft, credential/browser-data collection, and resilient C2
- Actions on contact: use alternate backdoors and channels; reinforce high-value access rather than immediately withdraw
- Confidence: moderate; support relationships and exact fallback capacity remain RFIs

**Instructor Notes:**

- **Image Prompt:** Three-column EMLCOA card: mission, current activity, actions on contact.
- **Say:** "This EMLCOA does not contradict our earlier warning about withdrawal. It demonstrates why DRAW-D must be actor-specific: this actor's observed redundancy supports a different action-on-contact assessment."
- **Show:** The evidence chain from SALUTE and DRAW-D.
- **Do:** Have teams write a one-paragraph alternative EMLCOA and state what evidence would make it more likely.
### Slide 33: Worked Example — COG, CV, and Exploitation Plan

- One defensible COG: **the repeatable speed of collection and exfiltration**
- Critical capabilities: rapidly execute, find target documents, and maintain outbound paths
- Critical requirements: script-based tooling, common persistence points, and observable process/registry activity
- Candidate CV: reliance on script-heavy and living-off-the-land behaviors that can be baselined and detected
- Exploitation plan: reduce detection time with ATT&CK-mapped telemetry, then isolate and scope affected systems

**Instructor Notes:**

- **Image Prompt:** A dependency chain for the worked FSB example.
- **Say:** "Another team may argue that persistent access is the COG. That is valid if its evidence chain is stronger. Use competing COGs to teach that the analysis must be explicit, not that one phrase is the answer."
- **Show:** Compare the speed-of-collection and persistent-access interpretations.
- **Do:** Ask each team to defend one interpretation using mission, capability, requirement, and vulnerability.
