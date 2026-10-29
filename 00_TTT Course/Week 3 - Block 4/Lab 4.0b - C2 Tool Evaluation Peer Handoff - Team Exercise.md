 # C2 Framework Evaluation and Peer Handoff

## Student Brief

**Phase:** Opening block (tool test + documentation). **Duration:** Instructor-flexible (individual evaluate/document + peer swap). **Platform:** Shared vSphere / vCenter.

## Operational Context

Your team must adopt unfamiliar offensive tooling under time pressure. Before anyone depends on a framework in a mission rehearsal or live window, you will **test**, **document**, and **prove** that a peer can stand it up from your writing alone.

This lab applies the **peer-handoff documentation standard** to one offensive **C2 framework**. Selection uses [The C2 Matrix](https://howto.thec2matrix.com/) and/or the instructor-approved shortlist as a **lab convenience** — not as a lecture topic.

## Access (Ops Station → Test VMs)

1. **Primary method: vSphere / vCenter UI + VM Remote Console** from your ops station into the exploitation range you already built (Kali ops, the redirector you chose, and the Windows target).
    
2. **Allowed fallback:** instructor-assisted console if UI/console fails.
    
3. Validate guest context before install or listener work: `bash hostname && whoami && pwd` Windows: `powershell hostname; whoami; pwd`

## Environment Constraints

|Constraint|Requirement|
|---|---|
|RAM|Stay within **~50 GB** concurrent; **power down** unused VMs as needed|
|Addressing|Use only your assigned block in **`172.16.45.0/24`**|
|Targets|Disposable VMs you own — **do not** target classmate ranges|
|Media|Install only from the instructor-staged package path / offline share|
|Egress|No assumption of live internet during the lab|

## Specific Tasks

### Part A — Author (individual)

1. Select **one** C2 framework from the instructor shortlist / Matrix selection rules for this class. Record why it fits a planned TTP (doctrine effect intent + **ATT&CK** technique tag).
    
2. Use the exploitation range you already built. Do **not** deploy a new server-and-target pair. Snapshot before install. Place the teamserver (or framework equivalent) on the **Kali ops** host. Place the beacon on the **Windows** target. The callback must traverse the **redirector**.
    
3. Install and configure the framework, then exercise the full basic employment chain:
    

- Install / configure the **teamserver** (or framework equivalent) on Kali
- **Build / generate a beacon** (payload) from the teamserver
- Deploy and execute the beacon on your **Windows** target
- Confirm a **listener / check-in** from the beacon, and that the callback traversed the redirector
    
- **Task the beacon** through the teamserver (e.g., a basic command) and observe the response as your **minimal validation task**
    

4. Produce a **tool dossier** using these sections:
    - Purpose and architecture
    - Prerequisites and install / config
    - Basic employment workflow
    - Validation checks and known limitations
    - Teardown steps
5. Snapshot a known-good state; note exact staged installer path for the peer.

### Part B — Peer swap

1. Exchange dossiers with your assigned peer. **No live coaching** during the execute window.
    
2. As **reviewer**, using **only** the peer dossier + approved installer path, on **your own** exploitation range (not the author's VMs):
    

- Install / configure the teamserver on your Kali ops host
- Build / generate a beacon from the dossier instructions
- Deploy the beacon to your Windows target, confirm check-in, and confirm the callback traversed your redirector
    
- Task the beacon through the teamserver and complete the minimal validation task described in the dossier
    

3. Complete the **[peer review form](https://moodle.cso.ops/mod/page/view.php?id=5719)** (success/fail per step; gaps found).
    
4. Joint **hotwash** notes: what the docs missed; what you would change before mission use.
    

## Deliverables

1. **Tool dossier** (author).
2. **[Peer review form](https://moodle.cso.ops/mod/page/view.php?id=5719)** (reviewer) — install, beacon build/deploy, tasking/validation, clarity.
    
3. **Hotwash notes** (pair) — gaps and remediation to the dossier.
    
4. **Resource note** — confirmation you stayed in RAM/IP constraints (brief).

## Success Criteria

- Dossier enables a peer to install, build/deploy a beacon, and complete minimal validation (tasking) **without author coaching**.
    
- Evaluation covers capabilities, burden, footprint/limitations, and TTP fit (doctrine + ATT&CK).
    
- Testing stayed on your own exploitation range, inside the assigned address block and ~50 GB cap.
    
- Teardown steps are present and credible.

## Tie-Back

- **Tool-testing lecture:** documentation as operational product; peer-execute test.
- **Planning / MITRE:** planned TTP fit uses doctrinal intent paired with ATT&CK.
- **Later effects work:** same handoff discipline applies when packaging effects and agentic products for another operator.

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
|Last modified|-|
|Submission comments|[![Comments](https://moodle.cso.ops/theme/image.php/boost/core/1784917078/t/collapsed)Comments (0)](https://moodle.cso.ops/mod/assign/view.php?id=5716#)|

#### Grading criteria

|   |   |
|---|---|
Rubric
|PH-1 (Weight: install reproducibility). Did the dossier enable a peer to install from staged media without author coaching?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Peer could not begin install, or required author intervention / missing path. Score: 1<br><br>1 points\|Peer installed only with significant guesswork; critical prereqs missing or unclear. Score: 2<br><br>2 points\|Peer completed install from dossier + staged path with only minor clarification to instructor about environment faults. Score: 3<br><br>3 points\|Peer installed cleanly on first pass; prereqs, paths, and order were explicit and verified. Score: 4<br><br>4 points\||
|PH-2 (Weight: operational clarity). Did the employment workflow make the install → build/deploy beacon → task-via-teamserver chain observable and ordered?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Workflow absent or contradictory; peer could not identify next action. Score: 1<br><br>1 points\|Partial workflow; peer stalled on beacon build, deployment, or tasking steps. Score: 2<br><br>2 points\|Clear happy-path steps for building/deploying the beacon and tasking it through the teamserver. Score: 3<br><br>3 points\|Workflow is concise, ordered, and anticipates common operator decision points (e.g., listener config, callback timing) without bloat. Score: 4<br><br>4 points\||
|PH-3 (Weight: validation evidence). Did validation checks (e.g., tasking the beacon and confirming a response) prove the tool worked and match what the peer could re-run?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|No validation section, or claims without runnable checks. Score: 1<br><br>1 points\|Validation vague; peer unsure what “success” looks like. Score: 2<br><br>2 points\|Runnable validation checks; peer completed the minimal proof described. Score: 3<br><br>3 points\|Validation includes expected evidence cues and failure discriminators the peer used successfully. Score: 4<br><br>4 points\||
|PH-4 (Weight: limitation honesty). Did the dossier surface real limitations, footprint, and failure modes?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Marketing-only tone; no limitations or known breaks. Score: 1<br><br>1 points\|Generic caveats unrelated to observed testing. Score: 2<br><br>2 points\|Concrete limitations and footprint notes tied to the author’s test. Score: 3<br><br>3 points\|Limitations clearly change mission suitability; ties burden/footprint to planned TTP risk. Score: 4<br><br>4 points\||
|PH-5 (Weight: peer success from docs alone). Did the peer complete install + build/deploy a beacon + task it via the teamserver using only the dossier and approved media?|\|   \|   \|   \|   \|<br>\|---\|---\|---\|---\|<br>\|Peer failed two or more of install / beacon build-deploy / tasking under sealed-dossier rules. Score: 1<br><br>1 points\|Peer completed only one major step; others needed coaching or were abandoned. Score: 2<br><br>2 points\|Peer completed all three major steps under sealed-dossier rules. Score: 3<br><br>3 points\|Peer completed all three major steps efficiently and documented residual gaps that still improve the dossier. Score: 4<br><br>4 points\||

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

# C2 Tool Evaluation Peer Handoff — Instructor Answer Key

## Objective and starting context

No classic discovery walkthrough. Grade **dossier reproducibility** and **peer-execute success** using [`rubric.md`](https://moodle.cso.ops/mod/assign/view.php?id=5716). Facilitation cadence lives in B04.M05 instructor materials in Lesson Plans and Instructor Slides.zip. Staging checklists live in [`setup-guide.md`](https://moodle.cso.ops/mod/page/view.php?id=5718).

Students start on the ops station, open vCenter Remote Console into the exploitation range they already built (Kali ops, chosen redirector, Windows target), and stay in their `/29` inside `172.16.45.0/24` with a ~50 GB concurrent RAM cap. Do not require a new server-and-target pair.

## Flag / reference table

|Item|Value|
|---|---|
|Shortlist (default)|Sliver, Mythic, Havoc, Covenant — adjust to what is legally/technically staged|
|Media|Instructor-staged share only; no live download|
|Addressing|Assigned block in `172.16.45.0/24`|
|RAM|≤ ~50 GB concurrent; power down unused VMs|
|Validation chain|Install teamserver → build/deploy beacon → check-in → task beacon|
|Grade instruments|Dossier + peer review form + hotwash|

Record live share paths in the setup-guide table before class. Grade against those paths.

## Initial situational awareness

In-guest, before install or listener work:

```
hostname && whoami && pwd
date -u
id
uname -a
ss -tulpen
ip -4 addr
```

Windows:

```
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

|Issue|Resolution|
|---|---|
|Peer claims docs incomplete; author disagrees|Grade from reviewer evidence + whether a competent operator could succeed; require specific missing steps|
|Installer path wrong|Environment fault if share moved; else dossier defect|
|Peer lacks prerequisite skill named in dossier|If prereq was stated and reasonable, author may still score; if hidden skill required, dossier defect|
|Cross-student targeting|Stop exercise for those students; remediation before continue|
|RAM pressure|Power off unused VMs; postpone Mythic-class heavy stacks if the Kali host cannot spare the RAM|
|Share not reachable|Fix connectivity; do not authorize internet pulls|
|Listener bind conflicts|Keep services inside student `/29`; check duplicate ports on same VM|
|Peer stuck on OS basics|Point to dossier prerequisites; do not demo the C2|

If environment breakage blocked the peer, do not penalize the author for that interval; resume scoring after restore.

## Grading checkpoints

Score the **author** primarily with PH-1–PH-4; use PH-5 as the integrated outcome check.

|Rubric|Evidence|Acceptable standard|
|---|---|---|
|PH-1|Dossier install section + peer form|Peer installed from staged media without author coaching|
|PH-2|Employment workflow|Ordered install → beacon build/deploy → task-via-teamserver|
|PH-3|Validation checks|Peer re-ran the named proof (tasking + response)|
|PH-4|Limitations / footprint|Concrete limits tied to the author's test, not marketing|
|PH-5|Peer execute|Install + beacon + tasking all completed under sealed-dossier rules|

Hotwash quality can inform Exemplary vs Acceptable on PH-4/PH-5 but does not replace peer-execute evidence.

# L4.0.b Instructor Setup Guide and Facilitator Notes

**Lab:** L4.0.b C2 Framework Evaluation and Peer Handoff  
**Audience:** Instructors / range operators  
**Student doc:** [L4.0.b Student Brief.md](https://moodle.cso.ops/mod/assign/view.php?id=5716)  
**Rubric:** [L4.0.b Peer Handoff Rubric.md](https://moodle.cso.ops/mod/assign/view.php?id=5716)  
**Peer form:** [L4.0.b Peer Review Form.md](https://moodle.cso.ops/mod/page/view.php?id=5719)  
**Shared env:** `environments/effects_lab_env/vsphere/README.md`

No classic discovery walkthrough answer key. Grade **dossier reproducibility** and **peer-execute success** using the rubric.

## Objective Framing

Students individually evaluate one offensive C2 framework on the exploitation range they already built, document it to the peer-handoff standard, then swap so a peer must install and complete a minimal validation task from the dossier alone on that peer's own cell.

C2 Matrix / shortlist is a **lab selection aid**, not lecture content.

## Default Approved Shortlist

Stage offline packages for at least these (adjust to what you can legally and technically stage in the closed environment):

|Framework|Notes for staging|
|---|---|
|Sliver|Server binary / release bundle on internal share|
|Mythic|Offline compose/bundle if available; document host RAM needs|
|Havoc|Teamserver + client packages|
|Covenant|Installer / published release bundle|

**Selection rules for students:**

1. Prefer a shortlist item with a staged package path.
2. If using [The C2 Matrix](https://howto.thec2matrix.com/) for awareness, final pick must still map to a staged package (no live download dependency).
    
3. One framework per student; instructor may force diversity across the room.
    

Record exact share paths here before class:

|Framework|Staged path|Approx. RAM for server VM|
|---|---|---|
|Sliver|`_TBD_`|`_TBD_`|
|Mythic|`_TBD_`|`_TBD_`|
|Havoc|`_TBD_`|`_TBD_`|
|Covenant|`_TBD_`|`_TBD_`|

## Pre-Class Staging Checklist

- [ ] Shortlist packages staged on datastore or internal file share
- [ ] Share readable from student ops stations / test VMs
- [ ] Offline howto excerpts available if Matrix site is unreachable
- [ ] Student folders / 50 GB pools still valid from the exploitation-range build
- [ ] Students reminded to power down unused VMs
- [ ] Students will use Kali as the teamserver host and Windows as the beacon target; callback stays through their redirector
- [ ] Peer pairing roster published
- [ ] Rubric and peer review form ready
- [ ] Isolation briefed: no targeting classmate IP blocks

## Access Runbook

**Primary:** vCenter UI + Remote Console from ops station into the exploitation range already built.  
**Fallback:** instructor-assisted console.

Students validate with `hostname` / `whoami` / `pwd` in-guest before installs.

## Facilitator Cadence

1. **Select framework** — confirm unique frameworks where possible. Do not have students build a new server-and-target pair.
2. **Author window** — dossier + self-validation; no peer help yet.
3. **Seal and swap** — dossiers + installer paths only; start execute clock.
4. **Peer execute** — no author coaching; instructor answers only environment-breakage questions (ISO/share down, pool exhausted).
    
5. **Review forms + hotwash** — capture gaps; allow dossier revision if time.
    
6. **Teardown** — listeners down; VMs powered off or snapped clean.

## Dispute Handling

|Issue|Resolution|
|---|---|
|Peer claims docs incomplete; author disagrees|Grade from reviewer evidence + whether a competent operator could succeed; require specific missing steps|
|Installer path wrong|Environment fault if share moved; else dossier defect|
|Peer lacks prerequisite skill named in dossier|If prereq was stated and reasonable, author may still score; if hidden skill required, dossier defect|
|Cross-student targeting|Stop exercise for those students; remediation before continue|

## Troubleshooting (Consolidated)

- **RAM pressure:** Power off unused VMs; postpone Mythic-class heavy stacks if the Kali host cannot spare the RAM.
- **Share not reachable:** Fix connectivity; do not authorize internet pulls.
- **Listener bind conflicts:** Keep services inside student `/29`; check duplicate ports on same VM.
- **Peer stuck on OS basics:** Point to dossier prerequisites; do not demo the C2 for them during execute window.

## Cleanup

- Students stop listeners. Power the cell off or leave a clean snapshot.
- Instructor verifies no leftover teamservers on shared networks.
- Reclaim disks after grading window.
- Refresh staged package checksums/paths for next class.

## Grading Crosswalk

|Rubric row family|Evidence source|
|---|---|
|PH-1 … PH-5|Dossier sections + peer review form + hotwash|
|See [L4.0.b Peer Handoff Rubric.md](https://moodle.cso.ops/mod/assign/view.php?id=5716)|Instructor scores each student as author and as reviewer contributions per form|

## Link to Course Objectives

- Converts individual tool discovery into team-usable capability.
- Reinforces closed-environment discipline and RAM/IP constraints from the exploitation-range build.
- Builds handoff documentation habits reused in later Week 4 products.

# L4.0.b Peer Review Form

**Reviewer:** _________________  
**Author:** _________________  
**Framework:** _________________  
**Installer path used:** _________________  
**Date:** _________________

Sealed-dossier rules: no author coaching during the execute window. Mark each step from **your** attempt only.

|Step|Result (pass / fail / blocked)|Evidence / notes|
|---|---|---|
|Located staged media from dossier path|||
|Completed install / config (teamserver)|||
|Built / generated a beacon from dossier instructions|||
|Deployed beacon to target VM and confirmed check-in|||
|Tasked the beacon via teamserver and completed minimal validation|||
|Followed teardown guidance (if time)|||

## Clarity gaps (required if any fail)

List specific missing or ambiguous dossier items (commands, order, prereqs, expected output):

1. 2. 3.

## Environment blocks (not dossier faults)

Describe only facility/share/RAM/console failures escalated to the instructor:

-

## Reviewer attestation

I executed using only the author dossier and the approved installer path, except for environment issues noted above.

Signature / initials: _____________

