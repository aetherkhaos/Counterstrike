---
id: B04.M13-setup
title: Build Agentic Workflow Lab — Setup Guide
artifact_type: setup_guide
audience: instructor
block: B04
module_type: lab
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: setup_guide_v1
sensitivity: instructor_only
---

# Lab L4.3a - Instructor Setup Notes (Instructor Only)

Each student VM already runs n8n from `environments/b04_m13_student_n8n/`. The UI is `http://localhost:5678` on that VM. The same image is used in the classroom and in a PCTE HWIL segment. Tell students which VM to log into. Do not give them a second procedure. CTI is instructor-hosted. Model calls go to team LiteLLM.

## Before class

1. CTI is the `cti-api` service in the team Compose file. The build context is `../cti` (`/opt/stack/cti` next to `/opt/stack/student-spark`). Traefik publishes `https://cti.${BASE_DOMAIN}` on the team certificate. Leave `CTI_API_KEY=cso-cti-k9m2p7x4q1`. `CTI_LITELLM_MODEL` must be a model id LiteLLM actually serves.

   ```bash
   cd /opt/stack/student-spark
   docker compose up -d --build cti-api
   curl -sk "https://cti.${BASE_DOMAIN}/api/v1/ip/198.51.100.44" \
     -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
   ```

   Expect `200` with score `88` / `malicious`. `summary` may vary. `8.8.8.8` → `404`. `203.0.113.250` → `500`.

2. The course pack attaches `auth_syslog.txt` as a File resource on this lab. Confirm it restored. The three reinforcement logs are File resources on Agent Reinforcement, not this lab.

3. Publish to the class:
   - Which VM each student logs into. n8n is `http://localhost:5678` on that VM.
   - Team LiteLLM URL (`https://litellm.<team-domain>/v1`) and key, from **DGX Spark team access**. In the student guide, `<team-domain>` is that team's `BASE_DOMAIN` (for example `team1.cso.ops`).
   - LiteLLM master key (team-shared credential)
   - Local aliases: secondary (IP extract), primary (triage)
   - Cloud frontier model id (for L4.3b branch B; name only, no vendor)
   - `https://cti.<team-domain>` (same domain; students use key `cso-cti-k9m2p7x4q1` from the guide)

## Part 0 watch-outs

- Deploy `environments/b04_m13_student_n8n/` on each student VM before class. Leave `N8N_RESTRICT_FILE_ACCESS_TO` unset so the first file read fails.
- Each student creates the owner account on their own VM. There is no shared owner and no invite step.
- Do not change `N8N_ENCRYPTION_KEY` after the first start. Changing it invalidates stored credentials in `vols/n8n`.
- Students copy syslog to the host directory mounted at `/lab_data`. The workflow path is `/lab_data/auth_syslog.txt`.
- The VM must reach team LiteLLM and `https://cti.<team-domain>`. Install the team CA so the n8n container trusts it. The OpenAI Chat Model node has no ignore-SSL option; a self-signed team certificate fails that node with `Connection error`.
- Accept the file node only after the student sets `N8N_RESTRICT_FILE_ACCESS_TO=/lab_data` and recreates the container. A copy into `/home/node/.n8n-files` skips that setting.

## Grading checkpoints

| Check | Evidence |
| --- | --- |
| Personal n8n account | Workflow owner is the student, name `Build an Agentic Workflow-[LastName]` |
| n8n on the student VM | UI is `http://localhost:5678` |
| Secondary then primary | IP extract vs triage use different LiteLLM aliases |
| Class CTI | HTTP nodes hit `/api/v1/ip/{ip}` with Bearer `cso-cti-k9m2p7x4q1` |
| JSON + IF | Parse keys present; True path needs `Malicious` AND threshold |
| Deliverables | Screenshot, JSON export, `markdown_report` |

Do not accept a model node that calls a host other than team LiteLLM. Leave the exported workflow untouched for the later comparison.
