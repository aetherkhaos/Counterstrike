## Purpose

This activity uses selected portions of the **Hack The Box (HTB) Using the Metasploit Framework** module to practice initial exploitation workflow in an authorized lab environment.

In this course, Metasploit is not treated as a shortcut or a replacement for analysis. It is a framework for matching target evidence to an exploit, selecting an appropriate payload, understanding failure modes, and managing access long enough to collect required proof. The larger course goal is to connect blue-space findings, tactical planning, and controlled access to a target system.

## Lab Access Model

Work from the HTB-provided lab environment or the attack host approved by your instructor. Your target will be provided through HTB or by your instructor.

Do not run Metasploit modules against systems outside the assigned HTB target or instructor-provided scope.

Pro tip: each student may receive a different target IP, and HTB may assign a new IP if you return to the lab later. At the start of each work session, confirm both your target IP and your local VPN/interface IP before launching listeners or payloads:

```bash
export TGT=<assigned_target_ip>
ip -br addr
echo "$TGT"
```

Use the current HTB target for `RHOSTS` or equivalent target options. Use the correct local VPN/interface address for callback options such as `LHOST` when a payload requires one.

After you obtain a shell or Meterpreter session in an HTB task, verify target context before collecting evidence:

```bash
hostname
whoami
pwd
```

## Required HTB Work

Complete the assigned HTB Metasploit pages and answer all associated HTB questions for the task areas below. Treat unlisted pages as reference material unless your instructor directs otherwise.

## What to Focus On

### 1. Introduction to Metasploit

Understand what Metasploit is, where it is installed, and how its directory/module structure supports repeatable exploitation workflow.

Course application: before using a framework in an operation, you need to know what capability it provides, what assumptions it makes, and where its artifacts live.

### 2. MSFconsole Workflow

Practice launching `msfconsole`, searching for relevant modules, setting required options, running modules, and reading output carefully.

Course application: MSFconsole is the central interface for moving from target evidence to controlled action. Speed matters, but only after you understand the target and module requirements.

### 3. Modules and Search

Use module categories and search syntax to identify capabilities that match the target environment, vulnerability, protocol, or CVE.

Course application: module selection should be driven by evidence. A useful operator can explain why a module matches the target rather than simply trying modules until one works.

### 4. Targets

Review target options inside exploit modules and understand why operating system, service version, architecture, and application context matter.

Course application: a mismatched target selection can fail noisily, crash a service, or produce misleading results. Target selection is part of operational discipline.

### 5. Payloads

Compare payload types and understand the difference between an exploit and a payload. Pay attention to payload compatibility, callback requirements, and whether the task calls for a basic shell or a Meterpreter session.

Course application: the payload determines what kind of access or effect the exploit attempts to produce. Payload selection should match the mission need and the target constraints.

### 6. Encoders

Review how encoders fit into payload generation and why they are not a universal evasion answer.

Course application: operators should understand payload formatting, bad-character handling, and signature risk without assuming encoding solves detection.

### 7. Databases and Workspaces

Use Metasploit database and workspace features when the HTB task requires them or when tracking multiple findings.

Course application: organized evidence reduces confusion during handoff and prevents repeated collection against the same target.

### 8. Sessions and Jobs

Practice managing sessions, backgrounding active access, and running jobs when a task requires multiple concurrent actions.

Course application: access management matters after initial exploitation. You need to know which session is active, what it connects to, and what evidence was collected through it.

### 9. Meterpreter

Use Meterpreter only as directed by the HTB task. Focus on understanding what the session gives you, what user context it runs under, and what evidence the task asks you to retrieve.

Course application: Meterpreter can provide a powerful post-exploitation vantage point, but that power must be bounded by the task, target scope, and evidence requirement.

### 10. MSFVenom

Use MSFVenom when the HTB task requires custom payload generation. Track the payload type, platform, format, callback settings, and where the generated artifact is used.

Course application: custom payload generation should be deliberate and documented so another operator can understand what was built and why.

### 11. Firewall and IDS/IPS Evasion Concepts

Review the differences between endpoint and perimeter defenses and how Metasploit activity may appear to defenders.

Course application: even in a lab, you should understand detectability, signatures, and traffic patterns. The goal is not only to get a shell; it is to understand what your actions would look like from blue space.

### 12. Framework Updates

Review current framework capabilities described in HTB, including changes to Meterpreter communication and supported protocols.

Course application: tool behavior changes over time. Operators should confirm current behavior rather than relying on stale assumptions.

## Practical Deliverables

Complete the HTB questions associated with the assigned Metasploit tasks. Your instructor may review progress during section checkpoints.

Be prepared to explain:

- Which target you used and how you confirmed it was in scope.
- Which module you selected and what evidence supported that choice.
- Which payload you selected and why it fit the task.
- Which options mattered most, including target and callback settings.
- What failed, how you diagnosed it, and what you changed.
- What evidence you collected from the target session.
- What the activity would look like from a defender's telemetry view.

## Required Task Areas

1. **Framework orientation:** Review the Metasploit directory structure and module organization.
2. **MSFconsole exploitation:** Use Metasploit as directed by HTB to exploit the assigned target and retrieve the requested flag from the specified user context.
3. **Module search:** Use Metasploit search features to locate modules that match specific CVEs, platforms, or services.
4. **Target selection:** Inspect and set module target options when the exploit requires an explicit target environment.
5. **Payload selection:** Filter and select compatible payloads for the HTB task, then explain the exploit/payload relationship.
6. **Apache Druid task:** Use the appropriate Metasploit workflow directed by HTB to exploit the assigned service and retrieve the required flag.
7. **Encoder review:** Identify compatible encoders and explain what problem they solve.
8. **Database workflow:** Initialize or use the Metasploit database and workspaces as directed.
9. **Session and job management:** Practice backgrounding sessions and managing running jobs.
10. **Meterpreter task:** Use the HTB-directed Meterpreter workflow to identify the requested user context and retrieve the requested hash evidence.
11. **MSFVenom task:** Generate the payload artifact required by HTB and document the options used.
12. **Detection discussion:** Review endpoint and perimeter detection concepts and be ready to discuss how Metasploit activity might appear in logs or alerts.