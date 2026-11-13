---
id: B04.M01
title: Threat-Representative Environments and Mission Rehearsal
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.0.a Threat-Representative Environments and Mission
  Rehearsal Content Guide.md
- B01.M29
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

# Threat-Representative Environments and Mission Rehearsal — Content Guide

**Source:** `../../overview.md`, `../../activities/L4.0a_Threat_Rep_Mission_Rehearsal/`, `../../activities/L4.0a_Adversary_Exfil_Stack_Reconstruction/`, `../../../../environments/effects_lab_env/vsphere/README.md`
**Audience:** CPT operators entering this Block who completed planning and on-target work.
**Duration:** Instructor-flexible opening lecture before the assigned rehearsal labs.
**Prerequisites:** Tactical planning (METT-TC, EMLCOA, CG/CV, SOM); ATT&CK ↔ D3FEND/ENGAGE bridge.
**References:**

- `../../M01-planning-foundations/lessons/01-military-tactical-planning/content-guide.md`
- `../../M01-planning-foundations/lessons/01-military-tactical-planning/content-guide.md`
- `../../M01-planning-foundations/lessons/04-d3fend-engage/content-guide.md`
- `../../../../environments/effects_lab_env/vsphere/README.md`
- `../../activities/L4.0a_Threat_Rep_Mission_Rehearsal/L4.0.a Student Brief.md`
- `../../activities/L4.0a_Adversary_Exfil_Stack_Reconstruction/L4.0.a Alternative Student Brief.md`

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
- **Show:** Walk the five objective tiles; contrast 'local resources / today's classroom cap' with 'scaled rehearsal when resourced'; point ahead to the assigned rehearsal lab (document-pipeline brief or the parallel reconstruction brief — instructor choice, same decision process).
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

### Slide 5: Scenario — Co-opted Redirector (13 min)

- Hundreds of beacons → co-opted **redirector** → backend **C2**
- Redirector access: **PHP execution only** — no interactive shell
- Backend C2 reachable **only through** the redirector
- RCE against C2 requires **HTTPS** to a **self-signed** cert (not a public CA)
- Rehearsal goal: **prove the RCE works** on that path

**Instructor Notes:**

- **Image Prompt:** Simple path diagram: many beacon icons → Redirector (PHP-only badge) → Backend C2 (HTTPS with a self-signed cert badge, not a green public-CA lock). Attack-platform arrow into the redirector labeled "PHP exec." Goal callout: "Validate RCE."
- **Say:** "Concrete example. Production looks like hundreds of beacons calling a co-opted redirector that fronts a backend C2. With the tools you have, you can execute PHP on the redirector — that is it. No interactive shell on that box. The backend C2 is only reachable through the redirector, and your RCE needs HTTPS to a service presenting a self-signed certificate — not a tidy public CA like Let's Encrypt. That wrinkle matters: many clients and libraries succeed against valid public certs and fail, hang, or take a different code path on self-signed trust. The rehearsal question is not 'can we rebuild the whole beacon farm.' It is 'will our RCE work through this path under those constraints.' Pair the path in partner language — redirector as proxy terrain, RCE as the ATT&CK-shaped exploitation step — but keep the doctrine framing: you are testing a critical vulnerability on the CG path."
- **Show:** Trace beacons → redirector → C2; circle PHP-only and self-signed HTTPS as load-bearing constraints.
- **Do:** Ask: "If the RCE fails in rehearsal, which node do you blame first — redirector access shape, self-signed TLS handling, or beacon volume — and why?"
- **Ask (Q):** If the RCE fails in rehearsal, which node do you blame first — redirector access shape, self-signed TLS handling, or beacon volume — and why?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 6: What Must Be Representative (13 min)

- Operator path on the redirector stays **PHP / webshell-shaped**
- C2 contact must be **HTTPS with self-signed trust behavior**
- **Redirector → C2** hop must exist — that is the RCE carrier
- Beacon load only as far as it **stresses the path you will use**
- Do **not** add SSH just because testing is easier — wrong access path

**Instructor Notes:**

