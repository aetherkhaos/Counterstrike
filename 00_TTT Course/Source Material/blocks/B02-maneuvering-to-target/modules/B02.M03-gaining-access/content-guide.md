---
id: B02.M03
title: Gaining Access
artifact_type: content_guide
audience: instructor
block: B02
module_type: lecture
legacy_aliases:
- legacy/week2/content-guides/2.7 Gaining Access Content Guide.md
- B04.M06
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

# Gaining Access — Content Guide

**Source:** This Markdown content guide is the source of truth. Instructor deck: [`slides/B02.M03_gaining-access_Instructor.pptx`](slides/B02.M03_gaining-access_Instructor.pptx). The student copy is generated at pack time.
**Audience:** CPT operators who have recon evidence and open-source exploit identification.
**Duration:** ~90 minutes (lecture block before gaining-access labs)
**Prerequisites:** Passive and active recon; open-source exploit ecosystem; Metasploit familiarity.
**References:**

- [`slides/B02.M03_gaining-access_Instructor.pptx`](slides/B02.M03_gaining-access_Instructor.pptx)
- `../../activities/L2.8_Gaining_Access/`
- `../../activities/L2.6_Using_MSF/`
- `../B02.M05-philadelphia/` through `../B02.M14-dallas/` (city-coded access labs; deploy stack is `environments/pcte_vulnhub_targets/`)
- `../02-info-gathering-recon/content-guide.md`
- `../05-open-source-ecosystem/content-guide.md`

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

- **Say:** "Recon told you what is exposed and what might be weak."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What is the difference between knowing a CVE exists and having a usable session?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "Recon told you what is exposed and what might be weak."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What is the difference between knowing a CVE exists and having a usable session?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Gaining Access for Cyber Protection Teams (2 min)

**Instructor Notes:**

- **Image Prompt:** Title slide only. A CPT ops-station silhouette faces an adversary-infrastructure silhouette; a single arrow labeled "Initial Access" connects them. Four small technique tags (T1190, T1133, T1078, T1534) sit under the arrow. No bullet stack.
- **Say:**
  - "Recon told you what is exposed and what might be weak."
  - "This lesson turns that evidence into a controlled foothold."
  - "Objectives are next; they are the contract for this block."
- **Show:**
  - Hold on the access arrow and technique tags long enough for students to orient, then advance.
- **Do:**
  - Ask: "What is the difference between knowing a CVE exists and having a usable session?"
  - Take one answer; return to it during the access pipeline.
- **Ask (Q):** What is the difference between knowing a CVE exists and having a usable session?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Lesson Objectives (2 min)

- Understand how to gain initial access by exploiting vulnerabilities in public-facing applications (T1190).
- Understand how to gain initial access through compromised external remote services (T1133).
- Understand how to gain initial access using valid but compromised user accounts (T1078).
- Understand how to gain initial access through internal spear-phishing attacks (T1534).

**Instructor Notes:**

- **Image Prompt:** Four objective cards in a row, each with a MITRE ID and a one-line operator outcome (shell from web app; entry via VPN/RDP/SSH; login with stolen/default creds; reverse foothold from a lure).
- **Say:**
  - "Read these objectives as written—they are the contract for this block."
  - "T1190: gain initial access by exploiting public-facing applications."
  - "T1133: gain initial access through compromised external remote services."
  - "T1078: gain initial access using valid but compromised user accounts."
  - "T1534: gain initial access through internal spear-phishing attacks."
  - "This block moves from evidence-driven access selection through four techniques, then combines paths and documents the handoff before labs."
  - "By the end, you should pick a technique from recon evidence, not from habit."
- **Show:**
  - Walk the four cards left to right while pointing at each matching bullet.
- **Do:**
  - Tell students to write the four IDs in their notebook; they will map lab work to them later.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: From Recon to Initial Access (2 min)

- Earlier recon reveals services, versions, and access leads
- Verify applicability before selecting a technique
- Prepare the path, act deliberately, and assess the resulting session

**Instructor Notes:**

- **Image Prompt:** Horizontal evidence-driven process diagram: "Recon evidence" → "Reveal / verify applicability" → "Prepare access path" → "Act and assess session." A smaller outcome box reads "Usable foothold for follow-on effects."
- **Say:**
  - "This block is the transition from characterizing a target to establishing a controllable foothold."
  - "Active recon provided service and version evidence; open-source research showed how to find candidate weaknesses."
  - "Do not treat a banner or a CVE listing as proof that a path will work."
  - "Use the sequence: observe, reveal or verify applicability, prepare, then act and assess the session."
  - "A foothold enables later effects; it is not the end state."
- **Show:**
  - Walk the process left to right and point out the assessment step after execution.
- **Do:**
  - Ask: "Where do access attempts most often fail: applicability, preparation, or execution?"
  - Take two answers.
- **Ask (Q):** Where do access attempts most often fail: applicability, preparation, or execution?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: Operational Role of Initial Access (2 min)

- Foothold on adversary networks
- Enables disrupt / deny / degrade against C2, malware, persistence
- Flip adversary tradecraft against them
- Flexibility: iterate techniques as recon yield changes

**Instructor Notes:**

- **Image Prompt:** Adversary network sketch with a foothold node highlighted; outbound effect arrows labeled disrupt, deny, degrade toward C2, malware staging, and persistence artifacts.
- **Say:**
  - "Initial access is the beachhead."
  - "Without it, effects stay theoretical."
  - "With it, you can disrupt C2, deny malware utility, or strip persistence."
  - "You are flipping the same techniques they use—on their infrastructure."
  - "Stay flexible: if one path dies, another may still work."
- **Show:**
  - Point to the foothold.
  - Point to each effect arrow.
