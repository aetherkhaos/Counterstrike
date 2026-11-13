---
id: B01.M01
title: Course Introduction
artifact_type: content_guide
audience: instructor
block: B01
module_type: lecture
legacy_aliases:
- legacy/week1/content-guides/0. Course Introduction Content Guide.md
source_status: canonical
review_required: false
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
---

# Course Introduction — Content Guide

**Source:** `archive/provenance/lecture.md`
**Audience:** Cyber Protection Team (CPT) operators and adjacent defensive operators transitioning from blue-space hunting into DCO-RA.
**Duration:** ~30 minutes. First Module of the course.
**Prerequisites:** None. First lecture of the course.
**References:**

- `archive/provenance/lecture.md`
- `../../../../Course Overview.md`
- Joint Publication 3-12 (Cyberspace Operations) — the DCO-RA definition block

## Instructor resources and pre-class

- Classroom projector and screen
- Whiteboard and markers (roster on the board; mindset rule stays up for the Modules that follow)
- Instructor copy of `Course Overview.md` for the Slide 5 preview and Slide 7 handoff
- JP 3-12 DCO-RA definition block ready to project on Slide 3

## Student resources

- Student copy of `Course Overview.md` (roadmap reference)
- No additional student kit for this lecture

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Welcome to the Counter Strike Operator Course. You were selected for this course. We will operate as a class, not as spectators."
- **Do:** Room check-in on the whiteboard: name, unit, one-sentence current role. Then ask one bonus question you invent on the spot. Do not use a scripted list. Write the mindset rule and leave it up for the Modules that follow: "We are conducting operations against the enemy. We are defending our terrain. They are attacking ours. We are striking back against theirs."
- **Ask (Q):** Name, unit, and one-sentence current role.
- **Expected Response (A):** Facilitation only. Capture what they say; no target answer. Use the board later for team assignments.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Welcome to the Counter Strike Operator Course. You were selected for this course. We will operate as a class, not as spectators."
- **Show:** Title slide. Point to the words "Counter Strike Operator."
- **Do:** Keep the same check-in verbally if a whiteboard is not available; still capture name, unit, and role. Ask one bonus question you invent on the spot. Do not use a scripted list.
- **Ask (Q):** Name, unit, and one-sentence current role.
- **Expected Response (A):** Facilitation only. Capture what they say; no target answer.

---

### Slide 1: Welcome to the Counter Strike Operator Course (4 min)

- You were selected; this is not an accident
- We will operate as a class, not as spectators
- Expect doctrine, hands-on labs, and scenarios — in that order

**Instructor Notes:**

- **Image Prompt:** A clean title slide with a stylized shield crossed with a sword over a faint network topology; dark navy background with muted gold accents, professional military aesthetic. Text field left blank so the title can be overlaid.
- **Say:** "Welcome to the Counter Strike Operator Course. You were selected for this course. We will operate as a class, not as spectators."
- **Show:** Title slide. Point to the words "Counter Strike Operator."
- **Do:** Quick room check-in — have each student give name, unit, and one-sentence current role. Then ask one bonus question you invent on the spot as an icebreaker. Do not put that question on the slide. Capture the roster on the whiteboard; you will reference it when making team assignments in a later Module.
- **Ask (Q):** Name, unit, and one-sentence current role.
- **Expected Response (A):** Facilitation only. Capture what they say on the board; no target answer.

### Slide 2: How You Will Access the Course (4 min)

- PCTE — range and lab access
- Moodle — course materials and submissions

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "You will use two systems. PCTE is where the range and labs live. Moodle is where the course materials and submissions live. Those are the only two we will walk through."
- **Show:** The two bullets. Text only. Do not add a graphic.
- **Do:** Walk the sign-in path for PCTE, then Moodle. Do not open HTB Academy, chat, or source-control sites.
- **Ask (Q):** Which two systems will you use for this course?
- **Expected Response (A):** PCTE and Moodle.

### Slide 3: What is DCO-RA? (6 min)

- JP 3-12 definition (read aloud, verbatim):
  - Actions taken **external to the defended network**
  - Conducted **without the permission of the owner** of the affected system
  - **May rise to the level of use of force**
  - Conducted in support of **defending forward** and persistent engagement
- This is not hunting. This is response action beyond the wire.

**Instructor Notes:**

- **Image Prompt:** A simple two-panel diagram. Left panel labeled "Blue Space" showing a defended enclave behind a perimeter. Right panel labeled "Gray / Red Space" showing terrain outside that perimeter with faint adversary indicators. An arrow labeled "DCO-RA" crosses from left to right through the perimeter.
- **Say:** "Read this paragraph slowly. Every phrase in it is deliberate. Pay attention to the four bolded phrases — they each redefine what you are allowed and expected to do compared to blue-space hunting."
- **Show:** Project the full JP 3-12 paragraph, then walk through each of the four key phrases one at a time.
- **Do:** Let two or three students answer. This surfaces the mindset gap the Modules that follow will close.
- **Ask (Q):** Which of those four phrases is most different from what you did last week at your home unit?
- **Expected Response (A):** Facilitation only. Do not grade a correct phrase. Use the answers to name the gap between hunt work and DCO-RA.

