## Purpose

This activity uses selected portions of the **Hack the Box (HTB) Academy: Corporate OSINT** module to practice public-source collection with an operational purpose. The HTB material teaches general corporate reconnaissance; in this course, you will apply those techniques to identify adversary infrastructure, attribution clues, and follow-on collection leads.

## Required HTB Work

Complete only the HTB Corporate OSINT sections assigned below:

1. [Infrastructure](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.2_OSINT/section-intros/infrastructure-section-intro/)
2. [Leaks](https://dco-counterstrike-pilot-course-content.pages.levelup.cce.af.mil/module-content/labs/L2.2_OSINT/section-intros/leaks-section-intro/)

For each assigned section, complete the HTB pages and answer all associated HTB questions. You do not need to complete unlisted Corporate OSINT sections unless an instructor directs you to do so.

## How to Use These Pages

Before starting each HTB section, read its course introduction page. These short introductions explain what to focus on in HTB and how the section supports the broader Counter-Strike Operations course.

As you work, track the evidence you collect, where it came from, and why it matters. The goal is not just to find facts; it is to turn public information into structured intelligence that can support later planning, targeting, and handoff.

---
# Infrastructure Section Introduction

## What to Do in HTB

In the **Corporate OSINT** module, complete the assigned Infrastructure section pages and answer all HTB questions for those pages. Focus on how public infrastructure records help you move from a broad organization or domain name to specific systems, services, providers, and technical leads.

## Why This Matters

Infrastructure analysis is target systems analysis for cyber operations. You are learning how to define the terrain before recommending any action against it. Domains, netblocks, DNS records, cloud providers, exposed services, and public technologies help you understand what belongs to the target, what is shared with third parties, and what deserves follow-on collection.

In this course, infrastructure findings support planning products such as SALUTE, OCOKA-W, EMLCOA, center of gravity, critical vulnerability, ATT&CK mapping, and handoff notes. A useful finding is not just "this domain exists"; it explains why that domain, service, provider, or relationship matters to the mission.

## What to Pay Attention To

As you work through HTB, capture evidence for:

- Domain registration, name servers, certificates, and DNS records.
- Netblocks, ASNs, hosting providers, and cloud services.
- Subdomains that suggest administrative panels, development systems, VPNs, mail services, storage, or staging infrastructure.
- Publicly visible technologies, frameworks, and service versions.
- Third-party dependencies that could affect attribution, access, risk, or handoff.

## Course Application

When you finish this section, you should be able to explain the target's public infrastructure in operational terms: what is known, how you know it, what remains uncertain, and which findings should drive the next collection or planning step.

---
# Leaks Section Introduction

## What to Do in HTB

In the **Corporate OSINT** module, complete the assigned Leaks section pages and answer all HTB questions for those pages. Focus on how publicly available leaks, archives, metadata, repositories, breach data, and vulnerability references can reveal attribution clues, access paths, and additional infrastructure.

## Why This Matters

Leaks expose the details that organizations and operators often did not intend to publish. Old web pages, metadata, code repositories, pasted text, breach records, and vulnerability databases can show who built a system, what tools were used, when activity occurred, and what technical weaknesses may matter later.

In this course, leaks are not just trivia. They help connect infrastructure to people, tools, timelines, and behaviors. Those connections can improve attribution confidence, identify RFIs, support ATT&CK mapping, and give the next team evidence they can verify.

## What to Pay Attention To

As you work through HTB, capture evidence for:

- Archived pages that reveal old paths, files, directories, or campaign timing.
- Pasted text, public code, or exposed configuration details.
- Metadata in documents and files, including usernames, software versions, time zones, and creation dates.
- Public repositories that reveal technologies, keys, configuration patterns, or developer habits.
- Breach and vulnerability records that help explain risk, likely access paths, or follow-on collection needs.

## Course Application

When you finish this section, you should be able to explain how leak evidence changes the picture built during infrastructure analysis. Strong answers connect a leak to a source, a confidence level, and a next step instead of treating it as an isolated fact.