- **Do:**
  - Ask: "If the public web exploit is patched mid-mission, what do you check next?"
- **Ask (Q):** If the public web exploit is patched mid-mission, what do you check next?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 5: Multiple Vectors and Technique Combinations (2 min)

- Combine techniques for redundancy (e.g., T1190 + T1078)
- Select from recon yield and mission requirements
- Iterate rapidly across paths
- Blue space supports precise, low-latency execution

**Instructor Notes:**

- **Image Prompt:** Two parallel access paths into the same adversary host: Path A "T1190 exploit," Path B "T1078 credentials," converging on "Session / shell." A side note: "Pick from evidence, keep a fallback."
- **Say:**
  - "Do not marry one technique."
  - "Typical pattern: exploit for speed, credentials as fallback."
  - "Selection follows what recon actually produced."
  - "If research and verification support a reliable module, lead with T1190."
  - "If you already have working creds from malware analysis, lead with T1078."
  - "Blue-space vantage lets you iterate without building covert launch infrastructure first."
- **Show:**
  - Trace Path A and Path B to the same session.
- **Do:**
  - Pair students: one names a primary path, the other names a fallback from the same recon packet.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 6: Blue Space vs Covert Launch Paths (2 min)

- Blue space: launch along already-allowed traffic paths
- Adversary already expects engagement with defended networks
- Reach assets that covert paths may not
- Avoid isolation, firewalling, and coordination delays of covert infrastructure

**Instructor Notes:**

- **Image Prompt:** Split comparison. Left: "Covert / CMT-style path" with extra hop boxes and delay icons. Right: "Blue-space path" as a direct allowed route from defended network into adversary-facing services.
- **Say:**
  - "Positioning is part of the technique."
  - "From blue space you often ride paths the adversary already trusts or probes."
  - "That can reach assets blocked to a cold covert launch."
  - "You also skip much of the setup tax of building and coordinating covert infrastructure."
  - "This is an execution advantage, not a license to be noisy."
- **Show:**
  - Contrast the multi-hop covert path with the direct blue-space path.
- **Do:**
  - Ask: "What operational delay does a covert path introduce that blue space can avoid?"
- **Ask (Q):** What operational delay does a covert path introduce that blue space can avoid?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 7: Leverage Adversary Behavior from Blue Space (2 min)

- Adversary steals/processes content from defended networks
- Capture credentials and IOCs from malware traffic during hunts
- Seed lures that trigger reverse effects (including T1534)
- Turn their collection into your access opportunity

**Instructor Notes:**

- **Image Prompt:** Cycle diagram: Adversary implant → blue-space content/creds → CPT captures IOCs → CPT seeds lure or uses creds → reverse access into red infrastructure.
- **Say:**
  - "They come to you for data."
  - "Hunt traffic and samples for credentials and IOCs."
  - "Those artifacts fuel T1078 and exploit matching."
  - "You can also plant lures they will steal—setting up T1534."
  - "Their collection habit becomes your access method."
- **Show:**
  - Walk the cycle clockwise.
- **Do:**
  - Ask for one blue-space artifact that could become an access input (cred, URL, upload path, version string).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Blue Space Application — OPSEC and Tempo (2 min)

- Blend operations with expected engagement
- Stronger OPSEC than cold covert first contact
- Real-time adjustments from live recon
- Attributable effects inside the assigned campaign

**Instructor Notes:**

- **Image Prompt:** Ops dashboard metaphor: live recon feed updating an access COA board, with OPSEC checklist items (timing, payload noise, expected traffic blend) checked green.
- **Say:**
  - "Blue space lets you look like traffic they already process."
  - "That improves OPSEC versus a brand-new covert launch signature."
  - "You can retune modules and targets from live recon without waiting on new infrastructure."
  - "Effects remain tied to the assigned campaign and target set."
  - "We will apply this lens to each technique."
- **Show:**
  - Point to OPSEC checklist and live-recon feed.
- **Do:**
  - Tell students: "For every technique today, ask what blue space uniquely enables."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: T1190 — Exploit Public-Facing Application (2 min)

**Instructor Notes:**

- **Image Prompt:** Section title card only: "T1190 — Exploit Public-Facing Application" with icons for a web app, database, and custom HTTP listener. No teaching bullets.
- **Say:**
  - "First technique: public-facing application exploitation."
  - "The next slide applies the definition and operational value."
- **Show:**
  - Hold on the technique title and service icons, then advance.
- **Do:**
  - None required beyond the transition.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 10: T1190 Definition and Operational Value (2 min)

- **Definition:** exploit vulns in internet-exposed services (web apps, databases, listeners)
- **Examples:** RCE on unpatched HTTP C2 listening posts; SQLi → shell on web control panels
- **Value:** high-impact entry to public adversary nodes without prior authentication

**Instructor Notes:**

- **Image Prompt:** Public adversary node with open ports; exploit arrow enters an HTTP listener and exits as a shell session. Callouts: "RCE," "SQLi → shell."
- **Say:**
  - "T1190 means you exploit the application or service itself."
  - "This is a reminder of the vulnerability-research workflow; the focus here is applying it to initial access."
  - "Classic counterstrike targets: HTTP listening posts and web management panels."
  - "RCE gives you code execution."
  - "SQLi can dump data or chain to a shell."
  - "Operational value is speed: no credential hunting required if the vuln is remote and unauthenticated."
- **Show:**
  - Trace exploit → shell on the graphic.
- **Do:**
  - Ask: "Why is an unauthenticated RCE usually preferred over an authenticated one for first entry?"
- **Ask (Q):** Why is an unauthenticated RCE usually preferred over an authenticated one for first entry?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 11: Common Targets — Web Apps and Unpatched Services (2 min)

