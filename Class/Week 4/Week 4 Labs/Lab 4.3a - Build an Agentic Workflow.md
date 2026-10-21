## Purpose

This lab asks you to build a local agentic triage workflow on the course n8n + Ollama stack. You will ingest syslog evidence, enrich indicators with a mock threat-intel service, classify activity with the local `phi4-mini` model, route high-confidence threats through conditional logic, and produce a structured incident report.

Duration: about 3 hours (Day 3 morning).

This lab builds the "happy path" workflow that you will harden in Lab L4.3b (Agent Reinforcement).

## Lab Access Model

You are working on the pre-staged agentic lab VM. All work happens in the local n8n canvas and terminal on that VM. Use the range-provided values if your instructor rotates any defaults.

| Role                          | Student-facing value                    | Notes                                                                                                       |
| ----------------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| n8n UI                        | `http://localhost:5678`                 | Primary workflow builder and execution audit surface. Login: **`student@cs.ops`** / **`1qaz2wsx!QAZ@WSX`**. |
| Ollama (from n8n nodes)       | `http://ollama:11434`                   | Docker-network hostname used inside n8n AI nodes.                                                           |
| Mock CTI API (from n8n nodes) | `http://cti-api:5000`                   | Docker-network hostname for threat-intel lookups.                                                           |
| Syslog artifact               | `/opt/agentic/lab_data/auth_syslog.txt` | Pre-staged evidence file for this lab.                                                                      |
| Lab stack directory           | `/opt/agentic`                          | Docker Compose project root.                                                                                |

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

# Part 1 - Workflow Foundation and Data Collection[](#part-1---workflow-foundation-and-data-collection)

[Back to lab overview](/dco-counterstrike-pilot-course-content/module-content/-/blob/main/../index.md)

## Operational Context[](#operational-context)

You have received an alert from your SIEM regarding unusual outbound traffic from a critical internal server. In this part, you build the first half of an autonomous agent that collects raw syslog data, extracts destination IPs, and queries a local Threat Intelligence (CTI) API for enrichment before handing evidence to the AI triage agent.

## What to Do[](#what-to-do)

### Step 1: Start the Environment and Initialize the Workflow[](#step-1-start-the-environment-and-initialize-the-workflow)

Start the local tool stack and create the base workflow.

1. Open your terminal and start the pre-configured containers:
    
    ```
    cd /opt/agentic
    docker compose up -d
    ```
    
2. Verify all three containers are running:
    
    ```
    docker ps
    ```
    
    You should see containers for `n8n`, `ollama`, and `cti-api`.
    
3. Open your browser and navigate to `http://localhost:5678`.
    
4. Log in with **`student@cs.ops`** / **`1qaz2wsx!QAZ@WSX`**.
    
5. Click **+ Add Workflow** in the top right corner.
    
6. Double-click the default node on the canvas and ensure it is set to **On clicking 'Execute Workflow'**. This is the Manual Trigger.
    
7. Rename the workflow in the top left to `Week4-Day3-Part1-[YourLastName]`.
    

> **Repetition Task:** While you are using a Manual Trigger for building and testing, agents in the wild are often triggered automatically. Delete your Manual Trigger, click **+ Add first step**, and search for the **Webhook** node. Look at how it generates a unique URL to catch data. Once you have explored it, delete the Webhook node and put the Manual Trigger back on the canvas.

> **Check Your Understanding**
> 
> Question: Once this agent is deployed operationally through a Webhook, it may run silently in the background. Where in the n8n interface would you go to audit past decisions or see where a specific execution failed?
> 
> Hint: Look at the main navigation menu on the far left side of the screen.

### Step 2: Define Mission Constants[](#step-2-define-mission-constants)

Agents often need static context to operate, such as target network segments, risk thresholds, or API keys.

1. Click the **+** button next to your trigger node.
    
2. Search for and select the **Edit Fields (Set)** node.
    
3. In the node settings, add the following fields by clicking **Add Value -> String**:
    
    |Name|Value|
    |---|---|
    |`target_subnet`|`172.20.0.0/16`|
    |`cti_api_key`|`pcte-mock-key-8675309`|
    |`suspicious_ip`|`198.51.100.44`|
    
4. Rename this node to `Define Mission Constants`.
    
