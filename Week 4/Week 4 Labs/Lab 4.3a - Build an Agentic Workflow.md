## Purpose

This lab asks you to build a local agentic triage workflow on the course n8n + Ollama stack. You will ingest syslog evidence, enrich indicators with a mock threat-intel service, classify activity with the local `phi4-mini` model, route high-confidence threats through conditional logic, and produce a structured incident report.

Duration: about 3 hours (Day 3 morning).

This lab builds the "happy path" workflow that you will harden in Lab L4.3b (Agent Reinforcement).

## Lab Access Model

You are working on the pre-staged agentic lab VM. All work happens in the local n8n canvas and terminal on that VM. Use the range-provided values if your instructor rotates any defaults.

|Role|Student-facing value|Notes|
|---|---|---|
|n8n UI|`http://localhost:5678`|Primary workflow builder and execution audit surface. Login: **`student@cs.ops`** / **`1qaz2wsx!QAZ@WSX`**.|
|Ollama (from n8n nodes)|`http://ollama:11434`|Docker-network hostname used inside n8n AI nodes.|
|Mock CTI API (from n8n nodes)|`http://cti-api:5000`|Docker-network hostname for threat-intel lookups.|
|Syslog artifact|`/opt/agentic/lab_data/auth_syslog.txt`|Pre-staged evidence file for this lab.|
|Lab stack directory|`/opt/agentic`|Docker Compose project root.|

### Environment Start and Verification

Primary method: local Docker Compose stack on the lab VM.

1. Start the pre-configured containers:
    
    ```
    cd /opt/agentic
    docker compose up -d
    ```
    
2. Verify all three containers are running:
    
    ```
    docker ps
    ```
    
    You should see `n8n`, `ollama`, and `cti-api`.
    
3. Open the n8n UI at `http://localhost:5678` and log in with **`student@cs.ops`** / **`1qaz2wsx!QAZ@WSX`**.
    
4. Confirm the `phi4-mini` model is available through an Ollama Chat Model sub-node before building AI steps.
    

If any pre-staged item is missing, stop and ask your instructor before modifying the lab host.

## Operational Context

You have received a SIEM alert for unusual outbound traffic from a critical internal server. Your task is to build a local agentic workflow that collects raw syslog evidence, enriches indicators with a mock threat-intel service, asks a local AI model to classify the activity, and routes the result into a structured incident output.

Treat each node name carefully. Later steps reference those names when mapping data between workflow stages.

## Objectives

By the end of this lab, you will be able to:

- Start and verify the local n8n, Ollama, and CTI API stack.
- Build an n8n workflow that ingests local syslog evidence.
- Extract indicators from the evidence and enrich them with a local CTI API.
- Configure `phi4-mini` as a local AI triage node.
- Force the model to return strict JSON that downstream nodes can parse.
- Route high-confidence malicious activity through an IF node.
- Transform the result into a human-readable incident report.

## Parts[](#parts)

Complete the parts in order:

1. Part 1 - Workflow Foundation and Data Collection
2. Part 2 - Configure the AI Triage Agent
3. Part 3 - Parse, Branch, and Transform the Output

## Evidence Expectations

Submit the following at the end of the lab:

1. A workflow screenshot showing the complete Day 3 morning workflow.
2. The exported workflow JSON named `Week4-Day3-Part1-[YourLastName].json`.
3. The final `markdown_report` output from a successful execution.
4. Short answers to the check-your-understanding prompts assigned by your instructor.

## Final Validation Checklist

Before exporting, verify the workflow has this high-level shape:

```
Manual Trigger
  -> Define Mission Constants
  -> Read Syslog File
  -> Extract Syslog Text
  -> Query CTI Database
  -> Extract IPs from Logs
  -> Split out IPs one at a time
  -> API Call for each IP detected
  -> Merge CTI from all IPs together
  -> AI Triage Agent
  -> Parse AI Output
  -> Is Threat Malicious?
  -> Format IR Ticket
```

