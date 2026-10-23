### **On-Target Group Assessment: Enumeration, Gaining Access, and Situational Awareness Exercise**

**Date:** 4JUNE26 **Duration:** Full training day (approximately 6–7 hours of work + two 10-minute team briefs) **Audience:** CounterStrike Operators (teams of 4) **Objective:** Validate your mastery of the **full military tactical planning process** (METT-TC → EMLCOA → CG/CV/Exp. Plan → SOM → FSP → TASKS), then **enumeration, initial access, and situational awareness** against a defended network. Issued **mission** and **commander’s intent** are separate statements below. Restate both in Phase 1; do not copy the mission “IOT” as intent purpose.

You will use **all** of the military tactical planning frameworks ([tactical tasks](https://moodle.cso.ops/mod/resource/view.php?id=5768 "Tactical Tasks"), SALUTE/DRAW-D/OCOKA-W, EMLCOA, CG/CV analysis, MITRE ATT&CK, MITRE D3FEND, MITRE ENGAGE, and D3FEND CAD where appropriate). After the commander approves an access vector, **enumerate, exploit, and gain situational awareness on** authorized adversary infrastructure and update your plan accordingly.

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

**Time allotted:** ~3 hours (including analysis and prep) **Deliverable:** Completed brief covering the entire input side of the planning process. Produce **one consolidated team brief** that includes:

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
    - Specific [tactical tasks](https://moodle.cso.ops/mod/resource/view.php?id=5768 "Tactical Tasks") (with purpose “in order to…” statements) assigned to each team member/role.
    - Reference the tactical task handout from Block 1 where applicable.
    - Include measures of performance/effectiveness and supervision plan.
- **Include the specific MITRE ATT&CK T-Codes utilized to:**
    - Conduct Reconnaissance
    - Develop any resources

**Output format:** Use the Tactical Planning Process student handout templates. Be specific, evidence-based, and honest about assumptions/RFIs.

**10-Minute Team Brief (end of Phase 1):** Each team will deliver a **10-minute back-brief** (8 min presentation + 2 min Q&A) to the instructor cadre and the class. Focus on:

- Your exploitation plan. **Do not speak in vague platitudes.** Provide concrete technical details (with evidence) about any plans to gain initial access.
- Key assumptions and RFIs

## **Goal of brief:** Provide the Commander with options before you move into phase 2 and gaining access to adversary infrastructure.

### **Phase 2: Complete the Planning, Gain Access, Gain Situational Awareness**

**Time allotted:** ~2.5–3 hours **Deliverable:** Commander-ready execution products. Add to your Phase 1 brief:

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

**10-Minute Team Brief (end of Phase 2):** Each team delivers a **10-minute execution brief** (8 min + 2 min Q&A). Treat this as a formal commander’s brief. Include:

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

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

### Grading summary

|   |   |
|---|---|
|Hidden from students|Yes|
|Participants|21|
|Submitted|0|
|Needs grading|0|

### Submission status

|   |   |
|---|---|
|Attempt number|This is attempt 1.|
|Submission status|No submissions have been made yet|
|Grading status|Not graded|

#### Grading criteria

|   |   |
|---|---|
Rubric
|PL-1 (Weight: planning completeness). Did the Phase 1 packet include METT-TC (with restated mission and commander’s intent), EMLCOA, CG/CV, exploitation plan, SOM, FSP, and tasks with evidence?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Major products missing or generic platitudes. Score: 1<br><br>1 points\|Most products present but weakly evidenced or incomplete. Score: 2<br><br>2 points\|Complete packet the commander can use; some RFIs remain. Score: 3<br><br>3 points\|Specific, evidence-based packet with honest assumptions/RFIs; mission and intent restated separately (purpose, key tasks, end state). Score: 4<br><br>4 points\||
|PL-2 (Weight: framework integration). Did the team map ATT&CK techniques to paired D3FEND/ENGAGE options and produce a usable CAD graph?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|No mapping or CAD; frameworks named without application. Score: 1<br><br>1 points\|Partial mapping; CAD missing required node types. Score: 2<br><br>2 points\|Navigator-linked mapping plus a CAD that meets the brief minimum. Score: 3<br><br>3 points\|Clustered techniques, option risk/authority stated, CAD with provenance and typed edges. Score: 4<br><br>4 points\||
|AC-1 (Weight: access decision). Did the team brief concrete initial-access options and wait for commander decision before attempting access?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Vague access talk, or access attempted before approval. Score: 1<br><br>1 points\|Options listed without technical detail or evidence. Score: 2<br><br>2 points\|Decision point briefed with enough technical detail to approve or redirect. Score: 3<br><br>3 points\|Concrete vectors with evidence, risk, and a clear wait-for-decision. Score: 4<br><br>4 points\||
|AC-2 (Weight: access and survey). Did Phase 2 show authorized access, reconnoiter of adversary terrain, and updated planning products?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|No access evidence or survey; plan not updated. Score: 1<br><br>1 points\|Access claimed with thin survey or stale planning. Score: 2<br><br>2 points\|Access plus terrain survey that updates SOM/tasks. Score: 3<br><br>3 points\|Access, survey, and planning updates that change commander options. Score: 4<br><br>4 points\||
|BR-1 (Weight: briefs). Did both 10-minute briefs stay commander-focused, evidence-backed, and shared across teammates?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Brief missing, unsupported, or one-person dump. Score: 1<br><br>1 points\|Disorganized or too tool-centric for the commander. Score: 2<br><br>2 points\|Clear, mostly complete briefs with visible team roles. Score: 3<br><br>3 points\|Concise, evidence-backed briefs from multiple members; Q&A handled. Score: 4<br><br>4 points\||
|TW-1 (Weight: individual contribution). Was each student’s contribution observable in products, brief, or Q&A?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|No observable individual work. Score: 1<br><br>1 points\|Contribution inferred but not attributable. Score: 2<br><br>2 points\|Each student has a visible role and product trace. Score: 3<br><br>3 points\|Roles, products, and Q&A show distinct, accountable contribution. Score: 4<br><br>4 points\||

Rubric options

Sort order for levels:Ascending by number of points

Calculate grade having a minimum score of the minimum achievable grade for the rubric

Allow users to preview rubric (otherwise it will only be displayed after grading)

Display rubric description during evaluation

Display rubric description to those being graded

Display points for each level during evaluation

Display points for each level to those being graded

Allow grader to add text remarks for each criterion

Show remarks to those being graded

# On-Target Group Assessment — Instructor Answer Key

## Objective and starting context

Grading reference for the on-target group assessment. Facilitation and timing live in B03.M07 instructor materials in Lesson Plans and Instructor Slides.zip. Score with [`rubric.md`](https://moodle.cso.ops/mod/assign/view.php?id=5705).

Students operate from Lunovia against the Varenskian actor. Phase 1 is tabletop plus a commander decision. Phase 2 is authorized access and survey. Do not hand destination product, credentials, or exploit steps; those come from the issued packet and live range.

## Flag / reference table

|Item|Source|Notes|
|---|---|---|
|Mission|Student brief|Interdict Varenskian collection on Lunovia IOT deny/degrade intelligence collection|
|Commander’s intent|Student brief|Purpose / key tasks / end state (FM 5-0). Purpose is not the mission IOT clause|
|Specified tasks|Student brief|Options for pursuit; reconnoiter after approved access|
|Hunt notes|`supporting-documents/it-wks1-hunt-notes.md`|`it-wks-01` scheduled tasks and `Network_Share_Scripts` artifacts|
|Team size|Instructor assignment|Four preferred|
|Phase 1|Student brief|~3 hours + 10-minute brief|
|Phase 2|Student brief|~2.5–3 hours + 10-minute brief|
|Grading instrument|`rubric.md`|PL-1, PL-2, AC-1, AC-2, BR-1, TW-1|

There is no single Hiera flag. Grade packets, briefs, and access/survey evidence.

## Initial situational awareness

### Scenario baseline (part of the assessment)

Have teams record before analysis:

```
Friendly force: Lunovia cyber defense / supported government stakeholders.
Enemy force: Varenskian actor described in Seraph-3 materials.
Friendly terrain: Lunovia Network (physical, logical, persona).
Known problem: network compromised; intelligence bleeding.
Current authority: plan and recommend; access only after commander decision.
```

### Optional workstation baseline

Use only to troubleshoot document access (`date`, `hostname`, `whoami`, `pwd`, `ss`/`Get-NetTCPConnection`). Do not grade it.

### Hunt-note artifacts students should already have

From [`supporting-documents/it-wks1-hunt-notes.md`](https://moodle.cso.ops/mod/page/view.php?id=5707) on `it-wks-01`:

- Scheduled task `\Windows Module Analysis Cache` → `Invoke-WuModule.ps1`
- Scheduled task `\Network_Share_Connection_test`
- `C:\windows\System32\Network_Share_Scripts\` (`lastrun.txt`, `Network_setup.exe`, `Network_Share_login.b64`, `Network_Share_Setup.ps1`, `ticket.kirbi`)

Treat these as **starting evidence**, not the Phase 2 answer. Access vectors must still be briefed and approved.

## Instructor live walkthrough

No single exploit path is required. Expected instructor flow:

1. Confirm scenario baseline and packet templates.
2. During Phase 1, look for evidence-tied SALUTE/DRAW-D/OCOKA-W, a coherent EMLCOA, a specific CG/CV, ATT&CK mapping **before** D3FEND/ENGAGE, and a CAD that meets the brief minimum (Agent + 2–3 Attack + Artifact + Condition + Countermeasure).
3. At the Phase 1 brief, require **concrete technical** initial-access options with evidence. Approve or redirect. Record the authorized vector (AC-1).
4. During Phase 2, confirm the team used the approved vector, produced survey evidence, named ATT&CK T-codes they actually used, and **updated** SOM/tasks.
5. At the Phase 2 brief, require a graphical depiction and an AAR that a commander could use.

### Acceptable Phase 1 access-decision quality

- Strong: named vector, evidence source, risk, and an explicit wait-for-decision.
- Acceptable: enough technical detail to approve or redirect.
- Fail: vague access talk, or access attempted before approval.

## Troubleshooting / confirmation

- Teams stall on attribution: require a cite from the intel sheet plus confidence; caveated answers beat unsupported certainty.
- Teams jump to D3FEND: require the ATT&CK behavior row first.
- Teams start exploiting during Phase 1: stop; score AC-1 Poor if they ignore the stop.
- Access claimed with no survey: AC-2 cannot exceed Marginal.
- One-person brief: BR-1/TW-1 cannot reach Exemplary.

## Grading checkpoints

|Rubric|Evidence to inspect|Acceptable standard|
|---|---|---|
|PL-1|Phase 1 packet|METT-TC with restated mission and intent, EMLCOA, CG/CV, exploitation plan, SOM, FSP, tasks with evidence|
|PL-2|Mapping table + CAD|ATT&CK paired to D3FEND/ENGAGE; CAD meets brief minimum|
|AC-1|Phase 1 brief + observation|Concrete options; wait for commander decision|
|AC-2|Phase 2 packet, shells/screenshots, updated SOM|Authorized access, terrain survey, plan updated|
|BR-1|Both 10-minute briefs|Commander-focused, evidence-backed, shared across teammates|
|TW-1|Observation, Q&A, contribution note|Each student has a visible role|

There is no single required plan. Award credit for defensible, evidence-based arguments that respect authority and the wait-for-decision rule.

# Morey Intel

## it-wks-01

- Scheduled Task named: `\Windows Module Analysis Cache` that runs `Invoke-WuModule.ps1`
- Scheduled Task named: `\Network_Share_Connection_test`
- `C:\windows\System32\Network_Share_Scripts`
    - `lastrun.txt`
    - `Network_setup.exe`
    - `Network_Share_login.b64`
    - `Network_Share_Setup.ps1`
    - `ticket.kirbi`