# Threat Hunter Introduction to AI

This module introduces AI as an operational capability for technically competent threat hunters. The goal is not to turn analysts into machine-learning researchers. The goal is to give operators enough architectural understanding to decide when AI helps, when it creates risk, what infrastructure it requires, and how to deploy it in a way that supports mission execution.

## Purpose

By the end of this block, students should be able to explain what an LLM is, how transformer-based systems process language, why GPU resources matter, and how local and remote inference stacks can support threat hunting workflows. Students should also be able to reason about which hardware class fits a given operational demand: a single analyst workstation, a small team service, or a centralized high-throughput inference environment.

## Learning Objectives

Students will be able to:

1. Explain the difference between training, fine-tuning, and inference.
2. Describe tokens, context windows, embeddings, parameters, quantization, and retrieval-augmented generation in operational language.
3. Explain what a model artifact contains, what "open weights" means, and why model files are so large.
4. Distinguish common model and tensor formats such as SafeTensors, PyTorch checkpoint files, GGUF, and ONNX.
5. Explain why transformer models use attention and why that architecture changed language-model capability.
6. Compare local runtimes and serving stacks such as Ollama, vLLM, OpenAI-compatible APIs, Open WebUI, and Docker Compose.
7. Explain what AI harnesses are and how rules, agent definitions, tools, and project instructions shape their behavior.
8. Identify common model repository workflows, including how Hugging Face is used to discover, evaluate, download, and track model artifacts.
9. Explain why LLM inference benefits from GPUs and how VRAM, memory bandwidth, tensor cores, and batching affect throughput.
10. Compare workstation, unified-memory, and datacenter GPU systems, including DGX Spark-class systems and NVIDIA A100, H100, and B100-class accelerators.
11. Select a deployment pattern that fits a mission: local analyst assist, team-shared service, or centralized inference cluster.

## Operational Framing

Threat hunters already perform work that looks like structured reasoning under uncertainty:

- summarize noisy telemetry;
- compare activity against known adversary behavior;
- translate evidence into hypotheses and RFIs;
- generate detection ideas and hunting questions;
- draft reports, handoff notes, and commander-readable summaries.

LLMs can accelerate parts of that workflow, but they do not replace the operator's judgment. The operator still owns evidence quality, source validation, hypothesis discipline, and final recommendations. Treat the model as a staff assistant that can read, summarize, transform, and propose, not as an authority.

## What "AI" Means in This Course

AI is a broad term. In this course, the practical focus is on systems that can process natural language, code, logs, and structured security data to support operator workflows.

Important categories:

- **Machine learning:** Systems that learn statistical patterns from data rather than following only hand-written rules.
- **Deep learning:** Machine learning using multi-layer neural networks.
- **Generative AI:** Models that generate text, code, images, audio, or other artifacts from learned patterns.
- **Large language models:** Generative models trained to predict and generate token sequences at large scale.
- **Agentic workflows:** LLM-centered workflows that can call tools, retrieve knowledge, maintain state, and produce structured outputs under guardrails.

For Week 1, the most important question is operational: what can this capability do for a threat hunter, and what infrastructure and controls are required before using it in a mission workflow?

## Big-Picture Mechanics: From Text to Prediction

At a high level, a language model is a prediction machine. It receives tokens, uses learned weights to transform those tokens through many layers, and produces a probability distribution over possible next tokens.

The flow looks like this:

1. **Text becomes tokens.** The tokenizer converts text into token IDs.
2. **Tokens become vectors.** Each token ID maps to an embedding: a numeric representation the model can process.
3. **Layers transform the vectors.** The model applies learned weights across many transformer layers. Each layer changes the representation based on token relationships, learned patterns, and attention.
4. **The model scores possible next tokens.** The final layer produces logits: raw scores for every token in the vocabulary.
5. **The runtime chooses output tokens.** Sampling settings such as temperature, top-p, top-k, and stop tokens influence which token is selected.
6. **The loop repeats.** Each generated token becomes part of the context for the next prediction.

This is why LLMs can feel conversational even though the basic operation is next-token prediction. The model repeatedly predicts the next token while conditioning on the prompt, prior conversation, retrieved context, and its own generated output.

## What Learned Weights Mean

Learned weights are numeric values adjusted during training. They are not hand-written rules and they are not a normal database. They are coefficients inside tensors that determine how strongly signals influence one another as tokens pass through the model.

During training, the model sees examples and tries to predict missing or next tokens. When its prediction is wrong, the training process calculates the error and adjusts the weights so that future predictions become slightly better. Repeating this process at massive scale produces weights that encode statistical relationships between language, code, facts, reasoning patterns, formats, and behaviors observed in the training data.

