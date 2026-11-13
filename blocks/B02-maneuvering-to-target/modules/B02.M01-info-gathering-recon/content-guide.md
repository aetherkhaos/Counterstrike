---
id: B02.M01
title: Intro to Information Gathering — Passive and Active Recon
artifact_type: content_guide
audience: instructor
block: B02
module_type: lecture
legacy_aliases:
- legacy/week2/content-guides/2.1 Intro to Info Gathering Passive and Active Recon
  Content Guide.md
- legacy/week2/content-guides/2.1 Intro to Info Gathering and Passive Recon Content
  Guide.md
- legacy/week2/content-guides/2.3 Intro to Info Gathering and Active Recon Content
  Guide.md
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

# Intro to Information Gathering — Passive and Active Recon — Content Guide

**Source:** This Markdown content guide is the source of truth (merged passive + active recon). Instructor deck: [`slides/B02.M01_info-gathering-recon_Instructor.pptx`](slides/B02.M01_info-gathering-recon_Instructor.pptx). The student copy is generated at pack time.
**Audience:** CPT operators building targeting intelligence: observe, then reveal or verify, then act.
**Duration:** ~90–120 minutes (single lecture block, or two delivery beats: Parts A–C then Part D)
**Prerequisites:** METT-TC, CG/CV, EMLCOA, and MITRE ATT&CK / ENGAGE orientation; staged Nmap collection (ports → versions → scripts) and basic HTTP enum (WhatWeb / Nikto) as talk-throughs in this block—do not live-demo.
**References:**

- [`slides/B02.M01_info-gathering-recon_Instructor.pptx`](slides/B02.M01_info-gathering-recon_Instructor.pptx)
- [`../../../../course/prerequisites/osint/`](../../../../course/prerequisites/osint/) (Corporate OSINT homework)
- [`../../../../course/prerequisites/nmap/`](../../../../course/prerequisites/nmap/) (Nmap network enumeration homework)

**Course weighting:** Passive reconnaissance is orientation—good to know. Active reconnaissance is the primary lecture skill (scan types, Nmap decisions, detection trade-offs).

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

- **Say:** "This hour is information gathering—reconnaissance as a whole."
- **Do:** Put the lesson contract on the board. Keep planning products (METT-TC, CG/CV, EMLCOA) visible if they are already up.
- **Ask (Q):** In one sentence, what is reconnaissance supposed to produce?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "This hour is information gathering—reconnaissance as a whole."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** In one sentence, what is reconnaissance supposed to produce?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Information Gathering and Reconnaissance (3 min)

**Instructor Notes:**

- **Image Prompt:** Title slide only. Dark operational backdrop with a faint network map. One highlighted adversary node; a quiet observation icon on the left and a probe path on the right. Large lesson title centered; no bullet stack. Optional subtitle: "Observe, then reveal or verify, then act."
- **Say:**
  - "This hour is information gathering—reconnaissance as a whole."
  - "You will see two types: passive and active."
  - "Passive is orientation for this course. Active is what we practice in depth."
  - "Objectives are next; that slide is the contract for the block."
- **Show:**
  - Hold on the title long enough for students to orient, then advance.
- **Do:**
  - Ask: "In one sentence, what is reconnaissance supposed to produce?"
  - Capture one or two answers; return to them on the next teaching slides.
- **Ask (Q):** In one sentence, what is reconnaissance supposed to produce?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Lesson Objectives (3 min)

- Define reconnaissance in cyber threat hunting and counterstrike operations, and distinguish **passive** (observe) from **active** (reveal/verify).
- Identify the role of recon against **adversary infrastructure** from **blue space**, mapped to ATT&CK **TA0043**.
- Apply a short passive collection picture (artifacts, OSINT, domain pivots) to generate **leads**—not the primary skill this course grades.
- Select and explain active scanning and enumeration methods (scan types, port states, Nmap decisions, detection trade-offs) you will use when you scan.

**Instructor Notes:**

- **Image Prompt:** Four objective tiles in a horizontal row: Define recon (passive vs active); Blue-space TA0043; Passive leads from artifacts; Active scan methods (Nmap, ports, detection). No lesson numbers, no lab labels.
- **Say:**
  - "Read these objectives as written—they are the contract for this block."
  - "Define recon and draw the passive versus active line: observe, then reveal or verify."
  - "Place the work against adversary infrastructure from blue space, mapped to ATT&CK Reconnaissance—TA0043."
  - "Build a short passive picture that produces leads. That is not the primary graded skill this lecture is built around."
  - "Then select and explain active scanning and enumeration you will use when you scan—scan types, port states, Nmap decisions, detection trade-offs."
  - "OSINT is keyboard practice on public sources. Nmap is keyboard practice on live hosts. This hour sets the decision order, not a second lab brief."
- **Show:**
  - Walk the four tiles left to right while pointing at each matching bullet.
- **Do:**
  - Tell students: "By the end, you should be able to take one IOC, sketch a passive lead package, then justify a scoped active scan—without treating curiosity as a scan plan."
  - Have them open two note columns labeled Passive and Active; they will fill those as the boundary slides land.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: What Reconnaissance Is (3 min)

- Collection that produces targeting intelligence
- Doctrinal task: **reconnoiter**
- ATT&CK tactic: **Reconnaissance (TA0043)**
- Target: **adversary infrastructure**, not friendly hosts
- Vantage: **blue space**—networks you control

**Instructor Notes:**

- **Image Prompt:** Simple orientation graphic. Left: blue-space ops station. Right: adversary C2 / attack infrastructure. Center label: "Reconnoiter → TA0043." Arrow labeled "Collection" pointing right; caption: "Target their nodes, not ours."
- **Say:**
  - "Reconnaissance is collection that produces targeting intelligence—not keyboard tourism."
  - "In planning language you already have, the task is reconnoiter: produce intelligence that later decisions can use."
  - "In ATT&CK, that work sits under tactic TA0043, Reconnaissance."
  - "The focus is adversary infrastructure from blue space."
  - "You are not scanning your own enterprise for sport."
  - "You launch from networks you control—and that may already touch the adversary—so collection stays planned and attributable."
  - "Passive-leaning examples under TA0043 include Search Open Technical Databases (T1596) and Gather Victim Identity Information (T1589). Active Scanning (T1595) lives under the same tactic—we map that ID once, after you have the scan mechanics."
- **Show:**
  - Point from the ops station to adversary infrastructure.
  - Point at reconnoiter paired with TA0043.
- **Do:**
  - Ask: "Name one adversary asset type a log or public report might hand you before anyone probes."
  - Accept: suspect C2 IP, malware staging domain, related ASN/block.
- **Ask (Q):** Name one adversary asset type a log or public report might hand you before anyone probes.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: Why Collection Matters (3 min)

- Validate IOCs from blue-space detections
- Support attribution and campaign linkage
- Shape targeting and effects options
- Quiet first; probe only when a decision needs it

**Instructor Notes:**

- **Image Prompt:** Three outcome boxes under a recon header: Validate IOCs, Attribute / Link Campaigns, Plan Targeting. A small badge: "Quiet collection first."
- **Say:**
  - "For a CPT, recon is not academic."
  - "You validate IOCs already in your environment."
  - "You link activity to infrastructure and campaigns."
  - "You shape what targeting or effects options are realistic—deny, degrade, disrupt, and related decision-cycle outcomes."
  - "Start quiet so evidence stays clean. Go interventional when the next decision actually needs live detail."
- **Show:**
  - Tap each outcome box, then the quiet-first badge.
- **Do:**
  - Ask: "Which of these three fails first if you only store IOCs and never expand them?"
  - Drive toward: targeting options stay empty; you stay in detect-and-block mode.
- **Ask (Q):** Which of these three fails first if you only store IOCs and never expand them?
- **Expected Response (A):** targeting options stay empty; you stay in detect-and-block mode

### Slide 5: Passive Reconnaissance Defined (3 min)

- **Passive recon:** collect from existing sources
- No direct interaction with target systems/networks
- Sources: internal logs, IOCs, public OSINT
- Benefit: low detection risk; quiet early mapping
- Output: **leads**, not live confirmation

**Instructor Notes:**

- **Image Prompt:** Two-panel graphic. Left: analyst reading SIEM logs, malware sample strings, and a public OSINT page—no packets leaving toward the adversary. Right: a "do not touch" shield over an adversary C2 icon.
- **Say:**
  - "Passive recon means you work from what already exists."
  - "Logs, IOCs already in blue space, and open-source data."
  - "You do not open a session to the target to get the answer."
  - "Payoff: low detection risk and a clean early profile."
  - "That profile is leads—it points you. It does not by itself prove what is listening right now."
