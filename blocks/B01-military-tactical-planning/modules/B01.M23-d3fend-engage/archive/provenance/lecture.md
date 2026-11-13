## MITRE D3FEND and ENGAGE

### From observed behavior to commander options

MITRE ATT&CK describes the adversary behavior mapped in B01.M19. MITRE
D3FEND organizes countermeasure knowledge, and MITRE ENGAGE organizes
adversary-engagement goals and approaches. The analytical task is to turn one
evidence-backed ATT&CK layer into feasible paired options.

For each significant ATT&CK technique:

1. identify applicable D3FEND countermeasures;
2. identify an ENGAGE option when engagement supports the mission;
3. state the expected effect on the adversary COG/CV;
4. state risk, authority, evidence, and ownership requirements; and
5. provide the commander alternatives rather than one tool-driven answer.

The frameworks constrain and explain the option space. They do not select an
option automatically.

### Outline

1. Introduction to MITRE ENGAGE
2. Mapping ATT&CK to ENGAGE
3. ENGAGE Codes
4. 2X/39 conversation?

### Introduction to MITRE ENGAGE

The final MITRE framework that we are going to leverage in this course is ENGAGE. Where ATT&CK is concerned with capturing and describing offensive TTPs and D3FEND is focused mainly on remedial steps against those TTPs, ENGAGE is more about actively interacting with the adversary in blue space. The combination of D3FEND's "D3" codes and ENGAGE's "EAC" codes are going to constitute the *bare minimum* options that need to be considered. Furthermore, we will not blindly recommend a D3FEND or ENGAGE technique to the commander as an option. We will ensure that we are recommending options that are realistic given the nuances of the environment and that we can articulate how an a recommended option works toward the accomplishment of our assigned mission.

### ENGAGE Categories

#### Expose

"Expose is about discovering previously undetected adversaries engaging in one of two behaviors. First, the adversary may be attempting to gain access to the networks. Second, the adversary may be currently operating on the networks. Both categories of adversary behavior contain vulnerabilities that can be advantageous for a defender seeking to expose the adversary.

As an example of such a vulnerability, when an adversary interacts with network or system resources, they are vulnerable to trigger tripwires. The defender can make and leak fake credentials both inside and outside of the network. The defender can then monitor for the use of these credentials. Then, when an adversary uses a fake credential, the defender will receive a high-fidelity alert. In addition, if the credentials are unique, a defender may be able to detect how and when an adversary collected the credentials. Whenever a defender seeks to engage with an adversary, operational safety is paramount. To maintain this safety, it is a best practice to monitor adversaries as they operate in an engagement environment. Additionally, the defender must be able to observe the adversary. Therefore, collection and detection activities can often be utilized even when a defender may have other strategic goals in mind.

Engage defines two approaches to make progress towards the Expose goal.

Collection activities are used to gather information about an adversary or their activities. This collection can include gathering system logs, network traffic, adversary artifacts, or other data that can be used to expose adversary activity. In many cases, collection activities are also good cybersecurity practices. However, in Engage, these activities will focus exclusively on the intersection of denial, deception, and adversary engagement technologies and the defender’s ability to Expose the adversary.

Detection activities focus on the defender’s ability to monitor adversary activity throughout an environment, often by creating high-fidelity detections. These detections can be produced in several ways. For example, a defender can deploy lures as tripwires in the environment. The defender may create custom alerts based on TTPs or IOCs observed during a malware detonation operation. Finally, the defender may write customer decoders to analyze and alert on malicious traffic.

In all these cases, detection activities allow the defender to produce a high-fidelity alert to monitor adversary activities. Often Detection activities are also good cybersecurity practices. However, in Engage, these activities will focus exclusively on the intersection of denial, deception, and adversary engagement technologies and the defender’s ability to Expose the adversary.

In many cases, the activities that support such Collection and Detection approaches are also good cybersecurity practices. However, in Engage, these activities will focus exclusively on the intersection of denial, deception, and adversary engagement technologies and the defender’s ability to Expose the adversary."

#### Affect

"Affect is ultimately about changing the cost-value proposition in cyber operations for the adversary. The defender may want to increase the adversary’s cost to operate or drive down the value they derive from their operations. For example, the defender can negatively impact the adversary’s on-network operations to drive up the resource cost of doing operations by slowing down or selectively resetting connections to impact exfiltration. This type of activity increases the adversary’s time on target and wastes their resources. To drive down the value of stolen data, a defender could provide an adversary deliberately conflicting information. Providing such information requires an adversary to either choose to believe one piece of data over another, disregard both, collect more data, or continue with uncertainty.

All these options increase operational costs and decrease the value of collected data. Engage defines three approaches to make progress towards the Affect goal.

