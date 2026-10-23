## Purpose

The approved course learning objective is:

> At the end of the Counterstrike Operator Course, students will be able to plan and execute counterstrike operations in support of DCO-RA by exploiting blue-space advantage to rapidly access, assess, and apply deliberate effects against adversary infrastructure in order to deny adversary mission accomplishment in cyberspace.

Five delivery Blocks accomplish that outcome through doctrinal framing, practical tradecraft labs, constrained on-target operations, effects content, and SI/agentic workflows. This course uses Super Intelligence (SI) for the systems often called artificial intelligence (AI). Executive Order 14434 directs that wording. The systems are the same ones defined as artificial intelligence in 15 U.S.C. § 9401(3). Official TLO statements and ELO tables are included in the syllabus. The ordered activity list for each Block is that Block's overview.

## Target Audience

- Cyber Protection Team (CPT) and adjacent defensive operators
- Students who already understand baseline hunting workflows
- Teams transitioning from internal defense toward forward response actions

## Daily schedule

> **INCOMPLETE:** coarse calendar-day outline for the student syllabus. Do not paste the hourly grid here. Source for hour-by-hour placement is the Hourly schedule. The syllabus renderer must include this section.

## Terminal Learning Objectives

Five terminal learning objectives (TLOs) decompose the single course learning outcome. Enabling learning objectives (ELOs) for each TLO are in `course/requirements/tlo-elo.md` (`course/requirements/tlo-elo.md`). The syllabus product (DOCX/PDF) includes those ELO tables; do not emit a standalone TLO/ELO handout.

- **TLO 1** — At the end of the Counterstrike Operator Course, students will possess the ability to conduct military tactical planning in the context of DCO-RA.
- **TLO 2** — At the end of the Counterstrike Operator Course, students will be able to exploit opportunities from a position of advantage in blue space.
- **TLO 3** — At the end of the Counterstrike Operator Course, students will be able deny adversary ability to accomplish their mission in cyberspace.
- **TLO 4** — At the end of the Counterstrike Operator Course, students will be able to rapidly access and effect adversary infrastructure.
- **TLO 5** — At the end of the Counterstrike Operator Course, students will be able to use local inference and agentic workflows to support hunting and planning, and counter adversary agentic systems.

Enabling learning objectives stay in `course/requirements/tlo-elo.md` (`course/requirements/tlo-elo.md`). The syllabus render includes those full tables. The Course Plan of Instruction lists TLOs only.

## Grading methodology

Assigned course activities are graded on completion. Completing those assigned items is required to pass the course. Completion is a gate, not a share of the official score.

The official course grade is the individual **Capstone Assessment** score. Instructors grade it with the Module rubric (Capstone Assessment rubric (`blocks/B05-capstone/modules/B05.M01-capstone/rubric.md`); 1–4 per row). That rubric score is also evidence unit trainers may use when completing a job qualification record (JQR). The schoolhouse sets the passing cutoff; this syllabus does not publish a letter scale.

Group activities receive instructor grades for feedback only and are not weighted into the official course grade. That includes Block group assessments **Planning Group Assessment**, **On-Target Group Assessment**, and **Effects Group Assessment**.

## Prerequisites

Complete all of the following **before day 1** of the instructor-led sequence:

- **HTB Academy Prerequisites** (OSINT, Nmap, Metasploit, gaining access, and pivoting). These packages are not assigned Modules and are not on the in-residence calendar.
    
- **Both** ESET threat reports listed under Read-aheads. In-class SALUTE and FSB Center 18 drills use those reports; they are not first-pass reading time.
    

> **INCOMPLETE:** other entry requirements (clearance, tooling, schoolhouse enrollment) are not recorded in this repository.

## Read-aheads

Read **both** of these ESET reports before day 1. Do not treat them as optional or as a substitute for one another.

|Report|File students receive|
|---|---|
|ESET, _InvisiMole_|`ESET_InvisiMole.pdf`|
|ESET, _Gamaredon_ / FSB Center 18 (_Cyberespionage in the Gamaredon way_)|`cyberespionage-gamaredon-way.pdf`|

