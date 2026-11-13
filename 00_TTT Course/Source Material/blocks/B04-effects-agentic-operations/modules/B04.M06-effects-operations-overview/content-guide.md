---
id: B04.M06
title: Effects Operations Overview
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.1 Effects Operations Overview Content Guide.md
- B03.M01
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

# Effects Operations Overview — Content Guide

**Source:** `../../overview.md`, harvest collection cell (break, then poison, then handoff)
**Audience:** CPT operators preparing to act on an issued harvest collection cell.
**Duration:** ~75 minutes (opening lecture for effects operations)
**Prerequisites:** Tactical planning (METT-TC, CG/CV, EMLCOA, actions-on-contact), access tradecraft, and on-target enumeration discipline.
**References:**

- `../../M01-planning-foundations/lessons/01-military-tactical-planning/content-guide.md` (CG/CV vocabulary)
- `../../M01-planning-foundations/lessons/04-d3fend-engage/content-guide.md` and `../../M01-planning-foundations/lessons/04-d3fend-engage/lecture.md`
- `../../M01-planning-foundations/lessons/05-mitre-d3fend-cad/lecture.md`
- [`../../../../environments/b04_temp_harvest_cell/README.md`](../../../../environments/b04_temp_harvest_cell/README.md) (issued harvest collection cell)

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

- **Say:** "You will be issued a live harvest collection cell. Access is the price of admission. This hour is about the effect you produce once you are there: break collection, then poison it, then hand it off."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** From planning, what is the center of gravity of the APT we studied?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "You will be issued a live harvest collection cell. Access is the price of admission. This hour is about the effect you produce once you are there: break collection, then poison it, then hand it off."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** From planning, what is the center of gravity of the APT we studied?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Effects Operations — Why We Are Here (3 min)

- Issued foothold: a live harvest collection cell
- Access enables action
- **Effects** create mission value
- Planning still drives choices: **CG / CV / exploitation plan**

**Instructor Notes:**

- **Image Prompt:** A split-screen graphic. Left panel: a stylized red-team dashboard labeled "Access" with a glowing foothold icon. Right panel: the same foothold now labeled "Effect" with four outbound arrows labeled Degrade/Disrupt/Deny, Deceive/Manipulate, Reconnoiter, Handoff. A dim CG/CV callout box underneath both panels.
- **Say:**
  - "You will be issued a live harvest collection cell."
  - "That access is the price of admission."
  - "This hour asks the next question: now that you are there, what do you do?"
  - "Access matters when it produces a deliberate, bounded effect."
  - "Every effect still has to support the CG/CV logic."
  - "First two days: deliberate effects."
  - "Last three days: doing this with SI help, and recognizing adversary SI use."
- **Show:**
  - Point from "Access" to "Effect."
  - Point at the CG/CV callout.
- **Do:**
  - Ask: "From planning, what is the center of gravity of the APT we studied?"
  - Take one answer.
  - Ask: "And what is a critical vulnerability against that CG?"
  - Capture both on the whiteboard as the running example.
- **Ask (Q):** From planning, what is the center of gravity of the APT we studied?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Effect ≠ Action (3 min)

- **Effect:** intended adversary change
- **Action:** technical method
- Same effect, many actions
- Same action, many effects
- Commanders task effects; operators choose actions

**Instructor Notes:**

- **Image Prompt:** A two-column table graphic. Left column "Effect" (verbs: deny, degrade, disrupt, destroy, deceive, manipulate). Right column "Action" (specific tool/command examples: `systemctl disable`, `INSERT INTO exfil_logs ...`, `plant canary.docx`, `drop partner_rat.exe`). Arrows show that multiple actions can map to the same effect.
- **Say:**
  - "Effect versus action keeps you out of trouble."
  - "Commander says: degrade their collection."
  - "That is an effect."
  - "You choose the action: stop a service, poison a database, corrupt logs."
  - "Choice depends on assessment, risk, access reliability, team skill, and partner need."
  - "Do not report an effect you did not actually achieve."
- **Show:**
  - Point to the effect column.
  - Point to the action column.
  - Linger on the multi-to-multi arrows.
- **Do:**
  - Ask: "Name an action you took on a prior on-target host."
  - Ask: "What effect, if any, did it produce?"
  - Take two answers.
  - Correct effect/action conflation.
