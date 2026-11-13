---
id: B01.M25
title: ENGAGE Technique Drills
artifact_type: content_guide
audience: instructor
block: B01
module_type: group_activity
related_to: B01.M17
source_status: canonical
review_required: false
template_profile: content_guide_v1
sensitivity: course_internal
legacy_aliases:
- B01.M19
---

# ENGAGE Technique Drills

This Module was previously an embedded exercise in [B01.M23 MITRE D3FEND and ENGAGE](../B01.M23-d3fend-engage/content-guide.md). Complete it in sequence immediately after that lecture.

### Slide 3: ENGAGE — The Third Framework

- **MITRE ATT&CK** describes adversary TTPs
- **MITRE D3FEND** describes remedial / defensive techniques against those TTPs
- **MITRE ENGAGE** describes **actively interacting** with the adversary in blue-space
- Together, **D3 codes** (D3FEND) and **EAC codes** (ENGAGE) are the **bare minimum** set of options to consider for the commander
- We never recommend an option **blindly** — it must be realistic for the environment and articulable against the assigned mission

**Instructor Notes:**

- **Image Prompt:** A three-framework triangle. Apex labeled "ATT&CK (Adversary)". Bottom-left labeled "D3FEND (Harden / Detect / Evict)". Bottom-right labeled "ENGAGE (Expose / Affect / Elicit)". Arrows from ATT&CK pointing to both D3FEND and ENGAGE. The triangle is filled with the label "Commander's Option Space."
- **Say:** "You already have ATT&CK and D3FEND in your head. ENGAGE is the third leg. ATT&CK describes what the adversary does. D3FEND is what we do to prevent, detect, or evict them. ENGAGE is what we do to **shape** them — deceive, elicit, direct. Together, the D3 codes and the EAC codes are the bare-minimum menu you bring to the commander. Bare minimum — because the goal is not to recite techniques. The goal is to pick the ones that actually work in this environment against this adversary toward this mission."
- **Show:** The triangle graphic; https://engage.mitre.org/matrix/ on the projector.
- **Do:** Quick poll: "Who has run a honeypot in anger?" "Who has fed fake credentials?" Calibrate depth based on responses. Tell them: "That intuition you already have — ENGAGE is the doctrine that organizes it."
### Slide 4: The Three ENGAGE Goals

- **Expose** — discover previously undetected adversaries (gaining access or already operating)
- **Affect** — change the adversary's cost-value calculation (raise cost, lower value of their collection)
- **Elicit** — draw out more advanced TTPs and intent by encouraging engagement in defender-controlled environments
- Every EAC technique you pick must trace back to one of these three goals

**Instructor Notes:**

- **Image Prompt:** Three labeled tiles in a horizontal row — "Expose", "Affect", "Elicit" — each with a one-line definition underneath and a small icon (eye, balance scale, fishhook).
- **Say:** "ENGAGE organizes around three goals. Expose finds adversaries we did not see. Affect bends their cost-value math. Elicit pulls out TTPs and intent we could not have gotten any other way. Every time you pick an EAC technique, you owe an answer to this question: which goal does this advance?"
- **Show:** Each tile; link each goal back to how it would plug into a commander's brief.
- **Do:** Ask each team: "From your Block 2 EMLCOA against FSB Center 18 — would Expose, Affect, or Elicit matter **most** for that mission?" Accept three or four answers with one-line justification.
### Slide 5: Expose — Two Approaches

- **Collection** — gather logs, traffic, artifacts that expose adversary activity at the intersection of denial, deception, and adversary-engagement tech
- **Detection** — produce **high-fidelity** alerts (tripwires, lures, custom decoders, alerts from malware detonation)
- Example: leaked fake credentials in and outside the network — any use is an immediate, high-fidelity signal
- Operational safety first — you must be able to **observe** the adversary while engaged

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Expose splits into Collection and Detection. Collection is the log-and-traffic side of the house — evidence gathered specifically because we are engaging the adversary, not generic SOC telemetry. Detection is the high-fidelity-alert side — tripwires, lures, custom rules. The classic example: leak fake credentials. Any use of those is a high-confidence hit. And if each credential is unique, you can even trace where and when it was collected."
- **Show:** The two approaches; the fake-credential example.
- **Do:** Ask: "What is a canary artifact you could drop in your home network tomorrow?" Capture two or three answers on the whiteboard.
### Slide 6: Affect — Three Approaches

