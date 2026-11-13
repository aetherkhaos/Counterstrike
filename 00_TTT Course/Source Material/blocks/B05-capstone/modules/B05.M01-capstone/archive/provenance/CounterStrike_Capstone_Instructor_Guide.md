---
id: B05.M01.instructor-guide
title: Capstone Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B05
legacy_aliases:
- legacy/week5/CounterStrike_Capstone_Instructor_Guide.md
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- docx
- pdf
sensitivity: course_internal
---
# CounterStrike Capstone Assessment — Instructor Guide (4-Phase Model)

**Version:** June 2026  
**Classification:** FOUO  
**Purpose:** Provide instructors with high-level exploitation paths, validation criteria, differentiated path handling, and JQS traceability for the 4-phase capstone.

---

## Overview and Structure

This capstone follows a phased approach based on realistic commander’s orders. It includes a **differentiated path** to accommodate varying student skill levels:

- Strong students can push all the way to redspace exploitation and D4M.
- Students who struggle with redspace access in Phase 3 execute a high-quality handoff (using the 7-section Access Guide) and receive access back in Phase 4.

**Core References:**
- JQS.txt (all objectives)
- `Attacker_Activity/01_Attacker_Activity_Overview.md` (documented attacker paths)
- `Exploit_Playbooks/Capstone Exploit details.md` (detailed PoCs)
- Lesson_4.2_Adversary_Handoff.pptx (Access Guide template)

**D4M Philosophy (Phase 3):**  
MILDEC via data manipulation on exfil’d files is one strong option. However, **any D4M option with meaningful operational thought** that supports friendly collection or degrades enemy capability meets JQS requirements. Students may be creative with exfil document contents.

---

## Phase 1: Reconnoiter Greyspace & Planning

**Commander’s Intent (given to students):**
> On Order reconnoiter enemy greyspace in order to identify avenues of approach. Upon discovery of initial access vectors/opportunities, be prepared to provide COAs to the commander to achieve initial access.

### Detailed Exploitation Paths (for Instructor Awareness)

Students should discover the following **5 primary paths** into greyspace during reconnaissance:

1. **Next.js Storefront (CVE-2025-29927 + CVE-2025-55182)**  
   - Middleware authentication bypass via `x-middleware-prefetch: 1` header.
   - Leads to React Server Components RCE.

2. **Tomcat Backend (CVE-2025-24813)**  
   - Path equivalence vulnerability allowing deserialization RCE.

3. **Webmin on Teamserver (CVE-2019-15107)**  
   - Unauthenticated RCE via `password_change.cgi` (exposed via edge forwarding on port 10000).

4. **Collector / Redirector SFTP Exposure**  
   - `intake` user SFTP access (from exfil workflow in threat report).

5. **SSH Key Reuse (Discovered in Testing)**  
   - The SSH key configured for the `intake` SFTP user on the collector/redirector can be reused to SSH directly as **root**.

**JQS Requirements Primarily Met:**
- 1–16, 51–53, 59–68, 76–91, 124, 130–138 (Reconnaissance, Tactical Planning, D3FEND CAD, AI tool integration).

**Validation Criteria (Tied to Rubric):**
- Identification of redirector (Nginx → Next.js/Tomcat), collector (198.51.100.200), and edge forwards.
- Active/vuln/wordlist scanning with service and version identification.
- Completed METT-TC, OCOKAW terrain analysis, CoG/CV identification, and draft exploitation plan.
- D3FEND CAD diagram of Silent Sync intrusion.
- Evidence of LLM/RAG usage for analysis or TTP mapping.

**Instructor Notes:**
Focus on reconnaissance discipline and planning quality. No exploitation in this phase.

---

## Phase 2: Initial Access & Greyspace Survey + Handoff Preparation

**Commander’s Intent:**
> NLT end of day exploit discovered vulnerability and achieve initial access. Upon gaining initial access to greyspace reconnoiter terrain in order to provide the commander with COAs to achieve D4M or access into redspace. Be prepared to hand off access to supporting higher echelon unit.

### Detailed Exploitation Paths & PoCs

**Primary Recommended Path – Next.js Storefront:**
- Use header bypass: `curl -H "x-middleware-prefetch: 1" http://<redirector>/staff`
- Trigger RCE using the PoC from `Capstone Exploit details.md` (mkfifo + nc reverse shell payload).
- Post-shell: Execute `/tmp/.escape.sh` or manual Docker socket escape to gain root on redirector host.

**Alternative Path – Tomcat:**
- Use ysoserial + CVE-2025-24813 PoC script (detailed in `Capstone Exploit details.md`).
- Achieve RCE → Docker socket escape to host root.

**Alternative Path – Webmin (Teamserver):**
- Use `curl` POST to `/password_change.cgi` with command injection in the `old` parameter (see `Capstone Exploit details.md` for exact syntax).
- Container escape via mounted Docker socket.

**JQS Requirements Primarily Met:**
- 17–34, 92–107 (Initial access TTPs, code execution in correct environments, priv esc, host survey, discovery TTPs).

