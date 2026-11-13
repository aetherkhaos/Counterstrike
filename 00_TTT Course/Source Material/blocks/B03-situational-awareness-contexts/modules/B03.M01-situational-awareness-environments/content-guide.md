---
id: B03.M01
title: Situational Awareness, Execution Environments, and User Context
artifact_type: content_guide
audience: instructor
block: B03
module_type: lecture
legacy_aliases:
- legacy/week3/content-guides/3.1 Situational Awareness, Execution Environments, and
  User Context Content Guide.md
- B04.M12
source_kind: markdown
render_mode: generate
source_status: authored
review_required: true
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
---
# Situational Awareness, Execution Environments, and User Context — Content Guide

**Source:** This Markdown content guide is the source of truth. Instructor deck: [`slides/B03.M01_situational-awareness-environments_Instructor.pptx`](slides/B03.M01_situational-awareness-environments_Instructor.pptx). The student copy is generated at pack time.
**Audience:** CPT operators entering on-target operations after tactical planning and recon/access.
**Duration:** ~90–120 minutes (Block opening lecture)
**Prerequisites:** Military tactical planning (METT-TC, CG/CV, EMLCOA, ATT&CK); recon and initial access.
**References:**

- [`slides/B03.M01_situational-awareness-environments_Instructor.pptx`](slides/B03.M01_situational-awareness-environments_Instructor.pptx)
- `../../overview.md`
- `../B03.M02-foundational-situational-awareness/student-brief.md`

Slide numbers match the instructor deck generated from this guide. On-slide **Lesson Objectives** bullets are verbatim from that PPTX.

---

## Instructor resources and pre-class

- Classroom projector and screen; whiteboard for the opening contract
- Parent or sibling briefs listed in this Module folder
- Live tabs and references already named in this file's header
- Do not project flags, tokens, or answer-key values

## Student resources

- Student brief, student guide, or homework file in this Module folder when present
- Assigned range, workstation, or lab stack named in the student-facing file
- No extra kit beyond what the student-facing file already lists

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "B03 starts on-objective."
- **Do:** Put the lesson contract on the board. Keep products from the prerequisite Module available.
- **Ask (Q):** In one sentence, what is the first thing you do after a shell?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "B03 starts on-objective."
- **Show:** The title slide and lesson objectives.
- **Do:** Confirm stations can open the required tool or file before the first teaching row.
- **Ask (Q):** In one sentence, what is the first thing you do after a shell?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 1: Situational Awareness, Execution Environments, and User Context (2 min)

**Instructor Notes:**

- **Image Prompt:** Title slide only. Dark operational backdrop; faint host silhouette with a checklist overlay (OS, user, network). Large lesson title; no bullet stack. Optional subtitle: "On-objective discovery after access."
- **Say:**
  - "B03 starts on-objective."
  - "You already have access from B02. This Block is: where am I, who am I, what can I do, and how do I learn that without lighting myself up."
  - "Objectives are next; that slide is the contract for the hour."
- **Show:** Hold the title long enough to orient, then advance.
- **Do:** Ask: "In one sentence, what is the first thing you do after a shell?" Capture two answers; return to them on the first-minute checklist.
- **Ask (Q):** In one sentence, what is the first thing you do after a shell?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 2: Lesson Objectives (2 min)

- Understand different execution environments
- Understand different user contexts
- Knowledge and understanding of MITRE ATT&CK® discovery techniques
- Understand development and utilization of survey scripts

**Instructor Notes:**

- **Image Prompt:** Four objective tiles in a row: Environments; User Context; ATT&CK Discovery (TA0007); Survey Scripts.
- **Say:**
  - "Read these as written—they are the contract for this block."
  - "Identify the execution environment before you pick a playbook."
  - "Read user context and privileges as the bound on what is feasible now."
  - "Map discovery to MITRE ATT&CK Discovery (TA0007)—same adversary vocabulary as planning, now as *your* on-host collection."
  - "Treat survey scripts as a speed/OPSEC trade, not a default."
  - "Hour map: on-objective framing, environments, user context, Discovery techniques, survey automation, OPSEC."
  - "Labs in this Block reuse this workflow on Linux, Windows, containers, hybrid shells, and degraded hosts."
  - "If delivery is 60 minutes, keep first-minute checklist, jail vs MAC, the Identify → Prove → Adapt → Document loop, and the lab-path slides. Cut TA0007 technique-card depth first."
- **Show:** Walk the four tiles left to right.
- **Do:** Tell students: "By the end you should produce a short environment + user-context summary from a handful of commands—not a dump of every tool you know."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 3: Lesson Overview (2 min)

- Introduction to On-Objective Operations
- Execution Environments
- User Context and Privileges
- MITRE ATT&CK® Discovery Techniques
- Survey Scripts and Automation
- OPSEC Considerations for Discovery

**Instructor Notes:**

- **Image Prompt:** Six numbered tiles on a horizontal flow, matching the six bullets.
- **Say:**
  - "This is the sequence, not a second objectives list."
  - "We close on OPSEC because discovery is how operators get caught."
- **Show:** Sweep the six tiles once.
- **Do:** Tell them to mark which section they are weakest in; they will revisit that during knowledge check.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 4: Introduction to On-Objective Operations (2 min)

**Instructor Notes:**

- **Image Prompt:** Section divider. Title only. Icon of an operator at a foothold looking at a host diagram (OS / user / network). No bullets.
- **Say:** "First section: what on-objective means after access, and what 'good' output looks like before you touch a technique list."
- **Show:** Title; advance.
- **Do:** None.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 5: On-Objective Phase Objectives (2 min)

- Understand where you are (system, network, environment)
- Understand what you can do (user context, privileges, tooling constraints)
- Gather intelligence on the target environment to support follow-on actions
- Identify adversary mission and infrastructure relevant to operational objectives

**Instructor Notes:**

- **Image Prompt:** Four tiles: Where; What I can do; Intel for follow-on; Adversary mission/infra.
- **Say:**
  - "On-objective is not 'run LinPEAS.' It is answering four questions."
  - "Where: OS, role, network, constraints."
  - "What you can do: identity, privileges, tools that actually exist."
  - "Intel: facts that support the next action, not trivia."
  - "Adversary mission and infrastructure: tie host facts back to CG/CV and EMLCOA—what this box is *for*."
- **Show:** Point at "where" then "what you can do" as the first-minute pair.
- **Do:** Ask: "Which of these four do people skip when they are excited about a shell?"
- **Ask (Q):** Which of these four do people skip when they are excited about a shell?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 6: MITRE ATT&CK Discovery (TA0007) (2 min)

