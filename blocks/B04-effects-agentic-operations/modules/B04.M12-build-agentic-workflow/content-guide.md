---
id: B04.M12
title: Build an Agentic Workflow
artifact_type: content_guide
audience: instructor
block: B04
module_type: lecture
legacy_aliases:
- legacy/week4/content-guides/4.3 Build an Agentic Workflow Content Guide.md
- B04.M23
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

# Build an Agentic Workflow — Content Guide

**Source:** `../AI Part 1 Lecture Content.md`, `../../overview.md`, `../../activities/L4.3a_Build_Agentic_Workflow/`, `../../activities/L4.3b_Agent_Reinforcement/`
**Audience:** CPT operators transitioning from manual effects operations into SI-assisted hunt and triage workflow construction.
**Duration:** ~60 minutes lecture + transition to hands-on build.
**Prerequisites:** Effects vocabulary, handoff discipline, tactical planning vocabulary, baseline threat-hunt triage, and the team DGX Spark (LiteLLM up; n8n enabled in this lab hour).
**References:**

- `../AI Part 1 Lecture Content.md` (legacy draft source)
- `../../overview.md`
- `../../activities/L4.3a_Build_Agentic_Workflow/L4.3a Student Guide.md`
- `../../activities/L4.3a_Build_Agentic_Workflow/L4.3a Instructor Setup Notes.md`
- `../../activities/L4.3b_Agent_Reinforcement/L4.3b Student Brief.md`
- `../../activities/L4.3b_Agent_Reinforcement/L4.3b Instructor Answer Key.md`
- `./4.4 Agent Tool Use and RAG Content Guide.md` (next lecture in sequence)

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

- **Say:** "This course shifts from manual effects operations into SI-assisted workflow construction. We are not treating the model as an authority. We are building a local workflow that reads evidence, applies a prompt, produces structured output, and tells us when a human needs to review the result."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "This course shifts from manual effects operations into SI-assisted workflow construction. We are not treating the model as an authority. We are building a local workflow that reads evidence, applies a prompt, produces structured output, and tells us when a human needs to review the result."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 1: Why Agentic Workflows Matter to CPTs (4 min)

- SI-assisted operations
- Evidence-first reasoning
- Structured incident output
- Human review points
- Repeatable hunt triage

**Instructor Notes:**

- **Image Prompt:** Create a professional CPT operations graphic, 16:9. Show an analyst workstation receiving syslog entries and alert artifacts on the left, a bounded local agent workflow in the center with labeled nodes for trigger, context, model, validation, and output, and a structured incident summary on the right. Use dark blue, muted green, and amber accents. Make the agent look like controlled infrastructure, not a consumer chatbot or glowing humanoid robot.
- **Say:** "This course shifts from manual effects operations into SI-assisted workflow construction. We are not treating the model as an authority. We are building a local workflow that reads evidence, applies a prompt, produces structured output, and tells us when a human needs to review the result."
- **Show:** Place this lesson in the Block arc: students first build the agentic triage pattern, then reinforce it, then extend the pattern with retrieval, tools, and adversary-agent considerations in later activities.
- **Do:** Ask students to name one hunt task that is repetitive enough to automate but still risky enough to require human review. Capture two examples for reuse during the lecture.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 2: Extending SOAR with Agentic Workflows (4 min)

- Stable rules stay deterministic
- Messy evidence needs reasoning
- LLM as one workflow node
- Validation before action
- Operator judgment remains central

**Instructor Notes:**