Operationally:

- A weight is a learned numeric influence, not an explicit fact.
- A parameter is usually one of those learned numbers.
- Billions of parameters mean billions of learned influences.
- The model applies those influences to token representations every time it runs inference.
- The output is a probability distribution, not certainty.

For a threat hunter, this matters because model output can look authoritative even when it is only the most likely continuation under the prompt and model weights. The answer still needs evidence.

## Why Larger Models Often Perform Better

Model scale matters because parameters provide capacity. A model with millions of parameters has less room to represent complex relationships than a model with billions, hundreds of billions, or trillions of parameters. Larger models can often represent more language patterns, code patterns, factual associations, instruction-following behavior, and multi-step reasoning structure.

The comparison is not magic:

- **Millions of parameters:** Useful for narrow tasks, classifiers, embeddings, small edge models, and constrained inference.
- **Billions of parameters:** Useful for local chat, summarization, coding support, and small-team workflows when paired with good prompts and RAG.
- **Hundreds of billions of parameters:** Better general capability, stronger instruction following, broader world and code knowledge, and more reliable synthesis across varied tasks.
- **Trillions of parameters or very large total-parameter systems:** Usually used in frontier or enterprise-scale systems, often with specialized serving infrastructure and architecture choices such as mixture of experts.

Scale is only one factor. Data quality, architecture, training method, context length, alignment, tool access, retrieval quality, and deployment configuration can matter as much as raw parameter count. A smaller model specialized for embeddings, malware strings, or log classification can outperform a much larger general chat model on that narrow task.

The operational takeaway: choose the smallest model that satisfies the mission requirement, but understand that harder general reasoning and broader synthesis usually benefit from larger models and stronger hardware.

## Dense Models, Mixture of Experts, and Other Approaches

Not all large models use the same architecture.

**Dense models** activate essentially the whole model for each token. If the model has 70 billion parameters, inference uses that dense network for every token. Dense models are straightforward to reason about operationally, but large dense models are expensive to serve.

**Mixture of Experts (MoE)** models contain many expert subnetworks and a routing mechanism. For each token, the router activates only a subset of experts. This allows a model to have a very large total parameter count while using a smaller active parameter count per token.

MoE advantages:

- more total capacity without paying full dense compute on every token;
- stronger specialization across different kinds of inputs;
- better scaling for very large models when serving infrastructure supports it.

MoE tradeoffs:

- all or many experts may still need to be resident in memory;
- routing and batching are more complex;
- utilization can be uneven if the router favors some experts;
- deployment can be harder than a comparable dense model.

Other important approaches:

- **Grouped-query and multi-query attention:** Reduce memory pressure for attention and the key/value cache (KV cache), the runtime memory that stores prior attention state so the model does not recompute the full context for every generated token.
- **Long-context methods:** Extend usable context through positional encoding changes, attention optimizations, sliding windows, or retrieval.
- **Quantization:** Reduces weight precision to make models smaller and faster, with possible quality tradeoffs.
- **Distillation:** Trains a smaller model to imitate behavior from a larger one.
- **Adapters and LoRA:** Add small task-specific weight updates without storing or retraining a full model.
- **Multimodal models:** Process text plus images, audio, video, or other modalities.

These choices explain why parameter count alone is not enough to compare models. A 200-billion-parameter MoE model may not have the same serving cost as a 200-billion-parameter dense model. A smaller dense model with strong RAG may beat a larger model that lacks the right evidence.

## How LLMs Work at a Practical Level

An LLM receives text, converts it into tokens, runs those tokens through a neural network, and predicts likely next tokens. Repeated prediction produces a response.

Key terms:

- **Token:** A chunk of text used by the model. A token may be a word, part of a word, punctuation, or whitespace.
- **Context window:** The maximum amount of text the model can consider in one request. Larger context allows more evidence in a prompt, but costs more memory and compute.
- **Parameters:** Learned numeric weights inside the model. More parameters can increase capability, but also increase compute and memory requirements.
- **Inference:** Running a trained model to produce an answer.
- **Training:** Building the base model by learning from very large datasets.
- **Fine-tuning:** Updating a trained model with additional examples to change behavior for a narrower use case.
- **Prompting:** Providing instructions and evidence at inference time without changing model weights.
- **Embeddings:** Numeric representations of text used for similarity search, clustering, and retrieval.
- **RAG:** Retrieval-augmented generation. The system searches a knowledge base first, then gives retrieved evidence to the model before asking it to answer.

