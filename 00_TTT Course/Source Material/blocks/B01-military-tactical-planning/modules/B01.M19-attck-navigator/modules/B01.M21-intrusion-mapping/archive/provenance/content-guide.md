---
id: B01.M21
title: Intrusion Mapping
artifact_type: content_guide
audience: instructor
block: B01
module_type: group_activity
related_to: B01.M13
source_status: canonical
review_required: false
template_profile: content_guide_v1
sensitivity: course_internal
legacy_aliases:
- B01.M15
---

# Intrusion Mapping

This Module was previously an embedded exercise in [B01.M19 MITRE ATT&CK and Navigator](../B01.M19-attck-navigator/content-guide.md). Complete it in sequence immediately after that lecture.

### Slide 9: Lab — Map an Intrusion to ATT&CK

- Map this FSB Center 18 evidence set:
  - Email gateway: delivered `.lnk` attachment
  - Sysmon Event 1: `mshta.exe` executes a URL on a `.ru` domain
  - Sysmon Event 1: `powershell.exe` uses `Invoke-Expression` and Base64
  - EDR: `PteroLNK.vbs` queries WMI for removable drives
  - File audit: `PteroPSDoor.ps1` reads `.docx`, `.xlsx`, and `.pdf` files and stages them under `%LOCALAPPDATA%\vector`
- Build an ATT&CK Navigator layer for the observed behavior
- For every mapped technique state:
  - the observed fact and source
  - the behavior it supports
  - the technique/sub-technique selected
  - confidence and competing interpretations
- Output: exported Navigator layer plus an analytical-justification table

**Instructor Notes:**

- **Image Prompt:** No image required for this slide.
- **Say:** "This is where you earn the mapping. You get an intrusion narrative. You produce a Navigator layer. You justify each technique — not just 'it looked like T1059,' but 'we observed encoded PowerShell in Event 4104 invoking an external URL, consistent with T1059.001 and T1105.'"
- **Show:** Demonstrate one evidence-to-technique row, then leave the required fields visible.
- **Do:** Timebox: **45–60 minutes**. Back-brief each team in **5 minutes** with Navigator shared to the projector. Challenge unsupported mappings and reward calibrated confidence.