Check the following before submitting:

- `docker ps` shows `n8n`, `ollama`, and `cti-api` running.
- `Extract Syslog Text` outputs `raw_syslog_data`.
- `Extract IPs from Logs` outputs a JSON array of IPs.
- `Merge CTI from all IPs together` outputs consolidated enrichment data.
- `AI Triage Agent` returns only JSON, with no markdown or introductory prose.
- `Parse AI Output` separates `classification`, `confidence`, and `summary`.
- `Is Threat Malicious?` uses both classification and confidence threshold logic.
- `Format IR Ticket` produces a readable `markdown_report`.

## Export the Workflow

1. Save the workflow.
2. Use the workflow menu to export the workflow JSON.
3. Name the export `Week4-Day3-Part1-[YourLastName].json`.
4. Capture a screenshot of the full workflow canvas.
5. Copy the final `markdown_report` output into your submission notes.

This exported workflow is the baseline you will duplicate and harden in Lab L4.3b.

## Self-Check Appendix

Use this appendix after you have attempted the questions in each part. It supports self-correction; it does not replace doing the workflow.

### Part 1 Answers

**Step 1:** The **Executions** tab is the audit log. It allows you to step through historical runs node by node to see what data the LLM saw and what decision it made.

**Step 2:** If a threshold is defined as a string, mathematical operations and numeric logic such as "greater than" can fail or behave incorrectly. n8n allows explicit types so downstream conditions evaluate correctly.

**Step 3:** n8n reads files as binary objects first because the same read action can feed many extraction paths. A text file, PDF, CSV, or binary artifact may all start as binary data before being handled by the correct downstream parser.

**Step 4:** In operations, one failed intel feed should not necessarily stop analysis of the raw evidence. You would use the HTTP Request node's **Settings** tab and enable **Continue On Fail** so the workflow can continue with reduced context.

**Step 5:** A single linear chain keeps prior node data easier to reference. If the workflow splits into parallel branches, you usually need a **Merge** node to bring raw syslog text and CTI JSON back together before the AI node can use both.

**Step 7, Question 1:** Update the prompt to ask for all IOC types and update the Structured Output Parser schema to return a richer object, such as `{"ips": [], "domains": [], "hashes": []}`.

**Step 7, Question 2:** Add a **Switch** or routing node after splitting items. Configure rules by IOC type or regex pattern, route each type to the correct enrichment tool, and merge the enriched results before final triage.

### Part 2 Answers

**Step 1:** n8n separates chain logic from model execution for modularity. You can swap the model backend without rebuilding all prompts and routing logic.

**Step 2:** A very low Max Tokens value can cut off the model response mid-object, leaving malformed JSON that downstream parse logic cannot read.

**Step 3:** Smaller local models often default to conversational responses. Without explicit constraints, the model may prepend text such as "Here is the JSON," which corrupts the machine-readable payload.

**Step 4:** Production-scale processing would require more suitable inference hardware, typically GPU-backed infrastructure, plus queueing and concurrency controls. CPU-only local inference is useful for this offline lab but not for high-volume enterprise log streams.

### Part 3 Answers

**Step 1:** You could enable **Continue On Fail** on the Code node, route failures to an IF node, and send the workflow back to the AI with a correction prompt such as "Your previous output was invalid JSON. Please correct the syntax and try again."

**Step 2:** The data routes down the **False** branch. In production, you would usually log that decision to a datastore for audit and metrics instead of dropping it completely.

**Step 3:** Strict JSON lets the workflow make machine decisions first. Markdown is better created after routing, when the workflow has already parsed the fields it needs for conditional logic.

## Course Tie-Back

- **L4.3b:** This morning build is the baseline you fork and harden in the afternoon reinforcement lab.
- **L4.4:** The reinforced STIX-style output from L4.3b becomes input for the Effects Advisor Agent lab on Day 4.