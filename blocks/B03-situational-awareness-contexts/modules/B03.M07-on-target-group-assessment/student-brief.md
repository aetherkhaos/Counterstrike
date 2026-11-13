---

id: B03.M07-brief
title: On-Target Group Assessment — Student Brief
artifact_type: student_brief
audience: student
block: B03
module_type: assessment
source_status: canonical
review_required: false
output_formats:

- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal

---

### **On-Target Group Assessment: Enumeration, Gaining Access, and Situational Awareness Exercise**

**Date:** 4JUNE26
**Duration:** Full training day (approximately 6–7 hours of work + two 10-minute team briefs)
**Audience:** CounterStrike Operators (teams of 4)
**Objective:** Validate your mastery of the **full military tactical planning process** (METT-TC → EMLCOA → CG/CV/Exp. Plan → SOM → FSP → TASKS), then **enumeration, initial access, and situational awareness** against a defended network. Issued **mission** and **commander’s intent** are separate statements below. Restate both in Phase 1; do not copy the mission “IOT” as intent purpose.

You will use **all** of the military tactical planning frameworks (tactical tasks, SALUTE/DRAW-D/OCOKA-W, EMLCOA, CG/CV analysis, MITRE ATT&CK, MITRE D3FEND, MITRE ENGAGE, and D3FEND CAD where appropriate). After the commander approves an access vector, **enumerate, exploit, and gain situational awareness on** authorized adversary infrastructure and update your plan accordingly.

---



## Scenario Overview

The commander has tasked your team to conduct a counterstrike operation from the **Lunovia Network** against the **Varenskian** nation-state adversary. The network is compromised and is bleeding intelligence.

### Mission

On order, Counterstrike teams interdict Varenskian collection on the Lunovia Network IOT deny or degrade the adversary’s ability to collect intelligence.

- **Who:** your team (Counterstrike operators)
- **What:** interdict (enemy-oriented; disrupt as required)
- **When:** on order (this assessment day)
- **Where:** Lunovia Network, then authorized adversary infrastructure
- **Why (mission purpose):** deny or degrade the adversary’s ability to collect intelligence

**Specified tasks**

1. Produce commander-ready options for pursuit.
2. After the commander approves an access vector, reconnoiter accessed adversary terrain IOT inform subsequent command decisions.



### Commander’s intent

**Purpose.** Stop unopposed intelligence loss on Lunovia and put the commander in a position to pursue, hold, or disengage with evidence, not hope.

**Key tasks.**

- Characterize how the adversary is collecting against Lunovia across physical, logical, and persona terrain.
- Present evidence-based options for pursuit and wait for the commander’s access decision.
- After approval, reconnoiter the accessed terrain and update the plan.

**End state.**

- **Friendly:** The commander holds a usable plan and terrain survey. Options for pursuit exist. The force remains inside assigned authorities.
- **Enemy:** Collection against Lunovia is characterized and, where approved, disrupted or degraded. The adversary has not been given a free warning before the commander’s decision.
- **Terrain:** Lunovia and any authorized adversary infrastructure are described well enough to support the next decision.
- **Civil:** Lunovian stakeholder exposure is understood and not worsened by unsanctioned access.

You will receive five key inputs at the start of the day:

- EIS Group Seraph-3
- Seraph-3 Threat Hunt Report
- Network Map
- Hunt Notes
- Tactical Planning Student Guide

---



## Assessment Structure (Two Phases)

The exercise is deliberately split into two phases to mirror the real planning timeline and allow for mid-course correction after commander feedback.

### **Phase 1: Begin the planning, Arrange Recon, Make Recon**

**Time allotted:** ~3 hours (including analysis and prep)
**Deliverable:** Completed brief covering the entire input side of the planning process. Produce **one consolidated team brief** that includes:

- **METT-TC, EMLCOA, CG/CV**
  - Mission analysis (explicit/implied tasks, restated mission, and restated commander’s intent: purpose, key tasks, end state)
  - Enemy analysis (SALUTE + DRAW-D)
  - Troops & Fire Support Available
  - Terrain & Weather analysis (Friendly OCOKA-W **and** Enemy OCOKA-W across all three layers of cyberspace)
  - Time/Space/Logistics + Civilian Considerations (ASCOPE/PMESII as relevant)
  - EMLCOA (one-paragraph enemy scheme of maneuver)
  - Center of Gravity (CG)
  - Critical Vulnerability (CV)
