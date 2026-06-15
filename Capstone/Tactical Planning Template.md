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
1. **Initial Access**: Spearphishing with LNK/HTA attachments in archives (T1566.001, T1204.001, T1204.002), HTML smuggling(T1027.006), weaponized Microsoft Word documents/templates (T1221), and USB drive weaponization for replication (T1091).
    
2. **Execution & Lateral Movement**: PowerShell (T1059.001) and VBScript (T1059.005) for command execution, WMI for USB discovery (T1047), Metasploit Framework integration, and mass internal propagation.
    
3. **Persistence**: Registry Run keys/Startup folder (T1547.001), logon scripts (T1037.001), Office template macros (T1137.001), scheduled tasks (T1053.005), and fileless registry storage.
    
4. **Defense Evasion**: Obfuscation via command(T1027.010)/HTML smuggling(T1027.006)/embedded payloads(T1027.009)/encrypted files (T1027.013), masquerading with double extensions and benign registry names (T1036), mshta.exe proxying (T1218.005), hidden files (T1564.001), AMSI bypass, and indicator removal (T1070.004).
    
5. **Discovery & Collection**: Targeted file discovery on local/network/USB drives(T1083), browser credential/cookie theft(T1539), screen capture(T1113), and data staging(T1074.001).

6. **Command & Control**: HTTP/HTTPS with dynamic IP resolution(T1568, T1071.001), third-party services (messaging platforms, cloud tunneling), proxies/reverse SOCKS, and frequent domain/IP rotation.
    
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
- Rear-Echelon Support (USCC/Agencies)

---

### Terrain and Weather

#### Friendly OCOKAW:

##### Obstacles:
- Current Posture: Amber Tide is known for “living off the land” (using native tools like PowerShell or WMI) and employing encrypted Command and Control (C2) channels.
- Analysis:
	- Host-Level: User-mode logs are insufficient here; Amber Tide will likely clear them or bypass user-mode hooks. We absolutely require kernel-level EDR agents deployed across all endpoints to catch their living-off-the-land binaries (LOLBins) and memory-resident malware.
- Network-Level: NetFlow is only good for spotting the volume of their exfiltration, but we need full PCAP at the boundary and passive network taps at critical internal choke points to decrypt or analyze the behavioral signatures of their C2 beacons.
- Blind Spots: We must identify segments where we lack visibility (e.g., legacy systems, unmanaged BYOD devices, or IoT segments) as Amber Tide will use these as safe havens.

##### Cover and Concealment:
- Current Posture: Do we want Amber Tide to know we are hunting them?
- Analysis:
	- Covert Approach (Watching): If our goal is intelligence gathering to understand Amber Tide’s full toolset and ultimate objective, our hunt activities must be highly concealed. We should not use overt active scanning or aggressively kill their shells, as this will burn our presence and cause them to dig deeper or deploy destructive wipers. We would route our analysis tools through obfuscated infrastructure.
	- Overt Approach (Eviction): If the mission shifts to immediate remediation, we drop concealment. We overtly isolate hosts, block their known C2 IPs at the firewall, and actively sweep the domain. We accept that they will know we are onto them.

##### Observation:
- **Current Posture:** What is preventing us from hunting Amber Tide effectively?
- **Analysis:**
    - **Data Acquisition Barriers:** Strict privacy policies, siloed IT departments, or outsourced infrastructure (like a third-party managed cloud) that prevents us from rapidly pulling forensic images or deploying our EDR tools.
    - **Maneuver Barriers:** Highly segmented network enclaves (e.g., air-gapped ICS/SCADA networks). While these keep Amber Tide out, they also act as obstacles for _our_ incident responders trying to push updates or pull telemetry.
    - **Adversary-Created Obstacles:** Amber Tide may have deployed rootkits to blind our EDR, or they might have altered firewall rules to lock us out of management interfaces.

##### Key Terrain:
- **Current Posture:** Why is Amber Tide here, and what must we protect at all costs?
- **Analysis:**
    - While the Domain Controller (DC) is tactical high ground for identity management, it is likely _not_ Amber Tide’s ultimate goal.
    - **Business/Mission Purpose:** If this network facilitates research and development, the Key Terrain is the **engineering database or file shares** containing intellectual property.
    - **Operational Purpose:** If this is a military or logistics network, the Key Terrain might be the **logistics planning applications or the Exchange email servers** where C2 communications happen.
    - We must position our heaviest defenses and most aggressive “Observation” (EDR/taps) around this specific Key Terrain, not just the IT infrastructure.

