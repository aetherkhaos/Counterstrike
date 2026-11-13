---

id: B04.M19-brief
title: Effects Group Assessment — Student Brief
artifact_type: student_brief
audience: student
block: B04
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

### **Effects Assessment: Effects Operations and Persistent Redirector Monitoring Exercise**

**Duration:** Full training day (approximately 6-7 hours of work + two 10-minute team briefs)
**Audience:** CounterStrike Operators (teams of 4)
**Objective:** Validate your mastery of effects operations by applying tactical planning, adversary-infrastructure access, and effects tradecraft against the same operational problem. Your team will plan, rehearse, execute, assess, and report a mission-relevant effect while maintaining presence on an adversary redirector to protect OPERATION SHINY HAMMER.

You will use the prior planning frameworks (METT-TC, EMLCOA, CG/CV analysis, SOM, FSP, and tasks) and the effects frameworks (effect naming, authority, burn risk, reversibility, mission rehearsal, access preservation, and battle damage assessment). Your work must be commander-ready and evidence-based.

---



## Scenario Overview

Follow-on from the planning group assessment and the on-target group assessment. Same Lunovia/Varenskian network. Each team starts with authorized access to an adversary redirector in gray space. Use that access to produce a mission-relevant effect while preserving enough access and evidence for follow-on operations.

### Mission

On order, Counterstrike teams disrupt Varenskian operations from authorized gray-space redirector access IOT deny or degrade adversary freedom of maneuver against Lunovia.

- **Who:** your team (Counterstrike operators)
- **What:** disrupt (enemy-oriented; other authorized effects as required)
- **When:** on order (this assessment day)
- **Where:** authorized adversary redirector, then related exfiltration paths
- **Why (mission purpose):** deny or degrade adversary freedom of maneuver against Lunovia

**Specified tasks**

1. Identify, rehearse, and execute one mission-relevant effect from the authorized redirector access. Do not execute until the instructor acting as commander approves the pre-execution check.
2. Maintain presence on the redirector and monitor exfiltrated data for OPERATION SHINY HAMMER using the protected-operation background below. If related data is confirmed, delete it immediately and alert the commander.

You will receive the same scenario references used in prior group activities, plus any range card or instructor-provided access details for the redirector.

---



## Commander’s intent

**Purpose.** Keep OPERATION SHINY HAMMER from becoming usable adversary intelligence while still producing a measurable effect and leaving access for follow-on work.

**Key tasks.**

- Produce a mission-relevant effect from authorized redirector access without unnecessary burn.
- Maintain presence and monitor exfiltrated data for direct or indirect SHINY HAMMER indicators, including paraphrase and euphemism. Keyword-only search is not enough.
- On confirmation, remove the data, keep the minimum metadata for accountability, and notify the commander without delay.

**End state.**

- **Friendly:** The commander has a measurable effect, intact redirector access where possible, and timely notice of any SHINY HAMMER exposure.
- **Enemy:** Adversary freedom of maneuver against Lunovia is denied or degraded. The adversary does not retain OPERATION SHINY HAMMER information from this redirector.
- **Terrain:** The redirector and observed exfiltration paths remain understood and usable for follow-on operations.
- **Civil:** Friendly remediation continues without added compromise of protected mission details.

---



## OPERATION SHINY HAMMER — protected-operation background

OPERATION SHINY HAMMER is a multi-national, joint-force stabilization mission in the coastal regions of the southern littoral zone. It degrades hostile anti-access/area-denial capabilities and re-establishes secure maritime trade lanes through a critical global choke point.

It was initiated in response to escalating irregular warfare by regional non-state actors. It integrates carrier-based strike packages with specialized amphibious reconnaissance units. Over a rolling forty-eight hour operational window, coalition forces neutralize key radar installations and littoral missile batteries to restore freedom of navigation.

The follow-on phase is civil-military operations and infrastructure fortification. Working with local governance, engineering battalions repair damaged port facilities, establish hardened security checkpoints along vital supply routes, enable humanitarian distribution networks, and embed long-term training detachments with host-nation forces.

**Seed facts for detection (not an exhaustive keyword list).** Treat combinations, paraphrases, summaries, and euphemisms of these as in-scope:

| Theme | Details your method should be able to bind together |
| --- | --- |
| Name / cover | OPERATION SHINY HAMMER; unnamed “the littoral op,” “the choke-point mission,” “the stabilization package” |
| Mission type | Multi-national joint stabilization; freedom of navigation; degrade A2/AD |
| Geography | Southern littoral / coastal zone; critical global maritime choke point; port approaches |
| Strike / recon | Carrier-based strike; amphibious reconnaissance; radar sites; littoral missile batteries; rolling 48-hour window |
| Civil-military | Port repair; hardened checkpoints; supply-route security; humanitarian distribution; host-nation training detachments |
| Language you should still catch | Talk of “the coalition landing,” “the navy package offshore,” “the engineers at the harbor,” “the 48-hour pulse,” or similar without the operation name |

Use this background as context. Keyword matching on `SHINY HAMMER` (or a short string list) is not sufficient by itself. Your Phase 1 monitoring plan must explain how you flag exfil, what you treat as a hit vs a near miss, and what you do on confirmation (metadata, delete, alert).

---



## Assessment Structure

The exercise is split into three phases to mirror a real effects operation: plan, rehearse, execute and assess.

### **Phase 1: Mission Analysis, Effect Selection, and Monitoring Plan**

**Time allotted:** ~2.5 hours
**Deliverable:** Commander-ready planning brief. Produce one consolidated team brief that includes:

- **Updated Tactical Analysis**
  - Mission analysis with explicit and implied tasks, restated mission, and restated commander’s intent (purpose, key tasks, end state).
  - Enemy analysis tied to the adversary redirector and prior on-target enumeration findings.
  - Friendly capabilities, authorities, constraints, and support requirements.
  - Terrain analysis across physical, logical, and persona layers, focused on the redirector and any observed exfiltration flow.
  - Updated EMLCOA, CG/CV, assumptions, and RFIs.
- **Mission-Relevant Effect Selection**
  - Identify the effect your team intends to generate.
  - Name the effect using the effects vocabulary, such as `deny`, `degrade`, `disrupt`, `deceive`, `manipulate`, `reconnoiter`, or `handoff`.
  - Explain why this effect is relevant to the mission and how it acts on the adversary CG/CV.
  - State the expected adversary response and how you will avoid unnecessary burn risk.
- **Scheme of Maneuver, Fire Support Plan, and Tasks**
  - Provide a phased SOM from access validation through execution, BDA, and reporting.
  - Identify support required from instructors, intelligence, legal, forensics, infrastructure, or adjacent teams.
  - Assign specific tasks to each team member with purpose statements, measures of performance, and measures of effectiveness.
- **Battle Damage Assessment Plan**
  - Define what you expect to change if the effect succeeds.
  - Identify before/after evidence sources.
  - Separate measures of performance from measures of effectiveness.
  - State what uncertainty will remain after execution and how you will communicate it to the commander.
- **OPERATION SHINY HAMMER Monitoring Plan**
  - Describe how you will maintain presence on the redirector while executing your primary effect.
  - Identify where exfiltrated data is likely staged, logged, queued, or forwarded.
  - Explain your semantic or contextual detection approach for SHINY HAMMER-related content.
  - Define deletion criteria, alerting criteria, notification path, and evidence preservation steps.
  - Explain how you will avoid relying only on exact keyword matching.

**10-Minute Team Brief (end of Phase 1):**
Each team will deliver a 10-minute planning back-brief (8 min presentation + 2 min Q&A) to the instructor cadre. Focus on:

- Your selected effect and why it matters.
- Your SOM, FSP, and task organization.
- Your BDA plan.
- Your SHINY HAMMER monitoring, deletion, and alerting plan.
- Any assumptions or RFIs that must be resolved before rehearsal.

**Goal of brief:** Convince the commander that your planned effect is feasible, authorized, measurable, and compatible with the requirement to protect OPERATION SHINY HAMMER.

---



### **Phase 2: Mission Rehearsal and Pre-Execution Check**

**Time allotted:** ~1.5 hours
**Deliverable:** Rehearsal record and pre-execution checklist.

Before touching the live effect path, conduct a mission rehearsal. The rehearsal may be a tabletop, command walkthrough, dry run against inert artifacts, or instructor-approved range rehearsal. It must be specific enough to reveal timing, access, communication, and evidence problems before execution.

Your rehearsal must include:

- Access validation and role handoff.
- Exact execution sequence and abort points.
- Expected system responses and adversary-observable indicators.
- Rollback or containment action, if applicable.
- BDA collection sequence.
- SHINY HAMMER monitoring coverage during the effect.
- Alerting drill for a suspected SHINY HAMMER hit.
- Communications plan for commander updates.