- **Ask (Q):** Name an action you took on a prior on-target host.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 3: Doctrinal Effects Language (D4M Family + Related Terms) (3 min)

- **D4M:** deny / degrade / disrupt / destroy
- **Related:** deceive / manipulate / reconnoiter / interdict / handoff
- Next: example-driven outcomes
- Classify by outcome, duration, recovery cost

**Instructor Notes:**

- **Image Prompt:** A two-row graphic. Top row labeled "D4M family" with four tiles: Deny, Degrade, Disrupt, Destroy. Bottom row labeled "Related effects" with four tiles: Deceive/Manipulate, Reconnoiter, Interdict, Handoff. Add a footer line: "Classify by outcome, duration, and recovery cost."
- **Say:**
  - "This is planning language, not a new dictionary."
  - "D4M verbs describe what you want done to an adversary capability."
  - "Related terms cover decision-cycle attack, intelligence collection, pathway denial, and partner transition."
  - "Classification is not the command you typed."
  - "Classification is what changed, how long it lasts, and how hard recovery is."
  - "The next slides stay concrete and example-driven."
- **Show:**
  - Walk the D4M row left to right.
  - Walk the related-effects row left to right.
  - Point at the footer classification line.
- **Do:**
  - Tell students: "For every example, ask what the adversary lost, kept, missed, or misunderstood."
  - Tell students: "Also ask what you must check before touching the keyboard."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 4: Deny Example — Revoke the Collector Credential (3 min)

- **Outcome:** collector cannot authenticate
- **Example:** revoke the collector credential
- `Access:` can we reach the identity/control plane reliably?
- `Dependency:` is this the credential the workflow actually uses?
- `Alternates:` backup token, service account, cached secret?
- `Rollback:` who restores it, and how fast?
- `Proof:` auth failure plus stopped collection

**Instructor Notes:**

- **Image Prompt:** A denial graphic showing a collector trying to authenticate to a service. The credential path is marked revoked, the collection job fails at login, and the downstream dashboard shows no new collection.
- **Say:**
  - "Deny is a hard stop."
  - "The adversary still wants to run the capability, but cannot."
  - "Scenario: the collector polls a staging API with one service credential."
  - "That credential is the dependency that lets collection run."
  - "Action: disable, revoke, or rotate that credential so the collector cannot log in."
  - "Do not assume the credential matters; prove the workflow uses it."
  - "Check for alternate credentials before calling this denial."
  - "Evidence should show authentication failure and stopped collection."
  - "If a backup token keeps the workflow alive, you did not deny it."
- **Show:**
  - Point to the revoked credential.
  - Point to the failed login.
  - Point to the missing downstream collection.
- **Do:**
  - Ask: "What would prove this credential is the real dependency?"
  - Ask: "What alternate path would defeat this denial?"
- **Ask (Q):** What would prove this credential is the real dependency?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 5: Deny Example — Block the Exfil Route (3 min)

- **Outcome:** data cannot leave by that path
- **Example:** block the exfil route
- `Access:` can we change the right DNS/firewall/route point?
- `Path:` destination, port, protocol, relay sequence?
- `Alternates:` fallback route, second relay, direct cloud path?
- `Persistence:` survives restart and mission window?
- `Proof:` failed connection plus stalled transfer

**Instructor Notes:**

- **Image Prompt:** A route map showing collected data moving toward an exfil destination. The selected route is blocked at a firewall or DNS control point, with alternate routes shown as question-mark paths that students must check.
- **Say:**
  - "This is still deny because the selected path becomes unusable."
  - "The target is network reachability, not the local tool."
  - "Scenario: collection bundles leave through a relay path to a known reporting destination."
  - "That path depends on a DNS, firewall, proxy, or route control point."
  - "Action: block or sinkhole the selected route so bundles cannot reach the destination."
  - "Students must identify the actual route before changing controls."
  - "Check for fallbacks, second relays, or direct cloud paths."
  - "Rule persistence matters if the mission window spans restarts."
  - "Evidence should show connection failure and no successful transfer."
  - "If traffic simply moves to another path, denial failed."
- **Show:**
  - Trace the normal route.
  - Point to the block point.
  - Point to alternate-route checks.
