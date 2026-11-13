---
id: B04.M09
title: Persistent Effects and Handoff
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.2 Persistent Effects and Handoff Content Guide.md
- B03.M04
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

# Persistent Effects and Handoff — Content Guide

**Source:** `../../overview.md`, `../../activities/L4.2a_Adversary_Tracking/`, `../../activities/L4.2b_Handoff_and_Partner_RAT_Deploy/`
**Audience:** CPT operators who completed disable-tooling and false-information practice and have working access to the adversary stack.
**Duration:** ~60 minutes (persistent effects and handoff lecture)
**Prerequisites:** Effects Operations Overview; prior disable-tooling and false-information practice.
**References:**

- `./4.1 Effects Operations Overview Content Guide.md`
- `../../M01-planning-foundations/lessons/04-d3fend-engage/content-guide.md`
- `../../M01-planning-foundations/lessons/01-military-tactical-planning/content-guide.md` (for the CG/CV reference)
- `../../../../environments/effects_lab_env/README.md`

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

- **Say:** "Yesterday you produced effects that lived and died inside the adversary stack. Today you reach out past that stack. Survey is how you execute reconnoiter in practice — you collect technical and behavioral facts from the adversary workflow and turn them into pursuit-enabling intelligence. Handoff deploys another team's capability from your foothold when needed — that is a force-multiplier. These are the effects that make a CPT valuable outside its own enclave."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** At your home unit, where does a partner team usually get stuck first: incomplete technical detail, unclear behavioral context, or both?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Yesterday you produced effects that lived and died inside the adversary stack. Today you reach out past that stack. Survey is how you execute reconnoiter in practice — you collect technical and behavioral facts from the adversary workflow and turn them into pursuit-enabling intelligence. Handoff deploys another team's capability from your foothold when needed — that is a force-multiplier. These are the effects that make a CPT valuable outside its own enclave."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** At your home unit, where does a partner team usually get stuck first: incomplete technical detail, unclear behavioral context, or both?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Yesterday We Denied and Deceived — Today We Survey and Hand Off (8 min)

- Local effects (**degrade / disrupt / deny** collection and **deceive / manipulate** analysis) **stop at the edge of the adversary stack**
- Extending effects (**reconnoiter** via survey methods, then **handoff**) **reach past the adversary stack** to collect technical and behavioral data, then pass action-ready context to partner teams
- These are the effects CPT commanders most care about because they generate options for pursuit
- They also demand the highest documentation discipline because another team may execute based on what you report

**Instructor Notes:**

- **Image Prompt:** A two-row graphic. Top row labeled "Local effects" with small icons for Degrade/Disrupt/Deny and Deceive/Manipulate, constrained inside a dotted box labeled "Adversary Stack." Bottom row labeled "Extending effects" with icons for Reconnoiter (survey) and Handoff, arrows breaking out of the dotted box toward labeled targets "Adversary Analyst," "Partner Team."
- **Say:** "Yesterday you produced effects that lived and died inside the adversary stack. Today you reach out past that stack. Survey is how you execute reconnoiter in practice — you collect technical and behavioral facts from the adversary workflow and turn them into pursuit-enabling intelligence. Handoff deploys another team's capability from your foothold when needed — that is a force-multiplier. These are the effects that make a CPT valuable outside its own enclave."
- **Show:** The local-vs-extending graphic.
- **Do:** Ask: "At your home unit, where does a partner team usually get stuck first: incomplete technical detail, unclear behavioral context, or both?" Use answers to frame why today's reporting quality matters.
- **Ask (Q):** At your home unit, where does a partner team usually get stuck first: incomplete technical detail, unclear behavioral context, or both?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Situational Awareness Package from Prior Survey (8 min)

- Initial access work from last week already produced a first-pass awareness picture; today we package that picture for partner action
- Organize existing survey-derived observations into four buckets:
  - **Technical state** — host, user, process, service, and network facts from the current foothold
  - **Behavioral indicators** — cadence, handling patterns, and likely next adversary action
  - **Attribution and tracking support** — infrastructure, timing, and routing clues that support "who is handling this" and "from where"
  - **Expansion leads** — additional systems, users, services, or workflows revealed by current access
- This package is the baseline for handoff quality: if these four buckets are weak, partner teams must re-discover before they can execute
- Effect framing remains **reconnoiter**; operational product is an actionable **Access Guide** baseline

**Instructor Notes:**