- Core purpose: build situational awareness (where you are, who you are, what’s running, what access can reach)
- Enables OPSEC: focused discovery reduces noise and detection opportunities
- Enables performance: fewer wrong playbooks; faster, more accurate next steps
- Informs next steps: what is feasible now vs what must be enabled first (privilege, tooling, paths)

**Instructor Notes:**

- **Image Prompt:** TA0007 banner with four outcomes: SA, OPSEC, performance, next-step feasibility.
- **Say:**
  - "ATT&CK Discovery is the tactic name for this collection."
  - "You are doing Discovery against the host you occupy—same matrix, operator side."
  - "Focused discovery is both quieter and faster than script-spray."
  - "The output is the art of the possible: what you can do now, and what you must enable first."
- **Show:** Pair TA0007 with the four bullets.
- **Do:** Have students write "TA0007 = on-host SA" in their notes.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 7: Why Discovery Gets You Caught (2 min)

- High command volume (especially scripts) creates log spikes
- Unusual parent/child processes stand out (shells, interpreters)
- Network enumeration can generate alerts and correlation hits

**Instructor Notes:**

- **Image Prompt:** Three alert tiles: log spike; odd process tree; network scan correlation.
- **Say:**
  - "Discovery is the noisiest honest work you will do on-objective."
  - "Volume, weird process trees, and network probes are what defenders correlate."
  - "You will spend the last section on OPSEC; this is why that section exists."
- **Show:** Point at process-tree as the one students underestimate.
- **Do:** Ask: "What does a burst of `find /` look like in EDR?" Take one answer.
- **Ask (Q):** What does a burst of `find /` look like in EDR?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 8: Collect Once, Parse Locally (2 min)

- Prefer fewer, higher-yield commands (collect broad data once)
- Parse and filter locally to answer questions without more on-objective commands
- Example: `ps -ef` once + local filtering beats many small process queries
- Example: `ss -tunap` once + local filtering beats repeated socket checks

**Instructor Notes:**

- **Image Prompt:** Left: many tiny command arrows into the host. Right: two fat arrows (`ps`, `ss`) then a local filter funnel.
- **Say:**
  - "This is the efficiency principle for the whole Block."
  - "One high-yield collect, then think on the output."
  - "`ps` and `ss`/`netstat` are the teaching examples; same idea for `systeminfo` and `tasklist`."
- **Show:** Contrast many queries vs collect-once.
- **Do:** Tell them this is the standard they will be graded on in later labs: evidence quality over command volume.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 9: The Operator’s First-Minute Checklist (2 min)

- What OS/environment am I in (Windows, Linux, container, cloud)?
- What user context do I have (who am I, groups, privileges)?
- What is the host role (server/workstation, domain-joined, services)?
- What runs on a timer (cron, scheduled tasks, other periodic jobs)?
- What is my current network situation (IP, routes, DNS, connectivity)?

**Instructor Notes:**

- **Image Prompt:** Five-box first-minute card: Env; User; Role; Schedule; Network.
- **Say:**
  - "Answer these five before you pick a technique or a script."
  - "Environment first—container vs full host changes every later assumption."
  - "User context second—privilege bounds the rest."
  - "Role is what the box is *for*; scheduled execution is how it keeps doing that job when nobody is at a prompt."
  - "Linux: crontab and `/etc/cron*` once, then parse locally. Windows: `schtasks /query` once—same collect-once rule as `ps`/`tasklist`."
  - "Network tells you what this box can reach."
- **Show:** Walk the five questions; linger on schedule so it is not treated as optional trivia.
- **Do:** Have them copy the five questions as a standing header for lab notes.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 10: Blue-Space Advantage On-Objective (2 min)

- Arrive with validated intel (IOCs, telemetry, known adversary TTP)
- Correlate discoveries with defensive data (logs, PCAP, EDR) to reduce guesswork
- Use blue-space observations to prioritize what to look for on target

**Instructor Notes:**

- **Image Prompt:** Two panels: blue-space intel packet (IOC/TTP) feeding a prioritized on-host checklist.
- **Say:**
  - "CPT hunters are not cold-starting like a random pentest."
  - "You should already have IOCs and TTPs from hunt and planning mapping."
  - "Use that to decide what is worth a command on this host."
  - "Correlate, do not re-discover everything from zero."
- **Show:** Point from blue intel to on-host priority.
- **Do:** Ask: "Name one hunt artifact you would want in hand before the first `ps`."
- **Ask (Q):** Name one hunt artifact you would want in hand before the first `ps`.
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.

### Slide 11: What Good Looks Like (Outputs) (2 min)

- Environment summary (OS/build, domain/workgroup, container/cloud indicators)
- User context summary (account, groups, privileges, tokens)
- Key services, processes, and scheduled jobs—and why they matter
- Network summary (interfaces, routes, name resolution, connections)
- Gaps/unknowns and next discovery steps

**Instructor Notes:**

- **Image Prompt:** Handover card with five fields matching the bullets; scheduled jobs sit with services/processes.
- **Say:**
  - "Good is a handover card, not a terminal scrollback."
  - "Each line is a claim plus why it matters for follow-on."
  - "Gaps are required—unknowns drive the next command, they are not failure."
- **Show:** Walk the five output lines.
- **Do:** Tell them Slide 51 is the same template they will fill in labs.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 12: Execution Environments (2 min)

**Instructor Notes:**

- **Image Prompt:** Section divider. Title only. Four faint platform icons: Linux, Windows, cloud, container.
- **Say:** "Next: how to *identify* the environment so you do not run a Windows playbook on a container."
- **Show:** Title; advance.
- **Do:** None.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 13: What Is an Execution Environment? (2 min)

- The system/platform where your commands and code execute
- Determines available tools, filesystem layout, and security controls
- Affects options for discovery, persistence, and effects

**Instructor Notes:**

- **Image Prompt:** Nested boxes: hardware → OS → container/cloud → your shell. Label: "This is where commands run."
- **Say:**
  - "Execution environment is where your process actually runs."
  - "It sets tools, paths, and controls—not your preference."
  - "Discovery, persistence, and later effects all inherit this bound."
- **Show:** Point at controls as the thing students forget until AppArmor/Defender bites them.
- **Do:** Ask: "Is 'I have a bash prompt' enough to know the environment?" Answer: no.
- **Ask (Q):** Is 'I have a bash prompt' enough to know the environment?
- **Expected Response (A):** no

### Slide 14: Linux — What to Identify (2 min)