- **Do:**
  - Ask: "What makes this route the right control point?"
  - Ask: "What evidence separates route denial from a local tool crash?"
- **Ask (Q):** What makes this route the right control point?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 6: Degrade Example — Lengthen Polling Interval (3 min)

- **Outcome:** collection arrives too slowly
- **Example:** lengthen polling interval
- `Access:` can we edit config and reload safely?
- `Timing:` what collection delay supports the mission?
- `Technique:` reload, restart, or scheduled pickup?
- `Reversibility:` known original value and restore path?
- `Proof:` before/after cadence comparison

**Instructor Notes:**

- **Image Prompt:** A before/after timing graphic. Before: collector polls every five minutes. After: collector still works but polls much less often, with delayed entries arriving downstream.
- **Say:**
  - "Degrade keeps the capability alive but worse."
  - "Here, the product is less timely."
  - "Scenario: a collector polls endpoints on a short interval and forwards results downstream."
  - "The adversary still gets data because the pipeline remains alive."
  - "Action: change the polling schedule so collection happens much less often."
  - "Do not pick an interval at random."
  - "Tie the delay to the mission window."
  - "Know whether the config needs reload or restart."
  - "Preserve the original value for rollback."
  - "Evidence is a before/after cadence comparison."
- **Show:**
  - Compare normal cadence to delayed cadence.
  - Point out that collection still occurs.
- **Do:**
  - Ask: "When does slow become operationally useful?"
  - Ask: "When would this accidentally become deny?"
- **Ask (Q):** When does slow become operationally useful?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 7: Degrade Example — Remove One Feeder Source (3 min)

- **Outcome:** coverage becomes incomplete
- **Example:** remove one feeder source
- `Access:` can we change the source without breaking the pipeline?
- `Dependency:` what does this feeder uniquely provide?
- `Blast radius:` partial loss, not total outage?
- `Visibility:` will analysts notice and compensate?
- `Proof:` lower volume or missing coverage area

**Instructor Notes:**

- **Image Prompt:** A collection pipeline with three feeder sources entering one processing path. One feeder is removed, and the output still exists but has a visible coverage gap.
- **Say:**
  - "This degradation reduces coverage rather than timing."
  - "The pipeline still runs."
  - "The product is less complete."
  - "Scenario: a redirector receives feeds from multiple implants."
  - "Those feeds are consolidated, parsed, and forwarded to a backend database."
  - "Action: remove or disable one feeder source while leaving the rest of the pipeline intact."
  - "Students must know what the feeder uniquely contributes."
  - "The goal is partial loss, not total outage."
  - "Analyst visibility matters; obvious loss may trigger fast repair."
  - "Evidence is lower volume or a missing coverage slice."
- **Show:**
  - Point to the removed feeder.
  - Point to the remaining pipeline.
  - Point to the output gap.
- **Do:**
  - Ask: "What would make this too obvious?"
  - Ask: "What evidence proves degradation instead of denial?"
- **Ask (Q):** What would make this too obvious?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 8: Disrupt Example — Stop Process During Reporting (3 min)

- **Outcome:** decisive reporting window missed
- **Example:** stop process during reporting
- `Access:` reliable at the exact action time?
- `Window:` start, duration, and mission relevance?
- `Recovery:` auto-restart, manual restart, or watchdog?
- `Coordination:` team ready to observe and deconflict?
- `Proof:` missed window plus later recovery

**Instructor Notes:**

- **Image Prompt:** A timeline with a normal reporting window on top and a disrupted window below. The process stops during the reporting period, then recovers later after the decisive time has passed.
- **Say:**
  - "Disrupt breaks rhythm."
  - "The capability may come back."
  - "The problem is that it comes back too late."
  - "Scenario: a collection process has one reporting window that matters to the mission."
  - "If that window is missed, later recovery does not undo the disruption."
  - "Action: stop the process during the reporting window and allow recovery afterward."
  - "Timing is the center of this example."
  - "Students need the real reporting window, not a guess."
  - "Watchdog or auto-restart behavior changes the effect."
  - "Evidence is the missed window plus later recovery."
- **Show:**
  - Point to the reporting window.
  - Point to the outage inside the window.
  - Point to recovery after the window.
- **Do:**
  - Ask: "If it restarts after ten minutes but the window was five, what effect is that?"
  - Ask: "What evidence would you capture?"
