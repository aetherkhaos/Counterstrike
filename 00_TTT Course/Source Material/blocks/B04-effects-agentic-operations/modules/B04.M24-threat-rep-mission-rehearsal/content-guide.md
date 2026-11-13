---
id: B04.M24
title: Threat-Representative Environments and Mission Rehearsal (Temp)
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases: []
source_kind: markdown
render_mode: generate
source_status: authored
review_required: true
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
---

# Threat-Representative Environments and Mission Rehearsal (Temp) — Content Guide

**Audience:** CPT operators entering this Block who completed planning and on-target work.
**Duration:** Instructor-flexible opening lecture before the assigned rehearsal lab.
**Prerequisites:** Tactical planning (METT-TC, EMLCOA, CG/CV, SOM); ATT&CK ↔ D3FEND/ENGAGE bridge.
**References:**

- [`../../../../environments/effects_lab_env/vsphere/README.md`](../../../../environments/effects_lab_env/vsphere/README.md)
- Sibling rehearsal lab student brief (same A/B/C option layouts): [`../B04.M25-threat-rep-mission-rehearsal-lab/student-brief.md`](../B04.M25-threat-rep-mission-rehearsal-lab/student-brief.md)

---

## Instructor resources and pre-class

- Classroom projector and screen; whiteboard for the opening contract
- Assigned rehearsal lab student brief with the three redirector option cards
- Live tabs already named in this file's header
- Do not project answer-key setup commands, exploit PoCs, or default passwords

## Student resources

- Assigned rehearsal lab student brief (same option layouts as the range slides)
- Shared vSphere folder and `/29` assignment slip
- No extra kit beyond what the student-facing file already lists

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "This block is mission prep. You will not recreate an entire adversary enterprise. You will identify the operational-environment pieces that can break your scheme of maneuver, build just enough of them to rehearse with the people and equipment you actually have, and write down what the rehearsal changes in the plan. Hard budgets are real — and they are not one number forever. What we impose in the classroom is a training constraint. Operationally your ceiling will differ by unit, range, and mission. Sometimes command will call for a more thorough mission rehearsal; that usually arrives with additional time and resources. Today we practice the local-resource version of the process so you can scale it when the mission demands more."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "This block is mission prep. You will not recreate an entire adversary enterprise. You will identify the operational-environment pieces that can break your scheme of maneuver, build just enough of them to rehearse with the people and equipment you actually have, and write down what the rehearsal changes in the plan. Hard budgets are real — and they are not one number forever. What we impose in the classroom is a training constraint. Operationally your ceiling will differ by unit, range, and mission. Sometimes command will call for a more thorough mission rehearsal; that usually arrives with additional time and resources. Today we practice the local-resource version of the process so you can scale it when the mission demands more."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 1: Objectives (13 min)

- Select **critical OE elements** that will stress your plan
- Build **threat-representative** terrain — not a full mirror
- Rehearse **SOM / TTPs** with **local resources** (people, equipment)
- Hard budgets **vary** — classroom limits ≠ operational limits
- Fuller rehearsal is sometimes required — expect more **time and resources** when directed

**Instructor Notes:**

- **Image Prompt:** Five compact tiles labeled Select OE, Build Lean, Local Resources, Variable Budgets, Scale Rehearsal, under a banner "Mission Prep Before Effects."
- **Say:** "This block is mission prep. You will not recreate an entire adversary enterprise. You will identify the operational-environment pieces that can break your scheme of maneuver, build just enough of them to rehearse with the people and equipment you actually have, and write down what the rehearsal changes in the plan. Hard budgets are real — and they are not one number forever. What we impose in the classroom is a training constraint. Operationally your ceiling will differ by unit, range, and mission. Sometimes command will call for a more thorough mission rehearsal; that usually arrives with additional time and resources. Today we practice the local-resource version of the process so you can scale it when the mission demands more."
- **Show:** Walk the five objective tiles; contrast 'local resources / today's classroom cap' with 'scaled rehearsal when resourced'; point ahead to the assigned rehearsal lab — same decision process, exploitation-range terrain.
- **Do:** Ask one student: "Name one OE element that has broken a plan you have seen — identity, path, sensor, or service?" Collect two answers to seed later slides.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 2: Threat-Representative vs Full Recreation (13 min)

