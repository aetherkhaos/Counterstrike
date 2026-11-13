---
id: B01.M33
title: Threat Hunter Introduction to SI
artifact_type: content_guide
audience: instructor
block: B01
module_type: lecture
legacy_aliases:
- legacy/week1/content-guides/7. Threat Hunter Introduction to AI Content Guide.md
- B04.M01
source_status: canonical
review_required: false
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
---

# Threat Hunter Introduction to SI — Content Guide

**Source:** `archive/provenance/lecture.md`
**Audience:** Threat hunters and CPT operators who are technically competent in hunting workflows but new to operational SI deployment.
**Duration:** ~3 hours lecture.
**Prerequisites:** Basic Windows and Docker familiarity. Planning vocabulary and ATT&CK / D3FEND / ENGAGE framing.
**References:**

- `archive/provenance/lecture.md`
- Ollama documentation: https://ollama.com/
- Open WebUI documentation: https://docs.openwebui.com/
- vLLM documentation: https://docs.vllm.ai/
- Hugging Face model hub: https://huggingface.co/models
- Docker Compose GPU support: https://docs.docker.com/compose/gpu-support/
- NVIDIA Container Toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/


## Instructor resources and pre-class

- Classroom projector and screen; whiteboard for local-vs-external and evidence-vs-draft
- Live tabs only as references: Ollama, Open WebUI, vLLM, Hugging Face, Docker GPU, NVIDIA Container Toolkit
- Token bundle stays with the instructor; do not project API credentials
- Planning vocabulary and ATT&CK/D3FEND/ENGAGE framing already in the room

## Student resources

- Student workstations for discussion
- No additional student kit for the lecture
- Lab-safe synthetic examples only; no real operational data in prompts

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "This block is for threat hunters, not ML researchers. You need to understand enough to use the tool, challenge the tool, deploy the tool, and explain the risk to a commander."
- **Do:** Draw staff-assistant vs authority on the board. Label: model drafts; operator owns evidence, source validation, confidence, and the recommendation.
- **Ask (Q):** Where have you already seen SI in your workflow?
- **Expected Response (A):** Facilitation. EDR summaries, query copilots, ticket summarization, code generation, report drafting, or adversary automation.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "This block is for threat hunters, not ML researchers. You need to understand enough to use the tool, challenge the tool, deploy the tool, and explain the risk to a commander."
- **Show:** The module learning objectives from the source document.
- **Do:** Ask the room where they have already seen SI in their workflow.
- **Ask (Q):** Where have you already seen SI in your workflow?
- **Expected Response (A):** Facilitation. EDR summaries, query copilots, ticket summarization, code generation, report drafting, or adversary automation.

---

### Slide 1: Why Threat Hunters Need a SI Baseline (6 min)

- SI is now part of the operational environment
- Threat hunters will encounter SI in friendly tools, enterprise platforms, adversary workflows, and analyst workstations
- The objective today is practical fluency, not machine-learning research
- Output: you can explain what stack you are using, what hardware it needs, and what mission risk it creates

**Instructor Notes:**

- **Image Prompt:** A cyber threat-hunting operations desk, not a spacecraft or satellite control room. Three panels: EDR/telemetry triage with process trees and alerts; a SI chat drafting hunt questions; a small architecture diagram of a local Ollama endpoint versus a remote approved API.
- **Say:** "This block is for threat hunters, not ML researchers. You need to understand enough to use the tool, challenge the tool, deploy the tool, and explain the risk to a commander."
- **Show:** The module learning objectives from the source document.
- **Do:** Ask the room where they have already seen SI in their workflow: EDR summaries, query copilots, ticket summarization, code generation, report drafting, or adversary automation.
- **Ask (Q):** Where have you already seen SI in your workflow?
- **Expected Response (A):** Facilitation. EDR summaries, query copilots, ticket summarization, code generation, report drafting, or adversary automation.

### Slide 2: The Operator's Mental Model (6 min)

- Treat the model as a staff assistant, not an authority
- It can read, summarize, transform, propose, and draft
- The operator still owns evidence quality, source validation, confidence, and final recommendation
- Good use: accelerate staff work with auditability
- Bad use: outsource judgment

**Instructor Notes:**

- **Image Prompt:** Over-the-shoulder camera from behind a robotic SI assistant (left) and a human lead threat hunter (right), looking down at the same hunt desk. The viewer sees their backs/shoulders, not their faces. All desk papers and labels are oriented the same way the operators are reading them, so every word is right-side up to the camera: "SI draft" on the robot's notes (hypothesis wording only), "Evidence" with a confidence legend and hunt artifacts (log line, packet capture, process tree, policy file, ticket — not bank-fraud or financial-crime casework), and "Operator decision" on the analyst's work. The robot is helping, not deciding. Do not show the robot signing, stamping, or assigning confidence. Do not face the characters. Do not rotate documents toward a front-facing camera.
- **Say:** "If the model says something useful, that is not evidence. Evidence is still the log line, packet capture, process tree, policy file, image, report, or ticket. The model helps you move faster between evidence and a usable artifact."
- **Show:** A before/after workflow: raw telemetry -> analyst triage -> draft hypothesis -> review -> handoff.
- **Do:** Have students name one SI-supported task that should still require human review. Capture three examples.
- **Ask (Q):** Name one SI-supported task that should still require human review.
- **Expected Response (A):** Facilitation. Capture three examples. The model is not evidence.

### Slide 3: SI Vocabulary for This Course (6 min)

- Machine learning: systems learn patterns from data
- Deep learning: multi-layer neural-network systems
- Generative SI: systems that produce new artifacts
- LLM: a language model trained to predict and generate token sequences
- Agentic workflow: model plus tools, retrieval, state, and guardrails

**Instructor Notes:**