- **Ask (Q):** If it restarts after ten minutes but the window was five, what effect is that?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 9: Disrupt Example — Scramble Scheduler Order (3 min)

- **Outcome:** job chain runs out of sequence
- **Example:** scramble scheduler order
- `Access:` can we edit scheduler state safely?
- `Chain:` upstream and downstream task dependencies?
- `Timing:` wrong order, wrong time, or missed trigger?
- `Recovery:` automatic correction or manual cleanup?
- `Proof:` job logs show broken sequence

**Instructor Notes:**

- **Image Prompt:** A job-chain diagram showing tasks A, B, and C. Normal order is A -> B -> C. The disrupted version runs B before A or misses the handoff trigger, causing downstream delay.
- **Say:**
  - "This disrupts coordination, not the whole capability."
  - "The tasks may all still exist."
  - "The sequence no longer supports the workflow."
  - "Scenario: scheduled jobs collect, parse, stage, and forward data in a fixed order."
  - "Downstream jobs depend on upstream output being ready at the right time."
  - "Action: change schedule order or trigger timing so jobs run before prerequisites exist."
  - "Students must map dependencies before changing schedule state."
  - "Know whether the system self-corrects."
  - "Manual cleanup means added adversary burden."
  - "Evidence comes from job logs and delayed downstream action."
- **Show:**
  - Trace the normal order.
  - Trace the scrambled order.
  - Point to the broken handoff.
- **Do:**
  - Ask: "Which dependency must students prove first?"
  - Ask: "When would this drift into denial?"
- **Ask (Q):** Which dependency must students prove first?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 10: Destroy Example — Remove Key Material (3 min)

- **Outcome:** secure channel requires rebuild
- **Example:** remove key material
- `Access:` can we reach and verify the key location?
- `Uniqueness:` only working key, cert, or token?
- `Backups:` local copy, vault, snapshot, export?
- `Authority:` mission approval for destructive action?
- `Proof:` failed channel plus rebuild requirement

**Instructor Notes:**

- **Image Prompt:** A capability stack where certificate/key material is highlighted as the single dependency for an encrypted reporting or exfil channel. Recovery arrow is labeled "reissue / redeploy required."
- **Say:**
  - "Destroy means recovery is hard."
  - "Here, the destroyed dependency is key material."
  - "Scenario: the reporting channel depends on one deployed certificate, private key, or token."
  - "Without that material, the adversary must reissue and redeploy before the channel works."
  - "Action: remove the required key material and any immediately usable local copy."
  - "A deleted key only matters if it is unique and required."
  - "Backups can turn destroy into short disruption."
  - "This requires explicit mission approval."
  - "Evidence must show failed channel operation and rebuild burden."
  - "Do not call it destroy just because a file was deleted."
- **Show:**
  - Point to the key dependency.
  - Point to backup checks.
  - Point to rebuild requirement.
- **Do:**
  - Ask: "What makes this destructive instead of disruptive?"
  - Ask: "What backup evidence would change your classification?"
- **Ask (Q):** What makes this destructive instead of disruptive?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 11: Destroy Example — Wipe Staging Data and Quick Restore Copy (3 min)

- **Outcome:** staging function needs restoration
- **Example:** wipe staging data plus quick restore copy
- `Access:` can we affect data and local restore copy?
- `Criticality:` does staging data drive the capability?
- `Containment:` avoid unrelated or partner-needed data?
- `Recovery:` distant backup, rebuild, or manual re-entry?
- `Proof:` missing data plus no quick restore path

**Instructor Notes:**

- **Image Prompt:** A staging database with a nearby quick restore export. Both the live staging data and quick restore copy are removed, while distant backup is shown as slow or unavailable.
- **Say:**
  - "This destroys by increasing recovery burden."
  - "The live data alone may not be enough."
  - "The quick restore copy matters."
  - "Scenario: staging data feeds the adversary's analytic or reporting backend."
  - "A nearby export or snapshot lets them restore quickly if only live data is lost."
  - "Action: remove the staging data and the quick local restore copy in the same operation."
  - "Students must avoid unrelated data and partner equities."
  - "Criticality has to be tied to the adversary capability."
  - "Evidence is missing staging data plus no quick local restore."
  - "If ordinary admin steps restore it in minutes, it was not destroy."
