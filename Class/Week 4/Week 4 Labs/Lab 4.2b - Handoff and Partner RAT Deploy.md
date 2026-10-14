## Purpose[](#purpose)

This lab asks you to produce a controlled `handoff` effect by transferring operational context to a notional partner team and deploying a partner-provided RAT binary with strict destination and rollback discipline.

Duration: about 2 hours.

## Lab Access Model[](#lab-access-model)

You are working from the student ops station against a simulated adversary stack. Use the range-provided values if your instructor or range card rotates any defaults.

|Role|Student-facing value|Notes|
|---|---|---|
|`red-river` / `adv-c2`|`20.30.40.150`|Primary target for foothold access, RAT deployment, and admin validation.|
|SSH foothold|`foothold@20.30.40.150:2222`|Primary access method from the ops station.|
|C2 admin panel|`http://20.30.40.150:8080/admin`|Default credentials are `admin` / `adminadmin` unless rotated.|
|`blue-lake` / collector database|`20.30.40.151`|Internal-only database; referenced in handoff posture, not a direct student pivot target.|
|`green-harbor` / analyst workstation|`20.30.40.157`|Internal analyst host; referenced in carry-over context from L4.2a.|
|Partner Bravo callback listener|`20.30.40.154:8443/tcp`|Required RAT callback destination. Use your team-segment equivalent in PCTE if assigned.|
|Student callback listener (contrast)|`20.30.40.155:9443/tcp`|Your Day 2 listener from L4.2a. Do not repoint the partner RAT here.|

### Foothold Re-Entry[](#foothold-re-entry)

Primary method: SSH key foothold on custom port `2222`.

1. From your ops station, protect the issued private key:
    
    ```
    chmod 600 ~/ops/footholds/l4.1b/adv-c2_id_ed25519
    ```
    
2. Connect to `red-river`:
    
    ```
    ssh -i ~/ops/footholds/l4.1b/adv-c2_id_ed25519 -p 2222 foothold@20.30.40.150
    ```
    
3. Validate target context before handoff and RAT tasks:
    
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

You should be able to operate a remote shell on `red-river` and reach the admin endpoint before handoff or RAT deployment.

## Operational Context[](#operational-context)

After L4.2a, you hold tracking-grade `reconnoiter` output on the adversary analyst and intact access to `red-river`. Higher has decided that continued observation is more valuable than additional CPT-run effects. The mission is shifting from CPT to a notional partner team, **Partner Bravo**, with broader collection authorities and a purpose-built toolset. Your job is to transfer the problem cleanly.

You will produce an information handoff package that enables Partner Bravo to continue operations without re-discovering the target. Partner Bravo has also provided a RAT binary (`partner_bravo_implant`) that they ask you to deploy on `red-river` and validate. The RAT calls back to a Partner-Bravo-controlled listener, not to your Day 2 listener.

Executed correctly, this turns your tactical access into persistent operational reach for a team that outmatches your authorities. Executed incorrectly, it burns the foothold, gives the adversary an implant to retask, and taints the Day 1-2 evidence trail.

## Authority[](#authority)

- Authorized effect: `handoff`.
- Authorized surfaces: produce a structured handoff package; deploy the partner-provided RAT binary into `red-river` at the brief-specified path; validate a single successful callback to the Partner Bravo listener.
- Not authorized: modifying the RAT binary; deploying it anywhere except `red-river`; pointing its callback at any destination other than the Partner Bravo listener address; continuing CPT-initiated effects against the stack after handoff is declared complete.
- Authority ceiling: RAT deployment is the hottest authorized action in Week 4. Every step of deployment must satisfy the Day 2 pre-execution four-item check: authority, destination, rollback, and predicted response. If any of the four items cannot be stated in writing, do not execute.

## Partner Bravo Details[](#partner-bravo-details)

- Team: Partner Bravo (joint element with broader collection authority and a 24/7 operations cell).
- Provided binary: `partner_bravo_implant` (instructor-supplied stub; benign in the closed environment). Runs as an unprivileged user and calls back every 5 minutes.
- Callback listener: `20.30.40.154:8443/tcp` (reachable from `red-river` over the internal net; in PCTE use the same listener role in your team-assigned segment).
- Rollback command: `kill $(pidof partner_bravo_implant); rm /opt/partner/partner_bravo_implant` — documented in the binary's README and in this brief.
- Partner sync window: 5-minute phone bridge at the end of the lab where you back-brief the package.

