<!-- Canonical merged lecture source. The former Part 1 and Part 2 sources are preserved below as one instructional sequence. -->

# Military Tactical Planning

Today we're going to talk about tactical planning in the context of cyber operations. Tactical planning is typically not associated with things like cyber or information operations. It's really something that you do when you're a small unit leader conducting ground tactical operations. And in those ground tactical operations you might just be going on a very small convoy 5 miles up the street with a couple trucks. But as a second Lieutenant in that space you're still held to a fairly high standard of planning and it is a higher standard of planning that a lot of cyber operations that are conducted.

It might be a little bit disorienting to be coming into this class and we're really not talking about Cyberspace at first. We're talking about convoys and tactical ground operations. This is the military. We are all uniformed service members and the more that we can scope and contextualize what we are doing, rooted in military planning fundamentals, the more that we can start transitioning smoothly between this weird opaque thing called cyberspace and the rest of the warfighting domains. And we can start integrating better with external organizations within the military. At least that's the thought, right? So what we're not going to do is we're not going to lean on industry digital forensics and incident response models and ways of doing things, there's definitely going to be some overlap and we're going to steal from them when it's applicable. When we can't find an answer within the military mindset. The headspace that everyone needs to be in going into this course with is: we are conducting operations against the enemy. We are defending our terrain. They are attacking our terrain. And we are striking back against theirs.

So one thing that we're going to steal from is operational terms and graphics, where they define tactical tasks. And how this fits really nicely within what we're trying to do here is that there are three orientations of tactical tasks. You have enemy oriented tactical tasks, terrain oriented tactical tasks, and friendly oriented tactical tasks. And you can flow between the orientation of task or simultaneously have multiple tactical tasks spanning across those orientations. For example,  when I have a deliberate defense and I've dug in trenches because i have been given the terrain oriented tactical task of "control" in order to protect some friendly forces, where protect is a friendly oriented tactical task. And while I'm doing that and there are adversaries or the enemies in the vicinity, I might also have the tactical task to reconnoiter that adversary. Reconnoiter can either be a terrain oriented tactical task or an enemy oriented tactical task, but in this case I have three tactical tasks with their respective orientations. I've been tasked to control terrain in order to protect friendly forces and reconnoiter the adversary while I am at it. There's no difference in cyberspace I can be tasked to reconnoiter. To reconnoiter cyber terrain n order to identify the adversary. Upon discovery of the adversary, reconnoiter the adversary as they are conducting operations within that terrain. And then reconnoiter the adversaries terrain. Upon sufficient reconnaissance of that terrain, do something to it. Destroy it. Disrupt it. Interdict the adversary. I  want to acknowledge that not all of these tactical tasks have a smooth translation into cyberspace. And we're not going to sit here and try to just shoehorn everything in, but we're going to use that underlying construct of the orientation as much as possible. There is a different orientation of mission as pertains to the terrain, the enemy, and friendly forces.

![Tactical Tasks](References/TacticalTasks.png)

- ### Group Exercise

	- Given the student handout of tactical task definitions, come up with some translations between the conventional applications/definitions of tactical tasks and seeing how they are/aren't applicable to cyber operations.
 	- We will do another exercise later on where we map MITRE ATT&CK, D3FEND, and ENGAGE techniques to tactical tasks, as applicable.

Very early on in at least my branch of service's training pipeline all the way back to boot camp, you learn about the six troop leading steps and the acronym is BAMCIS. BAMCIS stands for Begin the Planning, Arrange Recon, Make Recon, complete the planning, Issue the order, Supervise. And that's what we're going to. That's what we're going to learn here and that's what we're going to implement.

### BAMCIS

#### Begin Planning

This phase starts upon the reciept of a mission and addresses the following:
Assess the available time: How long until you have to execute? how much time do you have to prepare? Generate inital timeline. Begin preliminary estiamte of the situation: Initial METT-TC with whatever information you have. Develop an initial course of action that will be refined through detailed planning/analysis.

We then want to make a tentative plan by answering three questions: What do I know? What do I think? and What am I going to do? You want to update/continue the estimate of the situation (METT-TC) and start the tactical planning process which will be covered fully soon. In doing so, RFIs will naturally emerge and will need to be submitted.

#### Arrange Reconnaissance and Coordination

