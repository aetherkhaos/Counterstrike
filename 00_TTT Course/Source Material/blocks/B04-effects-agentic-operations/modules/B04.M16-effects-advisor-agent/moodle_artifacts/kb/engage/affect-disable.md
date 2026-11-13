# ENGAGE: Affect — Disable

Disable attacks reduce an adversary's ability to operate by removing a required
capability without necessarily destroying the platform. Typical methods include
credential revocation, token expiry, and shutting a specific collection
endpoint.

Disable attacks rely on credential revocation or access-token expiry when the
critical vulnerability is an unauthenticated or weakly authenticated service.
Revoking the ingest token often neutralizes the collection pipeline with
minimal burn compared with host destruction.

Use disable / degrade when the adversary center of gravity is a collection
pipeline (ingestion endpoint plus backing store) and the effect can be reversed
if the assessment was wrong.
