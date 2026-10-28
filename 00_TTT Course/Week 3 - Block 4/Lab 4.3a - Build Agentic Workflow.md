# Build Agentic Workflow Lab — Student Brief

## Objective

…

## Context

…

## Tasks

1. …

## Deliverables / Evidence

…

## Constraints

…

## Success Criteria

…

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Build an Agentic Workflow

## Student Guide

**Duration:** ~3 hours. **Stack:** n8n is already running on your VM at `http://localhost:5678`. SI nodes call your team's LiteLLM. CTI is the class API.

## Context

A SIEM alert reports unusual outbound traffic. Build a happy-path n8n workflow: ingest syslog, enrich IPs via class CTI, classify with a local model, branch, emit an IR report. A later pass hardens this workflow. Keep node names exact; later steps reference them.

## Objectives

- Confirm n8n is up on your VM and create the owner account on that instance.
- Ingest Moodle syslog evidence into n8n, including the file-access setting that blocks the first read.
- Extract IPs with the local **secondary** model; triage with the local **primary** model.
- Enrich IPs via `https://cti.<team-domain>/api/v1/ip/{ip}`.
- Force JSON output, branch on high-confidence `Malicious`, emit `markdown_report`.

## Access

The instructor tells you which VM to log into for this run. On that VM, n8n is `http://localhost:5678`. Hostnames, the LiteLLM key, and the model ids are on the Moodle page **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**.

`<team-domain>` is the domain on that page. If LiteLLM is listed as `[https://litellm.team1.cso.ops](https://litellm.team1.cso.ops)`, `<team-domain>` is `team1.cso.ops`. Use that same value everywhere this guide writes `<team-domain>`, including CTI.

|Role|Value|
|---|---|
|n8n UI|`http://localhost:5678` on your VM|
|LiteLLM|`https://litellm.<team-domain>/v1`|
|CTI|`https://cti.<team-domain>/api/v1/ip/{ip}`|
|CTI key|`cso-cti-k9m2p7x4q1`|
|Syslog|Moodle file `auth_syslog.txt`|

Open n8n in a browser on the VM. You are the owner of this instance.

## Deliverables

1. Screenshot of the complete workflow.
2. Export `Build an Agentic Workflow-[YourLastName].json`.
3. Final `markdown_report` from a successful run.
4. Assigned check-your-understanding answers.

## Part 0: Confirm n8n and team LiteLLM

**Objective:** Confirm n8n is already up on your VM, and that model calls go to team LiteLLM.

n8n is already installed. Do not add a service and do not change the encryption key.

1. On the VM, open `http://localhost:5678`. Create the owner account. This instance is yours.
    
2. Confirm LiteLLM is healthy. Replace `<team-domain>` as defined above, and `<LITELLM_KEY>` with the LiteLLM key on **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**.
    
    ```
    curl -sk "https://litellm.<team-domain>/v1/models" \
     -H "Authorization: Bearer <LITELLM_KEY>"
    ```
    
    `-k` skips verification of the team certificate. You should see the models that gateway is serving.
    
3. Download `auth_syslog.txt` from Moodle. `docker inspect` lists each host directory and the path inside the container. Copy the file into the host directory whose destination is `/lab_data`.
    
    ```
    docker inspect <n8n-container> --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}'
    cp auth_syslog.txt <host-directory-for-/lab_data>/auth_syslog.txt
    ```
    
    If `docker` says permission denied, run those commands with `sudo`. The workflow will read `/lab_data/auth_syslog.txt`. Do not put the file under n8n's own data directory.
    

Workflow SI nodes use the team LiteLLM URL only. Do not point them at a model host.

## Part 1: Workflow foundation and data collection

**Objective:** Ingest the syslog, clear the file-access block, look up CTI, and extract IPs with the local secondary model.

### Step 1: Create the workflow

1. Open `http://localhost:5678` and log in as yourself.
2. **+ Add Workflow**.
3. Confirm the default node is **On clicking 'Execute Workflow'** (Manual Trigger).
4. Rename the workflow `Build an Agentic Workflow-[YourLastName]`.

> **Repetition Task:** Delete the Manual Trigger, add a **Webhook** node, inspect the URL, then restore the Manual Trigger.
> 
> **Check Your Understanding**
> 
> Question: After a webhook deploy, where do you audit past runs and failures?
> 
> Hint: Far-left navigation.

### Step 2: Define mission constants

1. Add **Edit Fields (Set)** after the trigger.
2. Add these string fields:

