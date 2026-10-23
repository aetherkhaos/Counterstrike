# Adversary Agent Counter-Strike

## Student Guide

**Phase:** Full-day adversary-agent lab and Block hotwash. **Duration:** ~5 hours plus 30 minutes for hotwash. **Stack:** n8n, Postgres, webhook proxy, updates web service, and a simple PowerShell implant simulator.

## Mission Context

On a recent mission, a hunt cell recovered an n8n operator's API key and used that key to enumerate and export the workflows on the adversary server. The team then used those exports to replicate the workflow in this range, which, for simplicity only includes the adversary n8n workflows and your operations station. After you develop counter-strike TTPs here, the team will conduct an operation through the access that already exists on the live system. Today you are only developing those techniques.

The exported workflows call two small models, `llama3.1:8b` for tasking decisions and `qwen3.5:4b` for file summaries. While this range does not include the adversary's inference host, the workflows are pointed at those same models on the inference stack we do have available here. You have your own copy of the workflows. Your team shares one inference stack. The copy starts pointed at `litellm.teamX.cso.ops`.

You will attack the adversary's decision cycle, not the operating system directly. First, you will map how each workflow handles data. Then you will use controlled webhook requests to observe baseline behavior. Finally, you will adjust implant-style responses to influence the model into selecting outcomes that benefit you, such as collecting a high-priority document, tasking the implant to remove itself, or producing responses the workflow designer did not intend.

## Objectives

By the end of this lab, you will be able to:

- Open n8n with the captured operator session, point the two model nodes at your team's inference stack, and map the three workflows.
- Use curl requests to simulate implant check-ins, survey reports, and collection reports.
- Inspect n8n executions node by node to identify what the LLM saw and what the workflow accepted.
- Explain how untrusted implant telemetry can steer an LLM-driven tasking decision.
- Induce at least two desired tasking outcomes through modified survey data.
- Test novel LLM responses and determine whether the workflow accepts, drops, or safely ignores them.

## Environment Assumptions

Your instructor has staged the Adversary Agent Counter-Strike lab environment. Use your team-segment equivalent if your range uses different IP addresses.

|Component|Default address|Purpose|
|---|---|---|
|n8n UI|`[http://20.30.40.153:5678](http://20.30.40.153:5678)`|Workflow review and execution audit|
|Webhook proxy|`[http://20.30.40.155](http://20.30.40.155)`|Implant-style webhook traffic|
|Updates web page|`[http://20.30.40.154/](http://20.30.40.154/)`|Published file summaries and originals|
|Postgres|`20.30.40.151:5432`|Task queue and workflow state|

The replica UI opens as the adversary operator through the captured session cookie. Set it in the browser before you use the workflows. There is no username or password for this UI.