**Validation Criteria (Tied to Rubric):**
- Evidence of successful initial access (shell as root on redirector or teamserver).
- Immediate and thorough host survey (Docker socket detection is critical).
- Completed **4-bucket Situational Awareness Package**:
  - Technical State
  - Behavioral Indicators
  - Attribution & Tracking
  - Expansion Leads
- Early Access Guide work and reentry method documented.

**Instructor Notes:**
All students should reach initial access + survey. Begin assessing handoff readiness and decision-making quality.

---

## Phase 3: D4M on Redirector + Red-Net Recon + Handoff Execution

**Commander’s Intent:**
> Gain access to redspace in order to achieve source range D4M **OR** handoff access if unable. NLT 1200 be prepared to transfer access.

### Key Actions

**1. D4M on Redirector**
- **Any D4M option with meaningful operational thought** meets JQS requirements. Creativity is encouraged as long as it supports friendly collection or degrades enemy capability.
- **Example:** MILDEC via modification of exfil'd files with regex date switching via reoccuring method like a cron job or modification of exsisting adversary shell scripts. This creates false meeting data that enables friendly HUMINT/SIGINT collection while exposing adversary HUMINT operators.

**2. Red-Net Recon from Foothold**
- Students should perform active scanning and vulnerability gathering on red-net (172.15.x.x).
- **Expected Finding:** Webmin (CVE-2019-15107) on the C2/teamserver.
- Students should note the CVE and provide a potential PoC note for the senior operator.

**3. Handoff Execution (if not pushing to redspace)**
- Students must complete the **full 7-section Access Guide** (see Quick Reference below).
- Create a reentry method for the senior operator/instructor.
- Handoff must be complete by NLT 1200.

**Differentiated Path Handling:**
- **Strong students:** Identify and exploit Webmin on C2 to gain redspace access.
- **Students who struggle:** Execute high-quality handoff. Instructor gains redspace access and returns it in Phase 4.

**JQS Requirements Primarily Met:**
- 43–50, 54–58, 116–129 (Effects/D4M, active defense concepts, handoff).

**Validation Criteria (Tied to Rubric):**
- D4M action on redirector demonstrates meaningful thought (instructor judgment).
- Red-net active recon completed with Webmin CVE noted + PoC suggestion.
- Full Access Guide produced (if handing off).

---

## Phase 4: Redspace Recon + D4M Options Development + Hot Wash

**Commander’s Intent:**
> Upon receipt of access into redspace, reconnoiter redspace terrain in order to provide D4M options to the commander.

### Key Actions

**Access Target:**
- Primary host: **C2 / Teamserver** (gained via Webmin CVE-2019-15107).
- Secondary objective: Gain access to the **Operator Box** (second asset in red-net).
- Note depth of access achieved (C2 only vs. C2 + Operator Box).

**Survey Focus Areas (Must Be Briefed):**
- Exfil workflow from Redirector → C2 → Operator Box.
- Scripts responsible for moving exfil archives between these systems.
- Overall enemy terrain understanding (how the adversary moves data and maintains C2).

**D4M Options Development:**
- Students develop and brief D4M options against redspace targets based on their survey findings.
- Emphasis on operational value to the commander.

**Hot Wash (Verbal Brief Format):**
- Students deliver a **verbal brief** describing:
  - Actions taken across all phases.
  - Methods used (especially access paths and D4M decisions).
  - Motives and operational rationale behind key decisions (particularly D4M and handoff choices).
- No formal slides required due to time constraints.

**JQS Requirements Primarily Met:**
- Final recon, D4M options, COA development, and reflection on all prior work.

**Validation Criteria (Tied to Rubric):**
- Redspace reconnaissance completed (C2 minimum; Operator Box is stretch goal).
- Clear briefing of enemy terrain and exfil workflow understanding.
- D4M options developed and presented with operational thought.

---

## Quick Reference: Access Guide (7 Sections)

When students hand off access, they must be able to produce the following:

1. **Target Identity** — Hostname, IPs, OS/kernel, key users, domain (if any).
2. **Access Story** — Fully detailed and repeatable method of how access was gained (step-by-step with commands/tools used).
3. **Current Posture** — What has been enumerated, what effects have already been applied, what remains untouched.
4. **Expansion Method and Findings** — What follow-on method was used (scan or plant) and what it produced, including confidence level and justification.
5. **Adversary Tempo** — Observed cadence of activity, next expected action, time-to-detect estimate, and behavioral patterns (e.g., how they handle exfil failures).
6. **Partner Tasking** — Specific actions desired from the receiving team once they have access (e.g., "Establish persistent C2 on C2 host and map exfil pipeline to Operator Box").
7. **Rollback Plan** — How to cleanly remove any deployed capability (e.g., remove persistence, kill processes, clear logs) if mission direction changes.

---

## Safety and ROE Notes

- Any effects or deep actions on red-net require explicit **instructor approval**.
- Instructors will provide the initial access method when returning access in Phase 4.
- Students are responsible for documenting clean reentry methods when handing off.
- Emphasis is on **thoughtful effects** and **quality handoff documentation** rather than maximum destruction.

---

*End of Instructor Guide*