- **Show:**
  - Point to live staging data.
  - Point to the quick restore copy.
  - Point to the slower recovery path.
- **Do:**
  - Ask: "Why does the nearby restore copy matter?"
  - Ask: "What second-order effects must be checked?"
- **Ask (Q):** Why does the nearby restore copy matter?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 12: Deceive / Manipulate Example — Poison Target-Priority Records (3 min)

- **Outcome:** adversary mis-prioritizes effort
- **Example:** poison target-priority records
- `Access:` can we safely write to the right table or queue?
- `Model:` fields, valid values, and downstream consumers?
- `Believability:` consistent host, user, timing, and priority logic?
- `Detection:` can we observe changed tasking or analyst focus?
- `Proof:` poisoned record plus mis-prioritized action

**Instructor Notes:**

- **Image Prompt:** A decision-cycle graphic where a target-priority table feeds an analyst dashboard. One inserted or changed priority record moves a low-value target into a high-priority lane, and the analyst queue follows the false priority.
- **Say:**
  - "Deception succeeds when the adversary chooses wrong for a believable reason."
  - "Scenario: an analyst dashboard ranks targets from a backend priority table."
  - "Priority fields drive what operators investigate first."
  - "Action: insert or alter a believable record so the wrong target rises in the queue."
  - "The goal is mis-prioritization, not outage."
  - "Check the data model before writing anything."
  - "Evidence is the poisoned record plus changed analyst focus."
- **Show:**
  - Point to the priority record.
  - Point to the dashboard queue.
  - Point to the wrong high-priority target.
- **Do:**
  - Ask: "What makes a false priority believable?"
  - Steer toward field consistency, timing, and existing patterns.
- **Ask (Q):** What makes a false priority believable?
- **Expected Response (A):** field consistency, timing, and existing patterns

### Slide 13: Deceive / Manipulate Example — Plant a False Timeline Artifact (3 min)

- **Outcome:** adversary trusts the wrong sequence
- **Example:** plant a false timeline artifact
- `Access:` can we place the artifact where analysts already look?
- `Format:` filename, timestamp, metadata, and style match?
- `Consistency:` aligns with other logs and host behavior?
- `Risk:` false artifact does not break normal workflow?
- `Proof:` decoy review, mention, or follow-on action

**Instructor Notes:**

- **Image Prompt:** A timeline view with authentic log entries and one planted artifact that shifts the apparent sequence of activity. Analyst attention follows the false timeline toward the wrong conclusion.
- **Say:**
  - "This example manipulates the adversary's sense of sequence."
  - "Scenario: analysts review documents, screenshots, or logs to reconstruct activity."
  - "They trust artifacts that match normal naming, timing, and metadata."
  - "Action: place a false timeline artifact in a location they already use."
  - "The artifact must fit the environment around it."
  - "If it looks staged, it fails."
  - "Evidence is decoy review, mention, or follow-on action."
- **Show:**
  - Point to authentic timeline entries.
  - Point to the planted artifact.
  - Point to the wrong conclusion.
- **Do:**
  - Ask: "What would make this artifact stand out as fake?"
  - Take two answers.
- **Ask (Q):** What would make this artifact stand out as fake?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 14: Reconnoiter Example — Map the Collection Pipeline (3 min)

- **Outcome:** pipeline map changes the next COA
- **Example:** map the collection pipeline
- `Access:` what hosts, services, and data stores are in scope?
- `Safety:` commands are read-only and low-noise?
- `Unknowns:` controller, feeder, parser, database, relay?
- `Evidence:` configs, schedules, process state, and data paths?
- `Output:` diagram-ready facts for COA comparison

**Instructor Notes:**

- **Image Prompt:** A layered pipeline map that starts blank, then adds hosts, services, schedules, data paths, and choke points until the collection workflow is clear enough for planning.
- **Say:**
  - "Reconnoiter is an effect when it answers a mission gap."
  - "Scenario: the team has access but does not know how collection actually flows."
  - "The pipeline may include feeders, parser jobs, staging storage, and reporting relays."
  - "Action: enumerate services, schedules, configs, data paths, and process state."
  - "The result should support COA comparison."
  - "Use read-only, low-noise collection first."
  - "Evidence is a pipeline map tied to real artifacts."
