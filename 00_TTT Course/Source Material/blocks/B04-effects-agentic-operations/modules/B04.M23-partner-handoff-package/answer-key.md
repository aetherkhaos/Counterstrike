---
id: B04.M23-key
title: Partner Handoff Package — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Partner Handoff Package — Instructor Answer Key

## Objective and starting context

Students produce a `handoff` package on the live harvest cell after break/poison work, and **stage one C2 beacon** on a host they already hold. Other effects stay under consideration; **execution is on hold**. No partner RAT deploy and no course-supplied beacon. A live check-in is not required and is not a fail. Grade package completeness, access accuracy, beacon host rationale, a partner-usable beacon kit, and back-brief. Do not require sync-node login. Do not pick the beacon host.

Issued defaults (same cell as prior harvest sessions):

| Item | Default |
| --- | --- |
| Intake SSH | `relay@172.16.2.10:2222`, Moodle `access_key` |
| Leftover exec (discoverable) | `admin` / `relayadmin` on `:8080` (not in brief) |
| Windows indexer (issued) | `svc.harvest` / `Harvest!Relay01` @ `172.16.4.20` |
| Out of scope | sync-node login; new effect execution without verbal go; a second implant; a required callback |

## Initial situational awareness

Students should re-enter claimed seats and prove identity before writing the package:

```bash
ssh -i access_key -p 2222 relay@172.16.2.10
hostname && whoami && pwd
```

```powershell
# on 172.16.4.20 when claimed
hostname; whoami; pwd
```

**Expected:** `relay` on intake; `svc.harvest` (or previously earned SYSTEM-equivalent) on indexer if claimed.

## Six-section grading checklist

| Section | Acceptable | Fail cues |
| --- | --- | --- |
| Target identity | Names reachable hosts/roles/IPs they can prove (`172.16.2.10`, and `172.16.4.20` if held) | Vague "the harvest box"; unpublished actor IPs as graded seats |
| Access story | Key file, port, user, optional leftover discovery path if used; partner can replay | "SSH in"; missing port/key; credentials they never held |
| Current posture | What break/poison (or other) actions are still live; footholds intact or burned; beacon staged only or already running | Empty posture; invents effects not run; silent on whether the beacon is running |
| Adversary tempo | Cadence / movement evidence (staging ticks, outbox cadence) from observation | No time/evidence basis |
| Partner tasking | Recommended next effects **deferred** under hold, with rationale tied to APT motive / cell | Tasking that implies they already executed today |
| Rollback plan | Concrete reverse steps for live changes, beacon removal, and seat restore | "Ask instructor" with no technical rollback |
| Beacon host | One host they already hold and can prove (`172.16.2.10`, `172.16.4.20`, or another earned seat), with a reason tied to that host's role, reach, user context, or place in the collection path | "Because I could"; a host they cannot re-enter; more than one beacon; instructor-chosen host |
| Beacon kit | Binary, config, listener or callback, on-host path, account, start steps, tasking steps, and removal — enough for a cold partner to use the file they left behind. Staged-only is acceptable if start and task steps are present. If they started it, current posture says it is live. Do not fail a missing check-in | Missing binary or config; tasking steps a partner cannot run; no removal |

## Acceptable session outcomes

- Package complete before back-brief, including one staged beacon and a partner-usable kit.
- No new effect execution beyond that one staged beacon (unless instructor gave an explicit go — document that exception). Starting the beacon is optional; do not require or fail a missing callback.
- Claimed seats still authenticate after documentation.
- Five-line report names `handoff`.
- Five-minute back-brief hits all six sections and the beacon handoff without verbatim read-through.

## Troubleshooting / confirmation

| Symptom | Check |
| --- | --- |
| SSH fails | Moodle key vs host `authorized_keys`; port `2222`; `chmod 600` |
| Windows login fails | Password in brief; WinRM/OpenSSH; cell not reset unexpectedly |
| Team wants to deploy a partner RAT or a second implant | One student-generated beacon, staged by them, on a host they already hold. Do not run the M11 partner-RAT path |
| Team asks which box to use | Any held, provable seat with a specific rationale. There is no single correct host. Do not pick it |
| Team has no callback | Acceptable. Grade the kit (start, task, remove), not a check-in |
| Team asks for actor hop | Out of scope; package judges success |

## Grading checkpoints

| Deliverable | Acceptable |
| --- | --- |
| Handoff package | All six sections; cold-partner usable, including beacon removal |
| Staged beacon | One file left on a justified host they already hold |
| Beacon kit | Binary, config, listener or callback, path, account, start, task, and removal. Missing check-in is not a fail |
| Access confirmation | Proof of re-entry for each claimed seat |
| Five-line report | Names `handoff`; partner + adversary predicted response |
| Back-brief | Six sections plus beacon host and kit in ~5 minutes |
| Discipline | No unauthorized effect execution; no second implant; no graded sync-node shell |
