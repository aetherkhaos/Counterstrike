## Student Guide[](#student-guide)

**Phase:** Day 5 full-day lab and Week 4 hotwash. **Duration:** ~5 hours plus 30 minutes for hotwash. **Stack:** n8n, Postgres, Ollama, webhook proxy, updates web service, and a simple PowerShell implant simulator.

## Mission Context[](#mission-context)

Your hunt cell has identified an adversary workflow that uses a local LLM to task a Windows implant. The implant checks in, receives tasking, reports survey results, and publishes collected-file summaries through three n8n workflows.

Today you will attack the adversary's decision cycle, not the operating system directly. First, you will map how each workflow handles data. Then you will use controlled webhook requests to observe baseline behavior. Finally, you will adjust implant-style responses to influence the LLM into selecting outcomes that benefit you, such as collecting a high-priority document, tasking the implant to remove itself, or producing responses the workflow designer did not intend.

## Objectives[](#objectives)

By the end of this lab, you will be able to:

- Log into n8n and map a three-workflow implant tasking system.
- Use curl requests to simulate implant check-ins, survey reports, and collection reports.
- Inspect n8n executions node by node to identify what the LLM saw and what the workflow accepted.
- Explain how untrusted implant telemetry can steer an LLM-driven tasking decision.
- Induce at least two desired tasking outcomes through modified survey data.
- Test novel LLM responses and determine whether the workflow accepts, drops, or safely ignores them.
- Produce concise evidence notes that tie the observed effect to a failed guardrail.

## Environment Assumptions[](#environment-assumptions)

Your instructor has staged the L4.5 lab environment. Use your team-segment equivalent if your range uses different IP addresses.

|Component|Default address|Purpose|
|---|---|---|
|n8n UI|`http://20.30.40.153:5678`|Workflow review and execution audit|
|Webhook proxy|`http://20.30.40.155`|Implant-style webhook traffic|
|Updates web page|`http://20.30.40.154/`|Published file summaries and originals|
|Ollama|`20.30.40.152:11434`|Local LLM runtime|
|Postgres|`20.30.40.151:5432`|Task queue and workflow state|

Default n8n credentials are:

- Username: `admin@admin.com`
- Password: `1qaz2wsx!QAZ@WSX`

If your instructor rotated the credentials, use the values provided for your range. If any address or credential fails, stop and ask your instructor before changing the lab host.

You can also access the system hosting the lab environment via ssh using your default key:

```
┌──(kali㉿blue-ops)-[~]
└─$ ssh 20.30.40.150                                                  
Linux red-tgt 6.17.10+kali-amd64 #1 SMP PREEMPT_DYNAMIC Kali 6.17.10-1kali1 (2025-12-08) x86_64

The programs included with the Kali GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Kali GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
You have new mail.
┌──(kali㉿red-tgt)-[~]
└─$ cd /opt/cs_ops/week4/lab4.5
                                                                                
┌──(kali㉿red-tgt)-[/opt/cs_ops/week4/lab4.5]
└─$ ls 
lab_env
                                                                                
┌──(kali㉿red-tgt)-[/opt/cs_ops/week4/lab4.5]
└─$ ls lab_env 
db                  implant    save-images.sh  web
docker-compose.yml  README.md  vols            workflows
                                                                                
┌──(kali㉿red-tgt)-[/opt/cs_ops/week4/lab4.5]
└─$ 
```

## Access Method and Scope[](#access-method-and-scope)

Primary method: `existing-implant-tasking`.

You will operate from your student ops station by using:

- a browser to inspect the n8n UI,
- `curl` to send implant-style JSON to the webhook proxy,
- the n8n execution log to verify workflow decisions.

You are not gaining a new shell on the Windows target in this guide. The curl requests simulate what the implant would send. Keep activity limited to the assigned L4.5 services and addresses.

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

## Deliverables[](#deliverables)

Submit the following at the end of the lab:

1. A workflow map covering all three L4.5 workflows.
2. Screenshots or copied execution evidence for one baseline run of each workflow.
3. Two successful manipulation attempts that changed LLM-driven tasking or summary behavior.
4. One novelty test where the LLM produced, attempted, or was asked to produce behavior outside the intended workflow path.
5. A five-line effect report for each manipulation or novelty test.

