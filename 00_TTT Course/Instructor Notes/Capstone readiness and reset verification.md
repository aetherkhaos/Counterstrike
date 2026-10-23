# Capstone readiness and reset verification

Range implementation lives in PCTE and any environment-owned runbooks. Stack identity is the `capstone` row in [`pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765). Facilitation and safety (including red-net approval) stay in `blocks/B05-capstone/modules/B05.M01-capstone/instructor-guide.md` (`blocks/B05-capstone/modules/B05.M01-capstone/instructor-guide.md`). Live addresses come from the instructor / range card, not this file.

Do not invent host lists, IPs, or PCTE click-paths that are not in those sources. Sibling inventory of supporting sources is [#96](https://code.levelup.cce.af.mil/counterstrike-operations-development/counterstrike-ops-course-content/-/work_items/96).

## Stack identity (do not duplicate)

From the PCTE registry and Bill of Deliverables roll-up:

|Field|Value|
|---|---|
|Stack ID|`capstone`|
|Activity|structured_content|
|Netspec|`ACTEC_DCORA_CAPSTONE_NET`|
|Clone source|`ACTEC_DCORA_CAPSTONE_GOLD_v2.4`|
|SCM / SCP|`ACTEC_CSO_Capstone`|
|Assigned Module|Capstone Assessment|
|Scheduled window|Week 4 Monday–Friday (Bill of Deliverables SCP row)|

`B05.M01` `module.yaml` cites `pcte.stack_refs: capstone` as required. Setup and verification stay **not Module-local** so this course doc is the pointer, not a second copy of PCTE procedure.

## Pre-delivery readiness

Complete these checks **before** students start Phase 1. Record evidence on the range card or instructor packet.

|Check|Pass evidence|Owner|
|---|---|---|
|Gold image is the registry clone source|PCTE instance cloned from `ACTEC_DCORA_CAPSTONE_GOLD_v2.4` on `ACTEC_DCORA_CAPSTONE_NET`|Range engineer (PCTE)|
|Structured content objects match the registry|SCM/SCP `ACTEC_CSO_Capstone` present on the assigned ENT/EP|Range engineer (PCTE)|
|Students and instructors can reach the assigned range|Login and topology match the **issued range card** (instructor guide: live addressing from the instructor / range card)|Instructor + range engineer|
|Student packet is issued|Capstone student brief and Module supporting documents available; Threat Hunting Report named in the brief|Instructor|
|Safety contract is briefed|Red-net / deep effects require instructor approval (instructor guide Safety and ROE)|Instructor|
|Range-control no-strike list is in force|`pcte-student-disclaimer.md` (`course/operations/pcte-student-disclaimer.md`) applied to PCTE student products|Instructor / assemble pipeline|

Do **not** treat a successful ping of an undocumented IP as a substitute for the range card. Do not run student exploitation as a readiness proof.

## Reset / re-run (instructors)

Use these checks when a class iteration ends, a team must start clean, or Phase 4 returns access on the differentiated path.

|Check|Pass evidence|Owner|
|---|---|---|
|Return to gold|Re-clone or restore from `ACTEC_DCORA_CAPSTONE_GOLD_v2.4` using PCTE (not a Module-local script in this repo)|Range engineer|
|Student persistence is gone|Post-restore, student-added persistence, C2, and planted files from the prior run are not present on the restored gold|Range engineer + instructor spot-check|
|Differentiated-path reentry|If returning access in Phase 4, instructor provides the initial access method (instructor guide); students still document reentry on the Access Guide|Instructor|
|Unapproved red-net effects|Stop the team and restore to the approval state (instructor guide common stalls)|Instructor|
|Next iteration ready|Pre-delivery table above passes again before the next cohort|Range engineer + instructor|

This repository has **no** capstone compose/Puppet reset under `environments/`. Do not add one here. If a later environment repo publishes a reset command, link it from this file instead of copying it.

## Student-path smoke (non-spoiler)

Confirm only that students can open the brief, reach the assigned greyspace entry on the range card, and that Phase 1 recon is possible. Do not execute answer-key exploit paths as a smoke test.

## Related artifacts

- PCTE registry: [`pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Bill of Deliverables SCP row: [`../requirements/bill-of-deliverables.md`](https://moodle.cso.ops/mod/page/view.php?id=5759)
- Capstone instructor guide: `../../blocks/B05-capstone/modules/B05.M01-capstone/instructor-guide.md` (`blocks/B05-capstone/modules/B05.M01-capstone/instructor-guide.md`)
- Capstone student brief: `../../blocks/B05-capstone/modules/B05.M01-capstone/student-brief.md` (`blocks/B05-capstone/modules/B05.M01-capstone/student-brief.md`)
- Capstone `module.yaml` `pcte.stack_refs`