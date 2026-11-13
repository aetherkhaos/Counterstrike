---
id: B01.M36-key
title: Planning Group Assessment — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B01
module_type: assessment
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Planning Group Assessment — Instructor Answer Key

## Objective and starting context

Use this as the grading reference and expected-product walkthrough. Facilitation, timing, and stalls live in [`instructor-guide.md`](instructor-guide.md). The goal is not to force every team into one identical answer. The goal is to verify that students can reason from mission, enemy, terrain, evidence, and doctrine into a disciplined commander-ready plan.

Instructor note: This requires live infrastructure for classroom operations only. Student outputs are planning artifacts, CAD products, and commander briefs. There is no live target.

## Flag / reference table

| Reference item | Hiera key / source | Default / expected value | Notes |
| --- | --- | --- | --- |
| Assessment type | Not applicable - tabletop assessment | No live target or Puppet-managed flag | There are no Hiera tunables for this assessment package. |
| Mission statement | Student brief and instructor in-brief | Interdict Varenskian collection on Lunovia IOT deny/degrade intelligence collection | Students may paraphrase if task and purpose remain intact. |
| Commander’s intent | Student brief | Purpose / key tasks / end state. Purpose is not the mission IOT clause | Planning only; no live access |
| Threat actor sheet | `supporting-documents/L1.8 Threat Actor Intelligence Sheet - Amber Tide.md` | Amber Tide intelligence sheet | Exercise-specific student input. |
| Network map | `supporting-documents/L1.8 Lunovia Network Map.png` | Lunovia assessment network map | Exercise-specific student input. |
| Team size | Instructor assignment | Four students preferred | Three or five students are acceptable. |
| Phase 1 duration | Student brief | Approximately 3 hours | Protect briefing time. |
| Phase 2 duration | Student brief | Approximately 2.5-3 hours | Include CAD and execution products. |
| Grading instrument | `L1.8 Blank Student Rubric.md` | 15 observable rows | Fill one rubric per student or per LMS record. |

## Initial situational awareness

Because this is a tabletop assessment, the baseline is split into a scenario baseline and an optional classroom workstation baseline. The scenario baseline is part of the assessment. The workstation baseline is only for troubleshooting student access to documents.

### 2.1 Scenario Baseline

Have teams record these baseline facts before analysis begins:

```text
Friendly force: Lunovia cyber defense and supported government stakeholders.
Enemy force: Varenskian nation-state cyber actor described in the threat intelligence sheet.
Friendly terrain: Lunovia Network, including physical, logical, and persona-layer terrain shown in the network map.
Known problem: The network is compromised and adversary collection is ongoing or recently active.
Friendly mission: Deny or degrade adversary intelligence collection while preserving freedom of maneuver and pursuit options.
Current authority: Plan and recommend options; do not execute live actions during the assessment.
Required products: Phase 1 planning packet, Phase 2 execution products, CAD graph, commander briefs, and team contribution note.
```

Why this matters: students should begin by establishing who is friendly, who is enemy, what terrain matters, what authority exists, and what products are required. This replaces tool-first behavior with operational orientation.

### 2.2 Optional Classroom Workstation Baseline

If teams use a Linux or Windows workstation to write the packet, instructors may have them capture local context for troubleshooting file access only.

Linux/macOS:

```bash
date -Is
hostname
whoami
pwd
uname -a
id
w
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head
ss -tulpen 2>/dev/null | head -40
```

Windows PowerShell:

```powershell
Get-Date -Format o
hostname
whoami
Get-Location
$PSVersionTable
[System.Environment]::OSVersion.VersionString
query user
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 ProcessName, Id, CPU
Get-NetTCPConnection | Where-Object { $_.State -in @("Listen","Established") } | Select-Object -First 30 LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess
Get-NetUDPEndpoint | Select-Object -First 30 LocalAddress, LocalPort, OwningProcess
```

Expected finding: local host output varies by classroom. Do not grade these commands. They only prove the student can identify time, host, user/session context, shell/runtime context, active users, processes, and sockets if workstation troubleshooting is needed.

## Instructor live walkthrough