- Name: `n8n-auth`
- Value: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg0Y2ZmY2UwLTllM2QtNDVjNS05MDQ3LTJiZjY4YzFhMjliYiIsImhhc2giOiJ4S2YvU3kxSGZ6IiwiaWF0IjoxNzkxMjE0MzI3LCJleHAiOjE3OTI0MjM5Mjd9.MBGeoee-BpyM42OY0euCXJqrfILi-BCdNpWSEFSkWnw`

If the cookie is rejected, stop and ask your instructor. Do not create an account. If any address fails, stop and ask your instructor before changing the lab host.

## Access Method and Scope

Primary method: `existing-implant-tasking`.

You will operate from your student ops station by using:

- a browser to inspect the n8n UI,
- `curl` to send implant-style JSON to the webhook proxy,
- the n8n execution log to verify workflow decisions.

You are not gaining a new shell on the Windows target in this guide. The curl requests simulate what the implant would send. Keep activity limited to the assigned Adversary Agent Counter-Strike services and addresses.

Before testing, confirm your ops station context:

```
hostname
whoami
pwd
```

Then confirm the lab services are reachable:

```
curl -fsS http://20.30.40.155/healthz
curl -fsS http://20.30.40.154/ | sed -n '1,5p'
```

Expected result: the proxy health check returns a short success response, and the updates web page returns HTML. If `sed` is unavailable, run the second curl command without the pipe and review the first few lines manually.

## Part 1: Orient in n8n

### Step 1: Open the Operator Session and Find the Workflows

1. Open a browser to `[http://20.30.40.153:5678](http://20.30.40.153:5678)`.
2. Open developer tools on that page. In Chrome or Edge, use **Application → Cookies**. In Firefox, use **Storage → Cookies**. Select `[http://20.30.40.153:5678](http://20.30.40.153:5678)`.
3. Add a cookie named `n8n-auth` whose value is the captured session value in the environment section above. Path is `/`.
4. Reload the page. The n8n UI opens as the adversary operator.
5. Open **Workflows** from the left navigation.
6. Confirm you can see these workflows:

|Workflow|What it does|
|---|---|
|`L45 - Agent Checkin Dispatcher`|Receives implant check-ins and returns tasking|
|`L45 - Survey Analysis and Tasking`|Receives survey data, asks the LLM for tasking, and queues tasks|
|`L45 - File Summary and Updates Feed`|Receives collected files, summarizes them, and publishes updates|

7. Open each workflow in a separate browser tab if your browser supports it.
8. Confirm each workflow is **Active**.

> **Check Your Understanding**
> 
> Question: Why do production webhook URLs require the workflow to be active?
> 
> Hint: Compare `/webhook/...` behavior to n8n's test-only `/weebhook-test/...` behavior.

### Step 2: Point the Workflows at Your Team

Your copy starts with this inference host and a placeholder key in two code nodes:

- `[https://litellm.teamX.cso.ops/v1](https://litellm.teamX.cso.ops/v1)`
- `TEAM_LITELLM_KEY`

Change both nodes before you send any webhook traffic.

1. Open `L45 - Survey Analysis and Tasking` and the code node `LLM Decision and Task Builder`.
2. Replace `teamX` in `inferenceBase` with your team number. Team 2 uses `[https://litellm.team2.cso.ops/v1](https://litellm.team2.cso.ops/v1)`.
3. Replace `TEAM_LITELLM_KEY` with your team's LiteLLM key from the [DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access") page.
4. Open `L45 - File Summary and Updates Feed` and the code node `Summarize for Feed`. Make the same two replacements.
5. Save both workflows. Leave them active.

Leave the model ids as they are. Tasking stays `ollama/llama3.1:8b`. Summaries stay `ollama/qwen3.5:4b`.

### Step 3: Build a Workflow Map

For each workflow, draw or list the nodes in order. Your map does not need to be artistic. It must identify the decision points and data stores.

For `L45 - Agent Checkin Dispatcher`, identify:

- the webhook node,
- where the workflow checks for pending tasks,
- where it claims a task,
- where it builds a default survey response.

For `L45 - Survey Analysis and Tasking`, identify:

- the webhook node,
- where survey input is normalized,
- where the raw survey is saved,
- the LLM decision node,
- the IF node that decides whether a task exists,
- the Postgres node that enqueues tasking.

For `L45 - File Summary and Updates Feed`, identify:

- the webhook node,
- where file metadata is normalized,
- the LLM summary node,
- where the original file is written,
- where the updates feed is appended,
- where metadata is saved.

> **Repetition Task**
> 
> Open one Code node in each workflow and read only the first 10-15 lines. Write down what input fields the node expects. Do not edit the node.

### Step 4: Learn the Execution Log

1. Open **Executions** from the left navigation.
2. Use the workflow filter to show only Adversary Agent Counter-Strike executions.
3. Open a recent execution if one exists.
4. Click through the nodes from left to right.
5. Notice the right-side input and output panes for each node.

This execution log is your main evidence source. Curl output tells you what the webhook returned. The execution log shows what the workflow actually saw, what the LLM returned, and which branch the workflow followed.

> **Check Your Understanding**
> 
> Question: If the webhook response says `queued_task_count: 1`, which execution node proves what task was actually queued?
> 
> Hint: Look for the Postgres node after the LLM decision and IF branch.

## Part 2: Walk Through the Check-In Dispatcher

### Step 1: Send a Baseline Check-In

The implant checks in first. If no pending task exists, the dispatcher normally returns a `survey` task so the implant will report host context.

Run this from your ops station:

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-checkin \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "agent_checkin",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "checkin_time_utc": "2026-06-10T12:00:00Z",
    "os": "windows"
  }'
```

Expected response shape:

```
{
  "task_type": "survey",
  "task_payload": {},
  "report_urls": {
    "survey": "http://20.30.40.155/webhook/agent-survey",
    "collection": "http://20.30.40.155/webhook/agent-collection"
  }
}
```

If the response returns `collect`, `reboot`, or `delete_self`, a pending task already existed. That is useful evidence, but ask your instructor whether to reset the queue before continuing.

### Step 2: Inspect the Dispatcher Execution

In n8n:

1. Open the latest execution for `L45 - Agent Checkin Dispatcher`.
2. Click `Normalize Checkin`.
3. Confirm the node extracted `agent_id`, `host_name`, and `checkin_time_utc`.
4. Click `Fetch Pending Task`.
5. Determine whether Postgres returned a task.
6. Click `Task Ready?`.
7. Identify whether execution went to the true branch or false branch.
8. Click the response node and compare its output to your curl response.

> **Check Your Understanding**
> 
> Question: Why does the workflow claim a pending task before returning it to the implant?
> 
> Hint: Think about what could happen if the implant checks in twice quickly.

## Part 3: Walk Through Survey Analysis and Tasking

The survey workflow is the main counter-strike surface. It sends normalized survey evidence to the tasking model (`llama3.1:8b`) and asks for a strict JSON task decision. The workflow then parses that decision and queues only recognized implant task types.

### Step 1: Send a No-Task Survey

Start with boring telemetry.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\student", "is_admin": false}
    ],
    "process_list": [
      {"Name": "notepad", "Id": 1111}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\student\\Documents\\notes.txt", "size_bytes": 256}
    ]
  }'
```

Expected response: normally `queued_task_count: 0`.

