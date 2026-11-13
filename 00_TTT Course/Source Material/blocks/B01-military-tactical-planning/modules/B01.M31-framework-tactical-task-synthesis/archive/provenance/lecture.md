# Back to MITRE ATT&CK

This final lecture outline bridges the gap between the defensive/planning phase (Week 1) and the upcoming offensive execution phases (Weeks 2-5). It serves as the pivot point where students transition from mapping adversary TTPs for planning actions in bluespace (D3FEND/ENGAGE) to mapping those same TTPs for emulation and exploitation (CTE/DCO-RA(Counterstrike)/Offense).

### References
I. Introduction
    - Recap of the DCO-RA Mindset
    To recap, the DCO-RA mindset is about understanding the adversary's TTPs in order to effectively plan and execute defensive actions. It involves mapping out the attacker's techniques and tactics to identify vulnerabilities and opportunities for intervention. This mindset is crucial for effective cyber defense, as it allows defenders to anticipate and counteract potential attacks.

    - The Limits of defense
    While the DCO-RA mindset is essential for effective defense, it has its limits. It is primarily focused on understanding and countering the adversary's actions, but it does not necessarily provide insight into how to effectively emulate or exploit those TTPs. This is where the offensive side of the equation comes into play, which we will explore in the upcoming weeks.

    - The Goal of Weeks 2-5
    The goal of Weeks 2-5 is to transition from the defensive mindset of DCO-RA to the offensive mindset of emulation and exploitation. We will be using the MITRE ATT&CK framework as a guide for understanding and emulating adversary TTPs, and we will be exploring various offensive tools and techniques to effectively execute our cyber operations. By the end of this course, students should have a solid understanding of both defensive and offensive cyber operations, and how to effectively apply that knowledge in real-world scenarios.

II. The Dual Nature of MITRE ATT&CK
    - ATT&CK as a Defensive Map (Review)
    By now, you should be familiar with MITRE ATT&CK as a comprehensive framework for understanding and mapping adversary TTPs in the context of cyber defense. It provides a structured way to analyze and categorize the various techniques and tactics used by attackers, which can inform defensive strategies and actions.

    - ATT&CK as an Offensive Playbook (New Concept)
    However, MITRE ATT&CK is not just a defensive tool; it can also be used as an offensive playbook. By understanding the techniques and tactics outlined in the ATT&CK framework, defenders can also learn how to leverage those techniques. This dual nature of ATT&CK allows for a more holistic approach to cyber operations, where defenders can both anticipate and counteract attacks while also conducting their own offensive operations.

III. Transitioning to Offensive Tooling and Execution
    - Introduction to the Offensive Operator's Arsenal
    There is a entire arsenal of offensive tools and techniques at your disposal and 99% of them are on github. In the upcoming weeks, we will be exploring some of the most commonly used offensive tools and techniques, such as Sliver, Impacket, Metasploit, and various custom scripts and frameworks. These tools will allow you to effectively conduct DCO-RA(Counterstrike) operations.

    - The Concept of "Safe Emulation" and Operational Testing
    Something we are going to be doing in the upcoming weeks is "safe emulation" which is a concept that involves emulating adversary TTPs in a controlled and safe environment. This allows us to test and validate our defensive and offensive strategies and actions without risking actual harm to our systems or networks. Operational testing is a crucial part of this process, as it allows us to identify any issues and make necessary adjustments.

IV. Capstone Exercise Preview
    - Overview of the Capstone Exercise

V. Conclusion and Forward Look
    - Final Thoughts
    - Homework/Prep for Week 2


### Moving Out of Bluespace

Moving Out of Bluespace
"Moving out of Bluespace" means transitioning from defense to offense. This involves leveraging the Fire Support Plan we developed in Lesson 2. The intelligence we gather from ATT&CK and D3FEND directly enables our ability to call for fire.

From ATT&CK to Targeting: When our Process Spawn Analysis (D3-PSA) detects a Gamaredon downloader, we can extract the C2 IP address. This IP address is not just an indicator; it is a target.

From D3FEND to a Request for Fire: Our defensive action is to block that IP at our boundary. Our offensive action is to package that target data (IP, port, protocol, timestamp) into a Cyber Request for Fire (RFF).

From ENGAGE to Battle Damage Assessment: If we use the Reveal technique and our beaconed document is opened at an IP address in a foreign country, this provides critical intelligence for a potential OCO mission. This serves as a form of Battle Damage Assessment (BDA) for our deception operation.

This process transforms our hunt team from a purely defensive element into the forward observers for a larger, integrated cyber fires team.

## References