Prevention activities focus on stopping the adversary’s ability to conduct their operations as intended. The defender can physically or virtually remove or disable resources, tighten security controls, or otherwise impair the adversary’s ability to operate. A defender might prevent an adversary from operating to force them to reveal different, possibly more advanced, capabilities. Additionally, a defender can use prevention activities to discourage the adversary from operating against a specific target. In this case, the defender may be attempting to encourage the adversary to focus elsewhere in the engagement environment. There are many more prevention activities that are also good cybersecurity practices. However, in Engage, we are focused on a subset of activities. Those are focused exclusively on the intersection of denial, deception, and adversary engagement technologies and the defender’s ability to Affect the adversary.

Direction activities focus on moving the adversary towards or away from an intended path. This forced direction can be accomplished by removing or disabling some resources, while adding or enabling others. The defender can add lures or otherwise manipulate the environment to attempt to elicit specific responses from the adversary. Additionally, the defender can tighten some security controls while leaving others overly permissive or weakened. Finally, the defender can physically move the adversary by moving threats from their intended environment and into a safe engagement environment. For example, a suspicious email attachment can be moved from the intended target to an engagement environment for analysis. No matter how the direction is achieved, the defender hopes to force the adversary to take unintended actions or stop intended actions.

Disruption activities are used to stop or discourage an adversary from conducting part or all of their mission. This disruption may increase the time, skills, or resources needed for the adversary to accomplish a specific task. For example, a defender may degrade network speeds as the adversary attempts to exfiltrate large blocks of data. As a second example, the defender may manipulate the output of commonly used discovery commands to show targets that do not exist or to hide real targets. In either case, the adversary may waste resources acting on partial or falsified data. Disruptions may also include planting misinformation designed to influence the adversary’s decision-makers to make the wrong decisions or to waste resources.

#### Elicit

"Elicit encourages adversaries to reveal additional or more advanced TTPs and goals while operating in defender-controlled engagement environments. These high-fidelity, synthetic engagement environments are uniquely tailored to engage with specific adversaries. They may contain a combination of documents, browser artifacts, etc. to reassure an adversary and reduce suspicion. Further, they may offer enticing data and exploitable vulnerabilities to motivate an adversary to operate in the defender’s environment.

These environments can either be left as a dangle, i.e., honeypot. Other times, the defender may self-infect with malware. In either case, observing an adversary as they operate can provide organizations with actionable cyber threat intelligence and potential understanding of the adversary’s goals.

Engage defines two approaches to make progress towards the Elicit goal.

Reassurance activities are used to add authenticity to deceptive components to reduce adversary suspicion about the legitimacy of the environment. Activities include adding realistic user accounts, files, system activity, and any other content that an adversary might expect to find on the system. These activities may add new artifacts, such as peripherals and pocket litter, while concealing others, such as how recently an environment was stood up. If done correctly, reassuring an adversary may help to make them feel more comfortable upon landing in a new environment. This initial level of comfort can help anchor the adversary in the environment, increasing their tolerance to faults or weaknesses discovered later.

Motivating activities is used to encourage an adversary to conduct part or all of their mission by providing a target-rich environment. To do this, the defender can use unpatched versions of operating systems and software, remove end-point detection software, and use weak passwords. Additionally, the defender can open firewall ports, add proxy capabilities, or introduce elements that an adversary can easily leverage to bypass an obstacle in their operations. Finally, the defender can include enticing data to the environment to encourage the adversary to steal the data."

### ENGAGE Techniques

#### EAC0005 Lures

Deceptive systems and artifacts intended to serve as decoys, breadcrumbs, or bait to elicit a specific response from the adversary. Lures are intended to elicit a particular response from the adversary. For example, the defender may utilize Lures to enable or block the adversary’s intended actions or encourage or discourage a specific action or response. Lures can take a variety of forms including credentials, accounts, files/directories, browser extensions/bookmarks, system processes, etc. Regardless of form, Lures provide opportunities to the defender to drive adversary behavior in ways that align with operational outcomes.

#### EAC0023 Introduced Vulnerabilities

Intentionally introduce vulnerabilities into the environment for the adversary to exploit. By intentionally Introducing Vulnerabilities into the engagement environment, the defender can attempt to motivate the adversary to target specific resources. This targeting may serve to move the adversary towards a particular resource, or away from another resource. At other times, the defender may Introduce Vulnerabilities as a mean of encouraging the adversary to reveal targeting preferences, available capabilities, or even to influence future targeting decisions. The operational objectives will drive how and why the defender Introduces Vulnerabilities in the engagement environment.

#### EAC0017 Hardware Manipulation

