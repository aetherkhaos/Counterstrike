---
id: B04.M16-key
title: Effects Advisor Agent — Instructor Answer Key
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

# Lab L4.4 - Effects Advisor Agent
## Instructor Answer Key (Instructor Only)

Stretch / bonus lab. Live walkthrough: confirm the team `embed` alias and the student VM's Chroma, index the Moodle KB, build a RAG + tool-use advisor under the five guardrails. Grade guardrails as strictly as the recommendation.

n8n and Chroma are already on the student VM. Embeddings are the LiteLLM alias `embed` (`ollama/qwen3-embedding:0.6b`). Students do not add a model server.

## Situational awareness (start of demo)

From the ops station (or the team Spark SSH session), establish clock, host, user, shell, OS, and that the services this lab needs are actually up:

```bash
date -u
hostname
whoami
pwd
echo "$SHELL"
uname -a
id
who
ps aux | head -n 20
ss -tulpn
ss -tunap | head -n 30
curl -sS -o /dev/null -w "%{http_code}\n" "http://localhost:5678/"
curl -sk "https://litellm.<team-domain>/v1/models" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY"
curl -sk "https://cti.<team-domain>/api/v1/ip/198.51.100.44" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
curl -sk "https://cti.<team-domain>/api/v1/ip/198.51.100.157" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
curl -sk -o /dev/null -w "%{http_code}\n" \
  "https://cti.<team-domain>/api/v1/ip/203.0.113.250" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
curl -sS http://127.0.0.1:8000/api/v2/heartbeat
```

Why this matters: a failed run is often TLS, LiteLLM auth, or class CTI, not the agent prompt. Expected: localhost n8n `200`; `/v1/models` lists the local primary alias and `embed`; CTI `198.51.100.44` → 200 score 88; `198.51.100.157` → 200 score 91 tags `exfil-c2`; fail-trigger → 500; Chroma heartbeat answers on `127.0.0.1:8000`. `<team-domain>` is that team's `BASE_DOMAIN` on **DGX Spark team access**. If `/v1/models` shows a different primary alias, use that in the workflow.

`date -u` / `hostname` / `whoami` / `pwd` / `$SHELL` / `uname -a` / `id` / `who` / `ps` / `ss` establish remote time, host identity, user/session, interpreter, OS, other users, process table, and TCP+UDP listeners/sockets before anyone debugs GPU OOM as "the model is broken."

First-use: `curl -sk` skips TLS verify only if the ops station has not yet trusted the class CA from L1.7b; prefer a trusted CA and drop `-k`. `-sS` silences the progress meter but still shows errors. `-o /dev/null -w "%{http_code}"` prints only the status so a 302 login redirect is visible.

## Value provenance (how students know non-default values)

- LiteLLM `embed` alias: already on the team gateway; confirmed with `/v1/embeddings`. It is `ollama/qwen3-embedding:0.6b`, not a chat alias.
- Chroma `http://chroma:8000` (n8n) / `http://127.0.0.1:8000` (VM): student compose; heartbeat curl.
- Collection name `doctrine_index`: student brief Part 0.
- CTI URL, Bearer `cso-cti-k9m2p7x4q1`, CIDRs `172.16.0.0/12`, `192.168.0.0/16`, `198.51.100.0/24`, `203.0.113.0/24`: student brief tool spec. `203.0.113.0/24` is required so incident 3 can call CTI and receive 500.
- KB path: host directory mounted at `/lab_data/kb`.
- Audit path `/lab_data/runs/<run_id>/`: brief Part 2; created by the run-context node.
- IPs `198.51.100.157` / `172.20.2.80`: incident JSON `extensions.cs_ops_week4.observables` plus partner_charlie.md after retrieval — not a jump-to-answer in the student brief.

## Evidence reference

| Item | Where | Default / behavior |
| --- | --- | --- |
| n8n | `http://localhost:5678` on the student VM | Personal account, not shared owner |
| LiteLLM chat | OpenAI Chat Model | Local **primary** alias |
| LiteLLM embeddings | `POST /v1/embeddings` | Model `embed` |
| Chroma | `http://chroma:8000` from n8n | Collection `doctrine_index` |
| KB | `/lab_data/kb/` | `engage/`, `d3fend/`, `unit_roe/`, `partner_contacts/`, `week1_planning/` |
| Incidents | `/lab_data/incidents/` | Three STIX copies + `l44_incident_4.json` (mid-lab) |
| CTI | `https://cti.<team-domain>/api/v1/ip/{ip}` | Bearer `cso-cti-k9m2p7x4q1` |
| Audit / handoff | `/lab_data/runs/<run_id>/` | `audit.jsonl`, `handoff.json` |

## Recommended instructor walkthrough