5. Click **Execute Node** and verify that the data appears as a JSON table.
    

> **Repetition Task:** Add a fourth constant to define the agent's confidence threshold. This time, instead of selecting **String**, click **Add Value -> Number**. Name it `confidence_threshold` and set the value to `85`. Execute the node again. Notice that the number `85` is blue in the JSON output, while strings are green.

> **Check Your Understanding**
> 
> Question: Why does it matter if you define the threshold as a number instead of a string, such as `85` instead of `"85"`?
> 
> Hint: Think about how the IF node will evaluate routing logic later in the workflow.

### Step 3: Ingest Local Log Data[](#step-3-ingest-local-log-data)

Next, give the workflow raw evidence to analyze. You will read a syslog file from disk as binary data, then extract the binary content into readable text.

1. Add a new node connected to `Define Mission Constants`.
    
2. Search for and select **Read/Write Files from Disk**.
    
3. Configure the node:
    
    |Field|Value|
    |---|---|
    |Operation|`Read File(s) From Disk`|
    |File(s) Selector|`/opt/agentic/lab_data/auth_syslog.txt`|
    
4. Rename the node to `Read Syslog File`.
    
5. Click **Execute Node**.
    
    The output will show a binary object named `data`, not readable text. LLMs cannot read raw binary files directly, so you need an extraction node.
    
6. Click the **+** button next to `Read Syslog File`.
    
7. Search for and select **Extract from File**.
    
8. Configure the extraction node:
    
    |Field|Value|
    |---|---|
    |Operation|`Extract From Text File`|
    |Input Binary Field|`data`|
    |Destination Output Field|`raw_syslog_data`|
    
9. Rename this node to `Extract Syslog Text`.
    
10. Click **Execute Node**.
    

You should now see readable syslog content in the JSON output pane under the `raw_syslog_data` key.

> **Repetition Task:** In `Extract Syslog Text`, change **Destination Output Field** from `raw_syslog_data` to `my_custom_log_string`. Execute the node again and observe how the JSON key changed. Change it back to `raw_syslog_data` before moving on.

> **Check Your Understanding**
> 
> Question: Why does n8n use one node to read from disk and another node to extract text, instead of one simple "Read Text File" node?
> 
> Hint: Think about the variety of files a CPT analyst might need to ingest into an automated pipeline.

### Step 4: Test a Single CTI API Lookup[](#step-4-test-a-single-cti-api-lookup)

Before you build dynamic indicator enrichment, test the local threat-intel service with the static suspicious IP from your mission constants.

1. Add a node after `Extract Syslog Text`.
    
2. Search for and select **HTTP Request**.
    
3. Configure the HTTP Request node:
    
    |Field|Value|
    |---|---|
    |Method|`GET`|
    |URL|`http://cti-api:5000/api/v1/ip/{{ $('Define Mission Constants').item.json.suspicious_ip }}`|
    |Authentication|`None`|
    
4. Add a header:
    
    |Header Name|Header Value|
    |---|---|
    |`Authorization`|`Bearer {{ $('Define Mission Constants').item.json.cti_api_key }}`|
    
5. Rename the node to `Query CTI Database`.
    
6. Click **Execute Node**.
    

You should receive a JSON response with the IP reputation context.

> **Repetition Task:** Change the URL to target an IP that is not in the database by replacing the dynamic variable with `8.8.8.8`. Execute the node. You should receive a 404 error and the workflow should stop. Change the URL back to the dynamic expression before moving on.

> **Check Your Understanding**
> 
> Question: If the CTI server goes offline, the default behavior of the HTTP Request node is to throw an error and halt the workflow. In an operational threat-hunting scenario, why might you want to change this behavior, and where would you do it?
> 
> Hint: Look at the **Settings** tab at the top of the HTTP Request node.

### Step 5: Understand Workflow Flexibility and Node Placement[](#step-5-understand-workflow-flexibility-and-node-placement)

You are placing enrichment nodes in a single linear chain after `Extract Syslog Text`. In n8n, you could instead branch immediately after the trigger and fetch threat intel in parallel with log ingestion. For this first build, a single chain makes data references easier to understand and debug.

> **Check Your Understanding**
> 
> Question: You are placing the threat-intel request in-line instead of running it on a parallel branch. Why does this make configuring the final AI triage node easier?
> 
> Hint: Think about how data flows through connecting wires in n8n. If the workflow splits into two parallel branches, what must you do before sending all the data to one AI node?

