Range support uses this directory to provision each student DGX. It is separate from the instructor `spark/` stack. Students do not follow this file. They read the Moodle page [[B01.M35_DGX Spark Team Buildout]] after you replace its placeholders.

## Known baseline

Start from a DGX Spark that already has the NVIDIA driver, the NVIDIA container toolkit, and Docker with the Compose plugin. This directory does not install those. Confirm `docker compose version` succeeds before setup.

The host is on the classroom LAN `172.16.44.0/23`, with no NAT between team hosts. Worked example from the classroom map: instructor host `172.16.44.10`, team 1–4 at `172.16.44.11`–`.14`, DNS `172.16.44.2`. `BASE_DOMAIN` is the name DNS already has for that host (`team1.cso.ops` on `.11`).

Ports 80 and 443 are free. Do not start another publisher of those ports on this host.

`team/` is at `/opt/stack/student-spark`. The CTI build context is `../cti`, so `/opt/stack/cti` is present beside it. `.env` exists and every `change-me` value has been replaced.

The first host can reach the internet. It pulls container images and the `OLLAMA_MODELS` tags itself. It does not use the instructor mirror at `models.cso.ops`. Later hosts get `vols/ollama` by rsync and do not pull those tags again.

## Copy this directory to one DGX

Copy `team/` from this repository onto one Spark, for example `/opt/stack/student-spark`. This stack's Traefik binds host ports 80 and 443. Do not start `/opt/stack/traefik`, or any other publisher of those ports, on that host. Ollama is only on `127.0.0.1:11434`. The setup script creates the Docker network `web` if it is missing.

## Download the files if they are not already there

Start this on the first host before the class begins. The first day of class is the latest. The pull will not finish while students are waiting. On the team 9 host, `vols/ollama` was 308 GB.

If `vols/ollama` already contains the models, skip the pull. Otherwise:

```
cd /opt/stack/student-spark
cp env.example .env
# Set COMPOSE_PROJECT_NAME, BASE_DOMAIN, the webhook URL, and every change-me secret.
chmod +x scripts/setup-team.sh
```

Run the pull as a systemd unit so it keeps going if the SSH session drops. The Spark still needs its own route to the internet. Follow `setup.log`. `journalctl` only shows that the unit started.

```
sudo systemd-run --unit=team-spark-setup --collect \
  --working-directory=/opt/stack/student-spark \
  /bin/sh -c 'exec stdbuf -oL -eL ./scripts/setup-team.sh >> /opt/stack/student-spark/setup.log 2>&1'
tail -f /opt/stack/student-spark/setup.log
```

Success ends with `Models on this host:` and the unit goes inactive. A tag that is still missing after the second pass stops the script and prints `Still missing after retry:`. Fix that tag and run the script again. Models already on disk are skipped. A missing library tag is not retried forever.

The script does not write a TLS certificate. Traefik asks `[https://ca.cso.ops:9000](https://ca.cso.ops:9000)` for one certificate per published name and renews it. The script seeds Hermes and OpenClaw to call `http://litellm-gateway:4000/v1`, builds the local Hermes image, starts the stack, and pulls each tag in `OLLAMA_MODELS`. The `cti-api` service is in this same compose file. Its build context is `../cti`, which is `/opt/stack/cti` when this directory is `/opt/stack/student-spark`. Traefik publishes it at `https://cti.${BASE_DOMAIN}` with the team certificate. It calls LiteLLM at `http://litellm-gateway:4000/v1` for the summary text. Hermes is built from Nous Research `hermes-agent` tag `v2026.9.24` into `hermes-agent:local`. That image is not inside the rsync. Each later host builds it on first `docker compose up` (network required for that build only).

## Copy the finished directory to the other DGX boxes

Do not pull the models again. The copy includes `vols/ollama` and the first host's `.env`.

```
rsync -a --exclude vols/traefik/certs/acme.json /opt/stack/student-spark/ user@team2:/opt/stack/student-spark/
```

Exclude `acme.json`. Each box has its own ACME account and names. Copying team 1's store onto team 2 serves the wrong names.

## Make each host distinct

On every host after the first, edit `.env` before students use the box:

- `COMPOSE_PROJECT_NAME` (router names; keep it unique on a host that already has a stack)
- `BASE_DOMAIN` (for example `team2.cso.ops`)
- `N8N_WEBHOOK_URL` so it matches `https://n8n.${BASE_DOMAIN}/`
- `LITELLM_MASTER_KEY`, `LITELLM_SALT_KEY`, `LITELLM_DB_PASSWORD`, `N8N_ENCRYPTION_KEY`, `OPENCLAW_GATEWAY_TOKEN`, `HERMES_DASHBOARD_PASSWORD`

The seeded Hermes and OpenClaw configs were written for the first host. If `BASE_DOMAIN` or the LiteLLM key changed, delete these so setup regenerates them:

- `vols/traefik/certs/acme.json`
- `vols/hermes/config.yaml`
- `vols/openclaw/openclaw.json`

Leave `vols/traefik/ca/root_ca.crt` in place. Then run `./scripts/setup-team.sh` again. It skips any model `ollama show` already finds. Traefik issues new certificates for the new names on startup.

## Trust the classroom root

Traefik on this box gets certificates from the classroom CA at `[https://ca.cso.ops:9000](https://ca.cso.ops:9000)`. It stores them in `vols/traefik/certs/acme.json` and renews each one before expiry. Do not install a per-team leaf as a CA.

Before the first start, save the classroom root where Traefik and the pre-class check expect it:

```
curl -fsS http://trust.cso.ops/root_ca.crt -o /tmp/root_ca.crt
curl -fsS http://trust.cso.ops/root_ca.fingerprint
openssl x509 -in /tmp/root_ca.crt -noout -fingerprint -sha256
mkdir -p vols/traefik/ca
cp /tmp/root_ca.crt vols/traefik/ca/root_ca.crt
```

The two fingerprints must match. Do not copy the CA key onto a team box.

Workstations and the student n8n VM trust that same root from `[http://trust.cso.ops](http://trust.cso.ops)`. The VM procedure is `environments/b04_m13_student_n8n/README.md` in the course repo. That n8n is `http://localhost:5678`. The n8n on this DGX stays on `https://n8n.${BASE_DOMAIN}/`.

Open WebUI calls the public LiteLLM name students save in the chat UI (`https://litellm.${BASE_DOMAIN}/v1`). The image trust store does not include the classroom root, so that call fails certificate verification and the model list stays empty. `./scripts/build-webui-ca-bundle.sh` writes `certs/classroom-ca-bundle.pem` from the image trust store plus `vols/traefik/ca/root_ca.crt`, after the fingerprint matches `[http://trust.cso.ops/root_ca.fingerprint](http://trust.cso.ops/root_ca.fingerprint)`. Compose mounts that file into Open WebUI and sets `SSL_CERT_FILE`. Setup runs the script before `docker compose up`. Run it again, then `docker compose up -d open-webui`, after the classroom root changes. The bundle is generated on each team box and is not committed.

Open WebUI speaks streamable HTTP MCP, not the SSE path students register for the workstation filesystem server. The Open WebUI admin adds that connection in Settings, Integrations: type MCP, URL `https://litellm.${BASE_DOMAIN}/mcp/`, bearer auth with the team LiteLLM key, Visibility Public. The gateway then forwards the chat's tool call to the workstation server registered in LiteLLM. The classroom-root bundle above is what lets that public URL verify.

`./scripts/check-team.sh` fails when a published name does not verify against `vols/traefik/ca/root_ca.crt`, or when `notAfter` is already past. That is a stuck renewal: the instructor CA or port 80 between the CA and this box. It is not a date to put on a calendar.

## What students reach

Public names follow `BASE_DOMAIN`. Team 1 (`team1.cso.ops`):

|Service|Hostname|
|---|---|
|n8n|`[https://n8n.team1.cso.ops](https://n8n.team1.cso.ops)`|
|LiteLLM|`[https://litellm.team1.cso.ops](https://litellm.team1.cso.ops)`|
|Open WebUI|`[https://chat.team1.cso.ops](https://chat.team1.cso.ops)`|
|Hermes|`[https://hermes.team1.cso.ops](https://hermes.team1.cso.ops)`|
|OpenClaw|`[https://openclaw.team1.cso.ops](https://openclaw.team1.cso.ops)`|

Open WebUI starts with no provider configured. LiteLLM Admin UI login is username `admin` and password `LITELLM_MASTER_KEY`. Students add a cloud provider in that UI. `/v1/models` lists the `ollama/*` wildcard plus every model Ollama currently has. Hermes dashboard login is `HERMES_DASHBOARD_USER` / `HERMES_DASHBOARD_PASSWORD`. Hermes and OpenClaw use LiteLLM, default model `ollama/qwen3.8:27b`.

