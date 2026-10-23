# Agent Reinforcement

## Student Brief

**Duration:** ~2.5 hours. **Stack:** n8n is already running on your VM at `http://localhost:5678`. Personal account. Class CTI. Local primary plus the cloud frontier model, both through team LiteLLM.

## Access

`<team-domain>` is the domain on the Moodle page **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**. If LiteLLM is listed as `[https://litellm.team1.cso.ops](https://litellm.team1.cso.ops)`, `<team-domain>` is `team1.cso.ops`. Use that same value for LiteLLM and CTI.

|Role|Value|
|---|---|
|n8n UI|`http://localhost:5678` on your VM|
|LiteLLM|`https://litellm.<team-domain>/v1`|
|Class CTI|`https://cti.<team-domain>/api/v1/ip/{ip}` Bearer `cso-cti-k9m2p7x4q1`|
|Test logs|Moodle: `clean_malicious.log`, `ambiguous.log`, `intel_fail_trigger.log`|

Download the three logs from Moodle. `docker inspect` lists each host directory and the path inside the container. Copy the files into the host directory whose destination is `/lab_data` (the same directory as `auth_syslog.txt`).

```
docker inspect <n8n-container> --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}'
cp clean_malicious.log ambiguous.log intel_fail_trigger.log <host-directory-for-/lab_data>/
```

If `docker` says permission denied, run those commands with `sudo`. The workflow reads `/lab_data/<file>`. Confirm `Build an Agentic Workflow-[YourLastName]` still runs, then fork.

## Context

Build an Agentic Workflow is the happy path. Harden it so a CTI 500 or bad JSON does not crash the run, then cross-check the local primary against the cloud frontier model.

## Tasks

### 1. Fork Build an Agentic Workflow

1. Open `Build an Agentic Workflow-[YourLastName]`.
2. Workflow menu → **Duplicate**.
3. Rename the copy `Agent-Reinforcement-[YourLastName]`.
4. Confirm the original still exists. Work only in the copy.

### 2. CTI Continue On Fail

Enable **Continue On Fail** (**Continue using error output**) on `Query CTI Database` and on `API Call for each IP detected`. A 500 must not stop the run.

On `API Call for each IP detected` only:

1. Success output → **Edit Fields** `Set Intel OK`. Boolean `intel_unavailable` = `false`. Include the other fields. Wire it to **Merge** `Merge CTI paths` input 1.
2. Error output → **Edit Fields** `Set Intel Error`. Boolean `intel_unavailable` = `true`. String `intel_raw` = `{{ $json.error?.message || $json.error || 'unknown' }}`. Include the other fields. Wire it to `Merge CTI paths` input 2.
3. Set that Merge to **Append**. Its output goes to the existing `Merge CTI from all IPs together`.
4. After that aggregate, add **Edit Fields** `Set Intel Status`. Include the other fields. Boolean:
    
    ```
    {{ ($json.data || []).some(i => i.intel_unavailable) }}
    ```
    
    `Set Intel Status` is the node later steps read. It has to run on a good lookup and on a 500. Do not put that name on the error-only Set. If the format node reads a Set that only ran on the error output, a successful lookup throws `No path back to node`.
    

### 3. Branch A: timeout and JSON retry (local primary)

Keep `SI Triage Agent` on the local **primary** LiteLLM alias.

1. Open the OpenAI Chat Model. Set **Timeout** to `60000` ms (raise if the queue is slow).
2. Enable **Continue On Fail** (**Continue using error output**) on `SI Triage Agent` and on `Parse SI Output`.
3. Add a **Code** node `Set Retry Count` on the wire into `SI Triage Agent` only. Do not put the frontier branch through it.
    
    The error output is only `{error: "..."}`. It does not keep `retry_count`. A Set node also cannot read its own last value (`No path back to referenced node`). This code stores the count for the run and resets it at the start.
    
    ```
    const sd = $getWorkflowStaticData('global');
    sd.retry_count = 0;
    sd.raw_syslog_data = $('Extract Syslog Text').item.json.raw_syslog_data;
    sd.cti_context = $('Merge CTI from all IPs together').item.json;
    return [{ json: { ...$input.item.json, retry_count: 0, raw_syslog_data: sd.raw_syslog_data, cti_context: sd.cti_context } }];
    ```
    