For operators, the practical distinction is simple: training and fine-tuning change model weights; prompting and RAG change what evidence and instructions the model sees at runtime.

## Tokens, Context, and Context Windows

A model does not read text the way a person reads text. It sees a sequence of tokens. Tokens are numeric IDs that point to chunks of text in the model's tokenizer vocabulary.

Examples:

- `PowerShell` may be one token in some tokenizers and multiple tokens in others.
- `-EncodedCommand` may split into punctuation, word fragments, and casing-specific pieces.
- An IP address such as `203.0.113.77` may split into several tokens.
- Whitespace, punctuation, and line breaks can consume tokens too.

The **context window** is the maximum number of tokens the model can consider in one request. That request usually includes system instructions, developer/tool instructions, user prompt text, retrieved evidence, conversation history, and the answer being generated. If the model supports a 32,000-token context window, that does not mean the operator should paste 32,000 tokens of raw evidence without thought. The context budget must be spent deliberately.

Operational implications:

- Long prompts cost more memory and compute.
- Long conversation history consumes space that could have held fresh evidence.
- The model can only reason over content inside the active context window.
- If the critical artifact is not included or retrieved, the model may still produce a confident but unsupported answer.
- Larger context windows increase KV cache demand, especially under concurrent use.

Context design is an analyst task. A good prompt package separates:

- mission or task instruction;
- known evidence;
- constraints and assumptions;
- requested output format;
- citations or source requirements;
- explicit uncertainty handling.

## How Context Relates to RAG

RAG exists because context windows are finite and operational knowledge bases are large. Instead of pasting every SOP, detection note, incident report, or doctrine extract into the prompt, the system retrieves the most relevant chunks first and places only those chunks into context.

A typical RAG flow:

1. The user asks a question.
2. The system embeds the question as a vector.
3. The vector database searches for similar embedded chunks.
4. The top chunks are inserted into the model context with source metadata.
5. The model answers using the retrieved chunks and cites the sources.

RAG improves operational usefulness when it:

- retrieves the right evidence;
- includes source paths or document IDs;
- keeps chunks small enough to fit in context but large enough to preserve meaning;
- separates retrieved evidence from model instructions;
- tells the model what to do when retrieved evidence is insufficient.

RAG does not guarantee truth. Retrieval can miss the right document, return stale guidance, or surface a chunk that looks relevant but is not enough to support the answer. The operator still verifies citations and underlying source artifacts.

## RAG vs Fine-Tuning

RAG and fine-tuning are both ways to make a model more useful for a mission, but they solve different problems.

**RAG changes what the model can reference at runtime.** It retrieves relevant documents, chunks, images, or other artifacts and places them into the context window before generation. RAG is appropriate when the team needs current facts, local SOPs, doctrine, prior reports, case notes, tool manuals, or other evidence that should remain inspectable and citable.

Use RAG when:

- the knowledge changes often;
- citations and source review matter;
- the model needs local or mission-specific facts;
- the team wants to avoid changing model weights;
- the same base model must serve multiple knowledge domains.

**Fine-tuning changes the model's behavior by updating weights.** It is appropriate when the team wants the model to follow a specific format, style, classification pattern, or task behavior more reliably across many examples. Fine-tuning is less appropriate as a way to store fast-changing facts, because changing facts require another training cycle and may not be reliably recalled.

Use fine-tuning when:

- the desired behavior is stable and repeatable;
- the team has high-quality examples;
- the model must produce a specific output format or classification style;
- prompting alone is too brittle;
- latency or operational simplicity argues against retrieving many examples every time.

They can be combined. A fine-tuned model can follow the unit's output format while RAG supplies current evidence. For threat hunting, that combined pattern is common: fine-tune or instruct for behavior, retrieve for facts, and require citations for operational claims.

## What a Model Is

In operational terms, a model is a packaged set of learned numeric weights plus the supporting files needed to run those weights correctly. The weights encode statistical relationships learned during training. They do not contain a database of facts in the normal sense, and they are not a searchable evidence store. They are large arrays of numbers that transform input tokens into probability distributions over possible next tokens.

Common model contents include:

- **Weights:** The learned tensors, often split across multiple shard files for large models.
- **Tokenizer:** Files that define how text becomes tokens and how output tokens become text again.
- **Configuration:** Architecture details such as layer count, hidden size, attention heads, context length, vocabulary size, and precision.
- **Generation defaults:** Suggested sampling settings, stop tokens, chat template, and special-token behavior.
- **Model card:** Human-readable documentation describing intended use, limitations, license, training notes, and evaluation claims.
- **Adapter files:** Optional LoRA or other adapter weights that modify a base model without storing a full new copy.