- Kernel and architecture: `uname -a`, `uname -m`
- Distribution and version: `/etc/os-release`
- Hostname and role clues: `hostname`, `hostnamectl`
- Processes and init (high-yield): `ps -ef` once; parse locally for PID 1 and parent/child

**Instructor Notes:**

- **Image Prompt:** Linux ID card: kernel, distro, hostname, PID 1.
- **Say:**
  - "These four tells you Linux flavor and what is pid 1."
  - "`uname` and `os-release` are cheap and high-yield."
  - "`ps -ef` once—look at PID 1 (`systemd`, `init`, container entrypoint)."
- **Show:** Highlight PID 1 as the container vs host discriminator they will use in later labs.
- **Do:** Preview Linux labs in this Block: this is the start of the SA baseline.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 15: Linux — Key Directories (2 min)

- `/etc/` system configuration (users, services, network)
- `/var/` logs, spool, application state
- `/home/` user activity and artifacts
- `/tmp/` and `/dev/shm/` common execution locations (high detection interest)

**Instructor Notes:**

- **Image Prompt:** Simple filesystem tree with the four paths highlighted; `/tmp` and `/dev/shm` marked "detection interest."
- **Say:**
  - "Operator view, not a tour of FHS."
  - "`/etc` and `/var` tell you how the box is run."
  - "`/tmp` and `/dev/shm` are where dropped tools get seen."
- **Show:** Point at detection interest on tmp/shm.
- **Do:** "If you write a survey output file, where should it *not* live?" Steer off `/tmp` with a noisy name.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 16: Linux — Process, Service, Ports (2 min)

- Processes: `ps -ef` or `ps aux` (collect once, parse locally); `pstree -a` if available
- Services: `systemctl list-units --type=service`
- Listening ports: `ss -lntup`

**Instructor Notes:**

- **Image Prompt:** Three command chips feeding one "host role" conclusion box.
- **Say:**
  - "Process, service, listen—enough to guess host role."
  - "Collect `ps` and `ss` once; do not poll them."
  - "`systemctl` may be missing in chroot/BusyBox labs—that absence is evidence."
- **Show:** Pair `ss` with "what is this host for."
- **Do:** Remind: later constrained labs may lack `ss`/`systemctl`; adapt, do not freeze. Point forward to the Identify → Prove → Adapt → Document loop (Slide 67).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 17: Linux — Security Controls That Block You (2 min)

- Filesystem jail: a root prompt can still be confined
- MAC (AppArmor/SELinux): policy can deny exec even as root
- Prove the boundary from native evidence before you adapt
- Denied exec → read policy/logs, not a new exploit
- Host firewall and EDR still change outbound and tooling choices

**Instructor Notes:**

- **Image Prompt:** Two constraint tiles in front of a root shield: filesystem jail vs MAC policy. Firewall and EDR as smaller side gates.
- **Say:**
  - "Root is not a free pass. These are two different constraint models."
  - "Jail: the process sees a fake `/`. `whoami` can say root and you still are not on the host."
  - "MAC: AppArmor/SELinux policy can deny exec from an upload path even as root. Later labs model that on purpose."
  - "Do not memorize a chroot or `apparmor_status` walkthrough here. Prove the boundary from what the host already shows, then change tradecraft."
  - "Firewall and EDR still bound outbound and tooling choices."
- **Show:** Point at jail vs MAC as different proofs, not the same problem.
- **Do:** "If `whoami` is root, are you on the host?" No—prove the boundary. "If `./tool` dies with denied, what do you read first?" Policy/logs, not a new exploit.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 18: Windows — What to Identify (2 min)

- OS version/build and host info: `systeminfo`
- Domain/workgroup: `systeminfo` Domain field; `whoami /all`
- Local security posture: AV/EDR presence, policies, PowerShell language mode (as applicable)

**Instructor Notes:**

- **Image Prompt:** Windows ID card: build, domain/workgroup, security posture.
- **Say:**
  - "`systeminfo` is the collect-once analog to `uname` + `os-release`."
  - "Domain vs workgroup is an early branch—do not skip it."
  - "Language mode and EDR tell you what scripts will survive."
- **Show:** Highlight Domain field.
- **Do:** Preview Windows labs in this Block: same first commands.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 19: Windows — AD vs Workgroup (2 min)

- Domain-joined hosts introduce AD discovery requirements and handoff needs
- Workgroup hosts constrain trust relationships
- Discovery plan changes based on this early answer

**Instructor Notes:**

- **Image Prompt:** Fork: Domain path (AD discovery + handoff) vs Workgroup path (local trust only).
- **Say:**
  - "This one answer changes the rest of the survey."
  - "Domain: document DC/trust facts for partner handoff even if you will not execute AD movement today."
  - "Workgroup: do not assume tickets and GPOs."
- **Show:** The fork.
- **Do:** "If you only run `whoami` with no `/all`, what did you miss?" Domain/group/privilege detail.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 20: Windows — Processes, Services, Network (2 min)

- Processes: `tasklist` or `Get-Process`
- Services: `sc query` or `Get-Service`
- Network config: `ipconfig /all`, `route print`
- Connections: `netstat -ano`

**Instructor Notes:**

- **Image Prompt:** Four command chips → host-role conclusion (same layout as Linux Slide 16).
- **Say:**
  - "Same three questions as Linux: processes, services, listeners/connections."
  - "Collect `netstat -ano` once; parse PID locally."
- **Show:** Parallel to the Linux trio.
- **Do:** Tell them not to mix `cmd` and PowerShell randomly without noting which they used.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 21: Windows — Security Controls That Block You (2 min)

- Defender/EDR can flag common tooling and scripts
- Group Policy can restrict execution and access
- Token/privilege boundaries matter even as "Administrator"

**Instructor Notes:**

- **Image Prompt:** Three gates: Defender/EDR, GPO, token privileges—in front of an Administrator badge.
- **Say:**
  - "Administrator is not SYSTEM, and neither ignores Defender."
  - "GPO and AppLocker-class controls show up in later Windows labs."
  - "Tokens are next section—do not assume the label on the account is the capability."
- **Show:** Point at token boundary.
- **Do:** Flag Windows labs in this Block: Defender stays on; plan for it.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 22: Cloud Environments (Brief) (2 min)

- Common platforms: AWS, Azure, GCP
- Indicators: cloud-init artifacts, instance metadata services, cloud agents
- Operational note: metadata queries can be logged/monitored

**Instructor Notes:**

