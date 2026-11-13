---
id: B01.M13
title: APT SALUTE
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
- B01.M07
---

# APT SALUTE

This Module was previously an embedded exercise in [B01.M09 Military Tactical Planning](../B01.M09-military-tactical-planning/content-guide.md). Complete it in sequence immediately after that lecture.

### Slide 14: Enemy Analysis — SALUTE

- **S**ize — monetary backing, workforce, AI-augmented scale
- **A**ctivity — what are they doing? Map to MITRE ATT&CK
- **L**ocation — physical **and** logical; both ends of the tunnel
- **U**nit — the actual foreign intel entity or military unit behind the tradecraft
- **T**ime — when was the activity observed?
- **E**quipment — tooling

**Instructor Notes:**

- **Image Prompt:** A six-pointed SALUTE diagram; each point labeled with one letter and the enemy-analysis question it answers. Clean diagram style.
- **Say:** "SALUTE captures composition, disposition, and strength. In cyber, size is usually a proxy for money. Activity is your MITRE ATT&CK mapping. Location has two layers — physical and logical — and you have to articulate both. Unit matters because we are not hunting 'Fancy Bear'; we are hunting the GRU."
- **Show:** The SALUTE diagram.
- **Do:** Give the class one example SALUTE line for each letter using a well-known APT — pick one they will all recognize.
### Slide 15: Group Exercise — APT SALUTE Back-Brief

- Each team gets one APT report
- Produce a SALUTE analysis and brief it back
- Candidate groups (from the source doc):
  - **APT28** — Fancy Bear
  - **Gamaredon** (FSB Center 18)
  - **APT41** — Wicked Panda
  - **NightEagle**
  - **Void Blizzard**

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Each team gets one APT report. You will produce a SALUTE on that actor and brief it back in five minutes. The goal is not a perfect product — it is to practice the extraction."
- **Show:** The reports available in `../../references/Threat Actor Reports/` (e.g., `cyberespionage-gamaredon-way.pdf`, `CSA_COUNTERING_CHINA_STATE_ACTORS_COMPROMISE_OF_NETWORKS.pdf`, `ESET_InvisiMole.pdf`, `aa23-129a_snake_malware_2.pdf`).
- **Do:** Break into teams. Timebox: **30 minutes** of analysis + **5 minutes per team** to back-brief. Call out gaps — the gaps are the RFIs they would submit to their real intel section.