Based on the detailed analysis (Tactical Thought Process) performed during Begin the Planning, the planner must ask, “What information am I lacking in order to achieve success?” To get this information to further mitigate risk assumed during the Tactical Thought Process, the planner must arrange for a reconnaissance of the enemy and terrain. First, the planner must determine the most effective means of available reconnaissance. Second, the planner must determine their priority of reconnaissance, or what order they will try to fulfill the information gaps. The first priority must be the gaps regarding the enemy; focusing on confirming or denying any assumptions made about their location, orientation, or current tactical activity. The second priority is to identify elements of the friendly SOM such as travel plans and force flow, sensor placement plan, and data acquisition strategy.

#### Make Reconnaissance

The planner now acts to answer their questions and validate any assumptions based on their priorities of reconnaissance and the time available. The plannerr should look to use all assets (imagery, air reconnaissance, SIGINT, etc) available to help fill information gaps. The reconnaissance is only successful if it answers those questions needed to successfully accomplish the mission.

#### Complete the Plan

The unit leader must now take the information gained during the reconnaissance and validate their initial plan madeduring Begin the Planning. This is done by conducting the Tactical Thought Process again, now armed with the answers to our questions. This analysis must be conducted again to ensure necessary changes are ultimately reflected in our plan to our subordinates. A common problem occurs when leaders receive updated information that conflicts with their previous analysis or established plan, but fail to update their METT-TC or amend their scheme of maneuver. Do not fall in love with your plan. At the conclusion of your second conduct of the Tactical Thought Process, you will write an order (Five Paragraph Order) to communicate to your subordinates.

#### Issue the Order

Here, leaders verbally communicate their analysis and scheme of maneuver using proper order-issuing techniques. Without coherent communication, the leader's decisions will never successfully be turned into action.

#### Supervise

The leader ensures compliance with the details of their plan until the mission is accomplished. This includes the timeline the commander set forth (non-negotiable), the mission rehearsals defined (as realistic as possible), the inspections of personnel and equipment prior to execution, adn the complete exectuion of the mission. Delegation to subordinate unit leaders is utilized, however check, do not assume, that your plan is being executed by subordinates to your standards.

### Tactical Planning Process: METT-TC -> EMLCOA -> CG/CV/EXP. PLAN -> SOM -> FSP -> TASKS

### METT-TC

And we're just gonna dive right in and talk about some of the tools that we have to start planning to start this tactical planning process. So the tactical planning process starts with a METT-TC analysis and METT-TC  stands for: Mission, Enemy Troops and fire support, Terrain and Weather, Time, space, logistics, and Civilian considerations. Once you've conducted your METT-TC analysis, you start determining the EMLCOA: the enemy's most likely course of action. And the EMLCOA in in this level of planning isn't just something you make up it has real components and it's based on our analysis and understanding of the adversary's mission. When constructing the EMLCOA, you're  answering three questions: What do I deduce is the enemy's mission? What is the enemy's current tactical activity? What are the enemy's actions on contact; How will they react when we impose our will on them? After you've determined the EMLCOA. You need to conduct a center of gravity analysis. After you've determined the adversary centered gravity, you look for and assess what their critical vulnerability is. After you've determined their critical vulnerability, you then move into the creation of the exploitation plan. The exploitation plan has a structure, and we'll get to that. Once you've gotten that far, it's time to start discussing the scheme of maneuver and how you're really going to think through implementing the plan and designating phases of an operation. In conventional planning we would do a fire support plan that would come after the scheme of maneuver, and that's because, you kind of want to deconflict, where you'll be on the battlespace when airstrikes or artillery get called in. And and there's a parallel here as well. That we'll discuss.  And then finally, we're going to get to tasking our troops. One of the big problems in at least the defensive tactical missions is that it's a lot of individuals. It's a lot of individuals that are just sitting in a room together more than it is a team systematically moving through an environment and systematically conducting an operation together.

#### Mission Analysis

The first part of METT-TC is where we conduct our mission analysis: what are we doing here? Well, you're gonna presumably receive a mission from somebody. From a tasking statement issued to you from a higher echelon, and that's going to include hopefully one or more of those tactical tasks we discussed. And and it may or may not. Hopefully it does, but we can usually extrapolate even if it doesn't. There's going to be explicit tasks and implied tasks and your goal here in mission analysis is just to make sure you understand what the task is, and then also to conduct purpose analysis. Understand the why. Why am I doing this? What is the commander's intent? And in our context here, we're really focusing on cost imposition of the adversary as well as generating options for pursuit. Our adversaries have gone unopposed for too long in cyberspace. Its time to start making this risky business for them and forcing them to have to burn time, money, and manpower.