- **Threat-representative** = OE pieces that change your decisions
- Full recreation burns time, RAM, and focus
- Ask: what will **impact operations** if wrong or missing?
- Success = justified selection + rehearsal evidence

**Instructor Notes:**

- **Image Prompt:** Split graphic. Left: sprawling full enterprise map grayed out and crossed. Right: three highlighted nodes — Identity, Key Service, Endpoint Path — labeled "Critical OE."
- **Say:** "Mirror-perfect ranges feel productive and often teach the wrong lesson. Threat-representative means you can rehearse the plan against the friction that matters: identity that gates movement, the service sitting on your center of gravity logic, the path your TTP actually traverses. If a host does not change a decision, do not build it."
- **Show:** Contrast sprawl vs three critical nodes.
- **Do:** Have the room shout one 'do not build' example (print server nobody will touch, decorative DMZ, third domain controller).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: Planning Products Drive What You Build (13 min)

- **METT-TC / EMLCOA** → enemy terrain and actions-on-contact
- **CG / CV** → which services and paths must exist to rehearse
- **SOM** → sequencing, terrain layers, and friction points
- Pair doctrine with **ATT&CK** techniques you will dry-run

**Instructor Notes:**

- **Image Prompt:** Horizontal flow: METT-TC → EMLCOA → CG/CV → SOM → "OE Build List," with a parallel ATT&CK tag strip under the SOM box.
- **Say:** "You already have the planning pipeline. Do not invent a new process. METT-TC and EMLCOA tell you what the enemy and terrain look like. CG and CV tell you which element must be present to rehearse exploitation logic. SOM tells you order and friction. When you name a TTP you will rehearse, tag the matching ATT&CK technique so partner language stays bilingual."
- **Show:** Trace one example: CV 'exposed management service' → build that service host → rehearse the access TTP tagged to ATT&CK.
- **Do:** Ask: "If your CV is credential reuse on an admin workstation, what OE piece must exist before rehearsal is honest?"
- **Ask (Q):** If your CV is credential reuse on an admin workstation, what OE piece must exist before rehearsal is honest?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: Fidelity vs Available Resources (13 min)

- **Classroom today:** ~50 GB concurrent RAM per student (training constraint)
- Operational ceilings **differ** by unit, range, and mission
- Default: rehearse with **local people and equipment** you have
- Fuller rehearsal, when directed, usually brings **more time and resources**
- Scope-down is an operator skill — power off unused VMs; no vanity clones

**Instructor Notes:**

- **Image Prompt:** Two gauges side by side. Left labeled "Classroom Cap" fixed near 50 GB with a green 12–24 GB disciplined band. Right labeled "Operational" with a variable slider and a callout "Scaled rehearsal = more time/resources when directed."
- **Say:** "Fifty gigabytes is the hard ceiling for this classroom cluster — a training constraint, not the universal operational number. At home your RAM, people, and range time will differ. The process is the same either way: rehearse with the local resources you have unless command resources a more thorough mission rehearsal. When that fuller rehearsal is called for, expect more time and more equipment — then raise fidelity deliberately. Until then, scope-down is professionalism: size hosts honestly, power off what you are not using, and do not burn shared capacity on vanity clones. Sprawl here also taxes later tool-evaluation work on the same cluster."
- **Show:** Contrast the fixed classroom gauge with the variable operational gauge; point at the 'scaled rehearsal' callout.
- **Do:** Ask who has killed a shared lab by leaving clones powered on. Normalize the confession, then ask: "What would change in your build if command gave you another day and a second hypervisor?"
- **Ask (Q):** What would change in your build if command gave you another day and a second hypervisor?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 5: Scenario — Simulated Exploitation Range (13 min)

- Build **Kali ops** + **vulnerable *nix redirector** + **Windows target**
- Exploit the redirector → reach Windows via **RDP or SSH**
- Place a **C2 beacon** that calls back **through** the redirector to Kali
- Choose **one** of three reconstructable redirector stacks (A / B / C)
- Rehearsal goal: prove the **path**, not rebuild an entire beacon farm

**Instructor Notes:**