- **Image Prompt:** Checklist of four green "must match" items (PHP path, HTTPS + self-signed cert, Redirector→C2 hop, representative load) and one red X over an SSH icon on the redirector. Small callout: "Valid public CA ≠ self-signed."
- **Say:** "Representative means anything that can flip the RCE result. If production access is PHP-only, your OE must force you to operate that way. If you quietly stand up SSH on the redirector because it is more comfortable, you are no longer rehearsing the mission — you are rehearsing a different access method. Same trap on TLS: rehearsing against a clean public-CA cert when the real C2 is self-signed is a false green. Tools often 'just work' with valid certs and break on self-signed verification, hostname mismatch, or trust-store handling. The redirector-to-C2 hop is load-bearing because that is the only route to the target. Beacon volume matters only to the degree it changes redirector behavior under the PHP path you will actually use."
- **Show:** Point at the red X on SSH and the 'Valid public CA ≠ self-signed' callout.
- **Do:** Ask: "What false confidence would a Let's Encrypt stand-in create before you ever fire the RCE on the real self-signed C2?"
- **Ask (Q):** What false confidence would a Let's Encrypt stand-in create before you ever fire the RCE on the real self-signed C2?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 7: Sensible Compromises Under Constraint (13 min)

- Beacon count: **representative concurrency**, not hundreds of full clients
- Client OS diversity: often low value — scripts / containers / one generator host
- **C2 OS: get as right as you can** — exploits often depend on details you do not know yet
- Use OS mismatch discovery to map **TTP fragility** and left/right bounds of what works
- Latency focus: **attack platform ↔ redirector** and **redirector ↔ C2**; client WAN can be approximate

**Instructor Notes:**

- **Image Prompt:** Three hop bars with thick Attack↔Redirector and Redirector↔C2. Beside the C2 node: callouts "bash→dash?", "lib path/name?", "distro defaults?" feeding a small "bounds of what works" bracket. Side note: "N containers ≠ hundreds of client VMs."
- **Say:** "Local resources force choices. You probably do not need hundreds of distinct client operating systems calling home — scripts or a small container farm usually buy enough concurrency on the redirector. The backend C2 is different. Get the C2 OS as right as you reasonably can. Exploits and payloads often depend on details you will not see on a slide: bash symlinked to dash, a shared library with a different name or path, package defaults that change behavior. You may not know those ahead of time. That is exactly why rehearsal matters — a close OS match is how you discover TTP fragility and map the left and right bounds of what still works before you are on the real target. Do not 'simplify' TLS to a public CA just because issuance is easier in the lab. Spend latency attention on the hops that carry your operator actions and the RCE. Document every compromise so nobody reads a lean OE as a full-scale proof."
- **Show:** Contrast cheap client-beacon compromise with high-value C2 OS fidelity; point at the fragility callouts.
- **Do:** Ask: "Name one OS-detail failure you have seen that looked like 'the exploit is wrong' until someone checked the shell or library path."
- **Ask (Q):** Name one OS-detail failure you have seen that looked like 'the exploit is wrong' until someone checked the shell or library path.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 8: Effort vs Gain — Redirector Scenario (13 min)

- **Lots of effort / little gain:** hundreds of full OS beacon VMs
- **Lots of effort / little gain:** perfect multi-hop latency mirror end-to-end
- **Lots of effort / little gain:** interactive shell / SSH on the redirector "for ease"
- **Lots of effort / little gain:** swapping self-signed for a "clean" public CA cert to make testing easier
- **Little effort / lots of gain:** small script/container beacon farm for concurrency
- **Little effort / lots of gain:** keep PHP-only path; **self-signed** HTTPS path; measure redirector→C2
- **High value:** match **C2 OS** closely — finds hidden TTP bounds (shell, libs, paths)

**Instructor Notes:**

