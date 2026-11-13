---
id: B04.M05-key
title: C2 Tool Evaluation Peer Handoff — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B04
module_type: group_activity
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# C2 Tool Evaluation Peer Handoff — Instructor Answer Key

## Objective and starting context

No classic discovery walkthrough. Grade **dossier reproducibility** and **peer-execute success** using [`rubric.md`](rubric.md). Facilitation cadence lives in [`instructor-guide.md`](instructor-guide.md). Staging checklists live in [`setup-guide.md`](setup-guide.md).

Students start on the ops station, open vCenter Remote Console into the exploitation range they already built (Kali ops, chosen redirector, Windows target), and stay in their `/29` inside `172.16.45.0/24` with a ~50 GB concurrent RAM cap. Do not require a new server-and-target pair.

## Flag / reference table

| Item | Value |
| --- | --- |
| Shortlist (default) | Sliver, Mythic, Havoc, Covenant — adjust to what is legally/technically staged |
| Media | Instructor-staged share only; no live download |
| Addressing | Assigned block in `172.16.45.0/24` |
| RAM | ≤ ~50 GB concurrent; power down unused VMs |
| Validation chain | Install teamserver → build/deploy beacon → check-in → task beacon |
| Grade instruments | Dossier + peer review form + hotwash |

Record live share paths in the setup-guide table before class. Grade against those paths.

## Initial situational awareness

In-guest, before install or listener work:

```bash
hostname && whoami && pwd
date -u
id
uname -a
ss -tulpen
ip -4 addr
```

Windows:

```powershell
hostname; whoami; pwd
Get-Date -Format o
Get-NetTCPConnection | Where-Object { $_.State -in @("Listen","Established") } | Select-Object -First 20
```

Expected findings: the guest is the student's Kali ops host or Windows target, not a classmate range; no leftover listeners from a prior teamserver.

## Instructor live walkthrough

This is a documentation-and-handoff lab. The "walkthrough" is the employment chain the **author** must prove, then the **peer** must repeat from the dossier alone.

### Author self-validation (must be in the dossier)

1. Install / configure the teamserver (or framework equivalent) from the staged path on the author's Kali ops host.
2. Build / generate a beacon from the teamserver.
3. Deploy and execute the beacon on the author's Windows target. The callback must traverse that student's redirector.
4. Confirm listener / check-in.
5. Task the beacon (basic command) and record the response as the minimal validation task.

### Peer-execute sequence (sealed dossier)

1. Install / configure the teamserver from the dossier + staged path on the **reviewer's** Kali ops host.
2. Build / generate a beacon from the dossier instructions.
3. Deploy the beacon to the **reviewer's** Windows target, confirm check-in, and confirm the callback traversed the reviewer's redirector.
4. Task the beacon through the teamserver and complete the named validation task.
5. Complete the peer review form (success/fail per step; gaps found).

Do not fill missing dossier steps during execute. Environment faults (share down, pool exhausted) are instructor problems; missing prereqs are dossier defects.

## Troubleshooting / confirmation

| Issue | Resolution |
| --- | --- |
| Peer claims docs incomplete; author disagrees | Grade from reviewer evidence + whether a competent operator could succeed; require specific missing steps |
| Installer path wrong | Environment fault if share moved; else dossier defect |
| Peer lacks prerequisite skill named in dossier | If prereq was stated and reasonable, author may still score; if hidden skill required, dossier defect |
| Cross-student targeting | Stop exercise for those students; remediation before continue |
| RAM pressure | Power off unused VMs; postpone Mythic-class heavy stacks if the Kali host cannot spare the RAM |
| Share not reachable | Fix connectivity; do not authorize internet pulls |
| Listener bind conflicts | Keep services inside student `/29`; check duplicate ports on same VM |
| Peer stuck on OS basics | Point to dossier prerequisites; do not demo the C2 |

If environment breakage blocked the peer, do not penalize the author for that interval; resume scoring after restore.

## Grading checkpoints

Score the **author** primarily with PH-1–PH-4; use PH-5 as the integrated outcome check.

| Rubric | Evidence | Acceptable standard |
| --- | --- | --- |
| PH-1 | Dossier install section + peer form | Peer installed from staged media without author coaching |
| PH-2 | Employment workflow | Ordered install → beacon build/deploy → task-via-teamserver |
| PH-3 | Validation checks | Peer re-ran the named proof (tasking + response) |
| PH-4 | Limitations / footprint | Concrete limits tied to the author's test, not marketing |
| PH-5 | Peer execute | Install + beacon + tasking all completed under sealed-dossier rules |

Hotwash quality can inform Exemplary vs Acceptable on PH-4/PH-5 but does not replace peer-execute evidence.