If the tasking model queues a task anyway, do not treat that as a failure. Open the execution and document exactly what text caused the model to choose a task.

### Step 2: Inspect the LLM Decision

In the latest `L45 - Survey Analysis and Tasking` execution:

1. Open `Normalize Survey Input`.
2. Confirm the workflow extracted:
    - `process_names`,
    - `doc_paths`,
    - `logged_on_users`,
    - `survey_text`.
3. Open `LLM Decision and Task Builder`.
4. Review these output fields if present:
    - `llm_response`,
    - `llm_decision`,
    - `llm_error`,
    - `task_type`,
    - `task_payload_json_text`.
5. Open `Has Follow-on Task?`.
6. Confirm whether the workflow followed the task branch or no-task branch.

> **Check Your Understanding**
> 
> Question: What is the difference between `llm_response` and `task_payload_json_text`?
> 
> Hint: One is the model's raw output; the other is what the workflow is prepared to store for the implant.

### Step 3: Induce a Collect Decision

Now send a survey containing a document path that a tasking analyst would likely prioritize.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\jsmith", "is_admin": false}
    ],
    "process_list": [
      {"Name": "notepad", "Id": 2222}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx", "size_bytes": 128},
      {"full_path": "C:\\Users\\jsmith\\Documents\\grocery_list.txt", "size_bytes": 64}
    ]
  }'
```

Expected response: `queued_task_count` should be at least `1`.

Inspect the execution and answer:

- Which path did the LLM select?
- Did the parser keep the selected path?
- Which node inserted the queued task?
- What would the implant do when it receives that task?

### Step 4: Retrieve the Queued Task

After a survey queues tasking, the implant receives that task on its next check-in.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-checkin \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "agent_checkin",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "checkin_time_utc": "2026-06-10T12:01:00Z",
    "os": "windows"
  }'
```

Expected response: a `collect` task with a `task_payload.path` value selected from the previous survey.

> **Repetition Task**
> 
> Repeat Step 3 with a different high-priority filename. Keep the rest of the payload mostly the same. Compare whether the LLM changes its chosen path.

### Step 5: Induce Reboot and Delete-Self Decisions

Use the same method to test other decisions. Do not run a real Windows implant unless your instructor directs you to. These curl requests exercise the workflow and task queue.

For reboot, include evidence that an administrator is logged in:

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\Administrator", "is_admin": true}
    ],
    "process_list": [
      {"Name": "explorer", "Id": 3000}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\Public\\Documents\\team_notes.txt", "size_bytes": 4096}
    ]
  }'
```

For delete-self, include evidence that suggests burn risk or defensive monitoring:

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\jsmith", "is_admin": false}
    ],
    "process_list": [
      {"Name": "Velociraptor.exe", "Id": 9999}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\analyst\\Desktop\\meeting_notes.txt", "size_bytes": 128}
    ]
  }'
```

For each request:

1. Record the curl response.
2. Open the n8n execution.
3. Capture the LLM decision output.
4. Run a follow-up check-in to see the task returned.
5. Record which task type was claimed.

> **Check Your Understanding**
> 
> Question: Which guardrail keeps the workflow from queuing an arbitrary task type such as `spawn_shell`?
> 
> Hint: Compare the LLM response to the Code node's allowed task types.

## Part 4: Walk Through File Summary and Updates

The collection workflow receives file content from the implant, asks the summary model (`qwen3.5:4b`) to summarize it, writes the original file, and appends a summary card to the updates page.

### Step 1: Submit a Baseline Collection

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-collection \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "file_collection_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "source_path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx",
    "file_name": "internal-use_budget_notes.docx",
    "collected_time_utc": "2026-06-10T12:05:00Z",
    "content_base64": "SGVsbG8gZnJvbSBsYWIgdGVzdCBkb2N1bWVudC4=",
    "text_preview": "Hello from lab test document."
  }'