- **Image Prompt:** Path diagram: Kali Ops → exploit arrow → Redirector (A/B/C badge) → RDP/SSH → Windows Target; reverse arrow Windows → Redirector → Kali labeled "C2 callback."
- **Say:** "Concrete scenario. You build a lean threat-representative exploitation cell. Kali is your attack platform and C2 listener. The middle box is a dual-homed *nix redirector you make honestly exploitable — web RCE or app-server RCE, depending on which option you pick. From that foothold you reach a Windows host on the private side over RDP or SSH, place an implant, and force the callback to traverse the redirector back to Kali. The next three slides are the reconstruct inventories for those options. Same cards appear in the lab brief. Setup and exploit walkthroughs stay instructor-side."
- **Show:** Trace Kali → redirector → Windows and the callback return path.
- **Do:** Ask: "If the beacon reaches Kali without ever touching the redirector, what did you actually rehearse?"
- **Ask (Q):** If the beacon reaches Kali without ever touching the redirector, what did you actually rehearse?
- **Expected Response (A):** A different TTP — direct Windows-to-ops callback, not redirector pass-back.

### Slide 6: Option A — Soft-edge PHP (Ubuntu) (13 min)

- **Base:** Ubuntu LTS; **dual NIC** (ops-facing + private to Windows)
- **Stack:** nginx or Apache + PHP-FPM
- **Surface:** edge site vhost with a PHP health/admin endpoint that shells out from a request parameter
- **Windows:** reachable from the private NIC via RDP (OpenSSH optional)
- **After RCE:** userland forwarder (socat / nginx stream / iptables DNAT) for C2 pass-back to Kali
- Reconstruct inventory only — no setup or exploit steps on this slide

**Instructor Notes:**

- **Image Prompt:** Ubuntu badge on a dual-NIC host; Apache/nginx + PHP-FPM icons; PHP endpoint box with "param → shell" cue; private arrow to Windows; forwarder badge toward Kali.
- **Say:** "Option A is the soft-edge PHP redirector. Students rebuild Ubuntu, dual-home it, stand up a web stack, and place one intentionally unsafe PHP health or admin page that executes OS commands from request input. That is the ops-facing exploit path. Private side must reach Windows over RDP or SSH. After foothold, they configure a forwarder so the Windows beacon returns through this host to Kali. Do not put the PHP source or exploit commands on the board — that lives in the answer key."
- **Show:** Walk each reconstruct bullet once; emphasize dual-NIC and pass-back as load-bearing.
- **Do:** Ask: "What false confidence would adding ops-facing SSH 'for ease' create on Option A?"
- **Ask (Q):** What false confidence would adding ops-facing SSH 'for ease' create on Option A?
- **Expected Response (A):** You rehearse interactive shell access instead of the PHP execution path that is supposed to represent the edge.

### Slide 7: Option B — Legacy CGI (Debian) (13 min)

- **Base:** Debian; **dual NIC** (ops-facing + private to Windows)
- **Stack:** Apache with `cgi` / `cgid` enabled
- **Surface:** CGI status/diagnostics script that unsafely interpolates query or environment input into a shell
- **Windows:** reachable from the private NIC via RDP or SSH
- **After RCE:** same userland forwarder expectation for C2 pass-back to Kali
- Reconstruct inventory only — no setup or exploit steps on this slide

**Instructor Notes:**

- **Image Prompt:** Debian badge on dual-NIC host; Apache CGI icon; status.cgi box with "query → shell" cue; private arrow to Windows; forwarder badge toward Kali.
- **Say:** "Option B is the legacy CGI edge. Same dual-home and Windows reachability contract as A, different exploit class. Apache serves a bash or sh CGI status script that interpolates attacker-controlled input. Students must know the CGI path and which parameters the script accepts — not the instructor exploit sequence. Pass-back through this host remains mandatory for a green callback."
- **Show:** Contrast Option B stack (CGI) against Option A (PHP) while keeping topology identical.
- **Do:** Ask: "Why keep beacon load representative instead of standing up dozens of full client OSes?"
- **Ask (Q):** Why keep beacon load representative instead of standing up dozens of full client OSes?
- **Expected Response (A):** Concurrency on the redirector path matters; full client OS diversity rarely flips whether CGI RCE and pass-back work.

### Slide 8: Option C — Tomcat Manager / WAR (Rocky or Alma) (13 min)

