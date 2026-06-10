# Part 3 - Parse, Branch, and Transform the Output[](#part-3---parse-branch-and-transform-the-output)

[Back to lab overview](/dco-counterstrike-pilot-course-content/module-content/-/blob/main/../index.md) | [Previous: Part 2](/dco-counterstrike-pilot-course-content/module-content/-/blob/main/docs/labs/L4.3_Agentic_Workflows/parts/part-2-configure-ai-triage-agent.md)

## Operational Context[](#operational-context)

Your `phi4-mini` AI Agent has generated a structured JSON response, but n8n still treats that response as text until you parse it. In this part, you convert the model output into usable fields, route high-confidence malicious activity through an IF node, and transform the result into a human-readable incident report.

## What to Do[](#what-to-do)

### Step 1: Parse the AI Output[](#step-1-parse-the-ai-output)

Even though the LLM output looks like JSON, n8n initially treats it as a text string. Convert it into a native JSON object so you can reference `classification`, `confidence`, and `summary`.

1. Click the **+** button next to `AI Triage Agent`.
    
2. Search for the **Code** node and add it to the canvas.
    
3. Paste this JavaScript into the editor:
    
    ```
    // Get the output string from the AI node
    const aiResponse = $input.item.json.text;
    
    // Parse the string into a valid JSON object
    const parsedData = JSON.parse(aiResponse);
    
    // Return the parsed data so the next node can use it
    return parsedData;
    ```
    
4. Rename the node to `Parse AI Output`.
    
5. Click **Execute Node**.
    

The output pane should now show separate JSON keys for `classification`, `confidence`, and `summary`.

> **Repetition Task:** In the JavaScript editor, intentionally delete the closing parenthesis on the `JSON.parse` command so it reads `JSON.parse(aiResponse;`. Execute the node and observe the syntax error. Put the parenthesis back and execute it again. This is similar to what happens if the AI model returns malformed JSON.

> **Check Your Understanding**
> 
> Question: If the Code node fails because the LLM generated bad JSON, the workflow crashes. How could you design the workflow to recover automatically instead of crashing?
> 
> Hint: Look at the **Settings** tab of the Code node and think about how you might route the error back to the AI.

### Step 2: Add Conditional Branching with an IF Node[](#step-2-add-conditional-branching-with-an-if-node)

Now make the workflow take a different path when the AI identifies a true threat.

1. Add a new node after `Parse AI Output`.
2. Search for and select the **If** node.
3. Click **Add Condition -> String**.
4. In **Value 1**, click the gear icon to add an expression, then drag in the `classification` value from `Parse AI Output`.
5. Set **Operation** to `Equal`.
6. In **Value 2**, type `Malicious`.
7. Rename the node to `Is Threat Malicious?`.
8. Click **Execute Node**.

Because the mock CTI data and syslog data indicate brute-force activity, execution should route down the **True** branch.

> **Repetition Task:** Relying only on the word `Malicious` is risky. Add a secondary condition. Click **Add Condition -> Number** under the first condition. Map **Value 1** to `confidence` from `Parse AI Output`. Set **Operation** to `Larger or Equal`. Map **Value 2** to `confidence_threshold` from `Define Mission Constants`. Now the data must be classified as `Malicious` and have confidence of at least `85` to escalate.

> **Check Your Understanding**
> 
> Question: If an analyst manually reviewing these logs determines the activity is a false positive, and the AI also classifies it as `Benign`, where does the data go in this IF node?
> 
> Hint: Look at the outputs on the right side of the IF node.

### Step 3: Transform the Escalation Output[](#step-3-transform-the-escalation-output)

The final step is to package the raw logs, CTI data, and AI reasoning into a readable incident report for an IR handoff.

1. Hover over the **True** output of `Is Threat Malicious?` and click the **+** button.
    
2. Search for the **Edit Fields (Set)** node.
    
3. Click **Add Value -> String**.
    
4. Name the new field `markdown_report`.
    
5. For the value, use the Expression Editor to build this formatted alert:
    
    ```
    [HIGH CONFIDENCE THREAT]
    
    **Target Subnet:** {{ $('Define Mission Constants').item.json.target_subnet }}
    **Suspicious IP:** {{ $('Define Mission Constants').item.json.suspicious_ip }}
    
    **AI Assessment:** {{ $('Parse AI Output').item.json.classification }} (Confidence: {{ $('Parse AI Output').item.json.confidence }}%)
    **AI Summary:** {{ $('Parse AI Output').item.json.summary }}
    
    **CTI Context:**
    {{ $('Merge CTI from all IPs together').item.json }}
    ```
    
6. Rename this node to `Format IR Ticket`.
    
7. Click **Execute Node**.
    

> **Repetition Task:** Add a new String value to this node called `slack_alert_short`. Create a condensed one-sentence alert that could be sent to Mattermost or Slack, such as:
> 
> ```
> Alert: {{ $('Parse AI Output').item.json.classification }} activity detected from {{ $('Define Mission Constants').item.json.suspicious_ip }}
> ```

> **Check Your Understanding**
> 
> Question: Why do you transform the data into Markdown here instead of asking `phi4-mini` to output a Markdown report directly in Part 2?
> 
> Hint: Think about what data format the IF node needs to route the workflow.

## Evidence to Capture[](#evidence-to-capture)

- Parsed JSON output from `Parse AI Output`.
- IF-node routing result from `Is Threat Malicious?`.
- Final `markdown_report` from `Format IR Ticket`.

## Next Step[](#next-step)

Return to the [lab overview](/dco-counterstrike-pilot-course-content/module-content/-/blob/main/../index.md) for the final validation checklist, export instructions, and self-check appendix. Then continue to Lab L4.3b to harden this workflow.