Before execution, complete a written pre-execution check:

```text
Authority:
Target and surface:
Intended effect:
Execution steps:
Rollback or containment:
Predicted adversary response:
Burn-risk assessment:
BDA evidence sources:
SHINY HAMMER monitoring coverage:
Go / no-go decision:
```

Do not execute until the instructor acting as mission commander approves your pre-execution check.

---



### **Phase 3: Execute, Monitor, Assess, and Report**

**Time allotted:** ~2-2.5 hours
**Deliverable:** Commander-ready AAR packet.

Execute the approved operation and generate the planned effect. During execution, maintain redirector monitoring for SHINY HAMMER-related data. If your team discovers data related to the protected operation, you must:

1. Record enough metadata to support the alert and later reconstruction without spreading the protected content.
2. Delete the related data from the adversary redirector within the authority granted for this exercise.
3. Alert the commander immediately through the instructor-designated path.
4. Continue monitoring unless the commander directs otherwise.

Your final packet must include:

- **Graphical Depiction of Operation**
  - A map, diagram, timeline, or workflow view showing what your team did, where you operated, and what evidence proves the effect.
- **Effect Execution Evidence**
  - Before/after evidence showing the intended effect occurred.
  - Notes on access preservation, side effects, and deviations from the rehearsal.
  - Any observed adversary response or lack of response.
- **Battle Damage Assessment**
  - Measures of performance: what your team did and whether each task completed.
  - Measures of effectiveness: what changed in adversary capability, behavior, data flow, decision-making, or access.
  - Confidence level and remaining uncertainty.
  - Recommendation for follow-on action.
- **OPERATION SHINY HAMMER Monitoring Log**
  - Where and when you monitored.
  - Detection approach used, including semantic/contextual logic.
  - Hits, near misses, and false positives.
  - Any deletion actions performed.
  - Alert timestamp, recipient, and summary if a hit occurred.
- **Five-Line Effect Report**

```text
Effect:
Action:
Predicted response:
Observed result:
Burn-risk / BDA reassessment:
```

**10-Minute Team Brief (end of Phase 3):**
Each team delivers a 10-minute execution brief (8 min + 2 min Q&A). Treat this as a formal commander's brief. Include:

- The planned effect and whether it was achieved.
- The rehearsal finding that most affected execution.
- BDA results and confidence.
- SHINY HAMMER monitoring result, including any deletion and alerting actions.
- Follow-on recommendation.

---



## Timeline

- **0800-0815** - In-brief, scenario hand-out, team formation
- **0815-1045** - Phase 1 work: mission analysis, effect selection, SOM/FSP/tasks, BDA plan, SHINY HAMMER monitoring plan
- **1045-1135** - Phase 1 team briefs (10 min each + rotation)
- **1135-1230** - Instructor feedback, lunch, and planning refinement
- **1230-1400** - Phase 2 rehearsal and pre-execution check
- **1400-1530** - Phase 3 execution, monitoring, deletion/alerting if required, and BDA collection
- **1530-1630** - Final execution briefs (10 min each + rotation)
- **1630-1700** - Hot wash / instructor debrief / collection of packets

---



## Evaluation Criteria

Instructors will assess based on:

- **Planning rigor** - Tactical analysis is updated from prior blocks and supports the selected effect.
- **Effect feasibility** - The selected effect is mission-relevant, authorized, measurable, and scoped to the redirector access.
- **Operational discipline** - The team rehearses, follows go/no-go criteria, preserves access, manages burn risk, and stays within authority.
- **Battle damage assessment** - BDA distinguishes task completion from mission effect and communicates uncertainty clearly.
- **OPERATION SHINY HAMMER handling** - Monitoring uses semantic or contextual reasoning, deletion criteria are sound, and alerting is immediate when required.
- **Evidence quality** - Claims are supported by screenshots, logs, queries, command output, workflow execution evidence, or other instructor-approved artifacts.
- **Clarity and teamwork** - Briefs are concise, commander-focused, and show visible contribution from all team members.

---



## Final Note

This is your effects assessment. Treat it like a real mission: plan carefully, rehearse honestly, execute only what is approved, protect the commander's priority information, and report what you know with confidence levels and evidence.

Questions? Ask your instructors before execution begins.
