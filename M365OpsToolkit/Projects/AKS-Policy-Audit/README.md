# AKS Policy Audit

Purpose: inventory AKS clusters and Azure Policy state without requiring `Az.Aks` or `Az.PolicyInsights`.

## Operating model

1. Inventory target subscriptions with `Get-AzSubscription`.
2. Discover AKS clusters through `Get-AzResource -ResourceType Microsoft.ContainerService/managedClusters`.
3. Inspect inherited policy assignments and resolve their definitions.
4. Distinguish policy `effect` from assignment `enforcementMode`.
5. Verify whether `Audit` is an allowed effect before proposing a change.
6. Capture the current compliance baseline through `Invoke-AzRestMethod` against Policy Insights.
7. Stop for requirement confirmation before any mutation.
8. Use WhatIf / dry-run before an authorized change.

## Important semantics

`effect = Deny` with `enforcementMode = DoNotEnforce` is not the same configuration as `effect = Audit`.

Do not change a management-group assignment to satisfy a pilot in child subscriptions until inherited scope, exclusions, parameters and compliance behavior have been reviewed.

## Evidence

For each run capture:

- subscription ID
- AKS resource ID
- Azure Policy add-on state
- assignment name and scope
- policy definition ID
- current effect source
- enforcement mode
- assignment parameters
- compliance counts
- zero-change counters
- evidence hash where practical

## Scripts

- `Azure/Get-AksInventory.ps1`
- `Azure/Get-PolicyAssignmentInventory.ps1`
- `Azure/Get-AksPolicyCompliance.ps1`
