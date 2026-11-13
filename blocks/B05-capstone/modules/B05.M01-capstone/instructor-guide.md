---
id: B05.M01-ig
title: Capstone Assessment — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B05
module_type: assessment
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# CounterStrike Capstone Assessment — Instructor Guide (4-Phase Model)

**Version:** June 2026
**Classification:** FOUO
**Purpose:** Facilitation, differentiated-path handling, Access Guide framing, and safety notes for the 4-phase capstone. Exploitation paths, PoCs, and rubric validation criteria live in [`answer-key.md`](./answer-key.md).

## Objective and context

This capstone follows a phased approach based on realistic commander’s orders. It includes a **differentiated path** to accommodate varying student skill levels:

- Strong students can push all the way to redspace exploitation and D4M.
- Students who struggle with redspace access in Phase 3 execute a high-quality handoff (using the 7-section Access Guide) and receive access back in Phase 4.

**Core References:**
- JQS.txt (all objectives)
- `Attacker_Activity/01_Attacker_Activity_Overview.md` (documented attacker paths)
- `Exploit_Playbooks/Capstone Exploit details.md` (detailed PoCs)
- Issued Access Guide template (handoff lecture)

**D4M Philosophy (Phase 3):**
MILDEC via data manipulation on exfil’d files is one strong option. However, **any D4M option with meaningful operational thought** that supports friendly collection or degrades enemy capability meets JQS requirements. Students may be creative with exfil document contents.

Do not project PoC commands or CVE-specific exploit steps. Those stay in the answer key.

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "Four phases, commander’s orders each day. Strong teams may reach redspace. Teams that cannot still succeed by producing a complete Access Guide handoff."
- **Do:** Put the differentiated-path contract on the board. Confirm Access Guide section list is visible.
- **Ask (Q):** What must a struggling team still produce in Phase 3?
- **Expected Response (A):** A full 7-section Access Guide and a reentry method, complete by NLT 1200.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Four phases, commander’s orders each day. Strong teams may reach redspace. Teams that cannot still succeed by producing a complete Access Guide handoff."
- **Show:** Phase list and commander intent summaries (not exploit paths).
- **Do:** Confirm range access and JQS/rubric packet before Phase 1 recon.
- **Ask (Q):** What must a struggling team still produce in Phase 3?
- **Expected Response (A):** A full 7-section Access Guide and a reentry method, complete by NLT 1200.

## Instructor resources and pre-class preparation

- Answer key / PoCs: [`answer-key.md`](./answer-key.md)
- Rubric: [`rubric.md`](./rubric.md)
- Student brief: [`student-brief.md`](./student-brief.md)
- JQS and exploit playbooks named in Core References
- Weird File (backup) is an instructor-only file for when the deployed network is wrong. It is there if needed. Hopefully it will not be needed.
- Do not project flags, tokens, or PoC payloads

## Student resources and environment

- Student brief and supporting documents in this Module folder
- Assigned capstone range; live addressing from the instructor / range card
- Differentiated path: handoff in Phase 3 if redspace access is not achieved

## Facilitation flow

### Step 1: Phase 1 — Reconnoiter greyspace and planning (5 hours)

- **Say:** Commander's intent: On Order reconnoiter enemy greyspace in order to identify avenues of approach. Upon discovery of initial access vectors/opportunities, be prepared to provide COAs to the commander to achieve initial access.
- **Show:** Student brief Phase 1 products. Do not name CVEs or host roles.
- **Do:** Focus on reconnaissance discipline and planning quality. No exploitation in this phase.
- **Ask (Q):** What is in-scope for Phase 1?
- **Expected Response (A):** Recon and planning products only — METT-TC, terrain, CoG/CV, draft exploitation plan, CAD. No exploitation.

### Step 2: Phase 2 — Initial access, greyspace survey, handoff prep (5 hours)

- **Say:** NLT end of day exploit discovered vulnerability and achieve initial access. Upon gaining initial access to greyspace reconnoiter terrain in order to provide the commander with COAs to achieve D4M or access into redspace. Be prepared to hand off access to supporting higher echelon unit.
- **Show:** 4-bucket Situational Awareness Package list. Live exploit steps stay in the answer key.
- **Do:** All students should reach initial access + survey. Begin assessing handoff readiness.
- **Ask (Q):** What survey product is required after access?
- **Expected Response (A):** The 4-bucket SA package (Technical State, Behavioral Indicators, Attribution & Tracking, Expansion Leads) plus early Access Guide work.

