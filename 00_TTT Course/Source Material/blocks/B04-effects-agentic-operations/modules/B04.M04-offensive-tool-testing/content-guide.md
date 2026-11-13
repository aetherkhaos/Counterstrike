---
id: B04.M04
title: Offensive Tool Testing and Team Documentation
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.0.b Offensive Tool Testing and Team Documentation
  Content Guide.md
- B04.M20
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
---

# Offensive Tool Testing and Team Documentation — Content Guide

**Source:** `../../overview.md`, `../../activities/L4.0b_C2_Tool_Evaluation_Peer_Handoff/`, `../../../../environments/effects_lab_env/vsphere/README.md`
**Audience:** CPT operators who already built the exploitation range (Kali ops, one redirector, Windows target).
**Duration:** Instructor-flexible lecture before peer tool-evaluation practice.
**Prerequisites:** Threat-representative OE rehearsal; tactical planning + ATT&CK bilingual fluency.
**References:**

- [`../B04.M24-threat-rep-mission-rehearsal/content-guide.md`](../B04.M24-threat-rep-mission-rehearsal/content-guide.md)
- [`../B04.M05-c2-tool-evaluation-peer-handoff/student-brief.md`](../B04.M05-c2-tool-evaluation-peer-handoff/student-brief.md)
- [`../../../../environments/effects_lab_env/vsphere/README.md`](../../../../environments/effects_lab_env/vsphere/README.md)

---

## Instructor resources and pre-class

- Classroom projector and screen; whiteboard for the opening contract
- Parent or sibling briefs listed in this Module folder
- Live tabs and references already named in this file's header
- Do not project flags, tokens, or answer-key values

## Student resources

- Student brief, student guide, or homework file in this Module folder when present
- Assigned range, workstation, or lab stack named in the student-facing file
- No extra kit beyond what the student-facing file already lists

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Today has three deliverables: judge whether a new tool is actually good for the mission, employ it on the exploitation range you already built — Kali ops, the redirector you chose, and the Windows target — and write it up well enough that someone else can run it without you. A peer later proves that last part using only what you wrote. Do not stand up a second harness."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** Which of these three — evaluate, employ on the range you built, document — do you think your team is weakest at?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Today has three deliverables: judge whether a new tool is actually good for the mission, employ it on the exploitation range you already built — Kali ops, the redirector you chose, and the Windows target — and write it up well enough that someone else can run it without you. A peer later proves that last part using only what you wrote. Do not stand up a second harness."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** Which of these three — evaluate, employ on the range you built, document — do you think your team is weakest at?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Objectives (7 min)

- Evaluate an unfamiliar offensive tool before it reaches mission use
- Employ it on the exploitation range you already built (Kali ops, chosen redirector, Windows)
- Produce documentation detailed enough for another operator to use

**Instructor Notes:**

- **Image Prompt:** Three panels — Evaluate, Build Test Range, Document — feeding into a fourth panel labeled "Team-Ready Capability."
- **Say:** "Today has three deliverables: judge whether a new tool is actually good for the mission, employ it on the exploitation range you already built — Kali ops, the redirector you chose, and the Windows target — and write it up well enough that someone else can run it without you. A peer later proves that last part using only what you wrote. Do not stand up a second harness."
- **Show:** Point out that the test bed is the range already built, not a new cell.
- **Do:** Ask: "Which of these three — evaluate, employ on the range you built, document — do you think your team is weakest at?"
- **Ask (Q):** Which of these three — evaluate, employ on the range you built, document — do you think your team is weakest at?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Documentation Pitfalls (7 min)

- One person knowing how to run the tool is not a team capability
- Testing in only one environment hides real constraints
- "It worked on my box" is not documentation
- Mission timing will not allow rediscovery later

**Instructor Notes:**

