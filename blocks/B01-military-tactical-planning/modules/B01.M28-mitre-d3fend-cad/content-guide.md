---
id: B01.M28
title: MITRE D3FEND CAD
artifact_type: content_guide
audience: instructor
block: B01
module_type: lecture
legacy_aliases:
- legacy/week1/content-guides/4. MITRE D3FEND CAD Content Guide.md
- ingest/incoming/mitre_d3fend_cad_overview.pptx
- B01.M23
source_kind: markdown
render_mode: generate
source_status: canonical
review_required: false
output_formats:
- pptx_instructor
- pptx_student
- docx_lesson_plan
template_profile: content_guide_v1
sensitivity: course_internal
provenance:
  path: ingest/archive/c5c3a65dd715_mitre_d3fend_cad_overview.pptx
  sha256: c5c3a65dd7157d745f9b5711d1c1ff4311886011aec474eae2a08dedb9790801
---

# MITRE D3FEND CAD — Content Guide

**Source:** `archive/provenance/lecture.md`
**Audience:** CPT operators who have completed the attack-to-defend analytical arc.
**Duration:** ~1.5 hours (lecture + live Quick Start + mini-build exercise)
**References:**

- `archive/provenance/lecture.md`
- `../../references/node_anatomy.jpg`
- https://d3fend.mitre.org/cad/
- https://d3fend.mitre.org/cad/docs/
- https://d3fend.mitre.org/blog/building-d3fend-graphs-with-d3fend-cad/
- https://d3fend.mitre.org/resources/ontology/

## Instructor resources and pre-class

- Classroom projector and screen; workstations that can open D3FEND CAD
- Whiteboard for comparable-across-teams answers and mini-build checklist
- Live tab: https://d3fend.mitre.org/cad/; CAD docs, blog, and ontology pages
- Instructor copy of `../../references/node_anatomy.jpg` for Slide 10
- Nested briefs for `B01.M29` (Shadowcat exploration) and `B01.M30` (CAD mini-build)
- Navigator layers and paired D3+EAC option sheets students already produced

## Student resources

- Student workstations with https://d3fend.mitre.org/cad/
- Nested student briefs for `B01.M29` and `B01.M30`
- Navigator layer and paired option sheet (keep open)
- Exported CAD JSON
- No additional student kit beyond CAD and the prior-layer products

## Dual opening

### Option 1 (Interactive / Whiteboard / Kinesthetic)

- **Say:** "CAD is the communication product for the analysis you already completed. The goal is not a pretty picture; it is a typed, evidence-grounded graph another team can understand."
- **Do:** Sketch one Agent, Attack, Artifact, Condition, and Countermeasure on the board and connect them. Tell teams to keep the Navigator layer and paired option sheet available.
- **Ask (Q):** What two products do you keep open for CAD?
- **Expected Response (A):** Steer toward the Navigator layer and the paired D3+EAC option sheet.

### Option 2 (Digital Slide / Virtual / Slide Deck)

- **Say:** "CAD is the communication product for the analysis you already completed. The goal is not a pretty picture; it is a typed, evidence-grounded graph another team can understand."
- **Show:** The objectives and example graph.
- **Do:** Have teams keep their Navigator layer and paired option sheet available.
- **Ask (Q):** What two products do you keep open for CAD?
- **Expected Response (A):** Steer toward the Navigator layer and the paired D3+EAC option sheet.

---

### Slide 1: MITRE D3FEND CAD Objectives (5 min)

- Explain how a D3FEND knowledge graph differs from an untyped diagram
- Identify action, object, state, and miscellaneous node categories
- Build typed relationships between adversary activity, artifacts, conditions, and countermeasures
- Preserve artifact provenance and export a reusable CAD graph

**Instructor Notes:**

- **Image Prompt:** A compact knowledge graph with one Agent, Attack, Artifact, Condition, and Countermeasure node.
- **Say:** "CAD is the communication product for the analysis you already completed. The goal is not a pretty picture; it is a typed, evidence-grounded graph another team can understand."
- **Show:** The objectives and example graph.
- **Do:** Have teams keep their Navigator layer and paired option sheet available.
- **Ask (Q):** What two products do you keep open for CAD?
- **Expected Response (A):** Navigator layer and paired D3+EAC option sheet.

### Slide 2: MITRE D3FEND CAD — What and Why (5 min)

- **CAD:** *Cyberspace Attack Diagrammer* — MITRE's D3FEND graphing tool
- Graphs **adversary activity** and **our blue-space response** in one artifact
- Underpinned by the **D3FEND Ontology** — structured, consistent, shareable
- We use CAD to communicate plans to commanders and peers

**Instructor Notes:**

