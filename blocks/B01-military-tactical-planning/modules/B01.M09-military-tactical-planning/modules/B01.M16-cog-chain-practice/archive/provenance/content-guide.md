---
id: B01.M16
title: COG/CC/CR/CV Chain
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
- B01.M10
---

# COG/CC/CR/CV Chain

This Module was previously an embedded exercise in [B01.M09 Military Tactical Planning](../B01.M09-military-tactical-planning/content-guide.md). Complete it in sequence immediately after that lecture.

### Slide 24: EMLCOA — Enemy's Most Likely Course of Action

- After METT-TC, you **build the enemy's plan for them**
- Working definition: *the enemy's scheme of maneuver — their **task**, **purpose**, and **method** of imposing their will*
- Three questions drive the EMLCOA:
  - What do I deduce is the enemy's **mission**?
  - What is their **current tactical activity**?
  - What are their **actions on contact** — how will they react when we impose our will?
- **Contact** = any input that alters the enemy's current state — it is not just "kinetic"
- The EMLCOA shapes your own SOM in two ways: it must counter what the enemy is doing **now** *and* what they will do **on contact**

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "EMLCOA is not a guess. It is the output of your METT-TC. You have done SALUTE, DRAW-D, and terrain — now you assemble an assumption of the enemy's plan. Think of it as their task, their purpose, and their method of imposing their will. That assumption is what your commander has to counter — and your scheme of maneuver has to counter it in two states: what they are doing right now, and what they will do the moment they realize we are here."
- **Show:** The three driving questions plus the definition.
- **Do:** Reminder: "Actions on contact is where DRAW-D pays off. If you skipped DRAW-D, you cannot answer question three. And remember — 'contact' does not mean a gunfight. It means any input from us that changes the enemy's state — a blocked account, a rotated credential, a sudden change in traffic. If they notice, that is contact."
### Slide 25: Center of Gravity

- Definition: *"that element or capability which allows the enemy to execute his mission or scheme of maneuver successfully."*
- In cyber, CG is often a **combination** — stealth + creds, tooling + infrastructure, access + time
- Name it specifically. "Their operators" is not a CG.

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Center of gravity is the thing that, if it goes away, their mission falls apart. In cyber it is rarely one thing. Usually it is a pair — stealth plus admin creds, or a specific piece of tooling plus an unpatched access route."
- **Show:** The definition; read it verbatim.
- **Do:** Ask the room: "For the APT your team analyzed — take thirty seconds and write down a candidate center of gravity." Collect two answers.
### Slide 26: Critical Capabilities and Requirements

- **Critical capabilities:** what the COG must be able to do to achieve the mission
- **Critical requirements:** resources, conditions, or means the capabilities depend on
- **Critical vulnerabilities:** requirements that are deficient or exploitable
- Trace the chain: mission → COG → capability → requirement → vulnerability

**Instructor Notes:**

- **Image Prompt:** A dependency chain from Mission to COG to Critical Capability to Critical Requirement to Critical Vulnerability.
- **Say:** "Do not jump from a vague center of gravity directly to a favorite tool. Critical capabilities explain what the COG must do. Critical requirements explain what it needs. The critical vulnerability is the requirement you can actually exploit."
- **Show:** Work one FSB example: rapid collection requires repeatable execution, document access, and resilient outbound paths; script-heavy execution and observable persistence can become exploitable requirements.
- **Do:** Ask teams to add one critical capability and one critical requirement beneath their candidate COG before naming a CV.
### Slide 27: Critical Vulnerability

- Definition: *"what vulnerability can be exploited that will render their center of gravity ineffective?"*
- The CV is the **lever** on the CG
- If you cannot name a CV, your CG is probably too abstract

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Critical vulnerability is the thing you can actually do something about. If your CG was 'stealth plus admin creds,' your CV might be the specific credential set they rely on. Knocking that set out — rotating the passwords, disabling the account — collapses the center of gravity."
- **Show:** The definition.
- **Do:** Back to the same teams: "Take the CG you wrote down. Now write a CV that attacks it." Timebox: **5 minutes**.