4. Point the agent user prompt at those fields, and append the correction only after a failure:
    
    ```
    Analyze the following raw syslog data:
    {{ $json.raw_syslog_data }}
    
    Here is the Threat Intelligence context for the associated IP addresses:
    {{ JSON.stringify($json.cti_context) }}
    {{ $json.retry_count > 0 ? '\nYour previous output was invalid JSON. Return only the JSON object.' : '' }}
    ```
    
    A wire back to the agent cannot see `Extract Syslog Text`. The fields have to travel on the item.
    
5. Connect the error output of `SI Triage Agent` and of `Parse SI Output` to a **Code** node `Read Retry Count`:
    
    ```
    const sd = $getWorkflowStaticData('global');
    let raw = '';
    try { raw = $('SI Triage Agent').item.json.text || ''; } catch (e) { raw = String($json.error || ''); }
    return [{ json: { retry_count: sd.retry_count || 0, raw_ai_output: raw, raw_syslog_data: sd.raw_syslog_data, cti_context: sd.cti_context } }];
    ```
    
6. Add **IF** `Retries Left?`. Number, `retry_count` **smaller than** `2`.
    
    - **True:** **Code** `Increment Retry Count`, then back to `SI Triage Agent` (not back through `Set Retry Count`).
        
        ```
        const sd = $getWorkflowStaticData('global');
        sd.retry_count = (sd.retry_count || 0) + 1;
        return [{ json: { retry_count: sd.retry_count, raw_ai_output: $json.raw_ai_output, raw_syslog_data: sd.raw_syslog_data, cti_context: sd.cti_context } }];
        ```
        

- **False:** **Edit Fields** `Set SI Error`. Do not wire it back to the agent. Wire it to the same **Merge** input a successful parse uses, so the run still finishes.
    
    |Name|Value|
    |---|---|
    |`classification`|`ERROR`|
    |`confidence`|`0` (number)|
    |`summary`|`Two consecutive invalid SI outputs; see raw_ai_output field for forensic.`|
    |`raw_ai_output`|`{{ $json.raw_ai_output }}`|
    
    That is the original try plus two retries. The third bad output stops.
    

7. Prove the cap, then put the parser back. Replace the `Parse SI Output` code with `throw new Error('not json');` and execute. `SI Triage Agent` runs three times. `Read Retry Count` shows `retry_count` `0`, then `1`, then `2`. The second and third user prompts contain `Your previous output was invalid JSON.` `Set SI Error` outputs `classification` `ERROR`. Restore the `JSON.parse` code. Asking the model for prose is a weak check: the retry sentence tells it to return JSON, so a later try can succeed and leave the loop early.

### 4. Branch B: cloud frontier cross-check

1. Duplicate `SI Triage Agent` → `SI Triage Agent (Frontier)`.
2. Reuse the LiteLLM OpenAI credential (`https://litellm.<team-domain>/v1`). Change **Model** to the instructor-published **cloud frontier** id. On that model node, turn off **Use Responses API**. Left on, a reasoning model can spend the token budget before the JSON object is written, and the parse step fails. Do not point at vLLM.
3. Replace the system prompt (same JSON schema, different strategy):
    
    ```
    You are a senior security analyst. Given the evidence:
    1. List three possible classifications (Malicious, Suspicious, Benign).
    2. For each, give confidence 0-100 and a one-sentence rationale.
    3. Select the highest-confidence classification and output ONLY:
      {"classification": "...", "confidence": NN, "summary": "..."}
    No markdown.
    ```
    
4. Duplicate `Parse SI Output` for the frontier branch (or parse each branch before merge).
    
5. **Merge** both parsed objects. Combine → By Position.
6. Add **Code** `Compare Branches`:
    
    ```
    const a = $input.all()[0].json;
    const b = $input.all()[1].json;
    const agree = a.classification === b.classification;
    return {
     primary: a,
     secondary: b,
     branch_classifications: [a.classification, b.classification],
     needs_human_review: !agree
    };
    ```
    
7. Keep `Is Threat Malicious?`. Feed it Branch A `classification` and `confidence`. Do not delete the IF node.
    

### 5. Structured output

Add **Code** `Format Structured Output` after compare (and after the IF True path, or merge IF results into this node — final item must match this shape):

