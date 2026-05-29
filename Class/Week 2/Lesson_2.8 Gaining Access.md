## Purpose

This multi-part lab uses selected **Hack The Box (HTB) Academy** modules to practice gaining access through realistic web, service, and application weaknesses. The HTB environments provide the technical targets; the course framing explains why a Cyber Protection Team might move from blue-space telemetry to a controlled action against adversary infrastructure.

Use HTB to master the **how**. Use the operational context in these pages to understand the **when**, **why**, and **what evidence matters**.

## Lab Access Model

Work from the HTB-provided Pwnbox or an instructor-approved attack platform connected through the HTB VPN. Each part uses the target spawned by its assigned HTB module or skills assessment.

Do not interact with systems outside the assigned HTB target or instructor-provided scope.

Pro tip: HTB target IPs are per-student and may change if you return to the lab later. At the start of each work session, confirm the current target and set a shell variable to reduce copy-paste mistakes:

```bash
export TGT=<assigned_target_ip>
echo "$TGT"
```

Replace `<assigned_target_ip>` with the current target shown in HTB or provided by your instructor.

If a part gives you shell access, verify the target context before collecting evidence:

```bash
hostname
whoami
pwd
```

## Parts

Complete the parts in order unless your instructor assigns a different sequence.

|Part|HTB Module|Primary Skill|
|---|---|---|
|[Part A: SQL Injection Fundamentals](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.8_Gaining_Access/parts/part-a-sql-injection/)|SQL Injection Fundamentals|Manual SQL injection and authentication bypass|
|[Part B: File Upload Attacks](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.8_Gaining_Access/parts/part-b-file-upload/)|File Upload Attacks|Upload filter evasion and web-shell access|
|[Part C: FTP Common Services](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.8_Gaining_Access/parts/part-c-ftp-common-services/)|Attacking Common Services|FTP enumeration, credential discovery, and follow-on access assessment|
|[Part D: SMB Common Services](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.8_Gaining_Access/parts/part-d-smb-common-services/)|Attacking Common Services|SMB enumeration, credential validation, and interactive access path development|
|[Part E: Common Applications](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.8_Gaining_Access/parts/part-e-common-applications/)|Attacking Common Applications|Full service enumeration, vulnerability research, and application compromise|

## Evidence Expectations

For each part, be prepared to explain:

- What blue-space trigger or telemetry started the action.
- Which HTB target and module section you used.
- What you enumerated before attempting access.
- What weakness or misconfiguration enabled progress.
- What evidence proves the task objective was met.
- What the next planning, reporting, or handoff step would be.

Record commands, observations, and HTB answers as you work. The goal is not only to retrieve flags; it is to build the habit of turning access activity into defensible operational evidence.

---
# Part A: SQL Injection Fundamentals

## HTB Module

**SQL Injection Fundamentals**

## Operational Context

CPT threat hunters identify a persistent unauthorized outbound connection from a compromised internal file server to an external collection point. Endpoint logs and packet captures show a custom data exfiltration agent posting file metadata to an adversary-controlled backend.

From blue-space telemetry, the team can infer the structure of the HTTP request and the likely database-backed collection workflow. The counter-strike opportunity is to understand how SQL injection can affect an adversary application that trusts input from its collection agent.

## What to Do in HTB

1. Navigate to the HTB Academy module **SQL Injection Fundamentals**.
2. Review the introductory SQL injection material, especially the pages covering in-band SQL injection and authentication bypass.
3. Continue to **Subverting Query Logic**.
4. Spawn the target and open your Pwnbox or approved attack platform.
5. Analyze the provided login page and identify how user-controlled input affects the query logic.
6. Use manual payload testing to bypass authentication as directed by HTB.
7. Trigger the SQL injection from the command line when the HTB task requires it.

## Rules and Scope

Do not use automated exploitation tools such as SQLMap for this part. The learning objective is manual reasoning about query structure, input handling, and authentication bypass.

## Evidence to Capture

- The HTB page or section completed.
- The target address used for the exercise.
- The parameter or input field you tested.
- The reasoning that showed the query logic was injectable.
- The required HTB flag or answer after successful bypass.

