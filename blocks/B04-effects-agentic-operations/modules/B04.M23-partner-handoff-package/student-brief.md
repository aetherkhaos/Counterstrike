---
id: B04.M23-brief
title: Partner Handoff Package — Student Brief
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

# Partner Handoff Package

## Student Brief

**Effect category:** `handoff` (information handoff, plus one staged C2 beacon).
**Duration:** About 1 hour.
**Platform:** Live Lunovia harvest cell continuation. Issued seats: `172.16.2.10` and `172.16.4.20`.

## Operational Context

**Mission context:** After handoff doctrine, the Mission Commander places **all further effects under consideration**. Execution of new effects is **on hold** for political reasons. Your job is to produce a **quality partner handoff package** and to **stage one C2 beacon** on a host you already hold, so another team can pick up from your current posture and use the beacon you left behind without re-discovering access or guessing what you already changed.

This session **continues the live harvest cell** from the prior break and poison work. The range is **not** reset. Document what you actually hold and what you actually did.

**Foothold re-entry (ops station → remote targets):**

1. **Issued foothold:** Moodle `access_key` on port `2222` to `relay@172.16.2.10`. Validate with `hostname && whoami && pwd`.

2. **Windows host (if still issued / still held):** OpenSSH or WinRM as `svc.harvest` with password `Harvest!Relay01` to `172.16.4.20`. Validate:

   ```powershell
   hostname; whoami; pwd
   ```

If you earned additional access earlier, document it in the package — do not invent seats you cannot re-enter and prove.

**The Vantage Point:** A partner team must continue without your tribal knowledge. Incomplete access stories, missing rollback steps, a beacon with no way to run or task it, or vague posture notes burn time and can burn the seat.

**The Counter-Strike Opportunity:** Clean information handoff turns tactical access into operational continuity for a follow-on element. Dirty handoff forces rediscovery under political pause — often after the window has closed.

## Authority (Notional)

- **Authorized effect:** `handoff` — produce and back-brief the six-section package, and stage **one** C2 beacon on **one** host you already hold.
- **Authorized surfaces:** Re-validate issued (and previously earned) access long enough to confirm facts for the package. Place one beacon file on that host. Record recommended next effects as **partner tasking**, not as actions you execute today. A live check-in is **not** required. If you start the beacon, say so in current posture. If you only stage the file, the package must still tell a partner how to start and task it.
- **Not authorized:** New `deny` / `degrade` / `disrupt` / `deceive` / `manipulate` execution, a second implant, or a beacon on a host you cannot re-enter and prove. Do not log into hosts you cannot justify from your evidence trail.
- **Authority ceiling:** Any effect execution beyond this one staged beacon needs an explicit verbal go from the instructor acting as Mission Commander.

## Specific Tasks

1. Re-enter each seat you claim to hold. Validate hostname, user, and working directory.
2. **Produce the handoff package.** Complete all six sections of the Access Guide:

   1. **Target identity** — hosts, roles, addressing you can prove.
   2. **Access story** — exact path (keys, ports, users, leftover surfaces if used), how a partner re-enters.
   3. **Current posture** — effects already executed or still in place; what remains intact; what is damaged or dirty. State whether the beacon is staged only or already running.
   4. **Adversary tempo** — collection cadence and other tempo you observed (what moves, how often, what evidence proves it).
   5. **Partner tasking** — recommended next effects or investigations **not** to execute now; why they matter under the political hold.
   6. **Rollback plan** — how to reverse live changes, remove the beacon, and restore usable seats without guessing.

3. **Stage one C2 beacon** on one host you already hold and can re-enter. In the package, name that host and explain why it is the right place for a beacon: its role, reach, user context, or place in the collection path. A generic preference is not enough.
4. **Leave the beacon file in place.** The handoff package must contain every file and fact a cold partner needs to use that beacon without you: the binary, its config, listener or callback, on-host path, account, start steps, tasking steps, and removal.
5. Confirm your issued footholds still authenticate after you finish documenting.
6. **Deliver and back-brief.** Hand the package to the instructor. Walk the six sections and the beacon handoff in five minutes as if briefing a partner lead. Do **not** execute further effects after handoff is declared complete.

## Deliverables

Submit to the instructor:

1. **Handoff package** — all six sections complete and specific enough for a cold partner to operate, including the beacon host, why you chose it, and every file and fact needed to start, task, and remove the beacon you left behind.
2. **Staged beacon** — one beacon file on the host you chose, still in place at handoff.
3. **Access confirmation** — evidence you re-entered each claimed seat (hostname / whoami / pwd or equivalent).
4. **Five-line effect report** — names `handoff`; predicted response must cover both adversary risk if the package is wrong and the partner’s first scheduled action after the hold lifts.
5. **Back-brief** — verbal, five minutes, to the instructor acting as partner lead.

## Success Criteria

- Package includes all six sections with concrete access path and posture (not placeholders).
- Partner could re-enter claimed seats from the written access story alone.
- One beacon is staged on a host you already hold. The package names that host and explains why it is the right place for a beacon.
- A cold partner could start, task, and remove that beacon from the package alone (binary, config, listener or callback, path, account, start steps, tasking steps, and removal). A live check-in is not required.
- No other new effect execution occurred during this session (unless the instructor gave an explicit go).
- Issued footholds still work after documentation (or burn is documented honestly).
- Back-brief covers all six sections and the beacon handoff in five minutes without reading the document verbatim.

## Constraints

- Stay on `172.16.2.10` and `172.16.4.20` unless you previously earned and can still justify another seat from evidence. Stage the beacon only on a seat you hold and can still prove.
- Do not target classmate ranges.
- Do not execute new effects while the political hold is in force. Staging this one beacon is the authorized exception. A live check-in is not required.
- Do not target `10.10.0.0/16` — PCTE control range; off limits.
- Do not use accounts named `simspace` or `simspace management` (any capitalization or spacing variants if encountered).
- If the password `Simspace1!Simspace1!` is found, do not use it to gain or expand access in any way.
