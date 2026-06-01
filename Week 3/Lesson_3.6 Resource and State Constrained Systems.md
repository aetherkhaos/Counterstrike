# Module 5: Resource and State-Constrained Systems - Student Handout

## Objective

This module develops adaptive enumeration in environments with resource starvation and frequent state resets. Maintain evidence quality while operating under unstable execution conditions and strict time pressure.

## Lab 5.1 - The Starving System (Low Resources)

### Environment

A low-resource VM is provided (for example 128-256 MB RAM and/or one vCPU). Student access is through an intentionally constrained shell listener, and command execution may fail intermittently.

Expected flags: 6.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`ferret-51`|`20.30.40.51`|N/A|N/A|Netcat shell (TCP 2222)|

### Tasks

1. Establish constrained-session context and validate unstable execution behavior.
2. Recover all six lab flags from native host evidence categories: process/schedule, logs, user/account, port/service, configuration, and encrypted relay analysis.
3. For the encrypted relay objective, discover the correct decryption key from native host evidence, decrypt the large artifact, and recover the flag from plaintext.
4. Record the evidence path for each flag and include at least one adaptation example from failed/interrupted attempts.

### Clues and Constraints

- One flag is tied to scheduled execution behavior rather than always-on process state.
- One flag is tied to an operations-style log entry related to transient failure/recovery.
- One flag is associated with a non-login account and related home/user artifacts.
- One flag can be inferred from standard SSH service metadata on port `22`.
- One flag is in a small runtime configuration containing recovery-oriented key/value settings.
- One flag requires decrypting a large encrypted relay artifact; the matching key material is discoverable from normal host-side operational artifacts.

### Report and Submission

Submit all six recovered flags, the exact evidence source for each, and a short explanation of how you adapted to unreliable execution and memory pressure. Follow instructor assessment criteria for final format.

## Lab 5.2 - The Unstable System (Frequent Resets)

### Environment

The host resets frequently and powers off without warning. Each reboot changes the SSH port. This lab uses the same five evidence categories as Labs 1.1 and 5.1, but requires rapid recovery under reboot pressure.

Expected flags: 6 total, including five primary flags and one composite bonus flag.

### Access

|Hostname (expected)|IP address|Username|Password|Connection|
|---|---|---|---|---|
|`fowl-52`|`20.30.40.52`|`badguy`|`badGuy!QAZ1qaz`|SSH (TCP 2200-2299, rotating)|

### Tasks

1. Scan TCP ports 2200-2299 to identify the current SSH listener before each session.
2. Connect and prioritize high-yield evidence collection before the next reset.
3. Recover all five primary flags from process/schedule, log, user/account, port/service, and configuration evidence.
4. Collect telemetry segments 1 through 5 from the same reboot cycle.
5. Reconstruct the composite bonus flag from the five ordered segments.

### Clues and Constraints

- Each primary flag source includes the flag value and a telemetry line (for example `telemetry segment N of 5: <base64 data>`).
- All five telemetry segments must come from the same boot cycle; mixed-cycle segments produce corrupt output.
- Discovery methodology is consistent with Labs 1.1 and 5.1, but artifact locations and formats differ.
- Runtime bootstrap metadata may reference encrypted-secret inputs, but flags are recovered from native process/log/user/port/config evidence artifacts.
- Battery/failure narrative signals are operationally relevant and should guide prioritization.

### Report and Submission

Submit all five primary flags, the reconstructed composite flag, the evidence source for each, and a brief explanation of time-management strategy under reset pressure.

### Composite Reconstruction Reference

```bash
# 1) Concatenate segments 1 through 5 in order with no separators.
FULL="<segment1><segment2><segment3><segment4><segment5>"
# 2) Decode and decompress.
echo "$FULL" | base64 -d | gunzip
# 3) Output contains the composite flag value.
```