Both PDFs are posted with the syllabus. The Gamaredon paper is also the public ESET white paper at [https://web-assets.esetstatic.com/wls/en/papers/white-papers/cyberespionage-gamaredon-way.pdf](https://web-assets.esetstatic.com/wls/en/papers/white-papers/cyberespionage-gamaredon-way.pdf) when the issued file is not yet in hand.

These reads are not an assigned Module and do not have Module IDs. Do not add other threat-report titles to this list.

## Schoolhouse-specific information

> **Placeholder.** This repository does not fill local schoolhouse policy (reporting instructions, lodging, local network rules). Leave this heading in the syllabus so a schoolhouse can insert its own text.

## Course Organization

Blocks deliver the course in the order below. A Block may support more than one TLO, and TLO coverage by activity is tracked in Terminal and Enabling Learning Objectives.

|Order|Block|TLO references|Focus|
|---|---|---|---|
|1|Military Tactical Planning in Cyber Operations|TLO 1–5|Orientation; prerequisite homework; tactical planning; MITRE; SI/DGX; group assessment|
|2|Maneuvering to the Target|TLO 2, 4|Reconnaissance, open-source analysis, access, tunneling, and team maneuver|
|3|Situational Awareness in Different Operating Contexts|TLO 1, 4|On-target awareness across progressively constrained environments|
|4|Effects and Agentic Operations|TLO 1–5|Mission rehearsal, tool testing, effects, handoff, and agentic workflows|
|5|Capstone|TLO 1–5|Culminating assessment after B04|

Students progress from planning fluency, to gaining and extending access, to operating on target under constraint, to delivering and handing off effects, and finally to an integrative capstone.

### B01 Military Tactical Planning in Cyber Operations (TLO 1–5)

- Complete HTB Academy Prerequisites (OSINT, Nmap, Metasploit, gaining access, and pivoting) before the instructor-led sequence.
    
- Conduct military tactical planning in the DCO-RA context (METT-TC, DRAW-D, OCOKA-W, COG/CV, EMLCOA, scheme of maneuver).
    
- Use MITRE ATT&CK / D3FEND models and CAD to graph and sequence TTPs.
- Map military [tactical tasks](https://moodle.cso.ops/mod/resource/view.php?id=5768 "Tactical Tasks") to ATT&CK impact techniques.
- Complete the SI on-ramp and team DGX buildout.
- Produce a group tactical planning product against the shared scenario.

### B02 Maneuvering to the Target (TLO 2, 4)

- Conduct passive reconnaissance from a blue-space position of advantage.
- Identify key components of an open-source ecosystem.
- Gain access, establish tunnels, and maneuver through target infrastructure.
- Apply the access chain in team exercises.

### B03 Situational Awareness in Different Operating Contexts (TLO 1, 4)

- Establish the initial remote-host baseline before narrowing the investigation.
- Adapt survey and evidence collection to filesystem, kernel, virtualization, Windows, hybrid, resource, and state constraints.
    
- Demonstrate on-target situational awareness in the Block assessment.
    

### B04 Effects and Agentic Operations (TLO 1–5)

- Rehearse against a threat-representative environment and evaluate offensive tooling.
- Select, execute, and verify denial or deception effects.
- Track adversary activity and hand off durable effects.
- Build, reinforce, and counter agentic workflows.

### B05 Capstone (TLO 1–5)

- Integrate planning, access, assessment, and effects in a culminating exercise (ELO IDs on capstone rubric TBD).
    
- Delivered after B04 as the single capstone activity Capstone Assessment.
    

## Related documents

These documents are posted with the syllabus:

- Hourly schedule
- ESET InvisiMole
- ESET Gamaredon
- Capstone Assessment rubric

## Other interesting repos
- https://github.com/andrew-d/static-binaries
- https://github.com/TriV3/MCP-Kali-Server/blob/master/doc/mcp-htb-tutorial.md
- [AI Agent Bankrupted Their Operator While Trying to Scan DN42 - Lan Tian @ Blog](https://lantian.pub/en/article/fun/ai-agent-bankrupted-their-operator-scan-dn42lantian.lantian/)