Use this five-line format:

```
Effect:
Action:
Predicted response:
Observed result:
Burn-risk / failed guardrail:
```

## Part 1: Orient in n8n[](#part-1-orient-in-n8n)

### Step 1: Log In and Find the Workflows[](#step-1-log-in-and-find-the-workflows)

1. Open a browser to `http://20.30.40.153:5678`.
    
2. Log in with the credentials provided by your instructor.
    
3. Open **Workflows** from the left navigation.
    
4. Confirm you can see these workflows:
    
    |Workflow|What it does|
    |---|---|
    |`L45 - Agent Checkin Dispatcher`|Receives implant check-ins and returns tasking|
    |`L45 - Survey Analysis and Tasking`|Receives survey data, asks the LLM for tasking, and queues tasks|
    |`L45 - File Summary and Updates Feed`|Receives collected files, summarizes them, and publishes updates|
    
5. Open each workflow in a separate browser tab if your browser supports it.
    
6. Confirm each workflow is **Active**.
    

> **Check Your Understanding**
> 
> Question: Why do production webhook URLs require the workflow to be active?
> 
> Hint: Compare `/webhook/...` behavior to n8n's test-only `/webhook-test/...` behavior.

### Step 2: Build a Workflow Map[](#step-2-build-a-workflow-map)

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

### Step 3: Learn the Execution Log[](#step-3-learn-the-execution-log)

1. Open **Executions** from the left navigation.
2. Use the workflow filter to show only L4.5 executions.
3. Open a recent execution if one exists.
4. Click through the nodes from left to right.
5. Notice the right-side input and output panes for each node.

This execution log is your main evidence source. Curl output tells you what the webhook returned. The execution log shows what the workflow actually saw, what the LLM returned, and which branch the workflow followed.

> **Check Your Understanding**
> 
> Question: If the webhook response says `queued_task_count: 1`, which execution node proves what task was actually queued?
> 
> Hint: Look for the Postgres node after the LLM decision and IF branch.

## Part 2: Walk Through the Check-In Dispatcher[](#part-2-walk-through-the-check-in-dispatcher)

### Step 1: Send a Baseline Check-In[](#step-1-send-a-baseline-check-in)

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

### Step 2: Inspect the Dispatcher Execution[](#step-2-inspect-the-dispatcher-execution)

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

## Part 3: Walk Through Survey Analysis and Tasking[](#part-3-walk-through-survey-analysis-and-tasking)

The survey workflow is the main counter-strike surface. It sends normalized survey evidence to the local LLM and asks for a strict JSON task decision. The workflow then parses that decision and queues only recognized implant task types.

### Step 1: Send a No-Task Survey[](#step-1-send-a-no-task-survey)

Start with boring telemetry.

```
curl -fsS -X POST http://20.30.40.153/webhook-test/agent-survey \
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

If the local model queues a task anyway, do not treat that as a failure. Open the execution and document exactly what text caused the model to choose a task.

### Step 2: Inspect the LLM Decision[](#step-2-inspect-the-llm-decision)

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

### Step 3: Induce a Collect Decision[](#step-3-induce-a-collect-decision)

Now send a survey containing a document path that a tasking analyst would likely prioritize.

```
curl -fsS -X POST http://20.30.40.153/webhook-test/agent-survey \
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

### Step 4: Retrieve the Queued Task[](#step-4-retrieve-the-queued-task)

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

### Step 5: Induce Reboot and Delete-Self Decisions[](#step-5-induce-reboot-and-delete-self-decisions)

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

## Part 4: Walk Through File Summary and Updates[](#part-4-walk-through-file-summary-and-updates)

The collection workflow receives file content from the implant, asks the LLM to summarize it, writes the original file, and appends a summary card to the updates page.

### Step 1: Submit a Baseline Collection[](#step-1-submit-a-baseline-collection)

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

### Step 2: Inspect the Collection Execution[](#step-2-inspect-the-collection-execution)

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

If `tail` is unavailable, open `http://20.30.40.154/published/updates.html` in your browser and review the newest card.

