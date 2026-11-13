---
id: B04.M14-brief
title: Agent Reinforcement — Student Brief
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

# Agent Reinforcement
## Student Brief

**Duration:** ~2.5 hours.
**Stack:** n8n is already running on your VM at `http://localhost:5678`. Personal account. Class CTI. Local primary plus the cloud frontier model, both through team LiteLLM.

## Access

`<team-domain>` is the domain on the Moodle page **DGX Spark team access**. If LiteLLM is listed as `https://litellm.team1.cso.ops`, `<team-domain>` is `team1.cso.ops`. Use that same value for LiteLLM and CTI.

| Role | Value |
| --- | --- |
| n8n UI | `http://localhost:5678` on your VM |
| LiteLLM | `https://litellm.<team-domain>/v1` |
| Class CTI | `https://cti.<team-domain>/api/v1/ip/{ip}` Bearer `cso-cti-k9m2p7x4q1` |
| Test logs | Moodle: `clean_malicious.log`, `ambiguous.log`, `intel_fail_trigger.log` |

Download `clean_malicious.log`, `ambiguous.log`, and `intel_fail_trigger.log` from this lab. `docker inspect` lists each host directory and the path inside the container. Copy the files into the host directory whose destination is `/lab_data` (the same directory as `auth_syslog.txt`).

```bash
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

   ```text
   {{ ($json.data || []).some(i => i.intel_unavailable) }}
   ```

   `Set Intel Status` is the node later steps read. It has to run on a good lookup and on a 500. Do not put that name on the error-only Set. If the format node reads a Set that only ran on the error output, a successful lookup throws `No path back to node`.

### 3. Branch A: timeout and JSON retry (local primary)

Keep `SI Triage Agent` on the local **primary** LiteLLM alias.

1. Open the OpenAI Chat Model. Set **Timeout** to `60000` ms (raise if the queue is slow).
2. Enable **Continue On Fail** (**Continue using error output**) on `SI Triage Agent` and on `Parse SI Output`.
3. Add a **Code** node `Set Retry Count` on the wire into `SI Triage Agent` only. Do not put the frontier branch through it.

   The error output is only `{error: "..."}`. It does not keep `retry_count`. A Set node also cannot read its own last value (`No path back to referenced node`). This code stores the count for the run and resets it at the start.

   ```javascript
   const sd = $getWorkflowStaticData('global');
   sd.retry_count = 0;
   sd.raw_syslog_data = $('Extract Syslog Text').item.json.raw_syslog_data;
   sd.cti_context = $('Merge CTI from all IPs together').item.json;
   return [{ json: { ...$input.item.json, retry_count: 0, raw_syslog_data: sd.raw_syslog_data, cti_context: sd.cti_context } }];
   ```

4. Point the agent user prompt at those fields, and append the correction only after a failure:

   ```text
   Analyze the following raw syslog data:
   {{ $json.raw_syslog_data }}

   Here is the Threat Intelligence context for the associated IP addresses:
   {{ JSON.stringify($json.cti_context) }}
   {{ $json.retry_count > 0 ? '\nYour previous output was invalid JSON. Return only the JSON object.' : '' }}
   ```

   A wire back to the agent cannot see `Extract Syslog Text`. The fields have to travel on the item.

5. Connect the error output of `SI Triage Agent` and of `Parse SI Output` to a **Code** node `Read Retry Count`:

   ```javascript
   const sd = $getWorkflowStaticData('global');
   let raw = '';
   try { raw = $('SI Triage Agent').item.json.text || ''; } catch (e) { raw = String($json.error || ''); }
   return [{ json: { retry_count: sd.retry_count || 0, raw_ai_output: raw, raw_syslog_data: sd.raw_syslog_data, cti_context: sd.cti_context } }];
   ```

6. Add **IF** `Retries Left?`. Number, `retry_count` **smaller than** `2`.
   - **True:** **Code** `Increment Retry Count`, then back to `SI Triage Agent` (not back through `Set Retry Count`).

     ```javascript
     const sd = $getWorkflowStaticData('global');
     sd.retry_count = (sd.retry_count || 0) + 1;
     return [{ json: { retry_count: sd.retry_count, raw_ai_output: $json.raw_ai_output, raw_syslog_data: sd.raw_syslog_data, cti_context: sd.cti_context } }];
     ```

   - **False:** **Edit Fields** `Set SI Error`. Do not wire it back to the agent. Wire it to the same **Merge** input a successful parse uses, so the run still finishes.

     | Name | Value |
     | --- | --- |
     | `classification` | `ERROR` |
     | `confidence` | `0` (number) |
     | `summary` | `Two consecutive invalid SI outputs; see raw_ai_output field for forensic.` |
     | `raw_ai_output` | `{{ $json.raw_ai_output }}` |

   That is the original try plus two retries. The third bad output stops.

7. Prove the cap, then put the parser back. Replace the `Parse SI Output` code with `throw new Error('not json');` and execute. `SI Triage Agent` runs three times. `Read Retry Count` shows `retry_count` `0`, then `1`, then `2`. The second and third user prompts contain `Your previous output was invalid JSON.` `Set SI Error` outputs `classification` `ERROR`. Restore the `JSON.parse` code. Asking the model for prose is a weak check: the retry sentence tells it to return JSON, so a later try can succeed and leave the loop early.

### 4. Branch B: cloud frontier cross-check

1. Duplicate `SI Triage Agent` → `SI Triage Agent (Frontier)`.
2. Reuse the LiteLLM OpenAI credential (`https://litellm.<team-domain>/v1`). Change **Model** to the instructor-published **cloud frontier** id. On that model node, turn off **Use Responses API**. Left on, a reasoning model can spend the token budget before the JSON object is written, and the parse step fails. Do not point at vLLM.
3. Replace the system prompt (same JSON schema, different strategy):

   ```text
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

7. Keep `Is Threat Malicious?`. Feed it Branch A `classification` and `confidence`. Do not delete the IF node.

### 5. Structured output

Add **Code** `Format Structured Output` after compare (and after the IF True path, or merge IF results into this node — final item must match this shape):

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

Adjust `$('...')` names if yours differ. `confidence` must be a number. Shape is enough; full STIX validity is not required.

### 6. Validate on three files

In `Read Syslog File`, change the path and execute the whole workflow for each:

| File | Path | Expect |
| --- | --- | --- |
| `clean_malicious.log` | `/lab_data/clean_malicious.log` | Branches agree; `intel_unavailable: false` |
| `ambiguous.log` | `/lab_data/ambiguous.log` | Often disagree → `needs_human_review: true` |
| `intel_fail_trigger.log` | `/lab_data/intel_fail_trigger.log` | CTI **500** for `203.0.113.250`; run completes; `intel_unavailable: true` |

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