- **Show:**
  - Point at the blue-space sources panel.
  - Point at the "no direct interaction" shield.
- **Do:**
  - Ask: "Is querying crt.sh for a known IOC domain passive or active? Why?"
  - Confirm: third-party public logs, no packets to the adversary host = passive.
  - Students add a one-line definition under Passive.
- **Ask (Q):** Is querying crt.sh for a known IOC domain passive or active? Why?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 6: Active Reconnaissance Defined (3 min)

- **Active recon:** direct probing of adversary infrastructure
- Examples: port scanning, vulnerability enumeration
- Higher detection risk; richer live detail than passive alone
- Reveals or verifies what observation could not
- Feeds exploitation and effects planning

**Instructor Notes:**

- **Image Prompt:** Contrast graphic. An ops station sending probe packets toward an adversary host; a detection alert icon lights up on the adversary side. Caption: "Richer detail, higher signature."
- **Say:**
  - "Active recon is interventional."
  - "You probe to elicit a response—ports, services, versions."
  - "You get live detail that passive sources often cannot provide."
  - "You also accept higher detection risk."
  - "That is the block we will teach in depth: scan mechanics, Nmap, enumeration, and OPSEC."
- **Show:**
  - Trace the probe path and the detection icon.
- **Do:**
  - Ask students to add "port scan / service enum" under their Active column.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Passive vs Active — Distinctions (3 min)

- **Passive:** observational; points you toward leads from artifacts and public data
- **Active:** interventional; verifies those leads or reveals what passive could not
- Sequence: **observe → reveal/verify → act**
- Blue-space edge: controlled vantage; probes can blend with expected traffic

**Instructor Notes:**

- **Image Prompt:** Three-step flow left to right: Observe (passive artifacts/public data) → Reveal/Verify (active probing) → Act (follow-on operations). Soft arrow between Observe and Reveal/Verify labeled "leads," not "confirmed target." Small callout: "Blue-space vantage."
- **Say:**
  - "Passive is observational—it points you in the right direction and generates leads."
  - "Active either verifies those leads or surfaces information that was not available from passive collection alone."
  - "You do not go loud because you are curious."
  - "Working sequence: observe, then reveal or verify, then act."
  - "Blue-space advantage: you control the probing environment and can launch from paths the adversary already engaged."
- **Show:**
  - Trace observe → reveal/verify → act on the flow graphic.
  - Point at the blue-space callout.
- **Do:**
  - Ask: "Give one example of jumping to active too early."
  - Correct toward: scanning every IOC IP before OSINT/correlation.
- **Ask (Q):** Give one example of jumping to active too early.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 8: When to Go Active (3 min)

- Passive collection produced relevant leads
- Need to reveal or verify live services for the next decision
- Timing: after correlating passive evidence, then verify and enumerate
- OSINT builds the lead picture; scanning verifies live services
- Lecture weighting: passive = orientation; active = primary skill

**Instructor Notes:**

- **Image Prompt:** Dark ops-table decision strip with four stations: Passive hit (IP/domain card) → Corroborate leads (OSINT tiles) → Active verify (scoped probe) → Deeper enum (service profile). No footer chips, no lab names, no lesson numbers.
- **Say:**
  - "Do not go active because you are curious."
  - "Transition when passive recon already identifies potential targets—IP ranges hosting malware C2, staging hosts, related infrastructure."
  - "You need to reveal or verify live services before you plan the next action."
  - "Classic path: passive DNS yields a suspect domain; active scanning reveals which services are actually up and useful."
  - "How the two types share this hour: OSINT is keyboard work on public sources. This lecture does not treat passive as a second full skill block."
  - "Nmap decisions are the primary skill this hour is built around."
- **Show:**
  - Walk the four stations left to right.
- **Do:**
  - Ask: "What is one sign you jumped active too early?"
  - Correct toward: scanning every IOC IP before correlation / OSINT enrichment.
- **Ask (Q):** What is one sign you jumped active too early?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 9: Passive Reconnaissance (3 min)

**Instructor Notes:**

- **Image Prompt:** Full-bleed transition image. Analyst workspace with logs, a sample, and public OSINT tiles—no outbound probe path. Large centered title only: "Passive Reconnaissance." No bullet list. Optional subtitle: "Good to know—leads, not the primary graded skill."
- **Say:**
  - "Short orientation block: what passive collection looks like so you can build leads."
  - "Keyboard OSINT is where you practice targeting and TTP development from public sources. Here we cover the picture you need so active recon has something worth verifying."
- **Show:**
  - Hold the title/image long enough for a mental reset, then advance.
- **Do:**
  - Tell students: "Keep the Passive column open. We will fill it with artifact classes and OSINT pivots, then move on."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 10: Mine What They Already Left (3 min)

- Start with IOCs and artifacts the adversary already left behind
- Brief reminder: IOCs are traces (IPs, domains, hashes, keys, patterns)
- Mine them without generating new traffic toward the adversary
- Shift: same alert data → operations insight (timelines, leverage, weakness)

**Instructor Notes:**

- **Image Prompt:** Blue-space evidence stack (logs, disk, captures) with IOC tags (hash, domain, cert, key, timing). Arrow from "Alert data" to "Targeting insight" without any outbound probe path. Small pyramid inset: Detection → Timeline / TTP → Leverage.
- **Say:**
  - "The first place to mine passive information is what the adversary already left in blue space."
  - "You already know IOCs—addresses, names, hashes, keys, patterns. This is a reminder, not a new taxonomy."
  - "You analyze those artifacts where they already live. You do not create new traffic to get them."
  - "Detection is the floor, not the ceiling. Mine IOCs for how the adversary operates, rebuild timelines, and find leverage—configs, credentials, behavioral patterns."
  - "Standard: actionable intelligence—not another unread alert."
- **Show:**
  - Point from alert-data label to targeting-insight label.
  - Climb the small pyramid inset.
- **Do:**
  - Tell students: "For the next slides, ask: what decision does this artifact unlock?"
  - Quick call: "Hash vs domain—which usually expands infrastructure faster in OSINT?"
  - Drive toward: domains/IPs often open more pivot edges; hashes confirm tooling.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 11: High-Value Artifact Classes (3 min)

- **Credentials:** embedded C2 keys, staging logins—strings on samples you already hold
- **Certificates:** SANs and mismatched/expired TLS material in captures and logs
- **Timing:** beacon intervals and login windows in SIEM timelines
- **Keys / configs:** memory, registry, temp files that unlock more IOCs

**Instructor Notes:**

- **Image Prompt:** Four-tile board: Credentials (strings → FTP/C2 secret), Certificates (SAN list highlighted), Timing (02:00 UTC beacon ticks), Keys/Configs (memory dump → decrypted IOC list). Caption: "Passive dissection only."
- **Say:**
  - "Four artifact classes that routinely pay."
  - "Attacker tooling often hardcodes its own credentials—API keys, staging logins, exfil FTP. Pull them with strings review on the sample you already have. Reuse maps shared infrastructure."
  - "C2 often rides TLS. Dissect certs you already captured—openssl, Wireshark. SANs list extra names. Bad dates and mismatches signal poor OPSEC."
  - "Timing is an IOC class of its own: login times, exfil windows, beacon intervals. Predictable windows support later decoys and timed effects."
  - "Implants leave crypto material and configs in memory, registry, and temp files. If you already have a dump, extract passively. Keys can decrypt captured traffic and expose more IOCs."
  - "Certificate transparency as a domain-expansion tool comes two slides from now—same CT idea, applied to names rather than to a single leaf cert."
- **Show:**
  - Tap each of the four tiles.
- **Do:**
  - Ask: "Why might a SAN list be more valuable than the leaf CN alone?"
  - Confirm: reveals related infra the CN hides.
  - Follow-up if time: "What evidence would you record besides an embedded password?" Drive toward: where found, which sample/hash, what service it authenticates to.
- **Ask (Q):** Why might a SAN list be more valuable than the leaf CN alone?
- **Expected Response (A):** where found, which sample/hash, what service it authenticates to

### Slide 12: Case Study — SolarWinds (Passive Path) (3 min)

- Seed: tampered DLL hashes and embedded domains (public reporting)
- Strings → C2 names, user agents, staged-update timing
- Expand passively via **certificate transparency** (e.g., crt.sh)
- Lesson: the same IOC pile can drive offensive intelligence

**Instructor Notes:**

