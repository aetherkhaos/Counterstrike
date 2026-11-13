---
id: B04.M16-brief
title: Effects Advisor Agent — Student Brief
artifact_type: student_brief
audience: student
block: B04
module_type: lab
source_status: canonical
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---

# Effects Advisor Agent
## Student Brief

**Stretch / bonus lab.** Optional after Agent Reinforcement. Not required to complete the week.
The numbered steps, compose blocks, and Code snippets are **guidance, not a required procedure.** Meet the deliverables, schema, and five guardrails. Other node graphs, script languages, or Chroma API versions are fine if the evidence is the same.
**Duration:** ~5 hours if you attempt it.
**Stack:** n8n and Chroma are already running on your VM. n8n is `http://localhost:5678`. Chroma is the vector database on that same VM. The local **primary** model and the `embed` alias both go through team LiteLLM. Class CTI is on the team host.

## Lab Access

`<team-domain>` is the domain on the Moodle page **DGX Spark team access**. If LiteLLM is listed as `https://litellm.team1.cso.ops`, `<team-domain>` is `team1.cso.ops`. Use that same value for LiteLLM and CTI.

| Role | Value |
| --- | --- |
| n8n UI | `http://localhost:5678` on your VM |
| LiteLLM | `https://litellm.<team-domain>/v1` |
| Agent model | Local **primary** alias (instructor-published) |
| Embeddings | LiteLLM alias `embed` |
| Chroma | `http://chroma:8000` from n8n (`http://127.0.0.1:8000` on the VM) |
| Class CTI | `https://cti.<team-domain>/api/v1/ip/{ip}` |
| CTI key | `cso-cti-k9m2p7x4q1` |
| KB + incidents | Moodle file `lab-files.zip` → the host directory mounted at `/lab_data` |

Container path: `/lab_data/`.

## Operational Context

Agent Reinforcement emits STIX-style JSON per incident. Use your three Agent Reinforcement outputs **or** the Moodle copies (`output_clean.json`, `output_ambiguous.json`, `output_intel_fail.json`).

Build an **Effects Advisor** that reads an incident, retrieves doctrine from a local vector store, reasons in CG/CV language, calls one enrichment tool, and emits a **partner handoff package** recommending one effects-vocabulary verb: `deny`, `degrade`, `disrupt`, `destroy`, `deceive`, `manipulate`, `reconnoiter`, `interdict`, `handoff`.

The agent recommends. It does not execute effects.

## Knowledge Base

Download `lab-files.zip` from this lab. It contains `kb/` and `incidents/`. Unzip it into the host directory mounted at `/lab_data`:

```bash
docker inspect <n8n-container> --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}'
unzip lab-files.zip -d <host-directory-for-/lab_data>/
```

If `docker` says permission denied, run `docker inspect` with `sudo`.

| Dir | Contents |
| --- | --- |
| `engage/` | ENGAGE goals, approaches, activities |
| `d3fend/` | D3FEND notes keyed by ATT&CK ID |
| `unit_roe/` | Effect-ceiling summary per category |
| `partner_contacts/` | Partner teams, capability, callback |
| `week1_planning/` | CG, CV, RFI extracts |

Chunk and embed this corpus in Part 0.

## Tool Specification

Canonical enrichment tool:

- **Name:** `intel_lookup`
- **Args:** `{"ip": "<ipv4>"}`
- **Endpoint:** `https://cti.<team-domain>/api/v1/ip/{ip}`
- **Auth:** `Authorization: Bearer cso-cti-k9m2p7x4q1`
- **Response:** JSON with `reputation_score`, `classification`, `tags`, `last_seen`, `summary`

You may add a second **read-only** tool. No tools that write state.

`intel_lookup` may only run for well-formed IPv4 in:

- `172.16.0.0/12`
- `192.168.0.0/16`
- `198.51.100.0/24`
- `203.0.113.0/24`

Reject everything else (including public IPs outside those TEST-NET ranges).

## Part 0: Embeddings, Chroma, and index

**Objective:** Confirm the `embed` alias and local Chroma are already up, copy the doctrine notes and incidents into `/lab_data`, and build collection `doctrine_index`.

