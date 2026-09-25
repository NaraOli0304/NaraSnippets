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
