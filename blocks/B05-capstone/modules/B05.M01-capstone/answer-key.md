---
id: B05.M01-key
title: Capstone Assessment — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B05
module_type: assessment
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# Capstone Assessment — Instructor Answer Key

## Objective and starting context

Instructor-only exploitation paths, PoCs, and rubric validation criteria for the 4-phase capstone. Facilitation, commander-intent delivery, Access Guide framing, and safety notes live in [`instructor-guide.md`](instructor-guide.md).

Do not project this file. Detailed PoCs also live in `Exploit_Playbooks/Capstone Exploit details.md`.

## Flag / reference table

| Item | Default / expected | Notes |
| --- | --- | --- |
| Collector | `198.51.100.200` | Identification is a Phase 1 validation criterion |
| Red-net | `172.15.x.x` | Confirm live range card |
| Redirector roles | Nginx → Next.js/Tomcat | Phase 1 recon finding |
| SFTP user | `intake` | Collector/redirector; key reuse to root |
| Primary Phase 2 path | Next.js storefront | CVE-2025-29927 + CVE-2025-55182 |
| Alternate Phase 2 | Tomcat CVE-2025-24813; Webmin CVE-2019-15107 | See walkthrough |
| Phase 4 primary host | C2 / teamserver via Webmin | Operator Box is stretch |

Rotate live addressing from the range card. Grade against the live deployment.

## Initial situational awareness

Students establish SA on the ops station and then on each newly accessed host. After initial access, require the 4-bucket package: Technical State, Behavioral Indicators, Attribution & Tracking, Expansion Leads. Docker socket detection on greyspace hosts is a critical survey finding.

## Instructor live walkthrough

### Phase 1 — Detailed exploitation paths (instructor awareness only)

Students should discover the following **5 primary paths** into greyspace during reconnaissance. Do not open class with these names.

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

**JQS Requirements Primarily Met:** 1–16, 51–53, 59–68, 76–91, 124, 130–138.

**Validation Criteria (Tied to Rubric):**
- Identification of redirector (Nginx → Next.js/Tomcat), collector (`198.51.100.200`), and edge forwards.
- Active/vuln/wordlist scanning with service and version identification.
- Completed METT-TC, OCOKAW terrain analysis, CoG/CV identification, and draft exploitation plan.
- D3FEND CAD diagram of Silent Sync intrusion.
- Evidence of LLM/RAG usage for analysis or TTP mapping.

### Phase 2 — Exploitation paths and PoCs

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

**JQS Requirements Primarily Met:** 17–34, 92–107.

**Validation Criteria (Tied to Rubric):**
- Evidence of successful initial access (shell as root on redirector or teamserver).
- Immediate and thorough host survey (Docker socket detection is critical).
- Completed **4-bucket Situational Awareness Package**.
- Early Access Guide work and reentry method documented.

### Phase 3 — Expected findings and differentiated path

**1. D4M on Redirector**
- Any D4M option with meaningful operational thought meets JQS requirements.
- Example: MILDEC via modification of exfil'd files with regex date switching via a recurring method like a cron job or modification of existing adversary shell scripts.

**2. Red-Net Recon from Foothold**
- Students should perform active scanning and vulnerability gathering on red-net (`172.15.x.x`).
- **Expected Finding:** Webmin (CVE-2019-15107) on the C2/teamserver.
- Students should note the CVE and provide a potential PoC note for the senior operator.

**3. Handoff Execution (if not pushing to redspace)**
- Full 7-section Access Guide.
- Reentry method for the senior operator/instructor.
- Complete by NLT 1200.

**Differentiated Path Handling:**
- **Strong students:** Identify and exploit Webmin on C2 to gain redspace access.
- **Students who struggle:** Execute high-quality handoff. Instructor gains redspace access and returns it in Phase 4.

**JQS Requirements Primarily Met:** 43–50, 54–58, 116–129.

**Validation Criteria (Tied to Rubric):**
- D4M action on redirector demonstrates meaningful thought (instructor judgment).
- Red-net active recon completed with Webmin CVE noted + PoC suggestion.
- Full Access Guide produced (if handing off).

### Phase 4 — Redspace expected products

**Access Target:**
- Primary host: **C2 / Teamserver** (gained via Webmin CVE-2019-15107).
- Secondary objective: Gain access to the **Operator Box** (second asset in red-net).
- Note depth of access achieved (C2 only vs. C2 + Operator Box).

**Survey Focus Areas (Must Be Briefed):**
- Exfil workflow from Redirector → C2 → Operator Box.
- Scripts responsible for moving exfil archives between these systems.
- Overall enemy terrain understanding (how the adversary moves data and maintains C2).

**Validation Criteria (Tied to Rubric):**
- Redspace reconnaissance completed (C2 minimum; Operator Box is stretch goal).
- Clear briefing of enemy terrain and exfil workflow understanding.
- D4M options developed and presented with operational thought.

## Troubleshooting / confirmation

- If Phase 1 teams name CVEs without scan evidence, redirect to service/version output.
- If Phase 2 access fails, confirm they are on the live redirector (not a remembered IP) and check Docker socket after any container shell.
- If Phase 3 handoff is thin, grade against the seven Access Guide sections in the instructor guide — do not fill exploit steps for them.
- If Phase 4 access is returned by the instructor, document the method given and still require survey + D4M options.
- Live addressing may differ from examples here. Trust the range card.

## Grading checkpoints

Use [`rubric.md`](rubric.md) as the primary instrument. Map evidence as follows:

| Phase | Acceptable evidence |
| --- | --- |
| 1 | Redirector/collector/edge-forward identification; planning packet; CAD; no exploitation |
| 2 | Root shell on redirector or teamserver; 4-bucket SA; reentry notes |
| 3 | Meaningful D4M; red-net recon with Webmin note; Access Guide if handing off |
| 4 | Redspace survey (C2 min); exfil workflow briefed; D4M options with operational thought |