- **Exploitation Plan**
  - Map the adversary’s key ATT&CK techniques (from your Navigator layer) to this scenario.
  - For each major technique (or cluster), identify **paired D3FEND (D3) + ENGAGE (EAC)** options.
  - Explicitly state for each option: goal (Expose/Affect/Elicit), expected effect on adversary CG/CV, risk, and authority required.
  - Produce a **D3FEND CAD graph** (minimum: Agent node + 2–3 Attack nodes + 1 Artifact + 1 Condition + 1+ Countermeasure; use provenance and typed edges).
  - **DECISION POINT:** Identify initial access vectors into adversary infrastructure. Brief the commander and await their decision before attempting access.
- **Scheme of Maneuver (SOM)**
  - Phased plan that directly targets the CV.
  - Describe how you will occupy/deny terrain across physical, logical, and persona layers.
  - Address adversary actions on contact (withdraw, reinforce, etc.).
- **Fire Support Plan (FSP)**
  - Identify rear-echelon / higher / adjacent support required (forensics, malware analysis, infrastructure, legal, intel, etc.).
  - Deconfliction plan with other friendly cyber elements.
- **Tasks**
  - Specific tactical tasks (with purpose “in order to…” statements) assigned to each team member/role.
  - Reference the tactical task handout from Block 1 where applicable.
  - Include measures of performance/effectiveness and supervision plan.
- **Include the specific MITRE ATT&CK T-Codes utilized to:**
  - Conduct Reconnaissance
  - Develop any resources

**Output format:** Use the Tactical Planning Process student handout templates. Be specific, evidence-based, and honest about assumptions/RFIs.

**10-Minute Team Brief (end of Phase 1):**
Each team will deliver a **10-minute back-brief** (8 min presentation + 2 min Q&A) to the instructor cadre and the class. Focus on:

- Your exploitation plan. **Do not speak in vague platitudes.** Provide concrete technical details (with evidence) about any plans to gain initial access.
- Key assumptions and RFIs

## **Goal of brief:** Provide the Commander with options before you move into phase 2 and gaining access to adversary infrastructure.



### **Phase 2: Complete the Planning, Gain Access, Gain Situational Awareness**

**Time allotted:** ~2.5–3 hours
**Deliverable:** Commander-ready execution products. Add to your Phase 1 brief:

- **Graphical Depiction of Operation**
  - Using whatever tool you want, provide the commander with a visual of the operation that was conducted (give your brief over some kind of map).
- **Operation AAR**
  - Include the specific MITRE ATT&CK T-Codes utilized to:
    - Gain initial access
    - Gain code execution
    - Privilege escalate
    - Any defense impairment or stealth techniques
    - Gain situational awareness
    - Any collection or exfiltration
    - C2/Interact with the target

**10-Minute Team Brief (end of Phase 2):**
Each team delivers a **10-minute execution brief** (8 min + 2 min Q&A). Treat this as a formal commander’s brief. Include:

- Your Exploitation Plan (highlight D3 + EAC pairings and CAD graph)
- SOM overview (phases)
- FSP and Tasks
- Overall confidence in “stopping the bleeding” and why this plan will work

**Visual aid:** Project your CAD graph + any key slides/tables from your packet.

---



## Timeline

- **0800–0815** — In-brief, scenario hand-out, team formation
- **0815–1115** — Phase 1 work
- **1115–1205** — Phase 1 team briefs (10 min each + rotation)
- **1205–1300** — Lunch / instructor feedback on Phase 1
- **1300–1530** — Phase 2 work
- **1530–1630** — Phase 2 team briefs (10 min each + rotation)
- **1630–1700** — Hot wash / instructor debrief / collection of packets

---



## Evaluation Criteria

Instructors will assess based on:

- **Analytical rigor** — Use of doctrine (METT-TC, DRAW-D, OCOKA-W, EMLCOA, CG/CV) with evidence from the intel sheet and map.
- **Framework integration** — Accurate mapping of ATT&CK → D3FEND/ENGAGE, realistic option pairing, and quality CAD graph.
- **Feasibility & discipline** — Options respect authorities, risk, operational safety, and “do not spook the adversary” principles.
- **Clarity & professionalism** — Briefs are concise, visual, and commander-focused; written products are clear and usable as hand-off artifacts.
- **Teamwork** — Full participation; every member contributes visibly.

---

**Final Note:** This is your week 3 Assessment. Treat it exactly as you would a real-world mission. The products you produce today are the exact artifacts you will hand to a commander or pass to the next shift in a real operation.

**Questions?** Ask your instructors before Phase 1 begins.

---