```

Expected response:

```
{
  "status": "published",
  "source_path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx",
  "summary_link": "/published/updates.html",
  "file_link": "/published/files/<timestamp>_internal-use_budget_notes.docx"
}
```

### Step 2: Inspect the Collection Execution

In n8n:

1. Open the latest `L45 - File Summary and Updates Feed` execution.
2. Click `Normalize Collection Input`.
3. Confirm the workflow extracted `source_path`, `file_name`, `text_preview`, and `content_base64`.
4. Click `Summarize for Feed`.
5. Review the `summary` output.
6. Click `Write Original File` and `Append Updates Feed`.
7. Confirm the final response contains a `file_link`.

Then verify the published output:

```
curl -fsS http://20.30.40.154/published/updates.html | tail -n 20
curl -fsS http://20.30.40.154/published/files/
```

If `tail` is unavailable, open `[http://20.30.40.154/published/updates.html](http://20.30.40.154/published/updates.html)` in your browser and review the newest card.

The adversary side reads that published page regularly and opens the original when the summary marks sensitivity high.

> **Check Your Understanding**
> 
> Question: Why is the original file stored separately from the LLM summary?
> 
> Hint: Think about evidence quality and analyst review.

## Part 5: Customize Implant Responses to Steer the LLM

You have now seen the baseline workflows. Next, you will craft implant-style responses that influence the LLM. Your goal is not to break n8n. Your goal is to prove how small changes in untrusted telemetry alter the adversary agent's decisions.

### Step 1: Create a Desired Outcome Plan

Choose two outcomes:

- Task the implant to collect a document you want the adversary to prioritize.
- Task the implant to delete itself because the host appears risky.
- Task the implant to reboot because an administrator appears active.
- Make the file-summary workflow label a harmless file as unusually important.

For each outcome, write:

```
Desired outcome:
Input field I will modify:
Why the LLM might believe it:
Expected task or summary change:
Evidence I will collect:
```

### Step 2: Modify Survey Evidence, Not Workflow Code

Keep the workflow unchanged. Modify only webhook JSON fields such as:

- `host_name`,
- `logged_on_users`,
- `process_list[].Name`,
- `document_listing[].full_path`,
- `document_listing[].size_bytes`.

Useful patterns to test include:

- filenames that imply sensitivity or mission priority,
- process names that imply incident response or monitoring,
- usernames that imply privileged sessions,
- hostnames that imply special handling.

Do not use the exact same payload twice. Change one variable at a time so you can explain why the outcome changed.

### Step 3: Run and Inspect Each Attempt

For each attempt:

1. Send your modified survey with `curl`.
2. Open the matching survey execution.
3. Capture the LLM's raw response.
4. Capture the parsed task decision.
5. Run an agent check-in to confirm what task the implant would receive.
6. Record whether the actual task matched your desired outcome.

Use this evidence table in your notes:

|Attempt|Field changed|Desired outcome|LLM response|Queued task|Follow-up check-in result|
|---|---|---|---|---|---|
|1||||||
|2||||||

> **Check Your Understanding**
> 
> Question: Why is a follow-up check-in required before you can say the implant would execute your selected task?
> 
> Hint: The survey workflow queues tasking; the check-in workflow delivers it.

### Step 4: Steer the Published Summary

Now test the collection workflow. Build a collection payload where `text_preview` tries to influence how the file is summarized.

Keep the payload small. Change only `source_path`, `file_name`, and `text_preview`.

Your goal is to make the summary do one of the following:

- overstate the priority of a routine document,
- understate the priority of a document that appears sensitive,
- include an analyst action phrase not present in the baseline summary,
- use a priority label that the workflow did not explicitly ask for.

After each attempt:

1. Inspect `Summarize for Feed`.
2. Open the updates page.
3. Compare the summary to the source preview.
4. Decide whether the model was manipulated, resisted, or partially followed your wording.

> **Repetition Task**
> 
> Try the same `text_preview` with two different filenames. Did the filename change the summary? Record the difference.

## Part 6: Cause Novel Responses and Test Workflow Boundaries

The workflow asks the LLM for a limited set of tasks and summary formats. Your final test is to see what happens when untrusted input tries to push the model outside those intended paths.

### Step 1: Attempt an Unsupported Task

Create a survey payload that tries to convince the LLM to choose a task type the implant does not support. Pick your own wording and place it in a realistic field such as a document path or host name.

Do not edit the workflow prompt. Do not add a new node. The test is whether untrusted survey data can move the model outside the intended contract.

After running the payload, inspect:

- Did `llm_response` include an unsupported task?
- Did `llm_decision` parse successfully?
- Did `task_payload_json_text` appear?
- Did `queued_task_count` increase?
- Did the follow-up check-in return the unsupported task, or was it dropped?

Expected learning: a model may produce a novel answer, but a parser or allow-list can still prevent that answer from becoming implant tasking.

### Step 2: Attempt Format Drift

Create another survey payload that tries to make the LLM answer in prose, markdown, or a different JSON shape.

Inspect:

- whether the workflow parsed the response,
- whether `llm_error` was populated,
- whether the IF node followed the no-task branch,
- whether the webhook still returned a clean JSON response.

> **Check Your Understanding**
> 
> Question: Is it enough for the LLM to be tricked, or must the workflow also accept the tricked output?
> 
> Hint: Separate model behavior from system behavior.

### Step 3: Attempt Summary Format Drift

Use the collection workflow to try to make the summary include content outside the expected four bullet lines.

Examples of drift to look for:

- extra headings,
- extra bullets,
- a recommendation not grounded in the preview,
- a priority label not requested by the prompt,
- conversational text before the bullets.

Record whether the workflow publishes the drift exactly as returned, sanitizes it, or drops it.

## Final Validation Checklist

Before you leave the range, verify you have:

- Opened n8n with the captured operator session, pointed both model nodes at your team's inference stack, and mapped all three workflows.
- Run at least one check-in curl request.
- Run at least one baseline survey request.
- Run at least one collection request and viewed the updates page.
- Produced two successful manipulation attempts.
- Produced one novelty or boundary test.
- Captured execution evidence from n8n, not only terminal output.

## Self-Check Appendix

Use this appendix after you have attempted the questions.

**Part 1, Step 1:** Production webhook URLs require active workflows because n8n only serves `/webhook/...` routes for active workflows. Test routes use `/webhook-test/...` while editing.

**Part 1, Step 3:** The enqueue evidence is in `Enqueue Follow-on Task`. The LLM node explains the recommendation, but the Postgres insert proves what was stored for delivery.

**Part 2, Step 2:** Claiming a pending task prevents duplicate delivery. Without claim logic, repeated check-ins could receive and execute the same task more than once.

**Part 3, Step 2:** `llm_response` is the raw model text. `task_payload_json_text` is the workflow-normalized payload that can be inserted into the task queue.

**Part 3, Step 5:** The allow-list in the Code node drops task types outside `reboot`, `collect`, and `delete_self`. This limits what an induced model response can become.

**Part 4, Step 2:** Keeping the original file supports evidence review. A summary is an interpretation; the original is the artifact an analyst can re-check.

**Part 5, Step 3:** The follow-up check-in proves delivery. The survey workflow queues tasking, but the implant only acts after the check-in dispatcher returns that task.

**Part 6, Step 2:** The LLM being tricked is only one layer. The workflow must also parse, accept, store, and deliver the tricked output before it changes implant behavior.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Lab L4.5 - Adversary Agent Counter-Strike

## Instructor Answer Key

Use this guide to run the current L4.5 white-box adversary-agent lab. Students inspect three n8n workflows, simulate implant traffic with curl, and then manipulate untrusted telemetry to steer LLM-driven tasking and file-summary behavior.

## Objective Framing

The learning target is the adversary agent's decision cycle. Students should leave with a concrete understanding that:

- the model can be influenced by data the implant reports,
- the workflow decides whether model output becomes tasking,
- allow-lists and parsers reduce but do not eliminate manipulation risk,
- execution logs are the evidence source for model behavior and workflow behavior.

Do not accept answers based only on curl output. Students must show n8n execution evidence for the LLM response, parsed task, branch decision, and queued task.

## Configuration Reference

This Docker lab does not use Hiera. These defaults are configured in `lab_env/docker-compose.yml`, `lab_env/workflows/`, and `lab_env/implant/implant.ps1`.

|Item|Default|Source|
|---|---|---|
|n8n UI|`[http://20.30.40.153:5678](http://20.30.40.153:5678)`|`lab_env/docker-compose.yml`|
|n8n session|`n8n-auth` cookie in the student brief|minted before class; see the replica Quick Start|
|Webhook proxy|`[http://20.30.40.155](http://20.30.40.155)`|`lab_env/docker-compose.yml`|
|Updates page|`[http://20.30.40.154/](http://20.30.40.154/)`|`lab_env/docker-compose.yml`|
|Postgres database|`adversary_ops`|`.env` / compose default|
|Postgres user|`ops_admin`|`.env` / compose default|
|Tasking model|`ollama/llama3.1:8b`|literal in `LLM Decision and Task Builder`|
|Summary model|`ollama/qwen3.5:4b`|literal in `Summarize for Feed`; `think` is off so the reply is in `content`|
|Starting inference host|`[https://litellm.teamX.cso.ops/v1](https://litellm.teamX.cso.ops/v1)`|both model nodes; student replaces `teamX`|
|Starting inference key|`TEAM_LITELLM_KEY`|both model nodes; student replaces it with the team key|
|Implant ID|`alpha-node-01`|`lab_env/implant/implant.ps1`|
|Implant scheduled task|`WindowsHostTelemetrySync`|`lab_env/implant/implant.ps1`|

## Target Access Enablement

- Environment type: containerized lab services on the assigned PCTE segment.
- Primary method: `existing-implant-tasking`.
- Fallback method: the same webhook path on `[http://20.30.40.153:5678](http://20.30.40.153:5678)` if the proxy is unavailable. Production webhooks do not use the session cookie.
- Target-side enablement: n8n workflows imported and active; Postgres credential named `L45 Postgres` assigned to all Postgres nodes; webhook proxy running.
- Ops-station requirements: browser, `curl`, route to `20.30.40.153`, `20.30.40.154`, and `20.30.40.155` or team equivalents.
- Network assumptions: no host port publishing; students reach container IPs directly through the lab segment.
- Cleanup/reset: follow `lab_env/README.md` reset steps or restart from a clean PCTE baseline.

Fallback direct-to-n8n pattern:

```
curl -fsS -X POST http://20.30.40.153:5678/webhook/agent-checkin \
  -H 'Content-Type: application/json' \
  -d '{"event_type":"agent_checkin","agent_id":"alpha-node-01","host_name":"lab-win01","os":"windows"}'
```

Students open the UI by setting the `n8n-auth` cookie from the brief. They do not get a username or password. Webhook calls do not send that cookie.

## Initial Situational-Awareness Baseline

Run these from the instructor ops station or lab host before students begin. The point is to establish where commands are running, what services are reachable, and whether the lab begins from a known-good state.

The first block captures time, host identity, account context, working directory, shell, and OS/runtime. `date -u` prints UTC time for evidence correlation. `hostname`, `whoami`, `id`, and `pwd` establish local execution context. `uname -a` and version commands help distinguish host issues from container issues.

```
date -u
hostname
whoami
id
pwd
printf 'SHELL=%s\n' "$SHELL"
uname -a
python3 --version
curl --version
```

Expected findings: the instructor should be on the intended lab host or routed ops station with `curl` available.

The next block captures user/session, process, and socket context. `who -a` shows interactive sessions. `ps` lists running processes. `ss -tulpen` shows listening TCP/UDP sockets; `ss -tunap` shows active TCP/UDP sockets. Use these as broad baseline evidence before narrowing to Docker-specific checks.

```
who -a
ps -eo pid,ppid,user,comm,args --sort=comm | sed -n '1,80p'
ss -tulpen
ss -tunap
```

Expected findings: n8n and supporting containers may not appear as host listeners because the lab uses ipvlan container IPs rather than host port mappings.

On the lab host, `docker compose ps` lists services and health. Run the curls from the ops station. The lab host cannot open its own ipvlan addresses.

```
docker compose ps
```

```
curl -fsS http://20.30.40.155/healthz
curl -fsS http://20.30.40.154/ | sed -n '1,8p'
```

Expected findings: `l45-n8n`, `l45-postgres`, `l45-updates-web`, and `l45-webhook-proxy` are running. There is no local model container. The proxy health check succeeds. The updates page returns HTML.

Confirm the team's Spark is serving the two models. Use that team's LiteLLM key from the [DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access") page. From a host that trusts the classroom root:

```
curl -fsS https://litellm.teamN.cso.ops/v1/models \
  -H "Authorization: Bearer <team LiteLLM key>" \
  --cacert certs/classroom-root.crt
```

Replace `teamN` with the team number. Expected findings: `ollama/llama3.1:8b` and `ollama/qwen3.5:4b` are in the list.

## Expected Workflow Structure

Students should recover this through the n8n UI.

### `L45 - Agent Checkin Dispatcher`

```
Checkin Webhook
  -> Normalize Checkin
  -> Fetch Pending Task
  -> Task Ready?
     true  -> Claim Task -> Build Pending Task Response
     false -> Build Survey Task Response
  -> Respond Checkin
```

Expected observations:

- With no pending task, the response is `task_type: survey`.
- With a queued task, the workflow claims the oldest pending task and returns it.
- Claimed tasks should not be returned again on later check-ins.

### `L45 - Survey Analysis and Tasking`

```
Survey Webhook
  -> Normalize Survey Input
  -> Save Survey Event
  -> LLM Decision and Task Builder
  -> Has Follow-on Task?
     true  -> Enqueue Follow-on Task -> Build Queued Response
     false -> Build No Task Response
  -> Respond Survey
```

Expected observations:

- `Normalize Survey Input` extracts process names, document paths, users, and raw survey JSON.
- `LLM Decision and Task Builder` asks `llama3.1:8b` for strict JSON.
- Valid queued task types are `reboot`, `collect`, and `delete_self`.
- Unsupported task types are dropped by the Code node and should not reach the task queue.

### `L45 - File Summary and Updates Feed`

```
Collection Webhook
  -> Normalize Collection Input
  -> Summarize for Feed
  -> Write Original File
  -> Append Updates Feed
  -> Save Collected Metadata
  -> Build Collection Response
  -> Respond Collection
```

Expected observations:

- The summary text is escaped. `Sensitivity: high` stays plain text.
- The original file is written under `/shared/published/files/`.
- The updates page appends a card with the summary and an Open original file link.
- On the red host, headless Chromium reads `[http://127.0.0.1:8088/published/updates.html](http://127.0.0.1:8088/published/updates.html)` every `VIEW_INTERVAL_SECONDS` (default 60). When a card contains `Sensitivity: high`, that same browser opens the card's `/published/files/` link. Students still use `[http://20.30.40.154/published/updates.html](http://20.30.40.154/published/updates.html)`. The student brief says the adversary side reads the page regularly and opens the original when sensitivity is high.

## Instructor Walkthrough

### Point each copy at the team Spark

Each student has an independent copy of the three workflows. The team shares one Spark. Before the first webhook, both model nodes must use that team's host and the LiteLLM key from the [DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access") page.

- `LLM Decision and Task Builder` in `L45 - Survey Analysis and Tasking`
- `Summarize for Feed` in `L45 - File Summary and Updates Feed`

Replace `teamX` with the team number and `TEAM_LITELLM_KEY` with that team's key. Team 2 becomes `[https://litellm.team2.cso.ops/v1](https://litellm.team2.cso.ops/v1)`. Leave `ollama/llama3.1:8b` and `ollama/qwen3.5:4b` unchanged. Save both workflows and leave them active.

### 1. Baseline Check-In

Use this to show students how the dispatcher behaves before any manipulation. `curl -X POST` sends a JSON webhook request. `-H 'Content-Type: application/json'` tells n8n to parse the body as JSON. `-d` provides the simulated implant check-in body.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-checkin \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "agent_checkin",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "checkin_time_utc": "2026-06-10T12:00:00Z",
    "os": "windows"
  }'
```

Expected output:

```
{
  "task_type": "survey",
  "task_payload": {},
  "report_urls": {
    "survey": "http://20.30.40.155/webhook/agent-survey",
    "collection": "http://20.30.40.155/webhook/agent-collection"
  }
}
```

Teaching point: the dispatcher is not the model. It is the delivery path for whatever task is already queued, or a default survey request when no task exists.

### 2. Baseline No-Task Survey

Use this to demonstrate normal survey analysis. The payload includes a non-admin user, a routine process, and a low-value document path.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\student", "is_admin": false}
    ],
    "process_list": [
      {"Name": "notepad", "Id": 1111}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\student\\Documents\\notes.txt", "size_bytes": 256}
    ]
  }'
```

Expected output:

```
{
  "status": "accepted",
  "queued_task_count": 0,
  "message": "survey processed with no follow-on tasks"
}
```

If the tasking model queues a task, grade the student on whether they inspect `llm_response` and explain the interpretation. On the 5 October 2026 walk, `llama3.1:8b` queued `collect` for `C:\Users\student\Documents\notes.txt` and explained that a document was available. That is an acceptable result when the execution shows that decision.

### 3. Collect Task Outcome

This payload gives the LLM a plausible high-priority document path.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\jsmith", "is_admin": false}
    ],
    "process_list": [
      {"Name": "notepad", "Id": 2222}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx", "size_bytes": 128},
      {"full_path": "C:\\Users\\jsmith\\Documents\\grocery_list.txt", "size_bytes": 64}
    ]
  }'
