# D3FEND notes keyed to ATT&CK T1041 (Exfiltration Over C2 Channel)

Exfiltration over an existing C2 or ingest channel often presents as a high
volume of outbound bytes to a small set of external IPs. Defensive counterparts
include credential eviction, isolate-process, and network traffic filtering on
the ingest path.

When the backing store and ingest URL are known, application-layer revocation
(token or route) is usually enough to degrade collection. Network-wide
interdict is reserved for when the path cannot be closed at the application
layer.
