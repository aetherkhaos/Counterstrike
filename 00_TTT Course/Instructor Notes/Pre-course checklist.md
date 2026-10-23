Range support is the primary audience. Instructors use the same list. Each step lists who does it, when it applies, and the repo path for the procedure. Team DGX provisioning is tracked on #161.

## Live Action Events

One step per live-action stack that an assigned Module still references. Removing the stack, or removing every Module reference, removes the step on the next regenerate.

- Deploy a Live Action Event for `dcora-live-action` (DCORA live-action range)
    
    - **Who:** range support
    - **When:** Required for `B01.M36`, `B03.M07`, `B04.M19`.
    - **Procedure:** Display name: DCORA live-action range. Activity: live_action. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_DCORA_NET. Clone source: ACTEC_DCORA_CONTENT_GOLD. Modules: `B01.M36`, `B03.M07`, `B04.M19`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Deploy a Live Action Event for `classroom-shared` (Shared classroom live-action range)
    
    - **Who:** range support
    - **When:** Required for `B02.M04`, `B03.M08`.
    - **Procedure:** Display name: Shared classroom live-action range. Activity: live_action. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_CSO_CLASSROOM_SHARED_NS. Clone source: ACTEC_CSO_CLASSROOM_SHARED_CS_2.0. Modules: `B02.M04`, `B03.M08`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Deploy a Live Action Event for `b02-web-to-sql` (B02.M16 Web-to-SQL live-action range)
    
    - **Who:** range support
    - **When:** Required for `B02.M16`.
    - **Procedure:** Display name: B02.M16 Web-to-SQL live-action range. Activity: live_action. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_Web_to_SQL. Clone source: ACTEC_CSO_Web_to_SQL_CS_1.0.1. Modules: `B02.M16`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)

## Structured Content Events

One step per structured-content stack that an assigned Module still references and that has a Structured Content Plan.

- Create a Structured Content Event from `city-vulnhub` (B02 city / VulnHub targets)
    
    - **Who:** range support
    - **When:** Required for `B02.M04`, `B02.M05`, `B02.M06`, `B02.M07`, `B02.M08`, `B02.M09`, `B02.M10`, `B02.M11`, `B02.M12`, `B02.M13`, `B02.M14`.
    - **Procedure:** Display name: B02 city / VulnHub targets. Activity: structured_content. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_Counterstrike_Vulnhub_Targets. Clone source: ACTEC_CS_Ops_Vulnhub_Targets_CS_V2.0. Structured Content Plan: ACTEC Counterstrike Operations Module 2 Targets. Modules: `B02.M04`, `B02.M05`, `B02.M06`, `B02.M07`, `B02.M08`, `B02.M09`, `B02.M10`, `B02.M11`, `B02.M12`, `B02.M13`, `B02.M14`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Create a Structured Content Event from `week3-constrained` (B03 constrained-target and SquidLab range)
    
    - **Who:** range support
    - **When:** Required for `B03.M02`, `B03.M03`, `B03.M04`, `B03.M05`, `B03.M06`, `B03.M08`.
    - **Procedure:** Display name: B03 constrained-target and SquidLab range. Activity: structured_content. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC-CS_Ops_Week3. Clone source: ACTEC_CS_Ops_Wk3_CS1.4. Structured Content Plan: ACTEC Counterstrike Ops Module 3. Modules: `B03.M02`, `B03.M03`, `B03.M04`, `B03.M05`, `B03.M06`, `B03.M08`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Create a Structured Content Event from `week4-effects` (B04 effects (Mod4.1))
    
    - **Who:** range support
    - **When:** Required for `B04.M25`.
    - **Procedure:** Display name: B04 effects (Mod4.1). Activity: structured_content. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_Impact&Effect. Clone source: ACTEC_CSO_BLOCK4.1_IMPACT_EFFECT_V1.0. Structured Content Plan: ACTEC_CSO_CRS_Mod4.1. Modules: `B04.M25`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Create a Structured Content Event from `week4-agentic` (B04 agentic (Mod4.5))
    
    - **Who:** range support
    - **When:** Conditional for `B04.M13`, `B04.M14`, `B04.M16`, `B04.M18`.
    - **Procedure:** Display name: B04 agentic (Mod4.5). Activity: structured_content. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_CS-Ops_Week4. Clone source: ACTEC_CS-Ops_Week4.5-Agentic_CS2.0. Structured Content Plan: ACTEC_CSO_SCP_Mod4.5. Modules: `B04.M13`, `B04.M14`, `B04.M16`, `B04.M18`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Create a Structured Content Event from `capstone` (Capstone DCORA structured content)
    
    - **Who:** range support
    - **When:** Required for `B05.M01`.
    - **Procedure:** Display name: Capstone DCORA structured content. Activity: structured_content. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_DCORA_CAPSTONE_NET. Clone source: ACTEC_DCORA_CAPSTONE_GOLD_v2.4. Structured Content Plan: ACTEC_CSO_Capstone. Modules: `B05.M01`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)
- Create a Structured Content Event from `b01-runspace-demo` (B01.M08 Empire plus Windows victim demo)
    
    - **Who:** range support
    - **When:** Required for `B01.M08`.
    - **Procedure:** Display name: B01.M08 Empire plus Windows victim demo. Activity: structured_content. Enterprise / event plane: ENT3 / EP3. Instance: ENT3/EP3. NetSpec: ACTEC_Runspace-Debugger-Demo. Clone source: ACTEC_Runspace_Demo_v1.0. Structured Content Plan: ACTEC Counterstrike Operations Module 1 Systems. Modules: `B01.M08`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)

