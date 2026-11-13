---

id: B01.M35-guide
title: DGX Spark Team Buildout — Student Guide
artifact_type: student_guide
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
template_profile: student_guide_v1
sensitivity: course_internal

---

# DGX Spark Team Buildout

## Student Guide

The DGX is already running. This is a group exercise on that one box. **Each student** means that student, on that student's workstation and Open WebUI account. **Once for the team** means one person does it, and the rest of the team uses the result.

Read the Moodle page [DGX Spark team access](work-aid.md) for your team. It has the HTTPS names, the LiteLLM, Hermes, OpenClaw, and n8n logins, and the cloud model base URL, model id, and key. Redact those secrets in the packet.

Workstations, ESXi guest VMs, and the DGX boxes are on `172.16.44.0/23`. They reach each other directly.

## 1. Trust the classroom root and open the box

**Each student.** Install the classroom root on your workstation, then confirm the chat and LiteLLM pages for your team domain load.

On the workstation, open `http://trust.cso.ops`. That page is HTTP on purpose. Download `root_ca.crt`.

Check the fingerprint before you install. These two values must match:

```bash
curl -fsS http://trust.cso.ops/root_ca.crt -o root_ca.crt
curl -fsS http://trust.cso.ops/root_ca.fingerprint
openssl x509 -in root_ca.crt -noout -fingerprint -sha256
```

`curl -fsS` downloads a URL and fails on an HTTP error. `openssl x509 -fingerprint` prints the SHA-256 fingerprint of the file you just saved. If the two fingerprints differ, stop and tell the instructor.

Install the root the way `http://trust.cso.ops` describes for your workstation, then restart the browser.

Open `https://chat.<team-domain>/` and `https://litellm.<team-domain>/`. Replace `<team-domain>` from the access page. Both pages must load. A certificate warning after this install is a fault. Stop and tell the instructor.

## 2. List models from the workstation

**Each student.** Ask the gateway which models it is serving, and pick two small local chat models from the parameter count in each id.

`curl` is the HTTP client. The workstation trusts the classroom root, so certificate verification should succeed. The `Authorization` header is the LiteLLM key from the access page.

```bash
curl -sS https://litellm.<team-domain>/v1/models \
  -H "Authorization: Bearer <LITELLM_KEY>"
```

`-s` hides the progress meter. `-S` still prints an error if the request fails.

Replace `<team-domain>` and the key from the access page. Save the JSON with the key redacted. Local models are the ids that start with `ollama/`.

The number before `b` in the tag is the parameter count, in billions. `ollama/qwen3.5:4b` is 4 billion. `4b` and `8b` are the small chat models. A tag with two sizes, such as `35b-a3b`, gives the total and then the active size (`a3b` is 3 billion active). `e4b` means an effective 4 billion. An id that contains `embedding` is for vectors, not this chat comparison. Mark two small chat ids. Those are the two models you compare.

## 3. Point Open WebUI at LiteLLM and compare two models

**Once for the team,** create the accounts and point Open WebUI at LiteLLM. **Each student** then sends the same prompt to the two small local models and records how the answers differ.

Open `https://chat.<team-domain>/` in the workstation browser.

The first person to sign up becomes the Open WebUI admin, and that signup closes new signups. Create that admin account. It is not the LiteLLM key. In Admin Panel, open Users and choose Add User. Create one account for each teammate, with role user. Give each student the name, email, and password for that account.

Then open Settings, Connections (Admin Settings on this Open WebUI). Turn on the OpenAI-compatible API. Set the base URL to `https://litellm.<team-domain>/v1` and the key to the LiteLLM key from the access page. Save, and refresh the model list.

Each student signs in with the account the admin created. Ask the same short lab-safe prompt of the two small chat models you marked. Write down how the answers differ. If a reply is slow or fails, stop and tell the instructor.

## 4. Try several other local models

**Each student.** Ask that same prompt of several other local chat models, and record what each one does.

In Open WebUI, pick other `ollama/` chat ids from your `/v1/models` list, including at least one whose parameter count is larger than the two you marked. Ask the same prompt of each. Record what each one did: a reply, a slower reply, or a failure.

## 5. Add the cloud model

**Once for the team,** add the cloud model listed on the access page. **Each student** shows that Open WebUI can use it beside the local models.

Open `https://litellm.<team-domain>/`. Sign in as the LiteLLM admin user on the access page. The password is the LiteLLM key on that page.

