---
id: B02.M16-brief
title: Web-to-SQL Group Exercise — Student Brief
artifact_type: student_brief
audience: student
block: B02
module_type: group_activity
source_status: canonical
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_brief_v1
sensitivity: course_internal
---

# Student Brief: Web-to-SQL Group Exercise — Web Tier to Database Tier Compromise

## Activity Overview

This is a team-based lab chaining a web-application compromise into full
compromise of a backend database host, including local privilege escalation
to root. It draws directly on skills from earlier labs: SQL injection
fundamentals, gaining access via file upload, and tunneling/pivoting into
segments you cannot reach directly. This is the Block group activity. If the team finishes with time remaining, the instructor may offer an optional Hack The Box skills assessment.

## Operational Context

Your team has been given access to the external-facing network segment
hosting a custom web application. Your objective is to determine whether
that application's exposure can be leveraged into deeper network access —
specifically, whatever backend infrastructure supports it — and to fully
document that access chain for the engagement report.

You are not told in advance what is vulnerable, what credentials exist, or
what lies behind the web tier. Discovering that is the point of the exercise.

**Flags:** Three proof markers sit along the chain: one on the web-tier host
after you have code execution, one on the database-tier host as the service
account that first gets a shell, and one on that same host after you reach
root. Finding them is not the objective by itself — they mark progress along
the access chain you are building and documenting.

## Starting Point

| Setting | Value |
| --- | --- |
| Starting position | PCTE live-action range; positioned as if coming from the internet |
| Known information | Website IP `200.200.200.1` |

At the start of this scenario, we only know the website IP: `200.200.200.1`. We
are positioned as if we were coming from the internet.

Validate the IP is reachable:

```bash
nmap -sn 200.200.200.1
```

Backend addressing is discovered during the engagement, not given at start.

## Suggested Tools

- `nmap` for host discovery and service enumeration
- A browser or `curl`, plus an intercepting proxy (e.g., Burp Suite) for
  testing the login workflow
- A PHP-capable web shell / lightweight post-exploitation client (use one
  your team is already comfortable with)
- A TCP/SOCKS tunneling tool and `proxychains` (or equivalent) for reaching
  segments not directly routable from your position
- Standard Linux host-enumeration tools once you have a foothold on the
  database tier

Chisel and Godzilla are already staged on the ops station if you want to
learn or play with them. They are optional — use a webshell or tunnel your
team already knows if you prefer.

- Chisel: `/opt/chisel`
- Godzilla: `/opt/gozilla`

## Working Expectations

- Confirm `200.200.200.1` is reachable from the live-action range before starting.
- Track every credential, file, and command output you rely on as evidence.
- When a request fails, read the error message before trying something else
  — this lab rewards paying attention to what the application tells you.
- Avoid guessing your way through low- and medium-effort phases (e.g.,
  authentication testing, service enumeration); each step should follow from
  evidence you already collected.
- If your team is stuck for an extended period, flag it to your instructor —
  guiding hints are available if your team is falling behind.

## Deliverables

- A summary of the full access chain, tier by tier.
- The key evidence supporting each transition (commands, output, discovered
  credentials/config, and how you found them).
- All three flags (web host, database host as the service account, database
  host as root), with the command/output used to retrieve each.
- Proof of final access level obtained on the database tier (e.g., `id`,
  `hostname`, `whoami` output).
- A short note on the most important lesson your team took from the chain —
  especially anywhere a defensive control (or its absence) mattered.

## Success Criteria

- Your team obtains an interactive shell on the database-tier host at the
  highest privilege level available.
- All three flags are captured and included in your submission.
- The full chain from initial web access to final privilege is documented
  and defensible — another operator could follow it from your notes.

## Tie-Back

- **Authentication bypass and web foothold:** Use the login path to get
  code execution on the web tier.
- **Pivot / tunnel:** Reach a segment your attacker position cannot route
  to directly.
- **General methodology:** Enumerate before acting, and treat local
  privilege escalation as its own investigation, not an assumed outcome.
