---

id: B01.M35-brief
title: DGX Spark Team Buildout — Student Brief
artifact_type: student_brief
audience: student
block: B01
module_type: group_activity
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:

- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal

---

# DGX Spark Team Buildout

## Student Brief

**Sequence:** DGX Spark Team Buildout.

**Duration:** Full lab block, approximately 4-5 hours hands-on as a team.

**Primary system:** One provisioned NVIDIA DGX Spark per team, and a workstation for each student on the same classroom subnet.

**Stack:** The box is already running Traefik, Ollama, LiteLLM, Open WebUI, n8n, Hermes, and OpenClaw.

## Lab Objectives

This is a group exercise on one DGX. **Each student** does the workstation and chat work on that student's own account. **Once for the team** is one person, and everyone else uses the result.

You will:

1. **Each student.** Install the classroom root, then open the chat and LiteLLM pages for your team domain.
2. **Each student.** List the models LiteLLM is serving and mark small local chat ids by the parameter count in the tag.
3. **Once for the team,** create the Open WebUI admin and one account per student, and point Open WebUI at LiteLLM. **Each student** compares answers from the small models on that student's account.
4. **Each student.** Ask the same prompt of several other local models and record what each one does.
5. **Once for the team,** add the cloud model from the access page in the LiteLLM admin UI. **Each student** uses it from Open WebUI.
6. **Once for the team,** run a filesystem MCP server on one workstation, register it in LiteLLM, and have a model save a poem into that workstation home directory.
7. Bonus: sign in to Hermes and OpenClaw, send one prompt to each, and try one starter agent. **Each student** then runs Open WebUI, Hermes, or OpenClaw on that student's workstation and points it at LiteLLM.



## Operational Context

Your team has been issued a DGX Spark that already serves local models through one gateway. Each student opens that gateway from a workstation, lists the local models, and tries several local models on an individual chat account. The team points the shared chat UI at the gateway, adds the cloud model from the access page, and attaches a filesystem tool that writes on one workstation.

Hostnames and the service passwords are on the Moodle page [DGX Spark team access](work-aid.md). Read that page before you start.

## Constraints and Handling Rules

- Use lab-safe prompts.
- After your team server is up, every SI query for the rest of the course goes through your team's interface.



## Specific Tasks

Work through the [student guide](student-guide.md).

1. **See the box. Each student.** Install the classroom root. Open the chat and LiteLLM pages for your team domain.
2. **Read the catalog. Each student.** From the workstation, `GET /v1/models` on LiteLLM. Mark small chat ids by parameter count.
3. **Chat in the UI.** Once for the team, create the Open WebUI admin, one account per student, and the LiteLLM connection. Each student asks the same prompt of the small models and records the difference.
4. **Try more models. Each student.** Ask that prompt of several other local models. Record what each one does.
5. **Cloud model.** Once for the team, add the cloud model from the access page in the LiteLLM admin UI. Each student selects it in Open WebUI and shows that it answers.
6. **Let the model do something. Once for the team.** Start the MCP server on one workstation. Register it in LiteLLM. Save a poem into that workstation home directory.
7. **Bonus.** Sign in to Hermes and OpenClaw, then try one starter agent. Each student runs Open WebUI, Hermes, or OpenClaw on that student's workstation and points it at LiteLLM.



## Deliverables

Submit one team packet:

1. Evidence from each student that `https://chat.<team-domain>/` and `https://litellm.<team-domain>/` loaded after that student installed the root. No certificate warning.
2. Each student's workstation `GET /v1/models` listing, with the key redacted, and the small `ollama/` ids marked.
3. The prompt the team reused, and each student's short comparison of the small-model answers.
4. Each student's notes on the other local models, and what each one did.
5. Evidence from each student that the cloud model from the access page returned an answer in Open WebUI. No key.
6. The path of the poem file on the workstation that registered the filesystem server, and the command output that shows it is there.
7. A diagram of the request path: browser, Open WebUI, LiteLLM, local model or the cloud model from the access page, and the workstation filesystem tool.
8. A note on how the team divided the work, including who created the Open WebUI accounts.
9. Bonus, if you did it: one sentence each for Hermes and OpenClaw, which starter agent you tried, and which workstation instance each student pointed at LiteLLM.



## Success Criteria

- The chat and LiteLLM pages for your team domain load with the classroom root installed.
- `/v1/models` includes the small chat models the team marked, and the packet names the parameter count read from each id.
- Open WebUI chats through LiteLLM, and those models gave different answers to the same prompt.
- You recorded what several other local models did.
- The cloud model from the access page answers through that same UI.
- A poem file exists in the home directory of the workstation that registered the filesystem server, because a model used the filesystem tool.
- No access-page secret appears in the packet.

