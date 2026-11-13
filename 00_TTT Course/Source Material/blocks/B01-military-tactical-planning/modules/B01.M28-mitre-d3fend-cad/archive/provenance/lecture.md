## MITRE D3FEND CAD

#### Outline
1. Introduction
2. What is a D3FEND Graph?
3. How to use CAD
4. Creating a node
5. Selecting a D3FEND Class
6. Exploding the Node
7. Creating and Selecting Edges
8. Adding New Classes
9. Additional Features
10. Essential Tips
	1. Focus on artifact provenance
	2. be as specific as possible
	3. model incrementally and save often

#### 1. Introduction
For this course we are going to be using the MITRE D3FEND CAD (referred to as MITRE CAD from here on out) tool as our way to graphically communicate the discovered enemy operation as well as our blue space response to it. MITRE CAD can be found at  https://d3fend.mitre.org/cad. MITRE CAD is underpinned by the D3FNED Ontology which provides the underlying structure that makes this type of mapping and graphing possible.

#### 2. What is a D3FEND Graph?
From the blog: "Myriad representations of “attack graphs” exist in the literature and practice. These are often property graphs which conflate actions, objects, and changes to those objects... A D3FEND Graph is a [knowledge graph](https://en.wikipedia.org/wiki/Knowledge_graph) which comprises discrete activities, objects, and conditions and all of their necessary relationships—all conforming to the [D3FEND Ontology](https://d3fend.mitre.org/resources/ontology/)."

#### Quick Start Example
Everyone can browse to https://d3fend.mitre.org/cad/
Once you are there, click: File -> Example Graphs -> Shadowcat.json

#### 3. How to Use CAD
Our main focus is on creating graph nodes and relationships.
##### Nodes
Nodes are the building blocks of CAD graphs, and are used to represent various entities derived from the D3FEND ontology. CAD groups its nodes into several categories based on similarities in their semantics and purpose.

- Action Nodes
	- Intended to capture actions that occurred or may occur in the cyber domain.
	- Event
		- this node captures instances of events and is therefore mapped to the d3f:Event ontology class.
		- Example: Remote Command
	- Attack
		- This node captures instances of attacker steps (i.e., as part of a kill chain) and is therefore mapped to the d3f:ATTACKEnterprise ontology class which captures the full set of ATT&CK Techniques.
		- Example: Keylogging
	- Countermeasure
		- This node captures instances of cyber countermeasures and is therefore mapped to the full set of defensive Tactics and Techniques available in D3FEND.
		- Example: File Carving
- Object Nodes
	- Intended to granularly capture objects associated with the cyber domain.
	- Artifact
		- This node captures instances of physical, information, and information bearing artifacts associated with a digital computer system and is therefore mapped to the d3f:Artifact ontology class.
		- Example: Network Packet
	- Agent
		- This node captures instances of a person or non-person entity, including threat actors
		- Example: APT28
- State Nodes
	- Intended to capture states or conditions that may be associated with other CAD nodes.
	- Vulnerability
		- This node captures instances of software vulnerabilities and their underlying weaknesses, and is therefore mapped to the d3f:Weakness ontology class.
		- Example: Absolute Path Traversal
	- Condition
		- This node captures any condition associated with another CAD entity, and is therefore open-ended in nature.
		- Example: The resulting effect of a particular Attack node
- Miscellaneous Nodes
	- Miscellaneous nodes are entities that can provide additional context about other nodes or capture things that aren't in the CAD menus (either because they are too abstract for general scenario use or are out of scope for the D3FEND ontology).
	- Note
		- This node is intended to capture any notes, comments, or annotations that can provide additional context in a CAD graph.
	- Thing
		- This node is intended to capture any objects or concepts that are outside the scope of D3FEND, such as non-cyber physical entities.
		- Example: Data Center
![](References/node_anatomy.jpg)

#### References:
https://d3fend.mitre.org/blog/building-d3fend-graphs-with-d3fend-cad/
https://d3fend.mitre.org/cad/
https://d3fend.mitre.org/cad/docs/