Alter the hardware configuration of a system to limit what an adversary can do with the device. Hardware Manipulation can include physical adjustments or configuration changes to the hardware in the environment. This manipulation can include physically removing a system’s microphone, camera, on-board Wi-Fi adapter, etc. or using software controls to disable those devices. These types of manipulations can affect the adversary’s ability to achieve their operational objectives by incurring an increased resource cost, forcing them to change tactics, or stopping them altogether. Hardware Manipulation is often required to maintain operational safety. For example, if the operation includes Malware Detonation using a laptop physically located in a shared space, it is likely that the defender will not have the ability to hide the legitimate conversations and individuals present in the space. Unless the defender can control the background sounds and visuals, it is likely too risky to leave the camera and microphone connected to the machine.

#### EAC0021 Attack Vector Migration

Move a malicious link, file, or device from its intended location to an engagement system or network for execution/use. When a defender Migrates an Attack Vector, the defender intercepts a malicious element and moves it to a safe environment, such as a decoy system within a decoy network, for continued engagement or analysis. A defender may choose to Attack Vector Migrations, which may appear in the form of phishing emails, suspicious email attachments, or malicious USBs. For example, a defender might move a suspicious attachment from a corporate inbox to an inbox on a system that, while in the corporate IP space, is completely segmented from the enterprise network. This segregated environment will allow the adversary to move laterally throughout the environment without risk to enterprise resources. Determining when an engagement should be moved to an engagement environment is a critical decision when calculating acceptable operational risk. However, if the adversary sent a custom malware sample to a phishing victim, but ultimately find themselves on an unrelated victim, they may be suspicious. Balancing this acceptable risk, believability, and operational goals is essential when determining if or when to migrate an attack vector.

#### EAC0020 Isolation

Configure devices, systems, networks, etc. to contain activity and data, thus preventing the expansion of an engagement beyond desired limits. Using Isolation, a defender can limit the effectiveness and scope of malicious activity and/or lower exposure to unintended risks. When a system or resource is isolated, a defender can observe adversary behaviors or tools with limited, or no, lateral movement allowed. For example, a defender may detonate a piece of malware on an isolated system to perform dynamic analysis without risk to other network resources. Determining which systems should be isolated in an operation is a critical decision when calculating acceptable operational risk. However, if the adversary expects to find an entire corporate network but instead finds only an isolated system, they may not be interested in engaging with the target. Balancing acceptable risk, believability, and operational objectives is essential when determining if or when a system should be isolated.

#### EAC0016 Network Manipulation

Make changes to network properties and functions to achieve a desired effect.Network Manipulation allows a defender to throttle network speeds, segment the network, maintain a unique IP addressing scheme, add a kill switch to cut off network access, etc. These types of manipulations can affect the adversary’s ability to achieve their operational objectives by incurring an increased resource cost, forcing them to change tactics, or stopping them altogether. For example, a defender can limit the allowed ports or network requests to force the adversary to alter their planned C2 or exfiltration channels. As another example, a defender could allow or deny outbound SMB requests from a network to affect the success of forced authentication. Additionally, the defender can degrade network speeds and reliability to impose a resource cost as adversaries exfiltrate large quantities of data. Finally, a defender can block primary C2 domains and IPs to determine if the adversary has additional infrastructure. While there are a range of network manipulation options, in all cases, the defender has an opportunity to learn about or influence the adversaries operating in the environment.

#### EAC0018 Security Controls

Alter security controls to make the system more or less vulnerable to attack. Manipulating Security Controls involves making configuration changes to a system’s security settings including modifying Group Policies, disabling/enabling autorun for removable media, tightening or relaxing system firewalls, etc. Such security controls can be tightened to dissuade or prevent adversary activity. Conversely, security controls can be weakened or left overly permissive to encourage or enable adversary activity. Tightening security controls can typically be done by implementing any of the mitigations described in MITRE ATT&CK. See <https://attack.mitre.org/mitigations/enterprise/> for a full list of mitigation strategies. While loosening security controls may seem obvious (i.e., simply don’t employ a given mitigation strategy), there is an additional level of nuance that must be considered. Some security controls are considered so routine that its absence may be suspicious. For example, completely turning off Windows Defender would likely raise the adversary’s suspicion. However, it is possible to turn off Windows Defender in certain shared drives to encourage adversary activity in predetermined locations. Therefore, it will likely be far less suspicious to turn off Windows Defender in a single directory or share. When assessing the likelihood that removing a given security control is overly suspicious, it is important to consider how prevalent that security control is, the target adversary’s sophistication, and the engagement narrative.

#### EAC0021 Attack Vector Migration

