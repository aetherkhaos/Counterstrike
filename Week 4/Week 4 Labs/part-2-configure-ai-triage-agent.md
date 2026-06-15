# Part 2 - Configure the AI Triage Agent[](#part-2---configure-the-ai-triage-agent)

[Back to lab overview](/dco-counterstrike-pilot-course-content/module-content/-/blob/main/../index.md) | [Previous: Part 1](/dco-counterstrike-pilot-course-content/module-content/-/blob/main/docs/labs/L4.3_Agentic_Workflows/parts/part-1-workflow-foundation-and-data-collection.md)

## Operational Context[](#operational-context)

Now that your workflow can read syslog evidence and enrich indicators, configure the AI node that will classify the activity. You will connect the local `phi4-mini` model, tune parameters for repeatable triage output, and inject evidence plus CTI context into the prompt.

## What to Do[](#what-to-do)

### Step 1: Add the AI Node and Connect Ollama[](#step-1-add-the-ai-node-and-connect-ollama)

1. Click the **+** button next to `Merge CTI from all IPs together`.
    
2. Search for **Basic LLM Chain** and add it to the canvas.
    
3. Notice that this node has a sub-input on the bottom left for a model. You need to provide it with the Ollama engine.
    
4. Click the **+** icon on that sub-input, search for **Ollama Chat Model**, and select it.
    
5. Configure the Ollama Chat Model:
    
    |Field|Value|
    |---|---|
    |Base URL|`http://ollama:11434`|
    |Model|`phi4-mini`|
    
6. Close the Ollama Chat Model settings.
    
7. Rename the Basic LLM Chain node to `AI Triage Agent`.
    

> **Repetition Task:** Disconnect the Ollama Chat Model from the Basic LLM Chain by clicking the connection wire and pressing Delete. Look at `AI Triage Agent`; it should show an error indicating that it lacks a model. Reconnect the model by dragging the connector from the Ollama Chat Model back into the model input on the Basic LLM Chain.

> **Check Your Understanding**
> 
> Question: Why does n8n separate the LLM Chain or Agent node from the Model node instead of using one single AI node?
> 
> Hint: Think about what happens if the backend model provider changes next year.

### Step 2: Tune Model Parameters[](#step-2-tune-model-parameters)

Because this agent supports security triage, reduce model creativity and make the output more repeatable.

1. Open the **Ollama Chat Model** node settings again.
2. Scroll down to **Options** and click **Add Option**.
3. Select **Temperature**.
4. Set **Temperature** to `0`, or `0.1` if the UI does not permit `0`.
5. Close the model settings.

> **Repetition Task:** Add another option under Temperature. Select **Max Tokens** and set it to `500`. This creates a hard limit on how long the model response can be.

> **Check Your Understanding**
> 
> Question: What would happen if you set Max Tokens extremely low, such as `10`, while asking the model to generate a detailed JSON report?
> 
> Hint: Think about how downstream nodes parse JSON that cuts off halfway through.

### Step 3: Craft the System Prompt[](#step-3-craft-the-system-prompt)

The system prompt defines the model's role and output contract.

1. Open `AI Triage Agent`.
    
2. Under **System Message**, paste:
    
    ```
    You are an expert SOC Analyst and Threat Hunter. Your job is to review system logs and Threat Intelligence data to categorize potential network intrusions.
    You must output YOUR ENTIRE RESPONSE as a valid JSON object. Do not include markdown formatting, backticks, or conversational text.
    Use this exact schema:
    {
      "classification": "Benign" or "Suspicious" or "Malicious",
      "confidence": a number between 1 and 100,
      "summary": "A one sentence explanation of your finding"
    }
    ```
    

> **Repetition Task:** Edit the schema in the System Prompt to include a fourth key called `"recommended_action"`. Execute the node later and observe whether the model includes that field consistently. Before moving on to Part 3, return the schema to the three required keys unless your instructor tells you otherwise.

> **Check Your Understanding**
> 
> Question: Why is the explicit instruction "Do not include markdown formatting, backticks, or conversational text" critical when working with smaller local models like `phi4-mini`?
> 
> Hint: Think about how chatbots usually start responses when asked for JSON.

### Step 4: Craft the User Prompt with Dynamic Data[](#step-4-craft-the-user-prompt-with-dynamic-data)

Now inject the evidence and CTI context from your earlier nodes into the user prompt.

1. In `AI Triage Agent`, look for the **Prompt** or **User Message** field.
    
2. Click the gear icon next to the prompt field and select **Add Expression**.
    
3. In the expression editor, construct this prompt by typing the text and inserting variables from the left-hand input pane:
    
    ```
    Analyze the following raw syslog data:
    {{ $('Extract Syslog Text').item.json.raw_syslog_data }}
    
    Here is the Threat Intelligence context for the associated IP addresses:
    {{ $('Merge CTI from all IPs together').item.json }}
    ```
    
4. Click **Execute Node**.
    
    Because this model runs locally on your VM CPU, it may take 15-30 seconds to process.
    
5. Review the output in the right-hand pane. You should see a clean JSON response generated by the AI.
    

> **Repetition Task:** Open the Expression Editor again. Delete the `{{ $('Merge CTI from all IPs together').item.json }}` variable. Using the left-hand data tree, navigate back to your CTI output and drag a single field, such as `reputation_score`, back into the prompt. Notice how you can inject either an entire JSON object or a specific key-value pair. Restore the full CTI context before moving on.

> **Check Your Understanding**
> 
> Question: When you ran the node, you likely noticed CPU utilization spike. If you were deploying this in a live environment processing thousands of logs per minute, what architectural change would you need?
> 
> Hint: Think about the hardware constraints of the PCTE lab compared to a production enterprise server room.

## Evidence to Capture[](#evidence-to-capture)

- Execution output from `AI Triage Agent` showing valid JSON with `classification`, `confidence`, and `summary`.
- Note any latency or CPU impact you observed during local inference.

## Next Step[](#next-step)

Continue to [Part 3 - Parse, Branch, and Transform the Output](part-3-parse-branch-and-transform.md)