Only one large model should be resident at a time on the 128 GB GB10.

n8n creates its owner account on the first browser visit. Do that once per box and record the owner username and password on the Moodle page. `N8N_ENCRYPTION_KEY` is not that login.

## Tools students do not install

Students are told to stop if these are missing. Install them before class.

Docker and the Compose plugin are required to run this stack. `docker compose version` must succeed before setup. This directory does not install Docker. Students do not log in to the DGX, so do not install a monitor for them.

On each student workstation, students need `curl` and Node.js 18 or newer with `npx`. The filesystem step runs on the workstation, not on the DGX. Confirm:

```
curl --version
node --version
npx --version
```

If `curl` is missing, install `curl`. If `node` or `npx` is missing, or `node --version` is older than 18, install a current Node.js so both commands are on the default PATH. On a Debian or Ubuntu workstation whose distro package is already 18 or newer:

```
sudo apt-get update
sudo apt-get install -y nodejs npm curl
```

`npx -y` downloads two packages the first time it runs. Warm that cache before class, while the workstation can reach the npm registry:

```
npx -y supergateway --help
npx -y @modelcontextprotocol/server-filesystem --help
```

## Checks before students use the box

```
./scripts/check-team.sh
```

The script exits 0 only when the running services include `cti-api`, every `OLLAMA_MODELS` tag is in `ollama list`, each public HTTPS name verifies against `vols/traefik/ca/root_ca.crt` and is not yet expired, `embed` returns a numeric embedding, and class CTI returns score 88 for `198.51.100.44` and HTTP 500 for `203.0.113.250`. It does not print secrets.

Still confirm by hand:

- Open WebUI has no provider configured.
- On a student workstation, `node --version` is 18 or newer, `npx --version` succeeds, and the two `npx -y` warm commands above have already been run.

## Accounts

Students do not get a login on the DGX.

If a box already has a `student` account from an earlier setup, lock it so the old password cannot log in:

```
sudo passwd -l student
```

Do not turn off `PasswordAuthentication` for the whole host. The instructor account below is key-only. A console recovery path should still be able to use passwords if one exists.

Instructor backup login, username `instructor`. Students do not get this account or its key. Passwordless sudo. Login by SSH public key only. Keep the private key with the instructor. Do not commit it, and do not write it on the Moodle page.

On the workstation that will log in as `instructor`, create a key if you do not already have one, then install that public key on each box:

```
ssh-keygen -t ed25519 -f ~/.ssh/dgx-instructor
```

On each DGX:

```
sudo useradd --create-home --shell /bin/bash instructor
sudo usermod -aG sudo instructor
echo 'instructor ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/instructor
sudo chmod 440 /etc/sudoers.d/instructor
sudo passwd -l instructor
sudo install -d -m 700 -o instructor -g instructor /home/instructor/.ssh
echo 'ssh-ed25519 PASTE_THE_PUBLIC_KEY dgx-instructor' | sudo tee /home/instructor/.ssh/authorized_keys >/dev/null
sudo chmod 600 /home/instructor/.ssh/authorized_keys
sudo chown instructor:instructor /home/instructor/.ssh/authorized_keys
```

Confirm `sshd` is running and the `instructor` key login works from a classroom workstation with no password prompt. Confirm `sudo -n true` succeeds as `instructor`. Confirm `student` cannot log in with a password.

## Update the Moodle access page

Open the Moodle page **[DGX Spark team access](https://moodle.cso.ops/mod/page/view.php?id=5655 "DGX Spark team access")** (in the DGX Spark Team Buildout activity) and replace every placeholder from the live `.env` on each box and from the passwords you just set.

Put these on that page, one row per team: DGX address (firewall only, not a login), two small local model ids from `ollama list` whose sizes are a few GB, the five HTTPS names, LiteLLM user `admin` and `LITELLM_MASTER_KEY`, Hermes dashboard user and password, `OPENCLAW_GATEWAY_TOKEN`, the n8n owner login, and the cloud model base URL, model id, and key for that team. Do not put an SSH user or SSH password on that page.

Do not put `LITELLM_SALT_KEY`, `LITELLM_DB_PASSWORD`, `N8N_ENCRYPTION_KEY`, or the instructor key on that page.

Do not commit the filled-in values. A later render from source puts the placeholders back. After a rebuild, replace them again before anyone shows the page to students.