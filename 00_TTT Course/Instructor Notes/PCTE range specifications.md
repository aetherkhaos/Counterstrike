Canonical course registry of PCTE stacks (network specification, clone source, activity type, and Structured Content Module / Plan when applicable). Assigned Modules cite stacks by ID in `module.yaml`; they do not repeat portal display names. Set `fielded: false` on a planned stack whose clone source and Structured Content Module / Plan are not yet recorded; validation then allows empty clone fields.

City lab `/24` assignments for `B02.M05`–`B02.M14` are addressing inside `city-vulnhub`. Constrained-target VMs for B03 labs are hosts inside `week3-constrained`. Do not list those as Module equipment.

PCTE ops-station VMs are Course baseline student workstations and are not range deltas. Topology for the Chiron GRE/IPsec path remains in pcte_hwil_network_map.md (`course/operations/pcte_hwil_network_map.md`).

## Registry schema (Bill of Deliverables)

Keep portal **display names** on each stack row. Do not invent live names; owner verification is issues 144–152.

Registry-level defaults until a stack overrides them:

- `pcte_instance_default`: `ENT3/EP3`. Combined instance label.
- `enterprise_default`: `ENT3`. Enterprise Number.
- `event_plane_default`: `EP3`. Event Plane.

Optional per-stack overrides (omit until owner-verified): `pcte_instance`, `enterprise`, `event_plane`. Exact object / clone source / NetSpec names are the existing `structured_content_plan`, `clone_source`, and `network_specification` fields. First and last class day are **not** stored on the stack row; the Bill of Deliverables generator joins `module.yaml` `pcte.stack_refs` to the hourly schedule.

## Stack registry

```
verified_on: "2026-09-03"
verified_by: course-owner-provided
pcte_instance_default: ENT3/EP3
enterprise_default: ENT3
event_plane_default: EP3
persistent_live_action_events: []
stacks:
  - id: htb-portal
    title: Hack The Box Academy via PCTE portal
    activity_type: external_content
    pcte_instance: ENT1
    enterprise: ENT1
    network_specification: ""
    clone_source: ""
    structured_content_module: ""
    structured_content_plan: ""
    persistent_live_action_events: []
  - id: city-vulnhub
    title: B02 city / VulnHub targets
    activity_type: structured_content
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_Counterstrike_Vulnhub_Targets
    clone_source: ACTEC_CS_Ops_Vulnhub_Targets_CS_V2.0
    structured_content_module: ACTEC_Counterstrike_Ops_Vulnhub
    structured_content_plan: ACTEC Counterstrike Operations Module 2 Targets
    persistent_live_action_events: []
  - id: week3-constrained
    title: B03 constrained-target and SquidLab range
    activity_type: structured_content
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC-CS_Ops_Week3
    clone_source: ACTEC_CS_Ops_Wk3_CS1.4
    structured_content_module: ACTEC_Counterstrike_Module3_Targets
    structured_content_plan: ACTEC Counterstrike Ops Module 3
    persistent_live_action_events: []
  - id: dcora-live-action
    title: DCORA live-action range
    activity_type: live_action
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_DCORA_NET
    clone_source: ACTEC_DCORA_CONTENT_GOLD
    structured_content_module: ""
    structured_content_plan: ""
    persistent_live_action_events: []
  - id: week4-effects
    title: B04 effects (Mod4.1)
    activity_type: structured_content
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: "ACTEC_Impact&Effect"
    clone_source: ACTEC_CSO_BLOCK4.1_IMPACT_EFFECT_V1.0
    structured_content_module: ACTEC_CSO_CRS_Mod4.1
    structured_content_plan: ACTEC_CSO_CRS_Mod4.1
    persistent_live_action_events: []
  - id: week4-agentic
    title: B04 agentic (Mod4.5)
    activity_type: structured_content
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_CS-Ops_Week4
    clone_source: ACTEC_CS-Ops_Week4.5-Agentic_CS2.0
    structured_content_module: ACTEC_CSO_Mod4.5
    structured_content_plan: ACTEC_CSO_SCP_Mod4.5
    persistent_live_action_events: []
  - id: capstone
    title: Capstone DCORA structured content
    activity_type: structured_content
    fielded: true
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_DCORA_CAPSTONE_NET
    clone_source: ACTEC_DCORA_CAPSTONE_GOLD_v2.4
    structured_content_module: ACTEC_CSO_Capstone
    structured_content_plan: ACTEC_CSO_Capstone
    persistent_live_action_events: []
  - id: b01-runspace-demo
    title: B01.M08 Empire plus Windows victim demo
    activity_type: structured_content
    fielded: true
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_Runspace-Debugger-Demo
    clone_source: ACTEC_Runspace_Demo_v1.0
    structured_content_module: ACTEC_Runspace_Demo_v1.0
    structured_content_plan: ACTEC Counterstrike Operations Module 1 Systems
    persistent_live_action_events: []
  - id: classroom-shared
    title: Shared classroom live-action range
    activity_type: live_action
    fielded: true
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_CSO_CLASSROOM_SHARED_NS
    clone_source: ACTEC_CSO_CLASSROOM_SHARED_CS_2.0
    structured_content_module: ""
    structured_content_plan: ""
    persistent_live_action_events: []
  - id: b02-web-to-sql
    title: B02.M16 Web-to-SQL live-action range
    activity_type: live_action
    fielded: true
    pcte_instance: ENT3/EP3
    enterprise: ENT3
    event_plane: EP3
    network_specification: ACTEC_Web_to_SQL
    clone_source: ACTEC_CSO_Web_to_SQL_CS_1.0.1
    structured_content_module: ""
    structured_content_plan: ""
    persistent_live_action_events: []
```

