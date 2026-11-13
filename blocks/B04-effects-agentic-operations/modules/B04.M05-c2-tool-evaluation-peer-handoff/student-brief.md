---
id: B04.M05-brief
title: C2 Tool Evaluation Peer Handoff — Student Brief
artifact_type: student_brief
audience: student
block: B04
module_type: group_activity
source_status: canonical
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---

# C2 Framework Evaluation and Peer Handoff

## Student Brief

**Phase:** Opening block (tool test + documentation).
**Duration:** Instructor-flexible (individual evaluate/document + peer swap).
**Platform:** Shared vSphere / vCenter.

## Operational Context

Your team must adopt unfamiliar offensive tooling under time pressure. Before
anyone depends on a framework in a mission rehearsal or live window, you will
**test**, **document**, and **prove** that a peer can stand it up from your
writing alone.

This lab applies the **peer-handoff documentation standard** to one offensive **C2
framework**. Selection uses [The C2 Matrix](https://howto.thec2matrix.com/)
and/or the instructor-approved shortlist as a **lab convenience** — not as a
lecture topic.

## Access (Ops Station → Test VMs)

1. **Primary method: vSphere / vCenter UI + VM Remote Console** from your ops
   station into the exploitation range you already built (Kali ops, the
   redirector you chose, and the Windows target).
2. **Allowed fallback:** instructor-assisted console if UI/console fails.
3. Validate guest context before install or listener work:
   ```bash
   hostname && whoami && pwd
   ```
   Windows:
   ```powershell
   hostname; whoami; pwd
   ```

## Environment Constraints

| Constraint | Requirement |
| --- | --- |
| RAM | Stay within **~50 GB** concurrent; **power down** unused VMs as needed |
| Addressing | Use only your assigned block in **`172.16.45.0/24`** |
| Targets | Disposable VMs you own — **do not** target classmate ranges |
| Media | Install only from the instructor-staged package path / offline share |
| Egress | No assumption of live internet during the lab |

## Specific Tasks

### Part A — Author (individual)

1. Select **one** C2 framework from the instructor shortlist / Matrix selection
   rules for this class. Record why it fits a planned TTP (doctrine effect
   intent + **ATT&CK** technique tag).
2. Use the exploitation range you already built. Do **not** deploy a new
   server-and-target pair. Snapshot before install. Place the teamserver (or
   framework equivalent) on the **Kali ops** host. Place the beacon on the
   **Windows** target. The callback must traverse the **redirector**.
3. Install and configure the framework, then exercise the full basic
   employment chain:
   - Install / configure the **teamserver** (or framework equivalent) on Kali
   - **Build / generate a beacon** (payload) from the teamserver
   - Deploy and execute the beacon on your **Windows** target
   - Confirm a **listener / check-in** from the beacon, and that the callback
     traversed the redirector
   - **Task the beacon** through the teamserver (e.g., a basic command) and
     observe the response as your **minimal validation task**
4. Produce a **tool dossier** using these sections:
   - Purpose and architecture
   - Prerequisites and install / config
   - Basic employment workflow
   - Validation checks and known limitations
   - Teardown steps
5. Snapshot a known-good state; note exact staged installer path for the peer.

### Part B — Peer swap

1. Exchange dossiers with your assigned peer. **No live coaching** during the
   execute window.
2. As **reviewer**, using **only** the peer dossier + approved installer path,
   on **your own** exploitation range (not the author's VMs):
   - Install / configure the teamserver on your Kali ops host
   - Build / generate a beacon from the dossier instructions
   - Deploy the beacon to your Windows target, confirm check-in, and confirm
     the callback traversed your redirector
   - Task the beacon through the teamserver and complete the minimal
     validation task described in the dossier
3. Complete the **[peer review form](supporting-documents/L4.0.b%20Peer%20Review%20Form.md)** (success/fail
   per step; gaps found).
4. Joint **hotwash** notes: what the docs missed; what you would change before
   mission use.

## Deliverables

1. **Tool dossier** (author).
2. **[Peer review form](supporting-documents/L4.0.b%20Peer%20Review%20Form.md)** (reviewer) — install,
   beacon build/deploy, tasking/validation, clarity.
3. **Hotwash notes** (pair) — gaps and remediation to the dossier.
4. **Resource note** — confirmation you stayed in RAM/IP constraints (brief).

## Success Criteria

- Dossier enables a peer to install, build/deploy a beacon, and complete
  minimal validation (tasking) **without author coaching**.
- Evaluation covers capabilities, burden, footprint/limitations, and TTP fit
  (doctrine + ATT&CK).
- Testing stayed on your own exploitation range, inside the assigned address block and ~50 GB cap.
- Teardown steps are present and credible.

## Tie-Back

- **Tool-testing lecture:** documentation as operational product; peer-execute test.
- **Planning / MITRE:** planned TTP fit uses doctrinal intent paired with ATT&CK.
- **Later effects work:** same handoff discipline applies when packaging effects and
  agentic products for another operator.