- **Show:**
  - Build the map layer by layer.
  - Point to newly discovered dependencies.
  - Point to the likely choke point.
- **Do:**
  - Ask: "What fact would change your next COA?"
  - Take one or two answers.
- **Ask (Q):** What fact would change your next COA?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 15: Reconnoiter Example — Confirm Operator Cadence (3 min)

- **Outcome:** timing intelligence changes action window
- **Example:** confirm operator cadence
- `Access:` can we inspect logs without changing state?
- `Sources:` login history, job logs, dashboard events, edits?
- `Time basis:` timezone, clock drift, and log rollover?
- `Attribution:` human operator, service account, or automation?
- `Proof:` cadence pattern tied to next action timing

**Instructor Notes:**

- **Image Prompt:** A time-series graphic showing operator logins, dashboard use, job runs, and quiet periods. A highlighted action window appears where adversary attention is predictably low.
- **Say:**
  - "This recon example is about timing."
  - "Scenario: stronger effects depend on when adversary operators are active or absent."
  - "Logs may show login patterns, dashboard touches, task edits, or review cycles."
  - "Action: compare multiple time sources to establish operator cadence."
  - "Do not trust one timestamp without checking time basis."
  - "Separate human activity from automation."
  - "Evidence is a cadence pattern that changes when you act."
- **Show:**
  - Point to active periods.
  - Point to quiet periods.
  - Point to the proposed action window.
- **Do:**
  - Ask: "Why is timezone or clock drift a mission issue here?"
  - Ask: "What source would corroborate operator activity?"
- **Ask (Q):** Why is timezone or clock drift a mission issue here?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 16: Interdict Example — Sinkhole the Reporting Destination (3 min)

- **Outcome:** reporting path ends at a sink
- **Example:** sinkhole the reporting destination
- `Access:` can we change DNS, proxy, or routing control?
- `Path:` destination name, address, protocol, and relay path?
- `Scope:` affects intended reporting flow only?
- `Alternates:` cached address, backup domain, direct IP path?
- `Proof:` traffic reaches sink or fails before analyst node

**Instructor Notes:**

- **Image Prompt:** A reporting route map where traffic normally moves from collection nodes through a relay to an analyst destination. The route is redirected to a sinkhole, with alternate routes shown as checks.
- **Say:**
  - "Interdict is pathway language."
  - "Scenario: collected data reaches analysts through a named reporting destination."
  - "The destination depends on DNS, proxy, or route resolution."
  - "Action: sinkhole or redirect that destination so reporting never reaches the analyst node."
  - "The endpoint tool may still run."
  - "The path no longer delivers useful movement."
  - "Evidence is sinkhole traffic or failed delivery before the analyst node."
- **Show:**
  - Trace normal reporting path.
  - Point to the sinkhole point.
  - Point to alternate-route checks.
- **Do:**
  - Ask: "Why is this interdict instead of local denial?"
  - Make students answer in pathway terms.
- **Ask (Q):** Why is this interdict instead of local denial?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 17: Interdict Example — Remove Queue Access Between Stages (3 min)

- **Outcome:** workflow segment is isolated
- **Example:** remove queue access between stages
- `Access:` can we change queue or share permissions?
- `Handoff:` which stage writes and which stage reads?
- `Impact:` upstream collection continues but cannot advance?
- `Containment:` only intended queue, share, or API endpoint?
- `Proof:` stalled queue plus isolated downstream stage

**Instructor Notes:**

- **Image Prompt:** A workflow diagram with collection, queue, parser, and analyst stages. Permissions are removed between the queue and parser, so upstream data piles up while downstream processing starves.
- **Say:**
  - "This interdicts the handoff point."
  - "Scenario: one stage drops data into a queue, share, or API endpoint."
  - "A downstream stage reads from that handoff point and continues processing."
  - "Action: remove or narrow access so the downstream stage cannot receive the handoff."
  - "Upstream collection may still run."
  - "The pathway between stages is cut."
  - "Evidence is stalled queue growth and downstream starvation."
- **Show:**
  - Point to upstream collection.
  - Point to the handoff queue.
  - Point to isolated downstream stage.
- **Do:**
  - Ask: "What must students prove before changing permissions?"
  - Ask: "What would show endpoint failure instead of pathway interdiction?"