- **Image Prompt:** Compact flow: vendor update → tampered DLL (hash + embedded domain) → strings panel → kill-chain / timing map → crt.sh related names. Dimmed box at the end labeled "later phase." Caption: "Evidence first; access later."
- **Say:**
  - "Case study: SolarWinds—method, not a lab procedure."
  - "Tampered DLLs produced specific hashes. Embedded domains pointed at attacker infrastructure in public reporting."
  - "Passive strings analysis exposed C2 domains and mimicking user agents, and helped map staged-update timing."
  - "Take extracted C2 domains into certificate transparency. Expand related names without touching adversary hosts."
  - "If SSL material is reused, later phases may consider impersonation or a controlled endpoint. Any follow-on still lines up with observed beacon timing."
  - "Today's standard: evidence quality and target expansion—not jumping straight to access."
- **Show:**
  - Trace hash/domain seed → strings → CT expansion → dimmed later-phase box.
- **Do:**
  - Ask: "What would you put in the handoff note after the CT pivot?"
  - Accept: related names, cert linkage, confidence, still-passive status.
- **Ask (Q):** What would you put in the handoff note after the CT pivot?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 13: OSINT for Targeting and TTP Development (3 min)

- Public data maps adversary infrastructure and TTPs
- Source families: intel feeds; search/DB (Google, Shodan/Censys on known IOCs); paste/social
- Process: seed IOC → linked infra → report TTP cross-check → technique fit
- SI assistants accelerate research—verify every SI-sourced lead

**Instructor Notes:**

- **Image Prompt:** Three-column source board—Feeds, Search/DB, Social/Forums—feeding a four-step flowchart: Seed IOC → Linked infra → TTP cross-check → Technique selection. Small "SI assist → verify" badge that does not dominate the layout.
- **Say:**
  - "OSINT uses public data to map adversary infrastructure and TTPs."
  - "The product is a target map and starting points for techniques that fit that map—not a link dump."
  - "Three source families: feeds and sharing platforms; search and internet-wide databases for passive fingerprinting of known-bad IPs; social and paste sites for leaked tools and configs."
  - "Process, not tool worship: seed IOC, expand linked infrastructure, cross-check reputable reporting for TTPs, then select techniques that fit."
  - "Graphing tools help you see relationships faster—they do not replace judgment."
  - "SI assistants are fair game for speeding literature search and pivot brainstorming. Treat SI as an accelerator, not a crutch. Anything an assistant suggests is a lead until you verify it in primary sources."
  - "Shodan-style queries stay tied to IOCs you already have; you are not fishing the whole internet for sport."
  - "Still public-source only—no direct contact with attacker systems."
- **Show:**
  - Walk each source column, then the four process steps.
  - Point at the SI-verify badge.
- **Do:**
  - Ask: "Which source family would you hit first with a brand-new malware hash?"
  - Prefer: feeds / VT-class analyzers, then expand.
  - Follow-up: "Name one way you would verify a SI-suggested domain before it enters your target map."
  - Give a seed: "Hash of a dropper from last night's alert." Students verbalize the next two pivots.
- **Ask (Q):** Which source family would you hit first with a brand-new malware hash?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 14: Domain Expansion Tools (3 min)

- Domains are often the hub (phishing, C2)
- **WHOIS / RDAP:** registrant and shared-org clues
- **Passive DNS:** historical records and subdomains
- **Certificate transparency:** crt.sh for related names (same CT idea as the case study—now for domain pivots)
- **Correlation:** shared IPs / ASNs via analyzers and reporting

**Instructor Notes:**

- **Image Prompt:** Hub-and-spoke domain in the center; four tool tiles around it: WHOIS/RDAP, Passive DNS, CT Logs, IP/ASN Correlation. Small callback note on the CT tile: "Seen on SolarWinds—now for domain pivots." Caption: "Passive domain expansion."
- **Say:**
  - "Domains are often the hub of the operation. Passive work reveals additional targets and how the actor organizes names."
  - "WHOIS and RDAP for registrant and contact pivots."
  - "Passive DNS for historical resolutions and subdomains—without live brute force."
  - "Certificate transparency—you just used this idea on the SolarWinds opportunity path. Here it is a domain-expansion tool: crt.sh and CT logs for names that never showed in your logs."
  - "Correlate shared IPs and ASNs to map the wider net."
  - "Application: start from a domain already in blue-space logs, enumerate neighbors, push new names back through feeds. That loop is expand, enrich, prioritize."
  - "On a keyboard, domain pivots from a seed name are a primary OSINT move—watch for that pattern."
- **Show:**
  - Touch each tile; stress "historical / public" vs "live brute."
  - Explicitly call back to the case-study CT mention when pointing at the CT tile.
- **Do:**
  - Ask: "crt.sh vs subdomain brute—which is in scope for this orientation block?"
  - Confirm: crt.sh.
- **Ask (Q):** crt.sh vs subdomain brute—which is in scope for this orientation block?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 15: Passive Vulnerability Intelligence (3 min)

- IOC-seeded public data on exposed adversary services—not a scan you launch
- CVE / Exploit-DB keyed by versions from fingerprints you already have
- Shodan-class banners on known attacker domains/IPs
- Output: candidate weaknesses for planning, including later disruption options

**Instructor Notes:**

- **Image Prompt:** Three source lanes (CVE DBs, search banners, vuln intel platforms) merging into "Exploitable weakness candidates." Boomerang inset: leftover attacker tooling → public vuln intel → planned disrupt/deny option. Caption: "Seeded by IOCs—not random internet hunting."
- **Say:**
  - "Last passive technical beat: vulnerability searches against attacker infrastructure using public data."
  - "Purpose: inform planning—not spray exploits in class today."
  - "CVE and exploit databases keyed by versions you learned from fingerprints."
  - "Shodan-class queries against domains or IPs you already attribute."
  - "Attackers use open-source stacks and aging builds. Tools left in blue-space artifacts expose versions you can research. Note weak C2 panels as later disruption options."
  - "Example workflow: IOC IP, Shodan banner, CVE match, then OSINT on whether that actor reused that stack."
  - "You are building a decision-quality note, not firing the exploit in this lesson."
- **Show:**
  - Merge the three lanes into the candidate list, then the boomerang inset.
- **Do:**
  - Ask: "Why does 'hostname:malicious.com port:443' stay closer to passive tradecraft than a full port sweep you initiate?"
  - Confirm: using third-party collected data on a known IOC vs generating your own probe storm.
  - Follow-up: "What two fields belong in that note besides the CVE ID?" Accept: evidence source, confidence, recommended next phase (active verify / access / effect).
- **Ask (Q):** Why does 'hostname:malicious.com port:443' stay closer to passive tradecraft than a full port sweep you initiate?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 16: Passive Product — A Lead Package (3 min)

- Infra sketch, related names/IPs, confidence, still-passive status
- OSINT is noisy and can be stale—validate across sources
- Handoff question: what must active recon reveal or verify next?
- This hour now moves from the lead picture to probing

**Instructor Notes:**

- **Image Prompt:** Oversized lead-package card on a dark desk: Seed IOC, Related infra, Confidence, Still-passive: yes, Next verify question. No footer, no lab names. Caption on the card: "Another operator can act from this note."
- **Say:**
  - "Passive work is done when another operator can act from the note."
  - "Minimum package: infrastructure sketch, related names or addresses, confidence, and an explicit still-passive status."
  - "OSINT lies. It is noisy and can be stale. Validate across sources before you treat a name as a target."
  - "The handoff question is operational: what must active recon reveal or verify before the next decision?"
  - "OSINT targeting and TTP development is keyboard work on public sources. You now have the picture; we move to active reconnaissance."
  - "We now move to the primary skill block: active reconnaissance."
- **Show:**
  - Fill the lead-package card fields top to bottom.
- **Do:**
  - Ask: "How can one IOC—say a hardcoded password—shift hunting from reactive alerts to proactive targeting?"
  - Force at least one comment on validation discipline (multi-source check).
  - Students write one sentence: "My first pivot from a new IOC will be ___ because ___."
- **Ask (Q):** How can one IOC—say a hardcoded password—shift hunting from reactive alerts to proactive targeting?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 17: Active Reconnaissance (3 min)

**Instructor Notes:**

- **Image Prompt:** Section divider only. Dark operational backdrop with a probe path from a blue-space ops node to a highlighted adversary host. Large centered title: "Active Reconnaissance." No bullet stack. Optional subtitle: "Reveal or verify—then document the cost."
- **Say:**
  - "You have leads. Active recon is how you reveal or verify live services, versions, and OS clues."
  - "The rest of this block is scan mechanics, Nmap, service enumeration, OPSEC, and one ATT&CK mapping for reporting."
- **Show:**
  - Hold on the title briefly, then advance.
