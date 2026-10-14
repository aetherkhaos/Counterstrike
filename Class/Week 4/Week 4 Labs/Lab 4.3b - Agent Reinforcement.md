## Purpose[](#purpose)

This lab asks you to harden the L4.3a "happy path" agentic workflow so it survives adversarial conditions, cross-checks its own reasoning, and emits structured intelligence the rest of the week can consume.

Duration: about 2.5 hours (Day 3 afternoon).

The output of this lab is the evidence-bundle export format that Day 4's RAG lab (L4.4) will read, so treat the schema work as operational, not cosmetic.

## Lab Access Model[](#lab-access-model)

You are continuing on the same pre-staged agentic lab VM used in L4.3a. All work happens in the local n8n canvas on that VM.

|Role|Student-facing value|Notes|
|---|---|---|
|n8n UI|`http://localhost:5678`|Primary workflow builder and execution audit surface. Login: **`student@cs.ops`** / **`1qaz2wsx!QAZ@WSX`**.|
|Ollama (from n8n nodes)|`http://ollama:11434`|Local model backend; keep `phi4-mini`.|
|Mock CTI API (from n8n nodes)|`http://cti-api:5000`|Threat-intel lookups; you will harden failure handling here.|
|L4.3a baseline workflow|n8n workflow list|Named `Week4-Day3-Part1-[YourLastName]` or equivalent. Must remain untouched.|
|Reinforced workflow|n8n workflow list|Duplicate named `Week4-Day3-Reinforced`. This is your graded artifact.|

### Environment Start and Verification[](#environment-start-and-verification)

1. Confirm the lab stack is running:
    
    ```
    cd /opt/agentic
    docker compose up -d
    docker ps
    ```
    
2. Open `http://localhost:5678`, log in with **`student@cs.ops`** / **`1qaz2wsx!QAZ@WSX`**, and verify your L4.3a workflow still executes successfully before forking it.
    
3. Duplicate the L4.3a workflow and rename the copy `Week4-Day3-Reinforced`. Do not modify the original.
    

## Operational Context[](#operational-context)

**Carry-over from L4.3a:** Your workflow now ingests a syslog-style artifact, queries a mock threat-intel API, hands the combined context to a `phi4-mini` AI Agent, parses the JSON output, branches on classification, and emits a finalized output. That is the happy path.

Real operations do not run the happy path. Logs are malformed, APIs return 500s, models hallucinate, and prompts drift.

**The reinforcement goal:** Take the working L4.3a workflow and add:

1. Error handling and retry discipline around the HTTP and AI calls.
2. A second AI branch using a different prompt strategy on the same evidence so the two branches' outputs can be cross-checked.
3. A STIX-style structured output that other tools in your notional CPT can ingest.

## Required Work[](#required-work)

1. **Fork your L4.3a workflow.** Duplicate it in n8n and rename the copy `Week4-Day3-Reinforced`. Do not modify the L4.3a original. You will compare them in the back-brief.
    
2. **Add error handling.**
    
    - On the HTTP Request node for the threat-intel API, enable **Continue On Fail** and route the error branch to a `Set` node that stamps `"intel_unavailable": true` onto the downstream payload.
    - On the AI Agent node, set a **timeout** (60s is the suggested default) and wire the failure branch to a **retry** loop that rebuilds the prompt with an explicit correction line: "your previous output was invalid JSON; produce only the JSON object." Maximum retries: 2. After that, fail gracefully with a `"classification": "ERROR"` record.
3. **Add a second AI branch.** Duplicate the AI Agent node. Give it the same context but a different prompt strategy. Examples:
    
    - Original branch: "act as a security analyst; output JSON."
    - New branch: "list three possible classifications for this evidence, score each on a 0-100 confidence, pick the highest and explain." (Chain-of-thought style, more explicit about uncertainty.)
    
    Wire both branches into a **Merge** node. Use a subsequent **Code** node to compare their classifications. If they agree, continue. If they disagree, emit `"needs_human_review": true` and route both payloads to the final output unchanged.
    
4. **Emit STIX-style output.** The final transform should produce a JSON object matching roughly:
    
    ```
    {
      "type": "indicator",
      "id": "indicator--<uuid>",
      "created": "<iso8601>",
      "pattern_type": "stix",
      "indicator_types": ["<classification>"],
      "confidence": <0-100>,
      "description": "<summary>",
      "extensions": {
        "cs_ops_week4": {
          "intel_unavailable": <bool>,
          "needs_human_review": <bool>,
          "branch_classifications": ["<p1>", "<p2>"],
          "source_artifact": "<filename>"
        }
      }
    }
    ```
    
    You do not need full STIX validity. Hitting the shape above is enough.
    
5. **Validate on three test inputs.**
    
    - Input 1: a clean, obvious malicious syslog (both branches should agree).
    - Input 2: an ambiguous syslog with marginal evidence (branches may disagree; `needs_human_review` should fire).
    - Input 3: a syslog whose intel lookup is forced to fail (`intel_unavailable` path should activate; classification should still come through).
6. **Export the workflow JSON and three example outputs** from n8n. These become your Day 4 inputs.
    

## Constraints and Rules of Engagement[](#constraints-and-rules-of-engagement)

- Keep the L4.3a original untouched. Grading on Day 3 compares the two side by side.
- Do not change the `phi4-mini` model or bring in a cloud LLM. This runs in the closed environment.
- Do not remove the IF-node branching from L4.3a. Add on top of it; do not refactor it away.

## Evidence Expectations[](#evidence-expectations)

Submit to the instructor:

1. **Workflow screenshot** showing the reinforced workflow laid out in n8n.
2. **Workflow JSON export** (`Week4-Day3-Reinforced.json`).
3. **Three execution outputs** matching the STIX-style schema, one per test input.
4. **One-paragraph reflection:** where did the two AI branches disagree, and which branch was "right" in your judgment?

## Success Criteria[](#success-criteria)

- Forced HTTP 500 from the threat-intel API produces a STIX output with `intel_unavailable: true`, not a failed execution.
- Intentional malformed-JSON output from the first AI Agent is detected, retried, and eventually falls back to `"classification": "ERROR"` without crashing the workflow.
- On the ambiguous test input, the two AI branches return different classifications and the final output carries `needs_human_review: true`.
- STIX output hits the shape above for all three inputs.

## Course Tie-Back[](#course-tie-back)

- **L4.3a:** Reinforces the parse / branch / transform discipline from the morning build.
- **Day 4:** This lab's STIX-style output is the input format for L4.4 (Effects Advisor Agent).
- **Lecture 4.1:** The `needs_human_review` flag is the automation-friendly version of the escalate-to-commander step from the authority thermometer.