- **Image Prompt:** A stylized knowledge-graph visual with a handful of labeled nodes (Attack, Artifact, Countermeasure, Agent) connected by labeled edges. Minimalist, clean, non-busy.
- **Say:** "CAD is how we draw the story. You did the analysis in the last block — ATT&CK mapping, EMLCOA, D3FEND counterparts, options for the commander. CAD is where all of that becomes a single picture a commander can read in two minutes."
- **Show:** Live-open https://d3fend.mitre.org/cad/ in a browser. Let them see it on the projector.
- **Do:** Preview: "We will do a Quick Start together, then tour the node types, then you will build one."
- **Ask (Q):** What is CAD for, relative to the analysis you already completed?
- **Expected Response (A):** Communication product. Typed, evidence-grounded graph a commander can read. Not a pretty picture.

### Slide 3: What is a D3FEND Graph? (5 min)

- Most "attack graphs" out there are property graphs — they **conflate** actions, objects, and state
- A **D3FEND Graph** is a **knowledge graph** — discrete activities, objects, and conditions with typed relationships
- Every node and edge conforms to the **D3FEND Ontology**
- That structure is what makes graphs **comparable across teams**

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "The critical distinction — from the MITRE blog, verbatim — is that existing attack graphs conflate actions, objects, and state changes. A D3FEND graph keeps them typed and separate. That is what makes two analysts working the same intrusion on opposite sides of the world produce graphs that can be compared."
- **Show:** Read the definition slowly. Linger on the word "discrete."
- **Do:** Ask: "Why do we care about 'comparable across teams' in DCO-RA?" Drive toward hand-off, deconfliction, and joint operations.
- **Ask (Q):** Why do we care about comparable-across-teams graphs in DCO-RA?
- **Expected Response (A):** Steer toward hand-off, deconfliction, and joint operations. Typed nodes make graphs comparable.

### Slide 4: Quick Start — Load the Shadowcat Example (3 min)

- Browse to https://d3fend.mitre.org/cad/
- **File → Example Graphs → Shadowcat.json**
- Explore the loaded graph before we build our own
- Shadowcat is the canonical teaching example from MITRE

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Everyone open https://d3fend.mitre.org/cad/ on your laptop. Go to File, Example Graphs, and pick Shadowcat.json. When it loads, do not click anything — just look. I want you to see the shape before we talk about the pieces."
- **Show:** Demonstrate the load on the projector. Zoom and pan the graph.
- **Do:** Give the room **3 minutes** of silent exploration. Ask: "Before we name anything — what jumps out at you?" Accept 2-3 answers. Nested drill: B01.M29.
- **Ask (Q):** Before we name anything, what jumps out at you on the Shadowcat graph?
- **Expected Response (A):** Facilitation. Accept 2-3 answers. Nested drill: B01.M29.

### Slide 5: CAD Node Categories (5 min)

- Nodes are grouped by **semantics**, not by color
- Four categories:
  - **Action Nodes** — things that happened or may happen
  - **Object Nodes** — the things in the cyber domain
  - **State Nodes** — conditions or vulnerabilities
  - **Miscellaneous Nodes** — context that doesn't fit the ontology strictly

**Instructor Notes:**

- **Image Prompt:** A 2x2 grid of MITRE D3FEND CAD node categories, not a consumer-app UI. Tiles labeled Action, Object, State, Miscellaneous. Action shows Event / Attack / Countermeasure (examples Remote Command, Keylogging, File Carving). Object shows Artifact / Agent (Network Packet, APT28). State shows Vulnerability / Condition (Absolute Path Traversal, attacker holds credentials). Miscellaneous shows Note / Thing (Data Center as a physical building). Do not use Run, Click, Shake, Book, Phone, Mug, Happy, Sad, or Favorite-star icons.
- **Say:** "Four buckets. Action, Object, State, Misc. We are going to walk each one in turn. Whenever you place a node in CAD, you are picking from one of these four buckets first and then refining."
- **Show:** The 2x2 grid; keep it on the side monitor for the next three slides.
- **Do:** Preview: next three slides cover Action, Object, and State in detail.
- **Ask (Q):** When you place a node in CAD, what do you pick first?
- **Expected Response (A):** One of four buckets — Action, Object, State, or Miscellaneous — then refine.

### Slide 6: Action Nodes (5 min)

- **Event** — instances of events (mapped to `d3f:Event`)
  - Example: **Remote Command**
- **Attack** — adversary steps, mapped to the full **d3f:ATTACKEnterprise** technique set
  - Example: **Keylogging**