- **Ask (Q):** What must students prove before changing permissions?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 18: Handoff Example — Deliver an Access Package (3 min)

- **Outcome:** partner can use access immediately
- **Example:** deliver an access package
- `Access:` tested path, account, credential, and method?
- `Context:` host role, network position, privileges, limits?
- `Reliability:` session lifetime, resets, MFA, timing windows?
- `Risk:` deconfliction, burn risk, and do-not-touch notes?
- `Proof:` partner can connect and orient in minutes

**Instructor Notes:**

- **Image Prompt:** A handoff package with access path, credential, host context, risk notes, and recommended next objective. The partner team uses the package to connect without rediscovering the environment.
- **Say:**
  - "Handoff's outcome is partner reach."
  - "Scenario: your team has tactical access that another team needs to continue the mission."
  - "The partner cannot afford to rediscover the environment."
  - "Action: deliver a concise access package with connection method, credential, host context, limits, and risk notes."
  - "The package must be usable in the first few minutes."
  - "Include what not to touch."
  - "Evidence is the partner connecting and orienting from your report."
- **Show:**
  - Walk the package fields.
  - Point to first-five-minutes usability.
  - Point to risk notes.
- **Do:**
  - Ask: "What would make this package unusable?"
  - Build a short list live.
- **Ask (Q):** What would make this package unusable?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 19: Handoff Example — Validate a Partner Capability (3 min)

- **Outcome:** partner capability is ready to operate
- **Example:** validate a partner capability
- `Approval:` capability, placement, and timing are authorized?
- `Node:` correct host, privilege level, and network position?
- `Persistence:` survives reboot, task rotation, or session loss?
- `Training:` receiving team knows use, limits, and recovery?
- `Proof:` partner can operate capability from handoff notes

**Instructor Notes:**

- **Image Prompt:** A partner-approved capability staged on the correct node with validation checks for placement, persistence, access method, and receiving-team operation.
- **Say:**
  - "This handoff is more than reporting access."
  - "Scenario: a partner-approved capability must be placed or validated on the right node."
  - "The partner needs confidence that it works and will still be there when they take over."
  - "Action: validate placement, access method, persistence behavior, and operating notes."
  - "Do not improvise unapproved tools."
  - "Training and limits are part of the handoff."
  - "Evidence is the partner operating from your notes without rediscovery."
- **Show:**
  - Point to the placement node.
  - Point to persistence checks.
  - Point to partner operating notes.
- **Do:**
  - Ask: "What must be validated before the partner accepts this?"
  - Ask: "What would burn the handoff?"
- **Ask (Q):** What must be validated before the partner accepts this?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 20: Mapping Effects to Planning Vocabulary (3 min)

- **D4M / interdict:** CG as capability or pathway
- **Deceive / manipulate:** decision cycle and EMLCOA
- **Reconnoiter:** RFIs, assumptions, refined CV
- **Handoff:** partner reach and operational options
- Planning intent still applies: **impose cost; generate options**

**Instructor Notes:**

- **Image Prompt:** A four-lane mapping graphic. Left lane labeled "Effect language" with the doctrinal verbs from Slide 3. Middle lane labeled "Attacks" (CG / Decision cycle / Intel gap / Reach). Right lane labeled "Planning Product" (SOM counter-CG, counter-EMLCOA, new RFI set, partner tipper).
- **Say:**
  - "This is how you justify the effect."
  - "D4M and interdict often attack CG as capability or pathway."
  - "Deceive and manipulate attack decision cycle and EMLCOA."
  - "Reconnoiter closes intelligence gaps and refines the next COA."
  - "Handoff converts tactical success into operational reach."
  - "Your answer to the commander should sound like tactical planning."
  - "Every effect decision is a planning decision."
- **Show:**
  - Walk the four lanes left to right.
  - Tie each effect family to its planning product.
- **Do:**
  - Return to the APT example from Slide 1.
  - Assign one effect family to each student pair.
  - Give two minutes for planning justification.
  - Take one example back.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 21: Professional Operations Under Command Direction (3 min)

- Command-directed operations
- Not hacking just to hack
- Access is only one condition
- Think through the full tactical process
- Then execute, assess, and report

**Instructor Notes:**

