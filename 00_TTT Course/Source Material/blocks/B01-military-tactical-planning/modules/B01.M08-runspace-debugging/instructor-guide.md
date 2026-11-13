---
id: B01.M08-ig
title: EAC0014 Runspace Debugging — Instructor Guide
artifact_type: instructor_guide
audience: instructor
block: B01
module_type: demo
legacy_aliases:
- B01.M22
source_status: canonical
review_required: false
output_formats:
- docx
- pdf
- docx_lesson_plan
template_profile: instructor_guide_v1
sensitivity: instructor_only
---

# EAC0014 Runspace Debugging — Instructor Guide

## Objective and context

Standalone instructor demo early in B01. Show what blue-space counterstrike can look like before the formal planning and MITRE blocks: a privileged defender manipulates adversary software output in memory without immediately killing the adversary process.

**Mission framing:** A Lunovia defensive cyber element has local administrator access on an engaged Windows host where a Varensk-affiliated operator (Units 2213 *Iron Wolf* or 9931 *Storm Pike*, both associated with Empire C2 in the course scenario) is running script-based collection. Corrupt what the adversary sees and reports upstream while keeping the implant active.

Command-complete live walkthrough, first-use command explanations, troubleshooting, and teardown: [`RunspaceDebugging.md`](./RunspaceDebugging.md). Hidden stack: [`PowerShell Runspace Debugging/lab_env/README.md`](PowerShell%20Runspace%20Debugging/lab_env/README.md). When **B01.M23** reaches EAC0014, callback this demo by name; do not re-run the full walkthrough unless the class needs a refresher.

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "This demo shows one ENGAGE Affect technique — Software Manipulation (EAC0014) — in action. We are not rushing to reimage the host. We are in a position to observe and influence what malware reports."
- **Do:** Draw two columns on the board: **Window A / target host** (adversary script or Empire agent) and **Window B / defender** (elevated `Enter-PSHostProcess`). Label the effect: falsified output upstream; process stays alive.
- **Ask (Q):** If you already have local admin on the host, why not just kill the process?
- **Expected Response (A):** Steer toward continued observation and corrupting what the operator trusts. Killing ends the channel and tips that the host is hostile.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "PowerShell ships with a legitimate debugging feature: attach to another PowerShell host on the same machine, enter its runspace, and change variables or functions while they are still in memory. That is a defender using native platform capability from a privileged local position — not a vulnerability in Empire."
- **Show:** Board values `ENGAGE_TECHNIQUE=EAC0014 Software Manipulation` and the two-window model (target vs defender).
- **Do:** Set expectations: students observe and discuss; they do not build C2 today.
- **Ask (Q):** Who is running in Window A, and who is running in Window B?
- **Expected Response (A):** Window A hosts the target code (demo script or Empire agent). Window B is the elevated defender debug session. Never run the target script in Window B.

## Instructor resources and pre-class preparation

Complete before students enter. Do not project these steps. Delivery path is PCTE stack `b01-runspace-demo`. Full checklist: [`RunspaceDebugging.md`](./RunspaceDebugging.md) section 0. Starkiller listener/stager/beacon steps: [`lab_env/README.md`](PowerShell%20Runspace%20Debugging/lab_env/README.md).

- Range logins (confirm against the current range card): Kali `kali` / `toortoor!`; Windows `Administrator` / `Simspace1!Simspace1!`; Starkiller `empireadmin` / `password123`
- Windows victim with PowerShell 5.1+ and a local administrator for the defender session
- Defender for the stager: on the victim (elevated), run `Get-MpComputerStatus | Select IsTamperProtected, AntivirusEnabled, RealTimeProtectionEnabled, AMServiceEnabled`. If `RealTimeProtectionEnabled` is True, run `Set-MpPreference -DisableRealtimeMonitoring $true` and re-check. Realtime often re-enables — repeat this immediately before section 5. Full steps: lab_env README section 3.
- Demo script copied to `Desktop\Runspace-Demo\RunspaceDebugging.ps1`
- Open Starkiller at **`https://127.0.0.1:1337`** on Kali for **stager copy** — clipboard fails if you use the LAN IP
- Listener Host = victim-reachable ops-station IP (not `127.0.0.1`); generate PowerShell `multi/launcher`; agent checked in; honest Starkiller Shell `whoami`
- Window A (discovery-script walkthrough, during the live demo): `cd Desktop\Runspace-Demo` then `powershell.exe -ExecutionPolicy Bypass -File .\RunspaceDebugging.ps1`
- Notepad started and minimized (discovery-script walkthrough)
- Two elevated PowerShell windows on the victim (A = target, B = defender)
- Live Empire walkthrough: open Starkiller on the **Windows victim** (`https://<ops-station-ip>:1337`) so Shell and Window B are on one projector. Agents → agent → **Shell**
- Confirm `Get-PSHostProcessInfo` works from Window B

