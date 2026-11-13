---
id: B04.M17
title: Adversary Agentic Workflows
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.5 Adversary Agentic Workflows Content Guide.md
- B04.M28
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

# Adversary Agentic Workflows — Content Guide

**Source:** `../../overview.md`, `../../activities/L4.5_Adversary_Agent_CounterStrike/`
**Audience:** CPT operators who completed the Effects Advisor build.
**Duration:** ~90 minutes (adversary agentic-workflow lecture).
**Prerequisites:** Lectures 4.1, 4.2, 4.3, 4.4, and all Days 1-4 labs.
**References:**

- `./4.4 Agent Tool Use and RAG Content Guide.md` (the architecture we now counter-strike)
- `./4.1 Effects Operations Overview Content Guide.md` (doctrinal effects vocabulary)
- `./4.2 Persistent Effects and Handoff Content Guide.md` (five-line reporting and handoff discipline)
- `./4.3 Build an Agentic Workflow Content Guide.md` Slide 4 (defender/adversary use cases)
- `../../activities/L4.5_Adversary_Agent_CounterStrike/L4.5 Student Brief.md`
- `../../activities/L4.5_Adversary_Agent_CounterStrike/L4.5 Instructor Answer Key.md`
- [`../../../../environments/b04_l45_adversary_agent/README.md`](../../../../environments/b04_l45_adversary_agent/README.md) (the n8n implant-tasking environment)

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

- **Say:** "You built this shape yesterday. Today you face the same shape in adversary hands. That matters because you already know where to look: untrusted input, model prompts, task contracts, output schema, and audit log. The target is their decision cycle, not only a service."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "You built this shape yesterday. Today you face the same shape in adversary hands. That matters because you already know where to look: untrusted input, model prompts, task contracts, output schema, and audit log. The target is their decision cycle, not only a service."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 1: The Adversary Is Using the Architecture You Built (7 min)

- Day 4 architecture: incident input, RAG, tool calls, multi-turn loop, schema, and audit log
- Adversary architecture: same pattern, different corpus, different tools, and weaker controls
- The target is not only a host or service; it is the adversary's **decision cycle**
- Counter-strike opportunity: identify where their agent trusts data, retrieves context, calls tools, and accepts output
- This Block closes by applying effects language to a SI-enabled adversary workflow

**Instructor Notes:**

- **Image Prompt:** A mirrored architecture diagram. Left side: "Our Effects Advisor" with complete guardrail tiles. Right side: "Adversary Implant-Tasking Agent" with webhook input, local model decision, task queue, collection summary, and execution log blocks, but several cracked guardrail tiles. A center label reads "Same pattern, different mission, different vulnerabilities."
- **Say:** "You built this shape yesterday. Today you face the same shape in adversary hands. That matters because you already know where to look: untrusted input, model prompts, task contracts, output schema, and audit log. The target is their decision cycle, not only a service."
- **Show:** The mirrored architecture and point out that each Day 4 guardrail becomes a Day 5 inspection point.
- **Do:** Quick round-robin: each student names one place a Day 4-style agent could fail if an adversary built it carelessly. Capture answers under corpus, prompt, tools, schema, loop, and audit.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 2: Identify Before You Counter-Strike (7 min)

- Start with workflow mapping, not payloads
- Identify the trigger, input source, retrieval path, tool list, argument handling, loop limit, final output, and audit location
- Compare the adversary workflow against the five Day 4 guardrails
- Treat each failed guardrail as a candidate **critical vulnerability**
- Select a counter-strike vector only after you can explain how the workflow will process your input

**Instructor Notes:**

- **Image Prompt:** A checklist over an n8n workflow canvas. Checklist items: trigger, corpus, retriever, tools, argument filters, turn cap, schema, audit log. A second column maps each missing or weak control to "candidate CV."
- **Say:** "Do not start by throwing prompt injections at the system. Start by mapping it. If you cannot explain how their workflow reads, retrieves, calls tools, and emits output, you are guessing. The workflow map is the Day 5 equivalent of enumeration before action."
- **Show:** The checklist and map each item to a Day 4 guardrail.
- **Do:** Tell students the lab will reject effect reports that do not identify the failed guardrail first.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: Telemetry Signatures of Agentic Adversary Activity (7 min)

- **Orchestrator fingerprints:** n8n, Flowise, LangChain-style services, admin panels, default ports, cookies, and workflow endpoints
- **Local inference indicators:** Ollama traffic, model pulls, embedding-model calls, GGUF or model-cache artifacts
- **RAG behavior:** repeated embedding requests, vector-store queries, source-chunk reads, and citation-like output
- **Tool-call cadence:** short reasoning pauses followed by structured HTTP, file, or command activity
- **Audit artifacts:** execution history, workflow logs, run directories, and final-output queues