- **Web apps:** framework RCE (e.g., Log4Shell CVE-2021-44228); SQLi → DB dump → shell pivot
- **Unpatched services:** SMB EternalBlue (CVE-2017-0144); RDP BlueKeep (CVE-2019-0708)
- Use version evidence from recon to research candidate CVEs; verify applicability before execution

**Instructor Notes:**

- **Image Prompt:** Target board with two columns—"Web / app layer" and "Network services"—listing the example CVEs under each, fed by a recon banner strip.
- **Say:**
  - "Common does not mean only."
  - "Web frameworks inherit famous RCEs—Log4Shell is the teaching example."
  - "SQLi remains a path when the app talks to a database carelessly."
  - "Legacy service vulns still appear on neglected adversary hosts: EternalBlue, BlueKeep."
  - "Your recon banner is the index key into those CVEs."
- **Show:**
  - Point from banner strip to each CVE example.
- **Do:**
  - Ask which of these they touched in Metasploit practice or vulnhub-style targets.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Common Targets — Attacker Custom Applications (2 min)

- Custom HTTP listening posts and web control panels
- Often built on standard stacks (Apache, PHP, Java frameworks)
- Inherit framework vulnerabilities
- Recon the stack, not just the malware name

**Instructor Notes:**

- **Image Prompt:** "Custom C2 panel" UI sketch sitting on a labeled stack (Apache/PHP/Java). Cracks in the stack glow to show inherited vulns.
- **Say:**
  - "Adversary tooling is often custom at the top and ordinary underneath."
  - "Listening posts and botnet panels reuse Apache, PHP, Java, nginx."
  - "Exploit the framework they inherited, not a mythical unique binary only."
  - "Version the stack components the same way you version any public app."
- **Show:**
  - Point to the custom UI, then to the underlying stack cracks.
- **Do:**
  - Ask: "If the panel title is unique but the Server header says nginx/1.18, what do you research first?"
- **Ask (Q):** If the panel title is unique but the Server header says nginx/1.18, what do you research first?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 13: T1190 Exploitation Process (2 min)

- **Identify:** use recon (e.g., nginx 1.18) to research candidates via NVD
- **Select/prepare:** ExploitDB / Metasploit; adapt PoC to target version
- **Execute:** run against adversary host (e.g., `msfconsole` module + `RHOSTS`)
- **Obtain:** reverse shell or Meterpreter for post-exploitation effects

**Instructor Notes:**

- **Image Prompt:** Four-step flowchart matching the bullets, with example callouts (`nmap -sV` → `curl -s -D` → NVD → `exploit/multi/http/...` → shell).
- **Say:**
  - "This repeats the vulnerability-research workflow from Lessons 2.3 and 2.5, now applied to access."
  - "Identify: use the banner as a research lead, then verify the target's conditions against authoritative advisory and vendor evidence."
  - "NVD and ExploitDB can accelerate triage; SI can summarize or organize leads, but neither establishes exploitability. Verify against primary sources before execution."
  - "Prepare: choose a module or PoC only after confirming it fits the observed version and conditions."
  - "Execute: set target options carefully—wrong target crashes services."
  - "Obtain: prove interactive control, not just an error page."
  - "Labs reinforce this with Metasploit and public-facing app targets."
- **Show:**
  - Walk the four steps.
  - Linger on "adapt to version."
- **Do:**
  - Have students recite the four verbs: identify, prepare, execute, obtain.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 14: From Search to Execution — Metasploit Considerations (2 min)

- `search` by CVE/product/version, then `use` the module that matches recon
- Read `info`, `show options`, and `show payloads` before setting anything
- Set required target options (`RHOSTS` / `RPORT`); set `LHOST` / `LPORT` when the path is reverse
- Does this exploit handle a reverse shell—and will the **default** payload work here?
- If not: start `exploit/multi/handler` with a matching payload before you fire
- `check` when available, then `exploit`; prove a session, not a crash

**Instructor Notes:**

- **Image Prompt:** Talk-through flowchart, not a live terminal: `search` results → `use` module → options/payload decision diamond ("Does the module handle the callback? Default payload viable?") → either exploit-with-payload or `multi/handler` first → `exploit` → session check. Caption: "Talk through the decision; labs type the commands."
- **Say:**
  - "This is a conceptual walk of Metasploit employment—not a live demo. You have already seen msfconsole; Vulnhub and gaining-access labs are where you type."
  - "Start from evidence: search by CVE, product, or version string from recon. Then use the module that actually fits—do not grab the first hit."
  - "Before you set a single option, read the module. info tells you what it does and what it expects. show options lists required versus optional. show payloads lists what this exploit can actually deliver."
  - "Target options first: RHOSTS and RPORT from the banner. If the path is reverse, LHOST must be an address the target can reach, and LPORT must be allowed outbound from their side."
  - "Then the payload decision, which is the one operators skip. Does this exploit handle a reverse shell itself, or does it only trigger code with no built-in callback?"
  - "If it does handle a reverse payload: will the default work on this OS, architecture, and egress? Defaults are convenience, not a promise. Staged reverse_tcp fails when the second connection cannot return. Wrong arch or a bind payload on a filtered port fails silently."
  - "If the exploit does not handle the shell—or the default is wrong—do not fire yet. Stand up exploit/multi/handler with the same payload, LHOST, and LPORT you intend to use, then exploit. Mismatched handler and payload is a common no-session."
  - "When check exists, run it. Then exploit. A crash, a 500, or a hanging job is not access. You need a session you can interact with."
  - "Labs will make you type this. Here you own the questions you ask before exploit."
- **Show:**
  - Trace search → use → options → the payload/handler diamond → exploit → session.
  - Linger on the diamond: default payload versus a separate multi/handler.