- **Base:** Rocky Linux or AlmaLinux; **dual NIC** (ops-facing + private to Windows)
- **Stack:** Apache Tomcat (pin a major version)
- **Surface:** Manager app enabled; `tomcat-users.xml` role/user facts for manager-script / manager-gui
- **Windows:** reachable from the private NIC via RDP or SSH
- **After RCE:** same userland forwarder expectation for C2 pass-back to Kali
- Reconstruct inventory only — no setup or exploit steps on this slide

**Instructor Notes:**

- **Image Prompt:** Rocky/Alma badge on dual-NIC host; Tomcat icon with Manager badge; WAR deploy cue; private arrow to Windows; forwarder badge toward Kali.
- **Say:** "Option C is the Java app-server edge. Students reconstruct a RHEL-family host with Tomcat, enable the manager application, and leave manager identity facts weak enough to support WAR deploy or manager RCE. Listener ports and dual-NIC addressing are part of the inventory. Same Windows private reachability and same post-RCE forwarder contract as A and B. Answer key holds version pins, user XML, and exploit walkthrough."
- **Show:** Walk reconstruct bullets; underline that manager identity facts are inventory, not a password dump on the student slide.
- **Do:** Ask: "Name one compromise you would document if you used a lab Windows build instead of the suspected production build."
- **Ask (Q):** Name one compromise you would document if you used a lab Windows build instead of the suspected production build.
- **Expected Response (A):** Facilitation — e.g. shell/interpreter differences, Defender posture, RDP vs WinRM availability — and how that bounds the result.

### Slide 9: What Must Be Representative (13 min)

- Exploit path matches the **chosen option** (PHP / CGI / Tomcat) — not a comfort shell
- **Dual-home** redirector: ops-facing exploit surface + private path to Windows
- **Redirector → Windows** hop must exist (RDP or SSH)
- **Callback** must traverse the redirector back to Kali
- Do **not** shortcut implant delivery by copying files onto Windows from Kali

**Instructor Notes:**

- **Image Prompt:** Checklist of five green "must match" items and one red X over "direct Kali→Windows implant copy" and "ops-facing SSH for ease."
- **Say:** "Representative means anything that can flip the result. If you picked Option A, rehearse PHP-shaped access. If you quietly open ops-facing SSH because it is comfortable, you are rehearsing a different access method. Same trap if you RDP to Windows from Kali on a second NIC you invented — you skipped the redirector foothold. The callback must prove pass-back through the middle box."
- **Show:** Point at the red X items.
- **Do:** Ask: "Which node do you blame first if the beacon never arrives — Windows egress, redirector forwarder, or Kali listener — and why?"
- **Ask (Q):** Which node do you blame first if the beacon never arrives — Windows egress, redirector forwarder, or Kali listener — and why?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 10: Effort vs Gain — Exploitation Range (13 min)

- **Lots of effort / little gain:** extra vanity hosts; perfect WAN latency on every hop
- **Lots of effort / little gain:** ops-facing SSH on the redirector "for ease"
- **Lots of effort / little gain:** direct Kali→Windows implant copy that skips the redirector
- **Little effort / lots of gain:** one honest dual-homed redirector; measure pass-back
- **Little effort / lots of gain:** snapshot before exploit and before beacon placement
- **High value:** match Windows reachability method (RDP vs SSH) and redirector stack fidelity

**Instructor Notes:**

- **Image Prompt:** 2x2 effort/gain board with high-distortion cells for vanity hosts, comfort SSH, and shortcut implant copy; high-gain cells for dual-home, pass-back measure, snapshots; starred cell for Windows reachability match.
- **Say:** "Use the board. Three well-chosen VMs beat a decorative farm. Comfort SSH and shortcut copies buy green screenshots that lie about the SOM. Spend effort on the chosen redirector stack, private Windows access, and proving the callback through the middle hop."
- **Show:** Walk each cell once.
- **Do:** Ask the room to place "RDP from Kali straight to Windows while claiming redirector success" on the board and defend the placement in one sentence.
- **Ask (Q):** Where does "RDP from Kali straight to Windows while claiming redirector success" sit on the effort/gain board, and why?
- **Expected Response (A):** High distortion and little gain. It skips the redirector foothold the scheme of maneuver is testing.

### Slide 11: vSphere Operator Basics for This Course (13 min)