#### Enemy Analysis

##### SALUTE

The first portion of the enemy analysis is going to be SALUTE. SALUTE captures the composition, disposition, and strength of the adversary. SALUTE stands for size, activity, location, unit, time, and equipment.

###### Size

How we are going to capture size in this context? Are we talking about a nation state? Are we talking about a single individual? Are we talking about cyber criminals? What we can do here is roughly correlate this to monetary backing. Because that really is a lot of what the resourcing is in cyberspace that determines an actor's size. There is also just this raw, rote technical capability they bring to bear as well. With the incorporation of agentic artificial intelligence into these work flows, size can be enhanced dramatically. But  that goes back to the to the monetary resourcing.

###### Activity

When stating activity, you're answering a question, "what are they doing?" We are going to map their activity to the MITRE ATT&CK framework.

###### Location

We are going to articulate the differences in physical and logical locations, we are going to make sure that we are explicit with that. Where are they doing their activity? If it's an on-premise server that is going to bring its own challenges versus if the activity is being conducted on a cloud server. We want to distinguish that. And there are two ends of the tunnel, so to speak. The enemy is physically sitting in country X. But they are logically operating in country Y. And the target is physically in country Y

###### Unit

Who is it? We say APT whatever and MCA -"blah blah blah". But most of the time it is a foreign intelligence entity or a military unit that is doing the hacking.

###### Time

When was the activity observed? Was it three months ago? Was it yesterday?

###### Equipment

What tools are they using? And in our context, I think that is pretty straightforward.

- Here is a good place for a quick group exercise where each team is given a report on a different APT and they have to do a SALUTE analysis then brief it to the group.
- APT28 FANCYBEAR
- GAMAREDON
- APT41 WICKEDPANDA
- NIGHTEAGLE
- VOIDBLIZZARD

##### DRAW-D

After you've. Done the analysis of the adversary's composition, disposition, and strength. You are going to assess their capabilities and limitations. The acronym DRAW-D and it stands for Defend, Reinforce, Attack, Withdraw, Delay. What we're asking for each one of these is: What is the enemy's capability to do it? What are they limited by in doing it? And under what conditions will they do it? So for example for withdraw: is this cyber actor capable of withdrawing from the network? What are they limited by in their withdrawal? Is it  such a hard access for them that the thought of fully withdrawing from the network is just unheard of. It took them forever to get in there in the first place. Under what conditions will they withdraw? This is probably one of the most fundamental things that we need to understand about our adversary. Because if we've been given some tactical task such as reconnoiter where we have to observe them. Or if we get given something like, deceive them, we can't really do that if their withdrawal condition is to leave under any sort of indication that we know that they're there. So that might influence our scheme of maneuver, the way we collect data, the way we put tools in the environment, the way we just conduct our business.

- Another group discussion doing a DRAW-D analysis on different threat actors. A big part of this is just learning what RFIs to submit to your intel section.

#### Troops and Fire Support

For troops and fire support, we're looking at the friendly counterpart of the salute. We're looking at organic assets that we have. How many people do I have? What are their specialties and skill sets? And what equipment do we have? Attachments is another consideration here. What/who has been attached to my unit? And if they become detached, how will that affect my ability to achieve mission success? The next consideration here is fire support available and think about this as rear echelon support. And the last consideration is higher and adjacent units. We need to consider potentially some deconfliction here. A question to ask is, "Are there other cyber units operating in this space."

#### Terrain Analysis

Once you've done your DRAW-D, it's time to do a terrain analysis. The terrain analysis has to be conducted from friendly and enemy perspectives and the acronym that we use for this is OCOKA-W. This stands for observation and fields of fire, cover and concealment, obstacles, key terrain, avenues of approach, and weather. And I know you might be thinking right off the bat, "what does this have to do with cyber operations?" There are probably some things in OCOKA-W that we don't need and there's probably some things that we should add.

##### Friendly OCOKA-W

- Observation and Fields of Fire
 	- For friendly observation and fields of fire we're going to center on the data sources we have. Do we have passive network taps? Yes or no? Do we have full pcap? Do we only have net flow? Do we have only user mode host based logs? Do we have EDR agents down that get us data from the kernel.
- Cover and Concealment
 	- Are we overt in in our activity? In transitioning from blue space into Gray and red are we are we going to use our own obfuscation infrastructure or are we just going to be very, very overt and open with.