- **Countermeasure** — defensive tactics/techniques from D3FEND
  - Example: **File Carving**

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Action nodes capture things that happened, things the adversary did, or things we did in response. Events are generic; Attacks are specifically ATT&CK techniques; Countermeasures are specifically D3FEND techniques. The ontology does not let you smear those together."
- **Show:** Drop one of each node type into a new graph on-screen. Open each node's detail panel.
- **Do:** Ask the room: "Pick a technique from your ATT&CK layer in Block 3. Is it an Event or an Attack?" The answer is almost always Attack — reinforce why.
- **Ask (Q):** Pick a technique from your ATT&CK layer. Is it an Event or an Attack?
- **Expected Response (A):** Almost always Attack. Attacks are ATT&CK techniques; Events are generic.

### Slide 7: Object Nodes (5 min)

- **Artifact** — physical, information, or information-bearing artifacts
  - Mapped to `d3f:Artifact`
  - Example: **Network Packet**
- **Agent** — person or non-person entity, including threat actors
  - Example: **APT28**

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Object nodes are the *things* in the graph. Artifacts are what the action is acting on — a packet, a file, a driver. Agents are who is acting — humans, processes, threat actors. In our course, you are going to place an Agent node for whichever adversary you are graphing."
- **Show:** Place an Artifact node and an Agent node. Show the property panel for each.
- **Do:** Tie back: "The 'Unit' line from your SALUTE in Block 2 — that is the label on your Agent node."
- **Ask (Q):** What from your SALUTE in Block 2 labels the Agent node?
- **Expected Response (A):** The Unit line.

### Slide 8: State Nodes (5 min)

- **Vulnerability** — software vulnerabilities and underlying weaknesses
  - Mapped to `d3f:Weakness`
  - Example: **Absolute Path Traversal**
- **Condition** — open-ended; any condition associated with another node
  - Example: resulting effect of an Attack

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "State nodes capture *conditions*. Vulnerabilities are the specific weakness class. Conditions are everything else — 'attacker has SYSTEM,' 'service is now unavailable,' 'credentials have been exfiltrated.' Use Condition nodes to capture effects."
- **Show:** Place a Vulnerability node and a Condition node; link them to an Attack node.
- **Do:** Ask: "What Condition would you attach to a successful T1003 credential-dumping attack?" Common answer: "Credentials exfiltrated" or "Attacker holds LSASS-sourced credentials."
- **Ask (Q):** What Condition would you attach to a successful T1003 credential-dumping attack?
- **Expected Response (A):** Credentials exfiltrated, or attacker holds LSASS-sourced credentials.

### Slide 9: Miscellaneous Nodes (5 min)

- **Note** — comments or annotations that provide context
- **Thing** — objects or concepts outside the scope of D3FEND (non-cyber entities)
  - Example: **Data Center** as a physical building

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Misc nodes are your escape hatch. Note is for analyst commentary. Thing is for objects the ontology does not cover — the data center, a specific facility, a physical person. Use them sparingly; if you are using Thing nodes a lot, you are probably missing a real node type."
- **Show:** Place a Note on a node to demonstrate.
- **Do:** Reinforce the "sparingly" rule. Overuse of `Thing` and `Note` defeats the purpose of the ontology.
- **Ask (Q):** When should you use Thing or Note?
- **Expected Response (A):** Sparingly. Overuse defeats the ontology. Thing is for objects D3FEND does not cover.

### Slide 10: Node Anatomy (5 min)

- Every node has:
  - A **type** (drawn from the ontology classes above)
  - A **class selection** (the specific ATT&CK or D3FEND technique)
  - **Properties / metadata** (free-text and typed fields)
  - **Edges** to other nodes (typed relationships, not arbitrary lines)

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Show:** Project `../../references/node_anatomy.jpg` full-screen. Walk it top to bottom.
- **Say:** "Every node you place has these four pieces. The type puts it in a bucket. The class selection narrows it to a specific ATT&CK or D3FEND technique. Properties carry the evidence. And edges are typed — you do not just draw lines; each edge means something defined in the ontology."
- **Do:** Live on screen, add properties to a node that is already placed. Show the property panel.
- **Ask (Q):** What four pieces does every CAD node have?
- **Expected Response (A):** Type, class selection, properties/metadata, and typed edges.

### Slide 11: Edges — Creating and Selecting (5 min)

- Nodes without edges are just a list
- Edge types are **defined by the ontology** — not free-form
- When you create an edge, CAD shows only the edge types that are **valid** for the two node types you connected
- Common edges: *produces*, *accesses*, *exploits*, *mitigates*, *associated-with*

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "This is the part newcomers skip past. Edges are not decorative. Each edge is a typed relationship drawn from the ontology. CAD will only offer you edge types that are valid for the two nodes you are connecting — if you do not see the edge you want, you probably picked the wrong node type."
- **Show:** On-screen, create an edge between an Attack and an Artifact node. Read the available edge types aloud.
- **Do:** Ask the room: "If CAD is not offering you an edge type you need, what does that tell you?" Answer: your node type is wrong.
- **Ask (Q):** If CAD is not offering an edge type you need, what does that tell you?
- **Expected Response (A):** Your node type is wrong.

