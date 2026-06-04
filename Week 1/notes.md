## MLCOA
what is the enemy's mission?
	EX: is the enemy trying to achieve a specific tactical task like exfil sensitive data, or disrupt a crit svc?
what is the enemys current tactical activity?
	EX: are they staging tools for an attack? conducting active recon? maintaining persistance?
what are the enemys actions on contact?
	EX: how will they react when we take action against them? will they delete their presence, deploy ransomware, or escalate 
## CG/CV
COG - that element or capability which allows the enemy to execute their mission
CV - a vuln that, if exploit, will render the enemy COG ineffective

---
### Enemy's Mission:

The enemy's mission appears to be focused on cyberespionage against Lunovian governmental institutions. Their primary goal is to gather sensitive information and exfiltrate data. They do not prioritize stealth but compensate with frequent updates, obfuscation, and simultaneous deployment of multiple simple downloaders or backdoors to maintain access.

### Enemy's Current Tactical Activity:

The enemy group is currently engaged in maintaining persistence by rapidly updating tools, frequently changing obfuscation methods, and deploying multiple simple backdoors/downloaders. They are also observed conducting targeted file discovery on local/network/USB drives and browser credential/cookie theft.

### Enemy's Actions on Contact:

Given their behavior of rapidly adapting to detection and deploying new tactics, it is likely that the enemy will react aggressively if confronted. They may attempt to delete their presence, deploy ransomware, or escalate their actions in response to countermeasures. However, their primary goal remains data exfiltration.

## CG/CV

### Center Of Gravity (CG):

The Center of Gravity for ISB-Unit 18 "Amber Tide" appears to be their ability to rapidly update and adapt their tools, allowing them to maintain persistence despite detection. This capability enables them to continuously gather sensitive information and execute their mission.

### Critical Vulnerability (CV):

A critical vulnerability in the enemy's operations is their reliance on frequent domain/IP rotation for Command & Control channels. If this vulnerability can be exploited, it may render their Center of Gravity ineffective by disrupting their ability to maintain persistence and conduct data exfiltration.


---

Observation and fields of fire - what are our data sources? what is our vis into the env? - what are their sensors(insider access, compromised logging, C2 beacons)? what is their situational awareness?
Cover and Concealment - will our actions be overt or covert? will we use dedicated obfucation infrax)? - how are they hiding (matching network baseline, using encryption, "smash and grab" with no stealth)?
Obstacles - what barriers hinder data aquisition or scheme of manuver(eg. firewalls, encryption, lack of logging)? - what obstacles do they face(edr, application allow-listing)?
Key terrain - what is the critical func/info on this network? - what terrain is critical for their mission (eg. a specific database,  
Avenues of Approach - how can we gain or improve access? - how did they get in, and how can they move? map to mitre att&ck initial access techniques
Weather - phys weather can effect power and satcom, impacting phys infrax - same as friendly