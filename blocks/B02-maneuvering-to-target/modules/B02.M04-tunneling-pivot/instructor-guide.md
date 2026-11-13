---
id: B02.M04-ig
title: Tunneling and Pivot — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B02
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# Tunneling and Pivot — Instructor Guide

## Objective and context

Facilitation SoT for the generated lesson plan. Command-complete walkthrough, troubleshooting, and target-access enablement live in [`answer-key.md`](./answer-key.md). Students must get their image content into **two assigned cells** on the projected status grid. Discovery-first student tasking: [`student-brief.md`](./student-brief.md). PCTE build: [`environments/b02_tunneling_pivot/pcte-setup.md`](../../../../environments/b02_tunneling_pivot/pcte-setup.md).

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Start on the ops station. Your entry is the web server address in the student brief. The projected grid is asking for image content on two cells that belong to you."
- **Do:** Put the starting address and each team's assigned port on the board. Do not sketch LocalNet or the pivot host.
- **Ask (Q):** What proves you finished, and what must you confirm before digging on a remote host?
- **Expected Response (A):** Both assigned cells show intended image content. After remote execution, record hostname, identity, and working path.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Start on the ops station. Your entry is the web server address in the student brief. The projected grid is asking for image content on two cells that belong to you."
- **Show:** The student-brief objective and starting-address table. Do not project walkthrough commands.
- **Do:** Confirm each seat can reach the assigned entry host and knows its port.
- **Ask (Q):** What proves you finished, and what must you confirm before digging on a remote host?
- **Expected Response (A):** Both assigned cells show intended image content. After remote execution, record hostname, identity, and working path.

## Instructor resources and pre-class preparation

1. Complete [`setup-guide.md`](./setup-guide.md). Pass [`verification-runbook.md`](./verification-runbook.md) before students start.
2. Open `status/status.html` on Chromium/Chrome with “Always use secure connections” off (see the deploy-kit README).
3. Assign one status port per student or team (`14000–14019` by default).
4. Do not hand [`answer-key.md`](./answer-key.md) to students.

## Student resources and environment

- Ops station on `city-vulnhub`; starting address in the student brief
- Shared web host plus the browser VM that also hosts the SSH pivot, on live-action stack `classroom-shared`. Build steps: [`environments/b02_tunneling_pivot/pcte-setup.md`](../../../../environments/b02_tunneling_pivot/pcte-setup.md)
- NAT on the external-subnet link drops new sessions the shared target opens back to an ops station. If a team is stuck waiting for that return path, prompt them to try a connection they open toward the web server. Do not name the NAT on the student brief.
- Tools named in the answer key (routing, scan, HTTP, SSH, Python HTTP server) as needed — students discover which they need

## Facilitation flow

### Step 1: Orient on the grid and starting address (8 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Both of your cells must show what you intend. Investigate what the display is probing before you tunnel."
- **Show:** Projected status page (red cells at start). Student brief starting address.
- **Do:** Issue ports. Confirm remaps if the classroom is not on the defaults.
- **Ask (Q):** What does a red cell mean before anyone has tunneled?
- **Expected Response (A):** No listener answering that host:port probe yet.

### Step 2: Reach and enumerate from the ops station (12 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Start from the ops station. Evidence first. When you get a shell, verify host identity before you keep going."
- **Show:** Student-brief tasks 1–3. Live commands stay in the answer key.
- **Do:** Timebox discovery. Do not project internal addresses or key paths.
- **Ask (Q):** What tells you that you are on the intended host?
- **Expected Response (A):** Hostname, identity, and working path recorded after access.

### Step 3: Build paths so the grid can see the image (25 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "The left and right grids probe different places. Your content has to answer both."
- **Show:** Assigned cells on the projector. Do not show ProxyJump or remote-forward command lines unless a team is stuck after honest enumeration.
- **Do:** Coach from symptoms (red vs yellow vs image). The image stays on the ops-station Kali. Students do not upload it to the web server or the browser box. The forwards pull it from the ops station. Walkthrough in [`answer-key.md`](./answer-key.md) for live demo.
- **Ask (Q):** What does yellow mean versus an image in the cell?
- **Expected Response (A):** Yellow is a listener without a loadable `/pic.jpg`. Image means the HTTP GET returned an image.

### Step 4: Confirm both assigned cells (15 min)

- **Image Prompt:** No image required for this lab step.
- **Say:** "Done when both of your assigned locations show your intended content."
- **Show:** Status grid. Troubleshooting table in the answer key if TLS 400s appear in `http.server` logs.
- **Do:** Recheck Chromium settings if `curl http://...` works but cells stay red/yellow.
- **Ask (Q):** If curl on the ops station succeeds and the cell stays red, where do you look first?
- **Expected Response (A):** Projector browser (not Firefox / HTTPS-first) and whether the status page is on the host the right grid expects (`127.0.0.1`).

## Lesson summary

- Students extend reach through a position of access so the class status probes return their image.
- Walkthrough commands and deploy-kit paths stay in the answer key and setup guide.
- Success is both assigned cells on the projector, not a specific TTP.

## Questions and check on learning

- **Ask (Q):** What product does this lab collect, and what must not appear in student evidence dumps?
- **Expected Response (A):** Two assigned status cells showing intended image content. Do not put answer-key commands, flags, or tokens in screenshots.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Setup: [`setup-guide.md`](./setup-guide.md)
- Verification: [`verification-runbook.md`](./verification-runbook.md)
- Answer key: [`answer-key.md`](./answer-key.md)
- Deploy kit: [`environments/b02_tunneling_pivot/README.md`](../../../../environments/b02_tunneling_pivot/README.md)