- **Do:**
  - Ask: "Name one reason the default reverse payload would fail even if the exploit itself is right."
  - Accept: wrong LHOST, egress filter, staged second connect blocked, wrong arch, bind instead of reverse.
  - Follow-up: "When would you start multi/handler before clicking exploit?" Drive toward: exploit does not include a working reverse payload, or you replaced the default and must match the listener.
- **Ask (Q):** Name one reason the default reverse payload would fail even if the exploit itself is right.
- **Expected Response (A):** exploit does not include a working reverse payload, or you replaced the default and must match the listener

### Slide 15: T1190 Operational Considerations and OPSEC (2 min)

- Prefer remote, unauthenticated exploits for speed
- Chain payloads for immediate effects (e.g., deny/disrupt on C2)
- Modify exploits/payloads to reduce signature hits
- Time execution to low-monitoring windows when known

**Instructor Notes:**

- **Image Prompt:** Checklist graphic: Unauthenticated?, Payload ready?, Signature risk?, Timing window?—each with pass/fail marks.
- **Say:**
  - "Speed favors remote unauthenticated paths."
  - "Have the post-access action ready before you fire."
  - "Stock payloads are loud; customize when the environment warrants it."
  - "If hunt data shows quiet hours on their monitoring, use them."
  - "Stability matters: a crash without a session can burn the path."
- **Show:**
  - Tick through the checklist aloud.
- **Do:**
  - Ask: "What do you prepare before clicking exploit?"
- **Ask (Q):** What do you prepare before clicking exploit?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 16: T1190 — Blue Space OPSEC Advantages (2 min)

- Execute from defended vantage with expected traffic blend
- Minimize footprint relative to cold covert first contact
- Generate effects (e.g., shell for malware wipe) from that foothold
- Keep actions inside the assigned campaign target set

**Instructor Notes:**

- **Image Prompt:** Blue-space ops station firing a precise T1190 exploit along an allowed path; small footprint meter reading "low relative noise."
- **Say:**
  - "Blue space does not make exploits invisible."
  - "It often makes them less anomalous than a brand-new covert source."
  - "Use that to land the shell, then produce the planned effect."
  - "Example effect path: shell → locate malware staging → wipe or deny it."
  - "Stay inside assigned adversary targets."
- **Show:**
  - Point to vantage, path, and effect sequence.
- **Do:**
  - Transition: "Remote services are next—same discipline, different entry surface."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 17: T1133 — External Remote Services (2 min)

**Instructor Notes:**

- **Image Prompt:** Section title card only: "T1133 — External Remote Services" with VPN gateway, RDP desktop, and SSH server icons. No teaching bullets.
- **Say:**
  - "Second technique: external remote services."
  - "The next slide applies this technique to exposed remote-access surfaces."
- **Show:**
  - Hold on the technique title and icons, then advance.
- **Do:**
  - None required beyond the transition.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 18: T1133 Definition and Operational Value (2 min)

- **Reminder:** access via weaknesses in exposed remote-access protocols (VPN, RDP, SSH)
- **Common targets:** VPN (IPsec/IKE), RDP (:3389), SSH (:22)
- **Role:** compromise remote entry → reach internal adversary networks for broader disruption

**Instructor Notes:**

- **Image Prompt:** Perimeter diagram: Internet → VPN/RDP/SSH edge → internal adversary ops network. Exploit lightning bolt at the edge service.
- **Say:**
  - "T1133 is about the remote-access plane."
  - "VPN gateways, RDP hosts, SSH servers are primary surfaces."
  - "Counterstrike value is depth: edge compromise unlocks interior effects."
  - "Use the recon workflow to reveal the service and version, then verify applicability before selecting a module."
- **Show:**
  - Trace internet → edge → internal.
- **Do:**
  - Ask: "Why might SSH on an internal jump host matter more than a public marketing site?"
- **Ask (Q):** Why might SSH on an internal jump host matter more than a public marketing site?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 19: T1133 Access Method — Vulnerability Exploitation (2 min)

- Exploit CVEs in remote-access software
- Examples: Pulse Secure CVE-2019-11510; BlueKeep; OpenSSH regreSSHion CVE-2024-6387
- Process: version from recon → select module/PoC → execute → shell

**Instructor Notes:**

- **Image Prompt:** Process strip identical in shape to the T1190 process, but icons are VPN/RDP/SSH and example CVE labels differ.
- **Say:**
  - "Primary access method here is vulnerability exploitation."
  - "Same discipline as T1190: version, match, prepare, execute."
  - "Pulse Secure RCE, BlueKeep, and regreSSHion are teaching exemplars."
  - "Metasploit modules exist for several of these; PoCs for others."
  - "Do not skip version confirmation—remote service exploits are crash-prone."
- **Show:**
  - Align this process strip with the earlier T1190 strip to show reuse.
- **Do:**
  - Ask students where they would look up the CVE after seeing `OpenSSH_7.4` in a banner.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 20: T1133 Examples — RDP and SSH (2 min)

- **RDP:** Metasploit BlueKeep CVE-2019-0708 → shell on Windows host
- **SSH:** regreSSHion-style RCE (CVE-2024-6387) via PoC against vulnerable OpenSSH
- Goal: interactive control of the remote entry point

**Instructor Notes:**

- **Image Prompt:** Two example cards side by side—Windows RDP with BlueKeep module path; Linux SSH with regreSSHion PoC path—each ending in a shell icon.
- **Say:**
  - "RDP example: BlueKeep module path when version and conditions match."
  - "SSH example: modern RCE classes like regreSSHion when the OpenSSH build is vulnerable."
  - "Both aim at a usable shell on the remote service host."
  - "That host is often an ops console or jump box—high value for follow-on effects."
- **Show:**
  - Compare the two cards.
