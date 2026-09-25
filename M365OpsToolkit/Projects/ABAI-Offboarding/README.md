# ABAI Offboarding

Purpose: support a controlled post-acquisition separation from the Atento tenant.

## Current operating principle

No destructive action until a formal GO decision is recorded. Discovery must produce an exit-readiness matrix rather than a generic inventory.

## Workstreams

- Identity / synchronized objects
- AD Connect / source authority
- VPN / MFA / tunnel dependencies
- Defender / device offboarding
- SharePoint / regulatory backup
- Fabric / Power BI migration
- Key Vault / secret dependencies
- Owners, dates and exit criteria

## Recommended discovery sequence

1. Identity population and sync state
2. Hybrid source and OU profile
3. Active-use classification
4. SharePoint candidate inventory
5. SharePoint high-confidence / storage concentration
6. AD Connect engine and filtering validation
7. Devices / Defender dependency validation
8. VPN / MFA dependency validation
9. Consolidated GO / NO-GO matrix

## SharePoint rule

Do not infer deletion scope from an email domain or site owner alone. Classify sites using multiple signals such as URL/title, owner, recent content modification, storage, Teams/M365 Group relationship, retention/backup requirements and explicit migration evidence.

A high-volume tenant should be reduced to decision cohorts before owner validation. Prefer storage concentration and recent activity over broad regex matching.

## Hybrid identity rule

Cloud deletion is not a valid first action for synchronized identities. First identify the on-premises authority, connector/sync engine and OU/filtering scope. Preserve evidence of sync recency and source distinguished names.

## Minimum exit-readiness record

For each workstream record:

- status: READY / BLOCKED / PENDING
- owner
- remaining action
- evidence
- operational risk
- target date
- exit criterion
- GO / NO-GO consequence

Use read-only inventory first. Do not turn dependency discovery into remediation ownership for the other organization.