Expected Phase 1 and Phase 2 products. Run the classroom flow from the instructor guide; use the samples below while circulating and grading.

### 6.2 Phase 1 Work: METT-TC to CV (Approximately 3 hours)

Strong Phase 1 packets usually include:

- Mission analysis that restates the issued mission and commander’s intent (purpose, key tasks, end state) without copying the mission IOT as intent purpose.
- Enemy analysis that uses SALUTE for structured facts and DRAW-D for likely enemy choices on contact.
- Friendly OCOKA-W that identifies defender visibility, logs, authorities, support relationships, and service-continuity limits.
- Enemy OCOKA-W that explains how the adversary observes, hides, moves, collects, stages, and exits.
- Time and logistics analysis that addresses adversary tempo against friendly decision cycles.
- Civil considerations tied to government services, public trust, and the operational cost of disruption.
- EMLCOA that states enemy mission, current activity, and likely adaptation if pressured.
- CG/CV pair that is specific enough to shape the exploitation plan.

Acceptable EMLCOA range:

```text
The Varenskian actor is conducting intelligence collection against Lunovian government networks by using observed access, tooling, and infrastructure to locate and move mission-relevant information before defenders can convert detection into action. On contact, the actor is likely to shift infrastructure, reattempt access, accelerate collection, or reinforce access through alternate paths rather than abandon the mission immediately.
```

Acceptable CG statements include:

- The adversary's ability to maintain collection tempo across selected user personas, document stores, and outbound paths.
- The combination of access, staging, and egress that lets the actor move intelligence before defenders act.
- The actor's repeated access to mission-relevant terrain and the decision cycle that keeps collection ahead of response.

Acceptable CV statements include:

- Reliance on observable access, staging, or egress behavior that defenders can correlate faster than the adversary can adapt.
- Dependence on specific user personas or document repositories that can be monitored, constrained, or shaped.
- Dependence on infrastructure, timing, or behavior patterns that enable engagement or deception without immediately spooking the actor.

### 6.4 Phase 2 Work: Exploitation Plan to Tasks (Approximately 2.5-3 hours)

Strong Phase 2 packets usually include:

- ATT&CK mapping that begins from scenario behavior, not from technique memorization.
- D3FEND and ENGAGE options paired to each major behavior or behavior cluster.
- Clear option statements that include goal, expected effect on the CV, risk, authority, and evidence requirement.
- CAD graph with an adversary Agent node, two to three Attack nodes, at least one Artifact, at least one Condition, and one or more Countermeasures.
- Scheme of maneuver that phases observation, shaping, denial/degradation, pursuit enablement, and handoff.
- Fire support plan covering forensics, malware analysis, infrastructure, legal/authority, intelligence, communications, and partner coordination where relevant.
- Role-based tasks with "in order to" purpose statements, measures of performance/effectiveness, and supervision plan.

Acceptable option logic:

```text
If the CV is adversary dependence on observable staging and egress behavior, then an acceptable plan should prioritize evidence correlation, monitoring or shaping of staging paths, egress visibility, and options that expose, affect, or elicit adversary behavior before selecting a disruptive containment action.
```

Instructor teaching point: D3FEND and ENGAGE are planning vocabularies. They should not appear as isolated labels without explanation of how the option affects the CG/CV.

## Value provenance

| Value | How students know it | Why it matters |
| --- | --- | --- |
| Lunovia Network | L1.8 network map | Establishes friendly terrain and defended mission space. |
| Varenskian adversary | L1.8 threat actor intelligence sheet | Establishes enemy context for SALUTE, DRAW-D, EMLCOA, and actions on contact. |
| Intelligence collection problem | Mission statement and threat intelligence | Drives the "stop the bleeding" planning frame. |
| Physical, logical, and persona layers | Network map and Week 1 doctrine | Prevents terrain analysis from stopping at host names. |
| ATT&CK behavior mapping | Threat intelligence and observed TTPs | Keeps D3FEND and ENGAGE options tied to behavior. |
| D3FEND and ENGAGE pairings | Week 1 framework lessons | Converts behavior into defensible commander options. |
| CAD graph minimum | Student brief | Ensures graph products contain enough structure to support the plan. |
| Authority and risk constraints | Mission framing and handling rules | Prevents premature disruptive action or adversary tip-off. |
| Team contribution note | Student brief deliverables | Supports individual grading inside a group assessment. |