- **Do:**
  - Ask: "What recon artifact decides BlueKeep versus a credential spray instead?"
- **Ask (Q):** What recon artifact decides BlueKeep versus a credential spray instead?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 21: T1133 Examples — VPN and Operational Outcome (2 min)

- **VPN:** Metasploit Pulse Secure RCE (CVE-2019-11510) → shell
- **Operational outcome:** persistent reach to adversary ops consoles
- Effects example: data denial / service disruption from the foothold

**Instructor Notes:**

- **Image Prompt:** VPN gateway icon cracking open to reveal an internal ops console; effect tags "deny data," "disrupt service" attached to the console.
- **Say:**
  - "VPN gateways concentrate access."
  - "Pulse Secure CVE-2019-11510 is the classic teaching exploit."
  - "Landing there can mean durable reach into adversary operations."
  - "From that console you stage denial or disruption effects."
  - "Document the path—follow-on teams need the exact entry method."
- **Show:**
  - Trace gateway → console → effect.
- **Do:**
  - Ask what you would record for handoff after a VPN shell lands.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 22: Walk-Through — SSH Vulnerability Exploitation (2 min)

- **Input:** recon shows SSH 7.4; CVE research yields a candidate path (e.g., user-enum → RCE chain)
- **Steps:** prepare PoC → execute against target
- **Output:** shell → pivot toward internal effects
- Tie-in: recon banners; vuln research in NVD/ExploitDB

**Instructor Notes:**

- **Image Prompt:** Walk-through panel: banner `SSH-2.0-OpenSSH_7.4` → CVE/NVD match → PoC execution → shell prompt. Side callouts: "recon banner," "NVD/ExploitDB."
- **Say:**
  - "Purpose: walk T1133 execution without requiring a full live demo."
  - "Input comes from recon—service and version."
  - "Vulnerability search follows NVD, ExploitDB, and module fit."
  - "Use those sources to form and narrow a candidate; verify the advisory and target conditions before treating it as applicable."
  - "Narrate prepare and execute; if no live target, show expected shell output."
  - "Blue-space paths keep this lower risk than a cold covert launch."
  - "Debrief: interpretation matters—version evidence can narrow the path, but it does not establish exploitability alone."
  - "Transition next to operational checks for T1133."
- **Show:**
  - Point to each walk-through panel in order.
  - If simulating, display a short expected shell snippet.
- **Do:**
  - Ask: "What would you refuse to execute if the version match was ambiguous?"
  - Collect one refusal criterion (wrong major version, untested crash risk, etc.).
- **Ask (Q):** What would you refuse to execute if the version match was ambiguous?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 23: T1133 Operational Considerations (2 min)

- Prefer stable exploits; avoid needless service crashes
- Chain payloads for immediate effects (e.g., disrupt remote services)
- Time probes and exploits to low-monitoring windows
- Evade noisy reconnaissance signatures on the path in

**Instructor Notes:**

- **Image Prompt:** Risk dial between "Stable session" and "Service crash," with OPSEC notes for timing and probe noise.
- **Say:**
  - "Remote service exploits can brick the door you need."
  - "Choose stability when the mission needs the service alive under your control."
  - "Still prepare the effect payload so you do not waste the window."
  - "Throttle and time probes—banner grabbing can be as loud as the exploit."
  - "Evasion on the path in protects the technique for reuse."
- **Show:**
  - Move the risk dial toward "Stable session."
- **Do:**
  - Ask when crashing the service might still be acceptable (rare; only if effect requires denial and access is already redundant).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 24: T1078 — Valid Accounts (2 min)

**Instructor Notes:**

- **Image Prompt:** Section title card only: "T1078 — Valid Accounts" with a key/credential icon unlocking SSH and RDP doors quietly. No teaching bullets.
- **Say:**
  - "Third technique: valid accounts."
  - "The next slide covers the evidence sources and operational value."
- **Show:**
  - Hold on the technique title and credential icon, then advance.
- **Do:**
  - None required beyond the transition.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 25: T1078 Definition and Operational Use (2 min)

- **Reminder:** authenticate with stolen, guessed, or default credentials
- **Primary sources:** defender intel—hardcoded malware creds; IOCs in traffic
- **Secondary sources:** breach dumps / OSINT
- **Value:** stealthy entry that mimics legitimate user behavior

**Instructor Notes:**

- **Image Prompt:** Credential funnel: malware sample + traffic IOC (primary) and OSINT/breach (secondary) pouring into an auth success on an adversary service.
- **Say:**
  - "Valid means the system accepts the login."
  - "Primary gold: credentials pulled from malware and live traffic in blue space."
  - "Secondary: breach corpuses and OSINT when they map to the same actor infrastructure."
  - "Operationally, successful auth looks like a normal user—ideal for persistence and quiet effects."
- **Show:**
  - Emphasize primary over secondary sources.
- **Do:**
  - Ask why primary defender intel usually beats generic breach lists for counterstrike.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 26: Credential Sourcing — Primary Defender Intel (2 min)

- Hardcoded credentials in captured malware samples
- Creds and tokens observed in beacon / exfil traffic
- Extract during blue-space hunts
- Strongest lead when tied to live adversary tooling; validate it against the intended service

**Instructor Notes:**

- **Image Prompt:** Hunt desk view: malware binary open in analysis, PCAP highlight showing cleartext or encoded creds, sticky note "use against actor infra only."
- **Say:**
  - "Start with what the adversary already sent you."
  - "Malware samples often embed SSH/RDP/panel passwords."
  - "Beacon and exfil channels leak auth material."
  - "A connection between the tooling and target makes the credential a stronger lead, not proof of access."
  - "Validate the cred against the intended service before claiming access."
