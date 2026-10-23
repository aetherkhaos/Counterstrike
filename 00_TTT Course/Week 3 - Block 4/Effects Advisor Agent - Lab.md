# Effects Advisor Agent

## Student Brief

**Stretch / bonus lab.** Optional after Agent Reinforcement. Not required to complete the week. The numbered steps, compose blocks, and Code snippets are **guidance, not a required procedure.** Meet the deliverables, schema, and five guardrails. Other node graphs, script languages, or Chroma API versions are fine if the evidence is the same. **Duration:** ~5 hours if you attempt it. **Stack:** n8n and Chroma are already running on your VM. n8n is `http://localhost:5678`. Chroma is the vector database on that same VM. The local **primary** model and the `embed` alias both go through team LiteLLM. Class CTI is on the team host.

## Lab Access

`<team-domain>` is the domain on the Moodle page **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**. If LiteLLM is listed as `[https://litellm.team1.cso.ops](https://litellm.team1.cso.ops)`, `<team-domain>` is `team1.cso.ops`. Use that same value for LiteLLM and CTI.

|Role|Value|
|---|---|
|n8n UI|`http://localhost:5678` on your VM|
|LiteLLM|`https://litellm.<team-domain>/v1`|
|Agent model|Local **primary** alias (instructor-published)|
|Embeddings|LiteLLM alias `embed`|
|Chroma|`http://chroma:8000` from n8n (`[http://127.0.0.1:8000](http://127.0.0.1:8000)` on the VM)|
|Class CTI|`https://cti.<team-domain>/api/v1/ip/{ip}`|
|CTI key|`cso-cti-k9m2p7x4q1`|
|KB + incidents|Moodle package → the host directory mounted at `/lab_data`|

Container path: `/lab_data/`.

## Operational Context

Agent Reinforcement emits STIX-style JSON per incident. Use your three Agent Reinforcement outputs **or** the Moodle copies (`output_clean.json`, `output_ambiguous.json`, `output_intel_fail.json`).

Build an **Effects Advisor** that reads an incident, retrieves doctrine from a local vector store, reasons in CG/CV language, calls one enrichment tool, and emits a **partner handoff package** recommending one effects-vocabulary verb: `deny`, `degrade`, `disrupt`, `destroy`, `deceive`, `manipulate`, `reconnoiter`, `interdict`, `handoff`.

The agent recommends. It does not execute effects.

## Knowledge Base

Moodle `kb/` tree. Copy into the host directory mounted at `/lab_data`:

```
docker inspect <n8n-container> --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}'
cp -a kb <host-directory-for-/lab_data>/kb
cp output_clean.json output_ambiguous.json output_intel_fail.json \
  <host-directory-for-/lab_data>/incidents/
```

If `docker` says permission denied, run `docker inspect` with `sudo`.

|Dir|Contents|
|---|---|
|`engage/`|ENGAGE goals, approaches, activities|
|`d3fend/`|D3FEND notes keyed by ATT&CK ID|
|`unit_roe/`|Effect-ceiling summary per category|
|`partner_contacts/`|Partner teams, capability, callback|
|`week1_planning/`|CG, CV, RFI extracts|

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

```
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

1. Set env: `LITELLM_BASE=https://litellm.<team-domain>/v1`, `LITELLM_MASTER_KEY`, `KB` to the host directory you copied `kb/` into, `CHROMA=[http://127.0.0.1:8000](http://127.0.0.1:8000)`.
2. Walk `KB` for `*.md`. Split each file on blank lines; merge paragraphs until ~500 characters; keep leftover as a chunk.
3. For each chunk, `POST $LITELLM_BASE/embeddings` with `{"model":"embed","input":"<chunk>"}` and `Authorization: Bearer $LITELLM_MASTER_KEY`. Read `data[0].embedding`.
4. Create Chroma collection `doctrine_index` if missing. The create response includes an `id`. `POST` add to that id with `ids`, `documents`, `embeddings`, `metadatas` (`source` = path relative to `KB`). If create says the collection already exists, `GET` it by name and use the returned `id`. Add and query reject the name in place of the id.
5. Spot-check: embed `ENGAGE disable effect on adversary collection`, query `n_results=4`. At least one `source` should start with `engage/`.

Skeleton (adapt; do not treat as the only legal script):