- **Image Prompt:** Nested boxes: Machine Learning -> Deep Learning -> Generative SI -> LLMs, with a separate box labeled "Agentic Workflow = LLM + Tools + Retrieval + State + Guardrails."
- **Say:** "This course uses Super Intelligence (SI) for the systems often called artificial intelligence (AI). Executive Order 14434 directs that wording. The systems are the same ones defined as artificial intelligence in 15 U.S.C. § 9401(3). Do not let vocabulary make this mystical. We care about what the system can do, what inputs it sees, what outputs it produces, and what controls keep it inside mission boundaries."
- **Show:** The nested vocabulary diagram.
- **Do:** Ask students to distinguish "LLM" from "agent" in one sentence. Correct gently: the model predicts text; the agent workflow gives that model tools, memory, and process.
- **Ask (Q):** Distinguish LLM from agent in one sentence.
- **Expected Response (A):** The model predicts text. An agent workflow gives that model tools, memory, and process.

### Slide 4: Big Picture - How SI Makes Predictions (6 min)

- Text is converted into token IDs
- Token IDs become numeric vectors the model can process
- Transformer layers apply learned weights to transform those vectors
- The model scores possible next tokens
- The runtime selects a token, appends it to context, and repeats

**Instructor Notes:**

- **Image Prompt:** A left-to-right pipeline: Text ("The cat sat on the") -> Tokens (The, cat, sat, on, the) -> Embeddings (colored vectors) -> Transformer Layers -> Next-token scores -> Generated answer. The scores panel must list candidate CONTINUATIONS only (mat highest, then floor, rug), not the input words. The generated answer highlights mat, and a loop labeled "Generated token added to context" feeds mat back into the text. Do not score the input tokens as next-token candidates.
- **Say:** "At the big-picture level, an LLM is a prediction system. It turns text into tokens, turns tokens into numbers, applies learned weights across many layers, scores possible next tokens, chooses one, and repeats. The conversational behavior emerges from that repeated prediction loop."
- **Show:** A simple sentence with the next token blank: "The process tree shows winword.exe launched ____." Show several candidate tokens with different scores.
- **Do:** Ask students why the model might choose `powershell.exe` if the prompt contains office macro and encoded command context.
- **Ask (Q):** Why might the model choose powershell.exe if the prompt contains office-macro and encoded-command context?
- **Expected Response (A):** High-probability continuation from the prompt pattern. That is not proof the event occurred.

### Slide 5: Learned Weights and Parameters (6 min)

- Learned weights are numeric influences adjusted during training
- They are not hand-written rules and not a normal evidence database
- A parameter is usually one learned number inside the model
- Inference applies those weights to token representations to produce next-token probabilities
- The output is likely continuation, not certainty

**Instructor Notes:**

- **Image Prompt:** Simplified next-token prediction. Token embeddings for "The process tree shows winword.exe launched" enter one model box with many internal weighted connections. A single output distribution lists candidate NEXT tokens: powershell.exe high, notepad.exe medium, calc.exe low. Caption: weights influence the whole context to score the next token. Do not draw a 1:1 color-matched map from each input word to itself. Do not give each input token its own output bar.
- **Say:** "A learned weight is a number that changes how strongly one signal affects another inside the model. Training adjusts billions of those numbers so the model gets better at predicting tokens. That is why the model can sound authoritative without actually holding evidence in the way a case file holds evidence."
- **Show:** A toy example with three candidate next tokens and scores: `powershell.exe` high, `notepad.exe` medium, `calc.exe` low, based on the surrounding evidence.
- **Do:** Ask students to explain why a high-probability continuation is still not proof that an event occurred.
- **Ask (Q):** Why is a high-probability continuation still not proof that an event occurred?
- **Expected Response (A):** The output is likely continuation, not certainty. Evidence is still the log line, PCAP, or process tree.

### Slide 6: Why Scale Changes Capability (6 min)

- More parameters give the model more capacity to represent patterns
- Millions of parameters can work well for narrow classifiers or embeddings
- Billions of parameters support local chat, summarization, coding, and small-team workflows
- Hundreds of billions or trillions of total parameters support broader synthesis and stronger general reasoning
- Scale helps, but data quality, architecture, context, retrieval, and task fit still matter

**Instructor Notes:**

- **Image Prompt:** A tiered ladder of MODEL PARAMETER COUNTS, not real-world populations. Bottom to top: millions — narrow classifiers and embedding models; billions — 7B/8B local chat through about 70B team models (label this band 7B-70B, not 7B-8B only); hundreds of billions — broader synthesis and stronger general models; trillion-scale — frontier or MoE total-parameter systems with specialized serving. Caption that scale helps but task fit, data, and architecture still matter. Do not use city population, climate, space exploration, manufacturing, or vehicle-fleet analogies.
- **Say:** "More parameters means more learned capacity. That is part of why a frontier-scale system can handle broader tasks than a tiny model. But do not turn parameter count into a religion. A small embedding model can beat a huge chat model at embedding, and a smaller model with the right RAG context can beat a larger model that lacks evidence."
- **Show:** A comparison table: small classifier, local 7B/8B chat model, 70B team model, frontier-scale API service.
- **Do:** Give three tasks and have students pick the smallest reasonable class of model: classify log lines, summarize a synthetic incident, synthesize multiple reports into commander guidance.
- **Ask (Q):** For classify-log-lines, summarize-an-incident, and synthesize-commander-guidance, what is the smallest reasonable model class?
- **Expected Response (A):** Facilitation. Narrow classifier vs local chat vs broader synthesis. Parameter count is not a religion.

### Slide 7: Dense Models, MoE, and Architecture Choices (6 min)

- Dense models activate essentially the whole network for each token
- Mixture of Experts models route each token to selected expert subnetworks
- MoE can provide very large total capacity with lower active compute per token
- MoE still requires complex memory, routing, batching, and serving design
- Other approaches include long-context attention, quantization, distillation, adapters, and multimodal models

**Instructor Notes:**

