---
id: B02.M02
title: Navigating the Open-Source Ecosystem
artifact_type: content_guide
audience: instructor
block: B02
module_type: lecture
legacy_aliases:
- legacy/week2/content-guides/2.5 Navigating Open-Source Ecosystem Content Guide.md
- B02.M03
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

# Navigating the Open-Source Ecosystem — Content Guide

**Source:** This Markdown content guide is the source of truth. Instructor deck: [`slides/B02.M02_open-source-ecosystem_Instructor.pptx`](slides/B02.M02_open-source-ecosystem_Instructor.pptx). The student copy is generated at pack time.
**Audience:** CPT operators who hold service/version evidence from enumeration.
**Duration:** ~120 minutes lecture (Searchsploit and Metasploit keyboard practice follow).
**Prerequisites:** Planning pipeline and CG/CV framing; Nmap service/version output as the query key for this block. Hands-on CVE search, Searchsploit, and GitHub PoC work happen in later keyboard practice (including Vulnhub walkthroughs)—not as lecture demos.
**References:**

- [`slides/B02.M02_open-source-ecosystem_Instructor.pptx`](slides/B02.M02_open-source-ecosystem_Instructor.pptx)
- `../../archive/L2.5_Navigating_Open_Source/L2.5 Navigating The Open Source Environment.md`
- `../../activities/L2.6_Using_MSF/`
- `../../activities/L2.8_Gaining_Access/`
- `../02-info-gathering-recon/content-guide.md`

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

- **Say:** "You already have ports and versions from active recon."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** Hold up one service and version from your last Nmap run.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "You already have ports and versions from active recon."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** Hold up one service and version from your last Nmap run.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Navigating Open-Source Ecosystem for Cyber Protection Teams (2 min)

**Instructor Notes:**

- **Image Prompt:** Title slide only. A pipeline graphic: "Enumerate" → "Identify CVE" → "Locate Exploit" → "Assess Suitability" → "Initial Access." No week branding; no on-slide bullet stack.
- **Say:**
  - "You already have ports and versions from active recon."
  - "This lesson turns that evidence into a deliberate exploit path."
  - "We stay inside the open-source ecosystem: databases, repos, Searchsploit, Metasploit."
  - "Goal is not 'run the first hit'—it is select, vet, and justify."
- **Show:**
  - Trace the five-stage pipeline left to right.
- **Do:**
  - Ask: "Hold up one service and version from your last Nmap run."
  - Capture two examples on the board for the pipeline slides that follow.
- **Ask (Q):** Hold up one service and version from your last Nmap run.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Lesson Objectives (2 min)

- Identify initial access techniques from MITRE® attack
- Identify key components of an open-source ecosystem
- Recall and identify different types of vulnerabilities
- Recognize initial access opportunities

**Instructor Notes:**

- **Image Prompt:** Four objective tiles in a row mirroring the four bullets on this slide (MITRE initial access; ecosystem components; vulnerability types; access opportunities).
- **Say:**
  - "Read these objectives as written—they are the contract for this block."
  - "Identify initial access techniques from MITRE attack."
  - "Identify key components of an open-source ecosystem."
  - "Recall and identify different types of vulnerabilities."
  - "Recognize initial access opportunities."
  - "This block moves from passive leads and directly observed service/version evidence through vulnerability identification, exploit research, initial-access technique selection, and suitability assessment."
- **Show:**
  - Point to each objective tile as you name the matching bullet.
- **Do:**
  - Tell students to write their own one-line success check for each objective.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: From Recon to Exploitable Findings (2 min)

- Identifying exploitable vulnerabilities and finding exploits
- Builds on active recon: service/version evidence from Nmap
- Reuses passive leads to prioritize what to investigate
- Turns enumerated data into actionable exploit paths
- Supports targeted effects on adversary infrastructure (e.g., C2 disruption)

**Instructor Notes:**

- **Image Prompt:** Flow: Nmap version banner → vulnerability match → exploit candidate → planned effect on adversary node.
- **Say:**
  - "Passive leads prioritize where to look; Nmap gave you directly observed service and version evidence."
  - "Start with that observed evidence: service and version."
  - "Search for known weaknesses tied to that exact version."
  - "Then locate working code or modules."
  - "The point is a targeted path—not random scanning with exploit tools."
  - "That path supports deliberate effects on adversary infrastructure."
- **Show:**
  - Trace banner → match → candidate → effect.
- **Do:**
  - Ask: "What version string from Nmap would you feed a search first?"
- **Ask (Q):** What version string from Nmap would you feed a search first?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: Ecosystem Components (2 min)

- Vulnerability databases: CVE, NVD
- Exploit repositories: ExploitDB, GitHub
- Search tools: Searchsploit
- Community-vetted intel for rapid selection
- Enables operators to move from finding → effect planning

**Instructor Notes:**

- **Image Prompt:** Three stacked boxes labeled Databases (CVE/NVD), Repositories (ExploitDB/GitHub), Tools (Searchsploit), with an arrow into "Effect planning."
- **Say:**
  - "Three layers."
  - "Databases tell you what is wrong and how bad it is."
  - "Repositories give you code and PoCs."
  - "Searchsploit searches ExploitDB offline from the ops station."
  - "You are not inventing vulns—you are navigating community work that already exists."
- **Show:**
  - Point databases → repos → tools → planning.
- **Do:**
  - Cold-call: "Name one item in each layer."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 5: ATT&CK Mapping — TA0001 Initial Access (2 min)

- ATT&CK: **TA0001 Initial Access**
- Recon (e.g., T1595 Active Scanning) feeds Initial Access
- Open-source research supports **T1190** (Exploit Public-Facing Application)
- Also supports **T1133** (External Remote Services)
- Application: use discovered exploits to achieve access on adversary systems

**Instructor Notes:**

- **Image Prompt:** ATT&CK strip: T1595 → TA0001, with callouts T1190 and T1133 fed by "open-source vuln/exploit research."
- **Say:**
  - "ATT&CK language stays consistent with the planning pipeline."
  - "Active scanning produced the versions."
  - "This lesson feeds Initial Access—especially public-facing apps and external remote services."
  - "You reverse the adversary playbook: same techniques, aimed at their exposed stack."
- **Show:**
  - Point T1595 into TA0001, then highlight T1190 and T1133.
- **Do:**
  - Ask: "Which of your enumerated ports is more T1190 versus T1133?"
- **Ask (Q):** Which of your enumerated ports is more T1190 versus T1133?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 6: Key Considerations (2 min)

- Prioritize high-impact paths (e.g., RCE on command servers)
- Verify target identity with intel before exploit selection
- Test and adapt exploits in isolated labs when possible
- Prefer predictable, evidence-backed effects over speculative strikes

**Instructor Notes:**

- **Image Prompt:** Checklist graphic: Impact priority, Target verification, Lab validation, Evidence-backed effect—each with a checkbox.
- **Say:**
  - "Four operator filters before you touch exploit code."
  - "Impact: does this path actually matter to the adversary mission?"
  - "Verification: does intel and recon agree this is the right node?"
  - "Validation: can you prove behavior in a lab first?"
  - "Evidence: can you report what changed afterward?"
  - "Keep selection tied to mission effect—not novelty of the CVE."
- **Show:**
  - Tick each checklist item aloud.
