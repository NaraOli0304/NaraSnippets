# M365OpsToolkit

Safe and evidence-driven Microsoft 365, Entra, Purview, Intune and Azure operations toolkit.

## Operating model

Discovery → Read-only validation → Evidence → Decision → WhatIf/dry-run → Authorized change → Post-change validation → Closure evidence.

## Security rules

Never commit passwords, client secrets, access tokens, private keys, production exports, or sensitive evidence.
Prefer ObjectId/UserId correlation, UTC timestamps, immutable evidence hashes, and explicit authorization gates for mutations.