- **Image Prompt:** Cloud instance with a metadata IP callout and a "logged" stamp.
- **Say:**
  - "Brief only—recognize cloud, do not deep-dive IMDS exploits here."
  - "cloud-init, metadata endpoints, and vendor agents are the tells."
  - "Metadata queries are not free; they can be logged."
- **Show:** The logged stamp on metadata.
- **Do:** "If you see `169.254.169.254` in notes, what environment class is that?" Cloud metadata.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 23: Container Environments (Brief) (2 min)

- Indicators: limited filesystem, cgroup markers, container runtime artifacts
- Priority: identify you are in a container before assuming host-level access
- Re-run the first-minute checklist on every new shell, upload, or pivot
- Upload location is not proof of execution location
- A Linux prompt on a Windows host is a hypothesis, not a conclusion

**Instructor Notes:**

- **Image Prompt:** Container box inside a host box; a second arrow from "upload" to a different runtime labeled "prove where it ran." Faint WSL/hybrid silhouette: Linux prompt ≠ Windows host.
- **Say:**
  - "Later in this Block you will run a container chain (web shell → exec → BusyBox)."
  - "First job: prove container vs host (`.dockerenv`, cgroup, PID 1, limited `/`)."
  - "Escape is not today's objective; mis-identifying the environment is the failure."
  - "Every new command surface is untrusted until you prove identity, user, filesystem, and network again—upload path is not exec path."
  - "Hybrid later in this Block: a bash prompt can still be a Windows box. Treat the prompt as a claim; prove the host."
- **Show:** Point at "identify before assume host-level access," then at the upload-vs-exec split.
- **Do:** Preview the container labs: webshell does not mean you are on the Docker host. Ask: "If the prompt looks like Linux, what have you actually proven?" Only the shell, not the host.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 24: Demonstration — Identifying Execution Environment (2 min)

- Linux: `uname -a` → `/etc/os-release` → `id` → `ps -ef` → `ss -lntup`
- Windows: `systeminfo` → `whoami /all` → `ipconfig /all` → `netstat -ano`

**Instructor Notes:**

- **Image Prompt:** Two short pipelines (Linux / Windows) matching the bullets.
- **Say:**
  - "Live or narrated: five Linux commands, four Windows commands."
  - "After each line, say what question it answered from the first-minute checklist."
  - "Schedule is on the checklist but not in this opener—add cron or `schtasks /query` once after you know the host is stable."
  - "Do not add extra tools in the demo."
- **Show:** Run or talk through the exact sequence; paste expected shape of output (hostname, OS, user, listeners).
- **Do:** Students copy the sequence into lab notes as the default opener.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 25: User Context and Privileges (2 min)

**Instructor Notes:**

- **Image Prompt:** Section divider. Title only. Badge/id card icon plus a privilege ladder.
- **Say:** "Who you are bounds every later Discovery technique."
- **Show:** Title; advance.
- **Do:** None.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 26: What Is User Context? (2 min)

- Who you are and what you can do on the target
- Drives access decisions: discovery depth, privilege escalation need, lateral options
- Determines risk: some actions need elevation and create different audit artifacts

**Instructor Notes:**

- **Image Prompt:** Identity card feeding three decisions: how deep to look; whether to escalate; how loud.
- **Say:**
  - "User context is identity plus effective capability."
  - "It decides discovery depth, whether you need priv-esc, and what movement is even on the table."
  - "Elevation changes the audit story—know that before you sudo."
- **Show:** Point at risk/audit.
- **Do:** "Is `whoami` = `root` the end of this section?" No—groups, sudo, tokens still matter.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 27: Linux — `whoami` and `id` (2 min)

- `whoami` identifies current user
- `id` shows UID/GID and group memberships
- Groups can reveal capability (sudo, docker, service accounts)

**Instructor Notes:**

- **Image Prompt:** Terminal snippet of `id` with `sudo`/`docker` groups highlighted.
- **Say:**
  - "`whoami` is the name; `id` is the capability hint."
  - "docker/sudo/adm groups change the story immediately."
- **Show:** Highlight group names, not just uid 0 vs not.
- **Do:** Have them add `id` to the first-minute Linux list if it was missing.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 28: Linux — `sudo -l` (2 min)

- `sudo -l` enumerates allowed privileged commands (if permitted)
- Root vs non-root changes filesystem, service control, credential access
- Avoid repeated failed privilege attempts (noise)

**Instructor Notes:**

- **Image Prompt:** `sudo -l` output box; a red "failed sudo" log spike beside it.
- **Say:**
  - "`sudo -l` once if you can; do not hammer a bad password."
  - "A narrow sudoers line is often enough for the next action without full root."
- **Show:** Failed-attempt noise.
- **Do:** "If `sudo -l` asks for a password you do not have, what do you do?" Stop; document; do not spray.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 29: Linux — `/etc/passwd` and `/etc/shadow` (2 min)

- `/etc/passwd` lists local accounts and shells
- `/etc/shadow` holds password hashes (often needs root)
- Focus: service accounts vs interactive users

**Instructor Notes:**

- **Image Prompt:** Two files: passwd (readable) vs shadow (locked). Interactive shells highlighted in passwd.
- **Say:**
  - "passwd is account inventory; shadow is hash access—different privilege."
  - "Look for nologin vs bash to separate service vs interactive."
- **Show:** Interactive shell column.
- **Do:** Tie to later user-flag style evidence: accounts and comments, not just uid 0.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 30: Windows — `whoami` (2 min)

- `whoami` identifies the current principal
- `whoami /groups` and `whoami /priv` show effective groups/privileges
- Distinguish local vs domain identity early

**Instructor Notes:**

- **Image Prompt:** `whoami /all` with GROUP and PRIVILEGE sections highlighted; DOMAIN\user vs COMPUTER\user.
- **Say:**
  - "`whoami` without switches is incomplete."
  - "`/all` or `/groups` + `/priv` is the collect-once."
  - "Local vs DOMAIN\\user is the AD fork from earlier."
- **Show:** Domain prefix.
- **Do:** Require `/all` in the Windows demo notes.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 31: Windows — Local vs Domain (2 min)

- Local admin on one host is not domain admin
- Domain context enables AD-based discovery and movement
- Token/privilege differences decide what will succeed

**Instructor Notes:**

- **Image Prompt:** Two badges: "Local Admin (this host)" vs "Domain Admin (forest)."
- **Say:**
  - "Do not inflate local admin into DA in the handover."
  - "Domain context is an *option space* for later movement, not an order to execute it in this lecture."