- **Image Prompt:** One operator silhouette with a glowing laptop; three teammates blocked by a wall labeled "Undocumented"; a second panel showing the same tool succeeding on one laptop icon and failing on three others labeled with different OS icons.
- **Say:** "Two failure modes here. First: if only you can run it, the team doesn't have it — swap, casualty, or shift change exposes every undocumented step. Second: testing once on your machine and writing it up as gospel is a trap. Run it against more than one config before you claim it works, and write down where it didn't. 'Worked on my box' is not evidence, it's a guess with confidence."
- **Show:** Point at the wall graphic, then the multi-OS panel.
- **Do:** Collect one quick story: "When has a tool broken because it only ran on one specific setup?"
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: Self-Made Documentation — Why Do We Need It? (7 min)

- Custom tools, scripts, and one-off methods often have no existing guide
- You will not always be there when the team needs it next
- Open-source references you rely on may be unreachable during an operation
- Replicate the reference material you'll need onto internal/offline systems now

**Instructor Notes:**

- **Image Prompt:** Split panel — left shows a laptop with a "help page" browser tab greyed out/unreachable; right shows the same information rewritten into an internal team wiki page.
- **Say:** "This isn't just about commercial C2 frameworks. Anything your team builds — a custom script, a one-off technique, a wrapper around someone else's tool — has zero public documentation by definition. And even for public tools, don't assume you'll have internet access to that vendor wiki mid-operation. If you know you'll need a reference, capture it on an internal system now, while you have access, in your own words."
- **Show:** Emphasize the greyed-out browser tab — that's the moment this slide is solving for.
- **Do:** Ask: "Name one tool or script your team uses today that only exists as 'ask so-and-so.'"
- **Ask (Q):** Name one tool or script your team uses today that only exists as 'ask so-and-so.'
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: What to Evaluate (7 min)

- Capabilities — what jobs does it actually do
- Install / ops burden — time, dependencies, privileges required
- Reliability — what breaks under normal use
- Fit to planned TTPs — map to **ATT&CK**; pair with doctrine intent

**Instructor Notes:**

- **Image Prompt:** Four labeled gauges — Capabilities, Burden, Reliability, TTP Fit — each with a plain-language caption underneath instead of just the label.
- **Say:** "Score the tool against the mission, not the marketing page. A tool with great capabilities but a two-hour install and root-only operation may not be worth it. When you name the TTP it supports, pair the doctrinal intent — for example reconnoiter or later degrade — with the ATT&CK technique you expect to exercise. We'll cover OPSEC footprint separately when we get to documentation — that's evidence you gather during testing, not a judgment call you make up front."
- **Show:** Walk one example tool through all four gauges in one sentence each.
- **Do:** Ask which of these four gets skipped most often under time pressure — expect "reliability" or "TTP fit."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 5: Documentation Standard — Identity & Setup (7 min)

- Overview — what it is and why the team would choose it
- Where to get it — source and staged package path
- Exact version tested — pin it, don't assume "latest"
- Install steps and dependencies — in order, reproducible
- Limitations — be OS/version granular, not just "Windows" or "Linux"

**Instructor Notes:**

- **Image Prompt:** Dossier page split into five labeled fields: Overview, Source, Version, Install/Deps, Limitations — with a callout on Limitations showing "Windows" crossed out and replaced with "Windows Server 2019, x64."
- **Say:** "This half of the dossier answers 'what is this and can I get the same thing running.' Overview earns the reader's buy-in. Where you got it and the exact version matter because a tool that works on one release can break on the next. Install steps must be reproducible in order. And limitations need to be specific — 'runs on Windows' tells the next operator nothing useful; state the OS family, version, and architecture you actually tested."
- **Show:** Point at the crossed-out "Windows" callout as the example of the mistake to avoid.
- **Do:** Ask: "If your dossier just says 'Linux,' what question is your peer stuck asking you?"
- **Ask (Q):** If your dossier just says 'Linux,' what question is your peer stuck asking you?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 6: Documentation Standard — Usage, Footprint & Teardown (7 min)

