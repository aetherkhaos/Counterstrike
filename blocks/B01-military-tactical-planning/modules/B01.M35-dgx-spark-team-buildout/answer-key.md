---
id: B01.M35-key
title: DGX Spark Team Buildout — Instructor Answer Key
artifact_type: answer_key
audience: instructor
block: B01
module_type: group_activity
legacy_aliases: []
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: answer_key_v1
sensitivity: instructor_only
---

# DGX Spark Team Buildout — Instructor Answer Key

## Objective and starting context

Students arrive at a workstation. The team DGX already runs the stack. Each student installs the classroom root and lists models from that workstation. The first Open WebUI signup is the admin and closes further signup; that admin creates one user account per student, then points Open WebUI at LiteLLM. Each student compares small local chat models on that account. One person adds the cloud model and registers one filesystem MCP server. The poem is written on that workstation. Hermes and OpenClaw on the DGX are the start of the bonus. Each student who continues runs Open WebUI, Hermes, or OpenClaw on a workstation pointed at `https://litellm.<team-domain>/v1`. They do not build the team Compose and they do not SSH to the DGX.

Values come from the Moodle page [DGX Spark team access](work-aid.md), including the cloud model base URL, model id, and key. Students choose the two small chat models from the parameter count in the `/v1/models` ids. Do not read secrets aloud. Facilitation is in [`instructor-guide.md`](instructor-guide.md).

## 2. Initial situational-awareness baseline (on the workstation)

Run this on the workstation before the team changes Open WebUI or LiteLLM. It fixes time, identity, and which host they are on, then proves the team gateway answers with the classroom root.

```bash
date -Is
hostname
whoami
pwd
curl -fsS http://trust.cso.ops/root_ca.crt -o /tmp/root_ca.crt
curl -fsS http://trust.cso.ops/root_ca.fingerprint
openssl x509 -in /tmp/root_ca.crt -noout -fingerprint -sha256
curl -sS -o /dev/null -w 'chat %{http_code}\n' https://chat.<team-domain>/
curl -sS -o /dev/null -w 'litellm %{http_code}\n' https://litellm.<team-domain>/ui
```

`date -Is` prints the workstation clock in ISO-8601. `hostname` and `whoami` must be the workstation, not the DGX. `pwd` is the directory they will write the poem from later. The two fingerprint lines must match before anyone installs the root. `curl -sS -o /dev/null -w` prints only the HTTP status. A certificate error here means the root is not in the workstation trust store yet. Do not add `-k`.

Why it matters: later failures get blamed on the wrong host when this baseline was skipped. GPU health is a range-support check on the DGX before class. Students do not run `nvidia-smi`.

## 3. How students know each value

| Value | Where they learn it | Why that source is enough |
| --- | --- | --- |
| HTTPS names, LiteLLM key, Hermes login, OpenClaw token, cloud base URL, model id, and key | Moodle page [DGX Spark team access](work-aid.md) | Range support filled that page for the team |
| Two models to compare | The small-model cell on that page, confirmed in `/v1/models` | A tag is usable only when the JSON lists `ollama/<tag>` |
| DGX address | The address `chat.<team-domain>` resolves to | It is the source address for the workstation firewall rule on TCP 8000 |
| Classroom root | `http://trust.cso.ops` | The fingerprint on that host must match the file |
| Workstation address | `ip -4 addr` on the workstation | An address in `172.16.44.0/23` |
| MCP tool name and argument names | `GET /v1/mcp/tools` | The registered server publishes them |

## 4. Endpoint reference

| Check | Where |
| --- | --- |
| Classroom root | `http://trust.cso.ops/root_ca.crt` and `/root_ca.fingerprint` |
| Gateway catalog | `https://litellm.<team>/v1/models` |
| Chat UI | `https://chat.<team>/` |
| LiteLLM admin | `https://litellm.<team>/` user `admin`, password is the LiteLLM key |
| MCP tools | `https://litellm.<team>/v1/mcp/tools` |
| MCP call | `https://litellm.<team>/mcp-rest/tools/call` |
| Poem | `$HOME/poem.txt` on the workstation |
| Hermes / OpenClaw | `https://hermes.<team>/` and `https://openclaw.<team>/` |