- **Image Prompt:** 2x2 effort/gain board. High-effort/low-gain (or high-distortion) cells: "Hundreds of full OS beacons," "Perfect WAN latency copy," "SSH on redirector," "Public CA instead of self-signed." Low-effort/high-gain cells: "Container/script load," "PHP-only access," "Self-signed HTTPS + measure R→C2 hop." Separate starred cell: "Close C2 OS match → fragility / bounds."
- **Say:** "Use the board. Standing up hundreds of full client operating systems burns RAM and time and rarely changes whether the HTTPS RCE works through PHP on the redirector. Chasing perfect latency on every hop is the same trap unless the mission depends on it. Adding SSH so you can 'work faster' is high effort in fidelity cost — it buys comfort and destroys representativeness. Same for promoting the C2 to a valid public certificate because self-signed is annoying: you may pass rehearsal and fail on target. On the other side: a small container or script farm, staying inside PHP execution, keeping the self-signed HTTPS behavior, and measuring the redirector-to-C2 hop are usually cheap moves that protect the rehearsal question. Budget hard for C2 OS fidelity — that is often where you learn the exploit assumes bash, or a library path that is not there, and you map the real bounds of the TTP. That is threat-representative thinking under a hard budget."
- **Show:** Walk each cell once; highlight the starred C2 OS cell as high-value even when RAM is tight.
- **Do:** Ask the room to place "rehearse with Let's Encrypt, exploit for real against self-signed" and "Ubuntu stand-in for an unknown C2 distro" on the board and defend each placement in one sentence.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: vSphere Operator Basics for This Course (13 min)

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

### Slide 10: Addressing Model (13 min)

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

### Slide 11: Rehearsal Method (13 min)

- Dry-run the **SOM steps** against the OE you built
- Inject friction: deny a path, break a cred, trip a sensor
- Record **predicted vs observed** and the plan delta
- Doctrine effect under test is often **reconnoiter** of your own plan quality; map TTPs to **ATT&CK**

**Instructor Notes:**

- **Image Prompt:** Rehearsal loop diagram: Plan → Build OE → Execute TTP → Observe Friction → Update SOM, with ATT&CK tag on the Execute node.
- **Say:** "Rehearsal is not a demo that everything works. It is a deliberate attempt to find where the plan lies. Run the step. Add friction that EMLCOA said the enemy or terrain might impose. Write the delta. If you only screenshot green success, you did not rehearse — you filmed. Friction answers 'what happens when something goes wrong.' Next we define the limits — how far the SOM still works when conditions change. In the redirector example, friction might be PHP timeouts under load or self-signed trust failures in the HTTPS client — not 'SSH died,' because SSH was never the path."
- **Show:** Emphasize predicted vs observed as the gradeable artifact; teaser the limits slide; call back to the redirector example briefly.
- **Do:** Ask for one friction inject appropriate to the PHP-on-redirector path (not an SSH failure).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Define the Limits (13 min)

- Map the **envelope** where the SOM still works
- Pace: how **fast / slow** can the TTP run and remain effective?
- Knobs: which **settings / parameters** can change without breaking the plan?
- Find the **break points** — past which the SOM fails or must change
- Capture limits in the AAR next to friction findings

**Instructor Notes:**

- **Image Prompt:** Horizontal "effectiveness envelope" bar. Green center labeled "SOM effective," amber edges labeled "degraded but usable," red outside labeled "Break — plan must change." Callouts above for Pace and Settings knobs.
- **Say:** "Friction is adversarial or environmental pushback. Limits are the operating envelope of your own scheme of maneuver. How fast can you push before noise, errors, or detection kill the approach? How slow can you go before the timeline fails the mission? Which tool or procedure settings are flexible, and which are load-bearing? Rehearsal should find the green band and the break points — not just prove one happy-path timing. Write those limits down so the next operator does not rediscover them under fire. For the redirector case: how many concurrent synthetic beacons before PHP exec becomes unreliable; which TLS verify / trust-store knobs still let the self-signed HTTPS RCE succeed; and which C2 OS details — shell binary, library names and paths — move you from 'works' to 'breaks' even when the exploit 'should' be the same."
- **Show:** Walk pace and settings as two knobs on the envelope graphic; mark break points for beacon concurrency, self-signed TLS, and C2 OS detail.
- **Do:** Ask: "For the redirector RCE path, name one pace limit and one C2 OS detail you would deliberately vary to find the left and right bounds of the TTP."
- **Ask (Q):** For the redirector RCE path, name one pace limit and one C2 OS detail you would deliberately vary to find the left and right bounds of the TTP.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 13: Documentation Standard (13 min)