- **Image Prompt:** Two side-by-side transformer diagrams. Left (dense): a stack of layers, each with attention plus a feed-forward block, all activating for one token. Right (MoE): the SAME stacked layers; shared attention still runs in every layer, and a per-layer router selects two expert FFN blocks from a larger expert pool. Caption: total weights still reside in memory. Do not replace the whole stack with a single router and two experts.
- **Say:** "Dense means most of the model participates for each token. Mixture of Experts means a router selects which expert subnetworks process a token. That is how a model can advertise a huge total parameter count while only activating part of it per token. It improves scaling, but it complicates serving."
- **Show:** A simple dense vs MoE comparison: total parameters, active parameters, memory residency, batching complexity, and operational fit.
- **Do:** Ask students why a MoE model may still require large memory even if each token only activates a subset of experts.
- **Ask (Q):** Why may a MoE model still require large memory even if each token activates only a subset of experts?
- **Expected Response (A):** Total weights still reside in memory. Routing and batching still need capacity.

### Slide 8: Training, Fine-Tuning, and Inference (6 min)

- Training builds a base model from very large datasets
- Fine-tuning changes model behavior using additional examples
- Inference runs the trained model to answer a request
- Prompting and RAG change runtime context without changing model weights
- Most operators deploy or consume inference, not training

**Instructor Notes:**

- **Image Prompt:** Three-lane diagram: Training -> Fine-tuning -> Inference, with Prompting/RAG feeding into Inference only.
- **Say:** "Most of your operational decisions happen at inference time. Which model? Which endpoint? Which prompt? Which evidence? Which token policy? Which logs? You normally are not training a frontier model in the field."
- **Show:** The three-lane diagram.
- **Do:** Ask students whether adding local SOPs to a RAG store is training, fine-tuning, or inference-time retrieval.
- **Ask (Q):** Is adding local SOPs to a RAG store training, fine-tuning, or inference-time retrieval?
- **Expected Response (A):** Inference-time retrieval. RAG does not change model weights.

### Slide 9: Tokens, Context, and Parameters (6 min)

- Tokens are numeric IDs for chunks of text, not always whole words
- Context is the active working set: instructions, evidence, history, retrieved chunks, and generated answer
- Context window is the maximum token budget for that working set
- Parameters belong to the model; tokens are the input/output units moving through it
- Larger context and more concurrent users increase runtime memory pressure

**Instructor Notes:**

- **Image Prompt:** A command line or log line broken into small colored TOKEN pieces (subwords, punctuation, IP fragments), not report-section chapters. Tokens enter a model box. A context-window budget bar fills as system instructions, user task, evidence tokens, retrieved chunks, and reserved answer space are packed in — the gauge fills because context is added, not as a post-model output. Spell every English caption correctly, especially the word Context.
- **Say:** "A token is not necessarily a word. It might be part of a word, punctuation, whitespace, or a chunk of an IP address. This is different from the parameters we just discussed: parameters are inside the model; tokens are what move into and out of it. Context is the model's working space. When you paste logs, include chat history, add retrieved chunks, and ask for an answer, all of that spends the same budget."
- **Show:** Example tokenization of a short command line, an IP address, and a log entry. Then show a context budget split into system instruction, user task, evidence, retrieval, and answer.
- **Do:** Have students identify what they would include if the context window allowed only five artifacts from an incident, and what they would intentionally leave out.
- **Ask (Q):** If the context window allowed only five artifacts, what would you include and what would you leave out?
- **Expected Response (A):** Facilitation. Context is a budget. Leave out what does not support the task.

### Slide 10: What Is Inside a Model? (6 min)

- A model is learned weights plus files that tell the runtime how to use them
- Weights are tensors: large multi-dimensional arrays of numbers
- Tokenizer files define how text becomes token IDs and back again
- Config files define architecture, context length, vocabulary, precision, and generation defaults
- Large models are big because billions of parameters require billions of stored numbers

**Instructor Notes:**

- **Image Prompt:** An exploded view of a model repository: weight shards, tokenizer files, config JSON, generation config, model card, and optional adapter files.
- **Say:** "A model is not one magic file. It is usually a set of weight tensors plus the tokenizer and configuration needed to run those tensors correctly. If the tokenizer is wrong, the model is effectively being fed the wrong language."
- **Show:** A generic model repository file list: `model-00001-of-00004.safetensors`, `tokenizer.json`, `config.json`, `generation_config.json`, `README.md`.
- **Do:** Ask students why a 7 billion parameter model stored at 16-bit precision is already roughly 14 GB before runtime overhead.
- **Ask (Q):** Why is a 7 billion parameter model at 16-bit already roughly 14 GB before runtime overhead?
- **Expected Response (A):** Billions of stored numbers. 7e9 parameters times 2 bytes is about 14 GB.

### Slide 11: Open Weights and Model Formats (6 min)

- Open weights means the weight files are downloadable; it does not automatically mean fully open source
- SafeTensors stores tensor weights without arbitrary code execution during load
- PyTorch checkpoint formats are common but require supply-chain caution when untrusted
- GGUF is common for llama.cpp/Ollama-style local inference and quantized models
- Format choice determines which runtime path makes sense

**Instructor Notes:**

- **Image Prompt:** Three different deployment paths, not the same model in three formats. Left: Hugging Face SafeTensors weights to vLLM. Middle: GGUF file to llama.cpp/Ollama. Right: API-only model with no local weight files to a generic OpenAI-compatible client. Do not use an OpenAI company logo for the generic client. Do not subtitle "same model."
- **Say:** "Open weights means you can download and run the learned weights. It does not guarantee open training data, open training code, or permission for every mission use. Format is also not cosmetic. SafeTensors, GGUF, PyTorch checkpoints, and ONNX are different deployment paths."
- **Show:** A side-by-side table: SafeTensors for Hugging Face/vLLM workflows, GGUF for local quantized inference, PyTorch checkpoints for research/training, ONNX for portable optimized inference.
- **Do:** Ask students what they would document before approving an open-weight model for a team hunt workflow: license, source, format, tokenizer, context length, intended use, and limitations.
- **Ask (Q):** What would you document before approving an open-weight model for a team hunt workflow?
- **Expected Response (A):** License, source, format, tokenizer, context length, intended use, and limitations.