- **Do:**
  - Ask students to rank the four filters for a time-sensitive disruption; take disagreement and resolve toward mission fit.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Vulnerability Identification (2 min)

**Instructor Notes:**

- **Image Prompt:** Title-only transition slide. "Vulnerability Identification" over a magnifying glass examining a version string that resolves into a CVE ID. No bullets or label text.
- **Say:**
  - "We now turn observed service and version evidence into vulnerability candidates."
- **Show:**
  - Hold on the version-to-CVE visual, then advance.
- **Do:**
  - Have students keep one observed version ready for the next example.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Enumeration to Vulnerability Pipeline (2 min)

- Start with recon data: service versions (e.g., Apache 2.4.29 from `nmap -sV`)
- For web services: enumerate service further by sending a `curl -s -D - http://<ip>:<port>/ -o <output file>`
- Map to known issues: search databases for CVEs tied to that version
- Quickly identify exploitable flaws in adversary attack infrastructure
- Output: candidate CVE list for exploit research

**Instructor Notes:**

- **Image Prompt:** Pipeline cards: Recon evidence → CVE search → Candidate list → Exploit research handoff.
- **Say:**
  - "Pipeline, not luck."
  - "Banner or script output is the query key."
  - "Search NVD/CVE (and later ExploitDB) for that product and version."
  - "You leave this step with candidates—not a guaranteed shell."
- **Show:**
  - Walk the four cards.
- **Do:**
  - Write `Apache 2.4.29` on the board as the running query key.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: Version-Based Vulnerability Discovery (2 min)

- Example: OpenSSH 7.4 → search reveals version-tied CVEs
- Example pattern: CVE-2016-0777 class findings (assess carefully—not every hit is RCE)
- Process: cross-reference versions with databases for unpatched weaknesses
- Operational value: outdated adversary services become access candidates

**Instructor Notes:**

- **Image Prompt:** Callout: "OpenSSH 7.4" feeding a CVE results list; one result highlighted with a caution badge "verify impact class."
- **Say:**
  - "Exact version matching beats fuzzy product-only searches."
  - "OpenSSH 7.4 is the pattern: version in, CVE list out."
  - "Read the impact class—information leak is not the same as RCE."
  - "Unpatched legacy on adversary infrastructure is often your best first look."
- **Show:**
  - Point at the caution badge on impact class.
- **Do:**
  - Ask: "What would you record besides the CVE ID?" Prompt for CVSS, auth required, remote/local.
- **Ask (Q):** What would you record besides the CVE ID?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 10: Beyond Versions — Configuration Weaknesses (2 min)

- Enumeration also reveals misconfigs (e.g., exposed directories via HTTP enum)
- Common: default credentials
- Common: insecure protocols (HTTP instead of HTTPS)
- Pattern recognition from defensive hunts transfers to adversary nodes

**Instructor Notes:**

- **Image Prompt:** Split graphic: left "Version CVE," right "Misconfig" (open dir listing, default creds, cleartext protocol).
- **Say:**
  - "Not every access path is a CVE."
  - "Misconfiguration is still a vulnerability class."
  - "Default credentials and cleartext services show up in enum just like versions do."
  - "Hunt experience helps: the same weak patterns you see on blue hosts appear on adversary nodes."
- **Show:**
  - Contrast version CVE vs misconfig panels.
- **Do:**
  - Ask for one misconfig they have already seen in labs or hunts.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 11: Patching Gaps as Opportunities (2 min)

- Adversaries often run legacy systems for persistence (e.g., Windows Server 2008)
- Identify via OS fingerprinting (`nmap -O`) → link to end-of-life CVEs
- Unpatched flaws can enable access or disruptive effects on adversary tooling
- Prefer evidence of EOL/unpatched state before investing exploit effort

**Instructor Notes:**

- **Image Prompt:** Timeline: supported OS → EOL marker → growing CVE pile; arrow to "access / disrupt adversary tooling."
- **Say:**
  - "Legacy and EOL systems accumulate public exploit coverage."
  - "OS fingerprinting is a clue, not proof—verify with service banners when you can."
  - "Patch gaps are opportunities when the version and exposure match."
  - "Do not assume 'old' equals 'exploitable today' without a matching public path."
- **Show:**
  - Trace EOL → CVE pile → opportunity.
- **Do:**
  - Ask: "How would you distinguish a fingerprint guess from a banner-verified version?"
- **Ask (Q):** How would you distinguish a fingerprint guess from a banner-verified version?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 12: CVE and NVD (2 min)

- **CVE:** centralized list of publicly disclosed vulnerabilities
- Example: CVE-2021-44228 (Log4Shell)
- **NVD:** NIST-maintained details—descriptions, affected products, scoring links
- Search pattern: product + version + "CVE"
- Example query framing: "Apache 2.4.29 CVE"

**Instructor Notes:**

- **Image Prompt:** Two cards: CVE (ID catalog) and NVD (enriched record with description, CPE/products, links). Search bar example: "Apache 2.4.29 CVE."
- **Say:**
  - "CVE is the shared ID language."
  - "NVD adds the operator-useful detail: what is affected and how it is described."
  - "Search with product and version, not vibes."
  - "Log4Shell is the famous example of a CVE ID everyone recognizes—use the same discipline for boring CVEs too."
- **Show:**
  - Point CVE ID card, then NVD enrichment card.
- **Do:**
  - Have students write one search string for their board version example.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 13: Using CVE/NVD with Recon Evidence (2 min)

- Tie searches to enumerated versions
- Precise vulnerability intel for adversary infrastructure
- Record: CVE ID, affected versions, attack vector, privileges required
- Handoff artifact: short vuln note for exploit search

**Instructor Notes:**

- **Image Prompt:** Operator notepad template fields: CVE ID, Affected versions, Vector, Privs, Recon source (port/service).
- **Say:**
  - "Recon evidence is the filter that makes NVD useful."
  - "If the affected version range misses your banner, discard the candidate."
  - "Capture vector and privilege needs now—they drive suitability later."
  - "Your handoff is a short note, not a screenshot dump."
- **Show:**
  - Walk each notepad field.
- **Do:**
  - Fill one example note together from the Apache/OpenSSH board examples.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 14: CVSS Scoring (2 min)

- **CVSS:** scores 0–10
- Base (severity), Temporal (exploit maturity), Environmental (context)
- High band (~7.0–10.0): prioritize for review
- Example: CVSS 9.8 remote exploit → strong suitability signal—not automatic go

**Instructor Notes:**

- **Image Prompt:** CVSS meter 0–10 with Base/Temporal/Environmental callouts; a "prioritize review" zone above 7.0.
- **Say:**
  - "CVSS ranks severity and context—it does not replace suitability assessment."
  - "Base tells you inherent severity."
  - "Temporal reflects exploit maturity over time."
  - "Environmental is where your target context matters."
  - "High scores earn review priority, not blind execution."
- **Show:**
  - Point at the three metric groups and the high band.
- **Do:**
  - Ask: "When would you skip a 9.8?" Prompt for auth required, local-only, wrong version, noisy crash risk.
- **Ask (Q):** When would you skip a 9.8?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 15: Vendor Resources (2 min)

- Official patches and bulletins (e.g., Microsoft Security Updates for SMB vulns)
- Sometimes include PoC snippets or workarounds
- Use to verify affected versions and exploit preconditions
- Cross-check community exploits against vendor affected-product lists