- **Show:** The two badges.
- **Do:** "What would you write in a handoff if you are local admin on a domain-joined box?" Local admin, domain user X, not DA.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 32: Token Privileges (SeDebugPrivilege) (2 min)

- Token privileges influence which processes and secrets you can access
- High-impact privileges change what is feasible
- Do not "try everything"; choose actions from privileges observed

**Instructor Notes:**

- **Image Prompt:** Token ribbon with SeDebugPrivilege lit; others dim.
- **Say:**
  - "Privileges are the Windows equivalent of 'sudoers line' granularity."
  - "SeDebugPrivilege is the teaching example—process/secret access implications."
  - "Select the next command from what `/priv` showed."
- **Show:** Enabled vs disabled privilege rows.
- **Do:** If time: show `whoami /priv` and pick one enabled privilege to interpret.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 33: Why User Context Matters (2 min)

- Determines what you can access now
- Informs privilege escalation requirements
- Affects lateral movement options and OPSEC risk
- Shapes what discovery is worth doing immediately

**Instructor Notes:**

- **Image Prompt:** Four decision arrows out of a user-context box.
- **Say:**
  - "This is the decision slide: now vs later, local vs lateral, loud vs quiet."
  - "Worth-doing discovery is the subset that changes a decision."
- **Show:** Four arrows.
- **Do:** Tie back to Slide 5 on-objective questions.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 34: Demonstration — Checking User Context (2 min)

- Linux: `whoami`, `id`, `sudo -l` (if applicable)
- Windows: `whoami /all`, `net user %username%` (as applicable)
- Produce a short capability statement (what can we do now?)

**Instructor Notes:**

- **Image Prompt:** Demo checklist ending in a one-sentence "capability statement" box.
- **Say:**
  - "Run only this set. End with one sentence: 'We are X, we can Y, we cannot Z.'"
  - "That sentence is what a partner needs—not the raw `id` dump."
- **Show:** Live or narrated; write the capability sentence on the board.
- **Do:** Cold-call one student to draft the sentence from the demo output.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 35: MITRE ATT&CK Discovery Techniques (2 min)

**Instructor Notes:**

- **Image Prompt:** Section divider. TA0007 matrix fragment; title only.
- **Say:** "Technique tour: purpose, a few commands, OPSEC. You will not run all of them."
- **Show:** Title; advance.
- **Do:** None.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 36: How to Use This Section (2 min)

- For each technique: purpose, a small command set (Linux/Windows), what good output looks like, OPSEC
- Select techniques from objectives and current context—not from a full-matrix checklist

**Instructor Notes:**

- **Image Prompt:** Technique card template: Purpose / Commands / Good output / OPSEC.
- **Say:**
  - "Every following slide is that card."
  - "Objective-driven selection—Slide 50 makes that explicit."
- **Show:** The template.
- **Do:** "If your objective is 'what is listening,' which tactic/technique family?" Connections/services, not file search.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 37: T1082 System Information Discovery (2 min)

- Purpose: OS version, hostname, hardware clues
- Linux: `uname -a`, `hostnamectl`, `lscpu` (as available)
- Windows: `systeminfo`; `wmic os get Caption,Version,BuildNumber` (if available)
- OPSEC: fewer commands; collect high-yield output once; extract fields locally

**Instructor Notes:**

- **Image Prompt:** T1082 card with Linux/Windows command chips.
- **Say:**
  - "T1082 is the ATT&CK name for what you already did with `uname`/`systeminfo`."
  - "Do not re-run it five times later in the survey."
- **Show:** OPSEC line: collect once.
- **Do:** Map back to first-minute "what OS am I on."
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 38: T1033 System Owner/User Discovery (2 min)

- Purpose: current/logged-on users and usage patterns
- Linux: `whoami`, `w`, `last`
- Windows: `whoami`, `quser`, `qwinsta`
- OPSEC: user enumeration can be monitored; avoid excessive querying

**Instructor Notes:**

- **Image Prompt:** T1033 card; `w`/`quser` session table.
- **Say:**
  - "Who is on this box besides you—operators get surprised by interactive sessions."
  - "`w`/`quser` once; `last` if you need history."
- **Show:** OPSEC: do not loop `quser`.
- **Do:** Ask why a second logged-on admin matters for OPSEC.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 39: T1057 Process Discovery (2 min)

- Purpose: running processes and unexpected tooling
- Linux: `ps -ef` or `ps aux` (once, parse locally); `top` (interactive)
- Windows: `tasklist`, `Get-Process`
- OPSEC: avoid heavy memory inspection unless required

**Instructor Notes:**

- **Image Prompt:** T1057 card; process table with one unexpected child highlighted.
- **Say:**
  - "You already collected `ps`/`tasklist`—this is the ATT&CK label and the parse step."
  - "`top` is interactive and easy to leave running; prefer a snapshot."
- **Show:** Memory inspection as the loud option.
- **Do:** "What would you grep for in `ps` after a webshell foothold?" php/python/nc/unusual cwd.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 40: T1007 System Service Discovery (2 min)

- Purpose: services/daemons and configuration
- Linux: `systemctl list-units --type=service`, `service --status-all`
- Windows: `sc query`, `Get-Service`
- OPSEC: generally low-noise locally; avoid repeated remote queries

**Instructor Notes:**

- **Image Prompt:** T1007 card; service list with a non-default unit highlighted.
- **Say:**
  - "Services explain host role and restart behavior."
  - "Local query is quieter than remote service enum."
- **Show:** Remote vs local.
- **Do:** If `systemctl` is missing, that is environment evidence (container/BusyBox/chroot).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 41: T1083 File and Directory Discovery (2 min)

- Purpose: sensitive files, configs, operational artifacts
- Linux: one high-yield listing per directory of interest (`ls -la`); `find` only if tightly scoped
- Windows: one high-yield listing (`dir /a` or scoped `Get-ChildItem`); parse locally
- OPSEC: broad recursive search is noisy; start narrow; justify expansion

**Instructor Notes:**

- **Image Prompt:** T1083 card; narrow folder vs `find /` red-X.
- **Say:**
  - "This is where operators get loud."
  - "List the directory you already have a reason to care about."
  - "`find /` is a last resort with a written reason."
- **Show:** Narrow vs recursive.
- **Do:** "Name one directory you would list first on a web foothold." `/var/www`, app config, not `/`.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 42: T1087 Account Discovery (2 min)

- Purpose: local/domain accounts on the system
- Linux: `cat /etc/passwd`, `getent passwd`
- Windows: `net user`, `net localgroup` (domain as applicable)
- OPSEC: domain-wide queries are more visible; prefer local context first