### Step 3: Phase 3 — D4M, red-net recon, or handoff (5 hours)

- **Say:** Gain access to redspace in order to achieve source range D4M OR handoff access if unable. NLT 1200 be prepared to transfer access.
- **Show:** Differentiated path: strong students push to redspace; others execute the Access Guide.
- **Do:** Any D4M option with meaningful operational thought meets JQS. Time-box the NLT 1200 handoff.
- **Ask (Q):** What constitutes a successful Phase 3 for a team that cannot reach redspace?
- **Expected Response (A):** Meaningful D4M on the redirector, red-net recon notes, and a complete 7-section Access Guide with reentry.

### Step 4: Phase 4 — Redspace recon, D4M options, hot wash (5 hours)

- **Say:** Upon receipt of access into redspace, reconnoiter redspace terrain in order to provide D4M options to the commander.
- **Show:** Survey focus: exfil workflow Redirector → C2 → Operator Box. The teacher-only page Capstone lure data flow is that path. The teacher-only page Capstone red operator environment is the live demo: a blue-workstation file, a payload hosted for kali-red to fetch, and the red action log. Verbal hot wash, no required slides. Do not project Capstone exploit details.
- **Do:** Instructors provide the initial access method when returning access on the differentiated path. Require instructor approval for deep red-net effects.
- **Ask (Q):** What must the hot wash cover?
- **Expected Response (A):** Actions across all phases, methods (access paths and D4M), and operational rationale — especially D4M and handoff choices.

## Timing

Follow the capstone calendar. Protect the Phase 3 NLT 1200 handoff window.

## Common stalls

- Teams exploit in Phase 1 — stop them; recon and planning only.
- Teams treat D4M as destruction — redirect to meaningful operational thought.
- Incomplete Access Guide — walk the seven sections without giving exploit steps.
- Red-net effects without instructor approval — stop and reset to approval.

## Lesson summary

- Four commander-ordered phases with a differentiated redspace path.
- Quality handoff documentation and thoughtful effects outrank maximum destruction.
- PoCs and validation criteria remain in the answer key.

## Questions and check on learning

- **Ask (Q):** What must never happen without instructor approval?
- **Expected Response (A):** Deep effects or actions on red-net.
- **Ask (Q):** What are the seven Access Guide sections?
- **Expected Response (A):** Target Identity, Access Story, Current Posture, Expansion Method and Findings, Adversary Tempo, Partner Tasking, Rollback Plan.

## Quick Reference: Access Guide (7 Sections)

When students hand off access, they must be able to produce the following:

1. **Target Identity** — Hostname, IPs, OS/kernel, key users, domain (if any).
2. **Access Story** — Fully detailed and repeatable method of how access was gained (step-by-step with commands/tools used).
3. **Current Posture** — What has been enumerated, what effects have already been applied, what remains untouched.
4. **Expansion Method and Findings** — What follow-on method was used (scan or plant) and what it produced, including confidence level and justification.
5. **Adversary Tempo** — Observed cadence of activity, next expected action, time-to-detect estimate, and behavioral patterns (e.g., how they handle exfil failures).
6. **Partner Tasking** — Specific actions desired from the receiving team once they have access (e.g., "Establish persistent C2 on C2 host and map exfil pipeline to Operator Box").
7. **Rollback Plan** — How to cleanly remove any deployed capability (e.g., remove persistence, kill processes, clear logs) if mission direction changes.

## Safety and ROE Notes

- Any effects or deep actions on red-net require explicit **instructor approval**.
- Instructors will provide the initial access method when returning access in Phase 4.
- Students are responsible for documenting clean reentry methods when handing off.
- Emphasis is on **thoughtful effects** and **quality handoff documentation** rather than maximum destruction.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Rubric: [`rubric.md`](./rubric.md)
- Answer key / exploitation paths: [`answer-key.md`](./answer-key.md)
- Teacher-only Moodle pages: Capstone lure data flow, Capstone red operator environment, Capstone exploit details
- Range readiness and reset: [`../../../../course/operations/capstone-readiness-verification.md`](../../../../course/operations/capstone-readiness-verification.md)
- PCTE stack identity: [`../../../../course/operations/pcte-range-specifications.md`](../../../../course/operations/pcte-range-specifications.md) (`capstone`)
- Source inventory (in-repo vs missing): [`../../missing-references.md`](../../missing-references.md)
