---
id: B01.M35-ig
title: DGX Spark Team Buildout — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B01
module_type: group_activity
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# DGX Spark Team Buildout — Instructor Guide

## Objective and context

Students use a DGX that range support has already stood up. Each student installs the classroom root, lists models through LiteLLM, and chats on an individual Open WebUI account. One admin creates those accounts, points Open WebUI at LiteLLM, and adds the LiteLLM tool. One person adds the cloud model and registers the filesystem server. The poem is written on that one workstation. The bonus signs in to Hermes and OpenClaw on the DGX, then each student runs Open WebUI, Hermes, or OpenClaw on a workstation pointed at the team LiteLLM URL. They do not build the team stack and they do not get a shell on the DGX.

Command-complete steps are in [`answer-key.md`](./answer-key.md). Student steps are in [`student-guide.md`](./student-guide.md).

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "The box is already up. Your job is to open it from the workstation, point the chat UI at the gateway, and add one tool that writes a file on your workstation."
- **Do:** Point at the Moodle page **DGX Spark team access**. Do not write passwords or keys on the board.
- **Ask (Q):** Where do you get the HTTPS names and the LiteLLM key?
- **Expected Response (A):** The DGX Spark team access page.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "The box is already up. Trust the classroom root, use the gateway, then add a cloud model and a filesystem tool."
- **Show:** The student-guide steps. Show the access page title, not the secret values.
- **Do:** Confirm one team can open `https://chat.<team>/` and `https://litellm.<team>/` without a certificate warning before the room starts step 3.
- **Ask (Q):** Which two models should you compare?
- **Expected Response (A):** Two small chat ids, read from the parameter count in the tag (`4b` or `8b`), after `/v1/models` lists them as `ollama/` ids.

## Instructor resources and pre-class preparation

Range support provisions each student DGX from [`environments/dgx_spark_stack/team/README.md`](../../../../environments/dgx_spark_stack/team/README.md) before class. Students get addresses and passwords from the Moodle page **DGX Spark team access**. Do not put those secrets on the board.

1. The access page for each team has live values, not `change-me` placeholders. Students pick two small chat models from the parameter count in the `/v1/models` ids.
2. `https://chat.<team>/` and `https://litellm.<team>/` verify against the root from `http://trust.cso.ops`. A self-signed issuer means that box is still on the old file certificate.
3. The access page lists that team's cloud model base URL, model id, and key. Do not assume a provider that is not on the page. Keep a roster that does not store the full key. Revoke or rotate keys after class.
4. Node.js 18 or newer and `npx` are installed on the student workstations, and the filesystem packages were warmed before class. Range support does that from the team README. If `node` is missing, do not have students install it.
5. Team names such as `litellm.team1.cso.ops` resolve to that team's DGX on the classroom `/23`.
6. The instructor SSH key still logs in to the DGX. Students do not receive that key or a `student` password.

Workstations, ESXi guest VMs, and the DGX boxes are on `172.16.44.0/23` and reach each other with no NAT between them.

## Student resources and environment

- Browser and `curl` on the workstation. Students install the classroom root from `http://trust.cso.ops` once.
- The address `chat.<team-domain>` resolves to is the source for the workstation firewall rule (TCP 8000). It is not a login.
- The filesystem server runs on the workstation and writes that machine's home directory.

## Facilitation flow

### Step 1: Trust the root and see the box (15 min)

- **Say:** "Install the classroom root, then open your team's chat and LiteLLM pages."
- **Show:** `http://trust.cso.ops` and the fingerprint check in the student guide. Do not project a key.
- **Do:** A certificate warning after the install means the root is missing or the box is still serving the self-signed file. Do not tell them to click through.
- **Ask (Q):** Why is the trust page HTTP?
- **Expected Response (A):** HTTPS cannot be trusted until the root is installed.

### Step 2: List models (15 min)

- **Say:** "The workstation list is the catalog. Mark two small chat ids. The number before `b` is billions of parameters."
- **Show:** The `curl` without `-k`. Do not project the key.
- **Do:** A 401 means the access-page key was not used. A certificate error means the root is not installed. Do not suggest `-k`.
- **Ask (Q):** Which ids are local?
- **Expected Response (A):** The ones that start with `ollama/`.

### Step 3: Compare two models in Open WebUI (35 min)

