What we are going to do now is apply the tactical planning process against a real world adversary. We are going to start with the FSB Center 18. There is a mindset that we need to drop in this course. Industry and government have gone down the path of decoupling the hackers from the military or foreign intelligence entity that they are apart of. We are not going to carry that mentality into this course. We are not attempting to hunt and counter the activities of "Gamaredon" or "invisimole". We are operating against the Russian FSB or against the Chinese MSS. These are our enemies and we are conducting tactical engagements with them. We intend to plan accordingly.

Our primary references for this lesson are: The Tactical Planning Process student handout and the two reports for ESET on FSB Center 18. What we are going to do is dissect these reports and plan a tactical mission against the FSB Center 18 as they conduct espionage.

## METT-TC -> EMLCOA -> CG/CV/EXP. PLAN -> SOM -> FSP -> TASKS

### Mission

- Deny or degrade the FSB Center 18's ability to collect intelligence from network X IOT preserve friendly freedom of maneuver in cyberspace.

### Enemy

#### Composition, Disposition, Strength

- Students will break into small groups and complete a SALUTE report on the FSB Center 18 based on the information in the ESET reports and any other open source information that they can find. The goal of this exercise is to get students to think critically about the enemy and to understand their composition, disposition, strength, capabilities, and limitations.
    
- Size:
	- Great RFI for intel. We can say, however, given the fact that this actor falls under the FSB, they should be assumed to be well funded and well resourced.

- Activity:
	- The group's primary activity is cyberespionage. Key actions include: - Initial Access: Spearphishing with malicious LNK/HTA attachments and weaponized USB drives (PteroLNK). - Data Exfiltration: Stealing documents, browser credentials (PteroSteal), cookies (PteroCookie), and data from messaging apps like Signal (PteroSig) and Telegram (PteroGram). - Persistence & Lateral Movement: Heavy use of weaponized Word document templates (PteroDoc, PteroTemplate) and scheduled tasks.
	- We are going to update this section after we conduct our terrain and enemy reconnaissance. We want this to be as accurate as possible and we want it to be terrain specific.

- Location:
	- Physically operating out of occupied Crimea.
	- Logically they maintain global infrastructure
	- Logically, they are operating within multiple Ukrainian networks which are predominately physically hosted in Kyiv.

- Unit:
	- 18th Center of Information Security of the FSB Military Unit 64829
	
- Time:
	- Ongoing
	