- **Do:**
  - Tell students: "When we hit Nmap, every flag should map back to a packet behavior or a detection cost you can explain."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 18: Mutual Hunt and Cost vs Gain (3 min)

- Adversary defenders may hunt your probes the way you hunt scans
- Targets log attempts; IDS/IPS and SIEM can correlate patterns
- Mitigate: stealth pacing, traffic mimicry, disciplined scope
- Weigh detection **cost** against intelligence **gain** that changes a decision

**Instructor Notes:**

- **Image Prompt:** Two hunters facing each other across a network map; your probes light up on their sensor dashboard. Beside it, a balance scale: "Detection cost" vs "Intel gain." Caption: "Mutual hunt. Blue space is control, not invisibility."
- **Say:**
  - "As threat hunters, you already know the adversary may hunt you too."
  - "Probes on their infrastructure can alert their defenders—the same way you detect scans in blue space."
  - "Hosts log connection attempts. IDS/IPS may flag scans. SIEM correlates sources, timing, and port order."
  - "Blue space gives controlled emission, not invisibility. Unusual patterns still stand out."
  - "Mitigation is tradecraft: stealth pacing, traffic mimicry, disciplined scope—not magic."
  - "Always weigh detection cost against intelligence gain. Vulnerability discovery that enables disruption can justify cost. Curiosity scans that do not change a decision do not."
  - "We will return to how the same traffic looks in their logs after you know the Nmap flags. Do not expect a second full risk lecture."
- **Show:**
  - Point at both hunter icons, then tip the balance scale both ways.
- **Do:**
  - Ask: "Give one Gain that would justify a noisier scan on a high-value C2 node."
  - Accept: confirm exploitable service/version needed for an effects plan.
  - Ask: "Name one pattern in your own SIEM that would flag a noisy scan."
- **Ask (Q):** Give one Gain that would justify a noisier scan on a high-value C2 node.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 19: Execution Standard for Active Recon (3 min)

- Validate the target before probes; align collection to campaign objectives
- Blue-space advantages: visibility and control; hit covert assets without self-compromise
- Goal: precise recon that enables effects (e.g., disrupt C2)
- Execution discipline beats volume scanning

**Instructor Notes:**

- **Image Prompt:** Mission-flow strip: Validated target → Scoped active recon → Usable service/version picture → Effects option (disrupt/degrade C2). Side badge: "Blue-space control."
- **Say:**
  - "Keep this block execution-focused."
  - "Coordinate with intelligence for target validation before you probe."
  - "Ensure probes align with campaign objectives—not every reachable host deserves a full sweep."
  - "Blue-space advantages: full visibility and control for planning. You can target covert, unrelated adversary assets without compromising friendly systems."
  - "Goal: generate effects—such as disrupt command and control—via precise reconnaissance-driven strikes."
  - "Precision and evidence quality beat noisy coverage."
- **Show:**
  - Walk the mission-flow strip left to right.
  - Linger on "Validated target" as the gate before packets.
- **Do:**
  - Ask: "What fails first if you skip target validation?"
  - Take one answer (wrong host, wasted signature, useless intel for effects).
- **Ask (Q):** What fails first if you skip target validation?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 20: Network Scanning Fundamentals (3 min)

**Instructor Notes:**

- **Image Prompt:** Section divider only. Large title "NETWORK SCANNING FUNDAMENTALS" over a restrained TCP/UDP packet-flow image; no labels or bullet stack.
- **Say:**
  - "We now move into the mechanics underneath every scanner."
  - "TCP and UDP behavior, port states, timing, and evasion explain the Nmap decisions that follow."
- **Show:**
  - Hold on the title briefly, then advance.
- **Do:**
  - Tell students: "When we hit Nmap, every flag should map back to a packet behavior you can explain."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 21: TCP/IP, Handshake, and Scan States (3 min)

- Focus layers: **Network** (IP) and **Transport** (TCP/UDP)
- Handshake: **SYN → SYN-ACK → ACK** (full connection / ESTABLISHED)
- Half-open: SYN → SYN-ACK → RST—never ESTABLISHED
- Counterops: TCP for reliable service intel; UDP for datagram-only services

**Instructor Notes:**

- **Image Prompt:** Simplified stack highlighting Network (IP) and Transport (TCP | UDP). Beside it, a three-way handshake sequence and a second path SYN → SYN-ACK → RST labeled "half-open / no ESTABLISHED."
- **Say:**
  - "Assume the baseline stack; scanning lives at Network and Transport."
  - "IP gets your probe to the adversary node. TCP is connection-oriented; UDP is connectionless."
  - "Full TCP connection: SYN, SYN-ACK, ACK—ESTABLISHED on the target."
  - "Half-open SYN scanning never completes the handshake, so many targets never log a full connection."
  - "Probe TCP when you need reliable service intelligence. Use UDP when you need discovery of services that only speak datagrams—DNS, some C2 channels, management protocols—knowing results are messier."
- **Show:**
  - Point at IP, then TCP, then UDP.
  - Walk the full handshake, then contrast the half-open RST path.
- **Do:**
  - Ask: "Which path leaves ESTABLISHED on the target?"
  - Confirm: only the full three-way.
  - Follow-up: "Why might a UDP-only C2 channel be missed by a TCP-only sweep?" Confirm: wrong transport = invisible service.
- **Ask (Q):** Which path leaves ESTABLISHED on the target?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 22: TCP Connect vs SYN Scan (3 min)

- **Connect (`-sT`):** full handshake—reliable, often through stateful firewalls, noisier logs
- **SYN (`-sS`):** half-open—faster, less full-session logging, needs raw sockets
- Default preference: SYN when privileges allow
- Use connect when thoroughness beats stealth on a high-value node

**Instructor Notes:**

- **Image Prompt:** Two comic strips side by side. Left: SYN → SYN-ACK → ACK with badge `-sT` and a red "Logged" stamp. Right: SYN → SYN-ACK → RST with badge `-sS` and note "No ESTABLISHED" plus a raw-sockets privilege icon.
- **Say:**
  - "TCP connect scan completes the full handshake—Nmap -sT. Reliable; often works where raw half-open probes are blocked. Noisier; creates full connection logs."
  - "SYN scan sends SYN, reads SYN-ACK for open, then RST—never completes the connect. Faster and typically less logging. Requires raw sockets, so root or admin on the scanner."
  - "Ideal default for quieter counterstrike probing when you have privilege."
  - "Choose -sT when stealth is secondary to thoroughness—for example, confirming services on adversary C2 before disruption planning."
- **Show:**
  - Trace both strips.
  - Point at Logged versus No ESTABLISHED.
- **Do:**
  - Ask: "Why does a SYN scan often need sudo (or equivalent privilege) with -sS?"
  - Confirm: raw packet craft needs privilege.
  - Students put "-sT / full connect" under Cost as high visibility; "-sS" as preferred when available.
- **Ask (Q):** Why does a SYN scan often need sudo (or equivalent privilege) with -sS?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 23: UDP Scan (3 min)

- Send UDP; open may respond or stay silent; closed often → ICMP unreachable
- Finds UDP services (DNS, some C2 / management) that TCP sweeps miss
- Slow, rate-limited, and often **open|filtered**—treat silence as ambiguous
- Follow ambiguous results with protocol-aware probes, not blind trust

**Instructor Notes:**

- **Image Prompt:** UDP scan decision tree: probe sent → (response | ICMP port unreachable | silence). Labels: open/open|filtered, closed, filtered/ambiguous. Badge: `-sU`.
- **Say:**
  - "UDP has no handshake, so results are inference-heavy."
  - "You send UDP packets; open ports may respond with service data—or nothing. Closed ports often return ICMP port unreachable."
  - "Pros: discovers UDP services such as DNS on attack servers. Cons: slow, rate-limited, and ambiguous."
  - "Application: enumerate UDP-based C2 or support channels that never appear on TCP sweeps."
- **Show:**
  - Walk the decision tree branches.
  - Emphasize silence as ambiguous, not "safe."
- **Do:**
  - Ask: "If UDP scan says open|filtered, what is your next move?"
  - Drive toward: protocol-aware probes / service-specific enum, not blind trust.
- **Ask (Q):** If UDP scan says open|filtered, what is your next move?
- **Expected Response (A):** protocol-aware probes / service-specific enum, not blind trust

### Slide 24: FIN, NULL, and Xmas Scans (3 min)

- **FIN / NULL / Xmas:** unexpected TCP flag combinations
- Can slip simple filters; modern stacks often break textbook assumptions
- Use against heavily filtered covert infra—verify results carefully
- Prefer SYN when you need a reliable open/closed call

**Instructor Notes:**