## Course Application

This part connects blue-space evidence to adversary infrastructure manipulation. You are practicing how a defender can use knowledge of an adversary workflow to identify where trusted input, malformed data, or poor validation creates an opportunity for action.

---

# Part B: File Upload Attacks

## HTB Module

**File Upload Attacks**

## Operational Context

A CPT threat hunter identifies a scheduled task on a compromised system that compresses sensitive material and uploads it to an external adversary URL. Network telemetry shows a standard HTTP `POST` upload flow with no visible authentication headers.

The counter-strike opportunity is to understand how poorly controlled file upload functionality can become a path to command execution on an adversary staging server.

## What to Do in HTB

1. Navigate to the HTB Academy module **File Upload Attacks**.
2. Go to the skills assessment content for upload filter evasion.
3. Spawn the target system and confirm you can reach the upload form.
4. Analyze the upload behavior and observe how the application handles allowed and rejected files.
5. Use the HTB-guided techniques to test client-side filtering, MIME handling, file signatures, and extension controls.
6. Work toward command execution through the upload path as directed by HTB.
7. Submit the required flag from the web root after successful execution.

## Access Method

Primary method family: `web-shell`.

If you obtain a web shell or command-execution primitive, verify context before collecting evidence:

```bash
hostname
whoami
pwd
```

Keep activity limited to the assigned HTB target.

## Operator Notes

- File upload failures are evidence. Record which control rejected the file and why.
- If local file read becomes possible, use it to understand filtering logic before changing payload strategy.
- If encoded file reads are needed, document why raw content breaks the parser and how encoding changes the result.
- Avoid assuming that a blocked extension means execution is impossible; understand the server and handler behavior.

## Evidence to Capture

- The upload controls or validation layers you observed.
- The technique that changed the server response.
- The shell or command-execution context, if obtained.
- The required HTB flag from the web root.

## Course Application

This part demonstrates how adversary drop boxes and staging portals can become access paths when they are built quickly or defended poorly. The useful output is not only a flag; it is a clear explanation of which validation failed and how that failure could support a controlled follow-on action.

---

# Part C: FTP Common Services

## HTB Module

**Attacking Common Services**

## Operational Context

SIEM and NDR telemetry show credential-based activity from a suspected adversary staging VPS. During endpoint analysis, the CPT recovers fragments of configuration material that appear related to the adversary's credential workflow.

The counter-strike opportunity is to enumerate a misconfigured FTP service that may host payloads, victim lists, credential material, or other operational resources.

## What to Do in HTB

1. Navigate to the HTB Academy module **Attacking Common Services**.
2. Work through the FTP-focused section assigned by your instructor.
3. Confirm the current target IP and set `TGT` if helpful.
4. Perform service discovery and versioning to locate the FTP service.
5. Review relevant Nmap FTP scripts before running them.
6. Test for anonymous access or other HTB-directed access paths.
7. Search for files that may contain user lists, password material, payloads, or staging data.
8. Use the credential attack workflow required by HTB and validate results against the service.
9. Review other open services to determine whether recovered credentials enable a more useful interactive access path.
10. Complete all HTB questions for this section.

## Pro Tip: Target Variable

HTB target IPs can change between sessions. Set and confirm `TGT` at the beginning of the part:

```bash
export TGT=<assigned_target_ip>
echo "$TGT"
```

## Evidence to Capture

- Full-port discovery and the FTP service/version finding.
- Which FTP scripts you reviewed and why you selected any script you ran.
- Whether anonymous access worked and what evidence supported the conclusion.
- Any recovered user or password material used for the HTB task.
- Which other service could support follow-on access.
- HTB answers for the section.

## Course Application

This part links service enumeration to resource recovery. FTP findings can reveal how an adversary stages payloads, manages credentials, or exposes campaign material. Strong work explains how each recovered artifact changes the next collection or access decision.

---

# Part D: SMB Common Services

## HTB Module

**Attacking Common Services**

## Operational Context

