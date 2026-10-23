# SquidLab — Student Brief

## Objective

Pursue adversary infrastructure from a recovered workstation image. Characterize the callback path, reuse leftover access material the adversary left behind, reach the C2 over the path they actually use, and report who/what/when/where without executing effects.

## Context

Threat hunting recovered an Alpine Linux WSL image that contains adversary tooling. That image is issued to you as the start of this pursuit. Work from your **ops-station Windows seat**. Primary access method: the issued **Alpine WSL distro** (`wsl -d Alpine`). Do not treat a second Kali VM as required.

Before you hunt outward, establish target context on the image: hostname, current user, working path, and process list. Then follow native evidence (files, processes, and traffic), not a pre-briefed host list.

Time available: 90 minutes. Intelligence collection and reporting take priority over immediate effects. Do not destroy listeners, kill sessions, or otherwise disrupt the C2.

## Tasks

1. Start on the issued image. Record host identity, user, working path, and running processes before you hunt outward.
2. Find adversary artifacts on that image. Determine what they do, how they stay present, and what they try to contact.
3. Use only that evidence to choose the next host you are authorized to touch. Do not expand reconnaissance until the image gives you a reason.
4. On that next host, enumerate what is exposed. Test whether leftover administrative access is still available; do not assume a password list we issued.
5. Determine how that host moves, forwards, or hides traffic. Collect any leftover material that would let you follow the same path the adversary uses.
6. If that path needs a tunnel or a special network interface, build it from a NIC that actually works on your seat. Confirm you are on that path before scanning further.
7. From the path you just joined, find command-and-control and any leftover operator material. If a recovered config does not match the interface you are on, correct it from evidence, not from a pre-briefed address.
8. Use leftover operator access only to survey and report. Answer the 5 Ws (who, what, when, where, why/how). Name one potential cyber effect **without executing it**.
9. Produce the report listed under Deliverables.

## Deliverables / Evidence

A concise report covering:

1. How you identified the first-hop infrastructure from the recovered image
2. How you gained access to that host and what tunnel material you reused
3. How you obtained and (if needed) modified the operator configuration
4. Current C2 state: listeners, sessions/beacons, operator accounts
5. Recommended potential cyber effects (no execution)

Cite commands and evidence (file paths you discovered, service banners, overlay addresses you observed). Include the target-context snapshot from Task 1.

## Constraints

- Scope is the issued image and the infrastructure it leads you to. Do not scan unrelated classroom nets.
- Do not pre-assume hostnames, implant paths, or credentials. Prove each hop.
- WSL may not support `/dev/net/tun`. If OpenVPN fails inside Alpine, use Windows OpenVPN or another Linux NIC and document which path you used.
- Destructive actions against the C2 are out of scope. Report recommendations only.
- Isolation is intentional: C2 services that fail from the lab LAN may still answer on the adversary tunnel.

## Success Criteria

- You can explain the path from the recovered image to adversary C2 using evidence you collected
- You obtained operator access without being handed that infrastructure up front
- Your report answers the 5 Ws and names at least one effect you did **not** execute
- You did not kill sessions or listeners you found

## PCTE range limitations

These limits apply on Persistent Cyber Training Environment (PCTE) ranges used by this Module. Treat the items below as a no-strike list when they exist. Not every item is present on every range or host.

Do not target, block, terminate, or delete range-control artifacts:

- **Network:** `10.0.0.0/8` (range control and instrumentation; do not block or flag that traffic). Routers past the edge-router in grey space. TCP `5672` (AMQP user-emulation on the control subnet), `49998`, and `49999`.
- **Accounts:** `range-admin` / `range_admin`, `range-control`, and `range`. Do not use accounts whose username or password contains `simspace`.
- **User emulation:** do not stop it. Typical paths: `C:\Program Files (x86)\Simspace\` and `C:\Users\<Username>\Simspace`. Scripts: `run-actuation.cmd`, `ueactuation.cmd`.
- **Directories:** `C:\Program Files\Puppet Labs` and the Simspace paths above.
- **Processes:** `java.exe`, `javaw.exe`, `ruby.exe`, `rubyw.exe`, `start.exe`, `chromedriver.exe`, `IEDriverServer.exe`, Metova, Selenium, WebDriver.

