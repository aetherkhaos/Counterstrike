---
id: B04.M14-key
title: Agent Reinforcement — Instructor Answer Key
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

# Lab L4.3b - Agent Reinforcement
## Instructor Answer Key (Instructor Only)

Live walkthrough: fork L4.3a, add CTI/SI failure handling, cross-check local primary vs cloud frontier, emit structured JSON. Grade schema exactly.

## Situational awareness (start of demo)

On the student VM, confirm n8n and the team services before touching workflows. `<team-domain>` is that team's `BASE_DOMAIN` (the domain on **DGX Spark team access**).

```bash
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

| Item | Where | Default / behavior |
| --- | --- | --- |
| n8n | `http://localhost:5678` on the student VM | Personal account, not shared owner |
| Build an Agentic Workflow | workflow list | `Build an Agentic Workflow-[LastName]` — do not edit |
| Reinforced | workflow list | `Agent-Reinforcement-[LastName]` |
| Test inputs | `/lab_data/` | `clean_malicious.log`, `ambiguous.log`, `intel_fail_trigger.log` |
| CTI | `https://cti.<team-domain>/api/v1/ip/{ip}` | Bearer `cso-cti-k9m2p7x4q1`. `203.0.113.250` → 500 |
| Branch A | OpenAI Chat Model | Local **primary** alias |
| Branch B | OpenAI Chat Model | **Cloud frontier** alias |
| STIX | brief task 5 | Shape only |

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

   ```text
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

   ```json
   { "classification": "ERROR", "confidence": 0, "summary": "Two consecutive invalid SI outputs; see raw_ai_output field for forensic." }
   ```

How they know 2: the IF compares `retry_count` to `2`. The student brief states the cap.

Demo: replace the `Parse SI Output` body with `throw new Error('not json');` and execute. The agent runs three times. `Read Retry Count` shows `0`, then `1`, then `2`. The second and third user prompts contain the invalid-JSON sentence (the sentence does not include the count, so those two prompts are the same text). `Set SI Error` emits `classification` `ERROR`, `confidence` `0`, and the summary above. `raw_ai_output` is the last model text. Restore `JSON.parse` before the three-file runs. A "reply with hello" system message is a weak check: the retry sentence asks for JSON, and a later try can parse and leave the loop.

First-use: **Continue (using error output)** adds a second output instead of stopping the run. **Timeout** caps the wait on LiteLLM. `$getWorkflowStaticData('global')` keeps a value for this workflow across the loop and across later runs, which is why `Set Retry Count` sets it back to `0` at the start.

### 4. Frontier second branch

1. Duplicate triage node → `SI Triage Agent (Frontier)`.
2. Same LiteLLM **credential** (base URL `https://litellm.<team-domain>/v1`). Change **model** to the frontier id published on **DGX Spark team access** for this class. Turn off **Use Responses API** on that model node. Why: the chain vs model split is already in the forked workflow; only the model node changes. A reasoning model can spend the token budget before the JSON object is written, and `JSON.parse` then throws `Unterminated fractional number`. Do not leave Branch B on a leftover alias such as `gpt-5.6-sol`; that key is expired. The id for the 13 October 2026 class is #194.
3. System prompt (same JSON schema, different strategy):

   ```text
   You are a senior security analyst. Given the evidence:
   1. List three possible classifications (Malicious, Suspicious, Benign).
   2. For each, give confidence 0-100 and a one-sentence rationale.
   3. Select the highest-confidence classification and output ONLY:
      {"classification": "...", "confidence": NN, "summary": "..."}
   No markdown.
   ```

4. Parallel Parse → **Merge** Combine by Position.
5. Code:

   ```javascript
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

```javascript
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

| Input | `classification` | `intel_unavailable` | `needs_human_review` |
| --- | --- | --- | --- |
| `clean_malicious.log` | `Malicious` | `false` | `false` |
| `ambiguous.log` | either | `false` | often `true` |
| `intel_fail_trigger.log` | model-dependent | `true` | variable |

All three must match the brief schema.

Observed on this retry graph with primary `ollama/qwen3.5:35b-a3b` and Branch B `ollama/qwen3.5:122b` (local stand-in until the class frontier id is published):

| Input | Primary | Branch B | `intel_unavailable` | `needs_human_review` |
| --- | --- | --- | --- | --- |
| `clean_malicious.log` | `Malicious` | `Malicious` | `false` | `false` |
| `ambiguous.log` | `Suspicious` | `Benign` | `false` | `true` |
| `intel_fail_trigger.log` | `Suspicious` | `Malicious` | `true` | `true` |

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
