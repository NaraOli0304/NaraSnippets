# Operating standard

Every tenant operation should be split into explicit phases:

1. Discovery
2. Read-only validation
3. Evidence capture
4. Decision
5. Dry-run / WhatIf
6. Authorized change
7. Post-change validation
8. Closure evidence

## Naming

- Discovery: `DISC-xx`
- Validation: `VAL-xx`
- Change: `CHG-xx`
- Post-check: `POST-xx`

## Required evidence fields

- UTC timestamp
- tenant ID
- signed-in account
- target IDs
- script version / commit
- change count
- error count
- decision
- SHA256 for exported evidence where practical

## PowerShell session isolation

Use separate shells when module stacks have conflicting authentication/runtime dependencies.

Recommended pattern:

- Graph / Entra / Intune: PowerShell 7
- Azure / Az modules: PowerShell 7
- Purview / ExchangeOnlineManagement: dedicated PowerShell 7 session
- SharePoint Online Management Shell: dedicated Windows PowerShell 5.1 session when required

Do not load Graph and Exchange/Purview modules into the same long-running diagnostic session unless compatibility has been proven.

## Large-tenant query rule

Avoid tenant-wide `-All` retrieval followed by local filtering when the service supports server-side filtering. When a service does not support the required filter, prefer bounded windows, saved evidence reuse or another authoritative data source rather than repeatedly downloading the full tenant dataset.

## Dependency rule

Do not install a specialized Az module only for inventory when the same read-only result is available through `Az.Resources` or `Invoke-AzRestMethod`. Keep scripts explicit about optional dependencies.