Why models are so large:

- A 7 billion parameter model has roughly 7 billion learned numbers.
- If each number is stored in 16-bit precision, the weights alone require about 14 GB before runtime overhead.
- If each number is stored in 8-bit precision, the weights alone require about 7 GB.
- If quantized to 4-bit precision, the weights may require roughly 3.5-5 GB depending on format and metadata.
- Runtime memory also includes KV cache, temporary buffers, tokenizer/runtime overhead, and active request state.

That is why "model size" and "GPU size" are connected but not identical. Loading model weights is only the first requirement. Serving useful workloads also requires memory for context, concurrency, and the runtime.

## Open Weights and Model Formats

**Open weights** means the model's learned weight files are available for others to download and run. It does not always mean the model is open source in the software-license sense, and it does not always mean the training data, training code, or full build process is public.

When evaluating "open" models, distinguish:

- **Open weights:** Weight files are available.
- **Open model code:** Architecture/runtime code is available.
- **Open training data:** The data used to train the model is available or documented.
- **Open license:** The license permits the intended use.
- **Open evaluation:** Benchmarks and limitations are documented enough to assess fit.

Operators should not treat "open weights" as automatically approved. Licensing, provenance, safety behavior, and data-handling rules still matter.

Common formats and artifacts:

- **Tensor:** A multi-dimensional array of numbers. Model weights are stored as tensors.
- **PyTorch checkpoint (`.bin`, `.pt`, `.pth`):** Common training and research artifact formats. Older `.bin` files may use Python pickle mechanisms, which raises supply-chain caution when loading untrusted artifacts.
- **SafeTensors (`.safetensors`):** A safer tensor serialization format designed to store tensors without arbitrary code execution during load. Common on Hugging Face.
- **GGUF (`.gguf`):** A format used heavily by llama.cpp and many local runtimes. It packages model weights and metadata in a way optimized for local inference, including quantized variants.
- **ONNX (`.onnx`):** A portable model exchange format used across inference runtimes, more common in traditional ML and some optimized deployment workflows than in everyday local LLM use.
- **Tokenizer files (`tokenizer.json`, `tokenizer.model`, vocabulary files):** Required to ensure text becomes the same tokens the model was trained to expect.
- **Config files (`config.json`, `generation_config.json`):** Tell the runtime how to assemble and run the model.

Format choice affects the runtime path. Ollama and llama.cpp commonly use GGUF-derived local workflows. Hugging Face and vLLM commonly use repositories containing SafeTensors, tokenizer files, and config files. OpenAI-compatible APIs hide those files behind a service boundary; the operator consumes an endpoint rather than loading artifacts directly.

## What Transformers Changed

Modern LLMs are built on transformer architecture. The important operator-level idea is attention: the model can weigh relationships between tokens across the input instead of reading text only in sequence.

Why this matters:

- The model can connect distant parts of a log, report, or prompt.
- The model can maintain a working representation of entities, actions, and constraints across a context window.
- The same architecture scales well across large datasets and large compute clusters.
- Larger models and larger context windows can support more complex reasoning, but they also demand more memory and compute.

Transformer details such as attention heads, layers, feed-forward networks, and positional encodings matter to engineers building models. For this course, students need enough understanding to know why context length, model size, and hardware capacity drive deployment decisions.

## Operational Use Cases for Threat Hunting

Useful LLM-supported tasks include:

- summarizing endpoint, network, cloud, and identity telemetry;
- turning raw observations into hypotheses and RFIs;
- mapping observed behavior to ATT&CK techniques for analyst review;
- drafting detection logic or hunt queries for human validation;
- producing handoff packages from structured evidence;
- explaining unfamiliar tooling, script behavior, or error output;
- translating technical findings into commander-readable updates;
- building RAG systems over local doctrine, SOPs, detection notes, and prior incident reports.

High-risk uses include:

- accepting model output as evidence without source review;
- letting the model decide authority-sensitive actions;
- sending sensitive telemetry to unapproved external endpoints;
- using generated detection content without testing;
- allowing agents to call state-changing tools without guardrails.

The right mental model is "accelerated staff work with auditability," not "autonomous authority."

## Model and Runtime Ecosystem

### Local Runtimes

**Ollama** packages local model execution behind a simple CLI and HTTP API. It is useful for labs, analyst workstations, and small local demos because it lowers the setup burden.