- **Image Prompt:** Create a clean technical comparison diagram, 16:9, titled "Extending SOAR." On the left, show a deterministic SOAR path labeled "Stable Rule Path": alert -> parse -> match -> action -> audit log. On the right, show an agentic extension path labeled "Reasoning Step": alert -> evidence bundle -> LLM reasoning node -> validation gate -> branch decision -> audit log. Use a shared human review checkpoint across both paths. Avoid implying replacement; show extension and integration.
- **Say:** "Do not hear this as 'SOAR is obsolete.' SOAR is excellent when the rule is clear and the data is stable. The agentic pattern belongs where the input is messy and the workflow needs a bounded reasoning step. The model does not replace orchestration; it becomes one controlled node inside it."
- **Show:** Walk the deterministic path first, then the reasoning path, and point out where validation gates prevent model output from becoming unchecked action.
- **Do:** Ask: "Which of these should stay deterministic: blocking a hash from a vetted feed, or summarizing an ambiguous process tree?" Have students explain the difference.
- **Ask (Q):** Which of these should stay deterministic: blocking a hash from a vetted feed, or summarizing an ambiguous process tree?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 3: Anatomy of a Local SI Agent (4 min)

- Trigger or sensor
- Context builder
- Local reasoning node
- Validator and router
- State and audit trail

**Instructor Notes:**

- **Image Prompt:** Create a left-to-right architecture diagram, 16:9, with five labeled blocks: Trigger/Sensor, Context Builder, Local LLM Reasoning Node, Validator/Router, and Audit/State Store. Add small, realistic icons for logs, JSON schema, retry loop, human review, and stored execution records. Use restrained tactical colors and clear arrows. Do not depict the LLM as autonomous, magical, or human-like; make it one bounded service node.
- **Say:** "An agent is not just a model. The model is one reasoning node. The agent is the whole loop: what evidence enters, how context is built, what the model is allowed to produce, how the workflow validates it, and what record we keep afterward."
- **Show:** Highlight the validator/router block. Tie it directly to the reinforcement lab failure modes: malformed JSON, API failures, and disagreement between branches.
- **Do:** Have students repeat the operator test: "Can I explain what evidence went in, what prompt was used, what came out, and why the workflow took the branch it took?"
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 4: Operational Use Cases in CND and Hunt (4 min)

- Alert triage
- Hunt hypothesis support
- Evidence normalization
- Confidence scoring
- Adversary workflow recognition

**Instructor Notes:**

- **Image Prompt:** Create a four-panel operational use-case graphic, 16:9. Panels should show: alert triage, hunt hypothesis support, evidence normalization, and adversary workflow recognition. Use realistic security artifacts such as logs, tickets, process trees, and JSON records. Include a small human review icon in each panel. Avoid clutter, vendor logos, and cartoon robot imagery.
- **Say:** "The common thread is not chat. The common thread is evidence transformation. We are asking the workflow to take messy evidence, make a bounded assessment, produce a machine-readable artifact, and mark uncertainty. That is useful for defenders, and it is also exactly why adversaries will use the same pattern."
- **Show:** Connect each defensive example to a course build behavior: ingest, enrich, classify, validate, branch, and export.
- **Do:** Ask: "Where is the human review point in each use case?" If students skip it, bring them back to confidence and operational risk.
- **Ask (Q):** Where is the human review point in each use case?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 5: Prompt Structure: Instructions, Evidence, and Output Contract (4 min)

- System prompt
- User prompt
- Evidence bundle
- Context window
- Output contract

**Instructor Notes:**

- **Image Prompt:** Create a layered prompt-engineering diagram, 16:9. Top layer: "System Prompt - role, boundaries, schema." Middle layer: "User Prompt - task + evidence bundle." Side box: "Context Window Budget." Bottom layer: "Assistant Output - proposed JSON." Place a validation gate after the output before any branch or action. Use clean labels, minimal text, and a visual hierarchy that makes the output contract obvious.
- **Say:** "In a workflow, prompting is engineering. The system prompt defines stable behavior. The user prompt carries the current evidence. The output contract tells the model what shape downstream automation requires. If any one of those is vague, the workflow becomes brittle."
- **Show:** The three-layer prompt structure, then point to the validation gate after the assistant output.
- **Do:** Ask students what belongs in the system prompt versus the user prompt for a syslog triage workflow. Expected distinction: durable role/schema in system; current log and API results in user.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 6: Prompt Templates Keep Logic Separate from Evidence (4 min)

- Static instructions
- Dynamic variables
- Evidence provenance
- Repeatable criteria
- Safer maintenance
- Template example

**Instructor Notes:**