```
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

|Field|Value|
|---|---|
|Base URL|`https://litellm.<team-domain>/v1`|
|API Key|team LiteLLM master key|

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
    
    ```
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

|Name|Type|Value|
|---|---|---|
|`cti_base_url`|string|`https://cti.<team-domain>`|
|`cti_api_key`|string|`cso-cti-k9m2p7x4q1`|
|`chroma_url`|string|`http://chroma:8000`|
|`max_turns`|number|`5`|
|`allowed_tools`|string|`intel_lookup`|

Execute. Confirm `max_turns` is a number.

### 2.2 Run context and audit file

1. Change the Manual Trigger to also accept `incident_json` (string or JSON). Paste one Moodle incident to test.
2. Add **Code** `Set Run Context`:
    
    ```
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
    
    ```
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

```
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
    
    ```
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
    
    ```
    {{ $('Define Advisor Constants').item.json.cti_base_url }}/api/v1/ip/{{ $json.ip }}
    ```
    
    Header `Authorization` = `Bearer {{ $('Define Advisor Constants').item.json.cti_api_key }}`. **Continue On Fail** so a CTI 500 does not kill the run.
    
4. Audit `{event:"tool_call", ip, status, body_or_error}`. Push the result onto `scratchpad`. Increment turn. Loop.
    

Confirm with `8.8.8.8` (must refuse) and `203.0.113.250` (may call; expect 500; run continues).

### 2.9 Final Output

1. **Code** `Validate Handoff`: require this shape (extra keys ok; missing keys fail):
    
    ```
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

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Lab L4.4 - Effects Advisor Agent

## Instructor Answer Key (Instructor Only)

Stretch / bonus lab. Live walkthrough: confirm the team `embed` alias and the student VM's Chroma, index the Moodle KB, build a RAG + tool-use advisor under the five guardrails. Grade guardrails as strictly as the recommendation.

n8n and Chroma are already on the student VM. Embeddings are the LiteLLM alias `embed` (`ollama/qwen3-embedding:0.6b`). Students do not add a model server.

## Situational awareness (start of demo)

From the ops station (or the team Spark SSH session), establish clock, host, user, shell, OS, and that the services this lab needs are actually up:

```
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

Why this matters: a failed run is often TLS, LiteLLM auth, or class CTI, not the agent prompt. Expected: localhost n8n `200`; `/v1/models` lists the local primary alias and `embed`; CTI `198.51.100.44` → 200 score 88; `198.51.100.157` → 200 score 91 tags `exfil-c2`; fail-trigger → 500; Chroma heartbeat answers on `127.0.0.1:8000`. `<team-domain>` is that team's `BASE_DOMAIN` on **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**. If `/v1/models` shows a different primary alias, use that in the workflow.

`date -u` / `hostname` / `whoami` / `pwd` / `$SHELL` / `uname -a` / `id` / `who` / `ps` / `ss` establish remote time, host identity, user/session, interpreter, OS, other users, process table, and TCP+UDP listeners/sockets before anyone debugs GPU OOM as "the model is broken."

First-use: `curl -sk` skips TLS verify only if the ops station has not yet trusted the class CA from L1.7b; prefer a trusted CA and drop `-k`. `-sS` silences the progress meter but still shows errors. `-o /dev/null -w "%{http_code}"` prints only the status so a 302 login redirect is visible.

## Value provenance (how students know non-default values)

- LiteLLM `embed` alias: already on the team gateway; confirmed with `/v1/embeddings`. It is `ollama/qwen3-embedding:0.6b`, not a chat alias.
- Chroma `http://chroma:8000` (n8n) / `[http://127.0.0.1:8000](http://127.0.0.1:8000)` (VM): student compose; heartbeat curl.
- Collection name `doctrine_index`: student brief Part 0.
- CTI URL, Bearer `cso-cti-k9m2p7x4q1`, CIDRs `172.16.0.0/12`, `192.168.0.0/16`, `198.51.100.0/24`, `203.0.113.0/24`: student brief tool spec. `203.0.113.0/24` is required so incident 3 can call CTI and receive 500.
- KB path: host directory mounted at `/lab_data/kb`.
- Audit path `/lab_data/runs/<run_id>/`: brief Part 2; created by the run-context node.
- IPs `198.51.100.157` / `172.20.2.80`: incident JSON `extensions.cs_ops_week4.observables` plus partner_charlie.md after retrieval — not a jump-to-answer in the student brief.

## Evidence reference