- **OE rationale** — why each host/service exists for the plan
- **Diagram + RAM table** — roles, addresses, memory
- **Snapshot plan** — restore points before risk
- **Rehearsal AAR** — friction, **limits / envelope**, deltas to SOM / TTPs
- **Context & compromises** — what you cut, why, and how that bounds the results

**Instructor Notes:**

- **Image Prompt:** Five deliverable cards fanned out: Rationale, Diagram/RAM, Snapshots, AAR (Friction + Limits), Context & Compromises.
- **Say:** "Your product is not a pretty topology poster. It is a decision package: why these OE pieces, how they are addressed and sized, how you can roll back, and what the rehearsal changed in the scheme of maneuver — including friction findings and the effectiveness envelope. You will make many compromises — hosts you did not build, fidelity you deferred, classroom resource caps, time you did not spend. In the redirector example that means writing down 'synthetic beacons, not hundreds of full OS clients,' 'PHP-only, no SSH,' and 'self-signed C2 TLS, not a public CA stand-in' so nobody treats a green RCE as proof against a different access or trust model. Partners and future-you should be able to re-run from that package and know the context."
- **Show:** Tie each card to a rehearsal-lab deliverable; point at Context & Compromises as the lens for interpreting AAR findings.
- **Do:** Ask: "Name one compromise from the redirector scenario — and one wrong conclusion a reader could draw if you left it undocumented."
- **Ask (Q):** Name one compromise from the redirector scenario — and one wrong conclusion a reader could draw if you left it undocumented.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 14: Summary (13 min)

- Build **critical OE** — what changes decisions, not a full mirror
- Budgets **vary**; rehearse with **local resources** unless scaled rehearsal is resourced
- Match what can flip the result: **access path**, **TLS trust**, **C2 OS**
- Spend effort where gain is real; document **compromises and bounds**
- Rehearse for **friction** and the **envelope** where the SOM still works

**Instructor Notes:**

- **Image Prompt:** Five summary tiles: Critical OE, Variable Budgets, Match Load-Bearing Fidelity, Effort vs Gain, Friction + Limits — under banner "Threat-Representative Rehearsal."
- **Say:** "Pull it together. You are not cloning the internet. You select OE pieces that change the plan, work inside the resources you have — classroom or operational — and reserve fuller rehearsal for when command pays for it. Match the load-bearing details: how you access the box, how TLS actually behaves, and the C2 OS that hides shell and library assumptions. Cut vanity fidelity, keep high-gain fidelity, and write the compromises so results are read in context. Rehearsal proves friction and the left and right bounds of the TTP — not a single green screenshot."
- **Show:** Walk the five tiles once as the lecture contract closed.
- **Do:** Ask for one takeaway a student will apply in the next hour.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 15: Questions (13 min)

- Next: build a threat-representative OE and rehearse your SOM

**Instructor Notes:**

- **Image Prompt:** Empty dark classroom projection with a single large word Questions centered. No footer, no next-hour text, no lab names, no Module IDs.
- **Say:** "Questions on threat-representative design, compromises, or the redirector example. When we are done, you will build a lean threat-representative environment and rehearse your scheme of maneuver against it. The lecture example stays the redirector. The lab packet you receive is the assigned scenario — same decision process, different terrain."
- **Show:** Hold the Questions title; point at the footer when ready to transition.
- **Do:** Take questions. Hand out the assigned Opening A brief and IP assignment slip when the room is ready. If this class is on the parallel reconstruction option, issue the reconstruction student brief only — do not also issue the document-pipeline brief, and do not name destination product, version, credentials, or API details during the handoff. Students rebuild from planning and on-target collection they already hold.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M01-threat-rep-mission-rehearsal is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** If your CV is credential reuse on an admin workstation, what OE piece must exist before rehearsal is honest?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