n8n and Chroma are already on your VM. The `embed` alias is already on team LiteLLM. You do not add a model server or a database to a stack.

### 0.1 Confirm the existing stack

```bash
curl -sk "https://litellm.<team-domain>/v1/models" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY"
curl -sk "https://litellm.<team-domain>/v1/embeddings" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"embed","input":"center of gravity"}'
curl -sS http://127.0.0.1:8000/api/v2/heartbeat
```

`/v1/models` lists the local primary alias and `embed`. The embeddings call returns `data[0].embedding` as a numeric array. The heartbeat answers from Chroma on this VM. If `/api/v2/heartbeat` 404s, try `/api/v1/heartbeat` and use that generation for the rest of the script. Do not point n8n at an embedding server directly. Use the LiteLLM alias `embed`.

### 0.2 Build the index

Write a chunking/embedding script (deliverable). Run it on your VM (Python 3 stdlib is enough). One working path:

1. Set env: `LITELLM_BASE=https://litellm.<team-domain>/v1`, `LITELLM_MASTER_KEY`, `KB` to the host directory you copied `kb/` into, `CHROMA=http://127.0.0.1:8000`.
2. Walk `KB` for `*.md`. Split each file on blank lines; merge paragraphs until ~500 characters; keep leftover as a chunk.
3. For each chunk, `POST $LITELLM_BASE/embeddings` with `{"model":"embed","input":"<chunk>"}` and `Authorization: Bearer $LITELLM_MASTER_KEY`. Read `data[0].embedding`.
4. Create Chroma collection `doctrine_index` if missing. The create response includes an `id`. `POST` add to that id with `ids`, `documents`, `embeddings`, `metadatas` (`source` = path relative to `KB`). If create says the collection already exists, `GET` it by name and use the returned `id`. Add and query reject the name in place of the id.
5. Spot-check: embed `ENGAGE disable effect on adversary collection`, query `n_results=4`. At least one `source` should start with `engage/`.

Skeleton (adapt; do not treat as the only legal script):

```python
# chunk on blank lines -> embed via LiteLLM -> chroma add
# POST {LITELLM_BASE}/embeddings  {"model":"embed","input": text}
# POST {CHROMA}/api/v2/tenants/default_tenant/databases/default_database/collections
#   {"name":"doctrine_index"}  -> response id
# POST {CHROMA}/api/v2/.../collections/{id}/add
#   {"ids":[...],"documents":[...],"embeddings":[...],"metadatas":[{"source":"engage/..."}]}
```

## Part 1: Retrieval pipeline

**Objective:** Embed one query through team LiteLLM and return doctrine chunks from Chroma with a source path on each chunk.

Build this in a **new** workflow. Do not edit the workflow you already saved.

### 1.1 Create the workflow

1. Open `http://localhost:5678` as yourself.
2. **Add Workflow**. Keep the **Manual Trigger**.
3. Rename `Effects Advisor Agent-EffectsAdvisor-[YourLastName]`.
4. On the trigger, add a string field `query` (you will add `incident_json` in Part 2). Execute once so the node has output.

### 1.2 LiteLLM credential

Reuse the OpenAI credential you already saved for team LiteLLM. Otherwise **OpenAI Chat Model** (or HTTP header) credential:

| Field | Value |
| --- | --- |
| Base URL | `https://litellm.<team-domain>/v1` |
| API Key | team LiteLLM master key |

Do not set the base URL to a host port on the DGX. Use the LiteLLM URL.

### 1.3 Embed the query

1. Add **HTTP Request** `Embed Query`.
2. Method `POST`. URL `https://litellm.<team-domain>/v1/embeddings`.
3. Header `Authorization` = `Bearer <LiteLLM master key>` (or `{{ $env.LITELLM_MASTER_KEY }}` if you exposed it to n8n).
4. Body JSON: `{"model":"embed","input":"{{ $json.query }}"}`.
5. Execute. Confirm `data[0].embedding` is a numeric array.

`/v1/embeddings` is the OpenAI-compatible embeddings route. `model` must be the LiteLLM alias `embed`, not the Ollama tag.

