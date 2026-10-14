## Instructor Answer Key (Instructor Only)

Use this as a live walkthrough and facilitation guide for the standalone **B01.M08** instructor demo early in the Block (day 1–2). The goal is to show students what blue-space counterstrike can look like before the formal planning and MITRE framework blocks: a privileged defender manipulates adversary software output in memory without immediately killing the adversary process.

When **B01.M23** (MITRE D3FEND and ENGAGE) reaches EAC0014, callback this demo by name rather than re-running the full walkthrough unless the class needs a refresher.

**Mission framing:** A Lunovia defensive cyber element has local administrator access on an engaged Windows host where a Varensk-affiliated operator (Units 2213 _Iron Wolf_ or 9931 _Storm Pike_, both associated with Empire C2 in the course scenario) is running script-based collection. Your team will corrupt what the adversary sees and reports upstream while keeping the implant active for continued observation.

**Demo artifacts:**

- Discovery script: [`PowerShell Runspace Debugging/RunspaceDebugging.ps1`](https://moodle.cso.ops/mod/page/PowerShell%20Runspace%20Debugging/RunspaceDebugging.ps1)
- Empire stack (instructor only): `PowerShell Runspace Debugging/lab_env/README.md` (not in this Moodle backup)

---

## Student Introduction (Read to Class — 3–5 Minutes)

**Say:**

> "Up to now we have talked about ENGAGE techniques as options you bring to the commander. This demo shows one Affect technique — **Software Manipulation** — in action. The scenario is familiar: a Varensk operator has script-based malware running on a Lunovia workstation. We are not rushing to reimage the host. We are in a position to **observe and influence** what that malware reports.
> 
> PowerShell ships with a legitimate debugging feature: you can attach to another PowerShell host process on the same machine, enter its runspace, and change variables or functions **while they are still in memory**. That is not a vulnerability in Empire or in our demo script — it is a defender using native platform capability from a **privileged local position**.
> 
> We will do this in two demonstrations. First, a controlled script that mimics adversary discovery behavior. Second, the same technique against a live Empire agent that is already on the host. You will not build the C2 infrastructure today; you will watch how a defender corrupts collection quality while the adversary keeps working."

**Set expectations:**

- Students observe and discuss; they do not run the C2 setup.
- Defender actions require **elevated local PowerShell** on the Windows victim.
- Two PowerShell windows are always involved: one hosts the target code, one is the defender debug session.
- Success looks like falsified output reaching stdout (discovery-script walkthrough) or the projected Starkiller Shell (Empire walkthrough).

---

## 0. Instructor Pre-Class Checklist

Complete before students enter. Do not project these steps.

Delivery path is PCTE stack `b01-runspace-demo` (Kali ops station and Windows victim on that range). The steps in this section and in `lab_env/README.md` (not in this Moodle backup) are how you use that stack.

**Range logins (defaults — confirm against the current range card):**

|Host|Account|Password|Use|
|---|---|---|---|
|Kali ops station|`kali`|`toortoor!`|Docker / Starkiller (`[https://127.0.0.1:1337](https://127.0.0.1:1337)`)|
|Windows victim|`Administrator`|`Simspace1!Simspace1!`|Elevated Window A/B; `Enter-PSHostProcess`|
|Empire / Starkiller|`empireadmin`|`password123`|C2 UI: Kali `127.0.0.1` for stager copy; Windows victim browser for the live demo|

1. Log into the Kali ops station and the Windows victim with the accounts above. Confirm Windows PowerShell 5.1+ and that the defender session is a local administrator.
2. Copy demo files to the victim: `Desktop\Runspace-Demo\RunspaceDebugging.ps1`.
3. On the victim (elevated), confirm Defender realtime is off. Full steps: `lab_env/README.md` (not in this Moodle backup) section 3.

```
Get-MpComputerStatus | Select IsTamperProtected, AntivirusEnabled, RealTimeProtectionEnabled, AMServiceEnabled
```

If `RealTimeProtectionEnabled` is True:

```
Set-MpPreference -DisableRealtimeMonitoring $true
```

Re-check. Gate is `RealTimeProtectionEnabled` False. If you flipped realtime off, generate a **new** launcher. Default outbound firewall usually allows `:8080`; do not disable the whole firewall unless check-in is blocked.

4. Bring up the Empire stack per `lab_env/README.md` (not in this Moodle backup) (Starkiller listener, stager, and beacon steps are in that same file):
    - `docker compose --env-file instructor.env up -d`
    - Open Starkiller at **`[https://127.0.0.1:1337](https://127.0.0.1:1337)`** (`empireadmin` / `password123`). Do **not** use the LAN IP — clipboard copy of the stager one-liner fails unless the browser is on loopback. CLI is optional and needs `./ps-empire -f client`.
    - Create HTTP listener with Host = victim-reachable ops-station IP (not `127.0.0.1`, not only the value in `.env`)
    - Generate `multi/launcher` PowerShell one-liner, copy from Starkiller, run on the victim
    - Validate agent/beacon check-in. In Starkiller: Agents → select the agent → **Shell** → type `whoami`. Honest output should return.
5. Start **Notepad** on the victim and leave it minimized (discovery-script prerequisite).
6. Open **two** elevated PowerShell windows on the victim:
    - **Window A:** discovery script (commands below) or Empire agent host (Empire walkthrough)
    - **Window B:** defender debug session (never run the target script here)
7. **Window A** launch command (run during the discovery-script walkthrough, not before class):

```
cd Desktop\Runspace-Demo
powershell.exe -ExecutionPolicy Bypass -File .\RunspaceDebugging.ps1
```

8. For the live Empire walkthrough, open Starkiller on the **Windows victim** (`https://<ops-station-ip>:1337`, `empireadmin` / `password123`) so the C2 GUI and Window B sit on one projector. Shell tasking does not need clipboard. Keep Kali `[https://127.0.0.1:1337](https://127.0.0.1:1337)` for **pre-class launcher copy** — LAN IP will not copy the stager one-liner.
9. Confirm `Get-PSHostProcessInfo` works from Window B before class.

**Board values (suggested):**

```
DEMO_SCRIPT=Desktop\Runspace-Demo\RunspaceDebugging.ps1
DEFENDER_SESSION=Elevated PowerShell Window B
TARGET_SESSION=Window A or Empire agent powershell host
ENGAGE_TECHNIQUE=EAC0014 Software Manipulation
```

---

## 1. Access and Environment Model

|Role|Access method|Notes|
|---|---|---|
|Defender (demo operator)|**Local elevated PowerShell** on Windows victim|Primary method; log in as `Administrator` / `Simspace1!Simspace1!`; attach with `Enter-PSHostProcess`|
|Adversary tasking (instructor)|**Starkiller** (Agents → agent → **Shell**)|Live demo: open from the **Windows victim** at `https://<ops-station-ip>:1337`. Pre-class stager copy stays Kali `127.0.0.1`. CLI is optional in lab_env only.|
|Fallback|Same-user attach|Works only if the target runspace runs as the same user as the debugger; unlikely for a staged agent user|

**Verification before manipulation:**

```
hostname
whoami
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
```

Expected: hostname matches the victim; `whoami` shows the defender admin context; admin check returns `True`.

**Rollback summary:** kill demo script or Empire agent, `docker compose down` on ops station. Full steps in Section 8.

---

## 2. Initial Situational-Awareness Baseline

Run from **Window B** (defender session) before each walkthrough. Project on the instructor machine; students run locally if they have a victim workstation.

```
Get-Date -Format o
hostname
whoami
Get-Location
$PSVersionTable.PSVersion
Get-Process powershell | Select-Object Id, ProcessName, StartTime, Path
Get-PSHostProcessInfo | Format-Table ProcessName, ProcessId, AppDomainName, MainWindowTitle -AutoSize
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine
Get-NetTCPConnection -State Listen,Established -ErrorAction SilentlyContinue |
  Where-Object { $_.OwningProcess -in (Get-Process powershell -ErrorAction SilentlyContinue).Id } |
  Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess
```

**Expected findings:**

- Multiple `powershell` processes before the discovery-script launch; more after the script or agent is running.
- `Get-PSHostProcessInfo` lists each PowerShell host the defender can potentially attach to. Use **`ProcessId`**, not `Id` — `Id` can blank out in the live table.
- `Win32_Process.CommandLine` shows which host is the `.ps1` file, which is the defender console, and (later) which is the Empire stager.
- PS version 5.1 or later on Windows PowerShell.

**Teaching point:** The defender's first move is the same as any host investigation — establish time, identity, process context, and which PowerShell hosts exist before attaching to the wrong one.

---

## 3. Evidence and Value Provenance

|Value|How the instructor knows it|Why it matters|
|---|---|---|
|Target PID|From Window B: `Get-CimInstance Win32_Process` `CommandLine` plus `Get-PSHostProcessInfo`. Discovery-script host: `CommandLine` contains `-File` / `RunspaceDebugging.ps1`. Empire host: the other `powershell.exe` (stager / encoded command line), not `$PID` and not the leftover `.ps1`. Optional: Task Manager Details → Command line|Window A is busy in the loop, so you cannot type `$PID` there. Attaching to the defender session (`$PID` in Window B) fails|
|Runspace ID|After `Enter-PSHostProcess`, run `Get-Runspace`. Debug **`Runspace1`** (or another non-`RemoteHost` runspace running the target code). **Never** `Debug-Runspace` on `RemoteHost` — that row is the attach channel and PowerShell rejects it|`RemoteHost` is Busy because _you_ attached; the demo/script work lives in `Runspace1`|
|Breakpoint line 15|Shown first with debugger `l 1 30`. Line 10 computes `$NotepadPath`; line 15 is the `Write-Host` that reports it|Variable swap happens after compute, before output (discovery-script walkthrough only)|
|Breakpoint line 21|Shown with `l 1 30` or `l 20 5`. `Get-ThemProcesses` call inside `while ($true)` — the call site after proving the variable swap did not persist|Function-redefinition beat (discovery-script walkthrough only)|
|Empire breakpoint target|Live agent has **no `.ps1` path**; use `Set-PSBreakpoint -Command Invoke-ShellCommand` (or `-Command Invoke-Expression`) discovered via `l` / `Get-PSCallStack` inside `Invoke-Empire`|Script-path breakpoints do not apply to in-memory Empire agents|
|Empire `$output`|Set inside `Invoke-ShellCommand` after `iex "$cmdargs" \\| Out-String` for `shell` tasks; returned at end of that function|Path A overwrite target before results are packetized to C2|
|Empire agent name|Starkiller **Agents** list|Required to open **Shell** and task `whoami`|
|Decoy output string|Instructor choice (example: `varensk\decoy_operator`)|Projects scenario-consistent falsified intel|

---

## 4. Walkthrough — Discovery Script (File-Backed)

Controlled adversary script: [`RunspaceDebugging.ps1`](https://moodle.cso.ops/mod/page/PowerShell%20Runspace%20Debugging/RunspaceDebugging.ps1). The script loops on a function that discovers a running Notepad process, prints its path, and tests the path.

### 4.1 Start the benign discovery target

**Say:** "The adversary script is looking for a common user application as a discovery anchor. We leave Notepad running because that is ordinary user behavior on a workstation."

**Run (Window A or ordinary user session):**

```
Start-Process notepad
```

Minimize Notepad.

**Expect:** `notepad.exe` appears in Task Manager / `Get-Process notepad`.

---

### 4.2 Launch the adversary script

**Teach:** The script runs in its own PowerShell host process. The infinite loop gives the defender time to attach between iterations. Window A is now occupied by that child process — you cannot type `$PID` there without interrupting the script.

**Say:** "This is our stand-in for script-based malware: repetitive discovery, output, and sleep. The adversary operator would see this output on their C2 channel. We are going to change what gets reported."

**Run (Window A):**

```
cd Desktop\Runspace-Demo
powershell.exe -ExecutionPolicy Bypass -File .\RunspaceDebugging.ps1
```

`-ExecutionPolicy Bypass` applies only to this process so the unsigned demo script can run. `-File` runs `RunspaceDebugging.ps1` as a script rather than a command string.

**Expect:** Repeating output similar to:

```
Found notepad here: C:\Windows\System32\notepad.exe
True
```

ten-second pause between loops.

---

### 4.3 Identify the script host PID from command line

**Teach:** `Get-PSHostProcessInfo` lists processes hosting a PowerShell runspace debugger endpoint. `Get-CimInstance Win32_Process` adds the **command line**, which is how you tell the discovery script from the defender console when Window A is busy.

**Say:** "From a **second** elevated window, we map which PowerShell host is running the malware script. We cannot debug the session we are standing in. The command line of the process we just launched includes `-File` and `RunspaceDebugging.ps1` — that is the PID we attach to."

**Run (Window B):**

```
$MyDebugPid = $PID
Write-Host "Defender session PID (do not attach):" $MyDebugPid

Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine |
  Format-List

Get-PSHostProcessInfo |
  Where-Object { $_.ProcessId -ne $MyDebugPid } |
  Format-Table ProcessName, ProcessId, AppDomainName, MainWindowTitle -AutoSize
```

**Expect:** One `CommandLine` contains `-File` / `RunspaceDebugging.ps1` — that `ProcessId` is Window A. `$MyDebugPid` is Window B; skip it. Use **`ProcessId`** on `Get-PSHostProcessInfo` (not `Id`).

Optional visual: Task Manager Details → add the **Command line** column and point at the same `-File` host.

**Transition note:** If a leftover Empire stager is also listed, leave it alone for this walkthrough. Attach only to the `.ps1` host.

---

### 4.4 Enter the target PowerShell host

**Teach:** `Enter-PSHostProcess -Id` connects the defender shell to the named pipe debugger endpoint inside the target process. Requires administrator or same-owner rights.

**Run (Window B):**

```
Enter-PSHostProcess -Id <TARGET_PID>
```

Replace `<TARGET_PID>` with the `ProcessId` whose command line showed `RunspaceDebugging.ps1` in 4.3.

**Expect:** Prompt may change; no error. If access denied, confirm Window B is elevated admin.

---

### 4.5 List runspaces in the target host

**Teach:** `Get-Runspace` shows each runspace in the attached process. After `Enter-PSHostProcess` you almost always see at least:

1. **`Runspace1`** — the host's normal execution runspace (this is where `RunspaceDebugging.ps1` runs).
2. **`RemoteHost`** — the attach channel created by `Enter-PSHostProcess`. It often shows **Busy** because _your defender session_ is connected. You **cannot** debug this runspace with `Debug-Runspace`.

Also: inside the attach session, objects are remoted/deserialized. Use the **default** `Get-Runspace` view (or `Get-Runspace | Format-Table` with **no** property list). Do **not** select `State` / `Availability` explicitly — those columns go blank even though the default view shows them. `Where-Object { $_.Availability -eq "Busy" }` also fails for the same reason. Identify by **Name** / **Id** from the default table.

**Run:**

```
Get-Runspace
```

**Expect:** Two (or more) rows. Typical live demo shape:

```
 Id Name            ComputerName    Type          State         Availability
 -- ----            ------------    ----          -----         ------------
  1 Runspace1       localhost       Local         Opened        Available
  2 RemoteHost      localhost       Local         Opened        Busy
```

- **`RemoteHost` (Id 2 here):** attach channel — skip for `Debug-Runspace`.
- **`Runspace1` (Id 1 here):** target for debugging. It may show **Available** between commands; that does **not** mean you should pick `RemoteHost`.

Optional Id helper (Name still serializes; Availability does not):

```
Get-Runspace | Where-Object { $_.Name -eq 'Runspace1' } | Select-Object Id, Name
```

---

### 4.6 Attach the debugger

**Teach:** Enable debug on the script runspace, then attach. Debugger keys: `l` list code, `s` step into, `n` step over, `c` continue.

If you call `Debug-Runspace -Id` against `RemoteHost`, expect:

```
You cannot debug the default host Runspace using this cmdlet.
```

That error means you selected the attach channel — switch to `Runspace1`.

**Say:** "We are now inside the adversary's execution context. This is the privileged blue-space position — we did not patch a file on disk; we stepped into live memory."

**Run:**

```
Enable-RunspaceDebug -RunspaceId 1
Debug-Runspace -Id 1
```

Replace `1` only if `Runspace1` has a different Id in your table. Do **not** use the `RemoteHost` Id.

If `Debug-Runspace` waits or says the runspace is not Busy, leave it pending and wait for Window A's next loop iteration (the 10-second sleep will expire and the function will run again), or press activity in Window A's script window. `Enable-RunspaceDebug` ensures the next execution breakable for the debugger.

**Expect:** Debugger breaks into the running script. Press `l` to list current line context.

---

### 4.7 Operate the debugger (orient, then plan the breakpoint)

**Teach:** Treat this like any interactive debugger. Mental model for the rest of both walkthroughs:

1. **Attach** into the runspace (`Debug-Runspace`)
2. **Orient** with `l` (you often land on an arbitrary line)
3. **Set a breakpoint** at the intervention line
4. **Continue** (`c`) until that breakpoint hits
5. **Manipulate** variables/functions
6. **Continue** again so falsified output proceeds upstream

Debugger keys: `l` list code, `s` step into, `n` step over, `c` continue. At first break-in, run `?` (or `h`) once to show the full debugger cheat sheet before using those keys.

**Run (at debugger prompt):**

```
?
l
```

Optional: `n` or `s` a few times to show stepping. Prefer setting a breakpoint (next step) over racing with step commands alone.

**Expect:** `?` lists debugger commands (`l`/`list`, `c`/`continue`, `s`, `n`, etc.). Then `l` shows source lines from `RunspaceDebugging.ps1` with a marker on the active line. (`l <m> <n>` lists `n` lines starting at line `m`.)

---

### 4.8 Show the report line, then break before output

**Teach:** Do not set a line breakpoint until the class has seen the source. `l 1 30` lists 30 lines starting at line 1 — enough to show this whole short script.

**Run (at debugger prompt):**

```
l 1 30
```

**Say / teach while pointing at the listing:**

- Line 10 **computes** `$NotepadPath` from `Get-Process notepad`.
- Line 15 **reports** that value (`Write-Host "Found notepad here:" $NotepadPath`). That string is the collection product going upstream.
- Software Manipulation often targets **command output**. Break **after compute, before print** so the real path is already in memory and we can swap it.

**Say:** "Line 15 is a manipulatable variable at the moment it is about to be reported. We will let the adversary code compute the real answer, then swap `$NotepadPath` before it is printed."

**Run:**

```
Set-PSBreakpoint -Script "$env:USERPROFILE\Desktop\Runspace-Demo\RunspaceDebugging.ps1" -Line 15
c
```

**Expect:** Debugger stops at `Write-Host "Found notepad here:" $NotepadPath`.

---

### 4.9 Swap the discovery result in memory

**Teach:** `Get-Variable` reads runspace scope; `Set-Variable` overwrites before continue. The adversary channel will report the decoy.

**Run:**

```
Get-Variable -Name NotepadPath
Set-Variable -Name NotepadPath -Value "C:\lol.exe"
c
```

**Expect (Window A stdout):** wait for this loop to finish printing:

```
Found notepad here: C:\lol.exe
```

The real Notepad path was replaced in memory before output.

**Say:** "If this were C2, the operator upstream now records a bogus path. Their analyst time, pivot decisions, and follow-on tasking are all working off corrupted data."

---

### 4.10 Prove the swap did not persist

**Teach:** The line-15 breakpoint is still armed. `$NotepadPath` is a local inside `Get-ThemProcesses`. The next call runs line 10 again and rebuilds the real path. The inject lasted **one iteration**.

**Do:** After Window A shows `C:\lol.exe`, leave the debugger attached. After the 10-second sleep, the debugger hits line 15 **again**.

**Run (at the second line-15 break):**

```
Get-Variable -Name NotepadPath
c
```

Do **not** `Set-Variable` this time.

**Expect:**

- `Get-Variable` shows `C:\Windows\System32\notepad.exe` (or the live Notepad path) — line 10 reassigned it.
- Window A then prints:

```
Found notepad here: C:\Windows\System32\notepad.exe
```

**Say:** "Same breakpoint, same variable name, honest output again. What we replaced was only for that single run. It was not persisted in the process. That is why a one-off variable swap is a weak lasting disruption — and why the next move is the function itself."

---

### 4.11 Break at the call site (line 21)

**Teach:** List the loop so the class sees **why** line 21 matters before you set the breakpoint.

**Run:**

```
l 1 30
```

Or jump to the loop:

```
l 20 5
```

**Say / teach while pointing at the listing:**

```
while ($true) {
    Get-ThemProcesses
}
```

- Line 21 is the **call site**, not another output line.
- The function body still computes `$NotepadPath` on every call, which is why 4.10 returned to the real path.
- Breaking here lets you replace `Get-ThemProcesses` in memory _before_ the next call, so disruption persists across loops without touching disk.

**Run:**

```
Set-PSBreakpoint -Script "$env:USERPROFILE\Desktop\Runspace-Demo\RunspaceDebugging.ps1" -Line 21
c
```

**Expect:** Debugger stops on `Get-ThemProcesses` inside the `while` loop, before the next discovery run.

---

### 4.12 Replace the function in memory

**Teach:** Functions live in `function:\`. Redefining `Get-ThemProcesses` in the attached runspace replaces what executes on the next call.

**Run:**

```
Get-ChildItem function:\ | Where-Object { $_.Name -eq "Get-ThemProcesses" }
function Get-ThemProcesses { Write-Host "lol noob hacker is using script based malware" }
c
```

**Expect (Window A stdout):**

```
lol noob hacker is using script based malware
```

instead of the Notepad discovery block. Unlike the variable swap, this persists on later loop iterations.

**Say:** "We did not kill the process. We degraded the adversary's collection workflow and injected a message they will not expect. That is an ENGAGE counterstrike: **Affect** through **Disruption**."

**Stop the discovery-script walkthrough:** `Ctrl+C` in Window A or detach debugger (`q` until exited) and close the script host when ready for the Empire walkthrough.

---

## 5. Walkthrough — Empire Agent (In-Memory)

**Prerequisite:** Empire agent already staged on the victim per `lab_env/README.md` (not in this Moodle backup). Students see only the defender attach and projected **Starkiller** results.

**Live C2 for this demo is Starkiller**, not the Empire CLI. Open the UI on the **Windows victim** (`https://<ops-station-ip>:1337`, `empireadmin` / `password123`) so Shell and Window B are on one projector. Agents → select the agent → **Shell** → type commands such as `whoami`. GUI `whoami` still becomes `Invoke-ShellCommand -cmd shell -cmdargs whoami` inside the agent.

**Defender re-check (do this immediately before 5.1):** Realtime often turns itself back **on** after the pre-class `Set-MpPreference`. If you skip this, the agent can die mid-demo. Same commands as lab_env README section 3:

```
Get-MpComputerStatus | Select IsTamperProtected, AntivirusEnabled, RealTimeProtectionEnabled, AMServiceEnabled
```

If `RealTimeProtectionEnabled` is True:

```
Set-MpPreference -DisableRealtimeMonitoring $true
```

Re-check. Gate is `RealTimeProtectionEnabled` False.

**Say:** "The discovery script was training wheels — a `.ps1` on disk with line numbers we could list. This host is running a live Empire PowerShell agent — the kind of foothold Varensk Units 2213/9931 use in our scenario. Same defender move: attach to the process, understand the in-memory script, and falsify what returns to C2. There is no file path this time."

**Empire agent map (from live `l` of the agent in this course stack):** The agent body is the in-memory function **`Invoke-Empire`**. Nested inside it, **`Invoke-ShellCommand`** handles interactive shell tasking. A Starkiller Shell `whoami` becomes task type **40** → `Process-Tasking` → `Invoke-ShellCommand -cmd shell -cmdargs whoami`. Result string is built as `$output`, then returned and packetized for C2. There is **no on-disk `.ps1`**, so discovery-script `Set-PSBreakpoint -Script ... -Line ...` does **not** apply.

---

### 5.1 Establish honest baseline from C2

**Teach:** Show unmodified collection first so the falsified output is obviously defender-caused.

**Run (projected Starkiller on the Windows victim):**

1. Open **Agents** and select the checked-in agent.
2. Open **Shell**.
3. Type `whoami` and submit.

**Expect (Starkiller Shell):** Real `DOMAIN\user` of the agent execution context.

Optional: type `hostname` in the same Shell panel.

**Say:** "That is what the adversary operator currently trusts. We are about to poison that channel without killing the agent."

---

### 5.2 Locate the Empire agent PowerShell host

**Teach:** Same PID method as 4.3. The agent lives in a `powershell.exe` host separate from the defender debug window. Skip `$PID` and any leftover `RunspaceDebugging.ps1` host. The agent is the other command line (stager / encoded launcher).

**Run (Window B on victim):**

```
$MyDebugPid = $PID
Write-Host "Defender session PID (do not attach):" $MyDebugPid

Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine |
  Format-List

Get-PSHostProcessInfo |
  Where-Object { $_.ProcessId -ne $MyDebugPid } |
  Format-Table ProcessName, ProcessId, AppDomainName, MainWindowTitle -AutoSize
```

**Expect:** Candidate `ProcessId`(s). Prefer the command line that is **not** `-File ...RunspaceDebugging.ps1` and **not** `$MyDebugPid`. Start time should align with staging and remain after check-in.

**Transition note:** Do **not** race a Shell `whoami`. Use **arm → attach (wait) → orient → command breakpoint → continue → task → manipulate**.

---

### 5.3 Enter the agent host and select `Runspace1`

**Run (Window B):**

```
Enter-PSHostProcess -Id <AGENT_HOST_PID>
Get-Runspace
```

Use bare `Get-Runspace` (or `Get-Runspace | Format-Table` with no property list). Do **not** run `Get-Runspace | Format-Table Id, Name, State, Availability` — after `Enter-PSHostProcess`, selected `State` / `Availability` columns blank out even though the default view shows them correctly.

**Expect (typical):**

```
 Id Name            ComputerName    Type          State         Availability
 -- ----            ------------    ----          -----         ------------
  1 Runspace1       localhost       Local         Opened        Available
  2 RemoteHost      localhost       Local         Opened        Busy
```

**Instructor notes:**

- **`RemoteHost`** is the `Enter-PSHostProcess` attach channel. `Debug-Runspace` on it fails with `DebugRunspaceCannotDebugHostRunspace`.
- **`Runspace1`** hosts `Invoke-Empire`. Debug that Id (commonly `1`).
- Do **not** filter or select `Availability` / `State` as properties — remoted objects often will not expose them even when the default table displays them.

**Say:** "Busy on RemoteHost means _we_ are attached, not that Empire is running shell code there."

---

### 5.4 Arm, attach, and land inside `Invoke-Empire`

**Teach:** Correct order removes timing pressure.

1. `Enable-RunspaceDebug` on `Runspace1`
2. `Debug-Runspace` and leave it waiting if needed
3. Optionally nudge activity (next check-in / short task) until you break into agent code
4. Orient with call stack and `l` — confirm you are in `Invoke-Empire`

**Run (Window B):**

```
Enable-RunspaceDebug -RunspaceId 1
Debug-Runspace -Id 1
```

If attach waits, leave it. When broken in (or after a brief Starkiller Shell nudge), run:

```
Get-PSCallStack | Format-List *
```

**Teach — what that command is:** `Get-PSCallStack` is the live call stack of the runspace you are debugging (`k` at `[DBG]` is the short alias). Default table view hides most properties. `Format-List *` prints every field — **Command**, **Arguments**, **Location** — so you can prove you are inside **`Invoke-Empire`** (later **`Invoke-ShellCommand`**), not a random `<ScriptBlock>` or the `RemoteHost` attach channel. Arguments often include listener URL and session keys; project carefully.

**Expect (validated against this lab agent):** Top frames similar to:

```
Command         Arguments
-------         ---------
Invoke-Empire   {Servers=http://...:8080, StagingKey=..., SessionKey=...}
Start-Negotiate {...}
<ScriptBlock>   {}
```

That proves you are inside the in-memory agent, not a file-backed script.

**Teach — debugger help first:** At the `[DBG]` prompt, `?` (or `h`) prints the PowerShell debugger command cheat sheet. Run it once so the class sees that `l`/`list`, `c`/`continue`, `s`/`stepInto`, `n`/`stepOver`, and `k`/`Get-PSCallStack` are normal debugger verbs — not Empire-specific tricks.

**Run:**

```
?
```

**Expect (excerpt — keys instructors should call out):**

```
 s, stepInto         Single step (step into functions, scripts, etc.)
 v, stepOver         Single step (step over functions, scripts, etc.)
 o, stepOut          Step out of the current function, script, etc.
 c, continue         Continue operation
 q, stop             Stop operation and exit the debugger
 k, Get-PSCallStack  Display call stack
 l, list             List source code for the current file.
                     Use "list" to start from the current line, "list <m>"
                     to start from line m, and "list <m> <n>" to list n
                     lines starting from line m
 ?, h                Repeat this display
```

**Teach — what `l 1 200` means:** `l` is the debugger **list** command (alias of `list`). With no args it shows a small window around the current line. With two numbers it means:

- first number = **start line**
- second number = **how many lines** to show

So `l 1 200` means: list **200 lines starting at line 1** of the script currently under the debugger — here, the in-memory `Invoke-Empire` agent body. That is how you survey the agent without a `.ps1` on disk. Same listing idea as `l 1 30` on the short discovery script; the agent is just larger.

**Run:**

```
l 1 200
```

Optional follow-ups while teaching:

```
l          # window around the current (*) line only
l 130 50   # jump near Invoke-ShellCommand (approx. starting line from this lab agent)
```

**Teach while scrolling (key landmarks instructors should point at):**

|Landmark|What it is|Why it matters|
|---|---|---|
|`function Invoke-Empire { ... }`|Agent main body|Overall foothold loop, C2 servers, staging/session keys in parameters|
|`function Get-Sysinfo { ... }`|Host survey helper|Later tasking type can return domain/user/hostname/IP without a shell|
|`function Invoke-ShellCommand { ... }`|Shell task executor|**Primary demo target** for Starkiller **Shell** commands|
|Inside `Invoke-ShellCommand`, `if ($cmd.ToLower() -eq 'shell')`|Path for GUI `whoami`|Runs `iex "$cmdargs" \\| Out-String` into `$output`|
|`'(whoami\|getuid)' { $output = [Security.Principal.WindowsIdentity]::GetCurrent().Name }`|Alternate whoami path|Uses **.NET**, not `whoami.exe` — a `whoami` **command** breakpoint can miss this branch|
|Main `while ($True)` loop / `Start-Sleep` / `$GetTask`|Agent check-in loop|Why you often first break idle in the loop (`*` near sleep/task poll), not mid-shell|

**Instructor security note:** `l` can display C2 URLs and keys in parameter defaults/arguments. Project carefully; do not leave screenshots in student shares.

**Say:** "Empire did not give us a `.ps1` path. Everything we need to falsify is a function living in this runspace."

---

### 5.5 Set a _command_ breakpoint (no script path), then task

**Teach:** Because the agent is a `<ScriptBlock>` with no file, use a command breakpoint. Clear any leftover breakpoints first — a second `Set-PSBreakpoint` does **not** replace the first. Two armed BPs means `[DBG]` fires twice and extra `c` looks like the implant is stuck.

```
Get-PSBreakpoint
Get-PSBreakpoint | Remove-PSBreakpoint
Set-PSBreakpoint -Command Invoke-ShellCommand
```

`Get-PSBreakpoint` lists Id, type, and command/variable. Piping to `Remove-PSBreakpoint` clears **all** of them in this debug session so the next set is the only one. To drop a single Id: `Remove-PSBreakpoint -Id <n>`.

Optional backup if shell uses IEX heavily — remove first, then set **only** this one (do not leave `Invoke-ShellCommand` armed unless you want two hits):

```
Get-PSBreakpoint | Remove-PSBreakpoint
Set-PSBreakpoint -Command Invoke-Expression
```

Then continue so the agent returns to its check-in loop:

```
c
```

**Instructor mechanics — `c` and Enter (read before you task):**

- After arming the breakpoint, enter `c` **repeatedly**. The implant stays paused at `[DBG]` until you continue; the check-in loop will not run otherwise. You will often need several `c` presses to get past the current stop and let Empire keep living.
- **Every** Starkiller Shell command hits `Invoke-ShellCommand` again. At each hit, either finish Path A/B (5.6/5.7) or press `c` if you are only letting the agent live.
- After you submit `whoami` in Starkiller, click back to the elevated PowerShell debug window and press **Enter** if `[DBG]` does not appear. The break is often waiting until that window has focus/Enter.

**Say:** "We arm on `Invoke-ShellCommand` — that is the function Empire uses when the operator types a Shell command. The short command is the trigger, not a race."

**Run (projected Starkiller — only after `c` returned the agent to running):**

Agents → select the agent → **Shell** → type `whoami` and submit. Then click Window B and press Enter if needed.

**Expect:** Debugger breaks as Empire enters `Invoke-ShellCommand`. Confirm:

```
Get-PSCallStack | Format-List Command, Arguments
l
Get-Variable cmd, cmdargs, output -ErrorAction SilentlyContinue
```

**Teach — why those variables:** This is a landing check, not the overwrite.

- `cmd` and `cmdargs` prove you are in `Invoke-ShellCommand` and show what C2 asked. For Starkiller Shell `whoami` you should see roughly `$cmd = 'shell'` and `$cmdargs` containing `whoami`.
- `output` is the Path A timing gate. Empty or missing = **too early** (function entry; `iex` has not run). A populated identity string = safe to overwrite in 5.6.
- `-ErrorAction SilentlyContinue` because `$output` often does not exist yet at the first break. That is expected — do not `Set-Variable` / `$output =` here.

Optional longer Shell command if you need time to step with the class: `ping -n 30 127.0.0.1`.

---

### 5.6 Path A: corrupt `$output` before it returns to C2

**Teach:** Starkiller Shell `whoami` on this agent uses the **.NET `whoami|getuid` branch** (`[Security.Principal.WindowsIdentity]::GetCurrent().Name`), not `iex` first. `$output` is written **twice**: empty init (`$output = '';`), then the real identity. A write-watch therefore hits twice. Assign the decoy only on the **second** hit. If you assign on the empty hit and `c`, the agent overwrites your decoy with the real account and C2 still shows truth. Gate on **Value populated**, not a line number (lines drift).

**Say:** "Path A is surgical Software Manipulation: leave the agent alive, change what `$output` carries home."

**Run:** Remove leftover breakpoints (including the 5.5 command BP), then arm the write-watch:

```
Get-PSBreakpoint
Get-PSBreakpoint | Remove-PSBreakpoint
Set-PSBreakpoint -Variable output -Mode Write
c
```

If you keep the 5.5 command BP, you also hit function entry. Do not do that for this Path A.

**Hit 1 (empty — `c`, do not assign).** `Get-Variable -Name output` is empty. On this lab agent that is near `$output = '';` (about line 138).

```
Get-Variable -Name output
c
```

**Hit 2 (real identity — now assign).** Write-watch fires again. `Get-Variable` shows the real account (example: `ACTEC-HOST\Administrator`). On this lab agent that is the `whoami|getuid` / `GetCurrent().Name` assignment (about line 276).

```
Get-Variable -Name output
$output = "varensk\decoy_operator"
Get-Variable -Name output
c
```

Assign with `$output = ...` at the `[DBG]` prompt. Do **not** use `Set-Variable` — it often writes a different scope, and C2 still gets the truth. Then `c` (possibly more than once) so the packet returns to Starkiller. After Path A, restore `Set-PSBreakpoint -Command Invoke-ShellCommand` if 5.7 still needs a command break (`Get-PSBreakpoint | Remove-PSBreakpoint` first).

Optional: instead of the write-watch, stay on the 5.5 command break and step with `n` until `Get-Variable output` shows the real identity, then assign. Same rule — empty Value means too early.

**Expect (Starkiller Shell):** Result shows `varensk\decoy_operator` (or your decoy), not the real account.

**If C2 still shows truth:** You assigned on hit 1 (`$output = '';`) and the second write put the real identity back. Re-arm the write-watch (`Get-PSBreakpoint | Remove-PSBreakpoint` then `-Variable output -Mode Write`), `c` through the empty hit, assign only when Value is populated, or skip to **5.7**.

**Say:** "The operator just recorded a lie. Their follow-on decisions are now working from defender-controlled data."

---

### 5.7 Path B: redefine `Invoke-ShellCommand` in memory

**Teach:** Same privilege, deeper disruption — replace the entire shell helper the way the discovery-script walkthrough replaced `Get-ThemProcesses`. `Invoke-ShellCommand` is **nested inside `Invoke-Empire`**. A new `function Invoke-ShellCommand { }` at `[DBG]` is a **different** function (debugger/global scope). Empire keeps calling the nested original, so C2 stays honest.

**Do not expect decoy on the first execution after this breakpoint.** You are already inside the **old** body. Detach lets that call finish with real `whoami`. Persist is the **next** Starkiller Shell command after you `Set-Item` and detach.

**Demo: use a new agent for each Path B beat.** The in-memory replace persists until that implant dies. Do not stack the all-commands stub and the optional whoami-only wrap on the same agent — the stub already ate the original helper. Easier live path: prove the stub on one agent, then stage a **new** launcher (same listener; lab_env README (not in this Moodle backup)), attach to the **new** `ProcessId` (5.1–5.5), and run the wrap there. Leave or kill the first agent in Starkiller so you do not attach to the wrong host.

**Say:** "Path B is coarser but robust: every later shell task Empire asks this function to run now emits our fiction."

**Run (at the `Invoke-ShellCommand` break, or idle in `Invoke-Empire`):** Replace the existing item. Do not declare a new function.

```
Get-ChildItem function:\ | Where-Object { $_.Name -eq 'Invoke-ShellCommand' }
Set-Item Function:\Invoke-ShellCommand -Value {
    param($cmd, $cmdargs="")
    return "`nvarensk\decoy_operator`n"
}
(Get-Item Function:\Invoke-ShellCommand).ScriptBlock
```

**Expect:** Printed ScriptBlock is the decoy body, not the original `iex` / `GetCurrent()` helper.

**Detach after the in-memory replace.** The new function lives in the agent process, not in Window B. Staying at `[DBG]` pauses check-ins. Debugger `q` can **terminate** the implant. First use: `d` (Detach) releases the debugger and lets the current call finish; `Exit-PSHostProcess` leaves the attached host so Window B is a normal elevated prompt again.

```
Get-PSBreakpoint | Remove-PSBreakpoint
d
Exit-PSHostProcess
```

**Expect:** Window B is no longer inside the agent. The agent `powershell` process is still running. **Starkiller may still show the real account for this in-flight `whoami`.** That is expected — persist is the next Shell command.

**Run (projected Starkiller — new command, not the one that caused this break):**

Agents → select the agent → **Shell** → type `whoami` and submit.

**Expect:** Decoy string. Optional second command (`hostname`) still decoy — that is the 4.12 analog.

**If ScriptBlock looks replaced but C2 is still honest on the next command:** You were not replacing the nested item. Re-attach, `c` until `Get-PSCallStack` shows `Invoke-Empire` (not inside `Invoke-ShellCommand`), run the same `Set-Item`, detach again (`d` then `Exit-PSHostProcess`), then task again.

**Optional — whoami only, other Shell tasks honest:** Do this on a **new** agent, not the one that already has the all-commands stub. `Set-Item` replaces the whole helper. A match `if` with no saved original returns `$null` for every other command, so `hostname` and the rest look dead. Capture the original ScriptBlock **before** `Set-Item`, then invoke that copy. Do not call `Invoke-ShellCommand` by name (recursion). Do not re-implement `else` with `iex` (misses Empire's `$cmd` switch and the `.NET` `whoami|getuid` branch). Starkiller Shell `whoami` is `$cmd = 'shell'` with `whoami` in `$cmdargs` — match both. Same persist and detach rule as the stub.

```
$orig = (Get-Item Function:\Invoke-ShellCommand).ScriptBlock
Set-Item Function:\Invoke-ShellCommandOrig -Value $orig
Set-Item Function:\Invoke-ShellCommand -Value {
    param($cmd, $cmdargs="")
    if ("$cmd $cmdargs" -match '(?i)\bwhoami\b') {
        return "`nvarensk\decoy_operator`n"
    }
    & (Get-Item Function:\Invoke-ShellCommandOrig) $cmd $cmdargs
}
(Get-Item Function:\Invoke-ShellCommand).ScriptBlock
Get-PSBreakpoint | Remove-PSBreakpoint
d
Exit-PSHostProcess
```

**Expect:** Next Starkiller `whoami` is decoy; `hostname` (and other Shell tasks) honest.

**Say:** "Collection quality collapses while the check-in loop keeps the foothold looking alive."

---

### 5.8 Contrast kill vs manipulate (discussion beat)

**Say:**

> "Killing the agent ends observation and tips the adversary that the host is hostile. Manipulation keeps the channel open while we waste their analyst cycles and corrupt downstream planning. That is why EAC0014 belongs in the ENGAGE option set next to D3 hardening moves — different effect, same mission thread.
> 
> And notice what made this possible: we read the live agent with `l`, found `Invoke-ShellCommand`, and changed behavior without ever finding a file on disk."

Optional projection: agent `powershell` process still present while C2 returns fiction.

---

## 6. Consolidated Troubleshooting

|Symptom|Likely cause|Fix|
|---|---|---|
|`Enter-PSHostProcess` access denied|Defender not admin, or target runs as different user without admin override|Relaunch Window B elevated; confirm admin role (`Administrator` / range password)|
|Cannot enter host|Trying to attach to current session (`$PID`)|Pick the `ProcessId` from `CommandLine` (`RunspaceDebugging.ps1` or Empire stager), not Window B|
|`Get-PSHostProcessInfo` `Id` column blank|Property is **`ProcessId`**, not `Id`|`Format-Table ProcessName, ProcessId, ...`|
|Several `powershell.exe` hosts; unsure which to attach|Window A is busy so `$PID` is not available there|`Get-CimInstance Win32_Process` and match `CommandLine`; optional Task Manager Command line column|
|`Get-Runspace` shows `RemoteHost` Busy and `Runspace1` Available|Normal after `Enter-PSHostProcess`|Debug **`Runspace1`**, not `RemoteHost`|
|`Where-Object { $_.Availability -eq "Busy" }` returns nothing|Remoted session: Availability display ≠ filterable property|Identify by `Name` (`Runspace1` vs `RemoteHost`) and Id from default `Get-Runspace` table|
|`Get-Runspace \\| Format-Table Id, Name, State, Availability` blanks State/Availability|Remoted session: selecting those properties does not deserialize them|Use bare `Get-Runspace` or `Get-Runspace \\| Format-Table` with no property list|
|`DebugRunspaceCannotDebugHostRunspace` / cannot debug default host Runspace|Used `Debug-Runspace` on `RemoteHost` (attach channel)|`Enable-RunspaceDebug -RunspaceId 1` then `Debug-Runspace -Id 1` (or whatever Id `Runspace1` has)|
|`Debug-Runspace` waits / unavailable on `Runspace1`|Runspace idle until next Empire task / script loop|Expected after arm/attach — **then** task from Starkiller Shell (or wait for the discovery-script loop); do not abandon the wait to race a short command|
|Tried to attach _during_ Shell `whoami`|Empire shell tasks are too brief|Arm + `Debug-Runspace` first; set `-Command Invoke-ShellCommand`; `c` (repeatedly); **then** task|
|`Set-PSBreakpoint -Script` fails / no path (Empire walkthrough)|Empire agent is in-memory `<ScriptBlock>` / `Invoke-Empire`|Use `Set-PSBreakpoint -Command Invoke-ShellCommand` (or `Invoke-Expression`); never expect a `.ps1` path|
|`Set-PSBreakpoint -Command whoami` never hits|Starkiller Shell `whoami` uses `iex "$cmdargs"`; bare whoami path may use `.NET GetCurrent().Name`|Break on `Invoke-ShellCommand` or `Invoke-Expression`; corrupt `$output` after populate|
|Breakpoint never hits (discovery script)|Wrong script path or line number|Confirm `$env:USERPROFILE\Desktop\Runspace-Demo\RunspaceDebugging.ps1` line 15 / 21; list with `l 1 30` first|
|After `C:\lol.exe`, next loop still decoy / never returns to notepad|Instructor swapped `$NotepadPath` again at the second line-15 break|At the second break, `Get-Variable` only, then `c` with no `Set-Variable`|
|Extra `[DBG]` hits / need `c` twice per Shell command|Leftover breakpoint; `Set-PSBreakpoint` stacked a second one|`Get-PSBreakpoint` then `Get-PSBreakpoint \\| Remove-PSBreakpoint` before arming a new BP|
|Breakpoint never hits (Empire walkthrough)|Command BP not set, `c` not run, or debug window idle|After attach/orient: remove leftover BPs, `-Command Invoke-ShellCommand`, `c` repeatedly, then Starkiller Shell `whoami`. Click Window B and press **Enter** if `[DBG]` does not appear|
|C2 still shows honest output after write-watch|Assigned decoy on hit 1 (`$output = '';`); hit 2 wrote the real identity|`c` through the empty hit; assign `$output = "varensk\decoy_operator"` only when `Get-Variable output` shows the real account|
|Path B still honest after redefine|`function Invoke-ShellCommand { }` at `[DBG]` created a second function; or you judged the in-flight packet|`Set-Item Function:\Invoke-ShellCommand`; confirm `.ScriptBlock`; current breakpoint's packet still returns real `whoami`; persist is the **next** Shell command after detach|
|whoami decoy works; other Shell commands empty/fail|Path B replacement has no passthrough; `if` match returns decoy and everything else falls off the end (`$null`)|Save original ScriptBlock before `Set-Item`; invoke `Function:\Invoke-ShellCommandOrig` for non-whoami. Do not call `Invoke-ShellCommand` by name (recursion)|
|Agent paused / no check-ins after arming BP|Left sitting at `[DBG]`, or used `q` (quit) instead of Detach|After Path B, remove BPs, `d` (Detach), then `Exit-PSHostProcess`. Do not `q` — that can kill the implant. Before Path B, `c` as needed so check-ins continue|
|Empire agent missing / dies mid-demo|Listener unreachable, or Defender realtime re-enabled|`Test-NetConnection`; re-run `Get-MpComputerStatus` and `Set-MpPreference -DisableRealtimeMonitoring $true` if RTP is True|
|Discovery script prints "Target process not found"|Notepad not running|`Start-Process notepad` before script|
|Debugger detaches unexpectedly|Script loop ended or process died|Restart script or re-stage agent for next class|

**Confirmation commands:**

```
# Still attached?
Get-Runspace

# Which powershell hosts remain?
Get-PSHostProcessInfo | Format-Table ProcessName, ProcessId, AppDomainName -AutoSize
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine

# Empire agent process still alive?
Get-Process powershell | Select-Object Id, StartTime
```

---

## 7. Debrief and ENGAGE Tie-Out

**Say:**

> "This demo mapped to **EAC0014 Software Manipulation** under ENGAGE **Affect**, specifically the **Disruption** approach: we increased adversary cost by corrupting collection output without shutting them down.
> 
> In the Varensk/Lunovia scenario, Units 2213 and 9931 are associated with Empire-style C2. A Lunovia element with local admin on an engaged host can degrade what those operators collect — paths, users, hostnames — by manipulating PowerShell in memory.
> 
> The technique generalizes beyond PowerShell: the lesson is that **defenders with legitimate privileged access can reshape software behavior at runtime**. Runspace debugging is simply a clean, native example on Windows."

**Discussion prompts:**

1. How does this change the adversary's cost-value proposition if they cannot trust returned shell output?
2. When would you choose manipulation over isolation or kill?
3. What collection would prove the defender action occurred (Event ID 4104, process access, debugger attachment)?

**Instructor reference (do not assign as reading):** Lee Holmes, _HoneyBotting: Extracting confessions from client-side implants_ (PowerShell Conference EU 2019) — original defender-oriented runspace debugging demo including Empire output control.

---

## 8. Reset and Teardown

**Discovery-script cleanup (Windows victim):**

```
# Window A: stop script
Ctrl+C

# Window B: exit host attachment if still connected
Exit-PSHostProcess
```

**Empire-walkthrough cleanup:** Path B already detached (`d` then `Exit-PSHostProcess`). If Window B is still inside the agent, detach the same way — do not `q`. Then in Starkiller, kill the agent from the Agents view (do not use the Empire CLI unless that is all you have).

```
Get-Process powershell
# Confirm agent host is gone; defender window may remain
```

**Ops station** (this Module `lab_env`, not the `legacy/` archive):

```
cd "PowerShell Runspace Debugging/lab_env"
docker compose --env-file instructor.env down
```

Optional full reset including listener data and Starkiller users:

```
docker compose --env-file instructor.env down -v
```

Prefer Starkiller (Windows-host browser for the live demo; Kali `127.0.0.1` for stager copy). CLI is optional: `docker exec -it w1-runspace-empire ./ps-empire -f client`.

**Pre-next-class:** regenerate stager one-liner; do not reuse committed payloads.

---

## Summary

This demonstration showed **MITRE ENGAGE EAC0014 Software Manipulation** using PowerShell's built-in runspace debugging. In the discovery-script walkthrough, the instructor attached to a looping discovery script, showed line 15 before breaking on it, swapped `$NotepadPath` for one iteration, proved the next loop rebuilt the real Notepad path, then redefined `Get-ThemProcesses` at the line-21 call site. In the Empire walkthrough, the same privileged position entered a live in-memory Empire agent (`Invoke-Empire`), broke on **`Invoke-ShellCommand`**, and either corrupted **`$output`** or redefined that function so C2 received defender-controlled fiction. The counterstrike effect is **disruption through falsified collection** while preserving the adversary session for continued engagement analysis.