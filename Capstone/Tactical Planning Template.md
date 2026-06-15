## Tactical Planning Process

### METT-TC -> EMLCOA -> CG/CV/EXP. Plan -> SOM -> Tasks

## METT-TC: Estimate of the Situation

### Mission:

reconnoiter enemy greyspace in order to identify avenues of approach. Upon discovery of initial access vectors/opportunities, provide COAs to the commander to achieve initial access.

### Enemy Analysis:

#### SALUTE: Composition, Disposition, Strength

##### Size:
- Unit 18 “Amber Tide” is a Varensk-aligned advanced persistent threat (APT) group operating under the Internal Security Bureau (ISB) of Varensk.
##### Activity:
1. **Initial Access**: Spearphishing with LNK/HTA attachments in archives (T1566.001, T1204.001, T1204.002), HTML smuggling, weaponized Microsoft Word documents/templates (T1221), and USB drive weaponization for replication (T1091).
    
2. **Execution & Lateral Movement**: PowerShell (T1059.001) and VBScript (T1059.005) for command execution, WMI for USB discovery (T1047), Metasploit Framework integration, and mass internal propagation.
    
3. **Persistence**: Registry Run keys/Startup folder (T1547.001), logon scripts (T1037.001), Office template macros (T1137.001), scheduled tasks (T1053.005), and fileless registry storage.
    
4. **Defense Evasion**: Obfuscation via command/HTML smuggling/embedded payloads/encrypted files (T1027), masquerading with double extensions and benign registry names (T1036), mshta.exe proxying (T1218.005), hidden files (T1564.001), AMSI bypass, and indicator removal (T1070.004).
    
5. **Discovery & Collection**: Targeted file discovery on local/network/USB drives, browser credential/cookie theft, screen capture, and data staging.

##### Location:
- 
##### Unit:

##### Time:

##### Equipment:

---

#### DRAW-D: Capabilities and Limitations

##### Defend:

##### Reinforce:

##### Attack:

##### Withdraw:

##### Delay:

---

### Troops and Fire Support

#### Organic:

#### Higher:

#### Adjacent:

#### Supporting:

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