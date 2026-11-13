---
id: B01.M35-setup
title: DGX Spark Team Buildout — Setup Guide
artifact_type: setup_guide
audience: instructor
block: B01
module_type: group_activity
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
template_profile: setup_guide_v1
sensitivity: instructor_only
---

# DGX Spark Team Buildout (L1.7b)
## Instructor Setup Guide - Classroom Infrastructure (Instructor Only)

Range support provisions each student DGX. The procedure is [`environments/dgx_spark_stack/team/README.md`](../../../../environments/dgx_spark_stack/team/README.md). After it, run `team/scripts/check-team.sh`. Students get addresses and passwords from the Moodle page **DGX Spark team access**, which range support updates before that page is shown. B04 student VMs are a separate kit, [`environments/b04_m13_student_n8n/README.md`](../../../../environments/b04_m13_student_n8n/README.md). The n8n for this Module stays on the team DGX. The sections below are the shared classroom LAN stack. They do not replace that team-box provision, and they do not run on a host whose team stack already binds ports 80 and 443.

This guide stands up the shared classroom infrastructure that makes the team lab
work offline. Every model and container image the teams need is served from this
one host, so the DGX Spark boxes never pull across the internet. That improves
reliability and speed and keeps the exercise inside the lab LAN.

**Classroom runtime path:** bring the stacks up from **`/opt/stack`** on the
instructor host (deployed checkout of the multi-stack repo).

**Course-repo source mirror:** the same layout is editable under
[`environments/dgx_spark_stack/`](../../../../environments/dgx_spark_stack/) in this course content repo
(for review/PRs). Do not assume `/opt/stack` and `environments/dgx_spark_stack/` are the same
commit without comparing.

| Stack | Runtime path | Source (course repo) | Purpose | Reached at (`BASE_DOMAIN=cso.ops`) |
| --- | --- | --- | --- | --- |
| Traefik | `/opt/stack/traefik/` | [`traefik/`](../../../../environments/dgx_spark_stack/traefik/) | LAN DNS (Technitium), private ACME CA (step-ca), trust portal, reverse proxy | DNS `:53`, ACME `https://ca.cso.ops:9000`, trust `http://trust.cso.ops` |
| Mirrors | `/opt/stack/mirrors/` | [`mirrors/`](../../../../environments/dgx_spark_stack/mirrors/) | OCI registry + olah HF mirror | `https://registry.cso.ops`, `https://models.cso.ops` |

Keep `BASE_DOMAIN=cso.ops` identical across `traefik/`, `mirrors/`, and any other
sibling stacks (override only if you intentionally change the classroom domain).
Board `LAB_BASE_DOMAIN=cso.ops` for students. `INFRA_IP` must equal Traefik
`DNS_LANDING_IP`, and mirrors `DNS_LANDING_IP` must match that same value.

Instructor Traefik uses the `acme` cert resolver with **HTTP-01**. Student DGX
Traefik (built in the lab) uses the `labca` resolver with **TLS-ALPN-01** against
`https://ca.cso.ops:9000` — do not conflate the two.

The [stack/](stack/) directory is an **instructor reference** of the final Compose
end-state of the old from-scratch build. Students do **not** receive it and do not
create `~/stack`. The provisioned team stack is already running. n8n is on that stack.

The old [`instructor_support_stack/`](instructor_support_stack/) directory is a
pointer only — do not run compose from there.

## 0. Prerequisites

On the instructor host:

- Docker and the Docker Compose plugin.
- Classroom stacks available at `/opt/stack` (or a fresh deploy of the multi-stack
  repo to that path). Course content also mirrors the layout under
  `environments/dgx_spark_stack/` for documentation and PRs.
- Internet access **during setup only** (to pull infra images, warm models, and
  build the mirror). Teams do not need internet during the lab.
- A static LAN IP for this host (`INFRA_IP` / Traefik `DNS_LANDING_IP`). Keep
  classroom addressing outside `10.0.0.0/8` (reserved for PCTE control networks).
- Enough disk for the model weights plus the container images.
- Cloud model base URL, model id, and key for each team, written on the Moodle
  page **DGX Spark team access**. Track team mapping without writing full keys
  in shared notes; revoke or rotate after class.

Decide the classroom addressing before you start. Classroom default (current
offering worked example):

```text
BASE_DOMAIN=cso.ops          # board this to students as LAB_BASE_DOMAIN
INFRA_IP / DNS_LANDING_IP=172.16.44.10
  trust.cso.ops / ca.cso.ops / registry.cso.ops / models.cso.ops / dns.cso.ops
team1.cso.ops=172.16.44.11  team2=.12  team3=.13  team4=.14  team5=.15
```

## 1. Start Traefik (DNS, CA, trust, ingress)