- Obstacles
 	- In the physical world our considerations here are things like :Is there barbed wire or mines? But in cyberspace obstacles are  what? Think about what are their barriers to? What are the barriers to our scheme of maneuver? What are barriers to our data acquisition?
- Key Terrain
 	- Key terrain is is a hot topic in this space. People are so quick to throw out domain controllers as key terrain. Well, maybe not. To discern our key terrain in this context we really want to think of what the purpose is of the network that we're on, what is it facilitating? And you're trying to find where the critical information and critical function is of that network that's enabling the the operation that it was designed to conduct. The adversary is hacking it for a reason and that reason might be different than the reason for the existence of the network.
- Avenues of Approach
 	- How can the adversary achieve initial access into this environment? Think about the initial access techniques from the MITRE ATT&CK framework as avenues of approach.
- Weather
 	- Weather can directly impact the availability of power and communication links such as satellite communications.

##### Enemy OCOKA-W

- Observation and Fields of Fire
 	- What is the data available to the adversary? What are their sensors? How are they able to sense and observe the environment? If they have an insider, then that's a pretty crazy level of observation. As we're thinking about leaving blue space and transitioning from a defensive mission into an offensive mission and we are starting to touch their space what centralized logging and monitoring do have they set up on their infrastructure? Is it robust? Is there none at all? Take all those into consideration.
- Cover and Concealment
 	- What is the adversary doing to obfuscate or hide their activity? Are they loud and proud? Do they not care if we know that they're there and they are doing smash and grab operations? Or are they trying to match the baseline of the terrain they're operating in as much as possible?
- Obstacles
 	- What obstacles is the adversary facing?
- Key Terrain
 	- Consider key terrain in the context of the adversary's mission. What are they trying to accomplish? And what terrain, when they hold it, enables them to accomplish their mission?. We need to consider this across all three layers of cyberspace. Physical, Logical, and persona. The physical layer is: "do I have physical access to the router? to the server room?" What do I have logical access to? But also persona access. What do I have credentials for? Our key terrain in this context has to be considered up and down the technology stack. We can talk about the OSI model. It's physical at the bottom, it's User and Persona at the top, and logical in between.
- Avenues of Approach
 	- Avenues of approach? Same as before. What are those vectors into the network?
- Weather
 	- Same as friendly considerations.

#### Time/Space/Logistics Analysis

- Time:
 	- Some key considerations are: what is the enemy's mission? Are they conducting "smash and grab" operations or are they moving "low and slow" and are willing to wait out your team? In the case of oconus-off-dodin missions, there may not be a lot of dwell time for the team. A patient adversary with good intelligence may be able to just wait to resume operations until after the cpt leaves the terrain.

- Space:
 	- In our context we must consider all three layers of cyberspace: physical, logical, and persona. Will we have physical access to compromised assets? to data centers? Are we able to logically "touch" everything we need to from our position in the network? Do we have the right level of permissions in the network to do everything we want to do? What happens when the enemy has a more permissive level of access in the environment than the defensive team? How does this impact maneuver?

- Logistics:
 	- Force flow and equipment ingress are important considerations here. Is the team going to be under surveillance? If so, does a full complement of hunt equipment make sense?

#### Civilian Considerations

In conventional Tac Planning, the acronyms for civil considerations are ASCOPE and PMESII. While there are many considerations across these two things for conducting Counter Strike Operations, we are not going to delve to deeply into them.

Just know that there are civil implications for conducting these types of activities
![ASCOPE and PMESII](References/ASCOPE_PMESII.pdf)

### EMLCOA

So now that we've completed our estimate of the situation, METT-TC. Will analyze all aspects of our estimate to develop our comprehensive assumption of the enemy. The EMLCOA is the enemy's scheme of maneuver; it accounts for their task, purpose, and method of imposing their will. This is what we must counter with our plan.

#### What do I deduce is the enemy's mission?

What is the enemy's mission? What tactical task or tasks are they trying to accomplish?

#### What is the enemy's current tactical activity?

What are they doing right now? Are they staging for some sort of effects operation? Are they conducting persistent collect? Are they at the early phases of initial access where they're still trying to figure out where they are?

#### What are the enemy's actions on contact? How will they react when we impose our will on them?