|Item|Where|Default / behavior|
|---|---|---|
|n8n|`http://localhost:5678` on the student VM|Personal account, not shared owner|
|LiteLLM chat|OpenAI Chat Model|Local **primary** alias|
|LiteLLM embeddings|`POST /v1/embeddings`|Model `embed`|
|Chroma|`http://chroma:8000` from n8n|Collection `doctrine_index`|
|KB|`/lab_data/kb/`|`engage/`, `d3fend/`, `unit_roe/`, `partner_contacts/`, `week1_planning/`|
|Incidents|`/lab_data/incidents/`|Three STIX copies + `l44_incident_4.json` (mid-lab)|
|CTI|`https://cti.<team-domain>/api/v1/ip/{ip}`|Bearer `cso-cti-k9m2p7x4q1`|
|Audit / handoff|`/lab_data/runs/<run_id>/`|`audit.jsonl`, `handoff.json`|

## Recommended instructor walkthrough

### 1. Part 0 — embed and Chroma

`embed` and Chroma are already up. Confirm them. Do not have students add a model server.

Spot-check embeddings (first-use: `/v1/embeddings` is the OpenAI-compatible embeddings route; `model` must be the LiteLLM alias `embed`, not the Ollama tag, because clients talk to LiteLLM only):

```
curl -sk "https://litellm.<team-domain>/v1/embeddings" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"embed","input":"disable collection"}'
```

Key lines: `"object":"list"` and a numeric `"embedding"` array. Full vectors are long; the id/model fields plus the first few floats are enough to prove the route works.

Chroma heartbeat:

```
curl -sS http://127.0.0.1:8000/api/v2/heartbeat
```

If this 404s, try `/api/v1/heartbeat` — some Chroma tags still serve v1. Use whichever heartbeat succeeds for the rest of the script.

### 2. Chunking and embedding

Canonical host-side script (stdlib only). Inspect it before running: it only POSTs to LiteLLM embeddings and Chroma; it does not call CTI or change n8n credentials.

Usage: `python3 build_index.py` with env `LITELLM_BASE`, `LITELLM_MASTER_KEY`, optional `KB`, `CHROMA`. Defaults below.

```
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

How they know `LITELLM_BASE` and the alias `embed`: the Part 0 embeddings curl already succeeded. How they know `KB`: they copied Moodle `kb/` into the `/lab_data` mount. Do not embed whole files; paragraph-boundary chunking is the teaching point.

Spot retrieval after index (same embed function):

```
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

|Guardrail|Where|What good looks like|
|---|---|---|
|Tool allow-list|Route Response|`if action.tool not in ["intel_lookup"]: throw` (log the refusal)|
|Arg whitelist|Tool Call|`ipaddress` parse + CIDR membership in `172.16.0.0/12`, `192.168.0.0/16`, `198.51.100.0/24`, `203.0.113.0/24`|
|Max-turns cap|Loop start|hard stop at 5 with deterministic fallback|
|Schema enforcement|Final Output|JSON schema check. Citation `source` must match a retrieve path. No retrieve yet: count a turn and return to the cap. After a retrieve, one citation correction, then write the package with `schema_valid` false and stop. Cap fallback does not call the model again.|
|Audit log|Every node|`audit.jsonl` has `turn_start`, `llm_prompt`, `llm_response`, each retrieval + sources, each tool call/refusal + body, final + schema result|

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

```
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

```
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

|Symptom|Check|
|---|---|
|`embed` missing from `/v1/models`|`qwen3-embedding:0.6b` is in `OLLAMA_MODELS` and `ollama list`. LiteLLM `model_list` has `embed` → `ollama/qwen3-embedding:0.6b` (not `ollama_chat`). Recreate `litellm-gateway` after the config change.|
|`/v1/embeddings` 404 or a chat completion|Request `model` is `embed`. The `ollama/*` wildcard is chat-only.|
|Chroma heartbeat 404|Try `/api/v1/heartbeat`. Align add/query with the same API generation.|
|n8n cannot reach Chroma|Both on `web`; URL `http://chroma:8000` inside n8n, not `localhost`.|
|CTI 401|Header `Authorization: Bearer cso-cti-k9m2p7x4q1` (same key as L4.3a).|
|CTI 404 on `198.51.100.157` or `172.20.2.80`|Instructor CTI not rebuilt after seed extend. Rebuild `cti-api`.|
|Index script SSL error|Trust class CA from L1.7b, or run against LiteLLM on the Spark with the same CA bundle.|
|Agent loops the same retrieve|Turn cap not enforced; fail the guardrail.|
|`recommended_effect` synonym|Reject. Must be one of the nine lecture words.|
|Out-of-range IP accepted|Fail arg whitelist (e.g. `8.8.8.8`).|

Confirm CTI seeds used in this lab:

```
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