- **Show:**
  - Point to sample analysis and PCAP highlight.
- **Do:**
  - Ask for one safe validation step before spraying a harvested password widely.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 27: Credential Sourcing — Secondary Techniques (2 min)

- OSINT and breach data (reused passwords)
- Password spraying: common passwords across many users
- Credential stuffing: known pairs against the target service
- Use secondary methods when primary intel is thin—but expect more noise

**Instructor Notes:**

- **Image Prompt:** Three secondary method tiles—OSINT/breach, spray, stuff—each with a noise meter (spray/stuff higher than targeted primary use).
- **Say:**
  - "Secondary methods fill gaps."
  - "Breach reuse works when actors recycle passwords."
  - "Spraying tries common passwords across a user list."
  - "Stuffing replays known pairs at the service."
  - "These are louder and lockout-prone—throttle and watch responses."
- **Show:**
  - Compare noise meters across tiles.
- **Do:**
  - Ask which secondary method fits a short user list with malware-derived password candidates.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 28: T1078 Examples — SSH and RDP (2 min)

- **SSH:** hardcoded creds from malware analysis → `ssh user@target`
- **RDP:** stuffing/spray tools (e.g., Crowbar) with weak/default passwords from IOCs
- **Outcome:** full session for disruption (e.g., delete configs); low noise if creds are valid

**Instructor Notes:**

- **Image Prompt:** Split examples: Kali SSH session using extracted password; Windows RDP login success via credential tool. Both lead to "session for effects."
- **Say:**
  - "SSH with malware-hardcoded admin creds is a common win."
  - "RDP with weak or default passwords from IOCs is the Windows counterpart."
  - "Tools like Crowbar appear in stuffing/spray workflows—understand lockout risk."
  - "Valid creds mean the session looks legitimate—use that for deliberate effects, not thrashing."
- **Show:**
  - Contrast SSH and RDP success paths.
- **Do:**
  - Ask what effect they would run first on a quiet valid-account session.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 29: Walk-Through — Password Spraying on RDP (2 min)

- **Input:** user list from recon; passwords from malware IOCs / common sets
- **Tool example:** `hydra -L users.txt -P passwords.txt rdp://target`
- **Result:** successful login → establish session for effects
- Control rate; watch for lockouts and alerts

**Instructor Notes:**

- **Image Prompt:** Command-line storyboard showing hydra (or similar) RDP spray, a single success line, then an RDP desktop session. Warning badge: "rate + lockout."
- **Say:**
  - "Walk-through intent: show a controlled spray, not a brute-force flood."
  - "Users come from recon; passwords prefer malware IOC lists first."
  - "Hydra is a teaching example—any disciplined sprayer follows the same logic."
  - "One valid login is enough; stop and document."
  - "Then establish the interactive session and move to effects."
- **Show:**
  - Narrate the command options: `-L` user list, `-P` password list, `rdp://` target.
  - Highlight the success line.
- **Do:**
  - Ask: "What evidence tells you to stop spraying immediately?"
- **Ask (Q):** What evidence tells you to stop spraying immediately?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 30: T1078 OPSEC — Mimicking Legitimate Use (2 min)

- Time logins to adversary work patterns (e.g., business hours)
- Use expected clients / user agents where relevant
- Harder to detect than exploit crashes and shellcode
- Enables quieter persistence

**Instructor Notes:**

- **Image Prompt:** Timeline of adversary "normal login hours" with CPT login markers aligned to those windows; contrast icon of a noisy exploit crash outside the window.
- **Say:**
  - "Valid-account OPSEC is behavioral."
  - "Log in when they log in."
  - "Use tools and clients that look native to that service."
  - "You avoid the crash and payload signatures that betray exploits."
  - "That quietness supports longer-lived access for phased effects."
- **Show:**
  - Align CPT markers to the normal-hours band.
- **Do:**
  - Transition: "Last technique flips their collection—internal spear phishing / lures."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 31: T1534 — Internal Spear Phishing (2 min)

**Instructor Notes:**

- **Image Prompt:** Section title card only: "T1534 — Internal Spear Phishing" showing a decoy file in blue space being stolen into red space and beaconing back. No teaching bullets.
- **Say:**
  - "Fourth technique: internal spear phishing in the hunt/counterstrike sense."
  - "The next slide explains the observed collection behavior that makes a lure relevant."
- **Show:**
  - Hold on the technique title and image, then advance.
- **Do:**
  - None required beyond the transition.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 32: T1534 Definition — Reverse Access via Lures (2 min)

- Place lures (docs with exploits or tracking pixels) in defended blue-space networks
- Anticipate adversary collection / exfiltration
- Trigger reverse access into their red infrastructure
- Opportunistic; based on observed adversary behavior

**Instructor Notes:**

- **Image Prompt:** Shared-drive decoy document with embedded beacon; adversary exfil arrow pulls it to an analysis node; reverse shell returns to blue space.
- **Say:**
  - "This is unique to hunt-team counterstrike posture."
  - "Lures live in blue space—email traps, shares, honey files."
  - "When they steal and process the lure, the payload fires from their side."
  - "You gain a foothold on their analysis or C2-adjacent host."
  - "It is opportunistic: no observed collection pattern, no reliable T1534."
- **Show:**
  - Walk plant → steal → process → reverse shell.
- **Do:**
  - Ask what hunt evidence would justify seeding a lure tomorrow.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 33: T1534 in Operations — Execution and Value (2 min)

- **Execute:** craft high-value lookalikes; place in monitored theft-prone locations
- **Value:** access activates on their collection—no direct first contact required
- **Monitor:** watch blue-space sensors for collection triggers
- High OPSEC until they engage; hand off if lateral expansion is required

**Instructor Notes:**