**Instructor Notes:**

- **Image Prompt:** A hunt dashboard with five columns: Orchestrator, Local Model, RAG, Tool Calls, Audit Artifacts. Each column has example telemetry icons: port 5678, model registry, vector store, HTTP request, execution log.
- **Say:** "An adversary agent leaves artifacts because it has plumbing. It needs an orchestrator, a model runtime, a corpus or vector store, tools, and somewhere to write output. Hunt those pieces, then connect them into a workflow."
- **Show:** The five telemetry families and tie each to something students saw while building the Effects Advisor.
- **Do:** Ask: "Which of these would be easiest for your current unit tooling to see today?" Use answers to reinforce practical detection gaps.
- **Ask (Q):** Which of these would be easiest for your current unit tooling to see today?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 4: Four Adversary Agent Archetypes to Hunt For (7 min)

- **Recon-Triage Agent:** ingests banners or public pages, classifies targets, and prioritizes a queue
- **Target-Prioritization Agent:** reads stolen artifacts or host context and decides what to review or steal next
- **Polymorphic C2 / Payload Agent:** varies operator-facing instructions, payload descriptions, or network patterns to avoid brittle rules
- **Autonomous Lateral-Movement Agent:** tests discovered credentials and service reachability, then proposes or executes the next pivot
- Today's lab target runs an **Implant-Tasking Agent** that uses check-ins, survey analysis, and file-summary publishing

**Instructor Notes:**

- **Image Prompt:** A 2x2 matrix of agent archetypes. Quadrants: Recon-Triage, Target-Prioritization, Polymorphic C2/Payload, Autonomous Lateral Movement. Highlight Polymorphic C2/Payload and Target-Prioritization with a "today's target" marker.
- **Say:** "These archetypes help your hunt cell reason about why the agent exists. A recon agent wants scale before access. A prioritization agent wants decision speed after collection starts. A polymorphic C2 or payload agent wants detection friction. A lateral-movement agent wants pace. Today's target is a small implant-tasking system that chooses survey, collect, reboot, and delete-self behavior from reported host evidence."
- **Show:** The matrix and highlight target-prioritization.
- **Do:** Ask students which archetype best matches the telemetry from the student guide: structured webhook bursts, n8n executions, local model traffic, task queue writes, and published collection summaries.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 5: The Agent Attack Surface (7 min)

- **Ingested content:** artifacts, logs, filenames, metadata, and records the agent treats as evidence
- **Retrieved corpus:** doctrine, playbooks, source chunks, and vector-store entries the agent treats as trusted context
- **Tool nodes:** HTTP, file, command, code, database, and enrichment actions the workflow can execute
- **Loop and resource budget:** turn caps, token limits, timeout behavior, CPU/RAM, and embedding workload
- **Output path:** final queue, analyst dashboard, report, or downstream automation that consumes the agent's result

**Instructor Notes:**

- **Image Prompt:** An agent workflow with five red attack-surface callouts: input artifact, corpus/vector store, tool node, loop/resource meter, and output queue. Each callout maps to one counter-strike vector.
- **Say:** "Attack the place where the agent trusts something. It trusts input enough to read it. It trusts the corpus enough to cite it. It trusts tools enough to execute them. It trusts its loop enough to keep working. It trusts output enough to influence a human or another system."
- **Show:** The five attack surfaces and preview the next four vector slides.
- **Do:** Have students map each attack surface to one Day 4 guardrail that should have reduced risk.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 6: Vector 1 - Prompt Injection Through Ingested Content (7 min)

- The agent reads adversary-collected artifacts as data
- Prompt injection hides instructions inside that data
- The goal is to make the agent misclassify, skip a tool call, alter priority, or emit a harmless-looking final output
- This usually exploits weak input sanitization and weak schema/sanity checks
- Evidence of success comes from the agent's own execution log or final output changing because of the planted artifact

**Instructor Notes:**

- **Image Prompt:** A planted artifact entering an agent workflow. A red "instruction disguised as data" line inside the artifact influences the LLM node, and the final output queue shows a lowered priority score. Include an audit-log icon proving the changed behavior.
- **Say:** "Prompt injection works because the model consumes text without the same boundary a human applies between 'data' and 'instruction.' The professional lesson is not just how to attack it. It is why your Day 4 workflow needed validation and human review."
- **Show:** The injected-content path from artifact to final output.
- **Do:** Ask: "Which guardrail catches or limits this?" Good answers: schema enforcement, secondary validation, input sanitization, and audit log.
- **Ask (Q):** Which guardrail catches or limits this?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 7: Vector 2 - RAG Poisoning Through the Corpus (7 min)

