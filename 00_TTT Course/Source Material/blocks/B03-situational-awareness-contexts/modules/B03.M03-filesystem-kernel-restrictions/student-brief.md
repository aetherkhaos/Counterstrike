---
id: B03.M03.student-handout
title: Collie and Cow Student Brief
artifact_type: student_brief
audience: student
block: B03
module_type: lab
legacy_aliases:
- week3_repo/docs/student-handout-module-2.md
- legacy/week3/labs/L3.3_Filesystem_and_Kernel-Level_Restrictions
- B04.M14
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
# Collie and Cow Student Brief

## Objective

This module develops evidence-based analysis in restricted Linux environments. Students should identify environment type, validate control boundaries, and demonstrate adaptive execution under filesystem and policy constraints.

### Training caveat

Some actions in these labs are intentionally artificial, compressed, or staged for training. Treat them as simulations of investigative tasks you may need to perform across a variety of real operational situations, not as a claim that every step exactly mirrors a single real-world incident.

## Context

You will operate in restricted Linux execution contexts (chroot and AppArmor). Your goal is to identify the active constraint model, prove what is blocked or allowed, and adapt collection paths without jumping directly to solution commands.

## Constraints

- Prove constraint boundaries from native artifacts (runtime metadata, policy files, logs) before selecting bypass/adaptation actions.
- Use ordinary administrative evidence paths rather than training-only shortcuts.
- Record denied and allowed outcomes with command evidence.
- Puppet scripts and simspace accounts are range management tools, they are out of scope for this exercise.

## Tasks

### Chroot Jail Investigation

### Environment

A constrained shell entry point is provided on a TCP port (non-PTY interaction). In the default build, the initial prompt begins in `/opt/lab21`.

Expected flags: 4.

### Access


| Hostname (expected) | IP address  | Username            | Password | Connection                                   |
| ------------------- | ----------- | ------------------- | -------- | -------------------------------------------- |
| `collie-21`         | 20.30.40.21 | N/A (shell service) | N/A      | TCP shell service (default often TCP `4444`) |


### Tasks

1. Establish runtime context (identity, working path, process visibility, and filesystem boundaries) from the constrained shell.
2. Determine the environment type and justify that conclusion with concrete host evidence.
3. Document tooling limitations and demonstrate at least one adaptation strategy used because of those limits.
4. Recover all four flags in this environment.
5. For each flag, record both the recovery method and the evidence/output that validates the result.

#### Report and submission

Submit a concise environment assessment that answers: what environment you operated in, how you proved it, what constraints were encountered, and how you adapted. Include the recovery method and validating evidence for each flag, following instructor assessment criteria.

### AppArmor Restriction Investigation

### Environment

A standard Linux shell is provided with AppArmor enabled in enforcing mode.

Expected flags: 5.

### Access


| Hostname (expected) | IP address  | Username | Password         | Connection   |
| ------------------- | ----------- | -------- | ---------------- | ------------ |
| `cow-22`            | 20.30.40.22 | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 22) |


### Tasks

1. Confirm AppArmor status and identify relevant profile state and policy locations.
2. Identify and exercise lab-related helper/gate scripts in normal administrative paths.
3. Execute an uploaded payload through the gate from its initial location and capture blocked/denied behavior.
4. Collect denial and policy evidence from native host artifacts and correlate it to the blocked action.
5. Identify an allowed execution path from policy evidence, run the same payload from that path, and validate successful behavior.
6. Recover all five flags and document the command/evidence chain for each.

#### Clues and constraints

- Use native host evidence (for example kernel/system logs and policy files) to prove both denied and allowed outcomes.
- One flag depends on process-context analysis using standard runtime metadata.

#### Report and submission

Submit a structured explanation of how AppArmor affected workflow, which action was denied, which alternate action was allowed, and what host evidence validates each conclusion. Include all five flags with corresponding recovery evidence, following instructor assessment criteria.

## Deliverables / Evidence

- Submit all flags for Labs 2.1 and 2.2 with recovery method and validating host evidence.
- Include a short comparison of chroot constraints versus AppArmor policy constraints.
- Document at least one adaptation used in each lab when a default path or tool was constrained.

## Success Criteria

You successfully complete this Module when you can identify each restriction model, prove blocked-versus-allowed behavior from host artifacts, and recover all flags with clear adaptation rationale.