- Usage — how to operate it (e.g., build/deploy a beacon, talk to the teamserver)
- Footprint / artifacts — files left on disk, logs generated, network traffic
- Validation checks — how the next operator confirms it's working
- Teardown steps — return the range to a known-clean state

**Instructor Notes:**

- **Image Prompt:** Continuation of the dossier page — second half with fields: Usage, Footprint/Artifacts, Validation, Teardown — a small magnifying glass icon over Footprint/Artifacts.
- **Say:** "This half answers 'can I run it and do I know what it leaves behind.' Usage is the happy-path operator workflow — concrete verbs, not vibes. Footprint and artifacts are the OPSEC read: what would a defender see — files on disk, logs from install or use, network traffic signatures. Validation proves it worked. Teardown returns the environment to a known state — leftover listeners are exactly the mess this whole process exists to prevent."
- **Show:** Tell them the lab rubric grades both halves of this standard, especially whether a peer succeeds from the dossier alone.
- **Do:** Ask which section students are most tempted to shortchange — usually footprint or limitations. Demand honesty.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Peer-Review Mindset (7 min)

- Docs fail if a peer cannot stand the tool up
- Author is graded on **reproducibility**, not charisma
- Reviewer executes **only** from dossier + approved media path
- Hotwash captures what the docs missed

**Instructor Notes:**

- **Image Prompt:** Two desks — Author hands a sealed dossier folder to Reviewer; Reviewer has no author chat bubble, only the folder and an installer path.
- **Say:** "In the lab you will swap. The reviewer does not get a walkthrough from you. If they cannot install and complete a minimal validation task from your writing, your documentation failed — even if you personally know the tool cold."
- **Show:** Emphasize sealed-dossier constraint.
- **Do:** Set expectation: no coaching during the peer execute window.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Closed-Environment Testing Discipline (7 min)

- Use **local / staged media** only unless instructor opens egress
- Scope the test to **your** exploitation range and IP block: teamserver on Kali, beacon on Windows, callback through the redirector
- Snapshot before install; plan **teardown**
- Stay under the **~50 GB** shared RAM cap

**Instructor Notes:**

- **Image Prompt:** Checklist clipboard: Local Media, Scoped Targets, Snapshot, Teardown, RAM Cap — all checked.
- **Say:** "You are still on the shared cluster, on the cell you already built. Put the teamserver on the Kali ops host. Put the beacon on the Windows target and make the callback traverse the redirector. Power down unused VMs if you need headroom. Do not scan classmates. Do not stand up a second server-and-target pair. Do not assume internet for installers. Teardown is part of the test — leftover listeners are a self-inflicted failure you'll answer for in the hotwash."
- **Show:** Tie RAM discipline back to OE rehearsal.
- **Do:** Confirm students know which VMs they will power off before tool install.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: Transition to Peer Evaluation (7 min)

- Lab applies this process to a **chosen C2 framework**
- Deploy on the range you built: teamserver on Kali, beacon on Windows, callback through the redirector
- Selection source is a lab convenience (instructor shortlist / matrix)
- Produce dossier → swap → peer execute → hotwash
- Keep testing inside your **`172.16.45.0/24`** block

**Instructor Notes:**

- **Image Prompt:** Doorway labeled Peer Evaluate with icons for Dossier, Swap, Peer Execute, Hotwash.
- **Say:** "We are not teaching a particular C2 product in this lecture. In the lab you will pick one approved framework, install it on the exploitation range you already built, document that employment, then prove the docs with a peer who uses their own cell. Stay in your address block and RAM budget."
- **Show:** Hand out the peer-evaluation brief and shortlist / selection rules.
- **Do:** Break, then start peer evaluation.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M04-offensive-tool-testing is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** Which of these three — evaluate, employ on the range you built, document — do you think your team is weakest at?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** Name one tool or script your team uses today that only exists as 'ask so-and-so.'
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