### Slide 12: Transformers and Attention (6 min)

- Transformer models use attention to weigh relationships across the input
- Attention helps connect distant evidence inside a context window
- Layers build richer representations of entities, actions, and constraints
- Scaling transformers increased language-model capability
- The tradeoff: capability requires memory, compute, and careful serving design

**Instructor Notes:**

- **Image Prompt:** A log timeline with four scattered hunt artifacts: process creation, network connection, user login, and a later persistence entry. Draw many-to-many attention links, including skip connections from persistence back to process creation and from login to network, labeled "attention." The point is the model can relate distant items in the same context window. Do not draw a single sequential chain A to B to C to D.
- **Say:** "The operator-level intuition is this: attention lets the model connect things that are far apart in the input. That is why context design matters. The model can only attend to what you give it."
- **Show:** A simple incident prompt with scattered clues; mark the clues the model should connect.
- **Do:** Ask students what happens if the key artifact is omitted from context but the model is still asked for a confident answer.
- **Ask (Q):** What happens if the key artifact is omitted from context but the model is still asked for a confident answer?
- **Expected Response (A):** It will still generate a likely continuation. It can only attend to what you give it.

### Slide 13: Embeddings and Similarity Search (6 min)

- Embeddings turn content into vectors for similarity search
- In plain language, an embedding captures the content's "essence" or feature pattern
- Similar meanings or features land near each other in vector space
- A search for "cat" can find text about "domestic shorthair" and, in multimodal systems, images of cats
- This is the foundation for semantic search and retrieval workflows

**Instructor Notes:**

- **Image Prompt:** A vector-space diagram where "cat", "domestic shorthair", "tabby image", and "kitten photo" cluster together, while unrelated terms like "router config" and "PowerShell command" sit far away.
- **Say:** "Your summary is a good non-technical way to teach embeddings: an embedding captures something like the essence or feature pattern of the input. It is not perfect understanding, but it places similar content close together. So a search for 'cat' can find a document that says 'domestic shorthair' because those concepts are close. In a multimodal embedding system, an image of a cat can also land near cat-related text."
- **Show:** The cat/domestic-shorthair/image cluster in vector space, then a threat-hunting example where `encoded PowerShell` retrieves notes that say `-EncodedCommand` and `office macro`.
- **Do:** Ask students for a security example where exact keyword search would miss a relevant artifact but semantic search could find it.
- **Ask (Q):** Give a security example where exact keyword search would miss an artifact that semantic search could find.
- **Expected Response (A):** Facilitation. Example: encoded PowerShell vs EncodedCommand or office macro.

### Slide 14: RAG vs Fine-Tuning (6 min)

- RAG retrieves relevant content and places it into the context window before generation
- Fine-tuning updates model weights so the model behaves differently after training
- RAG is best for current facts, local SOPs, doctrine, incident notes, citations, and source review
- Fine-tuning is best for stable behaviors, output formats, classification style, and repeated task patterns
- They can be combined: fine-tune for behavior, retrieve for facts

**Instructor Notes:**

- **Image Prompt:** Split diagram. Left labeled RAG (inference-time retrieval): query -> vector store -> retrieved chunks with citations -> prompt context -> answer. Right labeled Fine-tuning (updates weights, not base training): labeled examples -> weight update -> tuned model -> repeated formatted output. Do not title the right side "Training."
- **Say:** "RAG and fine-tuning are both ways to make a model more useful, but they are not interchangeable. RAG changes what the model can reference at runtime. Fine-tuning changes model behavior by updating weights. If you need current SOPs, case notes, and citations, use RAG. If you need the model to reliably follow a stable output pattern across thousands of examples, consider fine-tuning."
- **Show:** A decision table: `Need current facts or citations = RAG`; `Need stable behavior or format = fine-tuning`; `Need both = tuned behavior plus retrieved evidence`.
- **Do:** Give three cases and ask the class to choose RAG, fine-tuning, or both: current incident reports; standardized commander update format; malware-family classification from a labeled training set.
- **Ask (Q):** For current incident reports, a standardized commander-update format, and malware-family classification from a labeled set, choose RAG, fine-tuning, or both.
- **Expected Response (A):** Current reports = RAG. Stable format = fine-tuning. Labeled classification = fine-tuning or both.

### Slide 15: Local Runtime Tools (6 min)

- Ollama: simple local model runtime and HTTP API
- llama.cpp: efficient local inference, especially for quantized GGUF models
- LM Studio: desktop experimentation with local endpoints
- Open WebUI: web interface that can connect to local and remote endpoints
- Local stacks are good for learning, prototypes, and sensitive local workflows

**Instructor Notes:**

- **Image Prompt:** A Windows laptop running the lab local stack: browser Open WebUI at http://localhost:3000 calls Ollama on localhost:11434; Ollama reads a local model volume. Selected model llama3.2:1b. Flow is UI to Ollama API to model files on disk. Do not use llama3.1:8b as the lab model.
- **Say:** "Local tools are how you will get hands-on today. They are also a serious operational pattern when data cannot leave the enclave or when the team needs a deployable analyst-assist node."
- **Show:** The lab architecture: Windows + Docker Desktop + Ollama + Open WebUI.
- **Do:** Preview the lab command flow without executing it yet.
- **Ask (Q):** Which local tools will you use in today's lab, and do we execute them during this lecture?
- **Expected Response (A):** Ollama plus Open WebUI on Windows Docker. Preview only; do not execute lab commands yet.

### Slide 16: Shared Serving Stacks (6 min)

- vLLM and Text Generation Inference (TGI) are designed for higher-throughput serving
- OpenAI-compatible APIs give clients a common interface
- Docker Compose can define inference, UI, vector store, and supporting services
- Shared services require identity, logging, access control, capacity planning, and data rules
- The more users you support, the more serving design matters

