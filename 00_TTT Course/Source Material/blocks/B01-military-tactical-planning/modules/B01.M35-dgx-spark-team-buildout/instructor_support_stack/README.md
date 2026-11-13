# Classroom support stack (moved)

The operational classroom offline supply chain runs from the instructor host at
**`/opt/stack`**:

- Traefik (DNS, private ACME CA, trust portal): `/opt/stack/traefik/`
- Mirrors (OCI registry + Hugging Face mirror): `/opt/stack/mirrors/`

The same layout is mirrored in the course content repo for review/PRs:

**[`environments/dgx_spark_stack/mirrors/`](../../../../../environments/dgx_spark_stack/mirrors/)**

**[`environments/dgx_spark_stack/traefik/`](../../../../../environments/dgx_spark_stack/traefik/)**

Do not assume `/opt/stack` and `environments/dgx_spark_stack/` are the same commit without
comparing. Follow the L1.7b Instructor Setup Guide in this lab folder for the
classroom bring-up order (Traefik → mirrors → preload / team DNS), using
`/opt/stack` as the runtime path.