## Evidence reference

| Product evidence | Where to check | Expected value / behavior |
| --- | --- | --- |
| Mission analysis | Phase 1 packet | Issued mission and intent restated separately; explicit/implied tasks, constraints, and purpose are separated. |
| SALUTE and DRAW-D | Phase 1 worksheets | Claims are tied to threat intelligence and scenario evidence. |
| Friendly and enemy OCOKA-W | Phase 1 worksheets | Terrain includes physical, logical, and persona-layer considerations. |
| EMLCOA | Phase 1 packet and brief | Enemy mission, current activity, and actions on contact are coherent. |
| CG/CV | Phase 1 packet and brief | The CV is specific enough to shape later options. |
| ATT&CK mapping | Phase 2 packet | Techniques or behavior clusters trace back to observed adversary behavior. |
| D3FEND/ENGAGE pairings | Phase 2 packet | Options include goal, effect, authority, risk, and evidence requirement. |
| CAD graph | Phase 2 packet or visual aid | Graph includes required node types, typed edges, and provenance. |
| SOM/FSP/tasks | Phase 2 packet | Actions are phased, supported, deconflicted, and assigned with purpose. |
| Team contribution note | Final packet | Each student has a visible contribution that can be checked against observation. |

## Troubleshooting / confirmation

Classroom stall prompts live in the instructor guide. For grading, confirm the packet contains the evidence rows in **Evidence reference** and the rubric mapping below.

## Grading checkpoints

Use `L1.8 Blank Student Rubric.md` as the primary grading instrument. The table below maps answer-key evidence to rubric rows so grading remains observable.

| Rubric rows | Gradeable area | Evidence to inspect | Acceptable standard |
| --- | --- | --- | --- |
| AR-1 to AR-3 | Analytical rigor | Phase 1 packet and brief | Doctrine is applied with evidence, uncertainty, and coherent CG/CV reasoning. |
| FI-1 to FI-3 | Framework integration | Phase 2 packet, mapping table, CAD graph | ATT&CK, D3FEND, ENGAGE, and CAD are accurate enough to support the plan. |
| FD-1 to FD-3 | Feasibility and discipline | Option statements, SOM, FSP | Options respect authority, risk, operational safety, and adversary reaction. |
| CP-1 to CP-3 | Clarity and professionalism | Briefs and final packet | Products are concise, visual, commander-focused, and handoff-ready. |
| TW-1 to TW-3 | Teamwork | Observation, Q&A, contribution note | Each student contributes visibly and helps the team adapt under time pressure. |

Suggested weighting if the LMS requires a numeric grade:

- Analytical rigor: 25%.
- Framework integration: 25%.
- Feasibility and discipline: 20%.
- Clarity and professionalism: 15%.
- Teamwork: 15%.

## Acceptable student answers

There is no single required final plan. Award credit when teams make defensible, evidence-based arguments that respect the scenario and Week 1 doctrine.

Strong analytical answers:

- Separate evidence, assessment, assumptions, and RFIs.
- Explain why the adversary mission is intelligence collection rather than defaulting to generic disruption.
- Treat physical, logical, and persona terrain as operationally meaningful.
- Make CG/CV statements specific enough to guide action.

Strong framework answers:

- Map behavior to ATT&CK before selecting D3FEND or ENGAGE options.
- Explain the purpose and expected effect of each D3FEND/ENGAGE pairing.
- Use CAD to show relationships among agent, action, artifact, condition, and countermeasure.
- Preserve provenance instead of drawing unsupported graph edges.

Strong execution answers:

- Phase the plan so observation, shaping, denial/degradation, pursuit, and handoff are coherent.
- Identify support requirements and deconfliction points.
- State authority and risk before recommending actions that could reveal defender awareness.
- Assign role-based tasks with purpose and measures.