- **Image Prompt:** Three small packet icons labeled FIN, NULL (no flags), Xmas (FIN+PSH+URG). Arrow past a simple firewall glyph to an adversary host. Warning badge: "Interpretation fragile."
- **Say:**
  - "FIN, NULL, and Xmas scans abuse unexpected TCP flag combinations."
  - "FIN scan sends FIN; behavior differs on open versus closed depending on stack and filters."
  - "NULL has no flags; Xmas sets illegal combinations."
  - "Pros: may evade basic firewalls or IDS. Treat results as hypotheses—modern stacks and stateful devices often break the textbook assumptions."
  - "Use when targeting heavily filtered covert infrastructure from blue space—not as the default go/no-go scan."
- **Show:**
  - Point at each packet icon.
  - Point at the fragile-interpretation warning.
- **Do:**
  - Ask: "When would you trust -sS over a FIN scan for a go/no-go targeting decision?"
  - Drive toward: when you need reliable open/closed, not just filter bypass experiments.
- **Ask (Q):** When would you trust -sS over a FIN scan for a go/no-go targeting decision?
- **Expected Response (A):** when you need reliable open/closed, not just filter bypass experiments

### Slide 25: Port States — Open, Closed, Filtered (3 min)

- On-host (blue space): query listeners directly (`ss` / `netstat`)
- Remote scan: infer state from packet responses only
- **Open:** SYN-ACK—candidate surface
- **Closed:** RST / unreachable—no service
- **Filtered:** no useful response—do not treat as empty

**Instructor Notes:**

- **Image Prompt:** Two panels. Left "On-host visibility" with ss/netstat showing LISTEN. Right "Remote inference" with Open / Closed / Filtered tiles tied to SYN-ACK, RST, and silence/drop.
- **Say:**
  - "As defenders in blue space, you can query systems directly—ss, netstat—to see listening ports."
  - "When scanning adversary assets, you usually cannot; states are inferred from responses."
  - "Open: service accepting connections—SYN-ACK—and a potential exploit path."
  - "Closed: no service; typically RST."
  - "Filtered: no useful response—firewall drop—and it may hide services or simply deny you data."
  - "Reconnaissance goal: map these states on adversary infrastructure to prioritize counterstrike vectors."
- **Show:**
  - Contrast left panel direct visibility with right panel inference.
  - Tap Open, Closed, Filtered in order.
- **Do:**
  - Ask: "Which state is most dangerous to over-interpret as empty?"
  - Confirm: Filtered—absence of evidence is not evidence of absence.
- **Ask (Q):** Which state is most dangerous to over-interpret as empty?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 26: Timing — Speed, Detectability, Accuracy (3 min)

- Aggressive rate → fast intel, lights up IDS; slow spacing → quieter, longer
- Three knobs: **speed**, **detectability**, **accuracy**
- Start quiet from blue vantage; escalate only when the decision needs it
- Randomize intervals; align with the operational environment—avoid a metronome

**Instructor Notes:**

- **Image Prompt:** Triangle trade-off with vertices Speed, Detectability, Accuracy. Dual timeline inset: dense ticks with an IDS alert vs sparse ticks in baseline traffic. Random interval marks vs evenly spaced ticks crossed out. Caption: "Start quiet → escalate for decision-quality intel."
- **Say:**
  - "You have seen aggressive scans light up IDS in blue-space hunts. The same physics apply when you probe adversaries."
  - "Three knobs: speed maps blocks quickly; detectability drops when you slow pacing; accuracy needs enough coverage to verify evidence for follow-on effects."
  - "Strategy: start slow from a blue vantage, then escalate when the targeting decision actually requires richer data."
  - "Timing is part of OPSEC, not just performance. Align with adversary traffic patterns when blending matters. Randomize intervals so defenders cannot correlate a metronome of probes."
  - "From blue space, choose windows and paths that reduce signature."
- **Show:**
  - Point at each triangle vertex, then contrast dense vs sparse timelines.
  - Point at the randomized interval marks.
- **Do:**
  - Ask: "Which knob did you sacrifice last time you ran -T5 on a lab box—and was it worth it?"
  - Ask: "What evenly spaced interval would look like in your own SIEM?" Drive toward: easy correlation rule.
- **Ask (Q):** Which knob did you sacrifice last time you ran -T5 on a lab box—and was it worth it?
- **Expected Response (A):** easy correlation rule

### Slide 27: Evasion — Fragments, Decoys, Source Ports (3 min)

- **Fragmentation:** split PDUs so weak filters miss signatures; modern IDS may reassemble
- **Decoys:** extra source IPs to dilute attribution
- **Source port tricks:** common ports (e.g., 53) to mimic legit flows
- None of these erase scope—they reduce easy matches

**Instructor Notes:**

- **Image Prompt:** One logical TCP segment split into IP fragments passing a basic IDS; reassembly on the target. Beside it, real scanner IP plus decoy IPs; source-port callout "sport 53." Warning: "Modern IDS may reassemble too." Caption: "Dilute, mimic, pace."
- **Say:**
  - "Fragmentation breaks packets into pieces for reassembly on the target. Basic firewalls or IDS that inspect only full packets can miss the signature. Modern devices often reassemble. In Nmap, options like --mtu support this against weak perimeters—verify whether fragments helped or just broke the scan."
  - "Decoys spoof extra source IPs so logs fill with noise around your real scanner."
  - "Source port manipulation uses common ports—like 53—to mimic legitimate traffic classes. Timing pauses help evade rate-based IDS."
  - "From blue space, layer these with proxies or alternate egress when your plan supports it."
  - "None of these erase responsibility for scoped, deliberate collection."
- **Show:**
  - Trace whole packet → fragments → target reassembly.
  - Point at decoys, then the source-port callout.
- **Do:**
  - Ask: "Which evasion fails if the adversary only trusts allowlisted peers?"
  - Drive toward: decoys/spoofs that never receive replies; path/identity still matters.
  - Transition: "Nmap turns these mechanics into flags and workflows."
- **Ask (Q):** Which evasion fails if the adversary only trusts allowlisted peers?
- **Expected Response (A):** decoys/spoofs that never receive replies; path/identity still matters. - Transition:

### Slide 28: Nmap Deep Dive (3 min)

**Instructor Notes:**

- **Image Prompt:** Section divider only. Large title "Nmap Deep Dive" with a stylized terminal silhouette and a blue-space ops node aiming probes at a highlighted adversary host; no footer or bullet stack.
- **Say:**
  - "We just covered how packets and port states work."
  - "Now we put that model on a keyboard with Nmap."
- **Show:**
  - Hold on the title briefly, then advance.
- **Do:**
  - Tell students: "Keep the packet behavior model in mind as we translate it into Nmap decisions."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 29: Nmap as a Collection Platform (3 min)

- **Nmap:** open-source scanner for host and network discovery
- Core capabilities: ports, service/version, OS fingerprint, NSE scripts
- Treat every flag as a yield-versus-visibility choice
- Primary active collection tool for this hour

**Instructor Notes:**

- **Image Prompt:** Four capability tiles around an Nmap logo: Port Scan, Service/Version, OS Fingerprint, Scripting (NSE). Caption: "One tool, layered yield."
- **Say:**
  - "Nmap is open-source and ubiquitous for a reason."
  - "Ports tell you where to look; -sV and -O refine what is there; NSE automates deeper checks."
  - "In counteroperations, it is your primary active scanner against adversary infrastructure from blue space."
  - "Treat it as a collection platform—every flag changes yield and visibility."
- **Show:**
  - Walk the four capability tiles left to right.
- **Do:**
  - Ask: "Which capability is enough for a first pass, and which do you reserve for high-value nodes?"
  - Drive toward: port discovery first; version/OS/scripts when the node is confirmed and the intelligence gain justifies noise.
- **Ask (Q):** Which capability is enough for a first pass, and which do you reserve for high-value nodes?
- **Expected Response (A):** port discovery first; version/OS/scripts when the node is confirmed and the intelligence gain justifies noise

### Slide 30: Scope, Ports, Scan Types, Timing, Archive (3 min)

- **Target:** single host, CIDR, or name—size scope to the intelligence need
- **Ports:** `-p 22,80` focused; `-p-` full TCP
- **Types:** `-sS` SYN; `-sT` connect; `-sU` UDP
- **Timing:** `-T0` … `-T5`; prefer **T3–T4** for most recon
- **Output:** `-oA` so you do not rescan to recover notes

**Instructor Notes:**