- **Image Prompt:** A handoff prep board with four labeled columns: Technical State, Behavioral Indicators, Attribution and Tracking, Expansion Leads. Each column contains 2-3 short example artifacts feeding an "Access Guide Baseline" box.
- **Say:** "Do not treat this as raw log dump. Treat it as your situational awareness package from prior survey work. Four buckets: technical state, behavior, attribution-and-tracking, and expansion leads. This is what partners need first to decide if they can act now, need more evidence, or need you to collect additional detail before handoff."
- **Show:** The four-column package graphic; walk one concrete example in each column and map it to Access Guide fields.
- **Do:** Ask: "Which of these four buckets is usually weakest in your team handoffs, and what mission risk does that create?"
- **Ask (Q):** Which of these four buckets is usually weakest in your team handoffs, and what mission risk does that create?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 3: Additional Collection for Handoff Decisions and Success (8 min)

- Once baseline awareness is organized, collect only what closes partner decision gaps or handoff execution gaps
- Two common additional-collection paths before/with handoff:
  - **Targeted scanning/enumeration from current foothold** — gather missing validation on adjacent hosts, exposed services, user paths, and callback feasibility
  - **Pipeline plant (optional, informed)** — introduce a controlled plant in a known adversary workflow when you need higher-confidence interaction evidence or persistent partner positioning
- Selection logic:
  - Use additional scanning when the gap is coverage, reachability, or technical validation
  - Use a pipeline plant when the gap is workflow understanding, adversary handling confirmation, or partner persistence requirements
  - Record purpose, expected evidence, and risk in the Access Guide before execution
- Poor handoff prep is collecting "more data" without a stated partner decision it supports

**Instructor Notes:**

- **Image Prompt:** A decision flow: "Access Guide Baseline Ready?" -> "What partner gap remains?" -> branch A "Need technical validation" -> "Targeted Scan/Enumeration"; branch B "Need workflow/handling confidence" -> "Optional Pipeline Plant." Both branches feed "Handoff Decision + Access Guide Update."
- **Say:** "Slide 2 gave the baseline. This slide is the gap-closure step. Ask what the partner still cannot decide or execute. If the gap is technical validation, scan with purpose. If the gap is workflow confidence or persistent positioning, consider a pipeline plant. In both cases, tie every action to a partner decision and capture it in the guide."
- **Show:** The decision flow and one example gap routed down each branch.
- **Do:** Ask: "Name one handoff decision your partner cannot make yet, then pick scan or plant and defend your choice in one sentence."
- **Ask (Q):** Name one handoff decision your partner cannot make yet, then pick scan or plant and defend your choice in one sentence.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: What "Handoff" Means in Cyber (8 min)

- **Handoff** = convert your tactical access into operational reach for someone else
- Two flavors:
  - **Access Guide handoff** — you package evidence so well that the partner team can act without re-discovering the target
  - **Capability handoff** — you deploy the partner team's **tool** into your foothold and let them drive
- Capability handoff is powerful and **dangerous**: you are now running someone else's code on a target that is still nominally your responsibility
- CPT rule of thumb: the Access Guide must be good enough that the partner team could act **without** the capability handoff — the implant is an accelerator, not a crutch
- Include the expansion rationale (scan vs plant) so partners understand how evidence was produced and where uncertainty remains

**Instructor Notes:**

- **Image Prompt:** A two-lane diagram. Top lane labeled "Access Guide Handoff" shows a completed guide flowing from a CPT operator to a partner team icon. Bottom lane labeled "Capability Handoff" shows the partner team's implant icon flowing back into the adversary stack via the CPT foothold.
- **Say:** "Handoff has two shapes. Access Guide handoff is you writing technical and behavioral context so clearly that another team can execute immediately. Capability handoff is you taking that team's tool and planting it in the position you already hold. Always produce the Access Guide first; only add capability handoff when partner mission need requires it."
- **Show:** The two-lane diagram; linger on "Access Guide first, capability second."
- **Do:** Ask: "If a partner receives only tool access but no Access Guide, what planning errors are most likely in the first 10 minutes?" Use answers to reinforce why guide quality comes first.
- **Ask (Q):** If a partner receives only tool access but no Access Guide, what planning errors are most likely in the first 10 minutes?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 5: The Access Guide — What a Partner Team Actually Needs (8 min)

- **Target identity** — hostname, domain (if any), IPs, OS/kernel, key users
- **Access story** — how you got in, what credentials/tokens/sessions you are holding, and how long they last
- **Current posture** — what you have enumerated, what you have already changed (prior local effects go here), what you have **not** touched
- **Expansion method and findings** — what follow-on method you chose (scan or plant), what it produced, and confidence level
- **Adversary tempo** — cadence observed, next expected action, time-to-detect estimate
- **Partner tasking** — what specifically you want them to do once they have their implant in place
- **Rollback plan** — how to remove partner capability cleanly if mission direction changes

**Instructor Notes:**

