---
id: B04.M18-key
title: Adversary Agent CounterStrike — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B04
module_type: lab
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

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

| Item | Default | Source |
| --- | --- | --- |
| n8n UI | `http://20.30.40.153:5678` | `lab_env/docker-compose.yml` |
| n8n session | `n8n-auth` cookie in the student brief | minted before class; see the replica Quick Start |
| Webhook proxy | `http://20.30.40.155` | `lab_env/docker-compose.yml` |
| Updates page | `http://20.30.40.154/` | `lab_env/docker-compose.yml` |
| Postgres database | `adversary_ops` | `.env` / compose default |
| Postgres user | `ops_admin` | `.env` / compose default |
| Tasking model | `ollama/llama3.1:8b` | literal in `LLM Decision and Task Builder` |
| Summary model | `ollama/qwen3.5:4b` | literal in `Summarize for Feed`; `think` is off so the reply is in `content` |
| Starting inference host | `https://litellm.teamX.cso.ops/v1` | both model nodes; student replaces `teamX` |
| Starting inference key | `TEAM_LITELLM_KEY` | both model nodes; student replaces it with the team key |
| Implant ID | `alpha-node-01` | `lab_env/implant/implant.ps1` |
| Implant scheduled task | `WindowsHostTelemetrySync` | `lab_env/implant/implant.ps1` |

## Target Access Enablement

- Environment type: containerized lab services on the assigned PCTE segment.
- Primary method: `existing-implant-tasking`.
- Fallback method: the same webhook path on `http://20.30.40.153:5678` if the proxy is unavailable. Production webhooks do not use the session cookie.
- Target-side enablement: n8n workflows imported and active; Postgres credential named `L45 Postgres` assigned to all Postgres nodes; webhook proxy running.
- Ops-station requirements: browser, `curl`, route to `20.30.40.153`, `20.30.40.154`, and `20.30.40.155` or team equivalents.
- Network assumptions: `l45_net` is ipvlan L2 on parent `eth1` (`IPVLAN_PARENT`). Default segment `20.30.40.0/24`, gateway `20.30.40.1`. Postgres `20.30.40.151`, n8n `20.30.40.153`, updates web `20.30.40.154`, and webhook proxy `20.30.40.155` have no host port mappings. The lab host cannot open those addresses. `l45-updates-loopback` and `l45-updates-viewer` use the host network. The viewer image is `zenika/alpine-chrome:latest` and reads `http://127.0.0.1:8088/published/updates.html`.
- Cleanup/reset: follow `lab_env/README.md` reset steps or restart from a clean PCTE baseline.

Fallback direct-to-n8n pattern:

```bash
curl -fsS -X POST http://20.30.40.153:5678/webhook/agent-checkin \
  -H 'Content-Type: application/json' \
  -d '{"event_type":"agent_checkin","agent_id":"alpha-node-01","host_name":"lab-win01","os":"windows"}'
```

Students open the UI by setting the `n8n-auth` cookie from the brief. They do not get a username or password. Webhook calls do not send that cookie.

## Initial Situational-Awareness Baseline

Run these from the instructor ops station or lab host before students begin. The point is to establish where commands are running, what services are reachable, and whether the lab begins from a known-good state.

The first block captures time, host identity, account context, working directory, shell, and OS/runtime. `date -u` prints UTC time for evidence correlation. `hostname`, `whoami`, `id`, and `pwd` establish local execution context. `uname -a` and version commands help distinguish host issues from container issues.

```bash
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

```bash
who -a
ps -eo pid,ppid,user,comm,args --sort=comm | sed -n '1,80p'
ss -tulpen
ss -tunap
```

Expected findings: n8n and supporting containers may not appear as host listeners because the lab uses ipvlan container IPs rather than host port mappings.

On the lab host, `docker compose ps` lists services and health. Run the curls from the ops station. The lab host cannot open its own ipvlan addresses.

```bash
docker compose ps
```

```bash
curl -fsS http://20.30.40.155/healthz
curl -fsS http://20.30.40.154/ | sed -n '1,8p'
```

Expected findings: `l45-n8n`, `l45-postgres`, `l45-updates-web`, and `l45-webhook-proxy` are running. There is no local model container. The proxy health check succeeds. The updates page returns HTML.

Confirm the team's Spark is serving the two models. Use that team's LiteLLM key from the DGX Spark team access page. From a host that trusts the classroom root:

```bash
curl -fsS https://litellm.teamN.cso.ops/v1/models \
  -H "Authorization: Bearer <team LiteLLM key>" \
  --cacert certs/classroom-root.crt