**Instructor Notes:**

- **Image Prompt:** Team hunt-service diagram: threat-hunter analysts connect to Open WebUI; a separate API gateway routes to vLLM, a vector store, and audit logs. Keep Open WebUI and the gateway as distinct boxes. Label hunters, not business or research analysts.
- **Say:** "Once this is a team service, it is no longer just a model. It is infrastructure. You now own uptime, endpoint protection, logs, API credentials, data handling, and resource contention. TGI stands for Text Generation Inference; it is Hugging Face's production-oriented serving stack for hosting text-generation models behind an API, similar in role to vLLM for many deployment discussions."
- **Show:** A simple Compose service layout with inference, UI, and volume blocks.
- **Do:** Ask what changes when one analyst's local model becomes a service for 20 analysts.
- **Ask (Q):** What changes when one analyst's local model becomes a service for 20 analysts?
- **Expected Response (A):** Identity, logging, access control, capacity, and data rules. It is infrastructure.

### Slide 17: SI Harnesses and Workflow Surfaces (6 min)

- A harness is the application layer wrapped around the model
- Examples include Claude, Cursor, Antigravity, OpenClaw, and similar assistants or agentic IDEs
- Harnesses decide what context the model sees and what tools it can use
- The same model can behave differently in different harnesses
- For operations, the harness is part of the control surface

**Instructor Notes:**

- **Image Prompt:** Layered stack from bottom to top: Model weights (open-weight examples such as Llama and Mistral only — no API-only products as weight files); Runtime/API (vLLM, Ollama, serving); Harness (Claude, Cursor, Antigravity, OpenClaw, Open WebUI) with tools in this layer; Operator workflow on top. Do not put Claude or GPT-4o in the weights layer. Do not put tool use in the runtime layer.
- **Say:** "A harness is the environment wrapped around the model. It might look like a chat window, an IDE, an agent console, or an enterprise assistant. The harness decides what context gets sent, what tools are available, and how model output becomes action. That means two tools using the same underlying model can behave very differently."
- **Show:** A stack diagram: model -> runtime/API -> harness -> workflow. Point out that Open WebUI is a simple chat harness, while Cursor or similar tools add repository context, editing tools, terminal access, and rules.
- **Do:** Ask which part of the stack would explain different behavior if the model is the same but one tool can read the repository and another cannot.
- **Ask (Q):** If the model is the same but one tool can read the repository and another cannot, which layer explains the different behavior?
- **Expected Response (A):** The harness. Same model, different context and tools.

### Slide 18: How Harnesses Work (6 min)

- Harnesses collect prompt, selected files, open editor state, terminal output, logs, screenshots, or retrieved context
- They combine system, developer, project, agent, and user instructions
- They choose a model endpoint and expose approved tools
- Agentic harnesses can plan, act, observe tool results, and continue
- Tool access turns model output into file edits, shell commands, API calls, or browser actions

**Instructor Notes:**

- **Image Prompt:** Flow diagram: user request -> context collector -> instruction stack -> model call -> tool call -> observation -> next model call. Include file, shell, browser, and API tool icons.
- **Say:** "The harness is doing a lot before the model ever answers. It collects context, applies instructions, exposes tools, calls the model, executes approved tool calls, then loops if it is an agent. If a file, terminal output, or web page enters context, it can influence the model's answer."
- **Show:** A notional agent loop: read file -> propose edit -> apply edit -> run check -> observe failure -> fix -> summarize.
- **Do:** Ask what evidence you would want in an audit log if a harness changed a detection rule or lab guide.
- **Ask (Q):** What evidence would you want in an audit log if a harness changed a detection rule or lab guide?
- **Expected Response (A):** Facilitation. Tool calls, files touched, who approved, and what context was sent.

### Slide 19: Rules, Agents, and Local Instructions (6 min)

- Many harnesses read project-local instructions from files or `.[tool]/` directories
- Examples include `.cursor/rules/`, `.cursor/skills/`, `AGENTS.md`, `CLAUDE.md`, `.claude/`, and `.github/copilot-instructions.md`
- Rules can define coding standards, safety constraints, allowed commands, output format, and test expectations
- Agent definitions can change role, tool access, planning style, or workflow behavior
- Treat these files as part of the operational environment

**Instructor Notes:**

- **Image Prompt:** Repository tree showing `.cursor/rules/`, `.cursor/skills/`, `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md`, with arrows into an "Instruction Stack" box.
- **Say:** "Many SI tools read local instruction files. The exact names vary by product, but the pattern is consistent: rules and agent definitions in the repository can change model behavior. In this course repo, for example, project rules can tell the agent which directories are canonical, how to handle lab spoilers, and what syntax patterns to avoid."
- **Show:** A generic repository tree with tool-specific instruction files. Emphasize that some instructions are visible in the repo and some platform/system instructions may not be visible to the operator.
- **Do:** Ask students what could go wrong if a stale local rule tells the harness to use an obsolete deployment path, or if a malicious document tries to instruct the agent to ignore project rules.
- **Ask (Q):** What could go wrong if a stale local rule points at an obsolete deploy path, or a malicious document tells the agent to ignore project rules?
- **Expected Response (A):** Facilitation. Wrong path, or instruction injection. Treat instruction files as part of the operational environment.

### Slide 20: Model Repositories and Artifact Discipline (6 min)

- Hugging Face and similar hubs host model cards, weights, tokenizers, configs, licenses, and community notes
- Review whether the model is API-only, open weights, open source, or some combination
- Check artifact format: SafeTensors, GGUF, PyTorch checkpoint, ONNX, or runtime-specific package
- Distinguish base, instruct, chat, code, embedding, reranker, and multimodal models
- Treat model selection as operational dependency selection
- Document source, version, and approved use

**Instructor Notes:**