- **Image Prompt:** A seven-section form/template graphic titled "Access Guide." Each section labeled with one of the seven bullets plus a one-line "what goes here" prompt.
- **Say:** "Write this template down. You will fill it in when you produce a partner Access Guide. This is not paperwork for its own sake — these seven sections are the questions a partner team will ask you in a five-minute sync call. If you cannot answer them crisply, they will not take the handoff, or worse, they will take it and do something you did not expect. The rollback plan is the section people skip and regret."
- **Show:** The seven-section template.
- **Do:** On the whiteboard, start a blank handoff template using the current foothold as the example target. Have the room call out what goes in each section. Tell them later Access Guide work will grade them against this template.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 6: Documentation Discipline — Characterize the Target and Actor Precisely (8 min)

- Extending effects are only as good as the evidence quality you record
- Your Access Guide must capture both:
  - **Technical characteristics** — host/user/process/network/tooling details
  - **Behavioral characteristics** — cadence, handling pattern, likely next action
- Poor characterization creates partner rework and can delay action windows
- Expansion decisions must be explicit so partners can reproduce or challenge your findings
- Checklist before any extending-effect execution:
  1. Technical artifacts captured and timestamped
  2. Behavioral observations captured with confidence notes
  3. Expansion method selected (scan or plant) and justified
  4. Callback / implant destination validated
  5. Next-action estimate written in the five-line report

**Instructor Notes:**

- **Image Prompt:** A five-box checklist graphic with header "Pre-Execution Documentation Check." The five boxes are the five checklist items from the slide.
- **Say:** "Today I am grading your characterization quality. A partner team acts on what you documented, not on what you meant. If technical artifacts are incomplete, behavioral observations are vague, or your expansion method is unexplained, you force rediscovery and lose tempo. Five-item check: technical evidence, behavioral evidence, method justification, validated destination, and next-action estimate. If any one is missing, stop and complete the record first."
- **Show:** The checklist graphic with the red header.
- **Do:** Run a dry check: pick one student at random, give them a notional action ("deploy the partner RAT to `adv-c2`"), and have them read the five-item documentation check aloud against it. Correct any missing items.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Tracking and Partner Handoff Practice (8 min)

- **Adversary tracking** — run on-target survey from your current foothold, then expand with deliberate follow-on collection to produce tracking-grade telemetry
- **Handoff and partner RAT deploy** — produce an Access Guide and deploy an instructor-provided RAT binary into the adversary foothold, validating callback and documenting expected partner next actions
- Both labs are graded on the **effect report** plus the **Access Guide** (handoff practice only)
- End-of-day transition is the pivot to agentic operations — **the adversary also automates**

**Instructor Notes:**

- **Image Prompt:** Adversary collection-workflow stack (collection nodes, queue, parser, analyst destination — not an ATT&CK kill-chain ladder). Survey icon on the current foothold node. Branch markers to "Scan Path" and "Plant Path (Optional)." Partner-team implant icon dropping onto a node labeled adv-c2. No lecture names, no Module IDs, no Recon/Initial Access/Execution stage labels.
- **Say:** "Two practices, both in extending territory. Tracking starts with on-target survey and then deliberate expansion. Handoff is a live implant plus a complete Access Guide. Later this Block, the adversary runs these same playbooks with SI help."
- **Show:** The annotated stack diagram.
- **Do:** Hand out the adversary-tracking student brief. Remind them that precision in collection and reporting is graded, not just successful callback. Break 15 minutes, then release to the lab.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Wrap — Transition to Agentic Operations (8 min)

- You have now run the effects arc at least once: **degrade / disrupt / deny**, **deceive / manipulate**, **reconnoiter (survey)**, **handoff**
- Tomorrow: the adversary is doing all of this too, but faster — because they are using agents
- You will spend three days building the same automation layer they are using, then counter-striking it
- Tonight's read-ahead: `../Agentic Lesson Part 1 Outline.md` and the first half of `../AI Part 1 Lecture Content.md`

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Look at what you ran in two days. Deny-or-degrade language on collection, deception on their analysis, reconnoiter via disciplined survey, then handoff when partners need to execute at tempo. One adversary stack. Human-paced. Now imagine an adversary running the same arc against you with a local LLM picking targets, tool-calling into your environment, and rewriting its own C2 on the fly. That is what later adversary-agent practice ends against. The only way you get good at defeating that is to build one first — which is what the next lectures start."
- **Show:** A simple four-box checklist labeled with the four doctrinal buckets from the slide bullets; check them all.
- **Do:** Collect the five-line effect reports and handoff packages. Tell students these reports become later retrieval context — their own work becomes the agent's knowledge base. Dismiss.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M09-persistent-effects-handoff is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** At your home unit, where does a partner team usually get stuck first: incomplete technical detail, unclear behavioral context, or both?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** Which of these four buckets is usually weakest in your team handoffs, and what mission risk does that create?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** Name one handoff decision your partner cannot make yet, then pick scan or plant and defend your choice in one sentence.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