> **Check Your Understanding**
> 
> Question: Why is the original file stored separately from the LLM summary?
> 
> Hint: Think about evidence quality and analyst review.

## Part 5: Customize Implant Responses to Steer the LLM[](#part-5-customize-implant-responses-to-steer-the-llm)

You have now seen the baseline workflows. Next, you will craft implant-style responses that influence the LLM. Your goal is not to break n8n. Your goal is to prove how small changes in untrusted telemetry alter the adversary agent's decisions.

### Step 1: Create a Desired Outcome Plan[](#step-1-create-a-desired-outcome-plan)

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

### Step 2: Modify Survey Evidence, Not Workflow Code[](#step-2-modify-survey-evidence-not-workflow-code)

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

### Step 3: Run and Inspect Each Attempt[](#step-3-run-and-inspect-each-attempt)

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

### Step 4: Steer the Published Summary[](#step-4-steer-the-published-summary)

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

## Part 6: Cause Novel Responses and Test Workflow Boundaries[](#part-6-cause-novel-responses-and-test-workflow-boundaries)

The workflow asks the LLM for a limited set of tasks and summary formats. Your final test is to see what happens when untrusted input tries to push the model outside those intended paths.

### Step 1: Attempt an Unsupported Task[](#step-1-attempt-an-unsupported-task)

Create a survey payload that tries to convince the LLM to choose a task type the implant does not support. Pick your own wording and place it in a realistic field such as a document path or host name.

Do not edit the workflow prompt. Do not add a new node. The test is whether untrusted survey data can move the model outside the intended contract.

After running the payload, inspect:

- Did `llm_response` include an unsupported task?
- Did `llm_decision` parse successfully?
- Did `task_payload_json_text` appear?
- Did `queued_task_count` increase?
- Did the follow-up check-in return the unsupported task, or was it dropped?

Expected learning: a model may produce a novel answer, but a parser or allow-list can still prevent that answer from becoming implant tasking.

### Step 2: Attempt Format Drift[](#step-2-attempt-format-drift)

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

### Step 3: Attempt Summary Format Drift[](#step-3-attempt-summary-format-drift)

Use the collection workflow to try to make the summary include content outside the expected four bullet lines.

Examples of drift to look for:

- extra headings,
- extra bullets,
- a recommendation not grounded in the preview,
- a priority label not requested by the prompt,
- conversational text before the bullets.

Record whether the workflow publishes the drift exactly as returned, sanitizes it, or drops it.

## Final Validation Checklist[](#final-validation-checklist)

Before submitting, verify you have:

- Logged into n8n and mapped all three workflows.
- Run at least one check-in curl request.
- Run at least one baseline survey request.
- Run at least one collection request and viewed the updates page.
- Produced two successful manipulation attempts.
- Produced one novelty or boundary test.
- Captured execution evidence from n8n, not only terminal output.
- Written one five-line effect report for each manipulation or novelty test.

## Self-Check Appendix[](#self-check-appendix)

Use this appendix after you have attempted the questions.

**Part 1, Step 1:** Production webhook URLs require active workflows because n8n only serves `/webhook/...` routes for active workflows. Test routes use `/webhook-test/...` while editing.

**Part 1, Step 3:** The enqueue evidence is in `Enqueue Follow-on Task`. The LLM node explains the recommendation, but the Postgres insert proves what was stored for delivery.

**Part 2, Step 2:** Claiming a pending task prevents duplicate delivery. Without claim logic, repeated check-ins could receive and execute the same task more than once.

**Part 3, Step 2:** `llm_response` is the raw model text. `task_payload_json_text` is the workflow-normalized payload that can be inserted into the task queue.

**Part 3, Step 5:** The allow-list in the Code node drops task types outside `reboot`, `collect`, and `delete_self`. This limits what an induced model response can become.

**Part 4, Step 2:** Keeping the original file supports evidence review. A summary is an interpretation; the original is the artifact an analyst can re-check.

**Part 5, Step 3:** The follow-up check-in proves delivery. The survey workflow queues tasking, but the implant only acts after the check-in dispatcher returns that task.

**Part 6, Step 2:** The LLM being tricked is only one layer. The workflow must also parse, accept, store, and deliver the tricked output before it changes implant behavior.