# Threat Hunter AI On-Ramp
## Student Brief

**Phase:** Week 1 Day 5 AI operational on-ramp.
**Duration:** ~3 hours hands-on lab after lecture.
**Primary system:** Student Windows ops station.
**Stack:** Docker Desktop, Docker Compose, Ollama, Open WebUI, local LLM, and instructor-provided `genai.mil` API token.

## Operational Context

Your team has been asked to evaluate how AI-assisted workflows can support threat hunting without losing evidence discipline. You are not building an autonomous agent in this lab. You are standing up a controlled local AI stack, validating how it behaves, and comparing local inference with an approved external OpenAI-compatible endpoint.

The mission outcome is practical fluency: you should be able to explain what is running, where the model is hosted, how the web interface reaches it, what data is being sent to each endpoint, and how token handling changes when the endpoint is external.

## Starting Assumptions

You begin on a Windows workstation with:

- Docker Desktop installed and able to run Linux containers.
- Docker Compose available through Docker Desktop.
- Web browser access to `http://localhost` services.
- PowerShell available for command-line validation.
- Instructor access to pre-generated `genai.mil` API tokens for the class.

If Docker Desktop, local administrator rights, or external network access are unavailable, notify the instructor before beginning the walkthrough.

## Lab Objectives

You will:

1. Verify Docker Desktop and Docker Compose readiness on Windows.
2. Start a local Ollama service and pull a small local model.
3. Validate local inference through a CLI or HTTP request.
4. Deploy Open WebUI with Docker Compose.
5. Connect Open WebUI to your local Ollama endpoint.
6. Add an instructor-provided `genai.mil` OpenAI-compatible API endpoint and token.
7. Run controlled threat-hunting prompts against local and external endpoints.
8. Document endpoint behavior, data-handling assumptions, and operational fit.

## Constraints and Handling Rules

- Do not paste real operational data, classified data, credentials, API tokens, or sensitive incident artifacts into any model.
- Treat all prompts as lab data unless the instructor explicitly approves otherwise.
- Do not share your `genai.mil` token with other students.
- Do not place API tokens in screenshots, submitted logs, public notes, or chat transcripts.
- Use the external endpoint only for the lab tasks specified by the instructor.
- If a model produces an unsupported claim, identify what evidence would be required to validate it.

## Specific Tasks

1. **Prepare the Windows ops station.**
   - Confirm Docker Desktop is running.
   - Confirm Docker Compose is available.
   - Create a local working directory for the lab.

2. **Stand up local inference.**
   - Run Ollama in Docker or through the approved instructor path.
   - Pull the assigned small model.
   - Validate that the model can answer a simple local request.

3. **Deploy Open WebUI.**
   - Use Docker Compose to start Open WebUI.
   - Connect it to local Ollama.
   - Confirm that browser-based chat works with the local model.

4. **Configure the external endpoint.**
   - Receive a `genai.mil` token from the instructor.
   - Add the endpoint in Open WebUI or through the approved API test method.
   - Confirm the endpoint can list or call the assigned model.

5. **Run operational comparison prompts.**
   - Ask the local model to summarize a short synthetic hunt note.
   - Ask the external endpoint to perform the same task.
   - Ask both endpoints to generate hunt questions from synthetic evidence.
   - Compare output quality, latency, data exposure, and operational fit.

6. **Produce a handoff artifact.**
   - Summarize the stack you deployed.
   - Document which endpoint handled each task.
   - Identify what data was sent to the local model versus the external service.
   - Recommend which deployment pattern fits a single analyst, a CPT team, and an enterprise hunt platform.

## Deliverables

Submit to the instructor:

1. A brief architecture note naming each running component and its purpose.
2. A screenshot or copied text showing local Ollama inference working. Redact any tokens.
3. A screenshot or copied text showing Open WebUI connected to the local model.
4. A redacted validation note showing successful `genai.mil` API use. Do not include the token.
5. The completed endpoint comparison worksheet:
   - local endpoint result summary;
   - external endpoint result summary;
   - latency/quality observations;
   - data-handling considerations;
   - recommended deployment pattern for three mission scales.
6. A one-paragraph reflection: where would AI help your hunt workflow, and where would you refuse to rely on it without additional evidence?

## Success Criteria

- Docker Desktop and Compose are verified before service deployment.
- Ollama is running and serving a local model.
- Open WebUI is reachable from the browser and connected to local Ollama.
- The external OpenAI-compatible endpoint is configured with an instructor-provided token.
- Student submissions do not expose API tokens.
- Operational comparison discusses mission fit, not just answer quality.
- Final reflection preserves analyst ownership of evidence and judgment.

## Tie-Back

- **Week 1 planning:** This lab turns AI into a capability-planning problem: what is the mission, what data is involved, what resources are required, and what controls are needed?
- **ATT&CK/D3FEND/ENGAGE:** AI can assist with mapping, summarization, and response planning, but outputs still require evidence and analyst validation.
- **Later course labs:** Week 4 expands from basic model use into agentic workflows, retrieval, tool calls, and adversary AI counter-strike scenarios.