- Equipment:
	- All heavily obfuscated tools capable of bypassing Windows Defender
	- Powershell, VBScript Downloaders that download various post-exploitation payloads
	- C Droppers that drop various payloads
	- Powershell, VBScript Weaponizers that weaponize office documents, usb drives, and LNK files _already present in the target environment_
	- PowerShell, VBScript Stealers that exfiltrate files, capture screenshots, exfiltrate cookies, etc.
	- PowerShell Backdoors that serve as remote shells
	- PowerShell socks proxies for pivoting through environments.
	- Final payload of a file stealer (see MONTEREY) whose main goal is to look for files with specific file extensions and exfiltrate them to the command and control server.
	- See more in reference [^3](https://web-assets.esetstatic.com/wls/en/papers/white-papers/cyberespionage-gamaredon-way.pdf).

#### Capabilities and Limitations

What we aren't going to do is try to force this model to fit our needs. We are going to work through it and critically think about what applies, and what doesn't.

- Students will break into small groups and complete a capabilities and limitations analysis on the FSB Center 18 based on the information in the ESET reports and any other open source information that they can find. The goal of this exercise is to get students to think critically about the enemy and to understand their capabilities and limitations.
    
- Defend:
	- Under what conditions can the enemy DEFEND?: Typically, they defend their accesses by deploying multiple simple downloaders or backdoors simultaneously. They also have invested a lot of time into testing and applying a variety of techniques to thwart domain-based blocking. They stopped relying solely on registering dozens of new C&C domains and started leveraging services provided by third parties like Telegram and Cloudflare.
	- Under what conditions is the enemy unable to DEFEND?:
	- Under what conditions WILL the enemy DEFEND?: We assume that the enemy will attempt to defend their accesses and infrastructure at all times albeit in an unconventional manner. This adversary accepts that they will be discovered in the network and they defend by having multiple simultaneous backdoors on any given machine.
    
- Reinforce:
	- Under what conditions can the enemy REINFORCE?: They reinforce their positions within networks by deploying miltiple simple downlaoders or backdoors simultaneously. They also have the ability to reinforce by handing off their access to a more sophisticated actor like Center 16.
	- Under what conditions does the enemy have the inability to REINFORCE?: We do not know specifically how much capacity INVISIMOLE has to give over to GAMAREDON. We assume that INVISIMOLE's capacity to support is the limiting factor.
	- Under what conditions WILL the enemy REINFORCE?: Observed activity has shown that, given a particularly "juicy" access, GAMAREDON will ask INVISIMOLE to take over the access to reinforce said access via kernel level implant.
    
- Attack:
	- Under what conditions can the enemy ATTACK?: Given sufficient access to an environment they can, in theory, perform destructive attacks.
	- Under what conditions is the enemy unable to ATTACK?: Their mission does not seem to be data destruction but data collection.
	- Under what conditions WILL the enemy ATTACK?: A change of mission assignment. There has been no observed attack activity by FSB Center 18.
    
- Withdraw:
	- Under what conditions is the enemy capable of WITHDRAW?: Certain pieces of malware by this actor have the ability to delete themselves.
	- Under what conditions is the enemy unable to WITHDRAW?: Some of the adverary's malware operates like a psuedo worm. It automatically infects external drives for self-propagation as well as backdooring normal.dotm files. We believe that this actually makes it somewhat difficult for the adversary to fully withdraw because they themselves may lose track of what machines are infected. Especially if they wind up jumping an airgap.
	- Under what conditions WILL the enemy WITHDRAW?: We do not believe the enemy will willfully withdraw under any condition.
    
- Delay:
	- Under what conditions can the enemy DELAY?: Their extensive use of heavy obfuscation delay's hunt and counterstrike personnel significantly. The sheer number of compromises within a network as well as the traffic it produces also is overwhelming for a defensive team.
	- Under what conditions is the enemy unable to DELAY?: They are limited by their use of scriptbased malware and live off the land techniques. Script based malware is much easier to debug and deobfuscate than compiled binaries.
	- Under what conditions WILL the enemy DELAY?: We believe they will try to delay our efforts at all times.
    

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
	- 1 SBO ME in direct support

- Higher and Adjacent Units:
	- N/A

### Terrain and Weather

"This analysis must be conducted from both a FRIENDLY and ENEMY perspective. The enemy perspective is more important because you will use this information with your enemy analysis to determine their EMLCOA. Analysis of terrain must extend beyond simple observations such as, "This is the domain controller" or, "there aren't any known CVEs for services available at the boundary." You must arrive at significant conclusions about how the terrain will impact the enemy and your unit. The current workrole that is best suited for this analysis are Exploitation Analysts. Prioritizing terrain analysis around what most impacts the mission is vital. In our context, we MUST consider all three layers of cyber terrain: physical, logical, and persona. The information to be analyzed may come from among the following: higher's orientation, network maps both physical and logical, or from intelligence (commercial or otherwise).

#### Friendly OCOKAW

- Observation and Fields of Fire:
	- Our physical terrain is locally hosted and we will have access to server rooms as well as to user workstations. We have the ability to monitor network traffic at the boundary as well as internally. We have the ability to monitor and analyze logs from various sources including EDR, Windows Event Logs, Sysmon, netflow, etc.
    
- Cover and Concealment:
	- We will try to conceal our tools by making sure that our EDR agents are configured to look like normal processes and that our analysts are using normal user accounts. We will also try to conceal our monitoring by making sure that we are not generating a lot of noise on the network or in the logs.
    
- Obstacles:
	- We are working with a very cooperative partner and we have a lot of access to the network. We do not have any significant obstacles to our movement within the network. The main obstacle that we have is the sheer amount of data that we have to analyze. We will need to prioritize our analysis and focus on the most relevant data sources.
    
- Key Terrain:
	- From the network perspective, we need to control the blue core router. This is the main point of ingress and egress for the network and it will allow us to monitor all traffic going in and out of the network. We also need to be able to see lateral movement within the network. From a host perspective, the domain controller is not necessarily key terrain but the ntds.dit file is. This adversary is primarily focused on stealing working documents from user workstations and servers. They are not focused on stealing credentials but they are focused on stealing the documents that the users have access to. This means that we need to be able to see what files are being accessed and exfiltrated from user workstations and servers.
    
- Avenues of Approach:
	- The main avenue of approach for the enemy is going to be through spear phishing. They have been observed sending spear phishing emails with weaponized attachments to users within the network. They have also been observed using USB drives to infect machines. They have also been observed using LNK files to infect machines.
    
- Weather:
	- There are no significant weather events in the forecast. However, due to kinetic strikes on the power grid around Kyiv, there may be some power outages that could impact our operations. We need to be prepared for this and have backup power sources available.

#### Enemy OCOKAW

- Observation and Fields of Fire:
	- The enemy has no physical access to the network but they have logical access to compromised hosts within the network. They have no ability to monitor network traffic but can look at host based logs such as Windows Event Logs, Sysmon, etc.
    
- Cover and Concealment:
	- The enemy is using heavy obfuscation to conceal their tools and techniques. However, they are leveraging known LOLBAS (Living Off the Land Binaries and Scripts) and persistence locations. They are also using a lot of different C&C domains and IP addresses to make it difficult for us to block them to include using telegram and cloudflare services.
    
- Obstacles:
	- The workstations and servers in the network are protected by Windows Defender and Crowdstrike EDR. The network is protected by a firewall and an IDS. The main obstacle for the enemy is the fact that they are operating in a network that is actively being monitored and defended by a team of analysts.
    
- Key Terrain:
	- The adversary's main target are working documents on user workstations and servers. They are not focused on stealing credentials but they are focused on stealing the documents that the users have access to. This means that the key terrain for the enemy is going to be the user workstations and servers that have the documents that they want to steal. They are also focused on maintaining access to these machines so they can continue to steal documents over time. Common persistence locations such as the Windows Registry, startup folder, and scheduled tasks are also key terrain for the enemy.
    
- Avenues of Approach:
	- T1566 Spear phishing
	- Removable media such as USB drives
    
- Weather:
	- No significant weather events in the forecast for the Crimean peninsula. However, the ongoing conflict in Ukraine may impact the enemy's operations and capabilities. We need to be aware of any changes in the situation that could impact our mission.

### Time/Space/Logistics

- Time:
- Space:
- Logistics:

### EMLCOA

The EMLCOA is the enemy's scheme of maneuver; it accounts for their task, purpose, and method of imposing their will. The EMLCOA is what a commander must counter with their plan. The detail required for an EMLCOA is based on the tactical situation.

There are three things that must be considered when developing the EMLCOA:

- What do I deduce is the enemy's tactical task and purpose (Mission)?
- To conduct cyberespionage by continuously collecting sensitive data from Ukrainian government networks to satisfy Russian intelligence requirements.
    
- What is the enemy currently doing?
    
- FSB Center 18 is engaged in a continuous, high-tempo operation. They gain initial access via spearphishing and weaponized USBs. Upon access, they deploy a multi-stage chain of PowerShell and VBScript downloaders to install a suite of stealers (PteroSteal, PteroPSDoor). They focus on exfiltrating documents and credentials while using automated tools (PteroTemplate, PteroLNK) to weaponize the environment for lateral movement and further reinforcement. They use a resilient, fast-flux C2 network and legitimate third-party services to maintain persistence despite likely detection. In our target environment, they have infected it-wks-01 and it-wks-02 with multiple backdoors and they are using these machines to steal documents and exfiltrate them to their C&C servers.
    
- What will the enemy do on contact? What do I anticipate will change when we engage the enemy? How will the enemy respond? You should consider how the enemy is being supported and how they are tied into the higher enemy system.
    
- On contact (e.g., if we block a C2 domain or remove a backdoor), the enemy will not withdraw. Instead, they will rely on their numerous other backdoors and persistence mechanisms to maintain access. They will likely attempt to deploy fresh downloaders and establish new C2 channels using their fallback techniques (Telegram, Cloudflare). Given a high-value target, they may also reinforce their position by handing off access to a more sophisticated actor (InvisiMole) for the deployment of stealthier, kernel-level implants.

### CG/CV/EXP. PLAN

#### Center of Gravity

- The enemy's center of gravity is the speed in which they exfiltrate data from the network. Their tools are designed to immediately directory walk a compromised machine for files with specific extensions and exfiltrate them to their C2 servers. They do not care if one of their tools gets caught by EDR or if one of their C2 domains gets blocked because usually they have already exfilrated everything they want by the time they are detected.

#### Critical Vulnerability

- The enemy's critical vulnerability is their reliance on script-based malware and live off the land techniques. Script-based malware is much easier to debug and deobfuscate than compiled binaries. Live off the land techniques are also easier to detect because they often involve the use of known LOLBAS (Living Off the Land Binaries and Scripts) and persistence locations.

#### Exploitation Plan

- We are going to exploit the enemy's critical vulnerability by focusing on reducing our time to detect down to near realtime detection independent of the EDR's ability to detect a new compromise. We need to focus on tempo and outpacing the adversary.
    
- We will identify discrete data sources and logs (process event creations, registry modifications, and other persistence location modifications) and tie those to specific techniques and sub-techniques in the MITRE ATT&CK framework. We will then create individual dashboards in the SIEM that use "allow-list" logic to alert on any activity that has not been cleared by our analysts as normal.
    
- Upon detection of a new compromise, we will quarantine the affected host via EDR as rapidly as possible and then we will pivot to the affected host to conduct live forensics and determine the scope of the compromise. We will then use this information to hunt for other compromised hosts within the network that may be part of the same intrusion. We will also use this information to identify the techniques and tools that the adversary is using so we can look for them in other parts of the network.
    
- D3FEND and ENGAGE Codes for our EXP. Plan
    
- D3-EAL Executable Allowlisting
    
- D3-CQ Content Quarantine
- EAC0005 Lures
- EAC0020 Isolation
- EAC0021 Attack Vector Migration
- EAC0018 Security Controls
- EAC0014 Software Manipulation
- EAC0016 Network Manipulation

### SOM

- Phase 1: Preparation and Baselining
- Set the defense
    
    1. Identify critical discrete data sources (Event ID 4688 for Process Creation, Sysmon Event 12/13/14 for Registry Mods, etc.).
    2. Map these data sources to specific MITRE ATT&CK Sub-techniques (e.g., T1547.001 - Registry Run Keys).
    3. Collect the identified data sources.
    4. Identify discrete analytical techniques to be applied for each data source and its corresponding MITRE ATT&CK sub-technique (e.g., for T1547.001, look for new entries in Run Keys that are unique in the environment).
- Phase 2: Near-Real-Time detection
    
- Detect the Enemy
    
    1. Deploy SIEM dashboards utilizing strict "allow-list" logic based on Phase I baselines; striving for blank dashboards that only alert on novel activity.
    2. Alert immediately on any process creation or persistence mechanism modification that deviates from the approved baseline, bypassing EDR signature delays.
    3. Triage alerts as they come in to confirm/deny new compromises. if determined to be benign, add the activity to the baseline and "allow-list" it in the SIEM. If determined to be malicious, immediately transition to Phase III.
- Phase 3: Isolation and Triage
    
- Fix the Enemy
    
    1. Upon alert validation, execute immediate host quarantine via EDR API/console to sever adversary C2.
    2. Pivot to the isolated host to conduct live forensics (memory capture, active process mapping, triage script execution).
- Phase 4: Scoping and hunt
    
- Exploit and Eradicate
    
    1. Extract newly identified Indicators of Compromise (IoCs) and adversary tools from the isolated host. Immediately transition to phase V to share this information with echeloned support for offensive action.
    2. Feed data back into the SIEM and EDR to conduct enterprise-wide hunts to identify laterally compromised systems.
    3. Repeat Phase III for newly discovered hosts until the intrusion is fully scoped.
- Phase 5: Information Dissemination
    
- Share IOCs and tools with echeloned support.
    1. Package all relevant data (PCAP, NetFlow, extracted tools, IoCs) for sharing.
    2. Draft a Cyber Request for Fire (RFF) to echeloned support to request offensive countermeasures against identified adversary infrastructure and tools.

### FSP

|Target Category|Trigger Event|Organic DCO Action|Rear Echelon Action|Desired Effects|
|---|---|---|---|---|
|Adversary C2 Infrastructure (IP/Domain)|Phase 3 Triage confirms active beaconing to external IP|1. Block outbound traffic locally. 2. Gather all associated logs and artifacts. 3. submit a request for support to rear echelon|1. Conduct active reconnaissance from non-atrributable infrastructure. 2. Exploit identified vulnerabilities on C2 node.|Degrade, Disrupt, Exploit|
|Adversary Tool Repository/Staging Server|Dashboard detects execution of a novel payload; payload URL is extracted from memory|1. Prevent internal hosts from downloading payload 2. Extract URL 3. Submit a request for support|1. Enumerate the staging srever directory 2. Download theadversary's full toolkit for reverse engineering 3. Potentially neutralize the staging server|Deny: Prevent adversary from deploying secondary tools. Intelligence: feed new IoCs back into the SIEM|
|Compromised Third-Party Relay (e.g. coopted residential redirector)|Identification of traffic routing throug ha know compromised residential proxy|1. Null-route traffic to proxy locally 2. Submit a request for support|Coordinate with law enforcement or execute authorized DCORA|Disrupt: Force the adversary to rebuild their infrastructure|

### Tasks

To execute the scheme of maneuver effectively, we need to assign specific, actionable tasks to our organic team members. By dividing the labor into distinct toles, you ensure unity of effort and prevent overlap during high-tempo operations.

### Organic Asset Tasking: Outpacing the Adversary

|Role|Phase I: Prep & Baseline|Phase II: Detection|Phase III: Isolation & Triage|Phase IV: Hunt & Fire Support|
|---|---|---|---|---|
|**Mission Commander (MC)**|Define mission success criteria; verify ROE and target boundaries.|Monitor team tempo; authorize transition from Phase II to Phase III.|Authorize host quarantine; manage risk of operational disruption to friendly forces.|**Draft and submit the Cyber Request for Fire (RFF)** to Rear Echelon; coordinate target handoff.|
|**Threat Intel (Intel)**|Provide Gamaredon IoCs/TTPs to NetOps; construct the initial EMLCOA.|Monitor open-source intel for shifting adversary TTPs during the ambush phase.|Analyze extracted tools to confirm attribution; predict adversary's "Actions on Contact."|Translate new findings into MITRE ATT&CK sub-techniques; update the EMLCOA for the next hunt iteration.|
|**Network Analyst (NetOps)**|Build "allow-list" SIEM dashboards for Process Creation (Event 4688) and Registry Mods.|Monitor dashboards for deviations from the baseline; trigger the Phase III alert.|Null-route identified C2 IP addresses at the local firewall to sever adversary communication.|Package PCAP and NetFlow data for the MC to include in the RFF; hunt for lateral movement.|
|**Host Analyst (HostOps)**|Deploy EDR baseline policies; ensure triage scripts and live forensic tools are staged.|Stage on "standby" to execute immediate quarantine upon NetOps alert.|**Execute immediate EDR quarantine;** run live triage scripts to extract volatile memory, active processes, and staged payloads.|Sweep the enterprise via EDR for newly discovered file hashes or persistence mechanisms found during triage.|

### Summary

In this lesson, we applied the tactical planning process to a real-world adversary, FSB Center 18. We conducted a thorough analysis of the enemy's composition, disposition, strength, capabilities, and limitations. We then developed an EMLCOA based on our understanding of the enemy and the terrain. Finally, we created a detailed scheme of maneuver and tasking plan to outpace the adversary and achieve our mission objectives.

### Sources