- **Say:** "The first signup is the admin, and signup then closes. That admin creates one user account per student, points the UI at LiteLLM, and then each student asks the same prompt on that student's account."
- **Show:** Admin Panel, Users, Add User, then the Connections settings and the two small chat ids.
- **Do:** Confirm the roster of accounts matches the team before they compare models. If a reply stalls, they tell you. You unload a resident large model with the instructor key. They do not.
- **Ask (Q):** What counts as a comparison?
- **Expected Response (A):** The same prompt, the two small models, and a stated difference.

### Step 4: Several other local models (15 min)

- **Say:** "Ask the same prompt of several other local models. Write down what each one does."
- **Show:** Other `ollama/` chat ids in their list, including one with a larger parameter count than the two they marked.
- **Do:** If you want them to see GPU memory, project `nvidia-smi` from the instructor login while they send the prompt. They do not receive that login.
- **Ask (Q):** What do you do if a larger model fails?
- **Expected Response (A):** Stop and tell the instructor.

### Step 5: Add the cloud model (30 min)

- **Say:** "One person adds the cloud model from the access page in the LiteLLM admin UI. Each student then selects it in the chat UI. Your server is up. For the rest of the course, every SI query goes through your team's interface."
- **Show:** The access-page fields for base URL and model id. Do not show the key.
- **Do:** Check one packet for a pasted key before they leave.
- **Ask (Q):** What must not be in the screenshot?
- **Expected Response (A):** The cloud model key and the LiteLLM key.

### Step 6: Let the model write a file (45 min)

- **Say:** "So far the model only answered. Now it writes a file on your workstation. The Open WebUI admin adds the LiteLLM tool, sets Visibility to Public, then turns that tool on in the chat."
- **Show:** `ip -4 addr`, the LiteLLM MCP form (name, `http://<workstation>:8000/sse`, transport `sse`), and Open WebUI Settings, Integrations (MCP, `https://litellm.<team-domain>/mcp/`, bearer, Visibility Public).
- **Do:** One teammate registers the MCP server. The Open WebUI admin adds the LiteLLM connection. If the file never appears, they stop and tell you. The grade is the file. The answer-key curl is yours to confirm the gateway can call the tool.
- **Ask (Q):** Why is `localhost` the wrong MCP URL?
- **Expected Response (A):** The gateway would connect to the DGX, not the workstation.

### Step 7: Bonus — Hermes, OpenClaw, and a workstation instance (40 min)

- **Say:** "Sign in to Hermes and OpenClaw on the DGX, try one starter, then run Open WebUI, Hermes, or OpenClaw on your workstation and point it at your team's LiteLLM URL."
- **Show:** The access-page hostnames, the three starters, and the workstation commands in the student guide. Do not show passwords or the OpenClaw token.
- **Do:** Treat this as extra. Do not hold the packet for it. A personal Open WebUI with an empty model list is missing the workstation CA bundle mount.
- **Ask (Q):** Where does the workstation instance send the prompt?
- **Expected Response (A):** `https://litellm.<team-domain>/v1`, using `ollama/qwen3.8:27b`.

## Timing

The block is the 4-5 hours in the student brief. Steps above are the facilitation split. Hold the file-write until the gateway chat works. The bonus fits after the poem file exists.

## Common stalls

- Access page still says `change-me`.
- Fingerprint mismatch on `root_ca.crt`.
- Browser warning after the root install: wrong root, browser not restarted, or the team box is still serving the self-signed file.
- Open WebUI URL missing `/v1`.
- Open WebUI model list stays empty after the connection is saved. The container is missing the classroom root. Rebuild `certs/classroom-ca-bundle.pem` on that team box and recreate Open WebUI.
- Two large models loaded together. Unload from the instructor key.
- MCP URL set to `localhost`, or TCP 8000 blocked on the workstation.
- LiteLLM tool missing in the chat. The Integrations connection was not saved, or Visibility is still Private, so only the admin account sees it.
- `node` is not on the workstation.

## Lesson summary

The team can open what the provisioned box is serving, talk to several local models through one gateway, add the cloud model from the access page beside the local ones, and have that gateway call a tool that writes a file on the workstation.

## Questions and check on learning

- **Ask (Q):** Where does the poem file have to be?
- **Expected Response (A):** The workstation home directory, not the DGX.
- **Ask (Q):** What must never appear in a deliverable?
- **Expected Response (A):** The cloud model key, the LiteLLM key, and the other access-page secrets.

## Related artifacts

- Student brief: [`student-brief.md`](./student-brief.md)
- Student guide: [`student-guide.md`](./student-guide.md)
- Setup: [`setup-guide.md`](./setup-guide.md)
- Answer key: [`answer-key.md`](./answer-key.md)
- Access page: [`work-aid.md`](./work-aid.md)