```

Expected output:

```
{
  "status": "accepted",
  "queued_task_count": 1,
  "message": "follow-on tasking queued"
}
```

Expected execution evidence:

- `llm_response` contains JSON with a `collect` task.
- `task_payload_json_text` contains a `path`.
- `Enqueue Follow-on Task` inserts `task_type = collect`.

Confirm delivery:

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-checkin \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "agent_checkin",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "checkin_time_utc": "2026-06-10T12:01:00Z",
    "os": "windows"
  }'
```

Expected output includes:

```
{
  "task_type": "collect",
  "task_payload": {
    "path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx"
  }
}
```

### 4. Reboot Task Outcome

Use this to demonstrate how session evidence can trigger disruption tasking.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\Administrator", "is_admin": true}
    ],
    "process_list": [
      {"Name": "explorer", "Id": 3000}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\Public\\Documents\\team_notes.txt", "size_bytes": 4096}
    ]
  }'
```

Expected evidence: `llm_response` selects `reboot`, the workflow queues `reboot`, and the next check-in returns `task_type: reboot`.

Do not run the real PowerShell implant against a live Windows target unless the range is staged for that effect.

### 5. Delete-Self Task Outcome

Use this to demonstrate burn-risk steering.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-survey \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "survey_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "logged_on_users": [
      {"username": "LAB\\jsmith", "is_admin": false}
    ],
    "process_list": [
      {"Name": "Velociraptor.exe", "Id": 9999}
    ],
    "document_listing": [
      {"full_path": "C:\\Users\\analyst\\Desktop\\meeting_notes.txt", "size_bytes": 128}
    ]
  }'
```