**Instructor Notes:**

- **Image Prompt:** Triangle: Vendor bulletin, NVD record, ExploitDB entry—arrows labeled "corroborate."
- **Say:**
  - "Vendor write-ups verify scope and sometimes preconditions."
  - "They are slower to give full exploit code—but strong for version truth."
  - "Corroborate community exploits against vendor affected lists."
  - "If vendor says not affected, stop and re-check your banner."
- **Show:**
  - Trace corroboration triangle.
- **Do:**
  - Ask: "What would you trust first if ExploitDB and vendor disagree on affected versions?"
- **Ask (Q):** What would you trust first if ExploitDB and vendor disagree on affected versions?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 16: Step-by-Step Vulnerability Process (2 min)

- 1. Identify service/version from enumeration (e.g., SSH 7.4)
- 2. Search CVE/NVD for matches
- 3. Evaluate exploitability (CVSS, requirements)
- 4. Assess operational suitability (stealth, impact, reliability)

**Instructor Notes:**

- **Image Prompt:** Numbered four-step flowchart with icons: banner, database, score/requirements, suitability gauges.
- **Say:**
  - "Memorize the order."
  - "Version first."
  - "Database match second."
  - "Exploitability third."
  - "Suitability fourth—before you run anything."
  - "Skipping to 'run module' is how you crash the wrong thing."
- **Show:**
  - Tap each step in order.
- **Do:**
  - Students recite the four steps to a partner in 20 seconds.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 17: Blue-Space Validation Before Employment (2 min)

- Research from a controlled vantage
- Validate against simulated targets when possible
- Verify effects and failure modes without burning the live path
- Carry forward only candidates that survive lab checks

**Instructor Notes:**

- **Image Prompt:** Two environments: Lab (green) with exploit test; Live adversary target (amber) with a gate labeled "only after lab proof."
- **Say:**
  - "Blue-space advantage is controlled testing."
  - "Prove crash versus shell in the lab."
  - "Prove options and callbacks before live employment."
  - "If it only works once by luck, it is not ready."
- **Show:**
  - Point at the gate between lab and live.
- **Do:**
  - Tie forward: Searchsploit judgment and Metasploit keyboard practice are the proving ground for this lecture.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 18: Evaluate Exploitability and Impact (2 min)

- Assessment criteria
- Exploitability: auth required? local or remote?
- Impact: confidentiality / integrity / availability effects
- Prefer remote, unauthenticated paths for initial access when mission allows
- Example impact framing: disrupt botnet controller availability vs read-only leak

**Instructor Notes:**

- **Image Prompt:** 2x2 matrix: Remote/Local vs Auth/No-auth; preferred cell highlighted "remote + unauthenticated."
- **Say:**
  - "Exploitability is requirements."
  - "Impact is what breaks for the adversary."
  - "For initial access, remote and unauthenticated usually wins the first pass."
  - "A local privilege bug may be useless until you already have a session."
  - "Match impact language to mission: access, disrupt, deny—not 'pwned.'"
- **Show:**
  - Highlight the preferred matrix cell; note exceptions.
- **Do:**
  - Give a local-only CVE and ask whether it belongs in the initial-access shortlist.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 19: Open-Source Exploit Ecosystem (2 min)

**Instructor Notes:**

- **Image Prompt:** Title-only transition slide. "Open-Source Exploit Ecosystem" above icons for ExploitDB, GitHub, Packet Storm, blogs, vendor PoCs, and Metasploit. No bullets or label text.
- **Say:**
  - "A candidate CVE is a lead; this block is about finding and vetting the code or framework that might apply."
- **Show:**
  - Hold on the source icons, then advance.
- **Do:**
  - Ask students to name one source they would use after checking a vendor advisory.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 20: Primary Source — ExploitDB (2 min)

- Archive of public exploits and PoCs indexed by product, version, and CVE
- Query by observed service/version (example: `Apache 2.4.49`)
- Prefer matches that align with platform and remote/local constraints from recon
- Goal: candidates whose type and prerequisites match the observed service—not a guaranteed shell

**Instructor Notes:**

- **Image Prompt:** ExploitDB search results panel seeded by a version string from recon; one row highlighted with EDB-ID, platform, and CVE cross-link.
- **Say:**
  - "You already used version evidence to find CVE candidates; ExploitDB is often the first place to look for public code tied to those findings."
  - "Search with the product and version you observed—not a vague product name alone."
  - "Read platform and exploit type before you copy anything."
  - "A hit is a candidate. Lab validation still decides employment."
- **Show:**
  - Point from the recon version string into the highlighted result row.
- **Do:**
  - Ask: "If ExploitDB and the vendor advisory disagree on affected versions, which do you trust first?"
- **Ask (Q):** If ExploitDB and the vendor advisory disagree on affected versions, which do you trust first?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 21: GitHub as Exploit Repository (2 min)

- Repos: ExploitDB mirrors and user-shared PoCs
- Search: "CVE-2021-44228 exploit" pattern
- Clone for modification
- Use stars/forks as weak quality signals—not proof

**Instructor Notes:**

- **Image Prompt:** GitHub search bar with CVE exploit query; repo card showing stars, forks, last update.
- **Say:**
  - "GitHub is fast and uneven."
  - "Great for recent PoCs and variants."
  - "Stars help triage; they do not certify safety or correctness."
  - "Always read the code before you run it."
- **Show:**
  - Point at stars/forks/last update fields.
- **Do:**
  - Ask: "What would make you reject a high-star repo immediately?"
- **Ask (Q):** What would make you reject a high-star repo immediately?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 22: Packet Storm (2 min)

- Curated exploits, tools, and advisories
- Focus: newer vulnerabilities and pre-CVE material
- Use to supplement ExploitDB for emerging threats
- Still requires the same suitability checks

**Instructor Notes:**

- **Image Prompt:** Secondary shelf labeled Packet Storm beside ExploitDB; badge "supplement, not replace."
- **Say:**
  - "Packet Storm is a secondary shelf."
  - "Useful when ExploitDB is thin on a new issue."
  - "Pre-CVE content can be noisy—verify against your version evidence."
- **Show:**
  - Emphasize supplement badge.
- **Do:**
  - Note: course labs primarily use Searchsploit/MSF; Packet Storm is awareness.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 23: Blogs and Write-Ups (2 min)

- Researcher blogs, vendor research posts, detailed write-ups
- Context, modified exploits, chaining techniques
- Learn adaptation for specific configs found in recon
- Extract commands and preconditions; discard narrative fluff

**Instructor Notes:**

- **Image Prompt:** Blog post mock with highlighted sections: Preconditions, Payload, Pitfalls.
- **Say:**
  - "Write-ups teach adaptation."
  - "You want preconditions and failure modes, not hype."
  - "Chaining ideas matter when one CVE is not enough."
  - "Translate blog steps into your own checklist."
- **Show:**
  - Highlight Preconditions / Payload / Pitfalls.
- **Do:**
  - Ask students what pitfall they would record from a write-up before testing.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 24: Vendor-Provided PoCs (2 min)

- Examples: vendor research teams publishing sample code
- Reliable starting points; often basic
- Extend for full operational effect
- Validate in labs for compatibility with target stack

**Instructor Notes:**