SIEM analysis identifies high-volume SMB traffic from a compromised file server to an external IP address. The adversary appears to have intentionally allowed SMB access from the defended network so stolen data can be staged to a remote Samba server.

The counter-strike opportunity is to use that same visible path to enumerate the adversary-controlled file service, identify accessible shares, recover useful artifacts, and determine whether those artifacts enable an interactive access path.

## What to Do in HTB

1. Navigate to the HTB Academy module **Attacking Common Services**.
2. Go to the SMB enumeration sections assigned by your instructor.
3. Review the resources section and download the provided user and password lists.
4. Perform service validation to confirm SMB/Samba is reachable and identify version details.
5. Attempt unauthenticated enumeration with tools such as `smbclient` and `enum4linux`.
6. Identify available shares and note whether each share appears read-only, writable, restricted, or anonymously accessible.
7. Extract valid local user information when available.
8. Validate credentials against the standalone service using the authentication mode required by the tool.
9. Explore accessible restricted shares with validated credentials.
10. Use recovered material to identify a path toward the final objective described in HTB.
11. Answer all HTB questions for this section.

## Access Method

Primary method family for any final interactive shell path: `ssh-key`, when recovered artifacts support SSH access in the HTB task. SMB enumeration itself is a service-enumeration and credential-validation activity.

If you obtain an interactive shell, verify context before collecting the final flag:

```bash
hostname
whoami
pwd
```

## Evidence to Capture

- SMB/Samba service version and reachable ports.
- Share names and access levels.
- Usernames or credential material recovered during enumeration.
- Credential validation results.
- Which recovered artifact enabled the final access path.
- HTB answers for the section.

## Course Application

This part emphasizes recursive resource enumeration: one exposed service can reveal credentials, files, or keys that unlock a better access path. The operational skill is explaining how each finding justifies the next step without jumping directly to exploitation.

---

# Part E: Attacking Common Applications

## HTB Module

**Attacking Common Applications**

## Operational Context

CPT threat hunters identify sporadic outbound connections from a compromised internal segment to an external IP across several ports. Banner evidence suggests the adversary staging server exposes multiple administrative and operational services.

The counter-strike opportunity is to sort through noisy exposed services, identify the application or service that actually matters, research the relevant vulnerability, and adapt the exploitation path to the target environment.

## What to Do in HTB

1. Navigate to the HTB Academy module **Attacking Common Applications**.
2. Select the **Skills Assessment** section.
3. Spawn the target system and confirm connectivity from your Pwnbox or approved HTB VPN attack platform.
4. Perform comprehensive port discovery.
5. Follow up with service version detection and default script scanning for identified open ports.
6. Determine the target operating system and version from your evidence.
7. Review each service and identify which ones reveal useful version information, unauthenticated access, or likely vulnerability leads.
8. Research public CVEs and proof-of-concept material for promising services.
9. Use content discovery when web services may hide directories, scripts, configuration files, or CGI paths.
10. Attempt to gain a foothold only after you can explain why the selected entry point is plausible.
11. Submit the final HTB flag after successful compromise.

## Pro Tip: Avoid Rabbit Holes

Windows targets and multi-service targets often expose distracting ports. If a service accepts a connection but provides no useful banner, version, authentication surface, or error behavior, record it and move on. Prioritize services that provide evidence you can tie to a known application, configuration weakness, or CVE.

## Access Method

Primary method family: `listening-raw-shell`, when the HTB task requires a callback shell from the exploited application. If the final path uses a different HTB-provided access method, follow the module instructions and keep the activity scoped to the spawned target.

After shell access, verify context:

```bash
hostname
whoami
pwd
```

## Evidence to Capture

- Full-port and service-version results.
- OS/version evidence.
- Services ruled in or out and why.
- CVE or public exploit research tied to the observed version.
- Any content-discovery results that changed your path.
- Adjustments required when a public exploit did not work as-is.
- The final HTB flag.

## Course Application

This part pulls together enumeration, vulnerability research, exploit selection, troubleshooting, and evidence collection. It is the closest L2.8 part to a full access workflow: identify the terrain, select a plausible path, test carefully, adapt to the environment, and document what proved success.