## Assigned-Module consumption

Rolled up from assigned-Module `pcte.stack_refs` by `python3 tools/manage_module.py aggregate-delivery`. `not_applicable` is omitted; `conditional` is included (worst case). Non-consumer Modules omit the PCTE fence.

> **Generated section—do not edit by hand.** Update assigned-Module `pcte.stack_refs` in `module.yaml` or the stack registry above, then run `python3 tools/manage_module.py aggregate-delivery --write`.

Assigned-Module PCTE consumption rolled up from `pcte.stack_refs`. `not_applicable` is omitted; `conditional` is included (worst case). PCTE ops-station VMs are Course baseline and are not listed.

- `htb-portal`
    
    - **Activity:** external_content
    - **Netspec:** —
    - **Clone source:** —
    - **SCM:** —
    - **SCP:** —
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B02.M15`
- `city-vulnhub`
    
    - **Activity:** structured_content
    - **Netspec:** ACTEC_Counterstrike_Vulnhub_Targets
    - **Clone source:** ACTEC_CS_Ops_Vulnhub_Targets_CS_V2.0
    - **SCM:** ACTEC_Counterstrike_Ops_Vulnhub
    - **SCP:** ACTEC Counterstrike Operations Module 2 Targets
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B02.M04`, `B02.M05`, `B02.M06`, `B02.M07`, `B02.M08`, `B02.M09`, `B02.M10`, `B02.M11` (+3 more)
- `week3-constrained`
    
    - **Activity:** structured_content
    - **Netspec:** ACTEC-CS_Ops_Week3
    - **Clone source:** ACTEC_CS_Ops_Wk3_CS1.4
    - **SCM:** ACTEC_Counterstrike_Module3_Targets
    - **SCP:** ACTEC Counterstrike Ops Module 3
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B03.M02`, `B03.M03`, `B03.M04`, `B03.M05`, `B03.M06`, `B03.M08`
- `dcora-live-action`
    
    - **Activity:** live_action
    - **Netspec:** ACTEC_DCORA_NET
    - **Clone source:** ACTEC_DCORA_CONTENT_GOLD
    - **SCM:** —
    - **SCP:** —
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B01.M36`, `B03.M07`, `B04.M19`
- `week4-effects`
    
    - **Activity:** structured_content
    - **Netspec:** ACTEC_Impact&Effect
    - **Clone source:** ACTEC_CSO_BLOCK4.1_IMPACT_EFFECT_V1.0
    - **SCM:** ACTEC_CSO_CRS_Mod4.1
    - **SCP:** ACTEC_CSO_CRS_Mod4.1
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B04.M25`
- `week4-agentic`
    
    - **Activity:** structured_content
    - **Netspec:** ACTEC_CS-Ops_Week4
    - **Clone source:** ACTEC_CS-Ops_Week4.5-Agentic_CS2.0
    - **SCM:** ACTEC_CSO_Mod4.5
    - **SCP:** ACTEC_CSO_SCP_Mod4.5
    - **PLAE:** none
    - **Applicability:** conditional
    - **Source Modules:** `B04.M13`, `B04.M14`, `B04.M18`, `B04.M16`
- `capstone`
    
    - **Activity:** structured_content
    - **Netspec:** ACTEC_DCORA_CAPSTONE_NET
    - **Clone source:** ACTEC_DCORA_CAPSTONE_GOLD_v2.4
    - **SCM:** ACTEC_CSO_Capstone
    - **SCP:** ACTEC_CSO_Capstone
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B05.M01`
- `b01-runspace-demo`
    
    - **Activity:** structured_content
    - **Netspec:** ACTEC_Runspace-Debugger-Demo
    - **Clone source:** ACTEC_Runspace_Demo_v1.0
    - **SCM:** ACTEC_Runspace_Demo_v1.0
    - **SCP:** ACTEC Counterstrike Operations Module 1 Systems
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B01.M08`
- `classroom-shared`
    
    - **Activity:** live_action
    - **Netspec:** ACTEC_CSO_CLASSROOM_SHARED_NS
    - **Clone source:** ACTEC_CSO_CLASSROOM_SHARED_CS_2.0
    - **SCM:** —
    - **SCP:** —
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B02.M04`, `B03.M08`
- `b02-web-to-sql`
    
    - **Activity:** live_action
    - **Netspec:** ACTEC_Web_to_SQL
    - **Clone source:** ACTEC_CSO_Web_to_SQL_CS_1.0.1
    - **SCM:** —
    - **SCP:** —
    - **PLAE:** none
    - **Applicability:** required
    - **Source Modules:** `B02.M16`