```

Replace `teamN` with the team number. Expected findings: `ollama/llama3.1:8b` and `ollama/qwen3.5:4b` are in the list.

## Expected Workflow Structure

Students should recover this through the n8n UI.

### `L45 - Agent Checkin Dispatcher`

```text
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

```text
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

```text
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
- On the red host, headless Chromium reads `http://127.0.0.1:8088/published/updates.html` every `VIEW_INTERVAL_SECONDS` (default 60). When a card contains `Sensitivity: high`, that same browser opens the card's `/published/files/` link. Students still use `http://20.30.40.154/published/updates.html`. The student brief says the adversary side reads the page regularly and opens the original when sensitivity is high.

## Instructor Walkthrough

### Point each copy at the team Spark

Each student has an independent copy of the three workflows. The team shares one Spark. Before the first webhook, both model nodes must use that team's host and the LiteLLM key from the DGX Spark team access page.

- `LLM Decision and Task Builder` in `L45 - Survey Analysis and Tasking`
- `Summarize for Feed` in `L45 - File Summary and Updates Feed`

Replace `teamX` with the team number and `TEAM_LITELLM_KEY` with that team's key. Team 2 becomes `https://litellm.team2.cso.ops/v1`. Leave `ollama/llama3.1:8b` and `ollama/qwen3.5:4b` unchanged. Save both workflows and leave them active.

### 1. Baseline Check-In

Use this to show students how the dispatcher behaves before any manipulation. `curl -X POST` sends a JSON webhook request. `-H 'Content-Type: application/json'` tells n8n to parse the body as JSON. `-d` provides the simulated implant check-in body.

```bash
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

```json
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

```bash
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

```json
{
  "status": "accepted",
  "queued_task_count": 0,
  "message": "survey processed with no follow-on tasks"
}
```

If the tasking model queues a task, grade the student on whether they inspect `llm_response` and explain the interpretation. On the 5 October 2026 walk, `llama3.1:8b` queued `collect` for `C:\Users\student\Documents\notes.txt` and explained that a document was available. That is an acceptable result when the execution shows that decision.

### 3. Collect Task Outcome

This payload gives the LLM a plausible high-priority document path.

```bash
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

```json
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

```bash
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

```json
{
  "task_type": "collect",
  "task_payload": {
    "path": "C:\\Users\\jsmith\\Documents\\internal-use_budget_notes.docx"
  }
}
```

### 4. Reboot Task Outcome

Use this to demonstrate how session evidence can trigger disruption tasking.

```bash
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

```bash
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

```bash
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

```json
{
  "status": "published",
  "summary_link": "/published/updates.html",
  "file_link": "/published/files/<timestamp>_internal-use_budget_notes.docx"
}
```

Verify the page:

```bash
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

```text
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

```text
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

```text
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
- Confirm the cookie path is `/` on `http://20.30.40.153:5678`.
- Mint a new cookie with the replica Quick Start before each offering. A previous offering's cookie does not carry forward.
- Direct webhook calls do not use the cookie.

### Production Webhook 404

- Confirm the workflow is active.
- Confirm the URL uses `/webhook/...`, not `/webhook-test/...`.
- Confirm the proxy health check succeeds:

```bash
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

```bash
docker compose exec postgres psql -U ops_admin -d adversary_ops \
  -c "select id, agent_id, task_type, status, created_at from task_queue order by id desc limit 20;"
```

The `psql` command opens a Postgres client inside the database container. The `-U` option selects the database user, `-d` selects the database, and `-c` runs one SQL command.

To clear only pending tasks during instructor reset:

```bash
docker compose exec postgres psql -U ops_admin -d adversary_ops \
  -c "update task_queue set status = 'completed', completed_at = now() where status = 'pending';"
```

### Updates Page Missing the New Card

- Confirm the collection workflow execution reached `Append Updates Feed`.
- Confirm the file link in the webhook response.
- Refresh `http://20.30.40.154/published/updates.html`.
- If state is dirty between cohorts, reset `lab_env/vols/updates` using the README reset procedure.

## Cleanup

For a full cohort reset from `lab_env`:

```bash
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