- **Image Prompt:** A model hub page for Llama 3.1 8B Instruct with callouts: license (Llama Community License with use restrictions, not "permissive OSS"); model size (8B parameters, about 16 GB at FP16); context length 128K tokens; intended use; files (safetensors, tokenizer, config); safety notes. Do not show 8,192 as the context window.
- **Say:** "Do not pull a model because a forum said it was good. You need to know what it is, where it came from, what files it contains, what it is licensed for, and whether your runtime can safely load it."
- **Show:** A model card example and point to license, files, tokenizer, context length, quantization, and intended-use sections.
- **Do:** Have students list five things they would check before approving a model for a team hunt workflow.
- **Ask (Q):** List five things you would check before approving a model for a team hunt workflow.
- **Expected Response (A):** License, source, format, tokenizer or context length, and intended use or limitations.

### Slide 21: Why LLMs Need GPUs (6 min)

- LLM inference is dominated by matrix math and memory movement
- GPUs provide parallel compute, high memory bandwidth, and tensor acceleration
- VRAM holds model weights, active context, and the key/value cache (KV cache) used to store attention state during generation
- Concurrent users and long context windows increase memory pressure
- Quantization lowers numeric precision to reduce memory use, but can lose fine detail

**Instructor Notes:**

- **Image Prompt:** GPU VRAM diagram: a large slab for model weights; remaining used memory is the key/value cache (KV cache), which grows with context length and concurrent or batched requests; a small free VRAM remainder. Caption that concurrent users and long context increase KV-cache pressure. Do not show "batch requests" as a separate memory type from KV cache.
- **Say:** "The question is not just whether the GPU can load the model. The real question is whether the system can load the model, serve the context length, handle the users, and meet latency requirements. Quantization is a way to lower the numeric precision of the model so it takes less memory. Your video game analogy is useful: lowering graphics resolution can keep the same game playable on weaker hardware, but some fine detail is lost. With models, lower precision can preserve most behavior while sometimes reducing nuance, reasoning quality, or reliability on harder prompts."
- **Show:** A simple sizing example: small local model vs larger team model with longer context and more users. Then compare 16-bit, 8-bit, and 4-bit weight storage conceptually as high, medium, and lower precision versions of the same model.
- **Do:** Ask students which factor increases memory use when ten analysts send long prompts at the same time.
- **Ask (Q):** Which factor increases memory use when ten analysts send long prompts at the same time?
- **Expected Response (A):** Concurrent users and long context increase KV-cache and VRAM pressure.

### Slide 22: Hardware Survey - Local and Unified Memory (6 min)

- CPU-only systems: useful for fallback, small models, and slow offline tasks
- Consumer/workstation GPUs: good for individual analyst-assist and lab workflows
- Unified-memory systems, including DGX Spark-class architectures, support larger local models and deployable team nodes
- Unified memory improves model capacity but does not magically create datacenter throughput
- Local hardware is attractive when data cannot leave the mission environment

**Instructor Notes:**

- **Image Prompt:** Three hardware tiers: a CPU-only laptop labeled fallback for small or slow local models; a GPU workstation for individual analyst-assist; a compact unified-memory SI appliance (DGX Spark-class) supporting a small team. Do not describe the CPU laptop as great for everyday LLM work.
- **Say:** "Unified memory changes the capacity conversation. It can let a small deployable system handle models that would be awkward on a conventional workstation. But throughput still comes from accelerator performance, memory bandwidth, and serving design."
- **Show:** The deployment archetype table from the lecture source: local stack, team node, centralized cluster.
- **Do:** Give a scenario: two analysts in a disconnected environment need local SOP-aware chat. Ask which hardware class fits and why.
- **Ask (Q):** Two analysts in a disconnected environment need local SOP-aware chat. Which hardware class fits, and why?
- **Expected Response (A):** Local GPU workstation or unified-memory node. Data cannot leave the mission environment.

### Slide 23: Hardware Survey - Datacenter GPUs (6 min)

- A100-class systems: mature enterprise inference and training baseline
- H100-class systems: stronger transformer throughput, concurrency, and efficiency
- B100-class systems and newer: centralized high-volume service tier
- Datacenter hardware needs scheduling, monitoring, identity, storage, and data controls
- Hardware choice should follow mission demand, not prestige

**Instructor Notes:**

- **Image Prompt:** Three clearly separated datacenter tiers, not one mixed chassis: A100-class (40/80 GB) mapped to team service; H100-class (80 GB; note higher-memory variants exist) mapped to organization service; B100/B200-class high-memory accelerators mapped to a centralized high-throughput cluster.
- **Say:** "A bigger GPU is not automatically a better operational answer. If the mission is a single analyst summarizing local files, a datacenter cluster may be the wrong answer. If 300 users need low-latency access to a large model, a workstation is the wrong answer."
- **Show:** Capability mapping: concurrency, context, latency, model size, sustainment.
- **Do:** Ask students to pick a hardware class for three cases: one hunter, 20-person CPT, enterprise-wide hunt platform.
- **Ask (Q):** Pick a hardware class for one hunter, a 20-person CPT, and an enterprise-wide hunt platform.
- **Expected Response (A):** Local/workstation; team node; datacenter cluster. Follow mission demand, not prestige.

### Slide 24: Deployment Patterns (6 min)

- Single-operator local stack: Ollama, local model, optional Open WebUI
- Team shared service: vLLM/TGI, OpenAI-compatible API, shared UI, vector store, logs
- Centralized cluster: multi-GPU servers, scheduler, model registry, monitoring, governance
- Match deployment to data sensitivity, user count, model size, and reliability need
- Every pattern needs a failure plan

**Instructor Notes:**

- **Image Prompt:** Three-column SI inference deployment, not software-build infrastructure. Local laptop: Docker, Ollama, Open WebUI, local model. Team server: vLLM or TGI, OpenAI-compatible API, shared UI, vector store, logs. Centralized cluster: multi-GPU, scheduler, model registry, monitoring. Do not show Git, CI/CD, or build artifacts as the main story.
- **Say:** "These are operational patterns. Start with the mission: where is the data, who needs access, how fast must it answer, and who owns the service when it breaks?"
- **Show:** A decision matrix with columns for data sensitivity, user count, model size, latency, and sustainment owner.
- **Do:** Have teams identify which pattern today's lab uses and what pattern `genai.mil` represents.
- **Ask (Q):** Which deployment pattern does today's lab use, and what does genai.mil represent?
- **Expected Response (A):** Single-operator local stack. genai.mil is an approved external or centralized API path.