- **Image Prompt:** Command-line callout `nmap <options> <target>` with chips for single IP / CIDR / hostname; port-spec examples; SYN / Connect / UDP badges; timing slider T0–T5 parked at T3–T4; `-oA` bundle icon.
- **Say:**
  - "Every Nmap run starts with a target definition—one IP, a CIDR block, or a resolvable name. Wider scope means more packets, more time, and more detection surface."
  - "Port selection controls how much of the attack surface you touch. -p 80,22 is focused; -p- is full TCP—slower and noisier."
  - "-sS is the classic SYN half-open scan—needs privileges. -sT completes the handshake. -sU covers UDP services TCP-only passes miss. Example for deep TCP coverage: nmap -sS -p- target."
  - "Timing templates trade speed for detectability. T0 is paranoid; T5 is insane. For most counterstrike recon, T3 to T4 is the practical balance."
  - "Always save results: -oN for human-readable notes, -oX for tooling, -oA for all common formats in one shot. If you do not archive output, you force a rescan—and a second detection event."
- **Show:**
  - Point at target chips, port specs, scan-type badges, the T3–T4 park, then the -oA bundle.
- **Do:**
  - Ask: "When would you scan a /24 instead of a single IP?"
  - Drive toward: suspected adversary address space after passive cues; not blind blasting of unrelated nets.
  - Tell students: "Name your output files so another operator can pick up your profile without re-probing."
- **Ask (Q):** When would you scan a /24 instead of a single IP?
- **Expected Response (A):** suspected adversary address space after passive cues; not blind blasting of unrelated nets. - Tell students:

### Slide 31: Versions, OS Fingerprint, and `-A` (3 min)

- **`-sV`:** protocol probes → banners → name and version for CVE matching
- **`-O`:** stack quirks vs `nmap-os-db`—worth it on high-value nodes
- **`-A`:** bundles `-sV`, `-O`, script scan, traceroute—high yield, high volume
- Stage collection: ports first; deepen where the profile justifies noise

**Instructor Notes:**

- **Image Prompt:** Flow: Open port → Probe → Banner → "nginx 1.x" tile. Beside it, stack-fingerprint features flowing into an OS match. A stacked `-A` badge wrapping Version, OS, Scripts, Traceroute with a high "noise" meter. Caption: "Convenience ≠ always appropriate."
- **Say:**
  - "-sV runs after you know something is open. It sends protocol probes and matches banners to the service database. Payoff is software name and version—inputs for CVE research. Do not run -sV on every host first."
  - "-O fingerprints the TCP/IP stack. Specialized probes elicit quirks; responses compare to nmap-os-db. That informs later payload and privilege-escalation choices. Often needs privileges and works best with at least one open and one closed port."
  - "-A is a convenience bundle: version detection, OS detection, default scripts, and traceroute. It multiplies probes. Use it when the node is high-value and you accept the detection trade-off. Do not default to -A on every host in a block."
  - "Prefer staged collection: ports first, then deepen where the profile justifies it."
- **Show:**
  - Trace Open port → Probe → Banner.
  - Point at each layer inside the -A stack and the high noise meter.
- **Do:**
  - Ask: "What decision does a version string unlock that an open port alone does not?"
  - Drive toward: specific exploit path and confidence that the service is what it appears to be.
  - Follow-up: "Rewrite -A as four explicit decisions—when would you skip one of them?"
- **Ask (Q):** What decision does a version string unlock that an open port alone does not?
- **Expected Response (A):** specific exploit path and confidence that the service is what it appears to be. - Follow-up:

### Slide 32: NSE — Defaults, Categories, and Recon Scripts (3 min)

- **`-sC`:** default script set—common enumeration after open ports
- **`--script`:** categories or names (`discovery`, `vuln`, `http-enum`)
- Lead with **discovery** and **vulnerability**; **brute** only when planned
- Example: `nmap --script http-enum,smb-os-discovery -p 80,445 target`

**Instructor Notes:**

- **Image Prompt:** NSE engine with Lua badge. Default-script chips (http-title, smb-os-discovery). Four category cards with Discovery and Vulnerability highlighted; Brute dimmed. Combined command strip with arrows to "Web paths" and "OS / SMB identity."
- **Say:**
  - "The Nmap Scripting Engine extends scanning with Lua scripts."
  - "-sC runs the default set—roughly the common safe enumeration scripts. Use it after you know which ports are open."
  - "--script lets you name categories or specific scripts. Discovery maps hosts and services. Vulnerability runs known-weakness checks. Exploit category is for safe probes—not a license to break things. Brute means credential guessing—only when the plan explicitly calls for it."
  - "Shortlist: http-enum for web paths; smb-os-discovery when 445 is open."
  - "You can chain scripts: nmap --script http-enum,smb-os-discovery -p 80,445 target. Focus packets on the ports that matter."
  - "Refresh the script database with nmap --script-updatedb after adding scripts. Match script intent to the current question; broad vuln categories are louder and slower."
- **Show:**
  - Point at -sC defaults, then highlighted Discovery/Vulnerability, then the combined command.
- **Do:**
  - Ask: "Why prefer --script http-enum over --script vuln on a first web pass?"
  - Drive toward: match script intent to current question.
  - Ask: "What would you add to the combined command for archival?" Drive toward: -oA.
- **Ask (Q):** Why prefer --script http-enum over --script vuln on a first web pass?
- **Expected Response (A):** match script intent to current question. - Ask:

### Slide 33: Example — Ports, Versions, Profile (3 min)

- Example sequence: `nmap -sS -p- target` → candidate listeners
- Then: `nmap -sV -p 22,80,443 target` → name and version
- Then: `nmap -sC -sV target` → enum details on top of banners
- Save output; unknown remaining work is part of the profile

**Instructor Notes:**

- **Image Prompt:** Three-step example strip on a briefing wall. Terminal 1: SYN scan table 22/80/443 open. Terminal 2: versioned lines (OpenSSH, nginx). Dossier card assembling Ports + Versions + Script findings. Caption: "Talk through the sequence—do not live-run."
- **Say:**
  - "This is a staged Nmap sequence—talk through it; do not treat this slide as a live demo."
  - "Ports first when you need complete TCP coverage: nmap -sS -p- target. Open 22, 80, 443 are candidate entry and enum paths—not yet versions or vulns."
  - "Deepen only the ports you care about: nmap -sV -p 22,80,443 target. Product and version turn a port list into a targeting package."
  - "Combine defaults and versions: nmap -sC -sV target. Scripts add titles, configs, and sometimes vuln indicators."
  - "Document what you ran, what you saw, and what you did not check. Next section: leave Nmap when a protocol-specific tool answers the next question better."
  - "This hour is the decision logic, not a keyboard run on an assigned host."
- **Show:**
  - Point at each open port, then version lines, then assemble the dossier on the graphic.
- **Do:**
  - Ask: "What is still unknown after the port-only scan?"
  - Drive toward: exact software versions, OS, and script-derived details.
  - Ask one student: "Given nginx 1.18 on 80, what is your next non-Nmap move?" Accept whatweb/nikto/dir busting.
- **Ask (Q):** What is still unknown after the port-only scan?
- **Expected Response (A):** exact software versions, OS, and script-derived details. - Ask one student:

### Slide 34: Service Enumeration Beyond Nmap (3 min)

**Instructor Notes:**

- **Image Prompt:** Section divider only. Large title "Service Enumeration Beyond Nmap" with Nmap results flowing into restrained protocol-tool icons; no labels or bullet stack.
- **Say:**
  - "Nmap has established a profile; the next slides use it to choose protocol-specific enumeration."
- **Show:**
  - Hold on the title briefly, then advance.
- **Do:**
  - Tell students: "Write the question before the command—then pick the tool that matches the observed service."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 35: Protocol-Specific Enumeration (3 min)

- **HTTP/HTTPS:** WhatWeb (stack), Nikto (issues), gobuster (paths)
- **SMB (445):** enum4linux, smbclient, smbmap
- **SNMP (UDP 161):** snmpwalk / snmp-check—often missed by TCP-only scans
- **DNS:** AXFR and record enum → names that IP scans never show
- **Banners:** nc/telnet on FTP/SSH; RDP with care

**Instructor Notes:**

