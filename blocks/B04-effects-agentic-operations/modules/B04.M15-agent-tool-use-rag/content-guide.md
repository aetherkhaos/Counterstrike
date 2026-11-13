---
id: B04.M15
title: Agent Tool Use and RAG
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.4 Agent Tool Use and RAG Content Guide.md
- B04.M26
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

# Agent Tool Use and RAG — Content Guide

**Source:** `../../overview.md`, `../../activities/L4.4_Effects_Advisor_Agent/`
**Audience:** CPT operators who completed agentic triage build and reinforcement.
**Duration:** ~75-90 minutes (agent tool-use and RAG lecture)
**Prerequisites:** Agentic triage build, reinforcement practice, effects vocabulary, and handoff discipline.
**References:**

- `./4.3 Build an Agentic Workflow Content Guide.md` (shared agent vocabulary and Day 3 workflow baseline)
- `../../activities/L4.4_Effects_Advisor_Agent/L4.4 Student Brief.md`
- `../../activities/L4.4_Effects_Advisor_Agent/L4.4 Instructor Answer Key.md`
- `../Agentic_Operations.md` (production-grade example showing tool use + file-system actions)
- `./4.1 Effects Operations Overview Content Guide.md` and `./4.2 Persistent Effects and Handoff Content Guide.md` (effect vocabulary and handoff package shape)

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

- **Say:** "You already built a workflow that could classify and export evidence. The syslog in that workflow is the triage input. It is not what this advisor retrieves. This hour we turn that workflow into an advisor. It reads the STIX-style incident output, retrieves doctrine, calls a controlled enrichment tool, and recommends an effect in the same vocabulary as disable, deceive, reconnoiter, and handoff. It does not execute the effect. It prepares a recommendation a human can review."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What would make you trust an automated recommendation enough to brief it?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "You already built a workflow that could classify and export evidence. The syslog in that workflow is the triage input. It is not what this advisor retrieves. This hour we turn that workflow into an advisor. It reads the STIX-style incident output, retrieves doctrine, calls a controlled enrichment tool, and recommends an effect in the same vocabulary as disable, deceive, reconnoiter, and handoff. It does not execute the effect. It prepares a recommendation a human can review."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What would make you trust an automated recommendation enough to brief it?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: From Triage Agent to Effects Advisor (6 min)

- Triage agent: **ingest, enrich, classify, validate, export**
- Advisor agent: **retrieve doctrine, call controlled tools, reason over CG/CV, recommend an effect, and produce a handoff package**
- The new capabilities are **RAG**, **tool use**, **multi-turn reasoning**, and **auditability**
- The product of today's lab is an **Effects Advisor**: a recommender for humans, not an autonomous effects executor

**Instructor Notes:**

- **Image Prompt:** A three-stage evolution diagram. Stage 1 labeled "Reinforced Triage Agent" shows input logs flowing to JSON output. Stage 2 labeled "+ Doctrine Shelf (RAG)" adds a local knowledge base feeding the agent. Stage 3 labeled "+ Controlled Tools + Handoff Package" adds read-only tool icons, a guardrail gate, and a partner package output.
- **Say:** "You already built a workflow that could classify and export evidence. The syslog in that workflow is the triage input. It is not what this advisor retrieves. This hour we turn that workflow into an advisor. It reads the STIX-style incident output, retrieves doctrine, calls a controlled enrichment tool, and recommends an effect in the same vocabulary as disable, deceive, reconnoiter, and handoff. It does not execute the effect. It prepares a recommendation a human can review."
- **Show:** The three-stage evolution and point out that triage output is advisor input.
- **Do:** Ask: "What would make you trust an automated recommendation enough to brief it?" Capture answers under evidence, citations, guardrails, and audit trail.
- **Ask (Q):** What would make you trust an automated recommendation enough to brief it?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: The Effects Advisor Mission (6 min)

