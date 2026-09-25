# Security policy

This repository is designed for enterprise operations. Treat production tenants and exports as sensitive.

## Never commit

- passwords, access tokens or refresh tokens
- client secrets
- PFX/P12/private keys
- production certificates containing private keys
- tenant exports containing personal or confidential information
- raw support bundles or evidence archives
- hardcoded tenant-specific production identifiers unless sanitized

## Operational rules

- Default to read-only discovery.
- Use `-WhatIf` / `SupportsShouldProcess` for supported mutations.
- Require an explicit execution switch for change scripts.
- Capture pre-state and post-state.
- Prefer immutable IDs for joins.
- Keep evidence outside the repository.
- Rotate any credential exposed in a terminal transcript, ticket, email or chat.
