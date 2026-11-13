---
id: B01.M08-guide
title: Runspace Debugging — Student Guide
artifact_type: student_guide
audience: student
block: B01
module_type: demo
source_status: canonical
review_required: false
output_formats:
- mkdocs
- pdf
- docx
template_profile: student_guide_v1
sensitivity: course_internal
---

# Runspace Debugging

Follow this on the Windows workstation while the demo runs, or work the same steps on your own. You need an elevated PowerShell window and the discovery script `RunspaceDebugging.ps1` on the Desktop under `Runspace-Demo`. The second walkthrough uses a PowerShell agent that is already running on that host.

Use two windows. Window A runs the script. Window B is the elevated defender session that attaches to Window A.

## Baseline

From Window B, record time, identity, and which PowerShell hosts already exist:

```powershell
Get-Date -Format o
hostname
whoami
Get-Location
$PSVersionTable.PSVersion
Get-Process powershell | Select-Object Id, ProcessName, StartTime, Path
Get-PSHostProcessInfo | Format-Table ProcessName, ProcessId, AppDomainName, MainWindowTitle -AutoSize
Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine
```

`Get-PSHostProcessInfo` uses `ProcessId`. The command line is how you tell the script host from this defender window.

## Discovery script

### Start Notepad and the script

In Window A:

```powershell
Start-Process notepad
cd Desktop\Runspace-Demo
powershell.exe -ExecutionPolicy Bypass -File .\RunspaceDebugging.ps1
```

`-ExecutionPolicy Bypass` applies to this process so the unsigned script can run. `-File` runs `RunspaceDebugging.ps1` as a script. Expect repeating lines like `Found notepad here: C:\Windows\System32\notepad.exe` and `True`, with about ten seconds between loops. Window A stays occupied by that process.

### Find the script host

In Window B:

```powershell
$MyDebugPid = $PID
Write-Host "Defender session PID:" $MyDebugPid

Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine |
  Format-List

Get-PSHostProcessInfo |
  Where-Object { $_.ProcessId -ne $MyDebugPid } |
  Format-Table ProcessName, ProcessId, AppDomainName, MainWindowTitle -AutoSize
```

The `ProcessId` whose command line contains `-File` and `RunspaceDebugging.ps1` is the script host. `$MyDebugPid` is Window B.

### Enter the host and list runspaces

```powershell
Enter-PSHostProcess -Id <TARGET_PID>
Get-Runspace
```

Replace `<TARGET_PID>` with that script-host `ProcessId`. Use the default `Get-Runspace` table. `Runspace1` is the host runspace where the script runs. `RemoteHost` is the attach channel this session created. Debug `Runspace1`.

### Attach

```powershell
Enable-RunspaceDebug -RunspaceId 1
Debug-Runspace -Id 1
```

Use the Id from the `Runspace1` row when it is not `1`. If the debugger reports that it cannot debug the default host runspace, that Id is `RemoteHost`. Switch to the `Runspace1` Id. If the debugger waits, leave it until the next loop in Window A.

At the debugger prompt, `?` lists the keys. `l` lists source, `s` steps into, `n` steps over, and `c` continues.

```text
?
l
l 1 30
```

Line 10 computes `$NotepadPath`. Line 15 reports it. Break on line 15, after the path is computed and before it is printed.

```powershell
Set-PSBreakpoint -Script "$env:USERPROFILE\Desktop\Runspace-Demo\RunspaceDebugging.ps1" -Line 15
c
```

The debugger stops on `Write-Host "Found notepad here:" $NotepadPath`.

### Swap the reported path

```powershell
Get-Variable -Name NotepadPath
Set-Variable -Name NotepadPath -Value "C:\lol.exe"
c
```

Window A prints `Found notepad here: C:\lol.exe` for that loop. On the next hit of line 15, read the variable and continue without assigning:

```powershell
Get-Variable -Name NotepadPath
c
```

`$NotepadPath` is the real Notepad path again. The swap lasted one iteration.

### Replace the function

List the loop (`l 20 5`). Line 21 is the call to `Get-ThemProcesses`.