## External portals

- Confirm external portal access for `htb-portal` (Hack The Box Academy via PCTE portal)
    - **Who:** range support
    - **When:** Required for `B02.M15`.
    - **Procedure:** Display name: Hack The Box Academy via PCTE portal. Activity: external_content. Enterprise / event plane: ENT1 / EP3. Instance: ENT1. Modules: `B02.M15`. [`course/operations/pcte-range-specifications.md`](https://moodle.cso.ops/mod/page/view.php?id=5765)

## Class setup

- Set up the DGX Spark team boxes. Copy the team stack once, download models if they are not already on the first box, rsync that copy to the other boxes, and give each box its own .env.
    
    - **Who:** range support
    - **When:** Every offering that uses the team DGX Spark boxes.
    - **Procedure:** [`environments/dgx_spark_stack/team/README.md`](https://moodle.cso.ops/mod/page/view.php?id=5767)
- Set classroom DNS so `*.teamN.cso.ops` resolves to that team's Spark. The resolver is the existing classroom DNS named in the team README. /opt/stack/traefik is that classroom mechanism.
    
    - **Who:** range support
    - **When:** Every offering that uses the team DGX Spark boxes.
    - **Procedure:** [`environments/dgx_spark_stack/team/README.md`](https://moodle.cso.ops/mod/page/view.php?id=5767)
- Copy or deploy the Moodle course, then replace the [DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access") placeholders with the live values. A later render from source puts the placeholders back.
    
    - **Who:** range support and instructor
    - **When:** Every offering.
    - **Procedure:** [`blocks/B01-military-tactical-planning/modules/B01.M35-dgx-spark-team-buildout/work-aid.md`](https://moodle.cso.ops/mod/page/view.php?id=5655)
- In the ESXi infrastructure, create a folder for each student and deploy a standard Kali Linux guest with reasonable CPU, RAM, and disk. Install Node.js and npx on that guest before class.
    
    - **Who:** range engineer or instructor
    - **When:** Every in-residence offering. Each student needs a workstation VM before class.
    - **Procedure:** [`course/operations/facility_requirements.md`](https://moodle.cso.ops/mod/page/view.php?id=5762)
- Set up access to the ESXi cluster and deliver laptops to the classroom. Wire the classroom when that offering needs it.
    
    - **Who:** range support
    - **When:** Every in-residence offering. Wiring applies only when that offering needs the classroom wired.
    - **Procedure:** [`course/operations/facility_requirements.md`](https://moodle.cso.ops/mod/page/view.php?id=5762)
- Build a VM template that already contains the student n8n stack, and deploy one VM from that template for each student.
    
    - **Who:** range support
    - **When:** Only when B04.M13 runs on the classroom ESXi cluster. Skip this step when that lab runs on PCTE. A PCTE template for the same stack is a separate work item (#193), not this step.
    - **Procedure:** [`environments/b04_m13_student_n8n/README.md`](https://moodle.cso.ops/mod/page/view.php?id=5766)
- Identify the cloud frontier model for this iteration, obtain API keys for this iteration, and publish the model id on the [DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access") page.
    
    - **Who:** range support and instructor
    - **When:** Before each class iteration. A key from a previous iteration does not carry forward. The class that starts 13 October 2026 is the next iteration; that iteration's model and keys are tracked on #194.
    - **Procedure:** [`course/requirements/bill-of-deliverables.md`](https://moodle.cso.ops/mod/page/view.php?id=5759); also [`blocks/B01-military-tactical-planning/modules/B01.M35-dgx-spark-team-buildout/work-aid.md`](https://moodle.cso.ops/mod/page/view.php?id=5655)
- Run the capstone readiness checks. This step points at that contract. It does not copy the deploy steps.
    
    - **Who:** range support
    - **When:** When the offering includes the capstone. Added in the 2026-09-30 completeness pass.
    - **Procedure:** [`course/operations/capstone-readiness-verification.md`](https://moodle.cso.ops/mod/page/view.php?id=5760)
- Confirm students have the Hack The Box Academy prerequisite packages and both ESET threat-report reads. Those packages are not assigned Modules and are not deployed by this checklist.
    
    - **Who:** instructor
    - **When:** Before day 1. Added in the 2026-09-30 completeness pass.
    - **Procedure:** [`course/prerequisites/README.md`](https://moodle.cso.ops/mod/page/view.php?id=5763); also [`Course Overview.md`](https://moodle.cso.ops/mod/page/view.php?id=5761)
- Mint a new n8n-auth cookie for the adversary operator on the B04.M18 replica and put that value in the student brief. Follow the Quick Start mint step.
    
    - **Who:** range support
    - **When:** Before B04.M18. A cookie from a previous offering does not carry forward.
    - **Procedure:** [`environments/b04_l45_adversary_agent/README.md`](https://moodle.cso.ops/mod/page/view.php?id=5764); also [`blocks/B04-effects-agentic-operations/modules/B04.M18-adversary-agent-counterstrike/student-brief.md`](https://moodle.cso.ops/mod/assign/view.php?id=5735)