- **Image Prompt:** Operator checklist: craft lure → place in monitored path → alert on collection → confirm reverse session → handoff package.
- **Say:**
  - "Craft lures that match what they already steal—fake intel docs, configs, keys."
  - "Placement matters: put them on paths your sensors watch."
  - "Value: they initiate contact by stealing."
  - "You monitor for the trigger, then validate the reverse session."
  - "If the mission needs deep lateral movement, package the foothold for follow-on / CMT transition."
- **Show:**
  - Tick the checklist.
- **Do:**
  - Ask what "success" looks like before anyone touches a keyboard on the red host.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 34: T1534 — Preview for Follow-On Handoff (2 min)

- T1534 secures initial foothold via reverse access
- Typical landing: adversary analysis node or C2-adjacent host
- Combine with T1190 / T1133 / T1078 for resilient access
- Hand off for lateral movement or expansion when required

**Instructor Notes:**

- **Image Prompt:** Handoff envelope from CPT hunt team to follow-on operators: contains session details, lure IOCs, landing host role, and recommended next techniques.
- **Say:**
  - "Treat T1534 as a door opener."
  - "You may land on an analysis box rather than the final objective host."
  - "Keep other vectors warm so one patch does not end the mission."
  - "When scope requires lateral movement beyond the foothold, hand off cleanly."
  - "Handoff quality is part of the technique's success."
- **Show:**
  - Point to each field in the handoff envelope.
- **Do:**
  - Ask students to name three fields they would include in that envelope.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 35: Integration and Selection (2 min)

**Instructor Notes:**

- **Image Prompt:** Section title card only: "Integration and Selection" with four technique icons linked into one access plan document. No teaching bullets.
- **Say:**
  - "Last block: put the techniques to work together."
  - "The next slides provide decision aids for selection, resilience, and handoff."
- **Show:**
  - Hold on the technique icons and plan document, then advance.
- **Do:**
  - None required beyond the transition.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 36: Integrating Vectors for Robust Access (2 min)

- Typical pattern: T1190 for quick shell; T1078 fallback if exploit fails
- Layer T1133 for remote pivots into deeper networks
- Multiple paths keep effects alive when one vector is patched
- Example outcome: disrupt C2 even if the web path dies

**Instructor Notes:**

- **Image Prompt:** Resilience diagram: primary T1190, fallback T1078, depth path T1133, optional T1534 lure— all capable of feeding "Effect: disrupt C2."
- **Say:**
  - "Plan primary and fallback before you execute."
  - "Exploits are fast; credentials are quiet insurance."
  - "Remote-service paths add depth when the edge web tier is hardened."
  - "Lures add an asynchronous path when they keep stealing."
  - "Resilience means the effect still happens after a patch."
- **Show:**
  - Trace each path to the shared effect.
- **Do:**
  - Scenario: "Web CVE patched overnight—what is your morning path?"
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 37: Selecting Techniques — Environment and Intelligence (2 min)

- **Exposed web / apps?** → prioritize T1190
- **Remote services with known vulns?** → prioritize T1133
- **Working credentials?** → prioritize T1078
- **Observed exfil / collection patterns?** → prioritize T1534 lures
- Let recon and hunt intel choose—do not default to one technique

**Instructor Notes:**

- **Image Prompt:** Decision matrix: rows are evidence types (web banner, SSH/RDP/VPN version, creds, exfil pattern); columns are techniques with checkmarks where evidence supports them.
- **Say:**
  - "Selection is evidence-driven."
  - "Public app surface points to T1190."
  - "Vulnerable remote services point to T1133."
  - "Creds in hand point to T1078."
  - "Active theft from blue space points to T1534."
  - "If two are green, pick primary by mission tempo and keep the other as backup."
- **Show:**
  - Fill checkmarks on the matrix with the class.
- **Do:**
  - Give a one-minute recon vignette; students vote primary technique.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 38: Selecting Techniques — Speed, Stealth, and Mission Fit (2 min)

- **Speed:** exploits for fast shells
- **Stealth:** valid accounts to blend; lures for passive triggers
- **Mission fit:** match technique to required depth and effect timing
- Operate against assigned adversary infrastructure only

**Instructor Notes:**

- **Image Prompt:** Three dials—Speed, Stealth, Depth—set differently for T1190 (speed high), T1078 (stealth high), T1534 (passive/stealth), T1133 (depth high).
- **Say:**
  - "Requirements finish the selection."
  - "Need a shell in minutes? Lead with a matched exploit."
  - "Need to blend for days? Lead with valid accounts."
  - "Need them to pull access to you? Seed the lure."
  - "Need interior reach? Weight remote-service paths."
  - "Stay on assigned adversary targets—scope is an execution constraint, not a debate topic."
- **Show:**
  - Adjust the dials per technique.
- **Do:**
  - Ask pairs to justify a primary technique using speed vs stealth for a "disrupt C2 before next beacon" mission.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 39: Documenting Access for Operational Handover (2 min)

- Record technique (e.g., "T1190 via CVE-2021-44228 Metasploit")
- Record success metrics and IOCs generated
- Share sessions/shells with follow-on teams
- Log from the secure vantage; preserve chain of custody

**Instructor Notes:**

- **Image Prompt:** Handover form mockup with fields: Technique/CVE/Module, Target, Session ID, IOCs, Proof commands, Next recommended actions.
- **Say:**
  - "If it is not documented, the team cannot reuse it."
  - "Name the technique and the exact module or PoC."
  - "Capture proof: host, user, time, how you verified the session."
  - "List IOCs you created so defenders and partners are not surprised."
  - "Hand the live session cleanly—credentials, listener details, stability notes."
  - "Logging from blue space supports custody and after-action review."
- **Show:**
  - Walk each form field.