**llama.cpp** provides efficient local inference, especially for quantized GGUF models. Many local tools use llama.cpp directly or indirectly.

**LM Studio** provides a desktop-centered local model experience. It is useful for experimentation and can expose OpenAI-compatible local endpoints.

### Serving Stacks

**vLLM** is designed for higher-throughput serving. It supports efficient batching and memory management features such as paged attention. It is a better fit for shared services than a single-user local runtime.

**Text Generation Inference (TGI)** is another production-oriented inference server commonly used with Hugging Face model workflows.

**OpenAI-compatible APIs** provide a common interface shape for chat completions, model listing, embeddings, and client integration. Many local and enterprise services expose an OpenAI-compatible endpoint even when they are not using OpenAI-hosted models.

### User Interfaces and Orchestration

**Open WebUI** provides a web interface that can connect to Ollama and OpenAI-compatible APIs. In this course, it is useful because students can compare local and remote model endpoints through one interface.

**Docker Compose** packages several services into a repeatable stack. For AI operations, Compose commonly defines:

- an inference service;
- a web UI;
- a vector database;
- supporting services such as reverse proxies, volumes, and health checks.

Compose is not a full production orchestrator, but it is a practical way to teach service relationships, port exposure, volumes, secrets, and GPU allocation.

## AI Harnesses and Workflow Layers

The model is only one part of an AI workflow. A **harness** is the application or environment wrapped around the model that decides what context the model sees, what tools it can use, what files it can read or edit, and how its output is turned into actions. Harnesses and workflow surfaces include general assistants, coding assistants, IDE-integrated agents, local agent frameworks, and enterprise chat environments. Examples include Claude, Cursor, Antigravity, OpenClaw, and similar tools.

A harness may provide:

- chat interface or IDE panel;
- automatic context collection from open files, repositories, terminals, logs, browser state, or selected documents;
- project rules, system instructions, and agent instructions;
- tool access such as file read/write, shell commands, browser automation, search, MCP tools, ticket systems, and code review;
- multi-step agent loops that plan, act, observe results, and continue;
- memory or persistent preferences;
- model routing across local models, hosted APIs, or enterprise inference services.

This matters operationally because two people can use the same underlying model and get different behavior if the harness supplies different context, rules, tools, or permissions.

## How Harnesses Work

Most harnesses follow the same general pattern:

1. **Collect context.** The harness gathers user prompt, selected text, open files, repository metadata, chat history, terminal output, issue text, screenshots, or other available artifacts.
2. **Apply instruction hierarchy.** The harness combines system instructions, developer instructions, project rules, agent instructions, user prompt, and sometimes tool-specific instructions.
3. **Select model and tools.** The harness chooses a model endpoint and decides which tools are available for the task.
4. **Call the model.** The model receives the assembled context and returns text, code, tool-call requests, or structured output.
5. **Execute tools.** If allowed, the harness reads files, edits files, runs commands, searches, calls APIs, or opens browser actions.
6. **Loop.** Agentic harnesses observe tool results and continue until the task is complete, blocked, or stopped by limits.

For operators, the key point is that the harness is part of the evidence chain. If the harness silently included a file, rule, terminal output, or retrieved chunk, that content may have influenced the model's answer.

## Rules, Agents, and Tool-Specific Instructions

Many harnesses support project-local instruction files. These are often stored in obvious repository files or tool-specific directories. Examples across tools include patterns such as:

- `.cursor/rules/` for Cursor project rules;
- `.cursor/skills/` for reusable Cursor agent skills;
- `AGENTS.md` for repository-level agent guidance;
- `CLAUDE.md` or `.claude/` for Claude-oriented project guidance;
- `.github/copilot-instructions.md` for GitHub Copilot-style repository guidance;
- tool-specific agent, rule, memory, or workflow files under a `.[tool]/` directory.

Names vary by product, but the concept is consistent: local files can alter model behavior. They may define coding standards, lab safety rules, allowed tools, command patterns, test expectations, output formats, or agent roles. Some are meant for all agents; others are specific to one tool.

Operational implications:

- Review project rules before trusting a harness-driven output.
- Treat local instruction files as part of the working environment.
- Watch for stale, conflicting, or overly broad rules.
- Understand which tools the harness can use and whether actions require approval.
- Be aware of prompt-injection risk from files, web pages, issues, and logs that the harness reads as context.
- Log important agent decisions when using harnesses for operational work.

Harnesses can be powerful because they connect models to workflows. They also widen the control surface. The model may only generate text, but the harness may turn that text into file edits, shell commands, API calls, or browser actions.

