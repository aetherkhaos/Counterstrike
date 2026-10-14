# Module 1: Foundational Situational Awareness - Student Handout

## Objective

This module develops baseline host-enumeration discipline in standard Linux and Windows environments. Build an evidence-based picture of system purpose, services, users, and operational risk indicators before moving into constrained scenarios.

## Lab 1.1 - Profiling the Linux Server

### Environment

A standard Linux server (for example Ubuntu or Rocky) is provided with common services and normal shell tooling.

Expected flags: 5.

### Analyst Box:
kali - toortoor!
### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`boar-11`|`20.30.40.11`|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 22)|

### Tasks

1. Enumerate running processes using standard process-inspection tools and distinguish expected daemons from custom applications or scripts.
2. Enumerate listening TCP/UDP services and associate ports to likely service roles.
3. Review system and user scheduled execution paths (including cron) and identify what runs, when it runs, and under which privileges.
4. Establish current user and privilege context, then map other user accounts and home-directory artifacts.
5. Perform file and configuration reconnaissance to identify service configuration, application footprint, and potential credential-bearing content.
6. Produce a host-purpose conclusion from the collected evidence and recover all five lab flags discovered during enumeration.

### Clues and Constraints

- Flag artifacts may appear in normal operational locations, including command output, configuration files, and service-related content.
- Evidence quality matters more than command volume; prefer concise commands with clear interpretation.

### Report and Submission

Submit a complete analysis covering process, network, scheduling, user, file/configuration, and conclusion evidence. Begin with a short **Flags** section listing each of the five exact flag strings and where each was recovered (for example, file path, command output, or service/config artifact). Then provide any additional responses required by the module assessment criteria.

## Lab 1.2 - Profiling the Windows Server

### Environment

A standard Windows Server environment is provided with common roles and built-in administrative tooling (PowerShell, CMD, and native binaries).

Expected flags: 5.

### Access

| Hostname (expected) | IP address    | Username | Password           | Connection |
| ------------------- | ------------- | -------- | ------------------ | ---------- |
| `bull-12`           | `20.30.40.12` | `badguy` | `1qaz2wsx!QAZ@WSX` | psexec     |

### Tasks

- 1. Enumerate running processes and differentiate system components, installed software, and custom execution.
- 2. Enumerate active/listening network connections and map key ports to expected services.
- 3. Review scheduled task activity and identify high-privilege or custom task behavior.
1. Establish user/domain context and enumerate account/session indicators relevant to host operation.
- 5. Perform file and configuration reconnaissance for web, script, and credential-bearing artifacts.
1. Produce a host-purpose conclusion from the collected evidence and recover all five lab flags discovered during enumeration. - web server

### Clues and Constraints

- Flag artifacts are integrated into realistic host evidence sources rather than isolated challenge-only files.
- Validate conclusions by correlating multiple evidence types whenever possible.

### Report and Submission

Submit a complete analysis covering process, network, scheduled-task, user/domain, file/configuration, and conclusion evidence. Begin with a short **Flags** section listing each of the five exact flag strings and where each was recovered (for example, file path, command output, or service/config artifact). Then provide any additional responses required by the module assessment criteria.

## Submission Notes

Push your report to the JCWA GitLab instance in the Counterstrike course [Student Submissions](https://code.levelup.cce.af.mil/dco-counterstrike-pilot-course-content/student-submissions) repository.

- Create a new branch name `Lab3.2-<Lastname>-<Firstname>`

---
## Building the Gitlab Student Submissions Folder

@ian.starr
https://code.levelup.cce.af.mil/dco-counterstrike-pilot-course-content/student-submissions.git
r2d2-3WBbMpkNeq2Zz5G9OF742W86MQp1OmhmbAk.01.0z0mvhgbs

git -c http.sslVerify=false clone 'https://ian.starr:r2d2-3WBbMpkNeq2Zz5G9OF742W86MQp1OmhmbAk.01.0z0mvhgbs@code.levelup.cce.af.mil/dco-counterstrike-pilot-course-content/student-submissions.git'