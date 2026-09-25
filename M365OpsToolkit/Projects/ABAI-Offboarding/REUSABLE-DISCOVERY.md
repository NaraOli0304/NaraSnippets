# ABAI Offboarding reusable scripts

These helpers turn live discovery lessons into generic, parameterized read-only tooling.

## Scripts

- `Get-ADSyncServiceTopology.ps1`
  - queries the remote Service Control Manager with `sc.exe`
  - does not require PowerShell remoting, admin-share access, `Az.Aks`, or ADSync module import
  - records service state, startup mode, service account, binary path and service PID
  - does not infer staging mode or connector scope

- `New-ExitReadinessMatrix.ps1`
  - emits the standard workstream matrix used for controlled separation projects
  - preserves READY / BLOCKED / PENDING status and explicit exit criteria

## Guardrails

Service presence is not connector-scope evidence. A running ADSync service confirms an active sync engine host, but connector, partition and OU filtering validation still requires authorized local/remote access to the sync engine configuration.

Do not interpret PowerShell remoting failure as absence of ADSync. Prefer authoritative service evidence when available and preserve access-denied states as an access limitation rather than a negative finding.
