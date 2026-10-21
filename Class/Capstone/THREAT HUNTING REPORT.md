**Report ID:** TH-2026-006-BLUENET  
**Incident Name:** BlueNet Workstation Compromise – Operation Silent Sync (Specific Incident)  
**Date of Report:** June 11, 2026  
**Prepared By:** USA Threat Hunting Team  
**Classification:** For Official Use (FOU)

## 1. Executive Summary

During proactive threat hunting on the BlueNet network's, the USA Threat Hunting Team identified a compromised workstation **bluenet-Blue05**. The intrusion involved deployment of a lightweight beacon with persistence and exfiltration capabilities.

Key discoveries of this Threat Hunt:

- Method of initial access was not able to be confidently determined
- Deployment of a beacon at `C:\users\public\libraries\agent.exe`
- Persistence via HKLM Run key named "OfficeUpdateAgent"
- Exfiltration handled through a masquerading service `SyncSvc` (binary at `C:\programdata\filesync\syncsvc.exe`) supported by multiple PowerShell scripts in `C:\ProgramData\FileSync\`
- Observed network connections from internal IP `172.16.3.7` (high ephemeral port) to external redirector `192.51.100.200:80`

The activity was detected during routine hunting and contained quickly. This report provides a detailed technical breakdown of the observed kill chain for analysis of ISB Unit 18 “Amber Tide” TTP's.

**Severity:** Medium-High  
**Status:** Contained  
**Business Impact:** Potential data exfiltration from a single workstation; no evidence of lateral movement or widespread compromise.

## 2. Incident Timeline

| Date / Time   | Event                                                                                    | Detection / Evidence                     |
| ------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------- |
| Late May 2026 | Suspected initial access (method unknown)                                                | No clear logs available                  |
| Day 0         | Beacon dropped to `C:\users\public\libraries\agent.exe`                                  | File creation / anomaly scan             |
| Day 0–1       | HKLM Run key "OfficeUpdateAgent" created                                                 | Registry analysis                        |
| Day 1         | Malicious service `SyncSvc` installed + supporting scripts in `C:\ProgramData\FileSync\` | Services / File system enumeration       |
| Day 1–Ongoing | Beacon and service maintain C2 via redirector                                            | Network connections (high-port outbound) |
| June 8, 2026  | USA Threat Hunting Team detected anomalies → containment                                 | Proactive hunt findings                  |

## 3. Threat Actor Attribution

- **Threat Actor:** ISB Unit 18 “Amber Tide”
- **Objective of this Campaign:** Establish persistent access and exfiltrate data via disguised service and redirector infrastructure. Emphasis on blending into legitimate-looking traffic and system processes.

## 4. Technical Analysis

### 4.1 Initial Access

Initial access vector was not able to be determined with confidence. No clear evidence of phishing, exploit, or credential compromise was recovered from available logs.

### 4.2 Execution

The primary beacon `agent.exe` was executed from the public user libraries directory. This provided the actor with command-and-control (C2) capabilities on the compromised host `bluenet-Blue05`.

### 4.3 Persistence

The threat actor established persistence through a registry Run key:

- **HKLM Run Key:** `OfficeUpdateAgent`  
    Value pointing to: `C:\users\public\libraries\agent.exe`

This ensures the beacon restarts with the system, masquerading as a legitimate Office update process.

### 4.4 Command and Control (C2)

The beacon maintained outbound communication through a redirector. Netstat analysis revealed connections originating from `172.16.3.7` (the compromised workstation) using random high ephemeral ports to `192.51.100.200:80`. The threat hunting team assesses `192.51.100.200` as a C2 redirector.

### 4.5 Actions on Objectives

Limited data was available on post-exploitation activities. The focus appeared to be maintaining access and preparing data channels for exfiltration.

### 4.6 Exfiltration

Exfiltration was facilitated by a running service named **SyncSvc** located at:  
`C:\programdata\filesync\syncsvc.exe`

The service directory `C:\ProgramData\FileSync\` contained several supporting files:

- `file_sync.ps1` (15KB) – Primary script executed periodically by the service (referenced in SyncSvc.xml)
- `file_sync_service_runner.ps1`, `install_file_sync_service.ps1`, `new_encrypted_sync_config.ps1`
- Service configuration: `SyncSvc.xml`
- Logs: `SyncSvc.wrapper.log`, `SyncSvc.out.log`, `SyncSvc.err.log`
- Binary: `SyncSvc.exe` (~18MB)

This service masquerades as a legitimate file synchronization tool. The `file_sync.ps1` script is invoked by the service wrapper to handle data staging and outbound transfer through the redirector channel.

## 5. Impact Assessment

- **Systems Affected:** Single workstation – `bluenet-Blue05`
- **Data at Risk:** Potential access to user files, documents, and local network resources on the compromised host.
- **Actual Exfiltration:** Unknown
- **Risk Level:** Medium-High (persistent foothold on a BlueNet asset).

## 6. Detection & Response Actions Taken

**Detection Method:** Proactive threat hunting (suspicious service enumeration, registry Run key anomalies, unusual outbound connections to known redirector patterns, and file path analysis in public directories).

**Containment & Eradication:** - Isolated `bluenet-Blue05` from the network. - Terminated `SyncSvc` service and removed `agent.exe`. - Deleted malicious HKLM Run key. - Re-imaged the workstation from a clean baseline.

**Recovery:** System returned to service with enhanced monitoring and logging enabled.

## 7. Indicators of Compromise (IOCs)

**File Paths / Artifacts:** - Beacon: `C:\users\public\libraries\agent.exe` - Service binary: `C:\programdata\filesync\syncsvc.exe` - Service directory: `C:\ProgramData\FileSync\` - Registry key: `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\OfficeUpdateAgent`

**Network:** - Outbound connections: `172.16.3.7:<high-port>` → `192.51.100.200:80` (suspected redirector) - HTTP traffic patterns consistent with C2 beaconing

**Persistence & Services:** - Service name: `SyncSvc` - Masquerading Run key: `OfficeUpdateAgent`

## 8. Recommendations & Hunting Guidance

**Immediate Hunting Queries:** 1. Enumerate all HKLM/HKCU Run and RunOnce keys for anomalous entries. 2. Review services (`sc query` or `Get-Service`) for suspicious names/binaries in `C:\programdata\`. 3. Hunt for unexpected executables/scripts in `C:\users\public\libraries\`, `C:\ProgramData\FileSync\`, and similar world-writable locations. 4. Monitor netstat / network flows for high-port outbound connections to non-standard external IPs. 5. Baseline and alert on new services with "Sync" or update-related naming.

**Long-term Hardening:** - Restrict write access to public user directories. - Implement application allow-listing / EDR rules for registry Run keys. - Monitor and baseline legitimate services. - Block or heavily inspect outbound HTTP/80 traffic to unknown destinations. - Regular proactive hunts for persistence mechanisms.

Full IOC package, hunting scripts, and lab VM artifacts available upon request for classroom exercises.

## 9. Malicious Artifacts Overview

**9.1 Beacon and Persistence Analysis:**

The primary implant was installed at `C:\users\public\libraries\agent.exe`. Persistence was achieved via the following registry modification (visible via `reg query`):

```
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
    OfficeUpdateAgent    REG_SZ    C:\users\public\libraries\agent.exe