### 1. Part 0 — embed and Chroma

`embed` and Chroma are already up. Confirm them. Do not have students add a model server.

Spot-check embeddings (first-use: `/v1/embeddings` is the OpenAI-compatible embeddings route; `model` must be the LiteLLM alias `embed`, not the Ollama tag, because clients talk to LiteLLM only):

```bash
curl -sk "https://litellm.<team-domain>/v1/embeddings" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"embed","input":"disable collection"}'
```

Key lines: `"object":"list"` and a numeric `"embedding"` array. Full vectors are long; the id/model fields plus the first few floats are enough to prove the route works.

Chroma heartbeat:

```bash
curl -sS http://127.0.0.1:8000/api/v2/heartbeat
```

If this 404s, try `/api/v1/heartbeat` — some Chroma tags still serve v1. Use whichever heartbeat succeeds for the rest of the script.

### 2. Chunking and embedding

Canonical host-side script (stdlib only). Inspect it before running: it only POSTs to LiteLLM embeddings and Chroma; it does not call CTI or change n8n credentials.

Usage: `python3 build_index.py` with env `LITELLM_BASE`, `LITELLM_MASTER_KEY`, optional `KB`, `CHROMA`. Defaults below.

```python
# build_index.py on the student VM
import json, os, pathlib, re, ssl, urllib.request, uuid

KB = pathlib.Path(os.environ["KB"])
LITELLM_BASE = os.environ.get("LITELLM_BASE", "https://litellm.<team-domain>/v1").rstrip("/")
KEY = os.environ["LITELLM_MASTER_KEY"]
CHROMA = os.environ.get("CHROMA", "http://127.0.0.1:8000").rstrip("/")
COLL = "doctrine_index"
CTX = ssl.create_default_context()

def post(url, payload, extra=None):
    data = json.dumps(payload).encode()
    headers = {"Content-Type": "application/json"}
    if extra:
        headers.update(extra)
    req = urllib.request.Request(url, data=data, headers=headers, method="POST")
    with urllib.request.urlopen(req, context=CTX) as r:
        return json.loads(r.read().decode())

def embed(text):
    body = post(
        f"{LITELLM_BASE}/embeddings",
        {"model": "embed", "input": text},
        {"Authorization": f"Bearer {KEY}"},
    )
    return body["data"][0]["embedding"]

def chunks(text, n=500):
    paras = re.split(r"\n\s*\n", text)
    buf, out = "", []
    for p in paras:
        if len(buf) + len(p) > n and buf:
            out.append(buf.strip()); buf = p
        else:
            buf = (buf + "\n\n" + p).strip()
    if buf:
        out.append(buf.strip())
    return out

# Chroma 1.0 answers /api/v2. Create returns an id. Add and query use that id.
# GET by name also returns id if the collection already exists. /api/v1 returns 410.
V2 = f"{CHROMA}/api/v2/tenants/default_tenant/databases/default_database/collections"
try:
    created = post(V2, {"name": COLL})
    coll_id = created["id"]
except Exception:
    req = urllib.request.Request(f"{V2}/{COLL}")
    with urllib.request.urlopen(req, context=CTX) as r:
        coll_id = json.loads(r.read().decode())["id"]

ids, docs, embs, metas = [], [], [], []
for p in KB.rglob("*.md"):
    for ch in chunks(p.read_text()):
        ids.append(str(uuid.uuid4()))
        docs.append(ch)
        embs.append(embed(ch))
        metas.append({"source": str(p.relative_to(KB))})

add_body = {"ids": ids, "documents": docs, "embeddings": embs, "metadatas": metas}
post(f"{V2}/{coll_id}/add", add_body)
print(f"indexed {len(ids)} chunks")
```

How they know `LITELLM_BASE` and the alias `embed`: the Part 0 embeddings curl already succeeded. How they know `KB`: they unzipped Moodle `lab-files.zip` into the `/lab_data` mount, which creates `kb/`. Do not embed whole files; paragraph-boundary chunking is the teaching point.

Spot retrieval after index (same embed function):

```python
q = "What ENGAGE activity matches a disable effect on adversary collection?"
emb = embed(q)
# POST .../query with {"query_embeddings":[emb],"n_results":4}
```

Top hit should be from `engage/affect-disable.md` or `engage/affect-baseline.md`.

### 3. Workflow skeleton

Nine nodes, minimum. Agent model = local primary via LiteLLM (`https://litellm.<team-domain>/v1`).