|Name|Value|
|---|---|
|`target_subnet`|`172.20.0.0/16`|
|`cti_base_url`|`https://cti.<team-domain>`|
|`cti_api_key`|`cso-cti-k9m2p7x4q1`|
|`suspicious_ip`|`198.51.100.44`|

3. Rename to `Define Mission Constants`. Execute and confirm JSON.

> **Repetition Task:** Add number field `confidence_threshold` = `85`. Numbers render blue; strings green.
> 
> **Check Your Understanding**
> 
> Question: Why store the threshold as a number, not `"85"`?
> 
> Hint: Later IF-node numeric compare.

### Step 3: Ingest syslog

1. Add **Read/Write Files from Disk**.

|Field|Value|
|---|---|
|Operation|`Read File(s) From Disk`|
|File(s) Selector|`/lab_data/auth_syslog.txt`|

2. Rename to `Read Syslog File`. Execute.
    
    The node fails. The error says `Access to the file is not allowed.` It does not name the path. n8n 2 allows that node only under `~/.n8n-files` (`/home/node/.n8n-files` in this container) until you name an allowlist. Copying the file to `.n8n-files` skips the setting this step is here to teach. Do not do that.
    
3. On the VM, edit the n8n service in the Compose file that mounts `/lab_data`. Add this environment line, then recreate the container:
    
    ```
    N8N_RESTRICT_FILE_ACCESS_TO: /lab_data
    ```
    
    ```
    docker compose -p student-n8n up -d --force-recreate
    ```
    
    Use `sudo` if Docker requires it. Open `http://localhost:5678` again and execute `Read Syslog File`. Output is binary `data`. The same allowlist is what permits a later write under `/lab_data`.
    
4. Add **Extract from File**.
    

|Field|Value|
|---|---|
|Operation|`Extract From Text File`|
|Input Binary Field|`data`|
|Destination Output Field|`raw_syslog_data`|

5. Rename to `Extract Syslog Text`. Execute. Confirm readable syslog under `raw_syslog_data`.

> **Repetition Task:** Change destination to `my_custom_log_string`, execute, then restore `raw_syslog_data`.
> 
> **Check Your Understanding**
> 
> Question: Why split read vs extract instead of one "read text file" node?
> 
> Hint: Same binary read can feed PDF, CSV, or text extractors.

### Step 4: Test one CTI lookup

1. Add **HTTP Request** after `Extract Syslog Text`.

|Field|Value|
|---|---|
|Method|`GET`|
|URL|`{{ $('Define Mission Constants').item.json.cti_base_url }}/api/v1/ip/{{ $('Define Mission Constants').item.json.suspicious_ip }}`|
|Authentication|`None`|

2. Header: `Authorization` = `Bearer {{ $('Define Mission Constants').item.json.cti_api_key }}`.
3. Under **Options**, turn on **Ignore SSL Issues (Insecure)**. The class certificate is the same one Part 0 skips with `curl -k`.
4. Rename to `Query CTI Database`. Execute.

Expect JSON with `indicator`, `reputation_score`, `classification`, `tags`, `last_seen`, and `summary`. `summary` may differ between runs; scores should not.

> **Repetition Task:** Query `8.8.8.8`. Expect **404** and a halt. Restore the expression.
> 
> **Check Your Understanding**
> 
> Question: If CTI is down, default HTTP Request fails the workflow. Why change that in ops, and where?
> 
> Hint: HTTP Request **Settings**.

### Step 5: Linear vs parallel placement

Keep enrichment in-line after `Extract Syslog Text` for this build. Parallel branches would need a Merge before triage.

> **Check Your Understanding**
> 
> Question: Why is in-line CTI easier for the later SI node than a parallel branch?
> 
> Hint: What must you do if wires split?

### Step 6: Extract IPs (local secondary model)

1. Add **Basic LLM Chain**. Rename `Extract IPs from Logs`.
2. Add **OpenAI Chat Model** sub-node. Create an OpenAI credential:

|Field|Value|
|---|---|
|Base URL|`https://litellm.<team-domain>/v1`|
|API Key|team LiteLLM master key|