## Required Work[](#required-work)

1. Produce the handoff package. Fill out all six sections of the template from Lecture 4.2:
    
    - Target identity.
    - Access story.
    - Current posture, including Day 1-2 effects executed: L4.1a collection-effect rollback, L4.1b poisoning that was cleaned up overnight, L4.2a canary still in place, and similar carry-over context.
    - Adversary tempo.
    - Partner tasking.
    - Rollback plan.
2. Stage the partner RAT. Copy `partner_bravo_implant` from your lab VM to `red-river`. Place it under `/opt/partner/` with appropriate ownership. Do not execute yet.
    
3. Validate the callback destination. Independently confirm that `20.30.40.154:8443` (or your team-segment equivalent) is reachable from `red-river` (for example, `curl -k https://20.30.40.154:8443/health`) and that the Partner Bravo listener is live.
    
4. Run the four-item pre-execution check. In writing, on the handoff package itself:
    
    - Authority: statement that this brief authorizes RAT deployment to this path and this destination.
    - Destination: the confirmed listener address.
    - Rollback: the exact command sequence to remove the RAT.
    - Predicted response: what the adversary would observe if they caught the deploy or the callback.
5. Execute the deploy. Start the RAT. Confirm one successful callback to Partner Bravo's listener via an instructor-shared excerpt from that listener's log. You will not have direct access to Partner Bravo's callback log.
    
6. Prove your prior posture is preserved. Confirm your `red-river` admin shell still authenticates, the L4.2a canary is still intact and unchanged, and no unusual entries appeared in `/var/log/adv-c2/access.log` during deploy.
    
7. Deliver and back-brief. Hand the package to the instructor. Walk through the six sections in five minutes. Take feedback. Do not take any additional actions against the stack after handoff is declared complete.
    

## Constraints[](#constraints)

- Do not modify the partner binary. You can only deploy, start, and stop it.
- Do not send the callback anywhere but `20.30.40.154:8443` (or your team-segment equivalent). Repointing the RAT is instant grounds for lab failure.
- Do not deploy the RAT prior to completing and submitting the handoff package. The information package exists so that, if authority is pulled mid-deploy, Partner Bravo still has what they need.
- Do not continue CPT effects after "handoff complete" is declared. The stack is Partner Bravo's problem now.

## Evidence Expectations[](#evidence-expectations)

Submit the following to the instructor:

1. Handoff package: six-section template, complete, with the pre-execution four-item check appended.
2. Deployment evidence: `ls -la /opt/partner/`, process confirmation (`ps`), and the instructor-shared callback log excerpt from Partner Bravo.
3. Posture preservation proof: admin panel login success, canary still in place (hash unchanged), and recent `access.log` tail.
4. Five-line effect report. This lab's report is slightly extended: predicted response must name both the adversary's expected behavior and Partner Bravo's next scheduled action.
5. Back-brief: verbal, five minutes, to the instructor acting as Partner Bravo lead.

## Success Criteria[](#success-criteria)

- Handoff package includes all six sections, all four pre-execution check items, and is submitted before RAT execution.
- RAT runs at `/opt/partner/partner_bravo_implant` on `red-river`, owned by `c2-app` or equivalent unprivileged user.
- Instructor confirms one successful callback to `20.30.40.154:8443` (or your team-segment equivalent).
- `red-river` admin shell still authenticates; canary hash unchanged; no anomalous entries in `access.log`.
- Back-brief covers all six sections in the five-minute window without re-reading the document verbatim.

## Course Tie-Back[](#course-tie-back)

- Week 1: converts tactical effect into operational reach — the exploitation plan's follow-on step.
- MITRE ENGAGE: _Affect / Baseline_ for the deploy itself; _Elicit / Peer Pressure_ optional analogy on the partner ask.
- MITRE ATT&CK (partner implant side): T1071 (Application Layer Protocol) and T1105 (Ingress Tool Transfer) — recognize that the partner's tool maps to the same techniques you would hunt in blue-space.