```bash
cd /opt/stack/traefik
cp env.example .env
```

Edit `.env` and set at least:

- `BASE_DOMAIN=cso.ops` (must match `mirrors/.env` and the student board)
- `DNS_LANDING_IP=<INFRA_IP>` (must match mirrors `DNS_LANDING_IP`)
- `STEP_CA_PASSWORD` (strong random value)
- `DNS_ADMIN_PASSWORD`
- `ACME_EMAIL`

Validate and start:

```bash
mkdir -p vols/traefik/certs vols/step-ca vols/technitium/config
docker compose config >/dev/null && echo "compose OK"
docker compose up -d
docker compose ps
```

Confirm `traefik`, `step-ca`, `trust`, and `technitium` are healthy before
continuing (students need DNS `:53` and ACME `:9000` for Stage 1).

Watch step-ca initialize on first boot:

```bash
docker compose logs -f step-ca
ls -l vols/step-ca/certs/root_ca.crt
```

Expected: root CA present; Technitium answering on `DNS_LANDING_IP:53`; trust
portal at `http://trust.cso.ops`; ACME published on `DNS_LANDING_IP:9000`.

`DOCKER_STEPCA_INIT_*` (including the `ca.cso.ops` DNS name) applies **first boot
only**. To rename the CA hostname later, wipe `vols/step-ca` and re-init
(students must reinstall the new root).

## 2. Trust the CA on the Instructor Host

```bash
curl -fsS http://trust.cso.ops/root_ca.crt -o /tmp/root_ca.crt
curl -fsS http://trust.cso.ops/root_ca.fingerprint -o /tmp/root_ca.fingerprint
openssl x509 -in /tmp/root_ca.crt -noout -fingerprint -sha256
cat /tmp/root_ca.fingerprint
# fingerprints must match

sudo cp /tmp/root_ca.crt /usr/local/share/ca-certificates/lab-root-ca.crt
sudo update-ca-certificates
sudo mkdir -p /etc/docker/certs.d/registry.cso.ops
sudo cp /tmp/root_ca.crt /etc/docker/certs.d/registry.cso.ops/ca.crt
```

If lab DNS is not yet the host resolver, temporarily add:

```bash
echo "${DNS_LANDING_IP:-172.16.44.10} trust.cso.ops registry.cso.ops models.cso.ops ca.cso.ops dns.cso.ops" | sudo tee -a /etc/hosts
```

## 3. Start Mirrors (registry + model cache)

```bash
cd /opt/stack/mirrors
cp env.example .env
```

Match `BASE_DOMAIN=cso.ops` with Traefik. Set `DNS_LANDING_IP` to the same
`INFRA_IP` as Traefik and the five `TEAMn_IP` values for your LAN. Validate and
start:

```bash
mkdir -p vols/{registry,olah}
docker compose config >/dev/null && echo "compose OK"
docker compose up -d --build
```

Traefik terminates TLS for the registry and models (HTTP backends inside Docker).
Verify empty catalog:

```bash
curl -s https://registry.cso.ops/v2/_catalog
```

Expected: `{"repositories":[]}` until preload.

## 4. Seed Team DNS and Preload

Team zones must be more specific than Traefik’s `*.cso.ops → INFRA_IP` wildcard:

```bash
chmod +x scripts/*.sh
./scripts/seed-team-dns.sh
```

Confirm:

```bash
nslookup chat.team1.cso.ops     # -> TEAM1_IP
nslookup registry.cso.ops       # -> INFRA_IP / DNS_LANDING_IP
```

Preload images and warm models (needs internet this one time):

```bash
./scripts/preload.sh
```

`preload.sh` pulls each image in `PRELOAD_IMAGES`, re-homes it under
`registry.cso.ops`, and pushes it; then it warms `MODEL_1_NAME`/`MODEL_2_NAME`
through `https://models.cso.ops` so olah caches the weights.

Confirm:

```bash
curl -s https://registry.cso.ops/v2/_catalog | tr ',' '\n'
ls -R vols/olah/repos | head
curl -sI https://models.cso.ops/
```

Expected: catalog includes the required lab images (order may vary; extras are
OK):

```text
berriai/litellm
open-webui/open-webui
traefik
vllm/vllm-openai
```

> Model note: the `MODEL_*_NAME` defaults mirror the DGX stack. If a default id
> is not yet published on Hugging Face, set the real ids in **both**
> `mirrors/.env` and each team `stack/.env` before preloading so the mirror
> caches what vLLM will request.

> olah note: if the mirror container restarts or logs a bad flag, confirm the
> olah entrypoint/flags for the installed version and adjust the `command:` in
> `mirrors/docker-compose.yaml`.

## 5. Point the Classroom at Lab DNS