Add a model in the admin UI. Use the cloud base URL, model id, and key on the access page. The provider is an OpenAI-compatible endpoint. Put the key in the key field of that form.

The gateway stores that model. Each student returns to Open WebUI, refreshes the model list, selects the new name, and asks the same prompt. Save evidence that it answered. Redact the key.

**Notice.** Your team server is up. For the rest of the course, every SI query goes through your team's interface: Open WebUI on your DGX, or Hermes or OpenClaw when you use those. Select the cloud model from the access page in that interface.

## 6. Let the model write a file

**Once for the team.** Let the model do something. The earlier steps only produced answers in a chat. This step makes it call a tool and write a file on the workstation that is running the filesystem server.

Run the tool server on the workstation, not on the DGX. LiteLLM will open a connection to the workstation address. That works because both hosts are on `172.16.44.0/23`.

On the workstation, confirm Node is available and note the home directory and the address on `172.16.44.0/23`:

```bash
node --version
echo "$HOME"
ip -4 addr
```

`npx` downloads and runs a package. This command starts a filesystem server rooted at your home directory and publishes it with Server-Sent Events so LiteLLM can reach it. `--host 0.0.0.0` listens on the workstation interfaces, not only on loopback. Leave the process running.

```bash
npx -y supergateway \
  --stdio "npx -y @modelcontextprotocol/server-filesystem $HOME" \
  --port 8000 --host 0.0.0.0 --ssePath /sse --messagePath /message
```

If the DGX cannot connect, the workstation firewall is the usual cause. Allow TCP 8000 from the address that `chat.<team-domain>` resolves to, then retry.

One teammate starts this server and registers it. The poem is written on that workstation. A second registration under the name `filesystem` replaces the team's server.

In the LiteLLM admin UI, add an MCP server:

- Name: `filesystem`
- URL: `http://<workstation-address>:8000/sse`
- Transport: `sse`

Use the workstation address you just recorded, not `localhost`. `localhost` from the gateway is the DGX, not your workstation.

The first Open WebUI account is the admin. Open Settings, then Integrations. Add a connection:

- Name: `LiteLLM`
- Type: MCP (Streamable HTTP)
- URL: `https://litellm.<team-domain>/mcp/`
- Auth: Bearer
- Key: the LiteLLM key from the access page
- Visibility: Public

Save. In a chat, turn on the LiteLLM tool. Ask a small model to draft a short poem and save it as `poem.txt` with the filesystem tool. Then on the workstation:

```bash
ls -l "$HOME/poem.txt"
```

The file should be there. If the chat replies and the file is missing, stop and tell the instructor.

## 7. Bonus: Hermes, OpenClaw, and a workstation instance

**Once for the team,** sign in to Hermes and OpenClaw on the DGX and try one starter. **Each student** then runs Open WebUI, Hermes, or OpenClaw on that student's workstation and points it at LiteLLM. This step is not required for the packet.

- Hermes: `https://hermes.<team-domain>/`. Sign in with the Hermes user and password on the access page. Send one lab-safe prompt. Confirm a reply.
- OpenClaw: `https://openclaw.<team-domain>/`. The page stays closed until you use the gateway token from the access page. Send one lab-safe prompt. Confirm a reply.

Then pick one starter and give it that job as the first message. Send one lab-safe input. You still decide what to keep.

- **Brief writer.** Paste the local model ids you tried and what each one did. Ask for a three-line situation note.
- **Difference checker.** Paste the two answers from step 3. Ask for one concrete difference.
- **Checklist maker.** Ask for a short ordered checklist of the file-write you just did. Run any command yourself on the workstation.

**Each student.** On your workstation, start one of the three below. Point it at `https://litellm.<team-domain>/v1` with the LiteLLM key from the access page, and use `ollama/qwen3.8:27b`. The container has to trust the classroom root you installed in step 1, so mount the workstation CA bundle. If `docker` is missing, stop and tell the instructor.

Open WebUI listens on `http://127.0.0.1:3000`. The first account on this copy is yours. If the model list is empty, set the same URL and key under Settings, Connections. Select `ollama/qwen3.8:27b` for the prompt.

```bash
docker run -d --name open-webui \
  -p 127.0.0.1:3000:8080 \
  -v "$HOME/open-webui:/app/backend/data" \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  -e SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
  -e REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
  -e OPENAI_API_BASE_URL="https://litellm.<team-domain>/v1" \
  -e OPENAI_API_KEY="<LITELLM_KEY>" \
  ghcr.io/open-webui/open-webui:main
```

