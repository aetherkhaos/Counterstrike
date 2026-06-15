## Tactical Planning Process

### METT-TC -> EMLCOA -> CG/CV/EXP. Plan -> SOM -> Tasks

## METT-TC: Estimate of the Situation

### Mission:

reconnoiter enemy greyspace in order to identify avenues of approach. Upon discovery of initial access vectors/opportunities, provide COAs to the commander to achieve initial access.

### Enemy Analysis:

#### SALUTE: Composition, Disposition, Strength

##### Size:
- Unit 18 “Amber Tide” is a Varensk-aligned advanced persistent threat (APT) group operating under the Internal Security Bureau (ISB) of Varensk. Considered a nation state level actor.
##### Activity:
1. **Initial Access**: Spearphishing with LNK/HTA attachments in archives (T1566.001, T1204.001, T1204.002), HTML smuggling, weaponized Microsoft Word documents/templates (T1221), and USB drive weaponization for replication (T1091).
    
2. **Execution & Lateral Movement**: PowerShell (T1059.001) and VBScript (T1059.005) for command execution, WMI for USB discovery (T1047), Metasploit Framework integration, and mass internal propagation.
    
3. **Persistence**: Registry Run keys/Startup folder (T1547.001), logon scripts (T1037.001), Office template macros (T1137.001), scheduled tasks (T1053.005), and fileless registry storage.
    
4. **Defense Evasion**: Obfuscation via command/HTML smuggling/embedded payloads/encrypted files (T1027), masquerading with double extensions and benign registry names (T1036), mshta.exe proxying (T1218.005), hidden files (T1564.001), AMSI bypass, and indicator removal (T1070.004).
    
5. **Discovery & Collection**: Targeted file discovery on local/network/USB drives, browser credential/cookie theft, screen capture, and data staging.

6. **Command & Control**: HTTP/HTTPS with dynamic IP resolution, third-party services (messaging platforms, cloud tunneling), proxies/reverse SOCKS, and frequent domain/IP rotation.
    
7. **Exfiltration**: Over C2 channels after staging (T1041).

##### Location:
- Amber Tide physically located in Varensk and logically operating in Lenovia
##### Unit:
- Unit 18 “Amber Tide”
	- operating under the Internal Security Bureau (ISB) of Varensk
##### Time:
- Late May 2026 - June 8, 2026
##### Equipment:
- 1. **Downloaders/Loaders**: Custom PowerShell (e.g., AmberPSLoad variants) and VBScript (e.g., AmberX, AmberSand, AmberDash, AmberRisk) general-purpose and dedicated downloaders that support encrypted PE files, PowerShell commands, and VBScript payloads (often XOR-encrypted with volume serial number as key).
    
2. **Weaponizers/Droppers**: AmberLNK (PowerShell/VBScript versions) for USB drive weaponization with enticing LNK files (double extensions, conspicuous filenames); AmberDoc and AmberTemplate for weaponizing Word documents/templates with malicious remote references or macros; AmberCDrop (C-based) for delivering VBScript payloads.
    
3. **Stealers & Backdoors**: File stealers (e.g., AmberPSDoor, AmberVDoor variants) targeting specific extensions; browser credential/cookie stealers (AmberSteal, AmberCookie); app-specific stealers (e.g., for messaging clients); screen capture (AmberScreen); remote shells (AmberPShell, ReVBShell); reverse SOCKS proxies (AmberSocks).
    
4. **Ad Hoc/Support**: Metasploit Framework integration, utilities for cloud transfers, and additional payload delivery.
    
5. **Obfuscation & Evasion**: Multi-layer string splitting/concatenation, base64, random variable/function names, registry-based fileless storage, and environmental keying.

---

#### DRAW-D: Capabilities and Limitations

##### Defend:
- Capabilities:
	- **High Resiliency:** Capable of maintaining access despite detection by simultaneously deploying multiple, redundant backdoors. They effectively use fileless registry storage, environmental keying (volume serial number XOR), and AMSI bypass to shield payloads from immediate antivirus blocking.
- Limitations:
	- **Lack of Stealth:** They explicitly do not prioritize stealth. Their defense relies on sheer volume rather than sophistication. Deploying multiple “simple” downloaders simultaneously increases the likelihood of triggering behavioral or heuristic alerts on endpoint detection systems.

##### Reinforce:
- Capabilities:
	- **Aggressive Propagation:** Highly capable of rapid internal spread using built-in Windows tools (PowerShell, VBScript, WMI). They can bridge segmented networks or cross digital-to-physical boundaries using weaponized USB drives (AmberLNK) and internal document sharing.
- Limitations:
	- **High Visibility & User Reliance:** Their mass lateral movement is extremely aggressive and loud, acting as a beacon for threat-hunting teams (as noted in the partner network detection). Furthermore, their USB and document reinforcement relies heavily on continuous user interaction to execute.

##### Attack:
- Capabilities:
	- **Layered Initial Access:** Proficient in bypassing perimeter defenses using HTML smuggling and weaponized templates. They possess highly specialized data collection capabilities, using custom tools to target specific file extensions, browser credentials, and screen captures.
- Limitations:
	- **Dependency on Known Vectors:** The group relies heavily on traditional spearphishing, LNK files, and macros rather than zero-day exploits. While highly successful against Lunovian targets, these same attack methods failed to achieve confirmed breaches during their late-2022 allied partner campaign.

##### Withdraw:
- Capabilities:
	- **Rapid Infrastructure Rotation:** Capable of quickly abandoning compromised Command & Control (C2) servers. They use dynamic IP resolution and frequent domain rotation, allowing them to shift operations instantly. They also possess indicator removal capabilities (T1070.004) to clean up local host artifacts.
- Limitations:
	- **Ineffective Log Evasion:** While they can delete local files or change IPs, the sheer volume of their prior activity (~1 GB data staging, mass script execution across 50+ endpoints) leaves a massive, unerasable footprint in network traffic logs and centralized SIEM solutions.

##### Delay:
- Capabilities:
	- **Analysis Frustration:** Capable of significantly slowing down malware analysts and reverse engineers. They achieve this through multi-layer string splitting, frequent obfuscation updates, proxying execution through `mshta.exe`, and masquerading files with double extensions.
- Limitations:
	- **Alert Fatigue vs. True Delay:** While they successfully delay the _analysis_ of their malware, they fail to delay the _detection_ of their presence. Their aggressive operations generate so much noise that incident response teams are alerted almost immediately, even if decoding the specific payload takes time.

---

### Troops and Fire Support

#### Organic:
- USA Threat Hunting Team
- how many personnel? what are their specialties? Any other attached elements?
#### Higher:
- USCC
#### Adjacent:
- National Cyber Defense Agency (NCDA)
- Digital Infrastructure Protection Corps (DIPC)
- Cyber Auxiliary Reserve
#### Supporting:
- Foreign Cyber Partnerships
- 

---

### Terrain and Weather

#### OCOKAW:

##### Obstacles:

##### Cover and Concealment:

##### Observation:

##### Key Terrain:

##### Avenues of Approach:

##### Weather:

---

### Time/Space/Logistics

---

### Civil Considerations

---

## EMLCOA

### What is the enemy's mission?

### What are they currently doing?

### What will they do on contact?

---

## Center of Gravity

### What is the enemy relying upon to accomplish their mission?

---

## Critical Vulnerability

### What can I take away from the enemy that renders their center of gravity ineffective?

---

## Exploitation Plan

### What is your plan to target the identified critical vulnerability in the enemy system?