### 1.4 Query Chroma

1. Add **HTTP Request** `Query Chroma`.
2. From n8n use `http://chroma:8000`. Not `localhost`. `localhost` inside the container is n8n, not Chroma.
3. `POST` a query against collection `doctrine_index`, `n_results` `4`, include documents and metadatas. Example v1 body:

   ```json
   {
     "query_embeddings": [ {{ $json.data[0].embedding }} ],
     "n_results": 4,
     "include": ["documents", "metadatas"]
   }
   ```

   URL: `http://chroma:8000/api/v2/tenants/default_tenant/databases/default_database/collections/{id}/query`. `{id}` is the id from Part 0, not the name `doctrine_index`. `GET` the collection by name if you did not keep the id.

4. Add **Code** `Shape Retrieval` that emits `{ query, chunks: [{ text, source }, ...] }` from documents + `metadatas.source`. Drop chunks with no `source`.

5. Pin a test `query` such as `ENGAGE disable effect on adversary collection`. Execute through Shape Retrieval. Expect four chunks and at least one `source` under `engage/`.

## Part 2: Agent loop and guardrails

**Objective:** Run a bounded advisor that retrieves, calls `intel_lookup` only for an allowed IP, and stops with a six-section handoff or the turn cap.

Wire retrieval into a bounded ReAct loop. The graph below is one shape that grades cleanly; a native n8n SI Agent is acceptable if the five guardrails still fire in the workflow (not only in the prompt).

### 2.1 Mission constants

Add **Edit Fields (Set)** `Define Advisor Constants`:

| Name | Type | Value |
| --- | --- | --- |
| `cti_base_url` | string | `https://cti.<team-domain>` |
| `cti_api_key` | string | `cso-cti-k9m2p7x4q1` |
| `chroma_url` | string | `http://chroma:8000` |
| `max_turns` | number | `5` |
| `allowed_tools` | string | `intel_lookup` |

Execute. Confirm `max_turns` is a number.

### 2.2 Run context and audit file

1. Change the Manual Trigger to also accept `incident_json` (string or JSON). Paste one Moodle incident to test.
2. Add **Code** `Set Run Context`:

   ```javascript
   const fs = require('fs');
   const run_id = `${Date.now().toString(16)}-${Math.random().toString(16).slice(2)}`;
   const dir = `/lab_data/runs/${run_id}`;
   fs.mkdirSync(dir, { recursive: true });
   const incident = $json.incident_json || $json;
   return {
     run_id,
     dir,
     turn_count: 0,
     scratchpad: [],
     incident_json: typeof incident === 'string' ? incident : JSON.stringify(incident),
   };
   ```

   `fs` writes inside the n8n container. `/lab_data` is the host directory you copied the notes into. This n8n sandbox has no `crypto`, so the run id is built from `Date.now()` and `Math.random()`. The VM allows `require('fs')`. If the node says `Module 'fs' is disallowed`, the image is missing `NODE_FUNCTION_ALLOW_BUILTIN=fs`. If it says access to the file is not allowed, set `N8N_RESTRICT_FILE_ACCESS_TO=/lab_data` and recreate the container.

3. Add a helper you call from later nodes, or inline appends:

   ```javascript
   const fs = require('fs');
   fs.appendFileSync(
     `${$json.dir}/audit.jsonl`,
     JSON.stringify({ ts: new Date().toISOString(), ...event }) + '\n'
   );
   ```

   Log failures too.

### 2.3 Turn cap

Add **If** `Under Turn Cap`: number `turn_count` **smaller than** `max_turns`.

- **True:** continue to Compose Prompt.
- **False:** **Set** `Unresolved Fallback` with a six-section package whose `partner_tasking.recommended_effect` is `handoff` and justification `turn cap reached`, then go to write `handoff.json`. Do not loop.

### 2.4 Compose Prompt

**Code** or **Set** `Compose Prompt`. User message must include the incident, `scratchpad` (prior retrieve/tool results), and:

```text
You recommend effects; you do not execute them.
Reply with exactly one JSON object, no markdown:
{"retrieve":"<query>"}
or {"tool":"intel_lookup","args":{"ip":"<ipv4>"}}
or {"final":{ ... six-section handoff package ... }}
recommended_effect must be one of:
deny, degrade, disrupt, destroy, deceive, manipulate, reconnoiter, interdict, handoff.
Name cg, cv, and at least two citations with source path and excerpt.
Each citation source must be a path returned by retrieve.
A final with no retrieve is sent back and counts as a turn.
After a retrieve, one citation correction is allowed, then the run stops.
```

Append `{event:"llm_prompt", turn, prompt}` (or a hash plus length) to `audit.jsonl`.

### 2.5 SI Agent (local primary)

1. Add **Basic LLM Chain** (or Chat) `Effects Advisor`. Attach **OpenAI Chat Model**.
2. Same LiteLLM credential. Model: instructor **primary** alias from `/v1/models`. Temperature `0` or `0.1`. Raise Max Tokens enough for the six-section JSON (start at `2000` if truncated).
3. Timeout ≥ `60000` ms on a shared GPU.
4. Execute with a short incident. Expect a single JSON object, not chat filler.

If the model wraps JSON in ``` fences, strip them in Route Response.

### 2.6 Route Response

**Code** `Route Response`:

1. Parse the model text as JSON. On parse fail, log and route to a one-time “return valid JSON only” retry, then Unresolved.
2. If the object has `retrieve` → Retrieve branch.
3. If `tool` → allow-list: `tool` must be `intel_lookup` (or another tool you declared). Else log `{event:"tool_reject", reason:"not in allow-list"}` and loop with that note in `scratchpad` (counts as a turn).
4. If `final` → Final Output.
5. Else log `{event:"schema_reject"}` and retry or fail closed.
6. Write `{event:"llm_response", turn, action}` to audit.

**Switch** (or two **If** nodes) on `action` = `retrieve` | `tool` | `final`.

### 2.7 Retrieve branch

Reuse Part 1 nodes (or a sub-workflow). After Shape Retrieval:

1. Audit `{event:"retrieve", query, top_sources:[...]}`.
2. Push `{type:"retrieve", query, chunks}` onto `scratchpad`.
3. `turn_count = turn_count + 1`.
4. Wire back to Under Turn Cap.

### 2.8 Tool Call branch (`intel_lookup`)

1. **Code** `Validate Intel Args` before any HTTP:

   ```javascript
   const ip = $json.args?.ip || '';
   const cidrs = [
     ['172.16.0.0', 12], ['192.168.0.0', 16],
     ['198.51.100.0', 24], ['203.0.113.0', 24],
   ];
   function ipv4ToInt(s) {
     const p = String(s).split('.').map(Number);
     if (p.length !== 4 || p.some((n) => n < 0 || n > 255 || Number.isNaN(n))) return null;
     return ((p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3]) >>> 0;
   }
   function inCidr(ip, net, bits) {
     const a = ipv4ToInt(ip), b = ipv4ToInt(net);
     if (a === null || b === null) return false;
     const mask = bits === 0 ? 0 : (~0 << (32 - bits)) >>> 0;
     return (a & mask) === (b & mask);
   }
   const ok = cidrs.some(([n, b]) => inCidr(ip, n, b));
   if (!ok) {
     return { allowed: false, ip, error: 'ip not in allow-list CIDRs' };
   }
   return { allowed: true, ip };
   ```

2. If `allowed` is false: audit `{event:"tool_reject", ...}`, push the refusal onto `scratchpad`, increment turn, loop. **Do not** call CTI.
3. If true: **HTTP Request** `Intel Lookup`. Method `GET`. URL:

   ```text
   {{ $('Define Advisor Constants').item.json.cti_base_url }}/api/v1/ip/{{ $json.ip }}
   ```

   Header `Authorization` = `Bearer {{ $('Define Advisor Constants').item.json.cti_api_key }}`.
   **Continue On Fail** so a CTI 500 does not kill the run.

4. Audit `{event:"tool_call", ip, status, body_or_error}`. Push the result onto `scratchpad`. Increment turn. Loop.

Confirm with `8.8.8.8` (must refuse) and `203.0.113.250` (may call; expect 500; run continues).

### 2.9 Final Output

1. **Code** `Validate Handoff`: require this shape (extra keys ok; missing keys fail):

   ```json
   {
     "target_identity": {},
     "access_story": "...",
     "current_posture": "...",
     "adversary_tempo": "...",
     "partner_tasking": {
       "recommended_effect": "deny",
       "justification": "...",
       "cg": "...",
       "cv": "...",
       "citations": [{"source": "engage/...", "excerpt": "..."}]
     },
     "rollback_plan": "..."
   }
   ```
2. `recommended_effect` must be exactly one of: `deny`, `degrade`, `disrupt`, `destroy`, `deceive`, `manipulate`, `reconnoiter`, `interdict`, `handoff`. `citations` length ≥ 2, and each `source` equals a path on a retrieve entry. A final with no retrieve counts as a turn and returns to the cap. After a retrieve, a citation mismatch gets one correction, then the run writes the package with `schema_valid` false and stops. At `max_turns` the fallback handoff is `handoff` / `turn cap reached` and does not call the model again.
3. On fail: one retry prompt “return only the six-section JSON”. Then fail closed and still write audit `{event:"final", schema_valid:false}`.
4. On pass: write `$json.dir/handoff.json` and audit `{event:"final", schema_valid:true}`.

## Part 3: Validate on four incidents

**Objective:** Execute the four incidents and keep the handoff, the audit log, the workflow export, the guardrail cheatsheet, and the reflection.

1. Point the trigger at `/lab_data/incidents/output_clean.json` (or paste its JSON). Execute. Save that run’s `handoff.json` and `audit.jsonl`.
2. Repeat for `output_ambiguous.json` and `output_intel_fail.json`.
3. When the instructor issues `l44_incident_4.json`, copy it into `incidents/` and run a fourth time.
4. Open one `audit.jsonl`. You should see `turn_start` or `llm_prompt`, `llm_response`, `retrieve` and/or `tool_call`/`tool_reject`, and `final`. Empty or success-only logs fail the guardrail grade.
5. Workflow menu → export `Effects Advisor Agent-EffectsAdvisor-[YourLastName].json`. Screenshot the canvas.
6. Cheatsheet: one page mapping each of the five guardrails to a node.
7. Reflection: one paragraph. Did a retrieved chunk change the effect? Cite incident file and `source` path.

Use the local **primary** LiteLLM alias for the agent (whatever `/v1/models` named it). Do not call a model server directly.

## Constraints

- Closed environment: team Spark + class CTI only.
- No state-changing tools.
- Turn cap = 5. Hard-fail over the cap.
- Guardrails from the tool-use lecture are graded: allow-list, arg whitelist, turn cap, schema enforcement, audit log.

## Deliverables

1. Workflow JSON export `Effects Advisor Agent-EffectsAdvisor-[YourLastName].json`.
2. Chunking / embedding script used to populate Chroma.
3. Four executions (three Agent Reinforcement STIX inputs + `l44_incident_4.json`): handoff JSON + audit log each.
4. Guardrail cheatsheet — one-page markdown naming where each of the five guardrails lives in the workflow.
5. One-paragraph reflection: did retrieval ever surface a chunk that changed the effect recommendation? Cite the case.

## Success Criteria

- Agent never exceeds 5 turns.
- Agent never invokes a tool off the allow-list, and never passes an out-of-range IP to `intel_lookup`.
- `recommended_effect` is one of the nine effects-vocabulary words, spelled exactly.
- Handoff package matches the six-section shape.
- Audit log records every turn, retrieval, and tool call with timestamps.
- On at least one incident, retrieved chunks demonstrably influenced the recommendation (reflection cites that case).

## Tie-Back

- **Effects / handoff:** Effect vocabulary and handoff package.
- **Planning:** CG/CV/RFI framing.
- **Agent Reinforcement:** Input is the STIX-style output you already produce.
- **Adversary Agent Counter-Strike:** Same architecture, adversary-owned. Guardrails you build here are the checklist you hunt there.