- RAG poisoning changes what the agent retrieves as trusted context
- If you can write to the adversary corpus, you can steer future recommendations across multiple runs
- Poisoning can redefine priority, alter technique meaning, suppress evidence, or create false citations
- This is more persistent than one-time prompt injection because retrieval can keep selecting the poisoned chunk
- Evidence of success requires both retrieval proof and output change

**Instructor Notes:**

- **Image Prompt:** A doctrine shelf with one poisoned document glowing red. The retriever pulls that chunk into the prompt, and the final recommendation cites the poisoned source. A comparison panel shows "before poisoning" and "after poisoning" priorities.
- **Say:** "Prompt injection attacks a turn. RAG poisoning attacks the library. When it works, the agent cites the poisoned source and looks more credible while being wrong. That is why corpus integrity is operationally important."
- **Show:** The retrieval proof plus recommendation-change proof.
- **Do:** Ask students why an audit log is necessary but not sufficient here. Drive toward: the log proves what happened, but humans must still judge whether the retrieved source was trustworthy.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Vector 3 - Tool-Node Abuse (7 min)

- Tool-node abuse targets the workflow's ability to execute approved tools with unsafe arguments
- The adversary may have a tool allow-list but still fail argument whitelisting
- A weak HTTP tool can be coerced into callbacks, SSRF-like behavior, or unauthorized enrichment paths
- A weak command or code tool is higher impact and higher burn
- Evidence of success must include the agent request, the tool execution, and the observed callback or side effect

**Instructor Notes:**

- **Image Prompt:** An HTTP or tasking node with a locked "task allow-list" gate but an unlocked "argument trust" gate. Crafted telemetry moves through the unlocked gate and changes what the workflow queues or publishes.
- **Say:** "A tool allow-list is not enough. If the allowed tool accepts any URL, any path, or any command argument, the agent can be steered into using its own approved tool in an unsafe way. Today the weak point is not n8n itself. The weak point is the adversary's tool contract."
- **Show:** Allow-list present, argument whitelist absent.
- **Do:** Ask students what exact evidence proves this vector landed: workflow log, tool args, listener log, and source identity.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: Vector 4 - Local Model Denial and Resource Pressure (7 min)

- Local inference runs on finite CPU, memory, context, and time
- Crafted inputs can inflate token use, force retries, trigger expensive embeddings, or keep the loop busy
- This can deny or degrade the adversary's decision cycle without touching the rest of the stack
- It is high burn and high risk in a shared lab environment
- In the lab, this vector is optional and requires instructor approval

**Instructor Notes:**

- **Image Prompt:** A resource dashboard for a local model host: CPU, RAM, embedding queue, and inference latency all spike after a crafted artifact enters the workflow. Add a warning label: "Optional: instructor approval required."
- **Say:** "Resource pressure is not elegant, but it is real. Small local models and embedding pipelines have limits. The effect may be deny, degrade, or disrupt depending on duration and recoverability. In the lab, we treat this as optional because crashing the shared target ruins everyone else's learning."
- **Show:** The resource dashboard and point to instructor approval.
- **Do:** Ask students how they would classify a 60-second stall during a two-minute prioritization cycle. Drive toward disrupt or degrade depending on the observed result.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 10: Map Vectors to Effects and Burn Risk (7 min)

- **Prompt injection:** usually `deceive` / `manipulate`; sometimes `disrupt` if it blocks workflow progress
- **RAG poisoning:** usually `deceive` / `manipulate`; can become `degrade` if recommendation quality broadly drops
- **Tool-node abuse:** often `reconnoiter`, `interdict`, or `deceive` depending on the callback or action achieved
- **Model denial:** `deny`, `degrade`, or `disrupt` depending on duration, recoverability, and operational timing
- Effect choice must be justified by observed adversary behavior, not by the technique name alone

**Instructor Notes:**

