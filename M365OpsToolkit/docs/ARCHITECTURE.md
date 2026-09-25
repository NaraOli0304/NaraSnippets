# Architecture

M365OpsToolkit separates reusable operational building blocks from project-specific orchestration.

## Control plane

- Common: connection, manifests, evidence and safety helpers
- Entra: identities, roles, memberships, sign-in evidence
- Purview: scanner, RBAC and eDiscovery
- ConditionalAccess: inventory, coverage and impact
- Intune: device state, assignments and co-management
- Azure: subscriptions, AKS, Policy and cost discovery

## Change discipline

Mutation scripts must:
1. validate the target,
2. prove the expected pre-state,
3. support WhatIf/dry-run when the backing cmdlet supports it,
4. require an explicit execution switch or ShouldProcess approval,
5. perform post-change validation.

## Connector extension

`Connector/GitHubRepoAdmin` is a small MCP extension for GitHub repository-admin operations that are not currently exposed by the connected GitHub integration. It uses a fine-grained token supplied only at runtime.