What are the enemy's actions on contact? How will they react when we impose our will on them? How will they react when they start seeing us taking action against them? Contact refers to an input that alters the current state of the enemy. This will influence our scheme of maneuver in two ways. First, when we analyze the enemy's critical vulnerability and determine our exploitation plan, we will seek to build a scheme of maneuver that counters both what the enemy is doing now and what they will do on contact.

### Center of Gravity

"that element or capability which allows the enemy to execute his mission or scheme of maneuver successfully"

After we've determined the EMLCOA, it's time to do something about it. So next we're going to do a center of gravity analysis and the center of gravity is defined as, "that element or capability that allows the enemy to execute his mission or scheme of maneuver successfully". So what is that here? What, based on what we've assessed of the adversary and their mission, is the core piece that's allowing them to accomplish their mission? Is it stealth combined with Administrative credentials? Is it just simply because up until this point no one knew they were there and using the admin's creds that could be their center of gravity?

### Critical Vulnerability

"what vulnerability can be exploited that will render their center of gravity ineffective?"

What vulnerability can be exploited that will render their center of gravity ineffective? And so in our previous example for the center of gravity, we now know they're here and we know what credentials they're using and if that's the only solidified access they have in the environment and we remove their access to those credentials, then now we're starting to think about how we're going to, stop the enemy from accomplishing their mission.

### Exploitation Plan

"What method will I use to directly target the enemy's critical vulnerability?"

And finally, the exploitation plan is putting all these parts together and making a decision on what you're going to do about it. What method will you use to directly target the enemy's critical vulnerability? In blue space here in our context, we're really going to focus on the MITRE D3FEND and ENGAGE models as the starting point for directly countering the adversary's ATT&CK techniques. There is a direct mapping between MITRE ATT&CK to MITRE D3FEND and ENGAGE.

### Scheme of Maneuver

Our scheme of maneuver has to be able to accomplish the mission. This may sound like an obvious thing to state but it needs to be stated. Scheme of maneuver in this context includes how and when we occupy terrain at all three layers of cyberspace. How much do we know about the adversary and their ability to sense the target environment? Will the introduction of endpoint detection and response tools into the environment trigger the adversary's withdrawl condition? Is this something we want to have happen or not? Does the proposed sensor placement plan make sense for the given terrain and adversary? Can we acquire the data that we need from the environment without introducing too much change that will potentially alert the adversary? If we have no reason to believe that the enemy has kernel level implants, do we need to have kernel level visibility or will system logging be sufficient?

These are just a few considerations while developing a scheme of maneuver. We must create a scheme of maneuver that will achieve our exploitation plan.

### Fire Support Plan

Based on the leader's analysis of any supporting assets in the METT-TC, they must now identify how to integrate those assets into their plan. The Fire Support Plan (FSP) must be developed following the SOM development because the support assets must be integrated to directly support the SOM.

### Tasks

At the conclusion of the tactical thought process, we develop our tasks to our team that provide them the mission they must accomplish to allow our SOM to be successful. A key point is the appropriate task (preferably a tactical task) and purpose (an "in order to" statement). The purpose is the most important part of the statement as it allows for decentralized execution off of intent.

### References

- Tactical Planning Student Handout USMC TBS
- Operational Terms and Graphics USMC TBS
- MCDP 1 Warfighting
- MCDP 2 Intelligence


---

# Instructor Worked Example — FSB Center 18

What we are going to do now is apply the tactical planning process against a real world adversary. We are going to start with the FSB Center 18. There is a mindset that we need to drop in this course. Industry and government have gone down the path of decoupling the hackers from the military or foreign intelligence entity that they are apart of. We are not going to carry that mentality into this course. We are not attempting to hunt and counter the activities of "Gamaredon" or "invisimole". We are operating against the Russian FSB or against the Chinese MSS. These are our enemies and we are conducting tactical engagements with them. We intend to plan accordingly.

Our primary references for this lesson are: The Tactical Planning Process student handout and the two reports for ESET on FSB Center 18. What we are going to do is dissect these reports and plan a tactical mission against the FSB Center 18 as they conduct espionage.

## METT-TC -> EMLCOA -> CG/CV/EXP. PLAN -> SOM -> FSP -> TASKS

### Mission