### Slide 4: Where You Are Coming From (3 min)

- Most of you have spent your careers inside blue-space
- You have been explicitly forbidden from "reaching out and touching" gray or red
- Your instincts are tuned for detection, containment, and reporting
- We are going to keep those instincts and add new ones

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "If you are in this course, you have probably spent the majority of your time looking down and in at blue-space. You have been told — correctly, up to this point — that you do not touch gray or red. That rule is not wrong, but it is about to get more nuanced."
- **Show:** The bullet list; linger on the phrase "reaching out and touching."
- **Do:** Ask for a show of hands, then acknowledge the experience — it validates the audience and sets up why the course exists.
- **Ask (Q):** Who here has ever been told to stop pivoting because they were about to leave the enclave?
- **Expected Response (A):** Facilitation only. Hands, not a scored answer. Acknowledge the experience.

### Slide 5: Purpose of This Course (4 min)

- Take operators who have almost exclusively operated in blue-space
- Give them the skills to operate **up and out** from blue-space
- Build the doctrinal frame first, then the tradecraft
- By end of course: plan, justify, and execute a DCO-RA mission with discipline

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "The purpose of this course is simple to state and hard to deliver. We take you from blue-space and give you the skills to operate up and out. The opening Modules build the doctrinal frame. Later Modules build the tradecraft, then the automation layer. By the end you should be able to plan and justify a response action, not just execute one."
- **Show:** Each bullet in sequence.
- **Do:** Preview the Module sequence from `Course Overview.md` at a high level. Stay on themes. Do not walk later Module tasking.
- **Ask (Q):** In one sentence, what is this course trying to do with operators who have worked almost exclusively in blue-space?
- **Expected Response (A):** Facilitation only. Steer toward skills to operate up and out, and toward planning and justifying a response action. Do not require verbatim wording.

### Slide 6: What This Course Is Not (4 min)

- **Not** a hunt course — we assume the hunt has already succeeded
- We start from: "you have eyes on the adversary — now what?"
- We will borrow from industry DFIR only where military doctrine has a gap
- We will **not** shoehorn cyber into every tactical-task definition

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "This course is not a hunt course. We assume you already know how to hunt, and we are starting from the position that the hunt has been successful. We will hit concepts that will make you better at hunting, but hunting is not the point. The point is what you do once you have found the enemy."
- **Show:** The "Not a hunt course" bullet, prominently.
- **Do:** State the mindset rule out loud. If it is not already on the board from the opening, write it and leave it up for the Modules that follow: "We are conducting operations against the enemy. We are defending our terrain. They are attacking ours. We are striking back against theirs."
- **Ask (Q):** If the hunt has already succeeded, what is the starting position of this course?
- **Expected Response (A):** Facilitation only. Steer toward "you have eyes on the adversary — now what?" Hunting is not the point.

### Slide 7: Course Roadmap (5 min)

- **B01** — Military tactical planning in cyber operations (you are here)
- **B02** — Maneuvering to the target
- **B03** — Situational awareness in different operating contexts
- **B04** — Effects and agentic operations
- **B05** — Capstone

**Instructor Notes:**

- **Image Prompt:** A horizontal five-step roadmap graphic. Each step is a numbered tile labeled B01 through B05, with one-word themes underneath (Planning, Maneuver, On-Target, Effects, Capstone). Do not use Week or L3 labels. Clean minimalist style.
- **Say:** "Here is the whole arc. B01 is doctrine-heavy on purpose — the later Modules assume you can think and talk in this language. If you catch yourself feeling impatient to get to a keyboard, hold on; that impatience is exactly what we are building the planning muscle to resist."
- **Show:** The roadmap graphic; point to B01 and say "this is where we live for this Block."
- **Do:** Transition to the next Module, the scenario brief. Tactical planning is a later Module in this Block: the same planning process a second lieutenant uses for a ground convoy, adapted for cyberspace.
- **Ask (Q):** If you feel impatient to get to a keyboard, what is B01 actually building?
- **Expected Response (A):** Facilitation only. Steer toward planning language the later Modules assume. Then hand off to the scenario brief.

## Lesson summary

- Operators who have worked almost exclusively in blue-space learn to operate up and out.
- DCO-RA (JP 3-12) is response action beyond the wire, not hunting. The starting position is eyes on the adversary — now what?
- Course access is PCTE and Moodle.
- B01 is doctrine and planning foundations on purpose. The next Module is the scenario brief.

## Questions and check on learning

- **Ask (Q):** What is the difference between this course and a hunt course?
- **Expected Response (A):** Facilitation only. Steer toward hunt-already-succeeded / eyes on the adversary — now what? Do not treat hunting as the course point.
- **Ask (Q):** Which JP 3-12 phrases redefine the work compared with blue-space hunting?
- **Expected Response (A):** Facilitation only. Students may name any of the four: external to the defended network; without the owner's permission; may rise to the level of use of force; in support of defending forward and persistent engagement.
- **Ask (Q):** Which two systems will you use for range access and for course materials?
- **Expected Response (A):** PCTE and Moodle.
- **Ask (Q):** What comes next after this opening Module?
- **Expected Response (A):** Facilitation only. Steer toward the scenario brief. Tactical planning follows in a later Module.
