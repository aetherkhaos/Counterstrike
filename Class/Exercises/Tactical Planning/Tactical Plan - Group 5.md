
## METT-TC -> EMLCOA -> CG/CV/EXP. PLAN -> SOM -> FSP -> TASKS

### Mission

- Deny or degrade the Varenskian ISB Unit 18's ability to collect intelligence from the defended Lunovian government network in order to perserve friendly freedom of maneuver in cyberspace, avoid unncessesary disruption to government services, and generate options for pursuit.

### Enemy

#### Composition, Disposition, Strength

- Size:
  - The actor falls under the ISB, they should be assumed to be well funded and well resourced. 
- Activity:
  - The group's primary activity is cyberespionage. Key actions include: - Initial Access: Weaponized USB based on removable-media alert recorded during same week as the first suspicious script execution. - Possible Data Exfiltration/C2: repeated script execution from user profile paths and unusual outbound web traffic to external infrastructure - Discovery and Collection: file server contains staged archives of common office-document types in user-writable directory 

- Location:
  - Physically operating out of Varensk.
  - Logically, they are operating within multiple Lunovian networks and allied partnered nations.
- Unit:
  - Unit 18 under the ISB. RFI for known coordination between Unit 18 and Unit 47 under the ISB. Initial access appears to be Unit 18 due to use of removable media and script execution but the targets appear to be of specific interest to Unit 47.
- Time:
  - Ongoing
  - RFI for exact date/time when the initial removable media alert was recorded as well as the first suspicious script execution
- Equipment:
  - All heavily obfuscated tools capable of bypassing EDR
  - AmberLNK (PowerShell/VBScript versions) for USB drive weaponization with enticing LNK files (double extensions, conspicuous filenames)
  - Custom PowerShell (e.g., AmberPSLoad variants) and VBScript (e.g., AmberX, AmberSand, AmberDash, AmberRisk) general-purpose and dedicated downloaders that support encrypted PE files, PowerShell commands, and VBScript payloads (often XOR-encrypted with volume serial number as key)
  - AmberDoc and AmberTemplate for weaponizing Word documents/templates with malicious remote references or macros
  - AmberCDrop (C-based) for delivering VBScript payloads.
  - File stealers (e.g., AmberPSDoor, AmberVDoor variants) targeting specific extensions; browser credential/cookie stealers (AmberSteal, AmberCookie); app-specific stealers (e.g., for messaging clients); screen capture (AmberScreen); remote shells (AmberPShell, ReVBShell); reverse SOCKS proxies (AmberSocks).

#### Capabilities and Limitations

- Defend:
  - Under what conditions can the enemy DEFEND?: Typically, they defend their accesses by deploying multiple simple downloaders or backdoors simultaneously.

  - Under what conditions is the enemy unable to DEFEND?: Doesn't prioritize stealth

  - Under what conditions WILL the enemy DEFEND?: We assume that the enemy will attempt to defend their accesses and infrastructure at all times albeit in an unconventional manner. This adversary accepts that they will be discovered in the network and they defend by having multiple simultaneous backdoors on any given machine.

- Reinforce:
  - Under what conditions can the enemy REINFORCE?: They reinforce their positions within networks by deploying miltiple simple downlaoders or backdoors simultaneously.

  - Under what conditions does the enemy have the inability to REINFORCE?: doesn't appear to do priv esc but rather mass internal propogation, has goal to maintain persistence access through layered tooling and facilitate lateral movement and new victim acquisition

  - Under what conditions WILL the enemy REINFORCE?: Based on report given there is no privilege esclation done by this group. An RFI is needed to determine if there is additional reporting regarding this or if they work with another unit and pass initial access to them for privilege escalation.

- Attack:
  - Under what conditions can the enemy ATTACK?: Given sufficient access to an environment they can, in theory, perform destructive attacks. spearphishing with LNK/HTA

  - Under what conditions is the enemy unable to ATTACK?: Their mission does not seem to be data destruction but data collection.

  - Under what conditions WILL the enemy ATTACK?: RFI Are there any policies within the ISB the prevents Unit 18 from conducting offensive effects?

- Withdraw:
  - Under what conditions is the enemy capable of WITHDRAW?: Certain pieces of malware by this actor have the ability to delete themselves.

  - Under what conditions is the enemy unable to WITHDRAW?: Some of the adverary's malware operates like a psuedo worm. It automatically infects external drives for self-propagation as well as backdooring normal.dotm files. We believe that this actually makes it somewhat difficult for the adversary to fully withdraw because they themselves may lose track of what machines are infected. Especially if they wind up jumping an airgap.

  - Under what conditions WILL the enemy WITHDRAW?: RFI what is considered intel gain/loss for unit 18? 

- Delay:
  - Under what conditions can the enemy DELAY?: Their extensive use of heavy obfuscation delay's hunt and counterstrike personnel significantly. The sheer number of compromises within a network as well as the traffic it produces also is overwhelming for a defensive team.
  - Under what conditions is the enemy unable to DELAY?: RFI needed for if there are any Varenskian or ISB policies/terms/conditions/ that they would not want to delay

  - Under what conditions WILL the enemy DELAY?: We believe they will try to delay our efforts at all times. simultaneous deployment of multiple simple downloaders or backdoors to maintain access, aggressive mass lateral movement, emphasizes rapid tool iteration

### Troops and Fire Support Available