Ollama is only on `127.0.0.1:11434` on the DGX. Students reach models through LiteLLM.

## 5. Instructor live walkthrough

### 5.1 Root and the two pages

`curl -fsS` fails the command if the download is an HTTP error, so a partial file is not treated as the root. `openssl x509 -noout -fingerprint -sha256` prints one line. It must equal the fingerprint URL.

After the install the trust portal describes, both team URLs must complete TLS verification. `curl` without `-k` is the check. A warning in the browser is the same fault.

### 5.2 Workstation model list

The bearer token is the LiteLLM key. Do not show it.

```bash
curl -sS https://litellm.<team-domain>/v1/models \
  -H "Authorization: Bearer <LITELLM_KEY>"
```

Expect HTTP 200 and `ollama/<tag>` ids. The two small chat tags are the ones whose count is `4b` or `8b`. A 401 means the wrong key. A local model is any id with the `ollama/` prefix. The cloud model is absent until step 5.5 adds it.

### 5.3 Open WebUI

First signup becomes the local admin and sets signup closed. In Admin Panel, Users, Add User, that admin creates one role-user account per teammate. Then in Settings, Connections, set the OpenAI-compatible URL to `https://litellm.<team-domain>/v1` and the same key. The model dropdown should fill from `/v1/models`.

Each student signs in with the account created for them. Ask one shared prompt of the two small models. Accept any concrete difference (length, wording, refusal, or format). The packet includes each student's comparison, not one comparison for the team.

### 5.4 Third local model

Pick one `ollama/` id that is not in the small pair. The same prompt should return text, more slowly, or fail. Either observation is the evidence. Students stop on a failure.

If you want a live GPU picture, SSH with the instructor key and run `nvidia-smi` while they send the prompt. Project that screen. Do not hand them the key. A stuck large model is unloaded from that login, not by the team.

### 5.5 Cloud model

LiteLLM admin login is user `admin` and the LiteLLM key. Add an OpenAI-compatible model with the base URL, model id, and key from the access page. Do not assume a provider name that is not on that page. The UI stores it because the gateway is configured to keep models in its database.

Each student refreshes Open WebUI and selects that name. A short lab-safe prompt must return text on that student's account. The packet must not contain the key.

Read the notice at the end of student-guide step 5. From here, course SI queries go through the team's Open WebUI, Hermes, or OpenClaw. The access-page cloud model is allowed only when selected in that interface.

### 5.6 Filesystem MCP

On the workstation, `node --version` must succeed. `echo "$HOME"` is the directory the tool may write. `ip -4 addr` must show an address in `172.16.44.0/23`.

`npx -y` runs the package without a prior install. `supergateway` wraps the stdio filesystem server and serves SSE on port 8000 on all interfaces, so the DGX can connect. Leave it in the foreground.

```bash
npx -y supergateway \
  --stdio "npx -y @modelcontextprotocol/server-filesystem $HOME" \
  --port 8000 --host 0.0.0.0 --ssePath /sse --messagePath /message
```

In LiteLLM admin, add MCP server name `filesystem`, URL `http://<workstation-ip>:8000/sse`, transport `sse`. Not `localhost`.

Open WebUI does not call that SSE URL itself. The Open WebUI admin adds the connection under Settings, Integrations: name `LiteLLM`, type MCP (Streamable HTTP), URL `https://litellm.<team-domain>/mcp/`, bearer auth with the LiteLLM key, Visibility Public. Open WebUI then calls that streamable HTTP endpoint, and the gateway forwards `filesystem-write_file` to the workstation.

The file lands on the workstation whose SSE URL is registered. The name `filesystem` is one server. Another registration under that name replaces it, so the team writes to one workstation at a time. Distinct names remain separate tools on the same LiteLLM key, and every chat that turns on LiteLLM can call any of them. This shared chat does not bind a student to that student's workstation.

If the DGX cannot open TCP 8000, allow that port from the DGX address on the workstation firewall and retry.

One teammate starts the server and registers the name `filesystem`. Another registration under that name replaces it. Students stop and tell you if the chat replies and the file is missing. This curl is the instructor check that the gateway can call the tool:

`GET /v1/mcp/tools` lists tools after registration. Use the write tool name from that list. The filesystem server's write arguments are `path` and `content`. If the list names them differently, use the list.

```bash
curl -sS https://litellm.<team-domain>/v1/mcp/tools \
  -H "Authorization: Bearer <LITELLM_KEY>"

curl -sS https://litellm.<team-domain>/mcp-rest/tools/call \
  -H "Authorization: Bearer <LITELLM_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"name":"<write-tool-name>","arguments":{"path":"poem.txt","content":"Lab poem.\n"}}'
```

On the workstation, `ls -l "$HOME/poem.txt"` must show the file. `cat` should show the poem text. That file is the grade evidence.

### 5.7 Bonus

Hermes on the DGX returns a login page, then a reply, using the access-page user and password. OpenClaw on the DGX returns 403 until the gateway token is supplied, then a reply. Both are already configured to call `http://litellm-gateway:4000/v1`. Students leave that URL as it is.

A starter is a first message on those DGX pages. Accept any one of these, or a similar lab-safe job: a three-line brief from the local ids they tried, one difference between two Open WebUI answers, or a checklist of the file-write they still run themselves. A bonus sentence that names the starter and says the reply came back is enough.

Each student who continues the bonus runs one workstation instance from the student guide: Open WebUI on `127.0.0.1:3000`, Hermes on `127.0.0.1:9119`, or OpenClaw on `127.0.0.1:18789`. The provider URL in that instance is `https://litellm.<team-domain>/v1`, and the model is `ollama/qwen3.8:27b`. The container mounts `/etc/ssl/certs/ca-certificates.crt` from the workstation so the classroom root is trusted. Accept a reply from that local page. An empty model list on the personal Open WebUI means the CA mount or `SSL_CERT_FILE` was left off.

## 6. Grading checkpoints

| Checkpoint | Evidence |
| --- | --- |
| SA-1 host baseline | Workstation identity, then chat and LiteLLM pages for this team's domain with the classroom root. Not `whoami` on the DGX |
| CK-1 catalog | Redacted `/v1/models`, with the two small `ollama/` ids marked |
| CK-7 several models | Same prompt, several other `ollama/` ids, and a note on what each one did |
| CK-2 gateway list | Those `ollama/` ids matched to the Open WebUI replies; key redacted |
| CK-3 comparison | Same prompt, the two small models, a stated difference |
| CK-4 cloud model | Open WebUI answer from the access-page cloud model; no key in the packet |
| CK-5 poem | `poem.txt` in the workstation home directory |
| CK-6 path | Diagram of browser, UI, gateway, model, and workstation tool |
| TW-1 / TW-2 | Who did which step, and Q&A on that work |
| Bonus | Hermes and OpenClaw replies on the DGX, plus one starter, plus one workstation instance pointed at the team LiteLLM URL; not required |

## 7. Troubleshooting

- `change-me` on the access page: range support has not published the live values.
- Fingerprint mismatch: do not install that `root_ca.crt`.
- Browser warning after the install: the root is not in that browser's trust store, or the team box is still serving the self-signed file. Do not tell them to click through.
- 401 on `/v1/models`: wrong LiteLLM key.
- Certificate error on `curl`: the root is not installed. Do not add `-k`.
- Empty Open WebUI model list: URL must end in `/v1`.
- Large model fails: unload it from the instructor key. Students do not get that login.
- Poem missing: MCP process still running, URL is the workstation `172.16.44.0/23` address, firewall allows TCP 8000 from the DGX, tool name matches `/v1/mcp/tools`.
- `node` missing on the workstation: range support skipped the workstation Node.js install in the team README. Do not have the team install it.

## 8. Acceptable answers

The two comparison models are small chat ids (`4b` or `8b`), and both must appear under `ollama/` in `/v1/models`. The cloud model name is whatever the access page lists. The poem text can be anything lab-safe. The diagram must show the workstation as the place the file is written, and the DGX as the place LiteLLM runs. Bonus text that only says "we logged in" without a reply is not the bonus. A starter that asks the agent to run commands on the DGX is not acceptable.