- Own **folder + resource pool** only
- Deploy from **ISO catalog** or thin templates
- Use **snapshots** before risky config and before rehearsal
- Primary access: **vCenter UI + Remote Console** from ops station

**Instructor Notes:**

- **Image Prompt:** Simple vSphere workflow icons: Folder → New VM → Mount ISO → Snapshot → Remote Console.
- **Say:** "You are not administering the cluster. You operate inside your folder and pool. Catalog ISOs and thin templates are already staged. Snapshot before you break identity or networking. Primary path is vCenter from your ops station with Remote Console into the guest. If console fails, escalate — do not invent a second unmanaged access path."
- **Show:** Map icons to the student folder: first name (last initial only if needed).
- **Do:** Confirm every student can find their vCenter folder before the lab.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Addressing Model (13 min)

- Network: **`172.16.44.0/23`**
- Lower half **`172.16.44.0/24`**: DHCP — do not steal
- Upper half **`172.16.45.0/24`**: your static **`/29`**
- Stay in your block; document gateway/DNS from the handout

**Instructor Notes:**

- **Image Prompt:** /23 bar split: left half labeled DHCP 172.16.44.0/24, right half labeled Student Static 172.16.45.0/24 with a highlighted /29 slice.
- **Say:** "Facility DHCP owns the lower half. Your static hosts live only in the upper half inside the slash-twenty-nine you are assigned. IP conflicts are usually someone parking a DC in the DHCP half. That is a fail, not a networking mystery."
- **Show:** Walk one example block from the vsphere README (N=0 → .1–.6).
- **Do:** Have students write their assigned block on a notecard before leaving the lecture.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 13: Rehearsal Method (13 min)

- Dry-run the **SOM steps** against the OE you built
- Inject friction: deny a path, break a cred, trip a sensor
- Record **predicted vs observed** and the plan delta
- Doctrine effect under test is often **reconnoiter** of your own plan quality; map TTPs to **ATT&CK**

**Instructor Notes:**

- **Image Prompt:** Rehearsal loop diagram: Plan → Build OE → Execute TTP → Observe Friction → Update SOM, with ATT&CK tag on the Execute node.
- **Say:** "Rehearsal is not a demo that everything works. It is a deliberate attempt to find where the plan lies. Run the step. Add friction that EMLCOA said the enemy or terrain might impose. Write the delta. If you only screenshot green success, you did not rehearse — you filmed. Friction answers 'what happens when something goes wrong.' Next we define the limits — how far the SOM still works when conditions change. In this exploitation range, friction might be a broken forwarder, denied RDP, or a listener mismatch — not 'ops-facing SSH died,' because comfort SSH was never the chosen exploit path."
- **Show:** Emphasize predicted vs observed as the gradeable artifact; teaser the limits slide; call back to callback pass-back briefly.
- **Do:** Ask for one friction inject appropriate to the redirector pass-back path (not an SSH-for-ease failure).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 14: Define the Limits (13 min)

- Map the **envelope** where the SOM still works
- Pace: how **fast / slow** can the TTP run and remain effective?
- Knobs: which **settings / parameters** can change without breaking the plan?
- Find the **break points** — past which the SOM fails or must change
- Capture limits in the AAR next to friction findings

**Instructor Notes:**

- **Image Prompt:** Horizontal "effectiveness envelope" bar. Green center labeled "SOM effective," amber edges labeled "degraded but usable," red outside labeled "Break — plan must change." Callouts above for Pace and Settings knobs.
- **Say:** "Friction is adversarial or environmental pushback. Limits are the operating envelope of your own scheme of maneuver. How fast can you push before noise, errors, or detection kill the approach? How slow can you go before the timeline fails the mission? Which tool or procedure settings are flexible, and which are load-bearing? Rehearsal should find the green band and the break points — not just prove one happy-path timing. Write those limits down so the next operator does not rediscover them under fire. For this range: how long the forwarder stays up; which callback ports still traverse the redirector; whether RDP-only vs SSH-only on Windows moves you from works to breaks."
- **Show:** Walk pace and settings as two knobs on the envelope graphic; mark break points for forwarder failure and Windows access method.
- **Do:** Ask: "Name one pace limit and one redirector setting you would deliberately vary to find the left and right bounds of the TTP."
- **Ask (Q):** Name one pace limit and one redirector setting you would deliberately vary to find the left and right bounds of the TTP.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 15: Documentation Standard (13 min)