- **Image Prompt:** Vendor PoC (small) growing into "adapted operator exploit" via lab wrench icon.
- **Say:**
  - "Vendor PoCs are usually cleaner and narrower."
  - "They prove the bug more than they deliver a full kit."
  - "Expect to extend payloads and options."
  - "Lab validation still required."
- **Show:**
  - Show small PoC → adapted path.
- **Do:**
  - Contrast: vendor PoC vs random GitHub one-liner—what differs in trust?
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 25: Public Exploits (Ready-to-Run) (2 min)

- Ready-to-run code (e.g., Python RCE scripts)
- Pros: speed against known vulns
- Cons: signatures and widespread detection
- Fit: immediate access attempts on exposed adversary services after vetting

**Instructor Notes:**

- **Image Prompt:** Speedometer on "fast" with a detection radar warning icon.
- **Say:**
  - "Public ready-to-run code is fast."
  - "It is also well known to defenders and vendors."
  - "Use when speed beats novelty and you accept signature risk."
  - "Still read it—malware in 'exploit' wrappers exists."
- **Show:**
  - Balance speed vs detection.
- **Do:**
  - Ask when they would choose a quieter modified PoC instead.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 26: PoCs Requiring Modification (2 min)

- Demonstrations, not full exploits (e.g., crash reproducers)
- Require tweaks: payloads, offsets, target OS/version
- Modify on the ops station for target-specific use
- Goal: reliable effect, not demo crash

**Instructor Notes:**

- **Image Prompt:** Before/after code snippet: "crash PoC" → "payload-adapted exploit" with fields for LHOST/RHOST/version.
- **Say:**
  - "Many 'exploits' only prove a crash."
  - "Your job is to adapt toward the intended effect."
  - "Match OS, arch, paths, and callback addresses."
  - "If you cannot explain the change, do not run it live."
- **Show:**
  - Point at the fields that usually need edits.
- **Do:**
  - Preview keyboard practice: inspect script variables before execution.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 27: Metasploit Framework Overview (2 min)

- Open-source penetration testing platform (Rapid7)
- Components: `msfconsole`, modules, databases/sessions
- Modular design chains recon data into exploit attempts
- Accelerates testing of public exploits against target infrastructure

**Instructor Notes:**

- **Image Prompt:** MSF architecture sketch: Console → Modules (exploit/payload/auxiliary) → Sessions DB.
- **Say:**
  - "Metasploit packages a large share of public exploit work into modules."
  - "Console is the operator interface."
  - "Modules are the weapons; payloads are what you deliver; auxiliaries help enum/check."
  - "It speeds disciplined testing—it does not remove suitability judgment."
- **Show:**
  - Walk console → modules → sessions.
- **Do:**
  - Point ahead to Metasploit as the hands-on proving ground for these families.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 28: Metasploit — Core Strength for Ops (2 min)

- Feed Nmap/service intel into module options
- Automate repetitive option setting and payload handling
- Useful for rapid iteration during access attempts
- Still requires correct RHOST/LHOST and version match

**Instructor Notes:**

- **Image Prompt:** Arrow from Nmap `-sV` output into MSF `set RHOSTS` / `set` options panel.
- **Say:**
  - "Strength is integration and speed."
  - "Your recon notes become module options."
  - "Wrong LHOST still fails the best module."
  - "Version mismatch still fails EternalBlue-class paths."
- **Show:**
  - Trace Nmap → set options.
- **Do:**
  - Ask: "What is your callback interface on Academy VPN?" (expect tun0 / lab-specific)
- **Ask (Q):** What is your callback interface on Academy VPN?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 29: Metasploit — Key Features for This Course (2 min)

- 2,000+ modules (example class: SMB EternalBlue `ms17_010_*` / CVE-2017-0144 family)
- Payloads: reverse shells, Meterpreter for post-access work
- Auxiliary modules: scanners and version/vuln checks
- Resource scripts: automate repeatable workflows

**Instructor Notes:**

- **Image Prompt:** Four tiles: Exploits, Payloads, Auxiliaries, Resource scripts—with one example under each.
- **Say:**
  - "You will touch all four families in later Metasploit practice."
  - "Exploits get you in."
  - "Payloads define the session you catch."
  - "Auxiliaries verify before you burn an exploit."
  - "Resource scripts save time on repeat targets."
- **Show:**
  - Tap each tile.
- **Do:**
  - Tell students to note one example module name during the next lab for their journal.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 30: Metasploit — Basic Usage Workflow (2 min)

- Launch: `msfconsole`
- Search: `search [keyword]` (e.g., `search log4shell`)
- Select: `use exploit/...`
- Configure: `set RHOSTS ...` ; `set LHOST ...`
- Execute: `exploit` or `run`
- Success signal: session opened for follow-on actions

**Instructor Notes:**

- **Image Prompt:** Vertical CLI checklist of the six workflow steps with example commands beside each.
- **Say:**
  - "Six verbs: launch, search, use, set, exploit, verify session."
  - "Search before use."
  - "Set both remote and callback addresses deliberately."
  - "Read errors—most failures are options, not 'MSF is broken.'"
- **Show:**
  - Walk the checklist without rushing.
- **Do:**
  - Students write the six steps in order from memory; spot-check two notebooks.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 31: Custom Exploit Development (Out of Scope) (2 min)

- Custom exploit development is advanced
- This course focuses on leveraging existing open-source work
- Reuse and adapt community code to accelerate access planning
- Note custom development as a future training path if needed

**Instructor Notes:**

- **Image Prompt:** Door labeled "Custom exploit dev" marked "Later"; main hallway labeled "Reuse / adapt open-source."
- **Say:**
  - "We are not writing 0-days in this block."
  - "Master navigation, vetting, and adaptation first."
  - "Custom development is a different skill pipeline."
  - "If a public path does not exist, escalate that finding—do not invent unsafe code under time pressure."
- **Show:**
  - Point at the closed door vs main hallway.
- **Do:**
  - Ask for a thumbs-up that scope is clear before continuing.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 32: Reliability Assessment (2 min)

- Does the exploit work across versions and configs?
- Review documented success/failure notes
- Test in a simulated target environment
- Prefer proven exploits for predictable effects

**Instructor Notes:**

- **Image Prompt:** Checklist: version matrix, community reports, lab success rate, "predictable effect" stamp.
- **Say:**
  - "Reliability is repeatability."
  - "One lucky shell is not a plan."
  - "Read the docs and issues for known failure cases."
  - "Lab rate informs live confidence."
- **Show:**
  - Tick the checklist.
- **Do:**
  - Ask what evidence would convince them an exploit is reliable enough for their COA.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 33: Stability Check (2 min)

- Will the exploit crash the target without achieving the effect?
- Watch for unintended DoS from overflow/crash PoCs
- Lab-test stability before live use
- Optimize for intended access/effect, not accidental outage—unless outage is the tasked effect

**Instructor Notes:**

- **Image Prompt:** Forked outcomes from one exploit: Session (green) vs Crash/DoS (red) with question "intended?"
- **Say:**
  - "Stability is about side effects."
  - "A crash can alert defenders and destroy access opportunities."
  - "If the tasked effect is disrupt/deny via outage, say so explicitly."
  - "Otherwise, treat crash as failure."
- **Show:**
  - Contrast session vs crash outcomes.
- **Do:**
  - Pose: "Mission needs a shell for follow-on. Is a crash PoC suitable?" Expect no.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 34: Requirements Review (2 min)

