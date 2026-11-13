---
id: B05.M01-red-operator-environment
title: Capstone red operator environment
artifact_type: reference
audience: instructor
block: B05
module_type: assessment
source_status: authored
review_required: false
output_formats: []
sensitivity: instructor_only
---

# Capstone red operator environment

Instructor explanation of the live red station. The procedure and the classroom secrets are in the `actec-capstone-network` submodule under `Rednet/Kali-Red/`. This page does not repeat those steps or those values.

## What the red station is for

- Amber Tide (ISB Unit 18, Operation Silent Sync) collects from BlueNet with `SyncSvc`.
- The red station is the operator end of that path. It pulls what the collector already gathered and decides what to do with it.
- The decision runs in n8n against the local `phi4-mini` model. A host script is the only thing that acts. The model does not supply a command.

## What is running

- n8n, the n8n runner, and Ollama stay. They were already the agentic stack on the red station, and the operator loop reuses them.
- Havoc's compose stack and the CTI container are gone. Havoc was not part of the capstone collection path. The CTI container only served the old student triage workflow, which has been removed.
- Sliver's client binary stays installed. The loop may ask whether a session exists. It does not task an implant.
- `kali` has passwordless sudo so operators can maintain the station. `simspace` and `range_admin` were left unchanged.

## What the loop decides

- On a timer, the station looks at files in the operator inbox.
- It may pull the next batch from the collector, sort a file into Technical or Operational, check for a Sliver session, or hold.
- A fetch happens only for credential material. That is the same priority Amber Tide already uses in `SyncSvc`: a KeePass vault, a certificate, or a key, or text about a password vault, a private key, or a client certificate.
- A URL in an ordinary document is not fetched. The host script enforces that check even when the model is loose.

## What a student can induce

- A URL inside credential material that reaches the inbox causes the station to connect out to that URL.
- The source address of that connection is the red station, so a listener the red network can reach shows the red address.
- If the downloaded body is a shell script, the station runs it as `kali` so the collection lead can continue. The model still does not choose the command.
- Because `kali` has passwordless sudo, a shell as `kali` can become root. That is an accepted outcome of this path.

## Where the procedure lives

- Setup steps, the workflow, the cycle script, and the record of what was changed: `environments/b05_capstone/actec-capstone-network/Rednet/Kali-Red/red-operator/`
- Classroom passwords, the runner token, and which keys were left in place: `environments/b05_capstone/actec-capstone-network/Rednet/Kali-Red/classroom-credentials.md`
- This change is on the running clone. The capstone gold image was not rebuilt.

## Instructor demo

Open the consoles before saving anything on the blue workstation. Do not create the credential file on kali-red.

- Blue console
  - Use the range console or an RDP session for a domain workstation that runs SyncSvc.
  - `bluenet-blue05` is the workstation named in the hunt report.
  - SyncSvc scans fixed drives about every 10 minutes and uploads a zip to the collector.
- Payload console
  - Log in to the grey redirector `redirector-01` at `198.51.100.200` with the range-card login.
  - Serve the payload script on this host for the demo.
  - This host is a convenience choice. The same script can be served from any address kali-red can reach, including a host that is not the redirector and not in grey space.
- Red console
  - From the instructor workstation, run `ssh capstone-red`.
  - Watch `/home/kali/red-operator/actions.log`.
  - Do not copy a file into the inbox.
- Optional browser
  - From the instructor workstation, run `ssh -L 5678:127.0.0.1:5678 capstone-red`.
  - Open `http://127.0.0.1:5678`.
  - Sign in with the n8n email and password in `classroom-credentials.md`.

The payload is a small text body. Its first line is `#!/bin/bash`. The remaining lines write one marker file. The URL written into the blue file is the redirector address used above. Tell the class that URL could instead be any host kali-red can reach.

On the blue workstation:

- Save a `.pem` whose text contains `private key` and that redirector URL.
- Leave it for SyncSvc.
- A plain `.txt` with the same URL can sit beside it.
- SyncSvc collects the `.txt` too. The red log shows `action=hold` for that file.

Wait for the blue upload, then for the next red cycle. The cycle pulls the new zip over SFTP as `intake`, unpacks every file into the inbox, and runs each file through the pipeline. The `.pem` is the file that produces a fetch. The red cron runs every 10 minutes.

Show the class three results:

- The redirector listener shows the source address of kali-red's connection into grey space.
  - That address is whatever address the redirector logs.
  - It may be `172.15.1.100` or a translated address on the path from red-net.
- `actions.log` contains `action=fetch` and `action=fetch executed` for that URL.
- The marker file from the script exists, which shows the lead ran as `kali`.
  - `kali` has passwordless sudo, so that shell can become root.

Before the next class, remove the inbox files, the downloaded lead under `exfil/PROCESSED/`, the marker, and the listener. Do not leave the demo script on the box.