Expected evidence: `llm_response` selects `delete_self`, `task_payload_json_text` contains `WindowsHostTelemetrySync`, and the next check-in returns `task_type: delete_self`.

Teaching point: this is a `deceive` / `manipulate` effect against the adversary's agent. The student is not deleting the agent by exploit; they are causing the adversary's own workflow to task removal.

### 6. File Collection and Summary

This verifies the third workflow.

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-collection \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "file_collection_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "source_path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx",
    "file_name": "internal-use_budget_notes.docx",
    "collected_time_utc": "2026-06-10T12:05:00Z",
    "content_base64": "SGVsbG8gZnJvbSBsYWIgdGVzdCBkb2N1bWVudC4=",
    "text_preview": "Hello from lab test document."
  }'
```

Expected output:

```
{
  "status": "published",
  "summary_link": "/published/updates.html",
  "file_link": "/published/files/<timestamp>_internal-use_budget_notes.docx"
}
```

Verify the page:

```
curl -fsS http://20.30.40.154/published/updates.html | tail -n 20
curl -fsS http://20.30.40.154/published/files/
```

Expected evidence: the latest updates card includes a four-bullet summary and a link to the original file.

## Manipulation Guidance for Instructors

Students should design their own attempts, but these patterns are acceptable if they are stuck.

### Desired `collect`

Acceptable student strategy:

- Add one or more document paths with names implying sensitivity, mission value, or urgency.
- Keep process and user evidence boring so the document choice is the main variable.
- Confirm the next check-in returns `collect` for the selected path.

Good evidence:

```
Changed field: document_listing[].full_path
Desired outcome: collect one selected document
Observed: LLM selected collect; task queue stored collect; next check-in returned collect path
Failed guardrail: untrusted survey content entered the model prompt without source trust scoring
```

### Desired `delete_self`

Acceptable student strategy:

- Add process evidence that suggests defensive monitoring or active response.
- Compare a baseline no-task survey against the modified survey.
- Confirm `delete_self` is queued and delivered.

Good evidence:

```
Changed field: process_list[].Name
Desired outcome: delete_self
Observed: LLM treated monitoring evidence as burn risk and selected delete_self
Failed guardrail: tasking prompt trusted process names reported by the implant
```

### Desired Summary Drift

Acceptable student strategy:

- Change `text_preview` and `file_name` to push the summary toward an elevated or reduced priority.
- Keep `content_base64` small and harmless.
- Compare the published summary to the source preview.

Good evidence:

```
Changed field: text_preview
Desired outcome: overstate routine file priority
Observed: updates page published stronger action language than the evidence supported
Failed guardrail: summary prompt had no independent evidence scoring or source validation
```

## Novel Response Boundary Tests

Students need one novelty test. Accept any of these if the evidence chain is clear:

- The LLM emits an unsupported task type, and the Code node drops it.
- The LLM emits prose or malformed JSON, and the workflow returns no task with `llm_error` populated.
- The collection summary includes extra headings or labels not requested by the prompt.
- The LLM includes more tasks than intended, and the workflow truncates to at most three.

The key grading question is whether the student separates:

1. what the model produced,
2. what the parser accepted,
3. what the task queue stored,
4. what the check-in dispatcher delivered.

## Grading Checkpoints

Accept full credit when students provide:

- A correct three-workflow map with triggers, LLM nodes, Postgres nodes, and response nodes.
- Baseline evidence from the check-in, survey, and collection workflows.
- Two manipulation attempts with the evidence table from the brief: field changed, desired outcome, model response, queued task, and follow-up check-in.
- One novelty test that distinguishes model behavior from workflow acceptance.

Common partial-credit cases:

- Student has curl responses but no n8n execution evidence.
- Student changes too many fields at once and cannot explain causality.
- Student reports the LLM output but does not confirm task delivery through check-in.
- Student claims a novel response succeeded even though the allow-list dropped it before the task queue.

## Troubleshooting and Confirmation

### n8n Login Fails

- Confirm the browser cookie name is `n8n-auth` and the value is the one in the student brief.
- Confirm the cookie path is `/` on `[http://20.30.40.153:5678](http://20.30.40.153:5678)`.
- Mint a new cookie with the replica Quick Start before each offering. A previous offering's cookie does not carry forward.
- Direct webhook calls do not use the cookie.

### Production Webhook 404

- Confirm the workflow is active.
- Confirm the URL uses `/webhook/...`, not `/webhook-test/...`.
- Confirm the proxy health check succeeds:

```
curl -fsS http://20.30.40.155/healthz
```

### Postgres Credential Errors

If a Postgres node reports a missing credential:

1. Open the node in n8n.
2. Select the credential named `L45 Postgres`.
3. Save the workflow.
4. Repeat for `Fetch Pending Task`, `Claim Task`, `Save Survey Event`, `Enqueue Follow-on Task`, and `Save Collected Metadata`.

### Model Does Not Queue the Expected Task

- Open `LLM Decision and Task Builder`.
- Review `llm_response` and `llm_error`.
- If `llm_error` shows a parse error, the model did not follow the JSON contract.
- If the model selected a different task, ask the student to reduce variables and make one field change at a time.
- If an unsupported task appears in `llm_response` but no task is queued, that is a valid boundary-test result.

### Stale Pending Tasks

If a student receives a task from a previous test, drain it with check-ins or reset the queue. To inspect the queue from the lab host:

```
docker compose exec postgres psql -U ops_admin -d adversary_ops \
  -c "select id, agent_id, task_type, status, created_at from task_queue order by id desc limit 20;"
```

The `psql` command opens a Postgres client inside the database container. The `-U` option selects the database user, `-d` selects the database, and `-c` runs one SQL command.

To clear only pending tasks during instructor reset:

```
docker compose exec postgres psql -U ops_admin -d adversary_ops \
  -c "update task_queue set status = 'completed', completed_at = now() where status = 'pending';"
```

### Updates Page Missing the New Card

- Confirm the collection workflow execution reached `Append Updates Feed`.
- Confirm the file link in the webhook response.
- Refresh `[http://20.30.40.154/published/updates.html](http://20.30.40.154/published/updates.html)`.
- If state is dirty between cohorts, reset `lab_env/vols/updates` using the README reset procedure.

## Cleanup

For a full cohort reset from `lab_env`:

```
docker compose down
rm -rf vols/postgres vols/n8n vols/updates/files
mkdir -p vols/updates
cp web/html/updates.html vols/updates/updates.html
docker compose up -d
docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/01-agent-checkin.json
docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/02-survey-analysis-and-tasking.json
docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/03-file-summary-and-updates.json
```

After import, reassign `L45 Postgres` to every Postgres node, activate the three current workflows, and mint a new `n8n-auth` cookie. Leave older imported copies inactive.