- Input: an incident record from reinforcement practice, including classification, confidence, enrichment status, and human-review flags
- Knowledge base: ENGAGE, D3FEND, tactical planning vocabulary, authority ceilings, partner contacts, and local SOP excerpts
- Tooling: read-only enrichment, with `intel_lookup` as the canonical example
- Output: a six-section partner handoff package with `recommended_effect`, CG, CV, justification, citations, and rollback plan
- Standard: the recommendation must be explainable from retrieved sources and logged workflow evidence

**Instructor Notes:**

- **Image Prompt:** A mission-flow graphic. Left: "STIX-style incident." Center: "Effects Advisor" with RAG, read-only tool, CG/CV reasoning, and guardrail icons. Right: "Partner Handoff Package" with sections target identity, access story, posture, tempo, tasking, rollback.
- **Say:** "The mission is not 'ask the model what to do.' The mission is to compress analyst staff work: read the incident, consult doctrine and partner context, enrich one observable, reason in CG/CV language, and produce a handoff package that a human can accept, modify, or reject."
- **Show:** The six-section output path and the specific `recommended_effect` field.
- **Do:** Have students name which skills supply each part of the mission: effect vocabulary, handoff package, incident schema, and RAG/tools.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: RAG Is Runtime Evidence, Not Model Memory (6 min)

- **Retrieval-Augmented Generation** means source chunks are retrieved and inserted into the prompt before generation
- The model weights do not change; the context changes
- RAG is best for current doctrine, unit SOPs, partner contacts, local notes, and citations
- RAG is not automatically true: stale, irrelevant, or poisoned chunks can still mislead the agent
- Operational rule: every recommendation that depends on RAG must cite the chunks it used

**Instructor Notes:**

- **Image Prompt:** Split diagram. Left side: "Model Weights" as a sealed model box labeled static. Right side: "Runtime Context" with incident evidence plus retrieved doctrine chunks feeding into the model. Add a citation tag on the output.
- **Say:** "RAG does not teach the model new facts permanently. It gives the model an open book during this run. That is powerful because the book can be local and current. It is also dangerous because a bad book produces confident bad answers."
- **Show:** Contrast static model weights with dynamic retrieved context.
- **Do:** Ask: "If the model cites a source chunk, does that make the answer correct?" Drive toward: citations make it reviewable, not automatically correct.
- **Ask (Q):** If the model cites a source chunk, does that make the answer correct?
- **Expected Response (A):** citations make it reviewable, not automatically correct

### Slide 4: The RAG Pipeline Students Build Today (6 min)

- **Corpus:** Markdown under `/lab_data/kb/`: unit effect ceilings, ENGAGE and D3FEND notes, partner contacts, and prior planning extracts
- **Chunk:** Break files into reviewable passages, preserving source path metadata
- **Embed:** Use the LiteLLM `embed` alias (`POST /v1/embeddings`) on the team Spark
- **Store:** Save vectors, chunks, and metadata in the student-provisioned Chroma container
- **Retrieve:** For each incident, return the top relevant chunks and source paths
- **Inject and cite:** Put chunks into the prompt and require citations in the final package

**Instructor Notes:**

- **Image Prompt:** A technical RAG pipeline diagram: Moodle `kb/` source folders -> paragraph-aware chunker -> LiteLLM `embed` alias -> Chroma -> retrieval query -> top-4 chunks with source paths -> local primary via LiteLLM -> cited handoff package.
- **Say:** "The corpus is the doctrine shelf under `/lab_data/kb/`: unit effect ceilings, ENGAGE and D3FEND notes, partner contacts, and prior planning extracts. Syslog is not in that shelf. This is the build sequence. Corpus, chunk, embed, store, retrieve, inject, cite. If students skip chunking and embed whole files, retrieval quality drops. If they lose source metadata, citations become useless. Every stage has to preserve reviewability."
- **Show:** The pipeline and point at source metadata moving with each chunk.
- **Do:** Ask students why a 500-token paragraph-aware chunk is usually better than one giant file or one sentence at a time.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 5: Corpus Design: What Belongs on the Doctrine Shelf (6 min)