- **Image Prompt:** Create a template-injection diagram, 16:9. On the left, show a prompt template document with labeled placeholders such as `{source}`, `{timestamp}`, and `{incoming_syslog_data}`. On the right, show live log records and enrichment results. In the center, show the rendered prompt with the evidence inserted and provenance retained. Use a precise engineering style, not a generic "code merging" illustration.
- **Say:** "We do not write a new prompt for every alert. We write a template. n8n injects the current log, source filename, timestamp, and enrichment results into known variables. That gives us repeatability and makes the output easier to debug."
- **Show:** The example `Analyze the following log for malicious activity: {{ incoming_syslog_data }}` and add a second notional variable such as `{{ threat_intel_result }}`.
- **Do:** Ask students which fields should be inserted automatically into every prompt for auditability: source artifact, timestamp, enrichment status, and workflow name.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Controlling the Brain: Model Parameters (4 min)

- Low temperature
- Constrained `top_k`
- Moderate `top_p`
- Capped max tokens
- Stop conditions
- Repeatable JSON

**Instructor Notes:**

- **Image Prompt:** Create a dashboard-style graphic, 16:9, showing five model controls: Temperature set low, `top_k` constrained, `top_p` moderate, Max Tokens capped, and Stop Condition enabled. Add a side label: "Operational goal: repeatable JSON, not creative prose." Use instrument-panel styling with readable labels and no decorative robot imagery.
- **Say:** "LLMs predict tokens. Parameters influence how much variation the model is allowed to introduce. For a poem, variation is useful. For an incident workflow, variation can break a parser or inflate confidence. Today we tune for boring, repeatable, short outputs."
- **Show:** The parameter controls and tie each to an operational failure mode: randomness, rambling, malformed output, or inconsistent confidence.
- **Do:** Ask students why a low-temperature model can still be wrong. Drive toward: deterministic does not mean accurate; it only means repeatable.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 8: Enforcing Output Formats (4 min)

- Chat breaks automation
- JSON enables routing
- Schema defines fields
- Format rules go up front
- Validate before branching

**Instructor Notes:**

- **Image Prompt:** Create a split-screen validation graphic, 16:9. Top half: red-tinted conversational model output beginning "Certainly..." hitting a broken automation gear. Bottom half: green-tinted valid JSON with fields such as `classification`, `confidence`, and `needs_human_review` passing through a validation gate into a branch node. Keep the JSON readable and the failure mode visually obvious.
- **Say:** "Downstream nodes do not read intent; they read fields. If the model gives a paragraph when the next node expects `classification`, `confidence`, and `summary`, the workflow is broken. Structured output is what turns language into an operational artifact."
- **Show:** A small schema with `classification`, `confidence`, `summary`, `intel_unavailable`, and `needs_human_review`.
- **Do:** Warn that local models can still drift from the schema. Validate and retry; do not skip the parser.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: Handling Format Failures (4 min)

- JSON validation
- Narrow correction prompt
- Hard retry cap
- Bounded reformat step
- Visible review flag

**Instructor Notes:**

- **Image Prompt:** Create a workflow failure-handling diagram, 16:9. Show output from an "SI Node" entering a "JSON Validator." The valid path uses a green check and proceeds to "Structured Output." The invalid path uses a red X, loops once or twice through "Correction Prompt," then exits to "Human Review Flag" after the retry cap. Include the retry cap as a visible counter, not an infinite loop.
- **Say:** "Even with good prompts, models sometimes produce invalid format. The professional answer is not hope; it is validation. Try once or twice with a narrower correction prompt, then fail gracefully with a review flag. A workflow that fails visibly is safer than one that invents a clean-looking answer."
- **Show:** The validation loop and point at the retry cap.
- **Do:** Tell students the hands-on workflow will deliberately stress these failure modes: broken JSON, enrichment failure, and conflicting branch evidence.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 10: Intro to RAG: Evidence the Model Can Reference (4 min)

- Retrieval-Augmented Generation
- Local source chunks
- Current doctrine and SOPs
- Prompt-time evidence injection
- Reviewable citations

