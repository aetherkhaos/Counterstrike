# Module 3: Virtualized and Abstracted Environments - Student Handout

## Objective

This module develops operational analysis in non-bare-metal contexts, including containerized services, minimal shell environments, and web-shell entry points. Your goal is to prove where your commands run, notice when that context changes, and adapt your collection approach when familiar tools are missing.

## Lab 3.1 - Merged Container Operations Chain

### Environment

The lab begins from a tokenized web shell on an instructor-designated Linux host. The exercise contains multiple runtime contexts, but you should discover those boundaries from system evidence rather than assuming the layout in advance.

Expected flags: 9.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`duck-31`|`20.30.40.31`|N/A|N/A|Web shell endpoint: `http://20.30.40.31:8081/?t=<instructor-provided-token>`|

### Investigation Rules

- Treat every new command surface as untrusted until you prove its identity, user context, working directory, process view, filesystem clues, and network view.
- Do not assume an uploaded file runs in the same place where the web page accepts it. Prove the execution context from output and nearby artifacts.
- When a normal helper command is unavailable, look for the source data that helper would have read and use available tools to inspect it.
- Record the evidence that led you from one stage to the next. A flag without the evidence chain is incomplete for this lab.

### Question Gates

Use the questions below as gates. Do not move to the next gate until you can answer the current one with command output or web UI evidence.

#### Gate 1 - Where Am I Starting?

- What user, host, shell, working directory, OS, process list, and network state can you observe from the web shell?
- What evidence shows this is a containerized or otherwise abstracted runtime?
- Which process, file-activity, or environment artifacts look intentionally placed for this exercise?
- Which three objectives can you recover from this first runtime context?

Evidence to capture: context commands, process or file listings, environment/container indicators, recovered objective values, and a short explanation of why each artifact belongs to the first context.

#### Gate 2 - What Does Upload and Execute Actually Do?

- What paths or labels does the web page reveal for uploaded files and remote execution?
- If you upload a small diagnostic payload, what does its output prove about where it ran?
- What output fields or response text are different from local web-shell command output?
- Which discovered hints point toward mounted data, missing-tool adaptation, scoped request/response behavior, or later movement?

Evidence to capture: uploaded payload content or description, remote execution output, context proof from the payload, and the clues you used to choose the next enumeration targets.

#### Gate 3 - What Can I Learn in the New Runtime?

- What user, host, filesystem roots, mounts, tools, and runtime directories are visible after remote execution?
- Which artifacts explain their own use through README files, notes, response fields, or ordinary directory names?
- What expected tool is missing, and what underlying data can you inspect without that tool?
- What request/response behavior can you trigger and verify from discovered instructions?
- Which three objectives can you recover in this runtime?

Evidence to capture: broad enumeration before targeted file reads, proof that each target path or request string was discoverable, missing-tool workaround evidence, request/response output, and recovered objective values.

#### Gate 4 - What Artifact Suggests the Next Reachable System?

- What files, configs, keys, host aliases, ports, or network notes suggest another reachable environment?
- What current limitation prevents the most obvious connection method from working directly?
- What alternate method can you justify using only discovered artifacts and allowed tools?
- How will you prove the next connection lands somewhere new?

Evidence to capture: discovered connection material, proof of the limitation, chosen adaptation method, and initial context proof after the transition.

#### Gate 5 - How Do I Operate in a Minimal Constrained Environment?

- What commands, built-ins, or linked utilities are actually available?
- Which objective files explain what you need to validate without revealing the answer directly?
- What links, aliases, or wrapper behavior can you prove instead of assuming?
- Which validation helper outputs confirm the remaining objectives?

Evidence to capture: available utility evidence, objective-note interpretation, link or alias behavior proof, helper usage/output, and recovered objective values.

### Submission

Submit a concise evidence narrative with all nine flags. For each objective, include:

- The question you were answering.
- The command or web action you used.
- The evidence source you observed.
- The conclusion you drew.
- Why that conclusion proves the correct runtime context or transition.

Your report should show a reproducible path through the lab, not just a list of values.