### Slide 12: Essential Tips (5 min)

- **Focus on artifact provenance** — where does each artifact come from and go to?
- **Be as specific as possible** — specific technique, specific artifact, specific condition
- **Model incrementally** — build a few nodes, connect them, save, extend
- **Save often** — export the graph JSON as you go

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Three habits that separate a good CAD graph from a bad one. First — follow artifact provenance; every artifact should have a source. Second — be specific; 'Attack: PowerShell' is worse than 'Attack: T1059.001 PowerShell.' Third — build incrementally; do not try to draw the whole intrusion in one pass."
- **Show:** The three-tip list.
- **Do:** Demonstrate File → Save (exports JSON). Remind the class to save every 5-10 minutes while they work.
- **Ask (Q):** What three habits separate a good CAD graph from a bad one?
- **Expected Response (A):** Artifact provenance, specificity, and incremental modeling. Save and export often.

### Slide 13: Mini-Build Exercise (30 min)

- Each team graphs the intrusion from the Navigator layer they already have
- Minimum required nodes:
  - 1 Agent (the adversary unit)
  - 2 Attacks (from your Navigator layer)
  - 1 Artifact
  - 1 Condition
  - 1 Countermeasure (from D3FEND)
- Minimum required edges: enough to make the graph a story, not a list

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "Stay with your current team. You already have the ATT&CK layer. Now turn it into a CAD graph with the minimum node set on this slide. Focus on provenance — every artifact has a source and an effect."
- **Show:** The minimum-node checklist; leave it visible during the exercise.
- **Do:** Timebox: **30 minutes** build + **3 minutes per team** to back-brief. Export the JSON and retain it for later commander briefing. Nested drill: B01.M30.
- **Ask (Q):** What is the minimum node set for the mini-build?
- **Expected Response (A):** 1 Agent, 2 Attacks, 1 Artifact, 1 Condition, 1 Countermeasure, plus enough edges to make a story. Nested drill: B01.M30.

### Slide 14: CAD References (5 min)

- D3FEND CAD: https://d3fend.mitre.org/cad/
- CAD documentation: https://d3fend.mitre.org/cad/docs/
- Building D3FEND Graphs with CAD: https://d3fend.mitre.org/blog/building-d3fend-graphs-with-d3fend-cad/
- D3FEND Ontology: https://d3fend.mitre.org/resources/ontology/

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "These references are the authoritative starting points when the tool or ontology changes."
- **Show:** Open the CAD documentation and ontology pages.
- **Do:** Have students bookmark the CAD documentation.
- **Ask (Q):** Which reference do you bookmark for when the tool or ontology changes?
- **Expected Response (A):** CAD documentation, and the ontology page as needed.

### Slide 15: Recap (5 min)

- CAD = D3FEND's graphing tool, built on the D3FEND Ontology
- Four node categories (Action / Object / State / Misc), typed edges
- Three habits: artifact provenance, specificity, incremental modeling
- You now have a graphing language that matches the planning pipeline

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "You now have the planning pipeline, an ATT&CK layer, paired D3FEND/ENGAGE options, and a graph that preserves the evidence chain."
- **Show:** The evidence flow beside the paired-options sheet.
- **Do:** Confirm exported JSON is saved for later briefing.
- **Ask (Q):** What do you hand off from this lesson?
- **Expected Response (A):** Exported CAD JSON plus the planning-pipeline products. Next: wire frameworks back to tactical tasks.

## Lesson summary

- CAD is the typed communication product for ATT&CK, D3FEND, and ENGAGE analysis already completed.
- A D3FEND graph keeps action, object, and state discrete so graphs are comparable across teams.
- Nested `B01.M29` explores Shadowcat; `B01.M30` is the mini-build from the Navigator intrusion.
- Retain exported JSON for later commander briefing and tactical-task synthesis.

## Questions and check on learning

- **Ask (Q):** How does a D3FEND knowledge graph differ from an untyped attack diagram?
- **Expected Response (A):** It keeps actions, objects, and state typed and separate under the D3FEND ontology, so graphs are comparable across teams.
- **Ask (Q):** What four node categories do you pick from, and what makes an edge valid?
- **Expected Response (A):** Action, Object, State, Miscellaneous. CAD only offers ontology-valid edge types for the two node types you connected.
- **Ask (Q):** What is the minimum mini-build node set, and what three habits keep the graph usable?
- **Expected Response (A):** 1 Agent, 2 Attacks, 1 Artifact, 1 Condition, 1 Countermeasure, with enough edges to tell a story. Provenance, specificity, incremental modeling.