**Instructor Notes:**

- **Image Prompt:** Create a concise RAG concept graphic, 16:9. Show a controlled document shelf with SOPs, doctrine notes, incident history, and network notes feeding a retrieval step. Retrieved chunks enter the prompt beside current incident evidence, then flow into the model and out to a cited answer. Use labels that emphasize "approved sources" and "reviewable citations."
- **Say:** "RAG is an open-book pattern. The model does not remember your local doctrine by default. The workflow searches the approved source material, retrieves the relevant chunks, and places those chunks into context. Now the model has evidence to reference."
- **Show:** Contrast model weights, which are static for our purposes, with retrieved context, which can be updated as documents change.
- **Do:** Keep this as a conceptual bridge. Students need the mental model here before the course turns retrieval into a primary build task.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 11: How RAG Works (4 min)

- Chunk source documents
- Embed semantic meaning
- Store vectors and metadata
- Retrieve closest evidence
- Inject and cite

**Instructor Notes:**

- **Image Prompt:** Create a six-step RAG process flowchart, 16:9. Step 1: doctrine and SOP files are chunked. Step 2: an embedding model converts chunks into vectors. Step 3: a vector store indexes vectors with source metadata. Step 4: an incident query retrieves closest chunks. Step 5: retrieved context and incident evidence enter the LLM. Step 6: the answer includes source references. Use compact labels and make source metadata visible throughout.
- **Say:** "The search is semantic. If an incident mentions suspicious PowerShell behavior, retrieval can find doctrine or notes that discuss command interpreters, script execution, or T1059-style behavior even when the exact words differ. That is why embeddings matter to hunt operations."
- **Show:** The full RAG flowchart, but keep the depth limited. Students only need the mental model today.
- **Do:** Ask students what can go wrong if the corpus contains stale or poisoned information. Save the answer for the later adversary-agent discussion.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Tool Calling: Let the Workflow Act, Not the Model (4 min)

- Tool request, not execution
- Approved tool list
- Clear argument schema
- Orchestrator control
- Read-only enrichment first

**Instructor Notes:**

- **Image Prompt:** Create a sequence diagram, 16:9. Step 1: agent receives task and evidence. Step 2: agent requests `lookup_ip_reputation(ip)` from the orchestrator. Step 3: orchestrator checks the approved tool list and argument schema. Step 4: orchestrator runs the API. Step 5: tool result returns to the agent. Step 6: agent generates final structured analysis. Make the orchestrator the execution boundary.
- **Say:** "Tool calling is how an agent gets new information or asks the workflow to do something. The model does not execute the tool. It emits a structured request. n8n checks the request, runs the approved tool, and returns the result."
- **Show:** The sequence diagram illustrating the pause in generation while the tool runs.
- **Do:** Emphasize that the current build uses simple enrichment and parsing patterns. Later course work expands this into controlled tool use with explicit audit expectations.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 13: Standardizing Tools: Model Context Protocol (MCP) (4 min)

- Common tool interface
- Approved context sources
- Reusable integrations
- Permission boundaries
- Audit expectations

**Instructor Notes:**

- **Image Prompt:** Create a hub-and-spoke architecture diagram, 16:9. Center node: "MCP Server / Approved Context Interface." Left side: SI harnesses and orchestrators such as local agent, n8n, and IDE assistant. Right side: approved resources such as local files, ticket system, telemetry API, and doctrine repository. Add lock, permission, and audit icons on each tool path. Keep the diagram vendor-neutral.
- **Say:** "MCP is a standardization pattern. Instead of every agent building custom glue to every tool, an MCP server exposes approved capabilities in a common way. For an operational team, that matters because context access and tool access are part of the control surface."
- **Show:** The hub-and-spoke diagram and point out that the center is not just convenience; it is where access can be described and constrained.
- **Do:** Tell students they do not need to implement MCP today. They need to recognize why standards matter when agent workflows move from lab prototype to team service.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 14: Surveying the Orchestration Landscape (4 min)

- Code-first frameworks
- Visual orchestrators
- Auditability
- Offline operation
- Credential control
- Maintainability