- Deny or degrade the FSB Center 18's ability to collect intelligence from network X IOT perserve friendly freedom of maneuver in cyberspace.

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
  - Powershell, VBScript Weaponizers that weaponize office documents, usb drives, and LNK files *already present in the target environment*
  - PowerShell, VBScript Stealers that exfiltrate files, capture screenshots, exfiltrate cookies, etc.
  - PowerShell Backdoors that serve as remote shells
  - PowerShell socks proxies for pivoting through environments.
  - Final payload of a file stealer (see MONTEREY) whose main goal is to look for files with specific file extensions and exfiltrate them to the command and control server.
  - See more in reference [^3].

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

#### Friendly OCOKA-W

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

#### Enemy OCOKA-W

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
|---------------|-------------|------------------|-------------------|---------------|
|Adversary C2 Infrastructure (IP/Domain)|Phase 3 Triage confirms active beaconing to external IP|1. Block outbound traffic locally. 2. Gather all associated logs and artifacts. 3. submit a request for support to rear echelon|1. Conduct active reconnaissance from non-atrributable infrastructure. 2. Exploit identified vulnerabilities on C2 node.|Degrade, Disrupt, Exploit|
|Adversary Tool Repository/Staging Server|Dashboard detects execution of a novel payload; payload URL is extracted from memory|1. Prevent internal hosts from downloading payload 2. Extract URL 3. Submit a request for support|1. Enumerate the staging srever directory 2. Download theadversary's full toolkit for reverse engineering 3. Potentially neutralize the staging server|Deny: Prevent adversary from deploying secondary tools. Intelligence: feed new IoCs back into the SIEM|
|Compromised Third-Party Relay (e.g. coopted residential redirector)|Identification of traffic routing throug ha know compromised residential proxy|1. Null-route traffic to proxy locally 2. Submit a request for support|Coordinate with law enforcement or execute authorized DCORA|Disrupt: Force the adversary to rebuild their infrastructure|


### Tasks

To execute the scheme of maneuver effectively, we need to assign specific, actionable tasks to our organic team members. By dividing the labor into distinct toles, you ensure unity of effort and prevent overlap during high-tempo operations.

### Organic Asset Tasking: Outpacing the Adversary

| Role | Phase I: Prep & Baseline | Phase II: Detection | Phase III: Isolation & Triage | Phase IV: Hunt & Fire Support |
| :--- | :--- | :--- | :--- | :--- |
| **Mission Commander (MC)** | Define mission success criteria; verify ROE and target boundaries. | Monitor team tempo; authorize transition from Phase II to Phase III. | Authorize host quarantine; manage risk of operational disruption to friendly forces. | **Draft and submit the Cyber Request for Fire (RFF)** to Rear Echelon; coordinate target handoff. |
| **Threat Intel (Intel)** | Provide Gamaredon IoCs/TTPs to NetOps; construct the initial EMLCOA. | Monitor open-source intel for shifting adversary TTPs during the ambush phase. | Analyze extracted tools to confirm attribution; predict adversary's "Actions on Contact." | Translate new findings into MITRE ATT&CK sub-techniques; update the EMLCOA for the next hunt iteration. |
| **Network Analyst (NetOps)** | Build "allow-list" SIEM dashboards for Process Creation (Event 4688) and Registry Mods. | Monitor dashboards for deviations from the baseline; trigger the Phase III alert. | Null-route identified C2 IP addresses at the local firewall to sever adversary communication. | Package PCAP and NetFlow data for the MC to include in the RFF; hunt for lateral movement. |
| **Host Analyst (HostOps)** | Deploy EDR baseline policies; ensure triage scripts and live forensic tools are staged. | Stage on "standby" to execute immediate quarantine upon NetOps alert. | **Execute immediate EDR quarantine;** run live triage scripts to extract volatile memory, active processes, and staged payloads. | Sweep the enterprise via EDR for newly discovered file hashes or persistence mechanisms found during triage. |

### Summary

In this lesson, we applied the tactical planning process to a real-world adversary, FSB Center 18. We conducted a thorough analysis of the enemy's composition, disposition, strength, capabilities, and limitations. We then developed an EMLCOA based on our understanding of the enemy and the terrain. Finally, we created a detailed scheme of maneuver and tasking plan to outpace the adversary and achieve our mission objectives.

### Sources

[^1]: <https://www.gov.uk/government/publications/russias-fsb-malign-cyber-activity-factsheet/russias-fsb-malign-activity-factsheet>
[^2]: <https://unit42.paloaltonetworks.com/gamaredon-primitive-bear-ukraine-update-2021/>
[^3]: <https://web-assets.esetstatic.com/wls/en/papers/white-papers/cyberespionage-gamaredon-way.pdf>