- Preconditions: paths, credentials, configs, reachable ports
- Cross-check against recon evidence
- Example: verify `/admin` exists before using an admin-only exploit
- Align requirements with what you can actually reach from the ops station

**Instructor Notes:**

- **Image Prompt:** Requirements list with green checks and red X's mapped to recon notes (port open, path present, creds known).
- **Say:**
  - "Every exploit has homework."
  - "If the module needs a file path, prove the path."
  - "If it needs auth, prove creds."
  - "Recon either satisfies requirements or the candidate is parked."
- **Show:**
  - Match each requirement to a recon artifact.
- **Do:**
  - Give a fake module requiring SMB + guest access; ask what enum proves guest.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 35: OPSEC Evaluation (2 min)

- How noisy is the exploit?
- Failed attempts, anomalous traffic, known signatures
- Reduce detection by adapting PoCs and matching expected traffic patterns when feasible
- Balance stealth needs against mission urgency

**Instructor Notes:**

- **Image Prompt:** Noise meter beside an exploit; mitigations listed: modify signatures, limit retries, match expected paths.
- **Say:**
  - "OPSEC is detectability under adversary eyes."
  - "Default public exploits are loud."
  - "Retries and wrong payloads create logs."
  - "When stealth matters, modify and rehearse; when speed matters, accept noise consciously."
- **Show:**
  - Walk noise meter and mitigations.
- **Do:**
  - Ask which upcoming lab values learning speed over stealth (expect early HTB skill labs).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 36: Searchsploit Basics (2 min)

- Often preinstalled on Kali-class images; update with `searchsploit -u` when online
- Syntax: `searchsploit [app] [version] [platform]`
- Example: `searchsploit ssh 7.4 linux`
- Output feeds EDB-ID selection

**Instructor Notes:**

- **Image Prompt:** Terminal with `searchsploit ssh 7.4 linux` and annotated syntax tokens: app, version, platform.
- **Say:**
  - "This is the detailed Searchsploit workflow; earlier vulnerability research established the evidence that supplies its query terms."
  - "Basics you will type repeatedly."
  - "Update when you can; search when you must."
  - "Add platform to cut noise."
  - "Copy the EDB-ID—you need it for examine/mirror commands."
- **Show:**
  - Annotate each syntax token.
- **Do:**
  - Students craft one Searchsploit line from their Nmap service.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 37: Searchsploit Details and Usage (2 min)

- Output: EDB-ID, type, platform
- Examine/copy patterns: `searchsploit -m [ID]` (mirror/copy into cwd—verify help on your build)
- Path/print options: `searchsploit -p [ID]` (path disclosure for local review)
- Adapt locally for the target before execution

**Instructor Notes:**

- **Image Prompt:** Three-step strip: Search results → `-m` copy → local edit/test.
- **Say:**
  - "Reading beats running."
  - "Mirror the exploit into your working directory."
  - "Open it; find the variables that must change."
  - "Flags can vary slightly by Searchsploit version—check `--help` once per image."
- **Show:**
  - Walk search → copy → edit.
- **Do:**
  - In lab: require a pre-execution `head`/`less` of the script before any run.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 38: GitHub Search Strategies (2 min)

- Keywords: `exploit CVE-XXXX` or `PoC [service]`
- Filters: language (e.g., Python), stars as a weak prior
- Look for recent commits on emerging issues
- Save the exact query you used in notes

**Instructor Notes:**

- **Image Prompt:** GitHub filter panel with Language and Stars; query examples listed.
- **Say:**
  - "Search like an analyst."
  - "CVE ID queries are precise; service PoC queries are broader."
  - "Language filters help when you must maintain the code."
  - "Record the query for reproducibility."
- **Show:**
  - Show example queries.
- **Do:**
  - Pair students: one writes a CVE query, one writes a service PoC query.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 39: GitHub Quality Check (2 min)

- Metrics: stars, forks, last commit, author reputation signals
- Read issues/PRs for fixes and failure reports
- Cross-check claims against CVE/NVD details
- Use SI assistants to accelerate leads, not replace research; verify every SI lead against primary sources, version evidence, and reviewed code
- Reject repos that disagree with affected-version truth

**Instructor Notes:**

- **Image Prompt:** Quality scorecard with pass/fail rows for freshness, issues, version match, code readability, and SI-lead verification.
- **Say:**
  - "Quality check is mandatory."
  - "Dead repos with bold README claims are common."
  - "Issues often tell you it only works on one build."
  - "SI can accelerate searches and summarize leads, but it is not evidence."
  - "Verify every SI-sourced lead against primary sources, observed version evidence, and the code you reviewed."
  - "If NVD says not vulnerable, the README does not override reality."
- **Show:**
  - Walk the scorecard.
- **Do:**
  - Show a hypothetical README claiming universal RCE; ask what they verify first.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 40: Cloning and Adaptation Process (2 min)

- `git clone [repo URL]`
- Modify parameters for target IP/version
- Test in a lab simulating the adversary environment
- Employ only after successful lab validation

**Instructor Notes:**

- **Image Prompt:** Four chevrons: Clone → Modify → Lab test → Employ.
- **Say:**
  - "Clone is the start, not the finish."
  - "Edit for your address plan and version."
  - "Lab test is the go/no-go gate."
  - "No silent live first-tries with untrusted code."
- **Show:**
  - Walk the four chevrons.
- **Do:**
  - Ask what single parameter mistake most often breaks reverse shells (LHOST/callback).
  - Ask: "Name three things you would read in a cloned PoC before any execution." Drive toward: target OS assumptions, required ports, and whether recon actually shows that service/version.
- **Ask (Q):** Name three things you would read in a cloned PoC before any execution.
- **Expected Response (A):** target OS assumptions, required ports, and whether recon actually shows that service/version

### Slide 41: Initial Access Techniques (2 min)

**Instructor Notes:**

- **Image Prompt:** Title-only transition slide. "Initial Access Techniques" with a TA0001 shield and technique IDs T1190, T1133, T1078, and T1534. No bullets or label text.
- **Say:**
  - "Research becomes operational only when it maps to an access technique that the evidence supports."
- **Show:**
  - Hold on the TA0001 visual, then advance.
- **Do:**
  - Have students keep one candidate in mind to map during this block.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 42: MITRE ATT&CK Initial Access Overview (2 min)

- **TA0001: Initial Access**
- Entry techniques applied against adversary infrastructure
- Informed by open-source vuln/exploit research
- Launch from positions that already engage the adversary when feasible

**Instructor Notes:**

- **Image Prompt:** TA0001 banner with subtitle "Research-enabled entry" and icons for web, remote services, accounts, lure-based paths.
- **Say:**
  - "Initial Access is the tactic."
  - "Techniques are how you enter."
  - "Your research narrows which technique is honest."
  - "Prefer paths that match how you already reach the target."
- **Show:**
  - Sweep the technique icons.
- **Do:**
  - Ask for a one-sentence definition of Initial Access in operator language.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 43: T1190 — Exploit Public-Facing Application (2 min)

- Common fit for exposed application access problems
- Exploit web apps/APIs on adversary infrastructure (SQLi, RCE via CVE)
- Example class: Log4Shell-style RCE on a C2 web tier → shell for follow-on effects
- Select exploits from enumerated versions

**Instructor Notes:**