- Organic:
  - 3 host analysts
  - 3 network analysts
  - 1 all source analyst
  - 1 certified counter-strike operator
  - 1 certified malware analyst
  - Standard complement of tools (network taps, forensic workstations, etc.)

- Attachments and Detachments:
  - No attachments or detachments.

- Fire Support Available:
  - N/A

- Higher and Adjacent Units:
  - N/A

### Terrain and Weather

#### Friendly OCOKAW

- Observation and Fields of Fire:
  - RFI: Where are we physically located and will we have access to server rooms as well as to user workstations? We have the ability to monitor network traffic at the boundary as well as internally. We have the ability to monitor and analyze logs from various sources including endpoint telemetry, firewall logs, Windows Event Logs, limited netflow, limited PCAP across some segments.

- Cover and Concealment:
  - RFI: Are we able to deploy EDR agents on this network? We would conceal our tools by making sure that our EDR agents are configured to look like normal processes and that our analysts are using normal user accounts. We would also try to conceal our monitoring by making sure that we are not generating a lot of noise on the network or in the logs.

- Obstacles:
  - Unknown number of event logs to parse through as well as the fidelity of the logging on the endpoints. Limited netflow and PCAP as well.

- Key Terrain:
  - From the network perspective, we need to control the blue core router. This is the main point of ingress and egress for the network and it will allow us to monitor all traffic going in and out of the network. We also need to be able to see lateral movement within the network. From a host perspective, the domain controller is not necessarily key terrain but the ntds.dit file is. This adversary is primarily focused on stealing working documents from user workstations and servers. They are not focused on stealing credentials but they are focused on stealing the documents that the users have access to. This means that we need to be able to see what files are being accessed and exfiltrated from user workstations and servers.

- Avenues of Approach:
  - The main avenue of approach for the enemy is going to be through USB weaponization. They have been known to spear phish with weaponized attachments to users within the network. They have also been observed using LNK files to infect machines.

- Weather:
  - RFI are there any significant weather events in the forecast in Lunovia? RFI: Does the Lunovian srever room we are using have an UPS and what is their capacity at? 

#### Enemy OCOKAW

- Observation and Fields of Fire:
  - Unknown if the enemy has no physical access to the network but they have logical access to compromised hosts within the network. RFI: Are there any intelligence reports/sigint indicating there may be insider threats within the Lunovian government networks?

- Cover and Concealment:
  - The enemy is using heavy obfuscation to conceal their tools and techniques. However, they are leveraging known LOLBAS (Living Off the Land Binaries and Scripts) and persistence locations. 

- Obstacles:
  - Unknown what the Lunovian workstations and servers in the network are protected by. Network map does not show a firewall but more information needs to be requested. Do they have a firewall, EDR, and IDS? Uknown if there are any obstacles to the enemy at this time. Have any clear actions been taken since detection?

- Key Terrain:
  - The adversary's main target are working documents on user workstations and servers. They are not focused on stealing credentials but they are focused on stealing the documents that the users have access to. This means that the key terrain for the enemy is going to be the user workstations and servers that have the documents that they want to steal. They are also focused on maintaining access to these machines so they can continue to steal documents over time. Common persistence locations such as the Windows Registry, startup folder, and scheduled tasks are also key terrain for the enemy.

- Avenues of Approach:
  - T1566 Spear phishing
  - Removable media such as USB drives

- Weather:
  - RFI are there any significant weather events in the forecast in Varensk?

### Time/Space/Logistics

- Time: Adversary ops tempo is high
- Space: RFI Where are we physically located and who do we have access to system admins/server room?
- Logistics: RFI: Are we physically co-located with administrators or do we need to travel somewhere to talk to them? Are they available for us to talk to when events arise or do we have set meeting times? 
- Civilian Consideration: Are we operating on a critical infrastructure (e.g. power grid, financial services)? What are the potential collateral effects? Do we know what documents regarding energy-policy coordination and transportation-setor continuity planning were exfiltrated?

### EMLCOA

There are three things that must be considered when developing the EMLCOA:

- What do I deduce is the enemy's tactical task and purpose (Mission)?
  - To conduct cyberespionage by continuously collecting sensitive data from Lunovian government networks to satisfy Varenskian intelligence requirements.

- What is the enemy currently doing?
  - ISB Unit 18 is engaged in a continuous, high-tempo operation. They gain initial access via spearphishing and weaponized USBs. Upon access, they deploy a multi-stage chain of PowerShell and VBScript downloaders to install a suite of stealers. They focus on exfiltrating documents. 

- What will the enemy do on contact? What do I anticipate will change when we engage the enemy? How will the enemy respond? You should consider how the enemy is being supported and how they are tied into the higher enemy system.
  - On contact, the enemy will not withdraw. Instead, they will rely on their numerous other backdoors and persistence mechanisms to maintain access. They will likely attempt to deploy fresh downloaders.

### CG/CV/EXP. PLAN

#### Center of Gravity

- The enemy's center of gravity is the speed in which they exfiltrate data from the network. Through mass propogation and rapid tool development they are able to establish multiple footholds in a network without caring if they are detected.

#### Critical Vulnerability

- The enemy's critical vulnerability is their reliance on script-based malware and live off the land techniques. Script-based malware is much easier to debug and deobfuscate than compiled binaries. Live off the land techniques are also easier to detect because they often involve the use of known LOLBAS (Living Off the Land Binaries and Scripts) and persistence locations.