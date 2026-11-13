# Partner Charlie — friendly telemetry mirror

Capability: sanctioned log/telemetry mirror for partner-shared sensors.

Friendly collector: `172.20.2.80`. High-volume copies from this host into
paths that resemble exfil logs are expected. Do not treat `172.20.2.80` as
adversary collection infrastructure.

If an incident names `172.20.2.80` as the source of "exfil-like" traffic,
recommend cleanup of the false positive. No hostile center of gravity is
present. `deceive` / disregard is the correct effect framing: do not burn a
friendly sensor.