**Instructor Notes:**

- **Image Prompt:** T1087 card; local SAM/passwd vs domain query with "visible" tag.
- **Say:**
  - "Local account list first; domain enumeration is a conscious louder step."
  - "Same files as the user-context section—do not duplicate blindly."
- **Show:** Local-first.
- **Do:** If already read passwd, skip re-cat; parse the saved output.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 43: T1069 Permission Groups Discovery (2 min)

- Purpose: group memberships and implied privilege
- Linux: `id`, `groups`
- Windows: `whoami /groups`, `net localgroup`
- OPSEC: high value; one query is often enough

**Instructor Notes:**

- **Image Prompt:** T1069 card; group list with Administrators/sudo highlighted.
- **Say:**
  - "Groups are the privilege implication of T1087."
  - "You likely already have this from `id` / `whoami /groups`."
- **Show:** One-query OPSEC.
- **Do:** Do not re-run `net localgroup Administrators` in a loop.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 44: T1018 Remote System Discovery (2 min)

- Purpose: other reachable hosts and potential pivots
- Linux: `arp -a`, limited ping, carefully scoped nmap only if required
- Windows: `arp -a`, ping, `nltest /dclist:<domain>` (domain context)
- OPSEC: scanning is high risk; prefer passive/low-rate discovery

**Instructor Notes:**

- **Image Prompt:** T1018 card; ARP table (quiet) vs nmap (loud).
- **Say:**
  - "ARP and existing connections (T1049) before ping sweeps."
  - "nmap on-objective is a decision, not a reflex—B02 scan tradecraft still applies."
  - "Handoff may need neighbor/DC names; document, do not flatten the network in lecture."
- **Show:** Quiet vs loud.
- **Do:** "What already-collected command might list remote IPs without a new scan?" `ss`/`netstat`.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 45: T1016 System Network Configuration Discovery (2 min)

- Purpose: interfaces, routing, DNS
- Linux: `ip addr`, `ip route`, `cat /etc/resolv.conf`
- Windows: `ipconfig /all`, `route print`, `nslookup`
- OPSEC: mostly local; avoid repeated DNS queries if monitored

**Instructor Notes:**

- **Image Prompt:** T1016 card; interface/route/DNS triad.
- **Say:**
  - "This answers first-minute 'network situation.'"
  - "Repeat `nslookup` is the quiet-looking thing that still logs."
- **Show:** DNS query caution.
- **Do:** Collect `ipconfig /all` once in the Windows demo; parse DNS from it.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 46: T1049 System Network Connections Discovery (2 min)

- Purpose: active connections; possible C2 or management sessions
- Linux: `ss -tunap` (once; parse by PID/port/remote IP)
- Windows: `netstat -ano`, `Get-NetTCPConnection`
- OPSEC: local command; collect once and interpret locally

**Instructor Notes:**

- **Image Prompt:** T1049 card; connection table with one unexpected remote highlighted.
- **Say:**
  - "This is the high-yield companion to T1016."
  - "Parse remotes and PIDs locally—do not re-run `netstat` for each question."
- **Show:** Unexpected remote as the teaching find.
- **Do:** Tie to blue-space IOCs: "Would this remote match a hunt IOC?"
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 47: T1135 Network Share Discovery (2 min)

- Purpose: shares and mounts for access and data movement
- Linux: `mount`, `showmount` / `smbclient -L` as applicable
- Windows: `net share`, `net view`
- OPSEC: remote share enumeration can be logged; scope to need

**Instructor Notes:**

- **Image Prompt:** T1135 card; local shares vs `net view` across the wire.
- **Say:**
  - "Local `net share`/`mount` first."
  - "`net view` of other hosts is a visibility event."
- **Show:** Remote enum warning.
- **Do:** Scope: only the share that the mission needs.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 48: Demonstration — Selected Discovery Techniques (2 min)

- Pick 3–5 techniques and run only 1–2 commands each
- After each: state what you learned, what you assume, and what you will verify next
- End with a short written summary (environment + user context + key findings)

**Instructor Notes:**

- **Image Prompt:** Demo loop: Technique → 1–2 commands → learned/assume/verify.
- **Say:**
  - "Live: pick five—T1082, T1033, T1057, T1016, T1049 is a solid set."
  - "After each, say learned / assume / verify. Do not skip assume—that is where people lie to themselves."
- **Show:** Write the three-part after-action on the board once.
- **Do:** Students replicate the loop silently on paper during the demo.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 49: Common Failure Modes (2 min)

- Run large scripts immediately without context
- Broad file searches or network scans without objectives
- Collect output without interpreting it
- Forget to document findings for handover

**Instructor Notes:**

- **Image Prompt:** Four failure tiles with X marks.
- **Say:**
  - "These four fail the Block even if you 'find the flag.'"
  - "Script-first, scan-first, dump-without-read, no handover."
- **Show:** Walk the four.
- **Do:** Tell them later lab grading cares about interpretation, not command count.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 50: Technique Selection (Objective-Driven) (2 min)

- Privilege escalation: prioritize user/groups, services, configs
- Lateral movement (handoff enablement): network config, connections, remote systems—document, do not execute movement in this block
- Effects on adversary infrastructure: processes/services and mission artifacts

**Instructor Notes:**

- **Image Prompt:** Three objective columns mapping to technique clusters.
- **Say:**
  - "Select Discovery from the mission, not from the full TA0007 list."
  - "Lateral here is *documentation for CMT/partner handoff*, not a license to pivot in lecture."
  - "Later effects work still needs process/service truth from this survey."
- **Show:** Three columns.
- **Do:** Give one vignette: "You must brief a partner RAT deploy tomorrow—what three techniques?" Steer to T1016/T1049/T1018 plus user context.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 51: Quick Documentation Template (2 min)

- Host: [hostname/IP]
- Environment: [OS/build, domain/workgroup, container/cloud indicators]
- User context: [user, groups, key privileges]
- Key findings: [services/processes/scheduled jobs/network indicators]
- OPSEC notes: [what might have logged/alerted]
- Next steps: [what to verify/do next]

**Instructor Notes:**

- **Image Prompt:** Blank template card matching the six fields.
- **Say:**
  - "This is the handover artifact."
  - "Fill it at the end of every lab foothold in this Block."
- **Show:** Leave the template up while they copy it.
- **Do:** Require this header in later lab notes.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 52: Survey Scripts and Automation (2 min)

**Instructor Notes:**