- **OE rationale** — why each host/service exists for the plan
- **Diagram + RAM table** — roles, addresses, memory
- **Snapshot plan** — restore points before risk
- **Rehearsal AAR** — friction, **limits / envelope**, deltas to SOM / TTPs
- **Context & compromises** — what you cut, why, and how that bounds the results

**Instructor Notes:**

- **Image Prompt:** Five deliverable cards fanned out: Rationale, Diagram/RAM, Snapshots, AAR (Friction + Limits), Context & Compromises.
- **Say:** "Your product is not a pretty topology poster. It is a decision package: why these OE pieces, how they are addressed and sized, how you can roll back, and what the rehearsal changed in the scheme of maneuver — including friction findings and the effectiveness envelope. You will make many compromises — hosts you did not build, fidelity you deferred, classroom resource caps, time you did not spend. In this exploitation range that means writing down which redirector option you chose and why, how dual-homing was addressed, and what you approximated on Windows so nobody treats a lean green callback as proof against every production edge stack. Partners and future-you should be able to re-run from that package and know the context."
- **Show:** Tie each card to a rehearsal-lab deliverable; point at Context & Compromises as the lens for interpreting AAR findings.
- **Do:** Ask: "Name one compromise from this exploitation-range scenario — and one wrong conclusion a reader could draw if you left it undocumented."
- **Ask (Q):** Name one compromise from this exploitation-range scenario — and one wrong conclusion a reader could draw if you left it undocumented.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 16: Summary (13 min)

- Build **critical OE** — Kali, one redirector option, Windows — not a full mirror
- Budgets **vary**; rehearse with **local resources** unless scaled rehearsal is resourced
- Match what can flip the result: **exploit path**, **dual-home**, **callback through redirector**
- Spend effort where gain is real; document **compromises and bounds**
- Rehearse for **friction** and the **envelope** where the SOM still works

**Instructor Notes:**

- **Image Prompt:** Five summary tiles: Critical OE, Variable Budgets, Match Load-Bearing Fidelity, Effort vs Gain, Friction + Limits — under banner "Threat-Representative Rehearsal."
- **Say:** "Pull it together. You are not cloning the internet. You select OE pieces that change the plan, work inside the resources you have — classroom or operational — and reserve fuller rehearsal for when command pays for it. Choose one reconstructable redirector option and keep the path honest. Match the load-bearing details: the chosen exploit path, dual-home, and callback through the middle hop. Cut vanity fidelity, keep high-gain fidelity, and write the compromises so results are read in context. Rehearsal proves friction and the left and right bounds of the TTP — not a single green screenshot."
- **Show:** Walk the five tiles once as the lecture contract closed.
- **Do:** Ask for one takeaway a student will apply in the build hour.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 17: Questions (13 min)

- Next: build the exploitation range and rehearse your SOM

**Instructor Notes:**

- **Image Prompt:** Empty dark classroom projection with a single large word Questions centered. No footer, no next-hour text, no lab names, no Module IDs.
- **Say:** "Questions on threat-representative design, the three redirector options, or callback pass-back. When we are done, you will build the lean range and rehearse the path."
- **Show:** Hold the Questions title; point at the footer when ready to transition.
- **Do:** Take questions. Hand out the assigned rehearsal brief and IP assignment slip when the room is ready.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M24-threat-rep-mission-rehearsal is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Option A/B/C reconstruct layouts must stay parallel with the sibling rehearsal lab student brief.

## Questions and check on learning

- **Ask (Q):** What three hosts make the critical OE for this rehearsal?
- **Expected Response (A):** Kali ops, one dual-homed vulnerable *nix redirector (A/B/C), Windows target with callback through the redirector.
- **Ask (Q):** Why must the beacon traverse the redirector instead of calling Kali directly?
- **Expected Response (A):** Direct callback rehearses a different TTP; the SOM under test is implant → redirector pass-back → ops.
- **Ask (Q):** If your CV is an exploitable edge host that fronts the only path to the Windows target, what three OE pieces must exist before rehearsal is honest?
- **Expected Response (A):** Ops platform, vulnerable dual-homed redirector, Windows target on the private path.
