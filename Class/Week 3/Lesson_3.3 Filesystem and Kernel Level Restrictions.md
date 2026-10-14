# Module 2: Filesystem and Kernel-Level Restrictions - Student Handout

## Objective

This module develops evidence-based analysis in restricted Linux environments. Identify environment type, validate control boundaries, and demonstrate adaptive execution under filesystem and policy constraints.

### Training Caveat

Some actions in these labs are intentionally artificial, compressed, or staged for training. Treat them as simulations of investigative tasks you may perform across a range of operational situations, not as a claim that every step exactly mirrors a single real-world incident.

## Lab 2.1 - The Chroot Jail

### Environment

A constrained shell entry point is provided on a TCP port (non-PTY interaction). In the default build, the initial prompt begins in `/opt/lab21`.

Expected flags: 4.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`collie-21`|`20.30.40.21`|N/A (shell service)|N/A|TCP shell service (default often TCP `4444`)|

### Tasks

1. Establish runtime context (identity, working path, process visibility, and filesystem boundaries) from the constrained shell.
2. Determine the environment type and justify that conclusion with concrete host evidence.
3. Document tooling limitations and demonstrate at least one adaptation strategy used because of those limits.
4. Recover all four flags in this environment.
5. For each flag, record both the recovery method and the evidence/output that validates the result.

### Report and Submission

Submit a concise environment assessment that answers: what environment you operated in, how you proved it, what constraints were encountered, and how you adapted. Include the recovery method and validating evidence for each flag, following instructor assessment criteria.

## Lab 2.2 - Living with AppArmor Restrictions

### Environment

A standard Linux shell is provided with AppArmor enabled in enforcing mode.

Expected flags: 5.

### Access

| Hostname (expected) | IP address    | Username | Password         | Connection   |
| ------------------- | ------------- | -------- | ---------------- | ------------ |
| `cow-22`            | `20.30.40.22` | `badguy` | `badGuy!QAZ1qaz` | SSH (TCP 22) |

### Tasks

1. Confirm AppArmor status and identify relevant profile state and policy locations.
2. Identify and exercise lab-related helper/gate scripts in normal administrative paths.
3. Execute an uploaded payload through the gate from its initial location and capture blocked/denied behavior.
4. Collect denial and policy evidence from native host artifacts and correlate it to the blocked action.
5. Identify an allowed execution path from policy evidence, run the same payload from that path, and validate successful behavior.
6. Recover all five flags and document the command/evidence chain for each.

### Clues and Constraints

- Use native host evidence (for example kernel/system logs and policy files) to prove both denied and allowed outcomes.
- One flag depends on process-context analysis using standard runtime metadata.

### Report and Submission

Submit a structured explanation of how AppArmor affected workflow, which action was denied, which alternate action was allowed, and what host evidence validates each conclusion. Include all five flags with corresponding recovery evidence, following instructor assessment criteria.