```
const x = $input.item.json;
const now = new Date().toISOString();
return {
  type: "indicator",
  id: `indicator--${Date.now().toString(16)}-${Math.random().toString(16).slice(2)}`,
  created: now,
  pattern_type: "stix",
  indicator_types: [x.primary.classification.toLowerCase()],
  confidence: x.primary.confidence,
  description: x.primary.summary,
  extensions: {
    cs_ops_week4: {
      intel_unavailable: $('Set Intel Status').item.json.intel_unavailable || false,
      needs_human_review: x.needs_human_review,
      branch_classifications: x.branch_classifications,
      source_artifact: $('Read Syslog File').item.json.fileName || 'unknown'
    }
  }
};
```

Adjust `$('...')` names if yours differ. `confidence` must be a number. Shape is enough; full STIX validity is not required.

### 6. Validate on three files

In `Read Syslog File`, change the path and execute the whole workflow for each:

|File|Path|Expect|
|---|---|---|
|`clean_malicious.log`|`/lab_data/clean_malicious.log`|Branches agree; `intel_unavailable: false`|
|`ambiguous.log`|`/lab_data/ambiguous.log`|Often disagree → `needs_human_review: true`|
|`intel_fail_trigger.log`|`/lab_data/intel_fail_trigger.log`|CTI **500** for `203.0.113.250`; run completes; `intel_unavailable: true`|

Save each JSON output.

### 7. Export

Workflow menu → export JSON as `Agent-Reinforcement-[YourLastName].json`. Screenshot the canvas.

## Constraints

- Leave Build an Agentic Workflow untouched.
- Branch A = local primary. Branch B = cloud frontier. No direct vLLM.
- Keep the Build an Agentic Workflow IF node.

## Deliverables

1. Screenshot of the reinforced canvas.
2. `Agent-Reinforcement-[YourLastName].json`.
3. Three structured outputs (one per test file).
4. One-paragraph reflection: where branches disagreed, which you trust and why.

## Success

- CTI 500 → structured output with `intel_unavailable: true`, not a crashed run.
- Bad JSON → retry, then `"classification": "ERROR"` if still broken.
- Ambiguous input → `needs_human_review: true`.
- All three outputs match the schema in task 5.

## Tie-Back

- **Build an Agentic Workflow:** Parse / branch / transform, now with failures and a second model.
- **Effects discipline:** `needs_human_review` is the escalate step in automation form.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Lab L4.3b - Agent Reinforcement

## Instructor Answer Key (Instructor Only)

Live walkthrough: fork L4.3a, add CTI/SI failure handling, cross-check local primary vs cloud frontier, emit structured JSON. Grade schema exactly.

## Situational awareness (start of demo)

On the student VM, confirm n8n and the team services before touching workflows. `<team-domain>` is that team's `BASE_DOMAIN` (the domain on **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")**).

```
date -u
hostname
whoami
curl -sS -o /dev/null -w "%{http_code}\n" "http://localhost:5678/"
curl -sk "https://litellm.<team-domain>/v1/models" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY"
curl -sk "https://cti.<team-domain>/api/v1/ip/198.51.100.44" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
curl -sk -o /dev/null -w "%{http_code}\n" \
  "https://cti.<team-domain>/api/v1/ip/203.0.113.250" \
  -H "Authorization: Bearer cso-cti-k9m2p7x4q1"
```

Why: n8n, LiteLLM aliases, and class CTI must be up before students debug the model. Expected: localhost n8n `200`; `/v1/models` lists local aliases plus the published frontier id; `198.51.100.44` → 200 score 88; fail-trigger IP → 500.

`date -u` / `hostname` / `whoami` establish clock, host, and user on that VM.

## Value provenance

- Fail-trigger IP `203.0.113.250`: Moodle `intel_fail_trigger.log` plus CTI 500 behavior.
- Test files: Moodle package; copy into the host directory mounted at `/lab_data`.
- Frontier model id: instructor-published LiteLLM name (not a vendor URL in student docs).
- STIX shape: student brief task 5.
- Node names in sample code must match the student's graph.

## Evidence reference

|Item|Where|Default / behavior|
|---|---|---|
|n8n|`http://localhost:5678` on the student VM|Personal account, not shared owner|
|Build an Agentic Workflow|workflow list|`Build an Agentic Workflow-[LastName]` — do not edit|
|Reinforced|workflow list|`Agent-Reinforcement-[LastName]`|
|Test inputs|`/lab_data/`|`clean_malicious.log`, `ambiguous.log`, `intel_fail_trigger.log`|
|CTI|`https://cti.<team-domain>/api/v1/ip/{ip}`|Bearer `cso-cti-k9m2p7x4q1`. `203.0.113.250` → 500|
|Branch A|OpenAI Chat Model|Local **primary** alias|
|Branch B|OpenAI Chat Model|**Cloud frontier** alias|
|STIX|brief task 5|Shape only|

