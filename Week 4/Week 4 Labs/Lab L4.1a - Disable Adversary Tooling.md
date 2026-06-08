## Purpose

This lab asks you to produce a controlled `degrade`, `disrupt`, or `deny` effect against an adversary collection pipeline while preserving access for follow-on operations. Reversible actions are preferred; `destroy` effects require explicit instructor approval.

Duration: about 2.5 hours.

## Lab Access Model

You are working from the student ops station against a simulated adversary stack. Use the range-provided values if your instructor or range card rotates any defaults.

|Role|Student-facing value|Notes|
|---|---|---|
|`red-river` / `adv-c2`|`20.30.40.150`|Primary target for foothold access and C2 administration.|
|SSH foothold|`foothold@20.30.40.150:2222`|Primary access method from the ops station.|
|C2 admin panel|`http://20.30.40.150:8080/admin`|Default credentials are `admin` / `adminadmin` unless rotated.|
|`blue-lake` / collector database|`20.30.40.151`|Internal-only database; reach it from the `red-river` shell using credentials discovered in `/opt/c2/config.yaml`.|
|`amber-bay` / exfil agent|`20.30.40.156`|You should see this source in `red-river` access logs. Do not pivot to it.|

### Foothold Re-Entry

Primary method: SSH key foothold on custom port `2222`.

1. From your ops station, protect the issued private key:
    
    ```
    chmod 600 ~/ops/footholds/l4.1a/adv-c2_id_ed25519
    ```
    
2. Connect to `red-river`:
    
    ```
    ssh -i ~/ops/footholds/l4.1a/adv-c2_id_ed25519 -p 2222 foothold@20.30.40.150
    ```
    
3. Validate target context before tasking:
    
    ```
    hostname && whoami && pwd
    ```
    
4. From the same ops station, validate C2 admin visibility:
    
    ```
    curl -u admin:adminadmin http://20.30.40.150:8080/admin
    ```
    

Allowed fallback methods, only if SSH is unavailable:

- Authenticated web-shell route through `/admin/exec` using issued operator credentials.
- Listening raw shell callback to your ops station listener, triggered through the approved web-shell route.

You should be able to operate a remote shell on `red-river` and reach the admin endpoint before attempting effects.

## Operational Context

Your team is holding pre-staged foothold access on an adversary Command-and-Control node, `red-river`. The host was discovered at the tail end of Week 3 hunting operations. A hunt team has already confirmed that it is the collection head for an active exfil campaign targeting a partner network.

From `red-river`, you can reach the internal collector database, `blue-lake`, and observe the exfil agent's inbound traffic in `/var/log/adv-c2/access.log`. You cannot and should not pivot outward to the compromised blue host where `amber-bay` is simulated.

Yesterday's hunt leadership has tasked your team to degrade, disrupt, or deny the adversary's collection pipeline for at least the next 48 hours. The partner team needs that window to complete remediation on the blue side. Speed matters less than cleanliness: the adversary must not easily re-stand the capability, and your access to `red-river` must be preserved for the rest of the week's labs.

## Authority

- Authorized effect: `degrade`, `disrupt`, or `deny` the exfil collection pipeline. Reversible paths are preferred.
- Authorized surfaces: `red-river` services, scheduled tasks under `red-river`, and data paths under `/opt/c2/` and `/opt/staging/`.
- Not authorized: destruction of log evidence, modification of `blue-lake` schema or rows, deployment of implants or callbacks, or anything touching `green-harbor`.
- Authority ceiling: any action outside the above requires verbal approval from the instructor acting as Mission Commander.

## Required Work

1. Enumerate `red-river` from your remote foothold shell. Produce a short inventory of:
    
    - Services and processes supporting the exfil ingestion endpoints.
    - Scheduled execution, such as cron or systemd timers, that moves incoming artifacts into the collector database.
    - Credential(s) the exfil agent is authenticating with against `/exfil` or `/beacon`.
2. Observe the live exfil cadence in `/var/log/adv-c2/access.log` for at least two agent cycles so you can establish a baseline.
    
3. Select a collection effect action that satisfies the authority above. Plot it on the burn-risk / reversibility matrix from Lecture 4.1.
    
4. Execute the action. Validate by:
    
    - Waiting at least one full exfil agent cycle and confirming no new rows in `exfil_logs` and no new hits in `access.log` from the agent.
    - Recording any side effects to operator access, such as whether the `red-river` web admin panel still responds, and explaining how that affects burn risk.
5. Write the five-line effect report per the 4.1 lecture cadence: effect, action, predicted response, observed result, burn-risk reassessment.
    

## Commander's Guidance

For this lab, reversible `degrade`, `disrupt`, or `deny` actions are preferred.

## Evidence Expectations

Submit the following to the instructor:

1. Enumeration summary: a table of processes, timers, and credentials that support collection, plus one paragraph of narrative.
2. Burn-risk / reversibility placement: one-paragraph justification of why your chosen action sits where it does on the 2x2 matrix.
3. Five-line effect report: effect, action, predicted adversary response, observed result, and burn-risk reassessment.
4. Validation log: an `access.log` excerpt or `exfil_logs` query result showing the agent's cadence before and after your action.

## Success Criteria

- `exfil_logs` shows zero new rows for at least one full exfil agent cycle after execution.
- `/var/log/adv-c2/access.log` shows the agent's POST attempts being refused, not absent. Silence is ambiguous; a `401`, `403`, or `503` proves your action is the cause.
- If your action impacts the `red-river` admin panel, your report clearly explains that tradeoff and whether the effect remains within authority.
- The effect report names the doctrinal effect, such as `degrade`, `disrupt`, `deny`, or `destroy`, spelled exactly as authorized in Lecture 4.1.

## Course Tie-Back

- Week 1 CG/CV: this lab attacks the adversary's center of gravity, the collection pipeline, by removing its critical vulnerability: a reachable ingestion path.
- MITRE ENGAGE: _Affect / Disable_.
- MITRE D3FEND: _Evict / Credential Revoking_ or _Evict / Process Termination_, depending on the action chosen.