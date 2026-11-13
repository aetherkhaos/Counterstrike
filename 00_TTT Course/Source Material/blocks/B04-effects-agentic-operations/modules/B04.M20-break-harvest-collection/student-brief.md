---
id: B04.M20-brief
title: Break Harvest Collection — Student Brief
artifact_type: student_brief
audience: student
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---

# Break Harvest Collection

## Student Brief

**Effect category:** `degrade` / `disrupt` / `deny` (reversible preferred).
**Duration:** About 2.5 hours.
**Platform:** Instructor-built harvest cell. Issued foothold: `relay@172.16.2.10` on port `2222` (Moodle `access_key`).

## Operational Context

**Blue Team Handoff (prior DCO cell).** The prior cell supported DCO at Lunovia’s regional power generation plant during a review of blackstart readiness. Engineering partners were exchanging revised islanding studies, creating a steady flow of documents through the defended network. Available reporting suggests the APT wants to understand regional generation dependencies; an intercepted tasking reference to an N-1 assessment supports that judgment.

A defended host was observed sending mail-shaped traffic toward `172.16.2.10`. The cell recovered an SSH private key and validated access as `relay` on port `2222`; Moodle issues that key as `access_key`. A leftover web admin surface appeared capable of command execution, but the cell did not evaluate it.

Take the seat, map how collection moves, and break it cleanly while preserving access for later work. Hunt leadership wants the collection broken for a remediation window — speed matters less than cleanliness.

**Foothold re-entry path (ops station → remote target):**

1. **SSH key foothold on custom port 2222.** Download the private key named `access_key` from Moodle, place it on your ops station, then:

   ```bash
   chmod 600 access_key
   ssh -i access_key -p 2222 relay@172.16.2.10
   ```

   If you saved the file somewhere other than your current directory, pass that full path to both commands.

2. Validate target context before tasking:

   ```bash
   hostname && whoami && pwd
   ```

**The Vantage Point:** From this seat you can see staging, schedules, leftover configs, and logs that show how objects move. Watch long enough to see objects appear or leave. Peer connections and access logs may reveal more of the collection path. You are authorized against collection you can reach from this foothold **and any further access justified by evidence you discover**. Do not invent logins to unpublished addresses.

**The Counter-Strike Opportunity:** Map how collection occurs end-to-end from what you can see, then achieve a solid **degrade, disrupt, or deny** against that pipeline long enough that new partner take stops moving. Prefer reversible actions that leave your issued foothold intact.

## Authority (Notional)

- **Authorized effect:** `degrade` / `disrupt` / `deny` against the harvest collection path you can reach from this seat (and any further access justified by evidence on the cell).
- **Authorized surfaces:** services, schedules, and data paths under `/srv/relay/` and related configs on the issued seat; any further access you earn from discoverable evidence, used to stop collection.
- **Not authorized:** Destruction of log evidence, permanent key wipe without instructor go, implants/callbacks, logging into a host you cannot justify from evidence on the issued seat.
- **Authority ceiling:** Anything outside the above needs a verbal go from the instructor acting as Mission Commander.

## Specific Tasks

1. Re-enter the issued foothold. Validate hostname, user, and working directory.
2. Enumerate how collection is occurring. Produce a short inventory of:
   - Processes / services that accept or stage harvest objects.
   - Scheduled execution that moves or encrypts staged objects.
   - Evidence of how objects leave staging (connections, logs, clearing cadence).
3. Observe live cadence long enough to establish a baseline (objects appear or leave staging without you planting them).
4. Select a collection effect that satisfies the authority above. Prefer reversible `degrade` / `disrupt` / `deny`.
5. Execute the action. Validate by waiting at least one collection cycle and showing that new take stops progressing (evidence you can prove from your seats).
6. Write the five-line effect report (effect, action, predicted response, observed result, burn-risk reassessment). Note whether the issued foothold still works.

## Commander's Guidance

- For this lab, reversible **degrade/disrupt/deny** actions are preferred.
- Preserve the issued foothold for later work.

## Deliverables

Submit to the instructor:

1. **Enumeration summary** — how collection works from your evidence; processes / timers / configs; any further access you earned and how.
2. **Burn-risk / reversibility note** — one paragraph on why your action sits where it does.
3. **Five-line effect report** — effect, action, predicted adversary response, observed result, burn-risk reassessment.
4. **Validation log** — before/after evidence that collection stopped progressing.

## Success Criteria

- You mapped the collection path from the issued foothold with concrete evidence.
- After your action, at least one full cycle shows collection stopped or clearly failed (not mere silence without a cause you can name).
- The effect report names `degrade`, `disrupt`, or `deny` exactly.
- The issued foothold still works after the effect (or you document the burn tradeoff).
- You did not require instructor-issued Windows credentials for this session.

## Constraints

- Start from the issued foothold at `172.16.2.10`.
- Do not target classmate ranges.
- Do not invent logins to hosts you cannot justify from evidence on the issued seat.
- Do not target `10.10.0.0/16` — PCTE control range; off limits.
- Do not use accounts named `simspace` or `simspace management` (any capitalization or spacing variants if encountered).
- If the password `Simspace1!Simspace1!` is found, do not use it to gain or expand access in any way.
