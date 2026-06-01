Counterstrike Operator Course{{{
	Objectives{{{
		- Conduct military tactical planning in the context of DCO-RA
		- Exploit oppertunities froma position of advantage in bluespace
		- Deny adversary ability to accomplish their mission in cyberspace
		- Rapidly access and effect adversary infrax
	}}}
	Military Tactical Planning{{{
		Objectives{{{
			understand the process of conducting a mett-tc analysis, recall and apply each component given a scenario.
			comprehend steps in conducting a draw-d
		}}}
		Intro to military tactical planning{{{
			What are tactical tasks?(MCRP 5-12a){{{
				actions that can be taken to accomplish a mission.
					- enemy-oriented
					- terrain-oriented
					- friendly-oriented
			}}}
		}}}
		Tactical Planning Process{{{
			Planning Chain{{{
				METT-TC > Enemy Most Likly COA > CG/CV/EXPloitation Plan > Scheme Of Manuvre > FSP > Tasks
			}}}
			BAMCIS: founational framework for military leadership and planning at the tactical level{{{
				Beging the planning - involves an initial assessment using METT-TC
				Arrange recon - determine info gaps and plan to fill them through recon and surveil
				Make recon - exec the recon plan to confirm or deny assumptions about the enemy and terrain
				Complete the planning - finalize the operational plan based on updated info gathered durring recon
				Issue the order - clearly and consisly communicate the finalized plan to subordinate leaders
				Supervise - oversee the execution of the plan, making adjustments as the situation evolves.
			}}}
			METT-TC: primary tool used to begin the planning. systematic analysis of the key variables in any tactical situation{{{
				Mission - analyze specified and implied tasks from higher echelons. understand the "why"(commander's intent)
				Enemy - analyze adversary composition, disposition, strength, and capabilities
				Troops & Fire Support - catalog organic and attached assets, skills, tools, and higer-level support
				Terrain & Weather - analyze the digital and physical env from both friendly and adversarial perspectives
				Time/Space/Logistics - assess the time available, operational area(log/phys), and logistical constraints
				Civilian Considerations - evaluate potential impacts on non-combatant populations and infrax
			}}}
			Mission analysis{{{
				core tasks: understand the units mission and the commanders intent
				process{{{
					Ideintify tasks - deconstruct the order from higher echelon
						specified tasks - explicitly stated
						implied tasks - not explicitly stated but necessay the mission accomplishment
					Conduct Purpose Analysis - determine the "why" behind the mission
						what is the desired end-state?
						what is the commanders overall intent?
				}}}
			Enemy Analysis{{{
				SALUTE - paints a clear picture of the Enemy{{{
					Size - nation-state, criminal group, or indiv? assess via estemated monitary backing, manpower, and tach caps
					Activity - What are they doing? map adversary action to a standardized framework like MITRE ATT&CK
					Location - Where are they operating? differenciate phys and log Location
					Unit - Who are they? ID specific threat actor groups and their affiliation(eg. foreign intel or military unit)
					Time - When was the activity observed? recency is critical to assessing current threat
					Equipment - What tools are they using? ID spcific malware, C2 frameworks, and exploit kits
				}}}
				DRAW-D: Caps and Limitations{{{
					Defend - can they defend their infrax and access? what defensive tools are in place?
					Reinforce - Can they escalate priv, deploy additional tools, or establish redundant C2 channles?
					Attack - What is their capability to conduct offensive effects operations from their current posture?
					Withdraw - Can they exfil and remove their presence? is their access too valuble to abandon? under what conditions will they withdraw?
					Delay - Can they disrupt our analysis or response
				}}}
			}}}	
			Friendly Force Analysis{{{
				Troops & Fire Support{{{
					the friendly counterpart to enemy analysis. catalog all available resources.
				}}}
				Organic Assets{{{
					Personnel - how many operators? what are their specific specialties, skill sets, and certifications?
					
				}}}
				Terrain Analysis{{{
					must be conducted from both the friendly and enemy perspectives. In cyberspace, "terrain" is the network env.
					OCOKAW - friendly perspective - enemy perspective
						Observation and fields of fire - what are our data sources? what is our vis into the env? - what are their sensors(insider access, compromised logging, C2 beacons)? what is their situational awareness?
						Cover and Concealment - will our actions be overt or covert? will we use dedicated obfucation infrax)? - how are they hiding (matching network baseline, using encryption, "smash and grab" with no stealth)?
						Obstacles - what barriers hinder data aquisition or scheme of manuver(eg. firewalls, encryption, lack of logging)? - what obstacles do they face(edr, application allow-listing)?
						Key terrain - what is the critical func/info on this network? - what terrain is critical for their mission (eg. a specific database,  
						Avenues of Approach - how can we gain or improve access? - how did they get in, and how can they move? map to mitre att&ck initial access techniques
						Weather - phys weather can effect power and satcom, impacting phys infrax - same as friendly
				}}}
				Time/Space/Logistics & Civilian Considerations{{{
					time analysis
						how much time is available to plan and execute the mission?
						what is the adversaries timeline?
						how much time zone diff 
				}}}
			}}}
			}}}
			EMLCOA{{{
				after completing the METT_TC analysis, synth the finding s to dev a comprehensive assumption of enemy actions. the ELMCOA answers 3 questions
					what is the enemys mission?
						EX: is the enemy trying to achieve a specific tactical task like exfil sensitive data, or disrupt a crit svc?
					what is the enemys current tactical activity?
						EX: are they staging tools for an attack? conducting active recon? maintaining persistance?
					what are the enemys actions on contact?
						EX: how will they react when we take action against them? will they delete their presence, deploy ransomware, or escalate their activity?
				Center of Gravity & Critical Vulnerability
					COG - that element or capability which allows the enemy to execute their mission
					CV - a vuln that, if exploit, will render the enemy COG ineffective
				Exploitation Plan{{{
					what specific action(s) will we take to neutralize the enemys COG by exploiting their CV?
					cyberspace applications
						for defensive, bluespace ops, the MITRE D3fend framework is a valuble starting point
				}}}
				scheme of manuver{{{
					how the elements of the exploit plan will be implemented in a coordinated manner, often through designated phases of operational
					firesupport Plan
						parallel concept of cyberops
						coord the use of rear ech support
						ensure actions are deconflicted
				}}}
			}}}
		}}}
		ATT&CK to D3fend and Engage{{{
			steps{{{
				1. eyes on aversary: conduct recon
				2. map to ATT&CK: map observed ttps to the framework
				3. determine mission: determin the enemys mission and their EMLCOA
				4. map to D3fend/Engage
				5. provide bluespace options: present defensive courses of action to the commander
				6. move out of bluespace: transition from defense to offence
			}}}
			Step 1: Recon{{{
				assumption: the hunt has been successful. you have found the adversarys activity.
				critical imparitive: do not alert the enemy. stealth preserves your options.
				mission focus: your primary mission is to conduct recon to determine the enemy's:
					Scheme of manuver
					TTPs
					Overall mission
			}}}
			Step 2: Mapping raw data to MITRE{{{
				
				
				Three approaches{{{
					1. start with theh data source
						begin with your logs(sysmon, edr, netflow) and ask:
							what is the object? (file, process, driver)
							what is the action?(read, write, execute)
							what techniques require this activity?
					2. start with specific tools or attrib
						id known tools(mimiktz), system components(registry), or commands. 
						search the att&ck repo for techniq that align with these items.
					3. start the analytics
						use existing detecton rules(sigma, mitre car) to id malicious activity and map it back to the technique
				}}}
			}}}
			Step 3:{{{
			}}}
			Step 4: 
			engage categories{{{
				expose
					Purpose
					collect
					detect
				affect
					
					Purpose: changing the cost-value proposition in cyber ops for the adversary, increase cost to operate, drive downthe value they derive from their ops
					prevent
						stop the aversary actions as intended
					direct
						encourage the adversary to take action in a diferent part of the network
					disrupt
						stop adversarial action
				elicit
					Purpose: encourage adversaries to reveal additional or more advanced TTPs and goals while operating in defender-controlled engagement environments
					reassure
					motivate
			}}}
			COAs
				1. harden
					action: agressive application whitelisting, block all usb devices
					pro: most effective denial of adversay ttps
					con: high op impact, may break legacy apps.
				2. detect and respond
					action: use seim alerts for powershell with base64/invoke-expression and wmi queries
					pro: lower op impact, directly counters observed behavior
					con: purly defensive and reactive
				3. decieve
					action: use engage lure/reveal. create beaconed documents and place them on USBs
					pro:
					con:
			step 6: moving out of BS
				this means tx from def to off, leveraging our firesupport Plan
				
		}}}
	}}}
    Passive recon{{{
	    intro to recon{{{
		    passive vs active recon{{{
			    Passive Recon- Involves collecting data from existing sources without direct interaction with target systems or networks. Benefits of passive recon are a low detection risk, and compliance with Rules of Engagement (ROE) that restrict overt actions.
				Active Recon- Entails direct probing of adversary infrastructure (e.g. port scanning, vulnerability enumeration) to elicit responses and gather detailed information.			    
		    }}}
		    role of recon in cyberspace{{{
			    Recon is the initial phase of cyberspace operations when intelligence is gathered on adversaries to inform decision-making.
		    }}}
		    IOCs and artifactis in bluespace{{{
			    What are IOCs? 
				    forensic artifacts or evidence of malicious activity left behind by attackers during an intrusion. IOCs can include items like IP addresses, domain names, file hashes, registry keys, or network patterns that can be used to detect, investigate, and attribute attacks. In passive reconnaissance, IOCs are analyzed from existing logs and artifacts in the blue network without generating new traffic or alerting the attacker.
				Actionable Intelligence from IOCs:
					IOCs provide rich, passive intelligence that threat hunters can mine to understand attacker operations, reconstruct timelines, and identify leverage points for counterstrike actions. Focus on extracting details like configurations, credentials, and patterns that reveal attacker weaknesses or infrastructure.

				Hardcoded Passwords or Credentials: 
					Malware or tools dropped by attackers often contain embedded credentials for their own infrastructure (e.g., API keys for C2 servers or admin logins for staging sites).
						Actionable Insight: Extract these from binary analysis (e.g., using strings command on malware samples) or script reviews. In a counterstrike context, these could enable authorized disruption, such as reporting to registrars or using them to access shared resources if permissible under ROE—e.g., identifying a weak password reused across attacker tools for potential sinkholing.
						Example: In a ransomware sample, a hardcoded FTP password for exfiltration might point to an attacker-controlled server; passively search OSINT for that server to map their OPSEC gaps.
				Certificates and SSL/TLS Artifacts: 
						Attackers use self-signed or stolen certificates for C2 communications, often visible in network captures or endpoint logs.
							Actionable Insight: Analyze certificate details using tools like openssl or Wireshark's passive dissection to uncover additional attack vectors. This can reveal hidden infrastructure like subject alternative names (SANs) that list extra domains or IP addresses for targeting in counterstrikes. Extracted certs can also be repurposed to forge trusted connections. Mismatched or expired certs highlight poor OPSEC, enabling prediction of infrastructure shifts for timed disruptions.
							Example: A C2 beacon's cert might include SANs pointing to unmonitored staging servers; passively enumerate these via OSINT to expand the target list for authorized exploits. Alternatively, reuse the cert's private key (if derivable from artifacts) to spoof a trusted connection, tricking the attacker's malware into accepting a reverse shell or data upload from blue space.
				Timing and Behavioral Patterns: 
					Logs may capture timestamps of attacker actions, such as login times, data exfiltration windows, or beaconing intervals, revealing operational hours or automation scripts.
						Actionable Insight: Correlate timings across IOCs (e.g., via SIEM timelines) to infer attacker locations (e.g., UTC offsets suggesting Asia-based ops) or routines (e.g., daily check-ins). This enables "hack back" timing—e.g., passively monitoring for predictable recon windows to deploy decoys or disrupt without direct engagement.
						Example: If IOCs show consistent 2 AM UTC beacons, hunters can anticipate and passively log future activity, building a case for proactive defenses like matching the pattern of life for the implant if attempting an exploit.
				Encryption Keys and Configuration Data: 
					Attacker tools like Cobalt Strike or custom RATs may leave partial keys, salts, or config files in memory dumps, registry, or temp files.
						Actionable Insight: Use memory forensics (e.g., Volatility) to extract these passively. Keys can decrypt C2 traffic samples, exposing plaintext commands or additional IOCs. In counterstrike planning, this reveals encryption weaknesses (e.g., reused keys across campaigns), allowing hunters to decode communications or identify pivot points for disruption.
						Example: A leaked AES key from a dropped implant could decrypt captured payloads, revealing hardcoded attacker IP addresses—use this to passively track infrastructure migrations without scanning.
		    }}}
		    OSINT{{{
			    leverages publicly available data to identify adversary infrastructure and TTP for counterstrike planning, focusing on mapping targets and effective techniques without direct interaction.
			    Key Sources{{{
				Threat Intel Feeds: Platforms like AlienVault OTX, MISP (Malware Information Sharing Platform), or MITRE ATT&CK framework to search IOCs for associated infrastructure, tools, and operational patterns.
				Search Engines and Databases: Use Google Dorks (e.g., "site:example.com inurl:admin" for exposed attacker panels) or Shodan/Censys for passive device fingerprinting (e.g., searching exposed RDP ports tied to IOC IP addresses) to reveal additional targets.
				Social Media and Forums: Monitor Pastebin, Reddit (r/netsec), or Twitter for leaked attacker tools/configs. Tools like Maltego or SpiderFoot automate OSINT graphing to connect IOCs to broader networks.
				}}}
				Target Identification and TTP Mapping Process{{{
					Input IOC (e.g., malware hash) into VirusTotal or Hybrid Analysis to uncover linked domains, IPs, and infrastructure used by the actors.
					Cross-check with reports from Mandiant, CrowdStrike, or Recorded Future for TTP details (e.g., common C2 protocols, exploitation methods) that can be mirrored or countered.
					Profile operational details: Preferred tools (e.g., RAT configurations), network patterns (e.g., beaconing cadences), and infrastructure (e.g., VPS providers) to select effective strike techniques.
				}}}
		    }}}
		    Domain Enumeration{{{
			    Tools and Techniques
					WHOIS and RDAP Queries: Use tools like whois or ICANN's RDAP to passively retrieve registrant details (e.g., email, organization) for suspected domains from IOCs, uncovering contact points or shared infrastructure for targeting.
					Passive DNS Enumeration: Platforms like PassiveTotal or DNSDumpster aggregate historical DNS records without active resolution. Search for subdomains (e.g., api.attacker.com) linked to main domains to expand the target footprint.
					Certificate Transparency Logs: Tools like crt.sh query public logs for SSL certs, exposing hidden subdomains or related domains (e.g., if attackers reuse certs across ops) that can be prioritized for disruption.
					Domain Correlation: Use VirusTotal or Recorded Future to find domains sharing IP addresses/ASNs with known malicious ones, mapping attacker networks for comprehensive targeting.
				Application to Threat Hunting
					From blue space IOCs (e.g., a domain in a log file), enumerate to find "neighbor" domains and subdomains for broader targeting in authorized operations.
					Example: If an IOC domain is evilcorp.ru, passive search might reveal interconnected domains hosting admin panels or C2 staging sites, ideal for coordinated strikes.
					Hands-On Tip
					Integrate with OSINT—feed enumerated domains into threat feeds to identify exploitable patterns like weak configurations or timing windows.
		    }}}
			Vulnerability Searches{{{
				Sources and Methods
					CVE Databases: Search NIST NVD or Exploit-DB with IOCs (e.g., software versions from Shodan scans of attacker IP addresses) to find exploitable vulns passively.
					Search Engines: Shodan/IoT Search for devices tied to attacker domains (e.g., query "port:443 hostname:malicious.com" to see server banners revealing vuln software like outdated Apache).
					Vuln Intel Platforms: Use VulnDB or OpenVAS's passive mode to correlate IOCs with known exploits, without scanning.
				Tying to Blue Space
					Analyze attacker tools left behind (e.g., an old Metasploit version in logs) for vulns that could be reversed against them.
				Strategic Use
					In threat hunting, this reveals "boomerang" opportunities—e.g., if an attacker's C2 server runs a vulnerable WordPress, note it for potential future disruption.
				Example Workflow
					 IOC IP → Shodan search → Exposed vuln (e.g., CVE-2023-1234) → Cross-check with OSINT for actor exploitation history.
			}}}
	    }}}
    }}}
}}}