## Student resources and environment

- Students observe and discuss; they do not run the C2 setup
- Defender actions require elevated local PowerShell on the Windows victim
- Success looks like falsified output on stdout (discovery-script walkthrough) or the projected Starkiller Shell (Empire walkthrough)
- No additional student kit for this demo

## Facilitation flow

### Step 1: Orient and EAC0014 framing (5 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "Up to now we have talked about ENGAGE techniques as options you bring to the commander. This demo shows Software Manipulation in action. Two demonstrations: a controlled discovery script, then the same technique against a live Empire agent. You will watch how a defender corrupts collection quality while the adversary keeps working."
- **Show:** Two-window model and `EAC0014` on the board.
- **Do:** Read the student introduction in [`RunspaceDebugging.md`](./RunspaceDebugging.md). Confirm students will not build C2.
- **Ask (Q):** What does success look like in this demo, if we are not killing the process?
- **Expected Response (A):** Falsified output reaching stdout (discovery-script walkthrough) or the projected Starkiller Shell (Empire walkthrough) while the implant stays active.

### Step 2: Access, identity, and host baseline (5 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "The defender's first move is the same as any host investigation — establish time, identity, process context, and which PowerShell hosts exist before attaching to the wrong one."
- **Show:** Project Window B. Primary access is **local elevated PowerShell** on the Windows victim (`Enter-PSHostProcess`). Adversary tasking (Empire walkthrough only) is **Starkiller Shell** opened on the Windows victim (`https://<ops-station-ip>:1337`).
- **Do:** From Window B run the access check and SA baseline in [`RunspaceDebugging.md`](./RunspaceDebugging.md) sections 1–2 (`hostname`, `whoami`, admin role `True`, `Get-PSHostProcessInfo` with **`ProcessId`**, `Win32_Process` `CommandLine`). First use: `Get-PSHostProcessInfo` lists processes hosting a PowerShell runspace debugger endpoint — that is the defender's attach map. `$PID` in Window B is the session you must **not** attach to. Match the target by command line (`-File` / `RunspaceDebugging.ps1` or the Empire stager), because Window A is busy and cannot print `$PID`.
- **Ask (Q):** Why must the defender attach to a different PID than the session they are standing in?
- **Expected Response (A):** You cannot debug the session you are using. Attaching to `$PID` fails; pick the host whose command line is running the target code.

### Step 3: Discovery-script walkthrough — variable, one-shot proof, then function (20 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "This script is a stand-in for script-based malware: repetitive discovery, output, and sleep. Software Manipulation often targets command output. We will let the code compute the real answer, swap the variable, prove that inject lasted one loop, then replace the function — without touching disk."
- **Show:** Window A looping on Notepad discovery (`Found notepad here: C:\Windows\System32\notepad.exe`), then Window B attach.
- **Do:** Execute [`RunspaceDebugging.md`](./RunspaceDebugging.md) section 4 (4.1–4.12). Sequence: start Notepad; launch `RunspaceDebugging.ps1` in Window A; from Window B match `CommandLine` containing `RunspaceDebugging.ps1`, `Enter-PSHostProcess -Id <TARGET_PID>`, `Get-Runspace`, debug **`Runspace1`** (never `RemoteHost`); `l 1 30` then breakpoint line 15; `Set-Variable NotepadPath`; wait for `C:\lol.exe`; at the next line-15 break continue without swapping so notepad.exe returns; then explain line 21 as the call site and redefine `Get-ThemProcesses`. First use: `Enter-PSHostProcess -Id` connects the defender shell to the named-pipe debugger in the target process (admin or same-owner). `Debug-Runspace` on `RemoteHost` errors with cannot-debug-host-runspace.
- **Ask (Q):** After the variable swap, what did Window A print, and what happened on the next loop?
- **Expected Response (A):** First stdout showed the decoy path (`C:\lol.exe`). The next loop printed the real Notepad path again — the inject was not persisted. Real Notepad on disk was still `C:\Windows\System32\notepad.exe`. The process was not killed.