Each DGX and each workstation must use this host as their DNS resolver so the
team domains and infra names resolve. Two options:

- Preferred: set the DHCP scope or each host's resolver to `INFRA_IP`.
- Per-host: set the resolver manually (student guide Stage 1 covers the DGX).

## 6. Assign Teams and Hand Off

| Team | Domain | DGX IP (example) | Services once built |
| --- | --- | --- | --- |
| 1 | `team1.cso.ops` | `172.16.44.11` | `chat/litellm/traefik.team1.cso.ops` |
| 2 | `team2.cso.ops` | `172.16.44.12` | `...team2.cso.ops` |
| 3 | `team3.cso.ops` | `172.16.44.13` | `...team3.cso.ops` |
| 4 | `team4.cso.ops` | `172.16.44.14` | `...team4.cso.ops` |
| 5 | `team5.cso.ops` | `172.16.44.15` | `...team5.cso.ops` |

Give each team:

- their assigned domain and DGX IP (they set stack `BASE_DOMAIN` to `teamN.cso.ops`),
- infra URLs: `registry.cso.ops`, `models.cso.ops`, `ca.cso.ops:9000`,
  `http://trust.cso.ops/` (root CA + fingerprint),
- the student brief and step-by-step guide (students use the provisioned DGX;
  do **not** hand out the repo `stack/` directory or have them create `~/stack`),
- the cloud model base URL, model id, and key, which they read from **DGX Spark team access**.
- Open WebUI on the team DGX starts with no users. During the module, the first signup becomes the admin and closes further signup. That admin creates one user account per student in Admin Panel, Users, Add User.

## 7. Verification Checklist (Before Students Arrive)

- [ ] `cd /opt/stack/traefik && docker compose ps` shows traefik, step-ca,
      trust, and technitium healthy.
- [ ] `cd /opt/stack/mirrors && docker compose ps` shows registry and models up.
- [ ] `nslookup chat.team1.cso.ops @INFRA_IP` returns the team1 IP.
- [ ] `curl https://registry.cso.ops/v2/_catalog` lists the required lab images
      over TLS (`traefik`, `vllm/vllm-openai`, `berriai/litellm`,
      `open-webui/open-webui`; extras are fine).
- [ ] A test pull works from a client that trusts the CA:
      `docker pull registry.cso.ops/vllm/vllm-openai:latest`.
- [ ] `curl -sI https://models.cso.ops/` responds (mirror reachable).
- [ ] `curl -fsS http://trust.cso.ops/root_ca.crt` and
      `.../root_ca.fingerprint` succeed; fingerprints match.
- [ ] `curl -skI https://ca.cso.ops:9000/acme/acme/directory` is reachable.
- [ ] Cloud model base URL, model id, and key for each team are on **DGX Spark team access**.

## 8. Troubleshooting

### `docker compose config` fails
An unresolved `${VAR}` or a typo in `.env`. Fix `.env` and re-run; nothing starts
until this passes.

### Registry pull/push gives a TLS/x509 error
The client does not trust the lab root CA. Confirm `update-ca-certificates` ran
and `/etc/docker/certs.d/registry.cso.ops/ca.crt` exists. Re-download from
`http://trust.cso.ops/root_ca.crt`.

### `step-ca` cannot validate a team's certificate (Stage 1 on the DGX)
Student Traefik uses **TLS-ALPN-01** (`labca` resolver) against the published
ACME endpoint. Instructor Traefik uses **HTTP-01** (`acme` resolver) for its own
certs — different setup. Confirm `https://ca.cso.ops:9000/acme/acme/directory` is
reachable from the DGX, `nslookup chat.teamN.cso.ops` resolves to that DGX, and
nothing blocks `80`/`443` between the instructor host and the DGX for challenge
validation.

### Model download stalls or 404s through the mirror
Confirm `MODEL_*_NAME` ids are real and match what vLLM will request, that the
mirror container is up, and that the warm step in `preload.sh` completed. Check
`docker compose logs models` under `mirrors/`.

### A team domain resolves to the wrong IP
Fix the `TEAMn_IP` value in `mirrors/.env`. If the zone already exists in
Technitium, edit records in `https://dns.cso.ops` or remove that zone and re-run
`./scripts/seed-team-dns.sh`.

## 9. Teardown / Reset

```bash
# Stop but keep CA, registry contents, and model cache:
cd /opt/stack/mirrors && docker compose down
cd /opt/stack/traefik && docker compose down

# Full reset (re-issues a NEW root CA on next start — redistribute it):
cd /opt/stack/mirrors && docker compose down && rm -rf vols
cd /opt/stack/traefik && docker compose down && rm -rf vols
```

Post-class: revoke or rotate the cloud model keys and confirm no collected
deliverable contains a key.