- **Image Prompt:** Public web app icon with exploit arrow into shell; label T1190; small "version-matched CVE" tag.
- **Say:**
  - "T1190 is your default when a public app is exposed."
  - "SQLi and RCE are common shapes—later access practice will use several."
  - "Version-matched CVEs make this technique concrete."
  - "Foothold is the start; effects come after."
- **Show:**
  - Trace public app → exploit → shell.
- **Do:**
  - Ask which student ports from recon look T1190-shaped (80/443/app ports).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 44: T1190 Examples — Web RCE Paths (2 min)

- Web server exploits and RCE
- Tools: Metasploit modules or adapted PoCs
- Operational pattern: foothold on public attack nodes, then follow-on actions
- Timing and preparation still matter for detection management

**Instructor Notes:**

- **Image Prompt:** Toolkit choice: MSF module card vs PoC script card, both pointing to "foothold," then dashed arrow "follow-on."
- **Say:**
  - "Same technique, multiple actions."
  - "MSF when a good module exists and fits policy/lab rules."
  - "PoC when you need transparency or MSF is unavailable."
  - "Plan the follow-on before you celebrate the shell."
- **Show:**
  - Compare the two toolkit cards.
- **Do:**
  - Tie to Metasploit and to manual Searchsploit judgment.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 45: T1133 — External Remote Services (2 min)

- Targets: VPN, RDP, SSH
- Examples: RDP vulnerability classes (e.g., BlueKeep-era), SSH weak keys/creds from enum
- Credential path vs exploit path
- Compromise remote services on adversary infrastructure for deeper reach

**Instructor Notes:**

- **Image Prompt:** Three service doors—VPN, RDP, SSH—each with dual keys labeled "exploit" and "credential."
- **Say:**
  - "T1133 is remote administration surfaces."
  - "Sometimes you exploit the service."
  - "Sometimes you authenticate with discovered credentials."
  - "Enum tells you which door is real and which path is viable."
- **Show:**
  - Point at exploit vs credential keys on each door.
- **Do:**
  - Ask: "From Nmap, what evidence pushes you to T1133 over T1190?"
- **Ask (Q):** From Nmap, what evidence pushes you to T1133 over T1190?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 46: T1078 — Valid Accounts (2 min)

- Using discovered or recovered credentials
- Sources: enum (e.g., enum4linux users), breach corpora analogs, hunt-derived IOCs/creds
- Techniques: stuffing (reused passwords), spraying (common passwords)
- Auth to adversary services for lower-noise access when creds work

**Instructor Notes:**

- **Image Prompt:** Credential funnel: enum users + hunt IOCs + breach-style lists → stuffing/spraying → valid session.
- **Say:**
  - "Valid accounts skip a lot of exploit noise."
  - "Build the user list from enum and hunt evidence."
  - "Stuffing and spraying are different tempos—know which you are doing."
  - "Validate carefully; lockouts are an OPSEC and stability issue."
- **Show:**
  - Walk the funnel.
- **Do:**
  - Ask where they already saw username discovery during recon.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 47: T1534 — Internal Spearphishing (Concept) (2 min)

- Seed the blue environment for adversary collection
- Plant lures (docs with payloads, tracking artifacts) where adversary collection is expected
- Bait mimics high-value material the adversary wants
- Flips collection behavior into a counter-access opportunity

**Instructor Notes:**

- **Image Prompt:** Blue-space file share with a lure document; red adversary collector icon reaching for it; caption "collection expected."
- **Say:**
  - "T1534 here is the reverse lure idea."
  - "You place bait on terrain the adversary already steals from."
  - "The lure must look like something worth taking."
  - "This is planning-heavy and environment-dependent—not every mission uses it."
- **Show:**
  - Trace adversary collection to the lure.
- **Do:**
  - Ask what blue artifact an adversary might routinely collect in a hunt scenario.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 48: T1534 — Trigger Path and Value (2 min)

- When adversary opens/collects the lure, trigger callback or follow-on exploit path
- Aim: access into adversary infrastructure via their own collection cycle
- Expands options against C2/analysis nodes
- Requires monitoring for collection triggers and safe callback handling

**Instructor Notes:**

- **Image Prompt:** Sequence: Plant lure → Adversary collects → Trigger/beacon → Access path back toward adversary tier.
- **Say:**
  - "Value appears only if collection actually happens."
  - "You need a monitor plan and a callback plan."
  - "This is not 'spray phishing the internet'—it is terrain the adversary already touches."
  - "Treat it as advanced sequencing relative to straight T1190."
- **Show:**
  - Step through plant → collect → trigger → access.
- **Do:**
  - Contrast speed: T1190 direct exploit vs T1534 waiting on adversary behavior.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 49: When to Use Each Technique (2 min)

- **T1190:** public web/app exposure; strong recon yield
- **T1133:** remote services with vulns or weak exposure
- **T1078:** creds available; lower exploit risk preferred
- **T1534:** adversary expected to collect from blue space
- Base selection on open-source findings plus target environment

**Instructor Notes:**

- **Image Prompt:** Decision table with technique rows and "use when" columns; a footer "recon + environment decide."
- **Say:**
  - "Selection is conditional."
  - "Public app evidence points T1190."
  - "Admin services point T1133."
  - "Creds point T1078."
  - "Expected collection points T1534."
  - "Open-source research informs feasibility inside each row."
- **Show:**
  - Walk the table row by row.
- **Do:**
  - Give one scenario per row; students call the technique ID.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 50: Operational Considerations for T1190 (2 min)

- Prefer modified PoCs when signature evasion matters
- Favor RCE paths when follow-on effects need a session
- Prepare callbacks and success criteria before launch
- Route and timing choices still affect detectability

**Instructor Notes:**

- **Image Prompt:** T1190 ops checklist: PoC adaptation, RCE vs non-RCE, callback ready, success criteria defined.
- **Say:**
  - "T1190 execution still has operator choices."
  - "Adaptation can reduce trivial signature hits."
  - "RCE is the usual path to meaningful follow-on."
  - "If you cannot state success criteria, you are not ready to launch."
- **Show:**
  - Tick the checklist.
- **Do:**
  - Students write one success criterion for a web RCE attempt.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 51: Operational Considerations for Other Techniques (2 min)

- **T1133:** pivot to the remote service; watch logs and lockouts
- **T1078:** validate creds offline/safely first; build lists from hunt IOCs
- **T1534:** seed lures where collection is likely; monitor for triggers
- Overall: use controlled ops-station execution and known adversary patterns

**Instructor Notes:**

- **Image Prompt:** Three mini-cards for T1133/T1078/T1534 with one primary caution each (logs, lockouts, trigger monitoring).
- **Say:**
  - "Each technique fails differently."
  - "Remote services produce authentication and session logs."
  - "Credential attacks produce lockouts and alerts."
  - "Lures produce nothing until collection happens—patience and monitoring."
- **Show:**
  - Point to each caution.
- **Do:**
  - Ask which failure mode is hardest to recover from; discuss briefly.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 52: Blue-Space Advantage — Expected Traffic Blend (2 min)

- Operations from engaged blue space can blend with traffic the adversary already expects
- Improves reach to assets that ignore unfamiliar sources
- Supports OPSEC relative to launches from unrelated infrastructure
- Still requires disciplined volume and timing

**Instructor Notes:**

