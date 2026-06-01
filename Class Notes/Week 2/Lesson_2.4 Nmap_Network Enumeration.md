## Purpose

This activity uses the **Hack The Box (HTB) Nmap** material to practice disciplined network enumeration. Nmap is a network analysis and security auditing tool that can discover live hosts, identify open ports, enumerate services, detect operating-system clues, and interact with services through the Nmap Scripting Engine (NSE).

In this course, the goal is not to run scans for their own sake. You are learning how to turn an assigned target IP into evidence: what is reachable, which services are exposed, what those services reveal, and which findings should drive the next planning or handoff step.

## Lab Access Model

Work from the HTB-provided lab environment or the attack host approved by your instructor. Your target will be provided through HTB or by your instructor.

Do not scan systems outside the assigned HTB target or instructor-provided scope.

Pro tip: each student may receive a different target IP, and HTB may assign a new IP if you return to the lab later. To avoid accidentally reusing an old address, set a shell variable at the start of each work session and confirm it before running scans:

```bash
export TGT=<assigned_target_ip>
echo "$TGT"
```

Replace `<assigned_target_ip>` with the current target shown in HTB or provided by your instructor.

## Required HTB Work

Complete the assigned HTB Nmap pages and answer all associated HTB questions for the task areas below. If a page or task is not tied to one of these areas, treat it as reference material unless your instructor directs otherwise.

## What to Focus On

### 1. Host Discovery and Network Range Scanning

Determine whether systems are online before spending time on deeper enumeration. Pay attention to how ICMP, ARP, and firewall behavior can affect whether Nmap marks a host as up or down.

Course application: host discovery supports basic target identification and helps you avoid building a plan from incomplete assumptions.

### 2. TCP and UDP Port Scanning

Use port scans to determine which services are reachable. Understand the difference between scan types such as TCP SYN scans and TCP connect scans, and recognize when accuracy, speed, and noise matter.

Course application: open ports define the first layer of observable terrain. They help identify likely service roles and follow-on collection priorities.

### 3. Saving Results and Reporting

Save scan output in reusable formats, especially when HTB tasks require reporting or later comparison. Use structured output so teammates and instructors can review your evidence without requiring you to rescan.

Course application: saved output supports post-mission analysis, team handoff, and defensible reporting.

### 4. Service Enumeration and Banner Grabbing

Enumerate services to identify application names, versions, banners, hostnames, and other clues. When automated output is incomplete, compare it with manual service interaction where appropriate in the HTB task.

Course application: service details provide the fidelity needed for ATT&CK mapping, vulnerability research, and follow-on decision-making.

### 5. Nmap Scripting Engine and Vulnerability Checks

Use NSE scripts when the HTB task requires them, but understand what each script category does before running it. Some scripts are informational; others are more intrusive and may create extra traffic or affect fragile services.

Course application: NSE results can quickly surface useful evidence, but operators must be able to explain what the script checked and why the result matters.

### 6. Performance and Evasion Concepts

Understand how timing, retries, packet rate, and scan strategy affect scan quality. Faster scans may miss results or trigger defensive controls; slower scans may be more reliable but take longer.

Course application: scan settings are operational choices. You should be able to explain why you selected a scan approach for the target and mission context.

## Deliverables

Complete the HTB questions associated with the assigned Nmap tasks. Your instructor may review progress during section checkpoints.

Be prepared to explain:

- Which target you scanned and how you confirmed it was in scope.
- Which scan types you used and why.
- Which ports and services were most important.
- Where you saved output and what format you used.
- Which evidence supports your conclusions.
- What you would recommend as the next collection or planning step.

## Required Task Areas

1. **Host Discovery:** Perform host discovery and use packet or TTL evidence to answer the assigned HTB question.
2. **Port Scanning:** Identify all TCP ports on `$TGT` and enumerate the target hostname.
3. **Reporting:** Perform a full TCP port scan, generate the required report output, and answer the assigned highest-port question.
4. **Service Enumeration:** Enumerate ports and services, then retrieve the text flag from the service identified by the HTB task.
5. **NSE Usage:** Use the Nmap Scripting Engine as directed by HTB to locate the final service-based flag.