- **Do:**
  - Students draft a five-line handoff for a fictional successful T1190.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 40: Blue Space Advantages in Selection and Execution (2 min)

- Positioning improves technique selection accuracy
- Live recon supports rapid retask between vectors
- Superior OPSEC vs cold covert infrastructure launches
- Precise countereffects and cleaner foothold handoff

**Instructor Notes:**

- **Image Prompt:** Blue-space advantage summary wheel: Selection accuracy, Live retask, OPSEC, Handoff quality—each spoke tied to "Initial access success."
- **Say:**
  - "Return to positioning."
  - "Blue space makes selection smarter because the intel is live and local."
  - "You can swap from exploit to creds without rebuilding launch infrastructure."
  - "OPSEC benefits compound across T1190 through T1534."
  - "The product you hand off is a precise foothold for effects—not a fragile one-off."
- **Show:**
  - Spin through the four spokes.
- **Do:**
  - Ask one student to restate the blue-space advantage in one sentence.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 41: Lesson Summary (2 min)

- **T1190:** public apps → RCE shells (web / service vulns)
- **T1133:** remote services via vulns (SSH / RDP / VPN CVEs)
- **T1078:** valid accounts for stealthy auth (spray / harvested creds)
- **T1534:** blue-space lures → reverse access on collection/exfil
- **Integration:** select from recon/intel; use blue-space tempo and OPSEC; keep fallbacks

**Instructor Notes:**

- **Image Prompt:** Four-quadrant summary plus a center hub labeled "Select → Execute → Document → Hand off."
- **Say:**
  - "You now have four initial-access tools and a selection logic."
  - "Exploits for exposed apps and remote services."
  - "Credentials when you already own the password."
  - "Lures when they keep stealing from you."
  - "Integrate them; document them; hand them forward."
- **Show:**
  - Tap each quadrant, then the hub.
- **Do:**
  - Rapid-fire: instructor names an evidence type; class names the technique.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 42: Next — Gaining Access Labs (2 min)

- Practice initial-access techniques in a simulated adversary scenario
- Apply selection logic to live targets
- Related practice: HTB Metasploit and gaining-access prep in `course/prerequisites/using-msf/` and `course/prerequisites/gaining-access/`, plus city-coded access labs

**Instructor Notes:**

- **Image Prompt:** Three practice-station tiles after the lecture hub: Metasploit module workflow, gaining-access scenarios across services, multi-surface target validation. Skill labels only — no lab names, no Module IDs, no course schedule or road-sign sequencing.
- **Say:**
  - "Next you practice."
  - "Expect to match banners, choose modules, and prove sessions."
  - "Metasploit labs reinforce exploit execution."
  - "Gaining-access practicals stretch across app and service surfaces."
  - "Treat each box as an adversary node—select the technique from evidence."
- **Show:**
  - Point to the lab boxes students will see on the schedule.
- **Do:**
  - Preview the first lab brief location; break if scheduled.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 43: Questions? (2 min)

- Clarify technique selection
- Clarify process steps
- Clarify handoff expectations

**Instructor Notes:**

- **Image Prompt:** Simple Q&A slide with footer memory anchors exactly: T1190 Exploit Public-Facing Application, T1133 External Remote Services, T1078 Valid Accounts, T1534 Internal Spearphishing. Do not use T1059, T1547, T1041, or other non-initial-access techniques.
- **Say:**
  - "Questions on T1190, T1133, T1078, T1534, or selection/handoff."
  - "If it is lab logistics, bring it to the lab brief."
- **Show:**
  - Leave the four IDs visible while taking questions.
- **Do:**
  - Take questions; if none, cold-call one selection vignette before release.
- **Ask (Q):** Which access technique would you select for the vignette, and what evidence makes it suitable?
- **Expected Response (A):** Facilitation. Tie the choice to T1190, T1133, T1078, or T1534 and the evidence already on the board.

---

## Improvement notes

- **Before → after slide count:** 46 → 43.
- **Removed / merged:** Lesson Overview and Introduction to Gaining Access were removed; From Recon to Initial Access and The Access Pipeline were merged into Slide 3. Overview pacing now lives in the Lesson Objectives notes.
- **Converted section transitions:** T1190, T1133, T1078, T1534, and Integration and Selection are title-and-image-only transition slides. Their teaching context now appears in the following operational slides.
- **Evidence-driven access:** Slide 3 teaches observe → reveal/verify → prepare → act/assess. Recon and vulnerability-research workflows are acknowledged where they are reused.
- **Research aids:** Slide 13 is the first NVD/ExploitDB mention and adds the SI guidance: SI may accelerate triage or summaries, but it does not establish exploitability; verify against primary sources. Slide 22 reinforces verification when that research workflow is revisited.
- **Slide 14 (this pass):** Converted from a live web-app exploit demo to a conceptual Metasploit talk-through: `search` → `use` → options → default-payload vs `multi/handler` → `exploit` / session proof. Keyboard practice remains Metasploit and gaining-access / Vulnhub labs.
- **Delivery parity:** Say / Show / Do and Image Prompts were retained and refreshed for all changed slides. No section opener contains teaching bullets, and deep questions route to the next lab or block without a deferral label.
- **Voice / focus:** Redundant audience/scenario tags were trimmed from bullets; the deck retains execution-focused mission framing and doctrinal effect verbs.
- **Lesson Objectives:** Slide 2 on-slide bullets restored verbatim from the faithful extract (commit `92b111f`); wording was not paraphrased.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B02.M03-gaining-access is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later gaining-access labs continue from the selection logic this session collects.

## Questions and check on learning

- **Ask (Q):** What is the difference between knowing a CVE exists and having a usable session?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** Where do access attempts most often fail: applicability, preparation, or execution?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