Move a malicious link, file, or device from its intended location to an engagement system or network for execution/use. When a defender Migrates an Attack Vector, the defender intercepts a malicious element and moves it to a safe environment, such as a decoy system within a decoy network, for continued engagement or analysis. A defender may choose to Attack Vector Migrations, which may appear in the form of phishing emails, suspicious email attachments, or malicious USBs. For example, a defender might move a suspicious attachment from a corporate inbox to an inbox on a system that, while in the corporate IP space, is completely segmented from the enterprise network. This segregated environment will allow the adversary to move laterally throughout the environment without risk to enterprise resources. Determining when an engagement should be moved to an engagement environment is a critical decision when calculating acceptable operational risk. However, if the adversary sent a custom malware sample to a phishing victim, but ultimately find themselves on an unrelated victim, they may be suspicious. Balancing this acceptable risk, believability, and operational goals is essential when determining if or when to migrate an attack vector.

#### EAC0010 Peripheral Management

Manage peripheral devices used on systems within the network for engagement purposes. Peripheral Management is the administration of peripheral devices used on systems within the engagement environment. A defender can choose to allow or deny certain types of peripherals from being used on systems to either motivate or demotivate adversary activity or to direct the adversary towards specific targets. Defenders can also introduce peripherals to an adversary-controlled system to see how the adversary reacts. For example, the defender can introduce external Wi-Fi adapters, USB devices, etc. to determine if adversaries attempt to use them for exfiltration purposes. Additionally, peripherals provide an avenue for the defender to present new or additional information to the adversary. This information can be used to introduce an additional attack surface, motivate or demotivate adversary activity, or to further the deception story. For example, the defender may include data on a connected USB device or stage an important conversation near an externally connected camera or microphone. Depending on the contents of this data, the adversary may be encouraged to take a specific action and/or reassured about the legitimacy of the environment.

#### EAC0014 Software Manipulation

Make changes to a system’s software properties and functions to achieve a desired effect. Software Manipulation allows a defender to alter or replace elements of the OS, file system, or other software installed and executed on a system. These alterations can affect outputs, degrade effectiveness, and/or prevent the software from functioning altogether. For example, the defender can manipulate software by changing the output of commonly used discovery commands to hide legitimate systems and artifacts and/or reveal deceptive artifacts and systems. Alternatively, the defender can change the output of the password policy description for an adversary attempting to brute-force credentials. This manipulation may cause the adversary to waste resources brute-forcing passwords with inaccurate complexity requirements. If the defender wanted to degrade software effectiveness, they might weaken algorithms to expose data that is being archived, encoded, and/or encrypted. Finally, to prevent software from functioning altogether, the defender may cause failures in software typically used to delete data or hide adversary artifacts. For some Software Manipulation use cases, it may be possible to make changes in such a way that adversary actions and legitimate user actions are handled differently. For example, the defender could show all files when viewed in a graphical application but hide files or introduce decoy files when viewed via a terminal command. This setup would allow legitimate users full access to the file system, while manipulating access for adversaries using a reverse shell.

DEMO: PowerShell Runspace Debugging — see [`legacy/week1/Demos/RunspaceDebugging.md`](../B01.M08-runspace-debugging/RunspaceDebugging.md) (instructor walkthrough)

#### EAC0015 Information Manipulation

Conceal and reveal both facts and fictions to support a deception story. Information Manipulation is used to support the engagement narrative and directly impact adversary activities. Revealed facts and fictions can be used to adjust the adversary’s trust in the environment. Concealed facts and fiction can be used to adjust the adversary’s sense of uncertainty towards the environment. Revealed facts may include OS type and version, geographic location, hardware type and version, accounts, credentials, etc. Revealed fictions may include the content of decoy files, emails, messages, etc. Revealed facts and fictions may or may not be believed by the adversary. If an adversary believes a revealed fact or fiction, it may lend credibility to the environment or encourage a specific action. If an adversary is suspicious or does not believe a revealed fact or fiction, it may erode adversary trust in the environment or discourage a specific action. Therefore, revealed facts and fictions can be used to adjust the adversary’s trust in the environment in ways that support the operational objectives.

#### EAC0011 Pocket Litter

Data used to support the engagement narrative. Pocket Litter is data placed on a system to help tell the engagement narrative, to increase the credibility of an environment, and/or to establish a cognitive bias to raise the adversary’s tolerance to weaknesses in the environment. Unlike Lures, Pocket Litter does not necessarily aim to encourage the adversary to take a specific action, but rather it supports the overall deception story. Pocket Litter can include documents, pictures, registry entries, installed software, log history, browsing history, connection history, and other user data that an adversary would expect to exist on a user’s computer. For example, a defender might conduct a series of web searches to generate browser artifacts, or scatter a variety of photos and documents across the desktop to make the computer feel lived in.

### References
<https://engage.mitre.org/matrix/>
