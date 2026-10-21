## Purpose

This lab asks you to produce a controlled `reconnoiter` effect by characterizing the adversary processing pipeline, standing up callback telemetry, and staging an instructor-approved plant artifact. Your output is tracking-grade evidence about adversary analyst workstation behavior.

Duration: about 2.75 hours.

## Lab Access Model

You are working from the student ops station against a simulated adversary stack. Use the range-provided values if your instructor or range card rotates any defaults.

| Role                                 | Student-facing value             | Notes                                                                                                                     |
| ------------------------------------ | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `red-river` / `adv-c2`               | `20.30.40.150`                   | Primary target for foothold access and C2 administration.                                                                 |
| SSH foothold                         | `foothold@20.30.40.160:2222`     | Primary access method from the ops station.                                                                               |
| C2 admin panel                       | `http://20.30.40.150:8080/admin` | Default credentials are `admin` / `adminadmin` unless rotated.                                                            |
| `blue-lake` / collector database     | `20.30.40.151`                   | Internal-only database; reach it from the `red-river` shell using credentials discovered in `/opt/c2/config.yaml`.        |
| `amber-bay` / exfil agent            | `20.30.40.156`                   | Expected source for legitimate exfil activity in `red-river` access logs. Do not pivot to it.                             |
| `green-harbor` / analyst workstation | `20.30.40.157`                   | Internal analyst host; you observe its behavior through pipeline and callback evidence. Do not run additional code there. |
| Student callback listener            | `20.30.40.155:9443/tcp`          | Stand up your listener on this address, or your team-segment equivalent in PCTE.                                          |

### Foothold Re-Entry

Primary method: SSH key foothold on custom port `2222`.

1. From your ops station, protect the issued private key:
    
    ```
    chmod 600 ~/ops/footholds/l4.1b/adv-c2_id_ed25519
    ```
    
2. Connect to `red-river`:
    
    ```
    ssh -i ~/ops/footholds/l4.1b/adv-c2_id_ed25519 -p 2222 foothold@20.30.40.150
    ```
    
3. Validate target context before analysis and plant staging:
    
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

You should be able to operate a remote shell on `red-river` and reach the admin endpoint before attempting reconnaissance or plant staging.

## Operational Context

You retain Day 1 access to `red-river`. In this lab, your job is to derive plant requirements by analyzing adversary pipeline behavior, then execute with an instructor-provided plant once your requirement analysis is approved.

From `red-river`, you can analyze drain logic, staging paths such as `/opt/staging/incoming/`, and configuration under `/opt/c2/`. Artifacts that route to analyst review are consumed on `green-harbor`, which is out of direct student scope for this lab.

## Authority

- Authorized effect: `reconnoiter` — characterize the processing pipeline and collect callback telemetry from analyst-station interaction.
- Authorized surfaces: adversary scripts and configs on `red-river`; `/opt/staging/incoming/`; student listener endpoint on `20.30.40.155:9443/tcp` (or team equivalent in PCTE).
- Not authorized: modifying adversary processing scripts, bypassing instructor review, or running additional code on `green-harbor`.

## Required Work

1. Map the processing path. Identify how artifacts move from exfil collection through C2 drain logic into analyst review.
    
2. Determine requirements for the plant. From script analysis, extract the exact characteristics a valid plant must meet:
    
    - Filename format: `timestamp_origFileName.origExt_hostname_exfilHostname_CATEGORY.b64`
    - Payload format: original content is gzip-compressed, then base64-encoded
    - Category handling: identify category allowlist behavior and which category routes to analyst review
    - REVIEW path transforms: identify where decode and decompress occur before analyst open
    - Sanitization edge case: identify the tracking-pixel strip logic and its markdown gap
3. Stand up callback listener. On `20.30.40.155:9443/tcp` (or your team equivalent), run a listener that records source IP, path, headers, and timestamps.
    
4. Stage approved plant artifact. After instructor review of your requirement list, stage the provided artifact in `/opt/staging/incoming/` without renaming.
    
5. Collect and correlate telemetry. Record callback evidence and correlate with analyst tracking indicators.
    
6. Report effect. Submit the five-line effect report plus a short tracking note.
    

## Evidence Expectations

Submit the following to the instructor:

1. Pipeline requirements sheet listing all required plant characteristics discovered from code.
2. Evidence log with commands and output snippets showing where each requirement was derived.
3. Callback evidence from analyst open: timestamp, source IP, headers, and path.
4. Tracking analysis note correlating callback telemetry to instructor-provided lookup context.
5. Five-line effect report naming the effect as `reconnoiter`.

## Success Criteria
- Requirement sheet correctly identifies filename, encoding, category, and REVIEW decode/decompress behavior.
- Requirement sheet correctly identifies the image-strip bug: HTML tag stripping only; markdown image syntax persists.
- Staged artifact is ingested and routed to analyst review without student-side pipeline edits.
- Callback telemetry is captured and tied to analyst workstation behavior.

## Course Tie-Back

- Week 1 CG/CV: converts pipeline understanding into actionable intelligence about adversary analyst behavior.
- MITRE ENGAGE: _Affect / Baseline_ and related reconnaissance-oriented effect framing from Lecture 4.2.