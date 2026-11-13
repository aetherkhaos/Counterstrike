---
id: B04.M25-brief
title: Threat-Rep Mission Rehearsal Lab — Student Brief
artifact_type: student_brief
audience: student
block: B04
module_type: lab
legacy_aliases: []
source_status: authored
review_required: true
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---

# Build a Simulated Exploitation Range and Rehearse SOM

## Student Brief

**Phase:** Opening block (mission prep).
**Duration:** Instructor-flexible (individual build + rehearsal).
**Platform:** Shared vSphere / vCenter.

## Operational Context

You are preparing a notional counterstrike mission that depends on co-opting an
edge **redirector** to place an implant on a **Windows** target that can call
home only through that middle hop. Before live execution, build a
**threat-representative** slice of that operational environment (OE) and
**rehearse** your scheme of maneuver (SOM) / TTPs against it.

**Non-goal:** Recreating a full beacon farm, enterprise AD, or every edge
service the adversary might own.

**Goal:** Instantiate only the **critical OE elements** — Kali ops, one
vulnerable *nix redirector (choose A, B, or C), and a Windows target — then
prove whether the planned TTP survives the real path: exploit redirector →
reach Windows → place beacon → callback through the redirector to Kali.

## Access (Ops Station → Build Environment)

- **Primary method: vSphere / vCenter UI + VM Remote Console** from your ops
  station into your folder (**first name**; add last initial only if needed to
  disambiguate).

## Environment Constraints

| Constraint | Requirement |
| --- | --- |
| RAM | **≤ ~50 GB** concurrent powered-on memory in your resource pool |
| Addressing | Static hosts **only** in your assigned `/29` in **`172.16.45.0/24`** |
| DHCP half | **Do not** place static hosts in **`172.16.44.0/24`** |
| Media | Deploy from the instructor ISO catalog / thin templates only |

Gateway and DNS for the static half are posted by the instructor. Use the
block the instructor assigns from this table:

| # | Block | Usable hosts |
| --- | --- | --- |
| 1 | `172.16.45.0/29` | `172.16.45.1`–`.6` |
| 2 | `172.16.45.8/29` | `172.16.45.9`–`.14` |
| 3 | `172.16.45.16/29` | `172.16.45.17`–`.22` |
| 4 | `172.16.45.24/29` | `172.16.45.25`–`.30` |
| 5 | `172.16.45.32/29` | `172.16.45.33`–`.38` |
| 6 | `172.16.45.40/29` | `172.16.45.41`–`.46` |
| 7 | `172.16.45.48/29` | `172.16.45.49`–`.54` |
| 8 | `172.16.45.56/29` | `172.16.45.57`–`.62` |
| 9 | `172.16.45.64/29` | `172.16.45.65`–`.70` |
| 10 | `172.16.45.72/29` | `172.16.45.73`–`.78` |
| 11 | `172.16.45.80/29` | `172.16.45.81`–`.86` |
| 12 | `172.16.45.88/29` | `172.16.45.89`–`.94` |
| 13 | `172.16.45.96/29` | `172.16.45.97`–`.102` |
| 14 | `172.16.45.104/29` | `172.16.45.105`–`.110` |
| 15 | `172.16.45.112/29` | `172.16.45.113`–`.118` |
| 16 | `172.16.45.120/29` | `172.16.45.121`–`.126` |
| 17 | `172.16.45.128/29` | `172.16.45.129`–`.134` |
| 18 | `172.16.45.136/29` | `172.16.45.137`–`.142` |
| 19 | `172.16.45.144/29` | `172.16.45.145`–`.150` |
| 20 | `172.16.45.152/29` | `172.16.45.153`–`.158` |

## Notional Mission Package (FRAGO)

### Situation

Collection indicates an adversary edge path shaped like:

```text
Kali ops  --exploit-->  Vulnerable *nix redirector  --RDP/SSH-->  Windows target
                ^                                              |
                +--------- C2 beacon callback (via redirector) +
```

You will **build** that lean cell yourself as a threat-representative range:

1. **Kali ops box** — attack platform and C2 listener.
2. **One dual-homed *nix redirector** — choose Option A, B, or C below.
3. **Windows target** — on the private side of the redirector; implant placed
   via RDP or SSH; beacon must call back **through** the redirector to Kali.

Exact Windows build, endpoint security, and production redirector package
versions are only **partially known**. Document what you approximate.

### Mission

**Reconnoiter** your own plan quality by building the range and rehearsing the
path. Pair rehearsed TTPs with **ATT&CK** technique IDs; note **ENGAGE** /
**D3FEND** language you would use with blue-space partners.

Prove, through the **actual path**:

1. The chosen redirector is exploitable for RCE as designed.
2. From that foothold you can reach Windows via RDP or SSH.
3. A C2 beacon on Windows calls back **through** the redirector to Kali.
4. Which conditions make the TTP succeed, degrade, or fail.

### Access constraint (mission, not vSphere)