```

This classic Run key technique ensures execution at boot/logon under the context of the logged-in user.

**9.2 Exfiltration Service Analysis:**

The exfiltration component runs as a Windows service named **SyncSvc** located at `C:\programdata\filesync\syncsvc.exe`. The service directory `C:\ProgramData\FileSync\` contained several supporting PowerShell scripts and configuration files.

**Directory Listing of C:\ProgramData\FileSync\ (excerpt):**

```
Directory: C:\ProgramData\FileSync

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        4/28/2026   1:11 PM          15291 file_sync.ps1
-a----        4/28/2026   1:53 PM           1887 file_sync_service_runner.ps1
-a----        4/28/2026   1:55 PM           2261 install_file_sync_service.ps1
-a----        4/28/2026   2:54 PM           3228 new_encrypted_sync_config.ps1
-a----        4/28/2026   2:15 PM              0 SyncSvc.err.log
-a----        4/28/2026   2:08 PM       18286774 SyncSvc.exe
-a----        4/28/2026   2:15 PM              0 SyncSvc.out.log
-a----        6/10/2026   9:04 AM           2251 SyncSvc.wrapper.log
-a----        4/28/2026   2:12 PM            642 SyncSvc.xml
```

The `file_sync.ps1` script (the primary exfiltration logic) is executed periodically by the service as defined in `SyncSvc.xml`.

**Key elements from `file_sync.ps1` analysis:**

- **Configuration:** Supports encrypted config via AES (decrypted with passphrase from `new_encrypted_sync_config.ps1` or parameters). Configures watch directories, allowed file extensions (`.docx`, `.xlsx`, `.pdf`, keys, etc.), SSH key path, remote SFTP/SCP target.
- **File Discovery:** Scans fixed drives or specified directories for new/changed files using SHA256 hashing and state tracking in `C:\ProgramData\file_sync_state.json`.
- **Staging:** New files are archived into timestamped ZIP files in `C:\ProgramData\SyncCache\` with manifest.
- **Exfiltration:** Uses OpenSSH `sftp.exe` or `scp.exe` with private key authentication to upload archives to `RemoteHost = "198.51.100.200"` (user: `intake`, dir: `/srv/intake/uploads`).

This provides a stealthy, targeted file exfiltration capability that prioritizes specific document types and uses SSH over the redirector channel for blending.

**Directory Listing of C:\ProgramData\FileSync\ (excerpt):**

```
Directory: C:\ProgramData\FileSync

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        4/28/2026   1:11 PM          15291 file_sync.ps1
-a----        4/28/2026   1:53 PM           1887 file_sync_service_runner.ps1
-a----        4/28/2026   1:55 PM           2261 install_file_sync_service.ps1
-a----        4/28/2026   2:54 PM           3228 new_encrypted_sync_config.ps1
-a----        4/28/2026   2:15 PM              0 SyncSvc.err.log
-a----        4/28/2026   2:08 PM       18286774 SyncSvc.exe
-a----        4/28/2026   2:15 PM              0 SyncSvc.out.log
-a----        6/10/2026   9:04 AM           2251 SyncSvc.wrapper.log
-a----        4/28/2026   2:12 PM            642 SyncSvc.xml
```

**Network Connection Example (netstat -ano output excerpt):**

```
TCP    172.16.3.7:49152       192.51.100.200:80      ESTABLISHED    <PID of agent.exe or SyncSvc>
```

The use of a public redirector on port 80 helps the traffic blend with normal web activity.

### Prepared by: USA Threat Hunting Lead **___**_ Date: June 11, 2026