### Step 6: Extract Indicators Dynamically with an AI Node[](#step-6-extract-indicators-dynamically-with-an-ai-node)

In the real world, you rarely know the suspicious IP ahead of time. Instead of relying only on the hardcoded IP, use a small AI extraction step to read the log and extract all IPv4 addresses into a clean JSON array.

1. Click the **+** button next to `Query CTI Database`.
    
2. Search for **Basic LLM Chain** and add it to the canvas.
    
3. Rename the node to `Extract IPs from Logs`.
    
4. Add **Ollama Chat Model** as a sub-node.
    
5. Configure the Ollama Chat Model:
    
    |Field|Value|
    |---|---|
    |Base URL|`http://ollama:11434`|
    |Model|`phi4-mini`|
    
6. In the sub-node area, add a **Structured Output Parser**.
    
7. Configure the parser to expect an array of strings. Each string should be an IP address.
    
8. In the prompt field for `Extract IPs from Logs`, use the expression editor to pass in the syslog text:
    
    ```
    Review this log and extract all IPv4 addresses:
    {{ $('Extract Syslog Text').item.json.raw_syslog_data }}
    ```
    
9. Click **Execute Node**.
    

The output should be a clean JSON array of IPs found in the text, such as:

```
["172.20.2.14", "198.51.100.44"]
```

### Step 7: Split, Query, and Merge CTI Data[](#step-7-split-query-and-merge-cti-data)

The CTI API can only look up one IP at a time. Split the array of IPs into separate execution items, query the API for each IP, then merge the enriched results.

1. Add an **Item Lists** node after `Extract IPs from Logs`.
    
2. Rename it to `Split out IPs one at a time`.
    
3. Configure it to **Split Out Items**. If the node asks for a destination field name, use `ip`.
    
    This turns one array of IPs into separate execution items.
    
4. Add an **HTTP Request** node after the split node.
    
5. Rename it to `API Call for each IP detected`.
    
6. Configure the URL to hit the CTI server dynamically using the current item's IP:
    
    ```
    http://cti-api:5000/api/v1/ip/{{ $json.ip }}
    ```
    
7. Add the same authorization header you used earlier:
    
    |Header Name|Header Value|
    |---|---|
    |`Authorization`|`Bearer {{ $('Define Mission Constants').item.json.cti_api_key }}`|
    
8. Add one more **Item Lists** node after `API Call for each IP detected`.
    
9. Rename it to `Merge CTI from all IPs together`.
    
10. Configure it to **Aggregate Items -> Keep All Fields**.
    
11. Click **Execute Workflow**.
    

You should see the workflow loop the HTTP request for every IP found in the log and output a consolidated JSON block containing threat intel for all detected IPs.

> **Repetition Task:** In `Extract IPs from Logs`, change the system prompt and Structured Output Parser to extract usernames instead of IP addresses. Execute the workflow and observe the failure at the HTTP Request step because the API expects an IP address. Change the node back to IP extraction and execute again to restore the flow.

> **Check Your Understanding: Scaling the Architecture**
> 
> Question 1: Right now, this extraction agent only looks for IPs. If you wanted to extend this workflow to hunt for other Indicators of Compromise, such as file hashes, domains, or email addresses, how would you change `Extract IPs from Logs`?
> 
> Hint: Look at the Structured Output Parser.
> 
> Question 2: If you successfully extract IPs, domains, and hashes, you cannot send them all to the same threat-intel API endpoint. How could you design the n8n workflow to route different IOC types to the correct tools?
> 
> Hint: Think about nodes available in n8n for conditional logic and branching.

## Evidence to Capture[](#evidence-to-capture)

- Screenshot or execution output showing `raw_syslog_data` from `Extract Syslog Text`.
- Execution output showing the IP array from `Extract IPs from Logs`.
- Execution output showing consolidated CTI enrichment from `Merge CTI from all IPs together`.

## Next Step[](#next-step)

Continue to [Part 2 - Configure the AI Triage Agent](part-2-configure-ai-triage-agent.md).
1. Part 2 - Configure the AI Triage Agent
2. Part 3 - Parse, Branch, and Transform the Output

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