```powershell
Set-PSBreakpoint -Script "$env:USERPROFILE\Desktop\Runspace-Demo\RunspaceDebugging.ps1" -Line 21
c
Get-ChildItem function:\ | Where-Object { $_.Name -eq "Get-ThemProcesses" }
function Get-ThemProcesses { Write-Host "lol noob hacker is using script based malware" }
c
```

Window A prints that message on later loops. The process is still running. Stop the script with `Ctrl+C` in Window A when you are ready for the agent walkthrough, or leave the debugger with `q`.

## In-memory agent

This walkthrough attaches to a PowerShell agent that is already on the workstation. From the agent's shell, task `whoami` once and note the real account. That is the baseline you will change.

### Find the agent host

In a new elevated Window B:

```powershell
$MyDebugPid = $PID
Write-Host "Defender session PID:" $MyDebugPid

Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" |
  Select-Object ProcessId, CommandLine |
  Format-List

Get-PSHostProcessInfo |
  Where-Object { $_.ProcessId -ne $MyDebugPid } |
  Format-Table ProcessName, ProcessId, AppDomainName, MainWindowTitle -AutoSize
```

Choose the PowerShell host that is the agent. Leave the defender PID and any leftover `RunspaceDebugging.ps1` host.

### Enter, arm, and confirm the agent

```powershell
Enter-PSHostProcess -Id <AGENT_HOST_PID>
Get-Runspace
Enable-RunspaceDebug -RunspaceId 1
Debug-Runspace -Id 1
```

When the debugger breaks in:

```powershell
Get-PSCallStack | Format-List *
?
l 1 200
```

`Get-PSCallStack` shows the live stack. `Format-List *` prints Command, Arguments, and Location. Confirm the top frames are inside `Invoke-Empire`. `l 1 200` lists 200 lines starting at line 1 of the in-memory agent. `Invoke-ShellCommand` is the function that runs a shell task.

### Break on the shell function

A second `Set-PSBreakpoint` does not replace the first. Clear breakpoints, then set one command breakpoint. The agent has no script path, so the breakpoint is on the command name.

```powershell
Get-PSBreakpoint
Get-PSBreakpoint | Remove-PSBreakpoint
Set-PSBreakpoint -Command Invoke-ShellCommand
c
```

Continue until the agent is back in its check-in loop. Then task `whoami` from the agent shell. If the debug window does not show `[DBG]`, click that window and press Enter.

```powershell
Get-PSCallStack | Format-List Command, Arguments
l
Get-Variable cmd, cmdargs, output -ErrorAction SilentlyContinue
```

`cmd` and `cmdargs` show the task. An empty or missing `output` means the function has not written the result yet.

### Change `$output` before it returns

Clear breakpoints and watch writes to `output`. The variable is written twice: once empty, then with the real identity. Assign the decoy on the write that already holds the real account.

```powershell
Get-PSBreakpoint | Remove-PSBreakpoint
Set-PSBreakpoint -Variable output -Mode Write
c
```

On the empty write:

```powershell
Get-Variable -Name output
c
```

On the write that shows the real account, assign at the `[DBG]` prompt and continue:

```powershell
Get-Variable -Name output
$output = "varensk\decoy_operator"
Get-Variable -Name output
c
```

The shell result shows `varensk\decoy_operator`.

### Replace `Invoke-ShellCommand`

`Invoke-ShellCommand` is nested inside `Invoke-Empire`. Replace that function item. A new `function` declaration at the debugger prompt is a different function, and the agent keeps calling the original.

At a break inside `Invoke-Empire`:

```powershell
Get-ChildItem function:\ | Where-Object { $_.Name -eq 'Invoke-ShellCommand' }
Set-Item Function:\Invoke-ShellCommand -Value {
    param($cmd, $cmdargs="")
    return "`nvarensk\decoy_operator`n"
}
(Get-Item Function:\Invoke-ShellCommand).ScriptBlock
Get-PSBreakpoint | Remove-PSBreakpoint
d
Exit-PSHostProcess
```

`d` detaches and lets the current call finish. `Exit-PSHostProcess` returns Window B to a normal prompt. The agent process keeps running. The in-flight `whoami` can still show the real account. The next shell command returns the decoy.

The process stayed up. What changed is the result the operator receives.