1. **Manual Trigger** with input field `incident_json`.
2. **Set Run Context** — Code node: `run_id` from `Date.now()` and `Math.random()` (`crypto` is not defined in this sandbox), `require('fs')` mkdir `/lab_data/runs/<run_id>/`, seed `turn_count = 0`. The compose sets `NODE_FUNCTION_ALLOW_BUILTIN=fs`. The file gate must include `/lab_data`.
3. **Agent Turn (Loop Start)** — if `turn_count` is not `< 5`, short-circuit to schema-fail fallback (`classification` / effect `UNRESOLVED` or omit effect and mark unresolved).
4. **Compose Prompt** — incident + prior-turn results + instruction to respond with one of `{retrieve: <query>}` / `{tool: intel_lookup, args: {ip: ...}}` / `{final: <handoff-package-json>}`. Append the prompt to `audit.jsonl`.
5. **SI Agent** (local primary).
6. **Route Response** — parse; must match one of the three schemas; log; route to Retrieve, ToolCall, or Final. Unknown tool name → allow-list error (log, do not execute).
7. **Retrieve** — embed query via LiteLLM `embed`, Chroma top-4 + sources, log, `turn_count++`, loop to Compose Prompt.
8. **Tool Call** — `intel_lookup` only after IPv4 parse + membership in the four CIDRs; HTTP GET `https://cti.<team-domain>/api/v1/ip/{ip}` with Bearer `cso-cti-k9m2p7x4q1`; log; `turn_count++`; loop.
9. **Final Output** — validate six-section schema; write `handoff.json`; write run-close audit record.

First-use: n8n **Code** node runs JavaScript in the n8n container (not on the ops station). **HTTP Request** is the right node for CTI and can also hit Chroma; a Code node is fine if they use `this.helpers.httpRequest`. **Manual Trigger** is how they paste each incident JSON without a webhook.

### 4. Guardrail implementation (grade these)

| Guardrail | Where | What good looks like |
| --- | --- | --- |
| Tool allow-list | Route Response | `if action.tool not in ["intel_lookup"]: throw` (log the refusal) |
| Arg whitelist | Tool Call | `ipaddress` parse + CIDR membership in `172.16.0.0/12`, `192.168.0.0/16`, `198.51.100.0/24`, `203.0.113.0/24` |
| Max-turns cap | Loop start | hard stop at 5 with deterministic fallback |
| Schema enforcement | Final Output | JSON schema check. Citation `source` must match a retrieve path. No retrieve yet: count a turn and return to the cap. After a retrieve, one citation correction, then write the package with `schema_valid` false and stop. Cap fallback does not call the model again. |
| Audit log | Every node | `audit.jsonl` has `turn_start`, `llm_prompt`, `llm_response`, each retrieval + sources, each tool call/refusal + body, final + schema result |

Grade the cheatsheet against this table.

### 5. Expected behavior on incident 1 (`output_clean.json`)

How they know the path: Moodle / their L4.3b export. Observables include `198.51.100.44` and `198.51.100.157`. Transition: CTI seed `198.51.100.157` is the collection/C2 enrichment target; `198.51.100.44` is the L4.3b brute-force IP. A good agent retrieves disable/degrade doctrine, then looks up `198.51.100.157` (in-range TEST-NET).

```
turn 1: {"retrieve": "ENGAGE activity for malicious exfil collection - degrade/deny"}
   -> engage/affect-baseline.md + engage/affect-disable.md
turn 2: {"tool": "intel_lookup", "args": {"ip": "198.51.100.157"}}
   -> classification malicious, tags ["exfil-c2","collection-pipeline"], score 91
turn 3: {"final": { ... recommended_effect degrade or deny, CV=unauthenticated ingest ... }}
```

Abridged `partner_tasking`:

```json
{
  "recommended_effect": "degrade",
  "justification": "Adversary CG is the collection pipeline. CV is a revocable ingest/token path; degrade/disable at the application layer beats destroy.",
  "cg": "Adversary exfil collection pipeline",
  "cv": "Unauthenticated or weakly authenticated ingest associated with 198.51.100.157",
  "citations": [
    {"source": "engage/affect-disable.md", "excerpt": "Disable attacks rely on credential revocation..."},
    {"source": "unit_roe/effects-ceiling.md", "excerpt": "Reversible disable or degrade at the application layer is authorized at the CPT level..."}
  ]
}
```

Accept `deny` if citations and CG/CV still match. Reject a made-up tenth verb.

Provisioned-stack check: the index held 16 chunks. The spot query returned `engage/affect-disable.md` first. One `output_clean.json` run retrieved twice, including `engage/affect-disable.md`, and closed with `schema_valid` true and `recommended_effect` `degrade`. That run did not call `intel_lookup`. A run that looks up `198.51.100.157` before the final still passes. n8n reached class CTI for `198.51.100.44` and got score 88.

### 6. Expected behavior on incident 2 (`output_ambiguous.json`)

`needs_human_review: true`, IP `198.51.100.99` (CTI suspicious / 42). Mature agent:

- Recommends **`reconnoiter`** (canary / lure), not degrade/deny/disrupt/destroy.
- Cites `engage/elicit-lure.md`.
- Rollback names the canary path and cites `week1_planning/rfi.md`.

### 7. Expected behavior on incident 3 (`output_intel_fail.json`)

`intel_unavailable: true`, IP `203.0.113.250`. Agent should skip `intel_lookup` or log "tool returned 500." Recommend **`handoff`** and cite `partner_contacts/partner_bravo.md`.

Calling `intel_lookup` anyway is passing **if** the CIDR check allows `203.0.113.250`, the 500 is logged, and the run completes. A mature agent skips it.

How they know `203.0.113.250` is allowed: it is in `203.0.113.0/24` on the brief whitelist so the fail-trigger is reachable. Public `8.8.8.8` must still be refused.

### 8. Mid-lab injection: `l44_incident_4.json`

Hand out around the three-hour mark (or whenever the first three runs work). `source_host` `172.20.2.80` matches `partner_contacts/partner_charlie.md`.

Correct behavior:

- Retrieve partner contacts; notice the friendly collector.
- Recommend **`deceive`** / disregard (no hostile CG; mark cleanup).
- Justify in CG/CV language why no hostile CG is present.

Grading point: does retrieval catch the false positive, or does the agent reflex-recommend `degrade` on volume? Coach the retrieval hit.

### 9. Audit log review

Open `/lab_data/runs/<run_id>/audit.jsonl` for incident 2. Target 15–40 lines:

```json
{"ts":"...","event":"turn_start","turn":1,"run_id":"..."}
{"ts":"...","event":"llm_prompt","turn":1,"prompt_hash":"..."}
{"ts":"...","event":"llm_response","turn":1,"action":"retrieve","raw":"..."}
{"ts":"...","event":"retrieve","query":"...","top_sources":["engage/elicit-lure.md","engage/affect-deceive.md","unit_roe/effects-ceiling.md","week1_planning/cg_cv.md"]}
{"ts":"...","event":"final","schema_valid":true,"run_id":"..."}
```

Missing or success-only logs fail the guardrail portion regardless of answer quality.

### 10. Reflection paragraph

Good:

> On `l44_incident_4.json`, retrieval surfaced `partner_contacts/partner_charlie.md` identifying `172.20.2.80` as a friendly mirror. Without that chunk the agent would have recommended `degrade` on volume. With it, the agent recommended cleanup and `deceive` / no hostile effect.

### 11. Close

Collect workflow JSON, scripts, four packages, cheatsheets, reflections. Pointer to L4.5: same loop, adversary corpus and tools.

## Troubleshooting / confirmation

Keep this section for failures; do not scatter fixes through the walkthrough.

| Symptom | Check |
| --- | --- |
| `embed` missing from `/v1/models` | `qwen3-embedding:0.6b` is in `OLLAMA_MODELS` and `ollama list`. LiteLLM `model_list` has `embed` → `ollama/qwen3-embedding:0.6b` (not `ollama_chat`). Recreate `litellm-gateway` after the config change. |
| `/v1/embeddings` 404 or a chat completion | Request `model` is `embed`. The `ollama/*` wildcard is chat-only. |
| Chroma heartbeat 404 | Try `/api/v1/heartbeat`. Align add/query with the same API generation. |
| n8n cannot reach Chroma | Both on `web`; URL `http://chroma:8000` inside n8n, not `localhost`. |
| CTI 401 | Header `Authorization: Bearer cso-cti-k9m2p7x4q1` (same key as L4.3a). |
| CTI 404 on `198.51.100.157` or `172.20.2.80` | Instructor CTI not rebuilt after seed extend. Rebuild `cti-api`. |
| Index script SSL error | Trust class CA from L1.7b, or run against LiteLLM on the Spark with the same CA bundle. |
| Agent loops the same retrieve | Turn cap not enforced; fail the guardrail. |
| `recommended_effect` synonym | Reject. Must be one of the nine lecture words. |
| Out-of-range IP accepted | Fail arg whitelist (e.g. `8.8.8.8`). |

Confirm CTI seeds used in this lab:

```bash
curl -sk "https://cti.<team-domain>/api/v1/ip/198.51.100.157" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
curl -sk "https://cti.<team-domain>/api/v1/ip/172.20.2.80" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
```

Expect scores 91 and 8.

## Common mistakes

- Skipping chunking (whole-file embeds).
- Loop without turn cap.
- Free-text effect verbs.
- Calling vLLM or a public embed API.
- Tool args not whitelisted.
- Audit log only on success.

## Course link

Stretch objective: retrieval over doctrine, controlled tool use, multi-step reasoning under guardrails. Same architecture L4.5 will counter-strike.