- **Image Prompt:** Decision flowchart: Open ports → Choose protocol toolkit → Collect evidence → Update target profile. Five small tool rows matching the bullets. Caption: "Every new tool is another detection event."
- **Say:**
  - "Deep enumeration is a deliberate second phase. Read the Nmap profile, then choose the tool that matches the observed service."
  - "On 80/443: WhatWeb fingerprints technologies and CMS; Nikto looks for known issues; gobuster brute-forces directories. WhatWeb answers 'what is running?'; gobuster answers 'what paths exist?'"
  - "On 80/443/80**: Curl the webpage to answer webapp specific version and basic functionality"
  - "When 445 is open: enum4linux aggregates users and shares; smbclient and smbmap work the share surface."
  - "SNMP on UDP 161 can spill device and network configuration. snmpwalk -v2c -c public target is still worth trying when SNMP is exposed. Treat community strings as credentials."
  - "DNS enum finds names that IP scans never show—dig axfr when allowed; dnsenum/fierce-class tools for records. New names feed back into scanning."
  - "Remote admin services often speak versions in the clear: nc target 22 for SSH. Manual banner grabs help when you need a quick confirm or constrained tooling."
  - "Every new tool is another detection event—justify it with a question the prior output cannot answer."
- **Show:**
  - Walk the flowchart, then tap each protocol row.
- **Do:**
  - Ask: "What Nmap clue would push you to SMB tools first?" Drive toward: open 445 and/or smb-os-discovery.
  - Ask: "Why is SNMP often missed after a TCP-only scan?" Drive toward: UDP—requires -sU or dedicated UDP checks.
  - Ask: "How does DNS enum reconnect to Nmap?" Drive toward: newly discovered names/IPs become the next scan targets.
- **Ask (Q):** What Nmap clue would push you to SMB tools first?
- **Expected Response (A):** open 445 and/or smb-os-discovery. - Ask:

### Slide 36: Example — HTTP Enum and the Target Profile (3 min)

- Example: `whatweb target`; `nikto -h target` on an open web listener
- Compile: ports → services → versions → paths / vuln candidates
- Example profile: Linux; aged SSH; Apache with `/admin`
- A usable profile is more than open ports on screen

**Instructor Notes:**

- **Image Prompt:** Example terminal with whatweb fingerprint lines and a Nikto summary. Beside it, a profile template card: IP, OS, Services (with versions), Notable paths/vulns, Recommended next actions. Caption: "Handoff-ready intelligence—talk through, do not live-run."
- **Say:**
  - "Same rule as the Nmap sequence: this HTTP enum chain is a talk-through. Do not live-run WhatWeb or Nikto in this hour."
  - "whatweb fingerprints stack and CMS. nikto -h target surfaces known-issue candidates."
  - "Interpret: technology plus weakness candidates become options for web-focused follow-on actions. Same discipline as Nmap—save output, explain what it means, state what you still need."
  - "Enumeration is not done until it is compiled. Build the chain: ports, services, versions, then vuln/path findings."
  - "Example profile: Linux host, aged SSH, Apache with an /admin path—enough for a planner to act."
  - "If another operator cannot act from your notes, you collected noise, not intelligence. Grade yourself on a readable profile, not only open ports."
- **Show:**
  - Point at whatweb lines first, then Nikto highlights, then fill the profile card top to bottom on the graphic.
- **Do:**
  - Ask: "Which finding would change your next tool choice?"
  - Take one concrete student answer.
- **Ask (Q):** Which finding would change your next tool choice?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 37: OPSEC and Detection Considerations (3 min)

**Instructor Notes:**

- **Image Prompt:** Section divider only. Large title "OPSEC and Detection Considerations" over a two-sided mirror of a probe and an alert; no labels or bullet stack.
- **Say:**
  - "You already have cost versus gain. We now look at the same traffic from their defenders' view."
  - "Connect each OPSEC choice to the evidence it creates—without re-teaching the mutual-hunt slide."
- **Show:**
  - Hold on the title briefly, then advance.
- **Do:**
  - Tell students: "Name the log story your flags would write before you run them."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 38: How the Scan Looks to Their Defenders (3 min)

- Same patterns you hunt in blue space: SYN volume, sequential probes, odd sources
- Firewall drops, IDS signatures (including Nmap patterns), app logs, SIEM correlation
- Filtered is still intelligence—perimeter behavior is a finding
- Mitigate: randomize timing/sources; fragment; decoys—on a justified scan

**Instructor Notes:**

- **Image Prompt:** Defender dashboard mockup with alerts: "Port sweep," "Multiple SYNs," "NMAP SYN scan," app 401/403. Mitigation chips underneath: randomize, fragment, decoy, pace. Caption: "You already know these signatures—from the other side."
- **Say:**
  - "Your probes look like incoming scans on their infrastructure."
  - "Firewalls record drops even when ports are filtered. IDS/IPS may match known Nmap probe patterns. Application logs catch failed logins and verbose enum. SIEM stitches those events into a hunt narrative."
  - "If the firewall drops everything, you still learned perimeter behavior—filtered is not a wasted scan if you document it."
  - "Mitigate with randomized timing and sources, fragmentation where it still helps, and decoys when infrastructure supports them. Mitigation is tradecraft layered on a justified scan—not a substitute for scoping."
  - "Protocol-specific tools can be louder at the app layer than a quiet SYN scan—nikto and gobuster volume versus lighter fingerprinting."
- **Show:**
  - Point at each alert type, then the mitigation chips.
- **Do:**
  - Ask: "Which of your Nmap habits creates the loudest SIEM story?"
  - Drive toward: -p- at T5, -A across a subnet, brute NSE categories.
  - Ask students to pair one scanning IOC with one mitigation they would actually configure.
- **Ask (Q):** Which of your Nmap habits creates the loudest SIEM story?
- **Expected Response (A):** -p- at T5, -A across a subnet, brute NSE categories. - Ask students to pair one scanning IOC with one mitigation they would actually configure

### Slide 39: Blend, Pace, and Operational Infrastructure (3 min)

- Mimic expected user-agents and common source ports when tools allow
- Distribute probes over time and multiple egress IPs
- Pace: intervals and volume caps; T0–T2 when stealth outweighs speed
- Emit from blue-space paths the adversary already expects

**Instructor Notes:**

- **Image Prompt:** Traffic mix chart with a thin recon strand woven through benign bars. Timeline of spaced probe ticks versus a burst that trips a rate alert. Ops diagram: probe path rides an expected response corridor from defended blue egress. Caption: "Path is part of OPSEC."
- **Say:**
  - "Use your defensive experience—know what benign looks like on the wire."
  - "Mimic legitimate user-agents and common source ports when tools allow. Spread probes across time and multiple blue egress addresses to dilute correlation."
  - "Pace probes the way patient adversaries pace persistence. Intervals on the order of minutes can evade simple rate rules. Cap ports-per-window when stealth outweighs speed. T0–T2 templates and manual pauses are Nmap levers for the same idea."
  - "Where you emit from matters as much as what you send. Prefer blue-space infrastructure the adversary has already engaged. Do not burn one-off unrelated paths when a supported ops path exists."
  - "Goal: force their hunters to sift false positives—the same problem you face in blue space."
- **Show:**
  - Point at the thin recon strand, then spaced ticks, then the expected-corridor path.
- **Do:**
  - Ask: "What breaks blending even if timing is perfect?"
  - Drive toward: unique probe signatures, impossible geo/path, or volume that still spikes baselines.
  - Ask: "When is a fast T4/T5 scan the right call anyway?" Drive toward: short windows, perishable intel, or low-sensitivity lab/sim targets.
- **Ask (Q):** What breaks blending even if timing is perfect?
- **Expected Response (A):** unique probe signatures, impossible geo/path, or volume that still spikes baselines. - Ask:

### Slide 40: Document the Noise You Accepted (3 min)

- High risk: aggressive scans → faster vulns, louder alerts
- Low risk: slower / passive follow-up → thinner confirmation
- Decide per mission: effects need vs footprint cost
- Write the rationale in the profile so the next operator understands it

**Instructor Notes:**

- **Image Prompt:** Balance scale: "Intelligence gain" vs "Detection risk." Mission card in the center: objective, time available, target value. Caption: "Choose deliberately; document why."
- **Say:**
  - "Every active technique sits on a trade-off. Aggressive scans buy speed and depth—and raise the chance their hunters notice. Low-and-slow or passive follow-up reduces footprint but may leave gaps."
  - "Decide from the mission: what intelligence is required to enable the next effect, and what footprint that is worth."
  - "Blue-space control helps you manage the hunt—it does not remove the trade-off."
  - "Write the rationale in the profile so the next operator understands the noise you accepted."
- **Show:**
  - Tip the scale both ways with example scenarios (quick C2 disruption intel vs. long-dwell mapping).
- **Do:**
  - Ask: "Pick one flag from today that you would drop first if detection risk spiked."
  - Transition: "Map the same work to MITRE ATT&CK so reporting stays standard."
- **Ask (Q):** Pick one flag from today that you would drop first if detection risk spiked.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 41: Mapping to MITRE ATT&CK® (3 min)

**Instructor Notes:**