### Step 4: Empire walkthrough — in-memory agent (22 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "The discovery script was training wheels. This host is running a live Empire PowerShell agent — the kind of foothold Varensk Units 2213/9931 use in our scenario. There is no on-disk `.ps1`. Same defender move: attach, read live functions with `l`, falsify what returns to C2."
- **Show:** Projected Starkiller on the Windows victim (Agents → agent → **Shell**, honest `whoami` first), then Window B inside `Invoke-Empire`.
- **Do:** Execute [`RunspaceDebugging.md`](./RunspaceDebugging.md) section 5 (5.1–5.8). Re-check Defender RTP first (it often re-enables). Arm → attach → orient (`Get-PSCallStack | Format-List *`, `?`, `l 1 200`) → `Get-PSBreakpoint | Remove-PSBreakpoint` then `Set-PSBreakpoint -Command Invoke-ShellCommand` → `c` repeatedly → Starkiller Shell `whoami` (click Window B and press Enter if `[DBG]` does not appear). Path A: write-watch on `$output`; first hit is empty (`$output = '';`) → `c`; second hit has the real identity → `$output = "varensk\decoy_operator"` (not `Set-Variable`). Do not assign on the empty hit. Path B: `Set-Item Function:\Invoke-ShellCommand` (not a new `function` statement). The in-flight `whoami` after this breakpoint still returns the real account; persist is the **next** Shell command. After `Set-Item`, remove BPs, **Detach** (`d`, not `q`), then `Exit-PSHostProcess` — the in-memory function stays in the agent. A whoami-only `if` without a saved original kills other Shell tasks; optional wrap is in 5.7. Prefer a **new** agent for the Path B all-commands stub and another **new** agent for the whoami-only wrap — do not stack both on the same implant. First use: `Set-PSBreakpoint -Command` breaks on a function name because the agent is an in-memory scriptblock — `Set-PSBreakpoint -Script -Line` does not apply. A second `Set-PSBreakpoint` does not replace the first — remove before arming a new one. `Get-Variable cmd, cmdargs, output` is a landing check (`output` empty = too early). `l 1 200` lists 200 lines starting at line 1 of the script under the debugger (the `Invoke-Empire` body).
- **Ask (Q):** Why does a script-path line breakpoint fail on this agent, and which user context is the defender changing?
- **Expected Response (A):** The agent is `Invoke-Empire` in memory, not a `.ps1` on disk. The defender is in an elevated local admin session; the output they corrupt is whatever user context the agent is running as. Break on `Invoke-ShellCommand` (or `Invoke-Expression`), not `whoami.exe`.

### Step 5: Debrief — kill vs manipulate (8 min)

- **Image Prompt:** No image required for this demo step.
- **Say:** "Killing the agent ends observation and tips the adversary that the host is hostile. Manipulation keeps the channel open while we waste analyst cycles and corrupt downstream planning. That is why EAC0014 belongs in the ENGAGE option set: Affect through Disruption. The technique generalizes: defenders with legitimate privileged access can reshape software behavior at runtime."
- **Show:** Agent `powershell` process still present while C2 returns fiction, if still attached.
- **Do:** Run the debrief in [`RunspaceDebugging.md`](./RunspaceDebugging.md) section 7. Teardown is section 8 (`Exit-PSHostProcess`, kill the agent in Starkiller, compose `down` from the Module `lab_env/`).
- **Ask (Q):** When would you choose manipulation over isolation or kill, and what collection would prove the defender action occurred?
- **Expected Response (A):** Choose manipulation when you still need the channel and can accept the risk of leaving the implant up. Evidence examples from the walkthrough: Event ID 4104, process access, debugger attachment.

## Lesson summary

- EAC0014 Software Manipulation (ENGAGE Affect / Disruption): change what the adversary collects without killing the process.
- Discovery-script walkthrough used a file-backed script: attach to `Runspace1`, show line 15 with `l 1 30`, swap `$NotepadPath` for one loop, prove the next loop rebuilt the real path, then redefine `Get-ThemProcesses` at the line-21 call site.
- Empire walkthrough used an in-memory agent: Starkiller Shell `whoami`, write-watch on `$output` (empty hit then identity), or `Set-Item Function:\Invoke-ShellCommand` so the **next** Shell command records fiction; detach (`d` then `Exit-PSHostProcess`) after the in-memory replace.
- Privilege and context: elevated local defender vs adversary execution user; do not attach to your own `$PID` or debug `RemoteHost`. Identify the target by `CommandLine`.

## Questions and check on learning

- **Ask (Q):** What is the difference between the discovery-script execution environment and the Empire-agent execution environment?
- **Expected Response (A):** The discovery script is a `.ps1` on disk with line breakpoints. The Empire agent is in-memory `Invoke-Empire` with no script path; use `Set-PSBreakpoint -Command`.
- **Ask (Q):** Which session is the defender, and which user context is being lied about to C2?
- **Expected Response (A):** Defender is elevated Window B. C2 is lied to about the agent process user (Path A `$output` / Path B `Invoke-ShellCommand`).
- **Ask (Q):** What ENGAGE technique and effect did this demo show?
- **Expected Response (A):** EAC0014 Software Manipulation; Affect / Disruption; falsified collection while the session stays up.

## Related artifacts

- Command walkthrough: [`RunspaceDebugging.md`](./RunspaceDebugging.md)
- Setup: [`PowerShell Runspace Debugging/lab_env/README.md`](PowerShell%20Runspace%20Debugging/lab_env/README.md)
- Discovery script: [`PowerShell Runspace Debugging/RunspaceDebugging.ps1`](PowerShell%20Runspace%20Debugging/RunspaceDebugging.ps1)