##### Avenues of Approach:
- **Current Posture:** How did Amber Tide get in, and how might they re-enter?
- **Analysis:**
    - Based on MITRE ATT&CK, advanced actors like Amber Tide frequently utilize:
        - **T1189 Drive-by Compromise / T1566 Phishing:** Spear-phishing targeting the specific personnel who have access to the Key Terrain.
        - **T1190 Exploit Public-Facing Application:** Exploiting zero-days or N-days in edge devices (e.g., VPNs, firewalls, or web servers) that face the internet.
        - **T1078 Valid Accounts:** Purchasing compromised credentials from initial access brokers to walk right through the front door via the VPN.
    - We must seal these avenues by enforcing MFA, patching edge devices, and conducting aggressive email filtering.

##### Weather:
- **Current Posture:** How does the physical world impact this cyber engagement?
- **Analysis:**
    - If our defense relies on cloud-based EDR consoles or remote logging, severe weather (hurricanes, solar flares) impacting local ISPs or SATCOM links could sever our “Observation” capabilities.
    - If Amber Tide is targeting a forward-deployed tactical operations center, bad weather might degrade the very satellite communications we need to coordinate the incident response, forcing us to rely entirely on local, disconnected defense measures.

#### Enemy OCOKAW:

##### Observation and fields of fire:
- They utilize WMI for USB discovery and local/network drive enumeration to map out file shares. They target what they can see locally from the infected endpoint, scraping browser credentials (AmberCookie) and taking screen captures (AmberScreen) to observe user activity and target specific file extensions.

##### Cover and Concealment:
- Stealth is sacrificed for speed. They conceal their payloads locally using double extensions, masquerading with benign registry names, and AMSI bypasses. Network concealment is achieved by blending C2 traffic into third-party messaging platforms, cloud tunneling, or using HTTP/HTTPS with frequent dynamic IP/domain rotation.

##### Obstacles:
- EDR systems that block script execution or monitor AMSI are their primary obstacles. To bypass these, they utilize proxy execution via `mshta\.exe`, fileless registry storage, and environmental keying (ensuring payloads only execute on the intended victim machine to avoid sandbox analysis).

##### Key Terrain:
- Initial foothold endpoints. By dropping layered tooling (AmberCDrop, AmberTemplate) onto a single host, they establish a durable beachhead. Compromising an internal communication node (like the email server in 2023) is vital terrain, allowing them to rapidly blast malicious attachments to internal peers who trust the source.

##### Avenues of Approach:
- They approach the network via spearphishing attachments (LNK/HTA in archives). Once inside, their internal avenues of approach are highly opportunistic: infecting any inserted USB drive to jump across air-gaps or segmentations, and leveraging legitimate Microsoft Office template macros to move laterally via document sharing

##### Weather:
- Same as friendly


---

### Time/Space/Logistics

### Time:
- Amber Tides operations rely on fast moving "smash and grab opertaions" meaning a high adversarial op tempo.
### Space:
- Partner Network is located in Lunovia's capital city, Velystok.
### Logistics:
- Due to the amount of data/alerts generated by the adversary, the full kit would be required.
---

### Civil Considerations
- the adversary is primarily focused on cyberespionage against Lunovian governmental institutions
---

## EMLCOA

### What is the enemy's mission?
- cyberespionage against Lunovian governmental institutions

### What are they currently doing?
- They are actively executing aggressive, noisy mass lateral movement across our networks using native PowerShell and VBScript. They are dropping layered, redundant tooling (like AmberX and AmberSand) and aggressively spreading via weaponized Word templates and USB drives (AmberLNK). Simultaneously, they are staging stolen browser credentials and targeted files for exfiltration over dynamic HTTP/HTTPS proxies and third-party messaging platforms.

### What will they do on contact?
- They will not retreat or attempt to “go dark.” Because they do not prioritize stealth, upon defensive contact (e.g., blocking an IP, killing a shell, or quarantining a host), they will attempt to outpace our response. They will rapidly iterate their toolsets, change obfuscation layers (Base64, string splitting), and rotate C2 infrastructure. More importantly, they will instantly trigger their redundant, multi-layered persistence mechanisms (fileless registry storage, scheduled tasks, and offline infected USBs) to immediately re-infect the environment and re-establish access.

---

## Center of Gravity

### What is the enemy relying upon to accomplish their mission?
- unrestricted ability to leverage native Windows scripting environments (PowerShell, VBScript, WMI) and physical media (USBs) to achieve rapid mass redundancy.

---

## Critical Vulnerability

### What can I take away from the enemy that renders their center of gravity ineffective?
- the enemy relies on their C2 network for exfiltration. degradation of that network would render their operations ineffective.

---

## Exploitation Plan

### What is your plan to target the identified critical vulnerability in the enemy system?