- **Image Prompt:** Two source maps: "unfamiliar VPS" rejected; "expected blue-path traffic" accepted by adversary edge.
- **Say:**
  - "Where you launch from changes outcomes."
  - "Adversaries often expect and allow certain blue-origin patterns."
  - "Unfamiliar sources get blocked or watched."
  - "Blending is an advantage—not a free pass to be loud."
- **Show:**
  - Compare rejected vs accepted paths.
- **Do:**
  - Ask for an example of traffic an adversary C2 might already expect from victims.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 53: Blue-Space Advantage — Control and Adaptation (2 min)

- Direct control from blue space supports strong OPSEC practices
- Enables real-time adaptation from ongoing recon
- Avoids fragile dependence on external intermediaries
- Supports precise, reportable effects as part of the campaign

**Instructor Notes:**

- **Image Prompt:** Control loop: Recon feed → Operator decision → Action → Observe → Adapt; labeled "blue-space control."
- **Say:**
  - "Control means you can adapt mid-operation."
  - "You see recon updates and change COAs."
  - "Fewer external dependencies means fewer broken handoffs."
  - "Effects stay reportable because you own the execution trail."
- **Show:**
  - Walk the control loop.
- **Do:**
  - Ask how lab logging mirrors this control advantage at small scale.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 54: Operational Suitability Assessment (2 min)

**Instructor Notes:**

- **Image Prompt:** Title-only transition slide. "Operational Suitability Assessment" with gauges for Likelihood, Stealth, Reliability, Risk, and Time plus a documentation icon. No bullets or label text.
- **Say:**
  - "Before employment, verify whether a candidate fits the target, task, and expected effect."
- **Show:**
  - Hold on the suitability gauges, then advance.
- **Do:**
  - Tell students to use these factors when they justify their lab selection.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 55: Likelihood of Success (2 min)

- Match exploit/technique to recon (version, config, exposure)
- Lab-simulate the target to verify functionality
- Prefer high-likelihood paths for reliable disruption or access
- Low likelihood belongs in contingency COAs, not the primary plan

**Instructor Notes:**

- **Image Prompt:** Overlay of recon facts onto exploit requirements with a likelihood dial moving high when matches align.
- **Say:**
  - "Likelihood starts with match quality."
  - "Version and config alignment first."
  - "Lab proof second."
  - "Do not build the primary COA on a long shot."
- **Show:**
  - Move the dial as matches align.
- **Do:**
  - Give a mismatched version scenario; students call likelihood low and say why.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 56: Stealth Assessment (2 min)

- Detectability factors: logs, traffic patterns, app alerts
- Mitigations: mimic expected patterns; reduce retries; adapt signatures when feasible
- Balance stealth (persistence/follow-on) vs aggressive speed for time-sensitive effects
- Record the stealth tradeoff in the COA rationale

**Instructor Notes:**

- **Image Prompt:** Balance scale: Stealth/persistence vs Speed/decisive effect; mitigation chips underneath.
- **Say:**
  - "Stealth is not always the top priority—but it is always assessed."
  - "Name what will log you."
  - "Name what you will do to reduce that."
  - "If you choose noisy, own it in the plan."
- **Show:**
  - Tip the scale both ways with example missions.
- **Do:**
  - Two volunteers: one argues stealth COA, one argues speed COA, same target.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 57: Reliability for Consistent Results (2 min)

- Repeatable outcomes across attempts in similar environments
- Review community feedback (ExploitDB/GitHub) for failure conditions
- Prefer techniques with strong demonstrated success in comparable configs
- Treat "worked once" as insufficient for primary COA

**Instructor Notes:**

- **Image Prompt:** Run chart of attempt 1..N with success marks; community "known failures" sticky notes.
- **Say:**
  - "Reliability is statistical intuition plus evidence."
  - "Community failure notes matter."
  - "Comparable configs matter—do not borrow success from a different stack."
  - "Primary COAs need boring, repeatable tools."
- **Show:**
  - Point at repeated successes vs one-off spike.
- **Do:**
  - Ask what lab evidence would raise confidence after a first success.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 58: Risk Evaluation — Technical Side Effects (2 min)

- Unintended crash, data loss, or defensive triggers
- Side effects can burn access paths or alert defenders
- Quantify via code review and lab testing
- Decide whether residual risk is acceptable for the tasked effect

**Instructor Notes:**

- **Image Prompt:** Risk board: Crash, Data loss, Alerting—each with lab test checkbox and residual-risk note.
- **Say:**
  - "Risk starts technical."
  - "Crash and alerting are first-order concerns."
  - "Lab testing is how you price residual risk."
  - "Accept risk only when the tasked effect justifies it."
- **Show:**
  - Walk the risk board.
- **Do:**
  - Ask which side effect is worst for a follow-on collection mission (usually alerting/crash).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 59: Risk Evaluation — Adversary Response (2 min)

- Anticipate adversary reactions: increased monitoring, path changes, retaliation attempts
- Assess whether those reactions complicate blue operations
- Mitigate with staging, timing, and reversible actions when possible
- Document expected response beside expected effect

**Instructor Notes:**

- **Image Prompt:** Simple red-team response tree: Detect → Monitor↑ / Relocate / Counter-action; blue mitigations listed beside.
- **Say:**
  - "Effects create responses."
  - "Ask how the adversary will notice."
  - "Ask what they will do next."
  - "Put expected response in the plan next to expected effect."
- **Show:**
  - Walk detect → response branches.
- **Do:**
  - Students write one expected adversary response for a noisy T1190.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 60: Mission Alignment and Decision Trail (2 min)

- Verify the chosen exploit/technique supports the tasked effect
- Keep selections within assigned targets and mission scope
- Record approvals/decisions needed by your team process
- Maintain a selection trail: why this CVE, why this code, why this technique

**Instructor Notes:**

- **Image Prompt:** Decision trail form fields: Tasked effect, Target, Technique, CVE/EDB, Rationale, Approver/time.
- **Say:**
  - "Alignment beats cleverness."
  - "If it does not support the tasked effect, drop it."
  - "Stay inside assigned targets."
  - "Your notes should let another operator understand the choice tomorrow."
- **Show:**
  - Fill one example trail on the board.
- **Do:**
  - Students copy the blank trail fields into their notebook for labs.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 61: Time Considerations (2 min)

- Estimate prep, execution, and cleanup time
- Example contrast: ~1 hour adapting a PoC vs ~10 minutes running a ready MSF module
- Account for recon-to-exploit cycle under a changing target
- Use parallel lab research to compress timelines

**Instructor Notes:**

- **Image Prompt:** Timeline bars comparing PoC adaptation vs MSF module path; a buffer labeled "target change."
- **Say:**
  - "Time is a suitability factor."
  - "Adaptation cost is real."
  - "MSF speed helps when modules fit."
  - "Always leave buffer for target change after recon."
- **Show:**
  - Compare the two timeline bars.
- **Do:**
  - Ask which path they choose with 20 minutes until a mission window.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 62: Balancing Factors — Decision Matrix (2 min)

- Build a simple weighted matrix for the decision
- Example weights: likelihood 40%, stealth 20%, reliability 15%—adjust to mission
- Score candidate COAs against the same criteria
- Select with transparent math, not vibes

**Instructor Notes:**

- **Image Prompt:** Spreadsheet-style matrix: candidates as rows; Likelihood/Stealth/Reliability/Risk/Time as columns; weighted total.
- **Say:**
  - "Make the tradeoffs visible."
  - "Weights change with mission—stealth rises for long games."
  - "Score at least two COAs."
  - "The matrix supports the recommendation; it does not replace judgment."
