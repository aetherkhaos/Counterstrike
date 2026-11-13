---
id: B03.M07-key
title: On-Target Group Assessment — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B03
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

# On-Target Group Assessment — Instructor Answer Key

## Objective and starting context

Grading reference for the on-target group assessment. Facilitation and timing live in [`instructor-guide.md`](instructor-guide.md). Score with [`rubric.md`](rubric.md).

Students operate from Lunovia against the Varenskian actor. Phase 1 is tabletop plus a commander decision. Phase 2 is authorized access and survey. Do not hand destination product, credentials, or exploit steps; those come from the issued packet and live range.

## Flag / reference table

| Item | Source | Notes |
| --- | --- | --- |
| Mission | Student brief | Interdict Varenskian collection on Lunovia IOT deny/degrade intelligence collection |
| Commander’s intent | Student brief | Purpose / key tasks / end state (FM 5-0). Purpose is not the mission IOT clause |
| Specified tasks | Student brief | Options for pursuit; reconnoiter after approved access |
| Hunt notes | `supporting-documents/it-wks1-hunt-notes.md` | `it-wks-01` scheduled tasks and `Network_Share_Scripts` artifacts |
| Team size | Instructor assignment | Four preferred |
| Phase 1 | Student brief | ~3 hours + 10-minute brief |
| Phase 2 | Student brief | ~2.5–3 hours + 10-minute brief |
| Grading instrument | `rubric.md` | PL-1, PL-2, AC-1, AC-2, BR-1, TW-1 |

There is no single Hiera flag. Grade packets, briefs, and access/survey evidence.

## Initial situational awareness

### Scenario baseline (part of the assessment)

Have teams record before analysis:

```text
Friendly force: Lunovia cyber defense / supported government stakeholders.
Enemy force: Varenskian actor described in Seraph-3 materials.
Friendly terrain: Lunovia Network (physical, logical, persona).
Known problem: network compromised; intelligence bleeding.
Current authority: plan and recommend; access only after commander decision.
```

### Optional workstation baseline

Use only to troubleshoot document access (`date`, `hostname`, `whoami`, `pwd`, `ss`/`Get-NetTCPConnection`). Do not grade it.

### Hunt-note artifacts students should already have

From [`supporting-documents/it-wks1-hunt-notes.md`](supporting-documents/it-wks1-hunt-notes.md) on `it-wks-01`:

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

| Rubric | Evidence to inspect | Acceptable standard |
| --- | --- | --- |
| PL-1 | Phase 1 packet | METT-TC with restated mission and intent, EMLCOA, CG/CV, exploitation plan, SOM, FSP, tasks with evidence |
| PL-2 | Mapping table + CAD | ATT&CK paired to D3FEND/ENGAGE; CAD meets brief minimum |
| AC-1 | Phase 1 brief + observation | Concrete options; wait for commander decision |
| AC-2 | Phase 2 packet, shells/screenshots, updated SOM | Authorized access, terrain survey, plan updated |
| BR-1 | Both 10-minute briefs | Commander-focused, evidence-backed, shared across teammates |
| TW-1 | Observation, Q&A, contribution note | Each student has a visible role |

There is no single required plan. Award credit for defensible, evidence-based arguments that respect authority and the wait-for-decision rule.