- ENGAGE and D3FEND excerpts supply effect and defensive-technique context
- Tactical planning extracts supply CG/CV and exploitation-plan language
- Authority-ceiling and unit SOP excerpts bound recommendations to the lab mission
- Partner contact notes tell the agent who can receive which handoff package
- Bad corpus design creates bad recommendations even when the agent loop is technically correct

**Instructor Notes:**

- **Image Prompt:** A shelf graphic with five labeled binders: ENGAGE, D3FEND, Tactical Planning, Authority Ceilings / SOPs, Partner Contacts. Each binder has a source-path tag and feeds into an Effects Advisor workflow.
- **Say:** "The corpus is not a dumping ground. It is the advisor's reference shelf. If you add irrelevant documents, stale partner contacts, or doctrine with no source labels, you make the model harder to audit."
- **Show:** The five corpus categories and tie each to a required field in the final output.
- **Do:** Ask: "Which corpus source would help the agent avoid recommending an effect against a friendly mirrored system?" Expected answer: partner contacts and local context.
- **Ask (Q):** Which corpus source would help the agent avoid recommending an effect against a friendly mirrored system?
- **Expected Response (A):** partner contacts and local context

### Slide 6: Retrieval Quality and Citation Discipline (6 min)

- Retrieval quality depends on chunk size, source metadata, query wording, and top-N selection
- A good retrieval result is relevant, reviewable, and specific enough to support a decision
- Citations must include source path and a useful excerpt, not just "the model said so"
- Retrieved chunks can change the recommended effect; students must identify at least one case where that happens
- If retrieval does not change or constrain reasoning, the RAG layer is decorative

**Instructor Notes:**

- **Image Prompt:** A comparison graphic. Left: poor retrieval shows a giant vague chunk with no source path and a red warning. Right: good retrieval shows four short chunks with paths, excerpts, and relevance labels feeding into a recommendation.
- **Say:** "The point of RAG is not to make the prompt longer. The point is to add decision-useful evidence. If the retrieved chunks do not change the recommendation, constrain it, or support it with citations, then the agent is just doing free-text guessing with extra steps."
- **Show:** Poor vs good retrieval examples.
- **Do:** Have students name one field in the final handoff package that should be directly supported by a retrieved citation.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Tool Use: The Agent Requests, the Workflow Decides (6 min)

- Tool use lets the agent request external information during the run
- The LLM emits a structured request; n8n validates and executes the approved node
- Today's canonical tool is `intel_lookup` with argument shape `{"ip": "<ipv4>"}`
- Tools for this lab are **read-only enrichment**; the advisor recommends effects but does not execute them
- Every tool request, rejection, and result must be logged

**Instructor Notes:**

- **Image Prompt:** A sequence diagram. Incident enters LLM; LLM emits `{"tool":"intel_lookup","args":{"ip":"198.51.100.157"}}`; guardrail gate checks tool name and IP range; HTTP Request node runs class CTI; JSON result returns to the LLM context; audit log records each step.
- **Say:** "The model asks; the workflow decides. That distinction matters. If the model asks for a tool that is not approved, the workflow refuses. If the argument is malformed or out of range, the workflow refuses. Tool use is only safe when the orchestration layer is in charge."
- **Show:** The sequence diagram and linger on the guardrail gate.
- **Do:** Ask students why the Day 4 advisor is limited to read-only tools. Tie the answer back to human review and recommendation-only posture.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Tool Contracts and Argument Whitelists (6 min)

- A tool contract names the tool, purpose, allowed arguments, output shape, and failure behavior
- Tool allow-list: the agent can only request declared tools
- Argument whitelist: each tool accepts only pre-approved values or ranges
- For `intel_lookup`, allowed targets are well-formed IPv4 addresses in approved private or lab ranges
- A rejected tool call is a success if it protects the workflow and is logged clearly

