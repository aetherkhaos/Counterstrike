---
id: B04.M16-setup
title: Effects Advisor Agent — Setup Guide
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

# Lab L4.4 - Instructor Setup Notes (Instructor Only)

Stretch / bonus lab. n8n and Chroma are already on each student VM (`environments/b04_m13_student_n8n/`). The embedding model is already on the team DGX as LiteLLM alias `embed`. Students index the KB. They do not add a model server.

## Before class

1. Class CTI is already the team Compose service. Confirm it. Do not start a second copy:

   ```bash
   curl -sk "https://cti.${BASE_DOMAIN}/api/v1/ip/198.51.100.44" \
     -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
   curl -sk "https://cti.${BASE_DOMAIN}/api/v1/ip/198.51.100.157" \
     -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
   curl -sk "https://cti.${BASE_DOMAIN}/api/v1/ip/172.20.2.80" \
     -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
   curl -sk -o /dev/null -w "%{http_code}\n" \
     "https://cti.${BASE_DOMAIN}/api/v1/ip/203.0.113.250" \
     -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
   ```

   Expect: `198.51.100.44` → 200 score 88; `198.51.100.157` → 200 score 91 / `exfil-c2`; `172.20.2.80` → 200 score 8 / `friendly-mirror`; `203.0.113.250` → 500.

2. On each team DGX, `OLLAMA_MODELS` includes `qwen3-embedding:0.6b` and LiteLLM serves alias `embed`. Confirm:

   ```bash
   docker compose exec -T ollama ollama list
   curl -sk "https://litellm.${BASE_DOMAIN}/v1/embeddings" \
     -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
     -H "Content-Type: application/json" \
     -d '{"model":"embed","input":"center of gravity"}'
   ```

3. On each student VM, Chroma is already in `environments/b04_m13_student_n8n/` (`chromadb/chroma:1.0.21`). `curl -sS http://127.0.0.1:8000/api/v2/heartbeat` answers. Students do not pull that image.

4. The course pack attaches `lab-files.zip` on this lab (`kb/` plus `incidents/output_clean.json`, `output_ambiguous.json`, and `output_intel_fail.json`). Confirm it restored. `l44_incident_4.json` is a teacher-only file on the same lab. Issue it at the mid-lab handout. It is not in the student zip.

5. Publish to the class:
   - Student n8n is `http://localhost:5678` on the VM
   - LiteLLM URL and key on **DGX Spark team access**
   - Local **primary** alias (agent) and embeddings alias `embed`
   - `https://cti.<team-domain>` (students already have key `cso-cti-k9m2p7x4q1`)
   - This lab is **stretch / bonus**

## Part 0 watch-outs

- `embed` uses the Ollama embeddings API. The `ollama/*` chat wildcard does not serve `/v1/embeddings`.
- Chroma is on the student compose network `student_n8n`. n8n uses `http://chroma:8000`. The index script on the VM uses `http://127.0.0.1:8000`.
- The student VM must trust the team certificate. The OpenAI node has no ignore-SSL switch.
- The student compose sets `NODE_FUNCTION_ALLOW_BUILTIN=fs`. Without it the code node throws `Module 'fs' is disallowed` and cannot create `/lab_data/runs/<id>`. Students still set `N8N_RESTRICT_FILE_ACCESS_TO=/lab_data` when the file gate blocks that path.

## Grading checkpoints

| Check | Evidence |
| --- | --- |
| Stretch attempt | Optional; do not fail the week solely for skipping L4.4 |
| Personal n8n account | Workflow owner is the student, name `L4.4-EffectsAdvisor-[LastName]` |
| Stack | `embed` via LiteLLM; Chroma up |
| Retrieval | Top-k chunks include `source` paths under the Moodle `kb/` tree |
| Class CTI | `intel_lookup` hits `/api/v1/ip/{ip}` with Bearer `cso-cti-k9m2p7x4q1` |
| CIDR gate | Out-of-range IPs refused; `203.0.113.250` allowed so the 500 path can fire |
| Five guardrails | Cheatsheet maps allow-list, arg whitelist, turn cap, schema, audit |
| Four runs | Three L4.3b STIX inputs + `l44_incident_4.json` with audit logs |
| Reflection | Cites a retrieval that changed the effect (incident 4 is the intended example) |

Do not accept a workflow that calls a model server directly. Chat and embeddings both go through team LiteLLM. n8n on the student VM is `http://localhost:5678`.