## Model Repositories and Artifact Discipline

Model repositories such as Hugging Face provide model cards, weights, tokenizer files, configuration, licenses, benchmark notes, and community discussion.

Operators should review:

- model purpose and training claims;
- license and use restrictions;
- whether the model is open weights, open source, or only accessible through an API;
- supported context length;
- input/output modality;
- model size and quantization availability;
- available artifact formats such as SafeTensors, GGUF, ONNX, or runtime-specific packages;
- tokenizer and chat-template requirements;
- known limitations and safety notes;
- download source and artifact integrity;
- whether the model is base, instruct, chat, code, embedding, reranker, or multimodal.

Treat model selection like tool selection. A model is an operational dependency. Its source, behavior, and constraints should be documented.

## Why GPUs Matter

LLM inference is dominated by large matrix operations and memory movement. GPUs are built to run many parallel numeric operations and move data at high bandwidth. That makes them a better fit than CPUs for most serious LLM workloads.

Important resource terms:

- **VRAM:** GPU memory available to hold model weights, key/value cache, and active request state.
- **Memory bandwidth:** How fast the accelerator can move model data. This often matters as much as raw compute.
- **Tensor cores:** Hardware units optimized for matrix math used by deep learning workloads.
- **KV cache:** Runtime memory used to store attention state for active contexts. Larger context windows and more concurrent users increase KV cache demand.
- **Batching:** Serving multiple requests together to improve throughput. Batching can improve system efficiency but may increase per-request latency.
- **Quantization:** Reducing weight precision to lower memory use and often improve speed. Quantization can reduce quality if pushed too far.

A common planning mistake is to ask only, "Can this GPU load the model?" The better question is, "Can this system load the model, support the required context length, serve the expected users, and stay within latency and reliability targets?"

## Hardware Survey

### CPU-Only Systems

CPU-only inference can work for small models, demonstrations, and low-speed offline tasks. It is useful when GPU access is unavailable or when the model is small enough that latency does not matter.

Operational fit:

- individual experimentation;
- small classification or summarization jobs;
- disconnected environments where GPU hardware is unavailable;
- emergency fallback.

Limitations:

- slow generation speed for larger models;
- poor concurrency;
- limited practicality for interactive team use.

### Consumer and Workstation GPUs

Single-GPU workstations can support local analyst-assist workflows. Depending on VRAM, they can run small to mid-sized models, embedding models, and some quantized larger models.

Operational fit:

- individual threat hunter workstation;
- lab environment;
- local prompt engineering and model comparison;
- small RAG prototypes;
- low-volume team support when expectations are modest.

Planning considerations:

- VRAM determines which model sizes and context windows are realistic.
- Consumer GPUs may lack enterprise manageability, error-correcting memory, and datacenter support features.
- Power, cooling, and driver stability still matter.

### Unified-Memory Workstation and Appliance Systems

Unified-memory systems, including DGX Spark-class architectures, blur the line between workstation and small shared inference appliance. Instead of treating CPU memory and GPU memory as entirely separate planning buckets, these systems can expose a large shared memory pool to support larger local models and more flexible workflows.

Operational fit:

- deployable team AI node;
- local inference for sensitive data that should not leave the mission environment;
- larger context analysis than a typical laptop or small workstation can support;
- prototype-to-field bridge before moving to datacenter hardware.

Planning considerations:

- Unified memory helps model capacity, but throughput still depends on accelerator compute and memory bandwidth.
- These systems are attractive for disconnected or bandwidth-constrained environments.
- They can support a small team service, but they should not be treated as a replacement for a multi-GPU datacenter cluster when many users need low latency.

### NVIDIA A100-Class Datacenter GPUs

A100-class systems are mature datacenter accelerators used for serious training and inference workloads. They provide high memory capacity options, strong tensor performance, and enterprise deployment support.

Operational fit:

- shared inference services for a team or organization;
- RAG and summarization over large internal corpora;
- multiple simultaneous analyst sessions;
- controlled model evaluation and deployment pipelines.

Planning considerations:

- Strong baseline for enterprise inference, especially when already available in the environment.
- Multi-instance GPU features can partition resources for separate workloads.
- Newer generations may offer better throughput and efficiency, but A100-class systems remain operationally useful.

### NVIDIA H100-Class Datacenter GPUs

H100-class systems improve throughput, transformer acceleration, and efficiency for modern LLM workloads. They are a strong fit where latency, concurrency, and large-model serving matter.

Operational fit:

- organization-level inference services;
- high-throughput chat and embedding workloads;
- larger model serving with longer context windows;
- production RAG systems with many users;
- model evaluation pipelines requiring faster iteration.

Planning considerations:

- Better suited than workstation systems for many concurrent users.
- Requires mature scheduling, monitoring, access control, and cost management.
- Often deployed behind an API service rather than exposed directly to analysts.

### NVIDIA B100-Class and Newer Datacenter Systems

B100-class systems represent the next tier of datacenter accelerator capability for very large models, high concurrency, and demanding production workloads.

Operational fit:

- centralized AI service for many teams;
- large-context or high-volume inference;
- multi-model serving where chat, embeddings, reranking, and tool-using agents all run at scale;
- strategic AI infrastructure rather than a single-course lab node.

Planning considerations:

- Hardware is only one part of the system. Network, storage, scheduling, monitoring, identity, and data controls become equally important.
- This class makes sense when demand is sustained and shared across missions.
- Without disciplined access control and workload planning, a high-end cluster can become an expensive shared bottleneck.

## Deployment Archetypes

### Single-Operator Local Stack

Use when one analyst needs a private assistant for local notes, logs, and experimentation.

Typical components:

- Ollama or llama.cpp;
- one local model;
- optional Open WebUI;
- local files or a small vector store.

Strengths:

- simple;
- low coordination burden;
- keeps data local;
- good for learning and prototyping.

Weaknesses:

- limited speed and model size;
- weak team sharing;
- inconsistent configurations across analysts.

### Team-Level Shared Inference Service

Use when a small team needs a common model endpoint, consistent prompts, and shared RAG content.

Typical components:

- vLLM or TGI;
- OpenAI-compatible API;
- Open WebUI or custom front end;
- vector database;
- central logging and access control.

Strengths:

- shared configuration;
- easier to audit;
- better hardware utilization;
- supports team workflows.

Weaknesses:

- requires service ownership;
- needs identity, logging, and endpoint protection;
- resource contention must be managed.

### Centralized Inference Cluster

Use when many teams need reliable access to large models or high-throughput services.

Typical components:

- multi-GPU servers or clusters;
- Kubernetes or another scheduler;
- vLLM/TGI-style serving;
- model registry and approval workflow;
- monitoring, chargeback, and capacity planning;
- identity, logging, and data controls.

Strengths:

- scalable;
- consistent;
- supports larger models and higher concurrency;
- enables organization-wide model governance.

Weaknesses:

- more complex to operate;
- risk of central dependency;
- requires clear data-handling and access policies.

## GPU Allocation in Docker Compose

Compose can request GPU access for containers. The exact syntax depends on Docker, NVIDIA Container Toolkit, and Compose version. The operational idea is consistent: the inference container must be allowed to see the GPU device and the required driver/runtime support must be present on the host.

Example pattern:

```yaml
services:
  inference:
    image: vllm/vllm-openai:latest
    ports:
      - "8000:8000"
    volumes:
      - ./models:/models
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

In a lab stack, the same concept may be simpler:

```yaml
services:
  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama:/root/.ollama
    gpus: all

volumes:
  ollama:
```

Students should understand the intent even when syntax changes by platform: expose GPU resources only to containers that need them, confirm the container can see the accelerator, and size the model and workload to the hardware.

## Safety Guardrails, Refusals, and Model Fit

Many LLMs include safety guardrails. These guardrails are model and platform behaviors intended to reduce harmful output, policy violations, unsafe instructions, data exposure, or unauthorized activity. In public chat systems, guardrails often appear as refusals: the model declines to answer, gives only high-level safety guidance, or redirects the user.

For normal consumer use, broad refusal behavior is usually acceptable. For authorized threat hunting, malware analysis, detection engineering, red-team emulation, or adversary tradecraft analysis, broad refusal behavior can become operational friction. A model may refuse a legitimate request because the words resemble malicious activity in another context.

The goal is not to bypass safety controls. The goal is to select and govern models whose safety behavior matches the mission and authority.

When evaluating refusal behavior, distinguish:

- **Appropriate refusal:** The model refuses a request outside authority, outside policy, or asking for unsafe action.
- **Over-refusal:** The model refuses authorized defensive analysis, synthetic lab work, detection engineering, or benign explanation because it misclassifies the request.
- **Under-refusal:** The model provides unsafe or unauthorized guidance when it should not.
- **Partial compliance:** The model gives generic advice but omits the technical detail needed for the authorized task.

For operational model selection, look for:

- model cards or platform documentation that explicitly support cybersecurity defense, threat analysis, malware analysis, or code review;
- acceptable-use terms that permit the intended mission environment;
- evaluation results from lab-safe prompts that represent real course tasks;
- predictable behavior on authorized dual-use language;
- the ability to log, audit, and review prompts and outputs;
- endpoint controls that compensate for lower refusal rates, such as identity, data rules, tool allow-lists, and human approval gates.

Avoid choosing a model simply because it is "uncensored" or has no obvious guardrails. Lower refusal characteristics can be useful when the work is authorized, but they increase the responsibility to control data, tools, users, logging, and review. A well-fit model should support legitimate security work without normalizing unsafe action outside the mission boundary.

Low-refusal variants are usually created by changing post-training behavior, not by changing the basic transformer prediction mechanism. At a high level, this may involve starting from a base or instruct model and then applying additional instruction tuning, preference optimization, adapter merges, or curated training examples that reward compliance with dual-use technical prompts and penalize unnecessary refusal. Some variants also remove or weaken external platform guardrails such as system prompts, hosted policy layers, or moderation wrappers.

The tradeoff is that refusal behavior is part of the model's instruction-following and boundary-setting behavior. Reducing refusals can also reduce calibration. A low-refusal model may be more willing to help with authorized malware analysis, but it may also:

- comply with requests that should have been rejected;
- provide more confident unsafe or unsupported output;
- follow user instructions over higher-priority safety or workflow constraints;
- lose some ability to say "I do not know" or ask for missing context;
- require stronger external controls around data, tools, logging, and human review.

It is also plausible, and commonly observed in some low-refusal or poorly tuned variants, that they get stuck in loops more often. This is not inherent to every low-refusal model, but several mechanisms can contribute:

- **Over-compliance:** The model keeps trying to satisfy an underspecified or conflicting request instead of stopping, refusing, or asking a clarifying question.
- **Weakened stop behavior:** Post-training changes can damage the model's learned sense of when an answer is complete.
- **Low-quality tuning data:** Repetitive compliance examples can teach repetitive output patterns.
- **Preference-optimization side effects:** Optimizing strongly for "always answer" can reduce calibration and increase rambling or repeated attempts.
- **Instruction hierarchy damage:** If tuning weakens system/developer instruction following, the model may loop around incompatible user goals.

Evaluate these variants with both refusal tests and stability tests. A useful low-refusal model for authorized cyber work should answer legitimate defensive prompts, refuse or constrain unauthorized prompts, stop cleanly, maintain output format, and avoid repetitive loops under realistic hunt workflows.

Evaluation should use an approved prompt set:

- benign threat-hunting summaries;
- synthetic malware-analysis descriptions;
- detection-rule drafting from lab-safe artifacts;
- ATT&CK mapping requests;
- questions that should be refused because they ask for unauthorized action;
- questions that should be answered because they are defensive, synthetic, or evidence-review tasks.

Record both false refusals and unsafe completions. The model that best supports operations is not always the model with the lowest refusal rate. It is the model whose refusal behavior, output quality, deployment controls, and policy fit match the mission.

## Operational Controls

Before using AI in an operational workflow, define:

- approved endpoints and models;
- data allowed into each endpoint;
- logging and audit expectations;
- prompt and output handling rules;
- human review points;
- tool-call allow-lists;
- API credential handling and revocation;
- failure behavior when the AI service is unavailable.

For threat hunting, the most important control is evidence discipline. The model can help generate hypotheses, but every conclusion still needs a source artifact, a confidence statement, and an analyst-owned judgment.

## Transition to Lab

The lab turns this lecture into a practical stack:

1. Verify a Windows ops station with Docker Desktop and Docker Compose.
2. Run Ollama locally and pull a small model.
3. Validate local inference through CLI and HTTP API calls.
4. Deploy Open WebUI through Docker Compose.
5. Connect Open WebUI to the local Ollama runtime.
6. Configure an OpenAI-compatible external endpoint using an instructor-provided `genai.mil` API token.
7. Perform controlled chat requests and document how local and external endpoints differ in latency, capability, and data-handling assumptions.

The tactical point is not that every mission needs this exact stack. The point is that operators should be able to understand, validate, and explain an AI stack before trusting it in a hunt workflow.

## References

- Ollama documentation: https://ollama.com/
- Open WebUI documentation: https://docs.openwebui.com/
- vLLM documentation: https://docs.vllm.ai/
- Hugging Face model hub: https://huggingface.co/models
- Docker Compose GPU support: https://docs.docker.com/compose/gpu-support/
- NVIDIA Container Toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/