**Instructor Notes:**

- **Image Prompt:** A tool contract card for `intel_lookup`: name, description, args, allowed CIDRs, response fields, reject conditions, audit fields. Beside it, show a rejected public-IP request with a red "logged refusal" stamp.
- **Say:** "A tool without a contract is an invitation to misuse. The contract tells the model what the tool is for, but more importantly it tells the workflow what to accept and what to reject."
- **Show:** The `intel_lookup` contract and an example of a rejected out-of-range request.
- **Do:** Ask: "What should the workflow do if the agent asks to call `http_fetch` instead of `intel_lookup`?" Expected answer: reject, log, and continue or fail gracefully according to policy.
- **Ask (Q):** What should the workflow do if the agent asks to call `http_fetch` instead of `intel_lookup`?
- **Expected Response (A):** reject, log, and continue or fail gracefully according to policy

### Slide 9: Multi-Turn Reasoning Under a Turn Cap (6 min)

- Day 3 mostly produced one-turn answers
- Day 4 uses a bounded loop: retrieve, reason, call a tool, reason again, finalize
- ReAct pattern: the agent alternates between reasoning and requesting actions
- Turn cap is a hard control: today's maximum is 5
- A mature workflow has deterministic failure behavior when the cap is reached

**Instructor Notes:**

- **Image Prompt:** A loop diagram with five numbered turn slots. Turn 1 retrieval, Turn 2 tool call, Turn 3 retrieval, Turn 4 final draft, Turn 5 final or fail. A red guardrail counter labeled "hard cap = 5" sits on the loop.
- **Say:** "Multi-turn reasoning is where agents become useful and where they become dangerous. A confused agent will keep asking the same question forever unless the workflow stops it. The cap is not a suggestion. It is part of the safety case."
- **Show:** The five-turn loop and explain what an acceptable run looks like.
- **Do:** Ask students what the final output should say if the cap is reached without a recommendation. Drive toward unresolved/human-review fallback, not silent failure.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 10: The Five Guardrails for Fieldable Advisors (6 min)

- **Tool allow-list:** refuse unknown tools
- **Argument whitelist:** refuse malformed or out-of-policy arguments
- **Max-turns cap:** prevent runaway loops and resource exhaustion
- **Output schema enforcement:** validate the handoff package before accepting it
- **Audit log:** record prompts, responses, retrievals, tool calls, refusals, retries, and final result
- These guardrails are also tomorrow's adversary-agent attack checklist

**Instructor Notes:**

- **Image Prompt:** A five-tile checklist titled "Fieldable Agent Guardrails." Each tile has an icon: tool list, argument filter, turn counter, JSON schema, audit log. No footer, no today/tomorrow text, no lab names, no Module IDs.
- **Say:** "These five are the difference between a demo and something you can brief. They are also the bridge to tomorrow. On Day 5, you will look for an adversary agent that failed one or more of these controls."
- **Show:** The five guardrails and explicitly connect each to a possible failure.
- **Do:** Tell students today's grading checks guardrails as strictly as recommendation quality.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 11: Audit Logs Are Operational Evidence (6 min)

- Audit logs show what the agent saw, requested, retrieved, refused, retried, and emitted
- Logs let instructors grade the reasoning path, not only the final answer
- Logs let operators explain why a recommendation changed after retrieval or enrichment
- Error paths must log too; success-only logs hide the most important behavior
- For this advisor build, each incident run must export an audit log alongside the final handoff package

**Instructor Notes:**

- **Image Prompt:** An audit-log viewer graphic with timestamped rows: `turn_start`, `llm_prompt_hash`, `retrieve`, `tool_call`, `tool_reject`, `schema_valid`, `final`. A reviewer icon highlights one retrieval row and one rejected tool-call row.
- **Say:** "The final JSON tells you what the agent recommended. The audit log tells you whether you should trust how it got there. That log is the run record. It is not a file you embed in the vector store. A fluent answer with no audit trail is not operationally useful."
- **Show:** Example audit events and tie them to the advisor-lab deliverables.
- **Do:** Ask students which audit event would prove that retrieval changed an effect recommendation.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Reasoning in CG/CV and Effect Vocabulary (6 min)