- **Image Prompt:** A professional operations graphic with four linked blocks: "Mission Intent," "COA Thinking," "Disciplined Execution," and "Assessment / Report." Underneath, a short caption: "Do not outrun the tactical decision-making process."
- **Say:**
  - "This course does not teach random hacking."
  - "It trains command-directed effects operations."
  - "Access is only one condition for action."
  - "Reachability is not permission to start typing."
  - "First: restate mission, desired effect, candidate actions, adversary response, team coordination, and success evidence."
  - "Then: execute."
  - "This is the bridge to the tactical decision-making process."
- **Show:**
  - Point to "Mission Intent."
  - Point to "COA Thinking."
  - Point to "Disciplined Execution."
  - Emphasize thinking before execution.
- **Do:**
  - Ask: "What is the risk of hacking first and planning afterward?"
  - Take two answers.
  - Steer toward wrong effect, burned access, poor deconfliction, and unusable reporting.
- **Ask (Q):** What is the risk of hacking first and planning afterward?
- **Expected Response (A):** wrong effect, burned access, poor deconfliction, and unusable reporting

### Slide 22: Counterstrike Planning Cycle (Planning Applied) (3 min)

- Same planning flow
- **Mission analysis:** task / purpose / constraints / desired effect
- **COA comparison:** feasible / acceptable / suitable / adversary response
- **Execution:** select / coordinate / act
- **Assessment:** intended effect vs observed effect

**Instructor Notes:**

- **Image Prompt:** A planning loop diagram with five nodes: "Mission Analysis," "COA Development," "Wargame/EMLCOA Check," "Decision/Execution," and "Assessment/Report." Add small callouts showing where CG/CV and EMLCOA from planning are used.
- **Say:**
  - "Apply planning discipline to every keyboard action."
  - "First: define mission and desired effect."
  - "Then: build and compare COAs."
  - "Include likely adversary response."
  - "Select and coordinate one COA."
  - "Execute, assess intended versus observed effect, and report in commander language."
  - "The technical command is the last step, not the first."
- **Show:**
  - Walk the planning loop clockwise.
  - Tie each node to planning products.
- **Do:**
  - Scenario: "Task: deny adversary collection for one reporting period."
  - Students verbalize mission analysis, candidate COA, anticipated adversary response, and assessment criterion.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 23: Two Effect Families on a Live Foothold (3 min)

- **Break collection**
- Effects: **degrade / disrupt / deny**
- **Poison collection**
- Effects: **deceive / manipulate**
- Then a **handoff package**
- Deliverable: short effect report

**Instructor Notes:**

- **Image Prompt:** A generic operation flow diagram with three boxes: "Your Access Position," "Adversary Collection Workflow," and "Effect Reporting." Do not include platform or infrastructure implementation details.
- **Say:**
  - "Two effect families on the same collection cell."
  - "Same operational problem set."
  - "Different effects."
  - "Break collection: choose degrade, disrupt, or deny where reversible paths are preferred."
  - "Poison collection: deceive or manipulate without producing an outage."
  - "After those effects, the product is a handoff package another team can use."
  - "Each practice produces a short effect report: effect, action, observed result, risk assessment."
  - "Platform details live in the student briefs."
- **Show:**
  - Show the generic operation flow.
  - Keep attention on access, workflow, and reporting.
- **Do:**
  - Hand out the break-collection student brief.
  - Remind students the brief is the authority document.
  - Break for 15 minutes, then begin the lab.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 24: Wrap — Planning Cadence, Then Execute (3 min)

- Before action: **effect / action / predicted response**
- After action: **observed result / risk reassessment**
- Five lines = report format
- Later: a **handoff package** uses the same report format

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:**
  - "Five lines."
  - "Effect, action, predicted response, observed result, risk reassessment."
  - "That is your report."
  - "It is short on purpose; commanders read five lines."
  - "First three lines happen before keyboard action."
  - "Last two lines prove whether the intended effect occurred and whether risk changed."
  - "If the action cannot survive five-line reporting, reconsider it."
- **Show:**
  - Show the five-line cadence verbatim.
- **Do:**
  - Students write the blank template in their notebook.
  - They fill it in twice today and twice tomorrow.
  - Release to break-collection practice.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M06-effects-operations-overview is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** From planning, what is the center of gravity of the APT we studied?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** Name an action you took on a prior on-target host.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