## Walkthrough

### 1. Preserve L4.3a

1. Student logs into n8n as themselves.
2. Open Build an Agentic Workflow → **Duplicate** → `Agent-Reinforcement-[LastName]`.
3. Confirm the original still exists.

Reject in-place edits.

How they know the name: L4.3a export convention plus this brief. Duplicate (not copy-paste of nodes) keeps credentials.

### 2. HTTP Continue On Fail

On both CTI **HTTP Request** nodes, **Settings** → **Continue (using error output)**. Why: a 500 must not kill the run. The default halt showed up on an unknown IP such as `8.8.8.8`.

Wire the error branch on `API Call for each IP detected`. `Query CTI Database` in the forked workflow looks up the constant `suspicious_ip` (`198.51.100.44`), which is seeded and returns 200. The 500 is on the per-IP call.

1. Success → **Set** `Set Intel OK`: `intel_unavailable` false (boolean), include other fields. **Merge** `Merge CTI paths` input 1.
2. Error → **Set** `Set Intel Error`: `intel_unavailable` true (boolean), `intel_raw` = `{{ $json.error?.message || $json.error || 'unknown' }}`, include other fields. Merge input 2.
3. Merge mode **Append**. Output → existing aggregate `Merge CTI from all IPs together`.
4. After the aggregate, **Set** `Set Intel Status`, include other fields:
    
    ```
    {{ ($json.data || []).some(i => i.intel_unavailable) }}
    ```
    
    This Set always runs. The STIX node reads `$('Set Intel Status')`. Naming the error-only Set that way throws `No path back to node` on a successful lookup.
    

Test: point Read File at `intel_fail_trigger.log` (IP `203.0.113.250`). Run completes with `intel_unavailable: true`.

How they know `203.0.113.250`: it is the only external IP in that Moodle log; CTI returns 500 for that address.

### 3. Primary timeout and JSON retry

On Branch A (`SI Triage Agent`, local primary):

1. Timeout 60000 ms (raise if GPU queue is long). Why: shared Spark, not a short call.
2. **Continue (using error output)** on `SI Triage Agent` and `Parse SI Output`. The error item is only `{error: "..."}`. `retry_count` is gone. A Set node that reads itself throws `No path back to referenced node`.
3. **Code** `Set Retry Count` sits on the primary wire only. It zeros `$getWorkflowStaticData('global').retry_count` and copies `raw_syslog_data` plus `cti_context` onto the item. The looped agent cannot see `Extract Syslog Text` (paired-item path breaks on the way back).
4. User prompt uses `$json.raw_syslog_data`, `JSON.stringify($json.cti_context)`, and appends `Your previous output was invalid JSON. Return only the JSON object.` when `$json.retry_count > 0`.
5. Both error outputs go to **Code** `Read Retry Count`, then **IF** `Retries Left?` (`retry_count` number **smaller than** 2). True goes through **Code** `Increment Retry Count` and back to `SI Triage Agent`. False is **Set** `Set SI Error`. That Set feeds **Merge Branches** input 0 (the same input a good parse uses) and does not loop. Without that wire, a primary parse that never succeeds leaves the merge waiting.
    
    Counts: first failure sees `0` and retries; second sees `1` and retries; third sees `2` and stops. That is two retries, then:
    
    ```
    { "classification": "ERROR", "confidence": 0, "summary": "Two consecutive invalid SI outputs; see raw_ai_output field for forensic." }
    ```
    

How they know 2: the IF compares `retry_count` to `2`. The student brief states the cap.

Demo: replace the `Parse SI Output` body with `throw new Error('not json');` and execute. The agent runs three times. `Read Retry Count` shows `0`, then `1`, then `2`. The second and third user prompts contain the invalid-JSON sentence (the sentence does not include the count, so those two prompts are the same text). `Set SI Error` emits `classification` `ERROR`, `confidence` `0`, and the summary above. `raw_ai_output` is the last model text. Restore `JSON.parse` before the three-file runs. A "reply with hello" system message is a weak check: the retry sentence asks for JSON, and a later try can parse and leave the loop.

First-use: **Continue (using error output)** adds a second output instead of stopping the run. **Timeout** caps the wait on LiteLLM. `$getWorkflowStaticData('global')` keeps a value for this workflow across the loop and across later runs, which is why `Set Retry Count` sets it back to `0` at the start.