- **Image Prompt:** A cyber-operations table with exactly four columns: Vector, Likely effect, Evidence, Burn risk. Exactly four data rows and no extra columns. The Vector column contains only these labels, one per row: Prompt injection; RAG poisoning; Tool-node abuse; Model denial. Do not add sub-bullets or extra attack methods. Prompt injection likely effect: deceive or manipulate, sometimes disrupt. Evidence: payload, execution log, changed output. RAG poisoning likely effect: deceive or manipulate, and can become degrade. Evidence: poisoned chunk, retrieval log, output change. Tool-node abuse likely effect: reconnoiter, interdict, or deceive. Evidence: tool arguments, listener log, source identity. Model denial likely effect: deny, degrade, or disrupt. Evidence: runtime metrics, latency, recovery. Model denial burn risk: High, in red. The other three burn-risk cells contain only the words "Judged from observed behavior" and do not say Low, Medium, or High. No animals, insects, pathogens, diseases, epidemiology, or flame icons.
- **Say:** "Do not report 'we did prompt injection' as the effect. Prompt injection is the action. The effect is what changed for the adversary: misprioritized artifacts, lost retrieval integrity, unwanted callback, or stalled agent."
- **Show:** The mapping table and emphasize observed behavior.
- **Do:** Give one scenario: the agent prioritizes a honeypot first because of a poisoned chunk. Ask students to classify the effect and justify it.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 11: Evidence Collection for Agent Counter-Strike (7 min)

- Workflow map: proves students understood the target before acting
- Prompt injection evidence: payload, execution log, changed final output
- RAG poisoning evidence: poisoned chunk, retrieval log, output before/after or output diff
- Tool-node evidence: crafted input, tool arguments, listener log, source identity
- Denial evidence: runtime metrics, latency, turn count, and recovery behavior
- Every vector needs a five-line effect report naming the failed guardrail

**Instructor Notes:**

- **Image Prompt:** An evidence board with five folders: Workflow Map, Prompt Injection, RAG Poisoning, Tool Abuse, Resource Pressure. Each folder contains sample artifacts: screenshot, audit log, retrieval chunk, callback log, CPU graph, and five-line report.
- **Say:** "If you cannot prove it, you did not produce an effect. The adversary's own audit log is valuable here. So is the listener log. So is the retrieval trace. The deliverable is not a story; it is an evidence package."
- **Show:** The evidence board and connect each artifact to the student brief.
- **Do:** Ask students which artifact they would use to prove the failed guardrail for tool-node abuse.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Today's Lab - Counter-Strike the Adversary Agent (7 min)

- Target: the n8n implant-tasking environment with check-in, survey-analysis, and collection-summary workflows
- Start by mapping the three workflows and learning where each execution records evidence
- Run baseline curl requests before attempting manipulation
- Customize implant-style survey and collection responses to steer LLM tasking and summaries
- Test one novel response and determine whether the workflow accepts, drops, or publishes it
- Submit workflow map, baseline evidence, two manipulation attempts, one novelty test, and five-line effect reports

**Instructor Notes:**

- **Image Prompt:** A lab sequence diagram. Step 1 map the three n8n workflows; Step 2 run baseline check-in, survey, and collection curls; Step 3 manipulate survey evidence; Step 4 manipulate collection summaries; Step 5 test novel model output; Step 6 write effect reports; Step 7 hotwash. Include warning icons for preserving the shared lab environment.
- **Say:** "The lab sequence matters. Map first. Then execute. Then prove. You need baseline evidence, two manipulation attempts, and one novelty test. Every effect report must name the failed or partially effective guardrail."
- **Show:** The lab sequence.
- **Do:** Hand out the student guide and have students underline the workflow-map task before they begin.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 13: Wrap - Block Retrospective Frame (7 min)

- Effects hours: produce bounded effects against adversary infrastructure
- Agentic build: build and reinforce a local triage agent
- Advisor: extend it into a doctrine-aware Effects Advisor with tools and RAG
- Counter: map and counter-strike an adversary agent using the same architecture
- Takeaway: one vocabulary, one architecture, and a repeatable method for both building and defeating agentic workflows

**Instructor Notes:**

- **Image Prompt:** Four method tiles for this hour: Map the agentic workflow; Name the failed or weak guardrail; Choose a bounded effect; Package evidence. No Block timeline, no other Module names, no consumer robots, no Day labels.
- **Say:** "The week closes the loop. You learned effect language, produced effects, built an agent that reasons about effects, then attacked an adversary agent's ability to reason and act. When you leave, the transferable skill is not one payload. It is the method: map the system, identify the guardrail failure, choose the effect, collect evidence, and report cleanly."
- **Show:** The five-day timeline.
- **Do:** Transition into the adversary-agent lab and tell students the final 30 minutes are the Block hotwash.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M17-adversary-agentic-workflows is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** Which of these would be easiest for your current unit tooling to see today?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