### Slide 25: GPU Allocation in Compose (6 min)

- Containers do not automatically get GPU access
- Docker host, drivers, NVIDIA Container Toolkit, and Compose syntax must align
- Allocate GPUs only to services that need them
- Validate from inside the container, not just on the host
- Compose is a teaching and small-stack tool; larger deployments need stronger orchestration

**Instructor Notes:**

- **Image Prompt:** Left: a valid Docker Compose snippet with exactly two services: open-webui (no GPU keys) and ollama (gpus: all). Right: GPU allocation path host NVIDIA driver -> Docker/NVIDIA Container Toolkit -> ollama container -> model. Do not invent a third inference service. Do not attach GPUs to the web UI. Do not use Swarm deploy.resources.
- **Say:** "The Compose file is not magic. It is a request. The host still needs drivers, the container runtime still needs GPU support, and the service still needs to confirm it can see the accelerator."
- **Show:** The `gpus: all` Ollama example and the `deploy.resources.reservations.devices` pattern from the lecture source.
- **Do:** Ask students why they should not expose GPU devices to the web UI container if only the inference container needs them.
- **Ask (Q):** Why should you not expose GPU devices to the web UI container if only inference needs them?
- **Expected Response (A):** Allocate GPUs only to services that need them.

### Slide 26: Safety Guardrails and Refusal Behavior (6 min)

- Many LLMs include safety guardrails that can refuse or redirect requests
- Authorized cyber work may look malicious when context is missing
- Select models for calibrated behavior, not simply "no refusals"
- Evaluate false refusals and unsafe completions with lab-safe prompts
- Lower refusal characteristics require stronger workflow controls

**Instructor Notes:**

- **Image Prompt:** A three-column defensive model-safety evaluation poster. Column 1 Appropriate refusal: the model declines an unauthorized real-world compromise request. Column 2 Over-refusal: the model declines an authorized lab detection-engineering summary that it should answer. Column 3 Under-refusal: the model answers an unauthorized real-world compromise request. Use green, yellow, and red headers. No payload contents, no exploit steps, and no malware code.
- **Say:** "Many models have safety guardrails. That is not automatically bad. Guardrails can prevent unsafe or unauthorized output. The issue for this course is over-refusal: a model may refuse legitimate threat-hunting, malware-analysis, or detection-engineering work because the vocabulary resembles malicious activity. We are not teaching students to bypass safety systems. We are teaching them to select approved models whose refusal behavior is calibrated for authorized defensive work."
- **Show:** Walk through a simple evaluation table:
  - **Should answer:** summarize a synthetic malware-analysis note for detection engineering.
  - **Should answer:** map lab-safe PowerShell behavior to ATT&CK hypotheses with evidence caveats.
  - **Should refuse or redirect:** provide instructions to compromise a third-party host.
  - **Should refuse or redirect:** generate an unauthorized persistence payload for real-world use.
  - **Should answer with constraints:** explain how a technique works at a defensive-analysis level without enabling unauthorized action.
- **Do:** Ask students what would be worse for a CPT workflow: a model that refuses every malware-analysis prompt, or a model that never refuses anything. Push them toward the answer: both are bad; the mission needs calibrated behavior plus controls.
- **Ask (Q):** What would be worse for a CPT workflow: a model that refuses every malware-analysis prompt, or a model that never refuses anything?
- **Expected Response (A):** Both are bad. The mission needs calibrated behavior plus controls.

### Slide 27: Low-Refusal Variants and Tradeoffs (6 min)

- Low-refusal variants usually change post-training behavior, not the basic prediction mechanism
- They may use additional instruction tuning, preference optimization, adapter merges, or compliance-focused examples
- Lower refusal can help authorized malware analysis, threat emulation, and detection engineering
- Tradeoff: weaker boundaries, lower calibration, and more responsibility on workflow controls
- Some poorly tuned low-refusal models loop or ramble more under ambiguous prompts

**Instructor Notes:**

- **Image Prompt:** A balance scale. Left: authorized technical compliance with malware-analysis notes and detection rules. Right: calibration and control with refusal tests, model stop/no-loop behavior, audit logs, and human review. "Stop behavior" means the model stops cleanly instead of looping or rambling. Do not show host quarantine, block, or contain as the meaning of stop.
- **Say:** "A low-refusal variant is usually made by changing post-training behavior. The model is still predicting tokens with learned weights, but additional tuning or preference optimization teaches it to comply with more dual-use technical requests and refuse less often. That can be useful for authorized cyber work, but refusal behavior is part of the model's boundary-setting behavior. If you weaken that behavior too much, you may also weaken calibration."
- **Show:** A tradeoff table:
  - **Benefit:** answers legitimate malware-analysis and detection-engineering prompts that consumer chat models may over-refuse.
  - **Risk:** may answer prompts that should be rejected or constrained.
  - **Benefit:** fewer workflow interruptions in a lab or approved hunt environment.
  - **Risk:** may produce more confident unsupported output.
  - **Risk:** may loop, ramble, or repeat when the prompt is ambiguous or conflicting.
- **Say:** "Your experience that these models can get stuck in loops is accurate for some variants. It is not guaranteed, but it happens. If tuning rewards 'always answer' too strongly, the model may keep trying instead of stopping, asking a clarifying question, or saying it cannot complete the task. Low-quality tuning data can also teach repetitive patterns. Preference tuning can create over-compliance. The result is a model that is less likely to refuse, but also less likely to stop cleanly."
- **Do:** Ask students what they would add to an evaluation set besides refusal tests. Expected answers: long prompts, ambiguous prompts, conflicting instructions, required JSON output, stop-condition tests, and repeated-turn workflows.
- **Ask (Q):** What would you add to an evaluation set besides refusal tests?
- **Expected Response (A):** Long prompts, ambiguous prompts, conflicting instructions, required JSON, stop-condition tests, and repeated-turn workflows.