- **Prevention** — stop or block adversary action (remove resources, tighten controls)
- **Direction** — move the adversary *toward* or *away from* a path (add/remove lures, selectively weaken controls, physically migrate an attack vector)
- **Disruption** — stop or discourage part of the adversary's mission (network throttling, manipulated command output, planted misinformation)
- The underlying lever is the adversary's **cost-value** proposition

**Instructor Notes:**

- **Image Prompt:** A three-panel graphic labeled "Prevention", "Direction", "Disruption". Prevention panel shows a door being locked; Direction shows two arrows, one path reinforced, one path erased; Disruption shows a network pipe being throttled.
- **Say:** "Affect is the category that moves the adversary's cost-value math. Prevention stops them. Direction steers them — the subtlety here is that you can tighten *some* controls while loosening others, which nudges them toward the terrain you want them in. Disruption degrades the value of what they are getting — throttled exfil, lied-to discovery output, planted misinformation that their analysts have to sort out."
- **Show:** The three approaches; call out that Direction is the most *active* of the three.
- **Do:** Example drill: "Adversary is exfiltrating 10 GB of data over a primary C2 channel. Give me one Prevention, one Direction, and one Disruption option for the commander." Accept answers; refine as needed.
### Slide 7: Elicit — Two Approaches

- **Reassurance** — authenticity-adding activities (realistic accounts, files, system activity) to reduce adversary suspicion
- **Motivating** — target-rich environment design (unpatched OS, weak passwords, enticing data) to pull the adversary in
- Environments can be *dangles* (honeypots) or *self-infected* — in either case the goal is to **observe** what they do
- The payoff is actionable CTI and insight into adversary goals

**Instructor Notes:**

- **Image Prompt:** A two-panel split. Left panel labeled "Reassurance" shows a deception environment with realistic desktop clutter, browser history, user accounts. Right panel labeled "Motivating" shows the same environment with an added unpatched server, a weak-password file, and an enticing "FINANCIALS.xlsx" on the desktop.
- **Say:** "Elicit is the deepest form of engagement. Reassurance makes the environment *feel real* — accounts with histories, files with sensible timestamps, system activity that matches a working user. Motivating makes the environment *worth attacking* — unpatched services, weak passwords, juicy-looking data. The goal is the same: get them to reveal more about themselves than they would have otherwise."
- **Show:** The two-panel comparison.
- **Do:** Tie back: "This is where our ENGAGE options start to look a lot like what you might build into a target environment in Week 3. Keep that in mind."
### Slide 8: ENGAGE Techniques — The EAC Codes

- The ENGAGE matrix publishes **EAC** codes — the equivalent of D3 codes in D3FEND
- Source doc covers the ten we will practice with in this block:
  - **EAC0005** Lures
  - **EAC0023** Introduced Vulnerabilities
  - **EAC0017** Hardware Manipulation
  - **EAC0021** Attack Vector Migration
  - **EAC0020** Isolation
  - **EAC0016** Network Manipulation
  - **EAC0018** Security Controls
  - **EAC0010** Peripheral Management
  - **EAC0014** Software Manipulation
  - **EAC0015** Information Manipulation
  - **EAC0011** Pocket Litter
- We will group these by **primary goal** (Expose / Affect / Elicit) and discuss how each plugs into a commander's option package

**Instructor Notes:**

- **Image Prompt:** A matrix-style tile layout with the eleven EAC codes listed above, each colored by primary goal: green (Expose-leaning), orange (Affect-leaning), blue (Elicit-leaning). Several tiles span multiple colors where the technique supports more than one goal.
- **Say:** "These are the techniques we will actually work with. The codes are opaque at first — EAC0005, EAC0023 — just like ATT&CK T-numbers were the first time you saw them. They become second nature. We are going to group them by primary goal and walk each one."
- **Show:** https://engage.mitre.org/matrix/ — scroll the matrix. Drop into one EAC page, e.g. Lures, and show the detail view.
- **Do:** Tell students to bookmark the matrix. You will reference it often over the next two blocks.
### Slide 9: Deception-Heavy Techniques (Elicit / Expose)