### 4. Frontier second branch

1. Duplicate triage node → `SI Triage Agent (Frontier)`.
2. Same LiteLLM **credential** (base URL `https://litellm.<team-domain>/v1`). Change **model** to the frontier id published on **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")** for this class. Turn off **Use Responses API** on that model node. Why: the chain vs model split is already in the forked workflow; only the model node changes. A reasoning model can spend the token budget before the JSON object is written, and `JSON.parse` then throws `Unterminated fractional number`. Do not leave Branch B on a leftover alias such as `gpt-5.6-sol`; that key is expired. The id for the 13 October 2026 class is #194.
3. System prompt (same JSON schema, different strategy):
    
    ```
    You are a senior security analyst. Given the evidence:
    1. List three possible classifications (Malicious, Suspicious, Benign).
    2. For each, give confidence 0-100 and a one-sentence rationale.
    3. Select the highest-confidence classification and output ONLY:
      {"classification": "...", "confidence": NN, "summary": "..."}
    No markdown.
    ```
    
4. Parallel Parse → **Merge** Combine by Position.
    
5. Code:
    
    ```
    const a = $input.all()[0].json;
    const b = $input.all()[1].json;
    const agree = a.classification === b.classification;
    return {
     primary: a,
     secondary: b,
     branch_classifications: [a.classification, b.classification],
     needs_human_review: !agree
    };
    ```
    
6. Keep `Is Threat Malicious?` from L4.3a; feed it the primary classification/confidence.
    

Test `ambiguous.log` (`198.51.100.99`, CTI classification `suspicious`, score 42). Expect disagreement often enough to set `needs_human_review`.

Identical prompts on both branches are a fail — `needs_human_review` never fires.

### 5. STIX output

Final Code node:

```
const x = $input.item.json;
const now = new Date().toISOString();
return {
  type: "indicator",
  id: `indicator--${Date.now().toString(16)}-${Math.random().toString(16).slice(2)}`,
  created: now,
  pattern_type: "stix",
  indicator_types: [x.primary.classification.toLowerCase()],
  confidence: x.primary.confidence,
  description: x.primary.summary,
  extensions: {
    cs_ops_week4: {
      intel_unavailable: $('Set Intel Status').item.json.intel_unavailable || false,
      needs_human_review: x.needs_human_review,
      branch_classifications: x.branch_classifications,
      source_artifact: $('Read Syslog File').item.json.fileName || 'unknown'
    }
  }
};
```

Adjust node names if the student renamed them. `confidence` must be a number. This n8n code sandbox has no `crypto`, so `crypto.randomUUID()` throws `ReferenceError: crypto is not defined`. Build the indicator id from `Date.now()` and `Math.random()`.

### 6. Three inputs

|Input|`classification`|`intel_unavailable`|`needs_human_review`|
|---|---|---|---|
|`clean_malicious.log`|`Malicious`|`false`|`false`|
|`ambiguous.log`|either|`false`|often `true`|
|`intel_fail_trigger.log`|model-dependent|`true`|variable|

All three must match the brief schema.

Observed on this retry graph with primary `ollama/qwen3.5:35b-a3b` and Branch B `ollama/qwen3.5:122b` (local stand-in until the class frontier id is published):

|Input|Primary|Branch B|`intel_unavailable`|`needs_human_review`|
|---|---|---|---|---|
|`clean_malicious.log`|`Malicious`|`Malicious`|`false`|`false`|
|`ambiguous.log`|`Suspicious`|`Benign`|`false`|`true`|
|`intel_fail_trigger.log`|`Suspicious`|`Malicious`|`true`|`true`|

Grade the flags, not those exact words. A different frontier model can pick different labels. `ambiguous.log` is a pass when the labels differ. `intel_fail_trigger.log` is a pass when the run finishes and `intel_unavailable` is true.

### 7. Reflection

Strong: cites a specific disagreement, compares rationales, does not treat higher confidence as truth.

Weak: "frontier is always right" with no evidence.

### 8. Export

Collect JSON + three outputs.

## Common mistakes

- Editing L4.3a in place.
- Missing `retry_count >= 2` (infinite loop).
- Branch B still on the local primary.
- Calling vLLM instead of LiteLLM.
- STIX `confidence` as string; `cs_ops_week4` nested wrong.
- Skipping `intel_fail_trigger.log`.

## Course link

L4.3b reinforcement: survive errors, cross-check two models, emit a structured intel record.