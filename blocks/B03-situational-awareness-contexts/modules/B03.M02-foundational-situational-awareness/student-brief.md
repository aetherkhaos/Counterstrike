---
id: B03.M02.student-handout
title: Boar and Bull Student Brief
artifact_type: student_brief
audience: student
block: B03
module_type: lab
legacy_aliases:
- week3_repo/docs/student-handout-module-1.md
- legacy/week3/labs/L3.2_Foundational_Situational_Awareness
- B04.M13
source_kind: markdown
render_mode: generate
source_status: authored
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---
# Boar and Bull Student Brief

## Objective

This module develops baseline host-enumeration discipline in standard Linux and Windows environments. Students should build an evidence-based picture of system purpose, services, users, and operational risk indicators before moving into more constrained scenarios.

## Context

You will profile one Linux host and one Windows host using native enumeration evidence before drawing conclusions. Start broad, then narrow only after evidence identifies likely service, account, and configuration targets.

## Constraints

- Use assigned host, credential, and connection values from instructor/range guidance when they differ from defaults.
- Keep collection evidence-first: avoid jumping to assumptions without process, network, scheduling, account, and config artifacts.
- Preserve student-safe operations; do not use destructive changes to fabricate evidence.
- Puppet scripts and simspace accounts are range management tools, they are out of scope for this exercise.

## Tasks

### Linux Server Profiling

### Environment

A standard Linux server (for example Ubuntu or Rocky) is provided with common services and normal shell tooling.

Expected flags: 5.

### Access


| Hostname (expected) | IP address  | Username | Password         | Connection   |
| ------------------- | ----------- | -------- | ---------------- | ------------ |
| `boar-11`           | 20.30.40.11 | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 22) |


### Tasks

1. Enumerate running processes using standard process inspection tools and distinguish expected daemons from custom applications or scripts.
2. Enumerate listening TCP/UDP services and associate ports to likely service roles.
3. Review system and user scheduled execution paths (including cron) and identify what runs, when it runs, and under which privileges.
4. Establish current user and privilege context, then map other user accounts and home-directory artifacts.
5. Perform file and configuration reconnaissance to identify service configuration, application footprint, and potential credential-bearing content.
6. Produce a host-purpose conclusion from the collected evidence and recover all five lab flags discovered during enumeration.

#### Clues and constraints

- Flag artifacts may appear in normal operational locations, including command output, configuration files, and service-related content.
- Evidence quality matters more than command volume; prefer concise commands with clear interpretation.

#### Report and submission

Submit a complete analysis covering process, network, scheduling, user, file/configuration, and conclusion evidence. Begin with a short **Flags** section listing each of the five exact flag strings and where each was recovered (for example, file path, command output, or service/config artifact). Then provide any additional responses required by the module assessment criteria.

### Windows Server Profiling

### Environment

A standard Windows Server environment is provided with common roles and built-in administrative tooling (PowerShell, CMD, and native binaries).

Expected flags: 5.

### Access


| Hostname (expected) | IP address  | Username | Password         | Connection |
| ------------------- | ----------- | -------- | ---------------- | ---------- |
| `bull-12`           | 20.30.40.12 | `badguy` | `1qaz2wsx!QAZ@WSX` | psexec     |


### Tasks

1. Enumerate running processes and differentiate system components, installed software, and custom execution.
2. Enumerate active/listening network connections and map key ports to expected services.
3. Review scheduled task activity and identify high-privilege or custom task behavior.
4. Establish user/domain context and enumerate account/session indicators relevant to host operation.
5. Perform file and configuration reconnaissance for web, script, and credential-bearing artifacts.
6. Produce a host-purpose conclusion from the collected evidence and recover all five lab flags discovered during enumeration.

#### Clues and constraints

- Flag artifacts are integrated into realistic host evidence sources rather than isolated challenge-only files.
- Validate conclusions by correlating multiple evidence types whenever possible.

#### Report and submission

Submit a complete analysis covering process, network, scheduled-task, user/domain, file/configuration, and conclusion evidence. Begin with a short **Flags** section listing each of the five exact flag strings and where each was recovered (for example, file path, command output, or service/config artifact). Then provide any additional responses required by the module assessment criteria.

## Submission notes

Follow instructor-provided assessment criteria for exact deliverable format and grading expectations.

## Deliverables / Evidence

- Submit both lab flag sets with exact evidence location for each flag (command output, file path, or configuration artifact).
- Provide Linux and Windows host-purpose conclusions supported by process, network, scheduling, user, and configuration evidence.
- Include one concise evidence chain per host from broad triage to final conclusion.

## Success Criteria

You successfully complete this Module when both host profiles include complete flag recovery, defensible host-purpose conclusions, and evidence chains that show disciplined baseline situational awareness in Linux and Windows contexts.