- **Image Prompt:** Section divider. Script icon with a volume slider (quiet ↔ loud).
- **Say:** "Automation is a choice with an OPSEC bill."
- **Show:** Title; advance.
- **Do:** None.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 53: Why Survey Scripts Exist (2 min)

- Speed, completeness, repeatability
- Reduce operator error under stress
- Standardized output for teams and handover

**Instructor Notes:**

- **Image Prompt:** Three payoff tiles: speed; fewer misses; standard handover.
- **Say:**
  - "Scripts exist because humans skip steps under stress."
  - "The payoff is a consistent packet for the next operator."
  - "That payoff is not free—next slide is the cost."
- **Show:** Three payoffs.
- **Do:** Ask who has run LinPEAS in a lab vs on a monitored range.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 54: Survey Script OPSEC (2 min)

- Many commands in a short window trigger detections
- Script artifacts on disk can be found
- Output files hold sensitive details; treat and move them carefully

**Instructor Notes:**

- **Image Prompt:** Script burst → SIEM spike; file on disk; output file stamped "sensitive."
- **Say:**
  - "A script is a log spike by design."
  - "The `.sh` you dropped and the `out.txt` you left are evidence against you too."
- **Show:** Three cost tiles.
- **Do:** "Where does survey output go in a professional op?" Named, controlled, cleaned or handed off.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 55: Types of Survey Scripts (2 min)

- Linux: LinPEAS, LinEnum, custom
- Windows: WinPEAS, PowerUp, custom
- Custom mission scripts: answer specific questions fast
- Executable scripts vs operator-driven command lists (often quieter)
- Prefer observable, interruptible runs (watch output; stop on risk; parse locally)

**Instructor Notes:**

- **Image Prompt:** Two columns: named public scripts vs a paced command list in an editor.
- **Say:**
  - "Know the public names so you recognize them; do not treat them as mandatory."
  - "A curated command list in an editor is often the better OPSEC control—you pace it."
  - "If you do run a script, watch it; be ready to stop."
- **Show:** Interruptible vs fire-and-forget.
- **Do:** For this course, default to command lists on constrained labs; full PEAS-class tools only when the environment and objective justify the noise.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 56: Example Survey Script Structure (2 min)

- System info
- User/account enumeration
- Network discovery
- Process/service discovery
- Filesystem reconnaissance
- Output formatting and collection

**Instructor Notes:**

- **Image Prompt:** Ordered pipeline of the six sections into a formatted report.
- **Say:**
  - "If you write a custom script, this is the outline—same as the first-minute checklist plus files and a report."
  - "Formatting is part of the job; unreadable output is failed handover."
- **Show:** Order: system → user → network → process → files → package.
- **Do:** Map each line to an ATT&CK ID they just saw.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 57: Demonstration — Run a Survey Script (2 min)

- Run a basic script in a lab environment
- Review output; identify 3 high-value findings
- Discuss what noise/logs the script likely created

**Instructor Notes:**

- **Image Prompt:** Split: script output with three stars; SIEM-style event list beside it.
- **Say:**
  - "Demo a *small* custom script or a trimmed command list—not full LinPEAS unless you have time and a throwaway host."
  - "Force three findings and an explicit noise discussion."
- **Show:** Three findings + likely log types (process create, file write).
- **Do:** Students shout out one noisy artifact they would not want left behind.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 58: Developing Custom Scripts (Brief) (2 min)

- Bash: functions, command existence checks, output formatting
- PowerShell: cmdlets, error handling, structured output
- Tailor to objectives; keep scope minimal

**Instructor Notes:**

- **Image Prompt:** Tiny code sketch: `command -v ss` / `Get-Command` then one collect.
- **Say:**
  - "Custom beats PEAS when the question is narrow."
  - "Check that the binary exists—B03 constrained hosts will lack tools."
  - "Minimal scope is an OPSEC control."
- **Show:** Existence check as the professional habit.
- **Do:** "What does your script do if `ss` is missing?" Fall back or record the gap.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 59: Automation Decision Rule (2 min)

- If you don’t know where you are: start manual
- If you need speed and accept noise: use automation
- If you need stealth: targeted manual discovery
- Always document what you ran and why

**Instructor Notes:**

- **Image Prompt:** Decision diamond: unknown env → manual; time-critical → script; stealth → targeted.
- **Say:**
  - "This is the rule you take into every B03 lab."
  - "Unknown environment: hands only until the first-minute checklist is answered."
  - "Document the choice—handover includes *what you ran*."
- **Show:** Four bullets as a standing SOP.
- **Do:** Post it on the board for the rest of the Block.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 60: OPSEC Considerations for Discovery (2 min)

**Instructor Notes:**

- **Image Prompt:** Section divider. Eye/SIEM icon; title only.
- **Say:** "Last section: how discovery looks from the other side, and how you hand it off."
- **Show:** Title; advance.
- **Do:** None.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 61: Discovery Activities Are Noisy (2 min)

- Generate logs (process, auth, file access, command history)
- Trigger alerts (rapid enumeration, suspicious tools)
- Feed correlation systems (SIEM)

**Instructor Notes:**

- **Image Prompt:** Three pipes from an operator into LOG / ALERT / SIEM.
- **Say:**
  - "Even 'native' commands log."
  - "Volume and tool choice are what correlation needs."
- **Show:** SIEM as the aggregator, not a single event.
- **Do:** Revisit Slide 7; this is the same idea after they have technique names.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 62: Balance Speed vs Stealth (2 min)

- Survey scripts are fast but noisy
- Manual discovery is slower but often quieter
- Context determines approach

**Instructor Notes:**

- **Image Prompt:** Slider: Speed vs Stealth; context knob.
- **Say:**
  - "There is no universal right setting."
  - "Mission timing, EDR, and how much you already know set the slider."
- **Show:** Slider.
- **Do:** "Classroom labs vs a live EDR—where does the slider move?"
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 63: Blend With Normal Activity (2 min)

- Mimic admin behavior and timing
- Use legitimate tools where possible
- Avoid obvious attacker tradecraft patterns

**Instructor Notes:**

- **Image Prompt:** Admin toolbox vs "hacker script" toolbox; pick admin.
- **Say:**
  - "Native `ps`, `ss`, `systeminfo`, `whoami` blend; random GitHub dump tools do not."
  - "Timing matters: a burst at 03:00 on a workstation is a tell."
- **Show:** Legitimate tools.
- **Do:** Ask for one "obvious attacker" pattern to avoid (LinPEAS from `/tmp/l.sh`).
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 64: Document for Operational Handover (2 min)

- What you learned
- Critical findings
- What you did not learn (gaps)
- What should happen next

