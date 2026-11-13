---
id: B01.M35-aid
title: DGX Spark team access
artifact_type: work_aid
audience: student
block: B01
module_type: group_activity
legacy_aliases: []
source_status: authored
review_required: false
output_formats: [moodle_fragment]
template_profile: work_aid_v1
sensitivity: course_internal
---

# DGX Spark team access

The LiteLLM key for each team is the live master key from that team's `/opt/stack/student-spark/.env`. The other values are still placeholders.

Use the HTTPS names below from the workstation.

Install the classroom root once before you open those names. Open `http://trust.cso.ops`, download `http://trust.cso.ops/root_ca.crt`, and check it against `http://trust.cso.ops/root_ca.fingerprint`. Follow the install steps on that page.

- Team 1
    - Chat: `https://chat.team1.cso.ops`
    - n8n: `https://n8n.team1.cso.ops`
    - LiteLLM: `https://litellm.team1.cso.ops`
    - Hermes: `https://hermes.team1.cso.ops`
    - OpenClaw: `https://openclaw.team1.cso.ops`
    - LiteLLM admin: `admin`
    - LiteLLM key: `sk-2628391d886e6748318ada0c33c36e1f1e9f7c8d235ebc3c`
    - Hermes user: `hermes`
    - Hermes password: `change-me-hermes-dashboard`
    - OpenClaw token: `change-me-openclaw`
    - n8n owner: `change-me-n8n-owner`
    - n8n password: `change-me-n8n-password`
    - Cloud base URL: `change-me-cloud-base-url`
    - Cloud model id: `change-me-cloud-model-id`
    - Cloud key: `change-me-cloud-key`
- Team 2
    - Chat: `https://chat.team2.cso.ops`
    - n8n: `https://n8n.team2.cso.ops`
    - LiteLLM: `https://litellm.team2.cso.ops`
    - Hermes: `https://hermes.team2.cso.ops`
    - OpenClaw: `https://openclaw.team2.cso.ops`
    - LiteLLM admin: `admin`
    - LiteLLM key: `sk-53fb3c9cd30c6472042cf2448affead0bd7b5cba33ad0ad9`
    - Hermes user: `hermes`
    - Hermes password: `change-me-hermes-dashboard`
    - OpenClaw token: `change-me-openclaw`
    - n8n owner: `change-me-n8n-owner`
    - n8n password: `change-me-n8n-password`
    - Cloud base URL: `change-me-cloud-base-url`
    - Cloud model id: `change-me-cloud-model-id`
    - Cloud key: `change-me-cloud-key`
- Team 3
    - Chat: `https://chat.team3.cso.ops`
    - n8n: `https://n8n.team3.cso.ops`
    - LiteLLM: `https://litellm.team3.cso.ops`
    - Hermes: `https://hermes.team3.cso.ops`
    - OpenClaw: `https://openclaw.team3.cso.ops`
    - LiteLLM admin: `admin`
    - LiteLLM key: `sk-ccafd2eb7e14e9cd539d66fce0d273c93a534868668d1567`
    - Hermes user: `hermes`
    - Hermes password: `change-me-hermes-dashboard`
    - OpenClaw token: `change-me-openclaw`
    - n8n owner: `change-me-n8n-owner`
    - n8n password: `change-me-n8n-password`
    - Cloud base URL: `change-me-cloud-base-url`
    - Cloud model id: `change-me-cloud-model-id`
    - Cloud key: `change-me-cloud-key`
- Team 4
    - Chat: `https://chat.team4.cso.ops`
    - n8n: `https://n8n.team4.cso.ops`
    - LiteLLM: `https://litellm.team4.cso.ops`
    - Hermes: `https://hermes.team4.cso.ops`
    - OpenClaw: `https://openclaw.team4.cso.ops`
    - LiteLLM admin: `admin`
    - LiteLLM key: `sk-4744c05d11697c09ec08dccfecee3e42f849e228b058410a`
    - Hermes user: `hermes`
    - Hermes password: `change-me-hermes-dashboard`
    - OpenClaw token: `change-me-openclaw`
    - n8n owner: `change-me-n8n-owner`
    - n8n password: `change-me-n8n-password`
    - Cloud base URL: `change-me-cloud-base-url`
    - Cloud model id: `change-me-cloud-model-id`
    - Cloud key: `change-me-cloud-key`

Open WebUI starts with no provider configured. Add the cloud model in LiteLLM admin using the cloud values for that team. Redact that key in the packet. The n8n owner is the account created on the first visit to n8n.