- The advisor must identify the adversary **center of gravity** in the incident context
- It must name the **critical vulnerability** that makes an effect feasible
- It must choose exactly one effects-vocabulary category where an effect is warranted
- It must justify why that effect fits the evidence better than near alternatives
- The recommendation should preserve human decision authority: advisor proposes, operator decides

**Instructor Notes:**

- **Image Prompt:** A reasoning ladder. Bottom rung: incident evidence. Next: retrieved doctrine and partner context. Next: CG and CV. Next: candidate effects. Top: recommended effect with citations and rollback plan.
- **Say:** "The model is not allowed to invent a tenth effect category. It must reason inside the vocabulary you learned: deny, degrade, disrupt, destroy, deceive, manipulate, reconnoiter, interdict, handoff. That discipline is what makes the output comparable across teams."
- **Show:** The reasoning ladder and point to where citations support CG/CV.
- **Do:** Give a quick example: if evidence is ambiguous and `needs_human_review` is true, ask why `reconnoiter` may be stronger than `deny`.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 13: Final Product: Partner Handoff Package (6 min)

- The output is a structured package, not a chat answer
- Required sections: target identity, access story, current posture, adversary tempo, partner tasking, rollback plan
- `partner_tasking` carries the recommended effect, CG, CV, justification, and citations
- Schema validation confirms the package is complete and machine-readable
- A good package lets a partner act without rediscovering the environment

**Instructor Notes:**

- **Image Prompt:** A JSON handoff package rendered as a clean document with six labeled sections. The `partner_tasking` section is highlighted and expands to show `recommended_effect`, `justification`, `cg`, `cv`, and `citations`.
- **Say:** "The Effects Advisor is valuable only if the output can move. A partner should be able to read the package, understand the target, see the evidence, know the recommended effect, and understand rollback. That is why schema matters."
- **Show:** The six sections and tie them back to the handoff package.
- **Do:** Ask students which section would fail first if the agent had no partner-contact corpus.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 14: Lab Flow and Day 5 Bridge (6 min)

- Index the doctrine shelf under `/lab_data/kb/`: unit effect ceilings, ENGAGE and D3FEND notes, partner contacts, and prior planning extracts
- Build retrieval and `intel_lookup` (class CTI) tool paths in n8n
- Build the bounded ReAct loop with all five guardrails
- Validate on three reinforced-incident outputs plus one instructor-provided incident
- Export the handoff package, the audit log of the run, workflow JSON, the embedding script, and the guardrail cheatsheet
- Next lab: map and counter-strike an adversary agent built on the same pattern

**Instructor Notes:**

- **Image Prompt:** Dual-use guardrail graphic. Build lane: Index corpus → retrieve → tool call → recommend effect → audit package. Inspection lane: the same five controls (tool list, argument filter, turn cap, schema, audit) as the surface an operator inspects. Caption: "Controls you implement are also the inspection surface." No today/tomorrow, no Day labels, no Module IDs.
- **Say:** "Index the doctrine shelf. Keep the audit log as the record of the run. Today you build the architecture well. Tomorrow you hunt for where the adversary built it badly. The corpus, tools, loop, schema, and audit log you implement today become your target-analysis checklist tomorrow."
- **Show:** The Day 4-to-Day 5 roadmap.
- **Do:** Release to the Effects Advisor lab and remind students that the guardrail cheatsheet is not paperwork; it is the field guide for later adversary-agent work.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M15-agent-tool-use-rag is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What would make you trust an automated recommendation enough to brief it?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** If the model cites a source chunk, does that make the answer correct?
- **Expected Response (A):** citations make it reviewable, not automatically correct