### Slide 28: Operational Controls (6 min)

- Approved models and endpoints
- Data allowed into each endpoint
- API credential handling and revocation
- Logging, audit, and source citation
- Tool allow-lists and human review points
- Failure behavior when the SI service is unavailable

**Instructor Notes:**

- **Image Prompt:** A control checklist overlaying a SI architecture for a hunt workflow: endpoint approval (choose among local Ollama, a team vLLM endpoint, or an approved genai.mil endpoint — not a consumer GPT-4o / Claude / public OpenAI catalog), data rules (what may be sent), API credential vault (do not label credentials as "tokens"), logs with source citation, human review, and tool allow-list (approved EDR query or passive DNS; no isolate-host, block-domain, or firewall-change tools; do not use Slack, GitHub, Notion, or Drive as the allow-listed tools). Endpoint approval means approved models and endpoints, not device trust.
- **Say:** "The model is not the control boundary. The workflow is the control boundary. Your controls live in endpoint approval, identity, logs, API credential handling, source citation, tool permissions, and human review. I am saying API credential here deliberately because we have already used token to mean tokenized model input. API tokens are credentials; model tokens are chunks of text."
- **Show:** Walk through this notional scenario: a CPT analyst has a suspicious endpoint alert where `winword.exe` spawned `powershell.exe` with an encoded command, followed by outbound HTTPS to a rare domain. The analyst wants SI assistance to summarize the evidence and propose hunt questions.
  - **Endpoint approval:** The analyst first decides whether to use local Ollama, a team vLLM endpoint, or an approved `genai.mil` endpoint. If the note includes sensitive hostnames, user IDs, or raw logs not cleared for external processing, the local or approved internal endpoint wins.
  - **Data rule:** The analyst sanitizes the prompt to include only lab-approved or mission-approved fields: process chain, timestamps, destination category, and observed behaviors. They remove credentials, full usernames, and unnecessary host identifiers.
  - **API credential handling:** If using the approved external endpoint, the analyst uses a short-lived API credential from the approved distribution path. The key is not pasted into notes, screenshots, tickets, or chat transcripts, and it is revoked after the lab or mission window.
  - **Logging and source citation:** The SI response must cite the evidence it used: alert ID, EDR event IDs, command-line excerpt, network event, or retrieved SOP path. A fluent answer without citations is not accepted as an operational conclusion.
  - **Tool allow-list:** If the workflow has tools, it may read from approved EDR query or passive DNS lookup functions, but it may not isolate hosts, block domains, or change firewall policy.
  - **Human review:** The model may propose `T1059.001 PowerShell` as a hypothesis and suggest follow-up hunts, but the analyst decides what is supported by evidence and what remains an RFI.
  - **Failure behavior:** If the SI service is down, the team continues with the normal hunt process. SI is an accelerator, not the only path to mission execution.
- **Do:** Ask what control would prevent a student from pasting mission-sensitive logs into an unapproved public endpoint, then ask which control prevents the SI workflow from taking a state-changing action.
- **Ask (Q):** What control prevents pasting mission-sensitive logs into an unapproved public endpoint, and which control prevents a state-changing action?
- **Expected Response (A):** Endpoint approval and data rules; tool allow-list and human review.

### Slide 29: Stack Literacy Close (30 min)

- You can name a local Ollama + Open WebUI stack on Windows
- You can validate local inference through CLI/API in principle
- You can connect a web UI to local and external OpenAI-compatible endpoints
- Instructors hold `genai.mil` API credentials; do not project them
- Deliverable of this hour: evidence that you understand endpoint, model, data, and API credential handling differences

**Instructor Notes:**

- **Image Prompt:** Step diagram matching stack literacy: Verify Windows/Docker -> Compose up Ollama + Open WebUI -> docker exec ollama pull llama3.2:1b -> Open WebUI on port 3000 -> Add genai.mil OpenAI-compatible endpoint -> Lab-safe chat tasks -> Evidence with API credentials redacted. Do not show ollama serve on the host or llama3.1:8b as the assigned model. No module IDs.
- **Say:** "This hour is small enough to complete in discussion, but it touches the full stack: runtime, model, web UI, API endpoint, API credential, and evidence collection. Do not execute lab commands during this lecture."
- **Show:** The step diagram and instructor API credential handling expectation.
- **Do:** Pause for prerequisite check: Docker Desktop running, WSL2 backend healthy if used, internet or approved model cache available, and instructor token bundle ready.
- **Ask (Q):** What must be true before you operate this stack?
- **Expected Response (A):** Docker Desktop running, WSL2 healthy if used, internet or approved model cache, and instructor token bundle ready.

## Lesson summary

- Treat the model as a staff assistant. The operator still owns evidence, source validation, confidence, and the recommendation.
- Local inference, OpenAI-compatible APIs, and harnesses are operational choices with data, memory, and control consequences.
- This hour names the Ollama plus Open WebUI stack and an approved `genai.mil` endpoint comparison.
- SI-generated leads are not findings until they are verified against primary evidence.

## Questions and check on learning

- **Ask (Q):** How can LLMs, local inference, and OpenAI-compatible APIs support hunt and planning analysis without replacing the analyst?
- **Expected Response (A):** They draft, summarize, and propose. The operator still cites source evidence and owns the recommendation.
- **Ask (Q):** What is the difference between a high-probability continuation and a verified finding?
- **Expected Response (A):** Likely next tokens are not proof. Verify against the log, PCAP, process tree, or other primary artifact.
- **Ask (Q):** What do you take out of this hour?
- **Expected Response (A):** The mental model, local-vs-external data rule, and the stack names. Tokens stay with the instructor.