- **Show:**
  - Fill two candidate rows quickly.
- **Do:**
  - Class scores a noisy high-success exploit vs a quiet lower-success PoC.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 63: Balancing Factors — COA Comparison (2 min)

- Example: noisy high-success exploit for urgent C2 disruption when speed matters
- Compare against quieter alternatives when persistence matters
- Use blue-space testing and real-time recon to refine the choice
- Tie final pick to mission objective and expected adversary response

**Instructor Notes:**

- **Image Prompt:** Two COA cards—Speed takedown vs Quiet foothold—with mission tags and expected responses.
- **Say:**
  - "Practical choice looks like this."
  - "Urgent disruption can justify noise."
  - "Long-game access usually cannot."
  - "Re-check recon right before execution—targets move."
- **Show:**
  - Compare the two COA cards.
- **Do:**
  - Vote with hands on the urgent scenario; require one sentence rationale from a voter.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 64: Documenting Technique Selection (2 min)

- Record why this exploit/technique won
- Include evidence: CVE match, reliability notes, lab results
- Supports debriefs, handoffs, and lessons learned
- Keep note-taking in the same workflow as recon → effect

**Instructor Notes:**

- **Image Prompt:** Operator journal template linking Recon → Vuln note → Exploit choice → Lab result → Employment decision.
- **Say:**
  - "If it is not written, the team cannot reuse it."
  - "Evidence beats adjectives."
  - "Documentation is part of execution quality."
  - "Your future self is a customer of these notes."
- **Show:**
  - Trace the journal chain.
- **Do:**
  - Require a five-line selection rationale as the exit ticket before questions.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 65: Key Takeaways — Research Pipeline (2 min)

- Pipeline: enumerate services/versions → CVE/NVD search → exploit evaluation → ATT&CK technique selection
- Sources: NVD for vuln detail, ExploitDB for code, GitHub for PoCs
- Build a repeatable research habit, not one-off searches

**Instructor Notes:**

- **Image Prompt:** End-to-end pipeline banner with source logos under the middle stages.
- **Say:**
  - "Takeaway one: order of operations."
  - "Enumeration keys the search."
  - "Databases and repos feed evaluation."
  - "Technique selection makes it operational."
- **Show:**
  - Trace the pipeline once more.
- **Do:**
  - Students redraw the pipeline from memory in 60 seconds.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 66: Key Takeaways — ATT&CK and Positioning (2 min)

- Research enables **TA0001 Initial Access** techniques
- Turns recon into access capability
- Blue-space positioning improves validation and adaptation
- Controlled testing beats untested live attempts

**Instructor Notes:**

- **Image Prompt:** Pair of takeaway tiles: ATT&CK-enabled access; Blue-space validation advantage.
- **Say:**
  - "Takeaway two: ATT&CK keeps language consistent."
  - "Takeaway three: where you plan and test matters."
  - "Validation is part of access tradecraft."
- **Show:**
  - Point both tiles.
- **Do:**
  - Ask for one sentence linking their next keyboard practice to TA0001.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 67: Up Next — Practical Application (2 min)

- Next: controlled labs applying Searchsploit and Metasploit
- Build on lecture concepts against simulated targets
- Primary practical hooks: Searchsploit and exploit judgment; Metasploit fluency; later access paths across common services
- Bring recon notes and a blank suitability checklist

**Instructor Notes:**

- **Image Prompt:** Road signs: Searchsploit/manual, Metasploit, gaining access—lecture box behind them checked done. No lesson numbers.
- **Say:**
  - "Lecture ends; reps begin."
  - "Searchsploit emphasizes exploit judgment."
  - "Metasploit builds module-employment fluency."
  - "Later access practice applies those techniques across common services."
  - "Bring version evidence and your suitability checklist."
- **Show:**
  - Point to each lab sign.
- **Do:**
  - Hand out or display the Searchsploit/open-source brief pointer; break.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 68: Questions? (2 min)

- Open floor

**Instructor Notes:**

- **Image Prompt:** Empty dark classroom projection with a single large word Questions centered. No footer, no deferral text, no lab names, no lesson numbers.
- **Say:**
  - "Questions on the pipeline, sources, techniques, or suitability."
  - "Tool errors and target IPs wait for the lab block."
- **Show:**
  - Open the floor; note lab-specific issues for the lab block.
- **Do:**
  - Take 3–5 questions; defer environment issues cleanly; release to break/lab.
- **Ask (Q):** What question still has to wait for the lab block?
- **Expected Response (A):** Tool errors and target IPs wait for the lab. Tradecraft questions belong here.

---

## Improvement notes

- **Before → after slide count:** 78 → 71 → 68
- **Live demos removed (this pass):** Dropped former slides 19 (CVE/NVD live search), 39 (Searchsploit live query), and 43 (GitHub/EternalBlue live clone). How-to remains on the teaching slides before each; keyboard practice is deferred to follow-on labs / Vulnhub walkthroughs. PoC pre-execution reading habit folded into Slide 40 Do.
- **Structural revisions:** Removed the Lesson Overview and introductory transition slides; converted the Vulnerability Identification, Open-Source Exploit Ecosystem, Initial Access Techniques, and Operational Suitability Assessment transitions to title-and-image-only slides. Consolidated early ExploitDB teaching into a single Primary Source — ExploitDB slide after the ecosystem transition; removed the duplicate early Searchsploit overview, the repeated Metasploit course/lab-ties slide, and the redundant lesson-summary slide.
- **Continuity and research quality:** Slide 3 now bridges passive leads and observed service/version evidence. Slide 36 acknowledges that its detailed Searchsploit workflow builds on the earlier evidence chain. Slide 39 adds SI guidance: use SI assistants to accelerate leads, then verify every lead against primary sources, version evidence, and reviewed code.
- **Splits (source PPTX → 71-slide revision; demo removal did not re-audit this table):**
  - Source 14 (CVE/NVD + use) → Slides 14–15
  - Source 16 (ExploitDB + example query) → Slides 17–18
  - Source 19 (step-by-step + blue-space integration) → Slides 21–22
  - Source 30 (Metasploit overview dense) → Slides 33–34
  - Source 52 (T1534 dense) → Slides 56–57
  - Source 56 (blue-space advantages dense) → Slides 61–62
- **Other packing notes:** Long paragraph bullets on suitability/OPSEC/risk slides compressed to scannable bullets; detail moved into Say/Show/Do. ROE/authority framing de-emphasized per execution-focus guidance; retained mission-alignment and decision-trail documentation (Slide 60) without expanding authority discussion.
- **Instructor notes disclaimer:** Source student PPTX had empty speaker notes. All Image Prompt / Say / Show / Do content in this file was authored during the improvement pass for Week 4 content-guide parity—not extracted from the deck.
- **Lesson Objectives:** Slide 2 on-slide bullets preserved verbatim from the faithful extract (commit `92b111f`), including `MITRE® attack` wording; not paraphrased.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B02.M02-open-source-ecosystem is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later Searchsploit and Metasploit practice continues from the version evidence this session collects.

## Questions and check on learning

- **Ask (Q):** Hold up one service and version from your last Nmap run.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** What version string from Nmap would you feed a search first?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
