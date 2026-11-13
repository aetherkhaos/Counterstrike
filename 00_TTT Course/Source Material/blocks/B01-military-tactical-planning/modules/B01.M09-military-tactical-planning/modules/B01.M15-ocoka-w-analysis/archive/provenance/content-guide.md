---
id: B01.M15
title: Friendly and Enemy OCOKA-W
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
- B01.M09
---

# Friendly and Enemy OCOKA-W

This Module was previously an embedded exercise in [B01.M09 Military Tactical Planning](../B01.M09-military-tactical-planning/content-guide.md). Complete it in sequence immediately after that lecture.

### Slide 19: Terrain Analysis — OCOKA-W

- Must be done from **both** friendly and enemy perspectives
- **O**bservation and fields of fire
- **C**over and concealment
- **O**bstacles
- **K**ey terrain
- **A**venues of approach
- **W**eather

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Yes, I am going to teach OCOKA-W in a cyber class. Some of it is going to bolt on cleanly, some with effort, and some will feel like a stretch. We are going to go through it honestly and mark the places where the analogy breaks."
- **Show:** The acronym expanded; flag that it gets done twice — friendly and enemy.
- **Do:** Preview: the next two slides are friendly OCOKA-W and enemy OCOKA-W, back to back.
### Slide 20: Friendly OCOKA-W in Cyber

- **Observation & Fields of Fire:** what data sources do I have? passive taps, full PCAP, netflow, EDR, host logs
- **Cover & Concealment:** am I overt or am I using obfuscation infrastructure?
- **Obstacles:** barriers to my scheme of maneuver or data acquisition
- **Key Terrain:** tie it to the **purpose** of the network, not just the prettiest host
- **Avenues of Approach:** treat ATT&CK Initial Access techniques as avenues
- **Weather:** power and comms availability (sat links included)

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Key terrain is where people get lazy. Everyone throws out 'the domain controller.' Sometimes. But your key terrain is whatever enables the mission *the network was built to perform*, and your adversary's key terrain may be different from yours because they are there for a different reason."
- **Show:** Each bullet; spend longest on Key Terrain.
- **Do:** Ask: "Name a network you have worked and tell me one piece of key terrain that is **not** a domain controller." Collect three or four answers.
### Slide 21: Enemy OCOKA-W in Cyber

- **Observation & Fields of Fire:** what sensors does the adversary have? insider access? centralized logging on their infra?
- **Cover & Concealment:** are they loud, or matching the baseline?
- **Obstacles:** what is slowing *them* down?
- **Key Terrain:** across all three layers — physical, logical, persona
- **Avenues of Approach:** same ATT&CK Initial Access frame
- **Weather:** same friendly considerations

**Instructor Notes:**

- **Image Prompt:** A three-layer cyber terrain diagram — bottom layer "Physical" (routers, cabling, server rooms), middle layer "Logical" (IP, routing, services), top layer "Persona" (identities, credentials, accounts). Labeled on the right side with "Key terrain exists on every layer."
- **Say:** "Their key terrain is whatever enables *their* mission. Enumerate it across all three layers of cyberspace — physical, logical, persona. If you only think about key terrain at the logical layer you will miss half of it."
- **Show:** The three-layer diagram.
- **Do:** Ask the room to name one piece of enemy key terrain at each layer for the APT their team drew earlier.