Hermes uses the same model fields as the team stack, with the public LiteLLM URL. Build the image, hash a password you choose, and write `$HOME/hermes-config/config.yaml` before you start it. Create that directory first with `mkdir -p "$HOME/hermes-config"`. Open `http://127.0.0.1:9119` and sign in with that username and password.

```bash
docker build -t hermes-agent:local https://github.com/NousResearch/hermes-agent.git#v2026.9.24
docker run --rm --entrypoint python3 \
  -e HERMES_DASHBOARD_PASSWORD="<password-you-choose>" \
  hermes-agent:local \
  -c 'from plugins.dashboard_auth.basic import hash_password; import os; print(hash_password(os.environ["HERMES_DASHBOARD_PASSWORD"]))'
```

```yaml
model:
  default: ollama/qwen3.8:27b
  provider: custom
  base_url: https://litellm.<team-domain>/v1
  api_key: <LITELLM_KEY>
dashboard:
  public_url: http://127.0.0.1:9119
  basic_auth:
    username: <username-you-choose>
    password_hash: <hash-from-the-command>
```

```bash
docker run -d --name hermes \
  -p 127.0.0.1:9119:9119 \
  -v "$HOME/hermes-config:/opt/data" \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  -e SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
  -e REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt \
  hermes-agent:local dashboard --host 0.0.0.0 --no-open
```

OpenClaw uses the same provider block as the team stack, with the public LiteLLM URL. Create the directory with `mkdir -p "$HOME/openclaw-config"` and write `$HOME/openclaw-config/openclaw.json`, then open `http://127.0.0.1:18789` and enter the token you chose.

```json
{
  "gateway": {
    "mode": "local",
    "bind": "loopback",
    "port": 18789,
    "auth": { "mode": "token", "token": "<token-you-choose>" },
    "controlUi": { "allowedOrigins": ["http://127.0.0.1:18789"] }
  },
  "models": {
    "providers": {
      "litellm": {
        "baseUrl": "https://litellm.<team-domain>/v1",
        "apiKey": "<LITELLM_KEY>",
        "api": "openai-completions",
        "models": [
          { "id": "ollama/qwen3.8:27b", "name": "ollama/qwen3.8:27b" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "litellm/ollama/qwen3.8:27b" }
    }
  }
}
```

```bash
docker run -d --name openclaw \
  -p 127.0.0.1:18789:18789 \
  -v "$HOME/openclaw-config:/home/node/.openclaw" \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  -e NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt \
  -e HOME=/home/node \
  -e OPENCLAW_CONFIG_DIR=/home/node/.openclaw \
  -e OPENCLAW_GATEWAY_TOKEN="<token-you-choose>" \
  ghcr.io/openclaw/openclaw:latest \
  node dist/index.js gateway --bind loopback --port 18789
```

Send one lab-safe prompt. Confirm a reply from `ollama/qwen3.8:27b`. Redact the key.

## Deliverables

- Each student's evidence that the chat and LiteLLM pages loaded after the root install.
- Each student's redacted `/v1/models` output with the two small `ollama/` ids marked.
- The shared prompt and each student's comparison of two small models.
- Each student's notes on the other local models, and what each one did.
- Each student's cloud-model evidence with the key removed. The model name is the one on the access page.
- `ls` of `poem.txt` on the workstation that registered the filesystem server.
- A request-path diagram: browser, Open WebUI, LiteLLM, local model or the cloud model from the access page, workstation filesystem tool.
- How the team split the work, including who created the Open WebUI accounts.
- Bonus notes if you did step 7, including which workstation instance answered.



## Troubleshooting



### The access page still says `change-me`

Stop and tell the instructor. Range support has not published the live values.

### Browser certificate warning

The root is missing, or the browser was not restarted, or Firefox still needs the import on `http://trust.cso.ops`.

### `/v1/models` returns 401

The bearer token does not match the LiteLLM key on the access page.

### `/v1/models` fails certificate verification

The workstation does not trust the classroom root yet. Repeat step 1.

### Open WebUI has no models

The OpenAI connection must be `https://litellm.<team-domain>/v1` plus that same key. Refresh after saving.

### A model will not answer

Stop and tell the instructor.

### The poem file never appears

Confirm the MCP process is still running, the URL uses the workstation address on `172.16.44.0/23`, and the workstation firewall allows TCP 8000 from the address that `chat.<team-domain>` resolves to. Then tell the instructor.