- **Image Prompt:** Section divider only. Large title "Mapping to MITRE ATT&CK®" with an ATT&CK matrix snippet highlighting Reconnaissance → T1595 Active Scanning; no labels or bullet stack.
- **Say:**
  - "TA0043 was the tactic at the start of the hour."
  - "We now name the active-scanning technique so reporting uses shared IDs—not tool names alone."
- **Show:**
  - Hold on the title briefly, then advance.
- **Do:**
  - Tell students: "Map the scan behavior—not just the tool name—to the technique that follows."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 42: T1595 — Active Scanning (3 min)

- Technique **T1595** Active Scanning under **TA0043**
- Flip the technique: scan *their* infrastructure for counterops
- **T1595.001** Scanning IP Blocks — CIDR / range sweeps
- **T1595.002** Vulnerability Scanning — `-sV` and vuln-oriented scripts
- Report the sub-technique you actually ran

**Instructor Notes:**

- **Image Prompt:** ATT&CK technique card for T1595 with two columns: T1595.001 (range scan icon) vs T1595.002 (vuln/script icon). Arrow from "blue-space scan" to "adversary infra map." Footer: "Report the sub-technique you actually ran."
- **Say:**
  - "T1595 is Active Scanning—sending probes to learn the target."
  - "Adversaries use it against us; we flip it and scan their infrastructure for counteroperations."
  - "T1595.001 covers scanning IP blocks—your CIDR and range sweeps. When you nmap a suspected attack network range, you are exercising that sub-technique."
  - "T1595.002 is vulnerability scanning—version probes and vuln-oriented scripts."
  - "Split your reporting when both apply. Do not claim .002 if you only ran a port list with no version or vuln checks."
- **Show:**
  - Point at T1595, then each sub-technique column with a matching Nmap example.
- **Do:**
  - Ask: "Which sub-technique is a wide nmap of a suspect /24? Which is -sV plus vuln scripts on open ports?"
  - Confirm: .001 then .002.
  - Ask: "Does -sS -p- alone equal T1595.002?" Drive toward: no.
- **Ask (Q):** Which sub-technique is a wide nmap of a suspect /24? Which is -sV plus vuln scripts on open ports?
- **Expected Response (A):** no

### Slide 43: Recon Feeds Initial Access (3 min)

- Active recon → **TA0001 Initial Access**
- Example path: scan finds vuln → **T1190** exploit public-facing app
- Campaign: recon yield becomes the effects-chain input
- Own the quality of the recon handoff; access comes later

**Instructor Notes:**

- **Image Prompt:** Arrow chain: T1595 Active Scanning → finding (CVE/path) → T1190 Exploit Public-Facing Application → foothold. Caption: "Recon is not the end state."
- **Say:**
  - "Active recon feeds Initial Access (TA0001)."
  - "Classic path: scan reveals a vulnerable public app; exploit it via T1190."
  - "Your Nmap and enum profile is the input to that decision—not the disruption itself."
  - "In a campaign, collection quality determines how precise the first effect can be."
  - "Later lessons pick up access; today you own the quality of the recon handoff."
- **Show:**
  - Trace the arrow chain end to end.
- **Do:**
  - Ask: "What must be in the recon profile before someone attempts T1190?"
  - Drive toward: service, version, evidence of weakness, and scoped target identity.
- **Ask (Q):** What must be in the recon profile before someone attempts T1190?
- **Expected Response (A):** service, version, evidence of weakness, and scoped target identity

### Slide 44: Lesson Summary (3 min)

- Recon as a whole: **reconnoiter** / **TA0043** against adversary infra from blue space
- Passive = observe → **leads**; active = reveal/verify → live profile
- Sequence: **observe → reveal/verify → act**
- Building blocks: artifacts/OSINT for leads; Nmap/enum/OPSEC for confirmation
- Report active scanning as **T1595** (and the sub-technique you ran)

**Instructor Notes:**

- **Image Prompt:** Two foundation layers. Bottom: IOCs, OSINT, Domains supporting "Lead package." Top: Nmap, Enum, OPSEC supporting "Live profile → T1595." Arrow between layers labeled "Reveal/Verify."
- **Say:**
  - "Summary of the contract."
  - "Reconnaissance is collection against their infrastructure from blue space—reconnoiter, TA0043."
  - "Passive observation produces leads. Active probing reveals or verifies live services."
  - "You do not skip the sequence because you are curious."
  - "Passive orientation used artifacts, OSINT, and domain pivots. Active skill used scan mechanics, Nmap, enumeration, and OPSEC."
  - "You can name the active work as T1595 and its sub-techniques for clean reporting."
- **Show:**
  - Tap the lead-package layer, then the live-profile layer, then the T1595 label.
- **Do:**
  - Ask for one takeaway per row of the room—keep answers to one sentence.
  - Prefer a mix: one passive pivot habit, one Nmap flag discipline.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 45: The Decision Loop You Leave With (3 min)

- **OSINT:** seed IOC → public pivots → lead package (passive)
- **Nmap:** scoped scan → versions/scripts → handoff-ready profile (active)
- Take today's sequence and OPSEC discipline onto the keyboard

**Instructor Notes:**

- **Image Prompt:** Split ops floor. Left workstation: OSINT tiles around a seed IOC card building a lead package. Right workstation: Nmap terminal assembling a live host profile. Center banner: "Observe, then reveal or verify." No lab names, no lesson numbers, no arrows labeled as later hours.
- **Say:**
  - "Two skill loops leave this hour."
  - "OSINT is the passive picture: targeting and TTP development from a seed IOC."
  - "Nmap is the active picture: scan, build profiles, and plan follow-on options from evidence."
  - "Take today's habits with you: observe first, deepen on purpose, save output, manage footprint."
  - "Reasoned pivots and flag choices matter more than a pile of names or open ports."
- **Show:**
  - Point at the OSINT station, then the Nmap station.
- **Do:**
  - Tell students: "For scanning, review -sS, -sV, -sC, -oA, and timing. For OSINT, review seed-to-pivot and multi-source validation."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 46: Questions (3 min)

- Open floor
- Leave with a lead package and a scan plan

**Instructor Notes:**

- **Image Prompt:** Empty dark classroom projection with a single large word "Questions" centered. No footer, no next-hour text, no lab names.
- **Say:**
  - "Questions on the passive/active line, OSINT pivots, Nmap flags, enumeration, or OPSEC?"
  - "Deep OSINT technique and deep scan mechanics both belong in this discussion if they change how you collect in this hour."
  - "If it is tradecraft—when to go active, scan choice, profiling—ask now so the room hears it."
- **Show:**
  - Hold the questions title; do not preview another hour.
- **Do:**
  - Take questions for the remaining time.
  - Close: "Leave with a lead package in mind and a scan plan—not just a default command."
- **Ask (Q):** What one takeaway are you carrying out of this hour?
- **Expected Response (A):** Facilitation. Prefer a lead package plus a scan plan—not a default command.

---

## Improvement notes

- **New combined guide.** Originals archived under `old/`: `2.1 Intro to Info Gathering and Passive Recon Content Guide.md` and `../02-info-gathering-recon/content-guide.md`.
- **Slide count:** 46 (vs 30 + 65 if the two decks were concatenated).
- **Structure:** Recon as a whole → two types → compressed passive orientation → active course core.
- **Redundancy removed:** one opener; one passive/active boundary; one TA0043 framing; T1595 mapped once; mutual hunt / cost-gain taught once before Nmap, with OPSEC as defender-view after packets; CT mentioned on artifacts/case study then callback on domain expansion.
- **Course weighting:** Passive treated as good-to-know orientation; active is the primary lecture skill.
- **Opening:** No separate Intro / Overview / section-open teaching slides; dividers are title + image only.
- **Passive vs active language:** observe → reveal/verify → act.
- **Instructor notes:** Image Prompt / Say / Show / Do retained for delivery parity with the established content-guide pattern.
- **Lesson Objectives:** On-slide bullets are the combined contract for this new lesson (not copied verbatim from either source deck).
- **Voice/rules applied:** Execution-focused framing (rules 45/46); doctrine **reconnoiter** paired with ATT&CK **TA0043**; this hour stands alone (rule 59)—no other assigned Module names in voice.
- **Examples vs demos:** Slides 33 and 36 are talk-throughs of Nmap and HTTP-enum sequences, not live instructor demos.
- **Out of scope this pass:** other Modules' content guides.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- This lecture is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Sequencing for other assigned work lives in block.yaml and the delivery schedule, not in this hour's slides.

## Questions and check on learning

- **Ask (Q):** In one sentence, what is reconnaissance supposed to produce?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** Name one adversary asset type a log or public report might hand you before anyone probes.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