**Instructor Notes:**

- **Image Prompt:** Four-line handover (learned / critical / gaps / next).
- **Say:**
  - "Handover is an OPSEC control too—someone else should not re-spray the host to learn what you already know."
  - "Gaps are mandatory."
- **Show:** Four lines = Slide 51 compressed.
- **Do:** This is the close-out for every lab in this Block.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 65: OPSEC Checklist (Preview) (2 min)

- Rate-limit and prioritize commands
- Avoid broad scans and recursive searches unless justified
- Prefer local discovery over remote where possible
- Track artifacts you create (files, scripts, outputs)
- Summarize and hand over

**Instructor Notes:**

- **Image Prompt:** Five-item checklist card.
- **Say:**
  - "Preview you can photograph."
  - "Justify the loud things in the notes if you do them."
- **Show:** Five lines.
- **Do:** Students keep this next to the documentation template.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 66: Common OPSEC Pitfalls (2 min)

- Running large third-party tools without review
- Obvious filenames and leftover artifacts
- Forgetting discovery can trigger defensive correlation

**Instructor Notes:**

- **Image Prompt:** Three pitfall tiles.
- **Say:**
  - "Read a tool before you run it."
  - "Names like `exploit.sh` in `/tmp` are a gift to defenders."
  - "Correlation is delayed—quiet now can still alert later."
- **Show:** Three pitfalls.
- **Do:** One horror-story prompt: leftover output file with creds.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 67: Constraint Adaptation — Standing Method (2 min)

- Identify the surface you occupy
- Prove the constraint from native evidence
- Adapt collection when the standard toolkit is missing
- Document gaps and what you ran
- Re-run the first-minute checklist on every new shell, upload, or pivot
- If the host is dying: identity, listeners, and a process snapshot before deep file search

**Instructor Notes:**

- **Image Prompt:** Four-step loop (Identify → Prove → Adapt → Document) with a side callout: "new surface → restart first-minute checklist." Degraded-host strip: identity / listeners / `ps` snapshot first.
- **Say:**
  - "This is the standing method for the rest of the Block—not a command list."
  - "Identify the surface. Prove the jail, MAC, container, or hybrid boundary from what the host already shows. Then change collection. Then write the gaps."
  - "Every new shell, upload, or pivot is a new surface. Re-run the first-minute checklist; do not inherit the last answer."
  - "If RAM, tools, or time are collapsing: identity, listeners, and a process snapshot before you start walking the filesystem."
  - "If the hour is short, keep this slide. Cut TA0007 technique-card depth first."
- **Show:** Walk Identify → Prove → Adapt → Document once; then the degraded-host strip.
- **Do:** Have them write the four verbs in lab notes. Cold-call: "Tools are gone and the box is swapping—what do you collect first?" Identity, listeners, process snapshot.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 69: Knowledge Check (6 min)

- If Windows is domain-joined, what discovery changes first?
- What is the minimum command set to identify Linux environment and user context?
- Name one OPSEC risk of automation
- `whoami` is root—how do you know you are not in a jail or container?

**Instructor Notes:**

- **Image Prompt:** Four numbered questions; no answers on the slide.
- **Say:**
  - "Cold-call or teams of two; 90 seconds each."
  - "Q1: AD/domain discovery and handoff documentation; local-admin ≠ DA."
  - "Q2: something like `uname -a`, `cat /etc/os-release`, `id` (and `ps`/`ss` if you include role/network)."
  - "Q3: log spike, on-disk script, sensitive output files."
  - "Q4: prove the boundary—PID 1, filesystem view, cgroup/`.dockerenv`, missing tools, policy/logs. A root prompt is a claim."
- **Show:** Keep answers off the slide until after they try.
- **Do:** Take four answers; correct using earlier slides.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 70: Lesson Summary (1 min)

- On-objective operations
- Execution environments
- User context and privileges
- MITRE ATT&CK Discovery techniques
- Survey scripts and automation
- OPSEC considerations for discovery

**Instructor Notes:**

- **Image Prompt:** Six recap tiles matching Slide 3.
- **Say:**
  - "You now have the on-objective loop: environment, user, selected Discovery, optional automation, OPSEC/handover."
  - "Constraint adaptation is how that loop survives the rest of the Block: Identify → Prove → Adapt → Document."
  - "ATT&CK Discovery is the shared language for what you just did."
- **Show:** Six tiles; add the four-verb loop as a footer if space.
- **Do:** Point back to the four objectives from Slide 2.
- **Ask (Q):** What is the operational takeaway from this row?
- **Expected Response (A):** Facilitation. Restate the Say/Do in operator terms. Do not invent a new teaching point.

### Slide 72: Questions? (1 min)

**Instructor Notes:**

- **Image Prompt:** Simple Q&A; footer with TA0007, "collect once, parse locally," and Identify → Prove → Adapt → Document.
- **Say:**
  - "Questions on environments, user context, Discovery technique choice, scripts, OPSEC, or the constraint loop."
  - "Lab logistics belong in the issued lab brief."
- **Show:** Leave the collect-once and four-verb lines visible.
- **Do:** If none, cold-call: "First four commands on a new Linux shell?" Then: "The box starts failing—what do you collect first?"
- **Ask (Q):** First four commands on a new Linux shell?
- **Expected Response (A):** Facilitation. Drive toward identity, time, process, and listener checks before Discovery noise.

---

## Reverse-build notes

- Extracted from the student PPTX via `tools/pptx_to_content_guide.py`, then rewritten to course content-guide form (Say/Show/Do, Image Prompt, ≤7 bullets, divider slides title-only).
- Lesson Objectives on Slide 2 kept **verbatim** from the deck.
- First-line PPTX headings that duplicated the slide title were folded into the `### Slide N:` title or dropped from the bullet list.
- Scheduled execution is a first-minute checklist item (Slide 9) and a handover field (Slides 11, 51).
- Jail vs MAC constraint models are student-visible on Slide 17; container/hybrid re-identify on Slide 23.
- Standing method Identify → Prove → Adapt → Document is Slide 67 (2 min; protect if the hour is short).
- Course tie-in and lab-preview slides were removed. Degraded-ops rules stay on Slide 67.

## Lesson summary

- B03.M01-situational-awareness-environments is executed as a generated lesson plan from this file.
- Assessment methods live on module.yaml; do not invent extra official ELOs.

## Questions and check on learning

- **Ask (Q):** In one sentence, what is the first thing you do after a shell?
- **Expected Response (A):** Facilitation. Use the Say/Do already on this row; do not force a single keyed answer.
