---
id: B05.M01-capstone-lure-data-flow
title: Capstone lure data flow
artifact_type: reference
audience: instructor
block: B05
module_type: assessment
source_status: authored
review_required: false
output_formats: []
sensitivity: instructor_only
---

# Capstone lure data flow

How a file saved on a blue workstation reaches the red operator inbox and what the agentic workflow does with it. The live demo, consoles, and classroom secrets are on the teacher-only page **Capstone red operator environment**. This page is the path between those consoles.

A lure does not go straight from a blue host to `kali-red`. Blue collection and the red decision are two separate timers. The grey redirector sits between them.

## Blue workstation

`SyncSvc` is already running on domain-joined BlueNet hosts, including `bluenet-blue05`. Its files live under `C:\ProgramData\FileSync`. About every 10 minutes it scans fixed drives, zips what it collects, and uploads that zip to the collector.

The file the red side will act on is credential material: a `.kdbx`, `.pfx`, `.pem`, `.key`, or `.ppk`, or text that mentions a password vault, a private key, or a client certificate. A URL inside that file is what later causes the outbound connection. A plain `.txt` with the same URL is collected too. The red side holds that file.

## Grey collector

The upload lands on the grey redirector `redirector-01` at `198.51.100.200`, in `/srv/intake/uploads`, as a `.zip`. The `intake` account on that host accepts SFTP only. Blue does not log into the red station, and nobody copies the lure onto `kali-red` by hand.

## Red pull

On `kali-red`, cron runs `red_operator_cycle.sh` every 10 minutes. The script is with the rest of the red-operator procedure under `environments/b05_capstone/actec-capstone-network/Rednet/Kali-Red/red-operator/`. The first thing the cycle does is pull the collector:

- SFTP as `intake@198.51.100.200`, using `kali`'s existing key
- List `/srv/intake/uploads`
- Download each `.zip` it has not already recorded
- Unpack every file in the zip into the operator inbox, named `{zip}__{original-filename}`

If that login fails, the cycle stops and does not look at the inbox. An older copy from `~/rocket_chat_data` runs only when the model chooses `sync`. The blue lure uses the collector path.

## What the workflow consumes

For each file now in the inbox, the script sends the filename and the start of the file to the local n8n webhook. n8n asks the local `phi4-mini` model and returns one of `sync`, `stage`, `fetch`, `beacon-check`, or `hold`. The model does not run a command. The script is the only thing that acts.

The script then applies its own rule:

- If the file is credential material and contains an `http` or `https` URL, the script fetches up to three of those URLs. The request uses the User-Agent `amber-collect/1.0`.
- If the downloaded body starts with `#!/bin/bash` or `#!/bin/sh`, the script runs it as `kali` for up to 30 seconds. The connection the class sees comes from `kali-red` into grey space. `kali` has passwordless sudo, so that shell can become root.
- If the model calls the file high value but it is not credential material, the script logs `action=hold` and moves the file out of the inbox. That is what happens to the plain `.txt`.
- Anything else is staged under `exfil/PROCESSED/Technical` or `Operational`, or held.

The cycle log is `/home/kali/red-operator/actions.log`. A lure that followed this path shows `collector unpacked`, then `action=fetch` and `action=fetch executed` for the credential file, and `action=hold` for the ordinary document.
