## Purpose[](#purpose)

This lab asks you to produce a controlled `deceive` or `manipulate` effect by poisoning the adversary's collection evidence. The goal is to influence adversary analysis while keeping the exfil pipeline functional.

Duration: about 2 hours.

## Lab Access Model

You are working from the student ops station against a simulated adversary stack. Use the range-provided values if your instructor or range card rotates any defaults.

|Role|Student-facing value|Notes|
|---|---|---|
|`red-river` / `adv-c2`|`20.30.40.150`|Primary target for foothold access and C2 administration.|
|SSH foothold|`foothold@20.30.40.150:2222`|Primary access method from the ops station.|
|C2 admin panel|`http://20.30.40.150:8080/admin`|Default credentials are `admin` / `adminadmin` unless rotated.|
|`blue-lake` / collector database|`20.30.40.151`|Internal-only database; reach it from the `red-river` shell using credentials discovered in `/opt/c2/config.yaml`.|
|`amber-bay` / exfil agent|`20.30.40.156`|Expected source for legitimate exfil activity. Do not pivot to it.|

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
    
3. Validate target context before poisoning actions:
    
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

You should be able to operate a remote shell on `red-river` and reach the admin endpoint before attempting poisoning actions.

## Operational Context

After L4.1a's disable-rollback demonstration, the adversary's exfil pipeline has been re-enabled. You still hold the admin foothold on `red-river`. Command appetite has shifted from "stop them" to "poison them": leadership now wants the adversary to act on bad intelligence while remediation completes on the blue side.

From `red-river`, you can observe artifacts landing in `/opt/staging/incoming/` before they are drained into `blue-lake.exfil_logs`. You have read/write access to that staging directory as the `red-river` application user, and you can reach the collector database directly with the credentials in `/opt/c2/config.yaml`. The adversary analyst consumes this database via a viewer script on `green-harbor`, which is out of scope for this lab.

The database ingestion process is not parameterized. It uses raw string concatenation to insert filename and metadata fields into `exfil_logs`. Blue-space hunters who reviewed `/opt/staging/incoming/` samples noticed that file names containing SQL meta-characters cause ingestion errors in the adversary's analytics step. That is your opening.

This builds directly on the Week 2 L2.8 SQL injection tradecraft, applied in the opposite direction: you are the injector, and the adversary's backend is the target. Reference: [Lab 2.8 Box A Student Brief](/dco-counterstrike-pilot-course-content/module-content/main/../../../../week2/labs/L2.8_Gaining_Access/Lab%202.8%20Box%20A%20Student%20Brief.md).

## Mission Commander Guidance

- Command intent: produce a broad `deceive` or `manipulate` effect so adversary decisions are based on corrupted evidence, not a service outage.
- Commander-approved battlespace: operate across `/opt/staging/incoming/` and `blue-lake.exfil_logs` to plant and shape deceptive records.
- Commander input on methods: honey-files, metadata shaping, and controlled SQL-bearing filename payloads are all on the table when they improve deception outcomes.
- Commander red lines: do not destroy target capability with `DROP`, `TRUNCATE`, destructive `DELETE`, or full service kill; do not modify schema; do not pivot to `green-harbor`; and do not implant callbacks.
- Execution expectation: team leads choose the specific technique mix and tempo inside this guidance and record exactly what was injected for later reconstruction.

## Required Work

1. Recon the ingestion path. Read `/opt/c2/config.yaml` and whichever script or cron handles the drain from `/opt/staging/incoming/` into `exfil_logs`. Identify exactly which metadata fields are string-concatenated into the `INSERT`.
    
2. Baseline the adversary analytics query. Confirm the row shape and typical values with:
    
    ```
    SELECT filename, size_bytes, sha256, source_host, ingested_at
    FROM exfil_logs ORDER BY ingested_at DESC LIMIT 10;
    ```
    
3. Design honey-files. Pick at least two patterns. Examples to consider:
    
    - Plausible-looking filenames that seed false attribution, such as `TOP-SECRET-meeting-notes-2026-04-20.docx` or `creds_dump_partner_alpha.txt`.
    - Filenames that trigger aggregation misreporting, such as null bytes, unicode confusables, or extremely large synthetic `size_bytes`.
    - Filenames that carry a SQL payload targeting the unparameterized `INSERT` when that improves the deception effect and stays inside commander red lines.
4. Plant the honey-files in `/opt/staging/incoming/` with appropriate size/hash metadata if required by the drain script.
    
5. Validate ingestion. Confirm your poisoned rows landed in `exfil_logs` and, for aggregation corruption, show the before/after numbers on at least one summary query, such as row count per `source_host` or total size exfiltrated today.
    
6. Write the five-line effect report per the 4.1 lecture cadence.
    

## Constraints

- Preserve the pipeline. The exfil pipeline must still be running end-to-end after your action. The goal is poisoning, not outage. If you break ingestion, you have produced a `deny`, `disrupt`, `degrade`, or `destroy` effect on collection, not a `deceive` or `manipulate` effect, and will be graded accordingly.
- Do not use `DROP`, `TRUNCATE`, or `DELETE` without a `WHERE ingested_at > <timestamp_of_your_injection>` clause.
- Do not plant more than 50 honey-files. Goal is precision, not flood.
- Log your payloads. Every honey-filename and every SQL-bearing string you plant must appear in the effect report, in plaintext, so command can reconstruct what is real and what is yours.

## Evidence Expectations

Submit the following to the instructor:

1. Ingestion-path map: which process drains `/opt/staging/incoming/`, which fields are string-concatenated into the `INSERT`, and what the baseline row shape looks like.
2. Honey-file inventory: filenames planted, the effect each is designed to produce, and whether each required a SQL payload.
3. Before/after analytics snapshot: one query demonstrating the corruption, such as row count per `source_host`, total exfil volume, or a similar metric.
4. Five-line effect report: effect, action, predicted adversary response, observed result, and burn-risk reassessment.

## Success Criteria

- At least two poisoned rows are visible in `exfil_logs` with values that would mislead an adversary analyst.
- At least one aggregation query result is materially wrong because of your rows.
- The pipeline remains functional, with new legitimate rows from `amber-bay` continuing to land.
- The effect report correctly names the effect as `deceive` or `manipulate`, not `deny`, `disrupt`, `degrade`, or `destroy`.

## Course Tie-Back

- Week 1 CG/CV: attacks the adversary's decision cycle by corrupting the evidence base their EMLCOA is built on.
- Week 2 L2.8: reuses the SQLi payload shape in the opposite direction, with you as the injector and their backend as the target.
- MITRE ENGAGE: _Affect / Introduce Decoy Artifacts_, and optionally _Affect / Analytic Poisoning_.
- MITRE D3FEND: no direct D3FEND tile; the ENGAGE mapping is primary here.