**Instructor Notes:**

- **Image Prompt:** Create a neutral orchestration landscape graphic, 16:9. Show two columns: "Code-First" with LangChain, LlamaIndex, CrewAI, and custom Python services; and "Visual Orchestrators" with n8n, Flowise, and LangFlow. Below both columns, show shared selection criteria: auditability, repeatability, data handling, offline operation, credential control, and maintainability. Avoid making one option look universally superior.
- **Say:** "The right tool depends on the mission and the team. A software team may want code-first control. A CPT classroom needs visibility, repeatability, and fast debugging. n8n gives us a graph that an instructor can grade and a student can explain."
- **Show:** A simple comparison: code-first for engineering depth; visual orchestration for workflow visibility and rapid operator iteration.
- **Do:** Ask students what they would need before approving either pattern in a real environment: logging, credential handling, review, backups, and failure behavior.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 15: Classroom Stack (4 min)

- Team DGX Spark
- n8n (enabled in this lab hour)
- LiteLLM local aliases
- Class CTI API
- Moodle evidence
- Visual debugging

**Instructor Notes:**

- **Image Prompt:** Create a classroom lab architecture diagram, 16:9. Show team n8n as orchestration, LiteLLM in front of local vLLM aliases, a class CTI service at cti.<domain>, Moodle log files, validation nodes, and JSON output. Boundary label: "Classroom DGX Spark." Trace log -> enrich -> local model -> validate -> output.
- **Say:** "Earlier stack setup left n8n out on purpose. This morning you add it to the team stack and create personal accounts. Inference goes through LiteLLM, never vLLM. CTI is a class service, not something you stand up per team."
- **Show:** Trace syslog from Moodle into n8n, CTI lookup, secondary then primary model, JSON out.
- **Do:** Have students name which component owns orchestration, inference, enrichment, and validation.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 16: Shared GPU, Not a Tiny VM (4 min)

- Team-shared n8n
- GPU local models
- LiteLLM aliases
- Queueing and timeouts
- Personal workflow names
- Bounded retries

**Instructor Notes:**

- **Image Prompt:** Create a technical constraints graphic, 16:9. Show several operator laptops pointing at one n8n on a DGX, LiteLLM routing to a fast local alias and a heavy local alias, plus a retry-cap badge. Keep it technical.
- **Say:** "You are not on a 16 GB CPU VM. You are on a shared Spark. GPU is faster, but concurrent class use still needs timeouts, retries, and the lighter alias for bulk extract. Name workflows with your last name so grading does not collide."
- **Show:** Secondary alias for IP extract, primary for triage, retry cap from the afternoon lab.
- **Do:** Ask what fails first if every team hits the heavy alias at once.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 17: Local Models and the Cloud Frontier (4 min)

- Local secondary: extract
- Local primary: triage
- Cloud frontier: cross-check
- Same LiteLLM gateway
- Same schema and validation
- Classroom only

**Instructor Notes:**

- **Image Prompt:** Create a three-stage model graphic, 16:9. Left: fast local alias labeled extract. Center: heavy local alias labeled triage. Right: cloud frontier model labeled cross-check. All three sit behind one LiteLLM gateway. Shared footer: prompt, evidence, schema, validation, human review. No vendor logos.
- **Say:** "Morning uses two local models through LiteLLM. Afternoon adds a cloud frontier model on the second branch. The gateway is the same; the trust boundary is not. Keep the schema, validation, and human-review flag when the model changes."
- **Show:** Extract vs triage vs frontier-branch reinforcement. CTI summaries also use a local alias on the instructor host — students only see the API.
- **Do:** Ask what must stay unchanged when the model changes. Expected: evidence boundaries, prompt structure, output schema, validation, audit, human review.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

## Lesson summary

- B04.M12-build-agentic-workflow is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.
- Later practice in this Block continues from the product this session collects.

## Questions and check on learning

- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
- **Ask (Q):** Which of these should stay deterministic: blocking a hash from a vetted feed, or summarizing an ambiguous process tree?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.
