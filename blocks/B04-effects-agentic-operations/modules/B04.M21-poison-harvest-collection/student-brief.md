---
id: B04.M21-brief
title: Poison Harvest Collection — Student Brief
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

# Poison Harvest Collection

## Student Brief

**Effect category:** `deceive` / `manipulate`.
**Duration:** About 2 hours.
**Platform:** Instructor-built Lunovia harvest cell (live continuation). Issued seats: `172.16.2.10` and `172.16.4.20`.

## Operational Context

**Mission context:** This session **continues the live harvest cell** from the prior break session — the range is **not** reset. You still hold the foothold on `172.16.2.10`. Leadership appetite has shifted from "stop them" to "poison them" — make the adversary act on **bad take** while remediation continues on the blue side. Use the prior blue reporting to make the deceptive take credible to this harvest cell. Think critically about **why this APT is collecting here**; well-chosen deceptive take informed by that motive can produce more interesting results than generic honey files.

**Foothold re-entry (ops station → remote targets):**

1. **Issued foothold (still available):** Moodle `access_key` on port 2222 to `relay@172.16.2.10`. Validate with `hostname && whoami && pwd`.

2. **Windows host (issued this session):** OpenSSH or WinRM as `svc.harvest` with password `Harvest!Relay01` to `172.16.4.20`. Validate:

   ```powershell
   hostname; whoami; pwd
   ```

**The Vantage Point:** On `172.16.4.20` you can read the harvest worker, watch inbox/outbox, and see JSON sidecars that record what the adversary **kept** vs **dropped**. That filter set is how you poison well — plant objects that survive triage or corrupt metadata the actor will trust.

**The Counter-Strike Opportunity:** Learn the collection parameters (keep-list / sidecar fields), then plant deceptive content so curated outbox packages mislead the actor. Keep the pipeline **running** — a break or outage is not today’s effect category. Craft take that fits the actor’s collection motive; precision beats volume.

## Mission Commander Guidance (Provided)

- **Command intent:** Broad `deceive` / `manipulate` against harvested evidence so adversary decisions are based on corrupted take.
- **Commander-approved battlespace:** Staging you already know on `172.16.2.10`, plus inbox/outbox and worker-visible metadata on `172.16.4.20`.
- **Commander input on methods:** Plausible office-like honey files that pass the keep filter, misleading sidecar/JSON fields, or curated-zip content shaping are on the table when they improve deception — especially when the content would matter to an actor collecting against this plant.
- **Commander red lines:** Do not destroy the pipeline (`deny`/`disrupt`/`degrade` as the primary outcome), do not wipe logs for cover, do not implant callbacks.
- **Execution expectation:** Log every planted object in plaintext for reconstruction.

## Specific Tasks

1. Re-enter both issued seats. Validate hostname, user, and working directory on each.
2. **Learn the filters.** On `172.16.4.20`, inspect the harvest worker and recent outbox JSON. Record:
   - Which extensions or object types are kept vs dropped.
   - Which sidecar fields (name, size, sha256, notes) an analyst would trust.
3. Baseline one curated package (or sidecar) before you plant anything.
4. Design at least two poison patterns that respect the keep filter (or intentionally exercise a drop path only if you can still show a deceive effect in kept metadata). Examples to consider:
   - Plausible office filenames that seed false attribution.
   - Misleading size/hash/note fields in a sidecar you can influence.
   - Content inside a kept office-like object that would mislead an analyst reading the take.
5. Plant the poison so it progresses through triage into outbox (or clearly appears in `kept` metadata).
6. Validate: show poisoned objects in outbox/sidecar evidence. Confirm legitimate collection still ticks.
7. Write the five-line effect report (effect, action, predicted response, observed result, burn-risk reassessment).

## Constraints and Rules of Engagement

- **Preserve the pipeline.** If you stop collection, you produced a break effect, not poison — grade fails the deceive/manipulate criteria.
- **Bounded volume.** Do not plant more than 50 honey objects. Precision over flood.
- **Log your payloads.** Every planted name and intended deceive effect must appear in the report.

## Deliverables

1. **Filter map** — keep vs drop rules and sidecar fields you used.
2. **Poison inventory** — what you planted and why each survives (or shapes) triage.
3. **Before/after evidence** — outbox listing and/or JSON excerpts showing poison landed; proof pipeline still ticks.
4. **Five-line effect report** — names `deceive` or `manipulate`.

## Success Criteria

- At least two poisoned objects or metadata effects visible in outbox/sidecar evidence.
- Pipeline still functional (new legitimate activity continues).
- Effect report correctly names `deceive` or `manipulate`, not break vocabulary.
- You used the issued seat on `172.16.4.20` to learn filters before planting.

## Constraints

- Stay on `172.16.2.10` and `172.16.4.20`.
- Do not target classmate ranges.
- Do not require a local hypervisor replica for this session.
- Do not target `10.10.0.0/16` — PCTE control range; off limits.
- Do not use accounts named `simspace` or `simspace management` (any capitalization or spacing variants if encountered).
- If the password `Simspace1!Simspace1!` is found, do not use it to gain or expand access in any way.