- **EAC0005 Lures** — decoys, breadcrumbs, bait to elicit a specific adversary response (fake creds, fake accounts, fake files, fake processes)
- **EAC0011 Pocket Litter** — supporting data that makes the environment feel lived-in (docs, pictures, registry entries, browsing history) — *does not* push the adversary toward a specific action
- **EAC0015 Information Manipulation** — conceal and reveal facts and fictions to support the deception story
- **EAC0023 Introduced Vulnerabilities** — intentionally vulnerable resources placed to pull the adversary's attention

**Instructor Notes:**

- **Image Prompt:** A desktop screenshot-style graphic with callouts: a fake cred file labeled "Lures", browsing history labeled "Pocket Litter", a file labeled "ADMIN_PASSWORDS.txt" with a lock icon labeled "Information Manipulation — revealed fiction", and an unpatched service banner labeled "Introduced Vulnerability".
- **Say:** "These four are your deception palette. Lures *elicit a specific action*. Pocket Litter *supports the narrative* — it does not aim to make them do one specific thing. Information Manipulation is the art of concealing and revealing; a revealed fiction that the adversary believes cements the environment, and one they disbelieve erodes it. Introduced Vulnerabilities are the intentional magnets."
- **Show:** The four techniques in a labeled mock desktop.
- **Do:** Quick team drill: "Take your Block 2 EMLCOA. Which of these four would have the highest payoff against FSB Center 18?" Capture one answer per team.
### Slide 10: Environment-Shaping Techniques (Affect)

- **EAC0020 Isolation** — contain activity and data so an engagement does not spill over; detonation rooms, decoy subnets
- **EAC0021 Attack Vector Migration** — intercept a malicious element and move it to a safe environment (phishing attachment into a decoy inbox)
- **EAC0016 Network Manipulation** — throttle, segment, kill-switch, unique addressing, selective allow/deny at the network layer
- **EAC0014 Software Manipulation** — alter OS/file system/software output to degrade, mislead, or fail adversary workflows
- **EAC0018 Security Controls** — tighten or *loosen* security settings (Group Policy, firewalls, autorun) — remember: some controls are so routine their *absence* is suspicious

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "These five are how you reshape the terrain the adversary is operating in. Isolation keeps them boxed in. Attack Vector Migration physically moves their payload into your sandbox. Network Manipulation and Software Manipulation change what they see when they look. Security Controls is where you tighten what should be tight and — selectively — loosen what you want them to walk into. Two-way nuance on Security Controls: completely turning off Windows Defender tips them off; turning it off for a single share may not."
- **Show:** Each technique; linger on the Security Controls nuance.
- **Do:** Ask the room: "If you leave Windows Defender off on an entire host, what does a serious adversary think?" Drive toward "this is a trap" as the likely adversary read.
### Slide 11: Hardware and Peripheral Techniques (Affect)

- **EAC0017 Hardware Manipulation** — physically or logically disable hardware (mic, camera, Wi-Fi adapter) to preserve operational safety
- **EAC0010 Peripheral Management** — allow/deny/introduce peripherals (external Wi-Fi, USB, camera) to shape adversary behavior or surface IOCs
- These two matter most in **on-prem** engagements — data centers, field kits, devices that ship with you

**Instructor Notes:**

- **Image Prompt:** A split-panel graphic. Left panel shows a laptop with a taped-over camera and disabled mic ("Hardware Manipulation"). Right panel shows a USB key being inserted into a host in a decoy environment ("Peripheral Management").
- **Say:** "Hardware and peripheral techniques get skipped often in pure cloud environments but matter a lot when you are on-prem or when you are running a controlled engagement in a physical space. Hardware Manipulation preserves operational safety — no hot mic, no camera capturing the background. Peripheral Management is how you introduce or deny USBs, Wi-Fi adapters, and other devices as engagement surface."
- **Show:** The split-panel graphic.
- **Do:** Prompt: "Your team is running a controlled malware-detonation in a shared SCIF. Which of these two is non-negotiable?" Expected answer: Hardware Manipulation.