3. Model: `ollama/qwen3.5:4b`. Temperature `0`. The number before `b` is billions of parameters. This model writes its reasoning before the answer. The OpenAI node has no ignore-SSL switch. The VM must already trust the team certificate. If Part 0's `curl -k` works and this node reports `Connection error`, the VM does not trust that certificate.
4. On the VM, stream one short completion. `-N` prints each chunk as it arrives instead of waiting for the whole reply. `<team LiteLLM key>` is the key from [DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access").
    
    ```
    curl -N "https://litellm.<team-domain>/v1/chat/completions" \
     -H "Authorization: Bearer <team LiteLLM key>" \
     -H "Content-Type: application/json" \
     -d '{"model":"ollama/qwen3.5:4b","max_tokens":120,"messages":[{"role":"user","content":"Reply with the single word pong."}]}'
    ```
    
    Tokens arrive for a couple of seconds. The text is the model's reasoning, and the call ends because `max_tokens` is `120`. The word `pong` is not the reply.
    
5. On the OpenAI Chat Model node, set **Max Tokens** to `1500` and **Timeout** to `10000` milliseconds. Execute the chain.
    
    The node stops with a timeout. The output has no IP list. The model is still writing: about 70 tokens per second, so 1500 tokens take about 20 seconds, and the node stopped waiting at 10 seconds. Wait for that reply to finish before the next execute. The team has one model slot, so a new call waits behind the one still running.
    
6. On the same model node, set **Max Tokens** to `500`, **Timeout** to `120000`, and **Extra Body** to `{"think": false}`.
    
7. Add **Structured Output Parser**: array of IP strings.
8. Prompt:
    
    ```
    Review this log and extract all IPv4 addresses:
    {{ $('Extract Syslog Text').item.json.raw_syslog_data }}
    ```
    
9. Execute. Expect something like:
    

```
["172.20.2.14", "198.51.100.44"]
```

> **Check Your Understanding**
> 
> Question: The first execute timed out. What were you watching in the terminal while the node had no output?
> 
> Hint: The stream ended on a token cap, not on the word you asked for.

### Step 7: Split, query, merge

1. Add **Item Lists** `Split out IPs one at a time`. Split Out Items; destination field `ip`.
2. Add **HTTP Request** `API Call for each IP detected`:
    
    ```
    {{ $('Define Mission Constants').item.json.cti_base_url }}/api/v1/ip/{{ $json.ip }}
    ```
    
    Same `Authorization` header as Step 4. Turn on **Ignore SSL Issues (Insecure)** here too.
    
3. Add **Item Lists** `Merge CTI from all IPs together`. Aggregate Items → Keep All Fields.
    
4. Execute Workflow. Expect one consolidated CTI block for every extracted IP.

> **Repetition Task:** Change extraction to usernames. Watch the HTTP step fail. Restore IP extraction.
> 
> **Check Your Understanding: Scaling**
> 
> Question 1: How would you extract hashes and domains as well as IPs?
> 
> Hint: Structured Output Parser.
> 
> Question 2: Different IOC types need different APIs. How do you route them?
> 
> Hint: Switch / IF after split.

## Part 2: SI triage agent (local primary model)

**Objective:** Add the triage agent on the local primary model.

### Step 1: Add the triage node

1. Add **Basic LLM Chain** after `Merge CTI from all IPs together`. Rename `SI Triage Agent`.
2. Attach **OpenAI Chat Model**. Reuse the LiteLLM credential. Model: a larger local chat model from the same `/v1/models` list.

> **Repetition Task:** Disconnect the model; confirm the chain errors; reconnect.
> 
> **Check Your Understanding**
> 
> Question: Why split chain vs model nodes?
> 
> Hint: Swapping backends later.

### Step 2: Tune parameters

On the OpenAI Chat Model: Temperature `0` (or `0.1`). Add Max Tokens `500`. If that model is a thinking model, the 500-token cap can be spent before any JSON is written, and the later parse step sees empty text. On that model node, set **Extra Body** to `{"think": false}`.

> **Repetition Task:** Confirm Max Tokens is set.
> 
> **Check Your Understanding**
> 
> Question: What happens if Max Tokens is `10` but you asked for JSON?
> 
> Hint: Downstream parse.

### Step 3: System prompt

In `SI Triage Agent`, System Message:

```
You are an expert SOC Analyst and Threat Hunter. Your job is to review system logs and Threat Intelligence data to categorize potential network intrusions.
You must output YOUR ENTIRE RESPONSE as a valid JSON object. Do not include markdown formatting, backticks, or conversational text.
Use this exact schema:
{
  "classification": "Benign" or "Suspicious" or "Malicious",
  "confidence": a number between 1 and 100,
  "summary": "A one sentence explanation of your finding"
}
```

> **Repetition Task:** Temporarily add `"recommended_action"`. Restore the three-key schema unless told otherwise.
> 
> **Check Your Understanding**
> 
> Question: Why ban markdown and chat filler?
> 
> Hint: How models often start JSON answers.

### Step 4: User prompt

Expression:

```
Analyze the following raw syslog data:
{{ $('Extract Syslog Text').item.json.raw_syslog_data }}

Here is the Threat Intelligence context for the associated IP addresses:
{{ JSON.stringify($('Merge CTI from all IPs together').item.json) }}
```

Execute. Expect JSON only.

> **Repetition Task:** Swap the full CTI object for one field (e.g. `reputation_score`), then restore.
> 
> **Check Your Understanding**
> 
> Question: This team Spark is GPU-backed and shared. What breaks first under many concurrent runs?
> 
> Hint: Queueing and which model id you send, not CPU-only VMs.

## Part 3: Parse, branch, transform

**Objective:** Parse the model output, branch, and emit the IR report.

### Step 1: Parse SI output

n8n treats the model output as text until you parse it.

1. Add **Code** after `SI Triage Agent`. Rename `Parse SI Output`.
    
    ```
    const aiResponse = $input.item.json.text;
    const parsedData = JSON.parse(aiResponse);
    return parsedData;
    ```
    
2. Execute. Confirm keys `classification`, `confidence`, `summary`.
    

> **Repetition Task:** Break `JSON.parse` syntax, observe the error, restore.
> 
> **Check Your Understanding**
> 
> Question: How do you recover if parse fails instead of crashing?
> 
> Hint: Code node Settings + retry to the SI node.

### Step 2: IF branch

1. Add **If**. Rename `Is Threat Malicious?`.
2. String: `classification` Equal `Malicious`.
3. Execute. This evidence should take **True**.

> **Repetition Task:** Add AND number condition: `confidence` Larger or Equal `confidence_threshold` from mission constants.
> 
> **Check Your Understanding**
> 
> Question: If classification is `Benign`, which IF output fires?
> 
> Hint: True vs False.

### Step 3: IR ticket

On the **True** output, add **Edit Fields (Set)** `Format IR Ticket`. String field `markdown_report`:

```
[HIGH CONFIDENCE THREAT]

**Target Subnet:** {{ $('Define Mission Constants').item.json.target_subnet }}
**Suspicious IP:** {{ $('Define Mission Constants').item.json.suspicious_ip }}

**SI Assessment:** {{ $('Parse SI Output').item.json.classification }} (Confidence: {{ $('Parse SI Output').item.json.confidence }}%)
**SI Summary:** {{ $('Parse SI Output').item.json.summary }}

**CTI Context:**
{{ JSON.stringify($('Merge CTI from all IPs together').item.json) }}
```

Execute.

> **Repetition Task:** Add `slack_alert_short` with a one-line alert.
> 
> **Check Your Understanding**
> 
> Question: Why format Markdown here instead of asking the model for Markdown in Part 2?
> 
> Hint: What the IF node needs.

## Validation

**Objective:** Run the workflow and keep the report.

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
  -> SI Triage Agent
  -> Parse SI Output
  -> Is Threat Malicious?
  -> Format IR Ticket
```

- Personal n8n login; workflow name includes your last name.
- IP extract uses a small local chat model (`4b` or `8b`). Triage uses a larger local chat model. Both go through LiteLLM.
- CTI lookups hit `https://cti.<team-domain>/api/v1/ip/{ip}`.
- `SI Triage Agent` returns JSON only.
- `Is Threat Malicious?` uses classification **and** confidence threshold.
- `Format IR Ticket` produces `markdown_report`.

## Export

**Objective:** Save the workflow JSON under your name.

Save, export JSON as `Build an Agentic Workflow-[YourLastName].json`, screenshot the canvas, copy `markdown_report`. Leave this export untouched after you save it.

## Self-Check Appendix

Use after you attempt the questions.

### Part 1

**Step 1:** **Executions** is the audit log.

**Step 2:** String thresholds break numeric compares. Typed numbers evaluate correctly.

**Step 3:** Binary read is generic; extractors specialize.

**Step 4:** Enable **Continue On Fail** so a dead intel feed does not drop the evidence path.

**Step 5:** Linear flow keeps prior nodes easy to reference. Parallel needs **Merge**.

**Step 7 Q1:** Ask for all IOC types and return `{"ips": [], "domains": [], "hashes": []}`.

**Step 7 Q2:** **Switch** after split; route by type; merge before triage.

### Part 2

**Step 1:** Swap the model node without rewriting prompts.

**Step 2:** Low Max Tokens truncates JSON.

**Step 3:** Models prepend "Here is the JSON," which breaks parsers.

**Step 4:** Shared GPU inference needs queueing and concurrency limits; pick the lighter model id for bulk extract.

### Part 3

**Step 1:** Continue On Fail → correction prompt → retry, then escalate.

**Step 2:** **False** branch. Log it in production.

**Step 3:** JSON first for routing; Markdown after the decision.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.