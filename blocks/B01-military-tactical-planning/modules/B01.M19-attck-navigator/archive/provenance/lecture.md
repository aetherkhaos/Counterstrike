# MITRE ATT&CK and Navigator

1. Eyes on the adversary, the reconnaissance
2. mapping observed adversary ttps to the mitre attack framework
3. determining the adversary's mission and their EMLCOA
4. Mapping MITRE ATT&CK to D3FEND
5. providing bluespace options to the commander
6. Moving out of bluespace

## Introduction

This lesson bridges the gap between passive data gathering and active defense planning. By mapping observed adversary behaviors to the MITRE ATT&CK framework, students learn how to systematically derive an adversary's mission. Subsequently, by mapping ATT&CK techniques to D3FEND and ENGAGE, students can develop and present multiple courses of action (COAs) to a commander, detailing both defensive ("Bluespace") and offensive ("Moving Out of Bluespace") options.

This lesson transitions our team from passive observers to active participants in the tactical engagement. We will move from the initial reconnaissance of an adversary to developing concrete, data-driven courses of action. We will take the raw data and observables gathered during the hunt, structure them using the MITRE ATT&CK framework, and then use the D3FEND and ENGAGE frameworks to build a set of defensive and offensive options. This process is critical for translating technical findings into tactical decisions that a commander can authorize.

### Reconnaissance: Eyes on the Adversary

This course is assuming that the hunt has been successful. As a hunter, you have found some part of the enemy's activity and now you have a foothold in observing their activity. It really is critical at this stage that you conduct yourself in a way that is not going to alert the enemy that you know about them. If you fail to do so, you reduce the amount of options that you have at your disposal to affect and/or impose costs.

Think about the EMLCOA and our DRAW-D analysis. We have made some informed estimates on what we know or think the enemy is going to do "on-contact". If we are given the explicit mission to conduct reconnaissance, we might be headed towards mission failure by scaring the enemy away. Yes, we will have temporarily shut down their operations. But we will have failed our primary mission of conducting reconnaissance. Unless of course our mission was to report back on what the enemy will do if we make ourselves known to them.

For this discussion, we are going to assume that we have been given the mission of conducting an enemy reconnaissance in order to determine their scheme of maneuver, TTPs, and to derive what their mission is.

It may be obvious what the enemy's mission is but we also have to avoid the "what if" game. Remember, when you have root or system, you can theoretically do what ever you want to the box. Most of the time we will see the EMDCOA listed as something destructive and we need to avoid this. Depending on the enemy, whether its a military intelligence/T10 equivalent verses a T50 equivalent, they may not have the authority or desire to do a destructive act.

Before we make a call on what we believe the enemy's mission is, we will use the MITRE ATT&CK Navigator to capture the observables. The ATT&CK Navigator is an excellent tool to visualize intrusions.

### Mapping Raw Data to MITRE ATT&CK

The process of mapping logs and artifacts to ATT&CK techniques is the foundational skill of a threat hunter. We will follow the guidance provided by CISA, focusing on how it applies to our target adversary, FSB Center 18 (Gamaredon).

- Need a demo here. The best way to do this is to have a few representative networks/intrusions.
- The reference we want to use here is the CISA guidance : <https://www.cisa.gov/sites/default/files/publications/Best%20Practices%20for%20MITRE%20ATTCK%20Mapping.pdf>

CISA has guidance on Mapping MITRE ATT&CK into Raw Data which is the exact type of guidance we need.

#### Option 1: Start with a Data Source to Identify the Technique and Procedure

We first have to have a really good understanding of the data source(s) that we have. This is a great time to review the "Observation" section of the friendly OCOKAW. These data sources could be from Windows Event Logs, Sysmon, EDR, netflow, or a slew of other sources. Some questions that may inform analysis:

- What is the object of the adversary's focus? (a file, a driver, a process, etc.)
- What is the action that being performed on the object? (read, write, execute, etc.)
- What techniques require this activity?
- Is there a substantiating activity that can help narrow down which technique occurred?
 	- Use of known tools like the impacket suite or mimikatz
 	- Use of known system components/lolbins/lolbas/gtfobins
  		- <https://lolbas-project.github.io/#>
  		- <https://gtfobins.org/>
 	- Access to specific system components (e.g. the windows registry)
 	- Use of scripts
 	- Identification of specific ports (e.g. 22, 80)
 	- Identification of the protocols involved (e.g. RDP, DNS, SSH, Telnet)
 	- Evidence of obfuscation or deobfuscation
 	- Evidence of a specific device involved (e.g. domain controller) and, if so, evidence of unexpected or inconsistent behavior for that device type.

#### Option 2: Start with Specific Tools or Attributes and Broaden the Aperture

Raw data offers a unique view of an adversary’s actions or tooling. It may be possible to identify their commands via process monitoring event logs, specific file system components that were accessed (e.g., Windows Registry), or even certain software that they used (e.g., mimikatz). An analyst can search the ATT&CK repository to potentially identify techniques or sub-techniques that align with these items. Analysts can also leverage them as a source of further exploration of related techniques. For example, if an adversary created a registry key for persistence in HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run to execute
when a computer reboots or a user logs on (i.e., Registry Run Keys / Startup Folder
[T1547.001]), an analyst may be able to explore other behaviors associated with the event. For example, malicious registry entries often masquerade as legitimate entries to avoid detection (Masquerading [T1036]), which is a Defense Evasion [TA0005] tactic.

#### Option 3: Start with Analytics

Detection analytics—or detection rules—are typically operationally implemented within a SIEM platform, which collects and aggregates log data and performs analytics like correlation and detection. The analytics seek to identify malicious adversary activity by analyzing observable events—often a chain of events—within a range of logs, such
as VPN logs, Windows event logs, IDS logs, and firewall logs. Through this analysis, detection analytics may provide insight into additional data sources that may contain artifacts of a specific adversary technique.

- Many organizations share their analytics as open-source material. These include:
 	- Sigma (a standardized rule syntax for SIEMs). Sigma rules contain logic to detect computer processes, commands, and operations. For example, there are multiple Sigma rules related to detecting the credential dumper Mimikatz.
- MITRE’s Cyber Analytics Repository (CAR).
 	- CAR is a knowledge base of rules for detecting a set of ATT&CK tactics, techniques, and sub-techniques.
- LSASS Access from Non System Account.
 	- Also behavior-based, this rule detects non-privileged processes that attempt to access the LSASS process—a critical step in executing Mimikatz to collect credentials from a system.

## Lab Exercise: Mapping the Gamaredon Intrusion

### Objective: Given the intrusion based on the ESET Gamaredon report, students will use the MITRE ATT&CK Navigator to visualize the intrusion and identify the TTPs.

### Execution:

1. Provide teams with a pre-configured, blank ATT&CK Navigator layer.

2. Provide the following log snippets:

	- Log 1 (Email Gateway): An email is delivered with a .lnk attachment.

	- Log 2 (Sysmon Event 1): mshta.exe is observed executing a URL hosted on a .ru domain.

	- Log 3 (Sysmon Event 1): powershell.exe is observed running a command containing Invoke-Expression and a Base64 encoded string.

	- Log 4 (EDR Log): PteroLNK.vbs is observed querying WMI for win32_logicaldisk where mediatype=null.

	- Log 5 (File Auditing): PteroPSDoor.ps1 is observed reading files with extensions .docx, .xlsx, and .pdf from a user's Desktop and writing them to a staging directory in %LOCALAPPDATA%\vector.

3. Task: Students must identify the corresponding ATT&CK technique for each log and color it in their Navigator layer.

### Determining the Adversary's Mission and their EMLCOA

The ATT&CK Navigator layer you just created is not just a heat map; it tells a story. The pattern of techniques reveals the adversary's intent.

The notable absence of techniques in the Impact tactic strongly suggests their mission is not destruction. The heavy concentration in Collection and Credential Access points directly to an espionage mission. This data-driven conclusion validates the EMLCOA we developed in Lesson 2.

### References

- CISA, *Best Practices for MITRE ATT&CK Mapping*
- MITRE ATT&CK: <https://attack.mitre.org/>
- ATT&CK Navigator: <https://mitre-attack.github.io/attack-navigator/>