Do not shortcut by copying the implant onto Windows from Kali on a second
invented path. Do not add ops-facing interactive SSH on the redirector just
to make testing easier if that is not the chosen option's exploit surface.
Rehearse the access method the option inventory describes.

### Friendly constraint

Shared cluster; no egress for ISO download; stay in your IP block; preserve
enough RAM for later tool testing on the same pool. Classroom resource caps
are a training constraint — operational ceilings will differ. Document what
you could not reproduce.

## Redirector options (choose one)

Reconstruct inventory only. Build and configure from this card; do not expect
instructor exploit steps in this brief.

### Option A — Soft-edge PHP (Ubuntu)

- **Base:** Ubuntu LTS; **dual NIC** (ops-facing + private to Windows)
- **Stack:** nginx or Apache + PHP-FPM
- **Surface:** edge site vhost with a PHP health/admin endpoint that shells out from a request parameter
- **Windows:** reachable from the private NIC via RDP (OpenSSH optional)
- **After RCE:** userland forwarder (socat / nginx stream / iptables DNAT) for C2 pass-back to Kali

### Option B — Legacy CGI (Debian)

- **Base:** Debian; **dual NIC** (ops-facing + private to Windows)
- **Stack:** Apache with `cgi` / `cgid` enabled
- **Surface:** CGI status/diagnostics script that unsafely interpolates query or environment input into a shell
- **Windows:** reachable from the private NIC via RDP or SSH
- **After RCE:** same userland forwarder expectation for C2 pass-back to Kali

### Option C — Tomcat Manager / WAR (Rocky or Alma)

- **Base:** Rocky Linux or AlmaLinux; **dual NIC** (ops-facing + private to Windows)
- **Stack:** Apache Tomcat (pin a major version)
- **Surface:** Manager app enabled; `tomcat-users.xml` role/user facts for manager-script / manager-gui
- **Windows:** reachable from the private NIC via RDP or SSH
- **After RCE:** same userland forwarder expectation for C2 pass-back to Kali

## Specific Tasks

1. **OE selection:** Keep Kali, one redirector option, and Windows. Write one
   sentence of rationale per kept element, and name what you will **not**
   build (for example extra domain services or a beacon farm).
2. **Choose option:** Pick A, B, or C. Record why that stack is a fair
   threat-representative stand-in for the edge you care about.
3. **Build:** Deploy and configure the three roles in vSphere under your
   folder. Stay inside the RAM cap and your static `/29`. Dual-home the
   redirector honestly.
4. **Document live state:** Network diagram (roles + addresses), host/role +
   RAM table, snapshot plan (at least one pre-rehearsal snapshot).
5. **Rehearse:** Exploit the chosen redirector → reach Windows via RDP or SSH
   → place a beacon that calls back through the redirector to Kali. Inject at
   least one friction condition (forwarder break, RDP deny, listener mismatch,
   wrong bind address). Vary at least one bound (callback port, forwarder
   tool, Windows access method). Record predicted vs observed. Tag TTPs with
   ATT&CK IDs.
6. **AAR:** Update the plan — sequencing, prerequisites, TTP choice, and the
   **effectiveness envelope**. Explain compromises so a reader cannot treat a
   lean green callback as proof against every plausible edge stack.

## Deliverables

Submit to the instructor:

1. **OE rationale** — kept elements with plan-linked justification, plus an
   explicit cut list; state which option (A/B/C) you built and why.
2. **Network diagram** — roles and addresses in your `/29` (show dual-home).
3. **Host / role / RAM table** — powered-on memory totaling ≤ ~50 GB.
4. **Snapshot plan** — names and purpose.
5. **SOM rehearsal script** — steps executed (exploit → lateral → callback
   through redirector), ATT&CK tags, friction inject, and at least one
   bound/limit test.
6. **Rehearsal after-action** — predicted vs observed; plan deltas; **context
   and compromises** (what you approximated and how that bounds the result).

## Success Criteria

- Every powered-on VM has a plan-linked rationale (no vanity hosts).
- Concurrent RAM stays within the ~50 GB pool limit.
- All static addresses are inside the assigned upper-half block.
- Rehearsal uses the **chosen redirector exploit path** (not comfort SSH unless
  that is the option surface).
- Beacon callback **traverses the redirector** to Kali (not a direct
  Windows→Kali shortcut).
- Rehearsal includes at least one friction inject, one limits/bounds test,
  and a written plan delta.
- Compromises are documented so results can be interpreted in context.
- Doctrine terms (SOM, CG/CV, reconnoiter intent) and MITRE ATT&CK tags appear
  together in the rehearsal product.

## Tie-Back

- **Planning:** METT-TC → EMLCOA → CG/CV → SOM → rehearsal discipline.
- **MITRE ATT&CK:** Technique tags on exploit, lateral movement, and C2
  callback TTPs.
- **MITRE ENGAGE / D3FEND:** Partner-facing labels for blue-space implications
  of friction you observed (for example, edge exploitation or redirector
  inspection).
