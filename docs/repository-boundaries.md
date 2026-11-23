# Repository responsibilities and overlap review

This document records current repository boundaries and proposed improvements. It does **not** authorize moving code or changing production operations.

| Repository | Current responsibility | Boundary |
| --- | --- | --- |
| NaraSnippets | Espanso shortcuts and their safe installation | Expansions must not automatically execute commands or contain environment-specific secrets. |
| NaraSnippets/M365OpsToolkit | Reusable Microsoft 365/Azure operational scripts, evidence and specific discovery projects | Treat this as a separately scoped toolkit within the repository until a migration is explicitly approved. |
| microsoft-cloud-ops | Vendor references, troubleshooting runbooks and read-only diagnostic collectors | Keep procedures and reusable explanation here; reference maintained scripts instead of copying implementations. |
| ChangePack365 | Controlled before/after change evidence and verification | Do not repurpose as a general security scanner or remediation engine. |
| Atento-CloudOps | Organization-specific operational runbooks and evidence | Keep internal identifiers and tenant evidence in approved private storage, not public examples. |
| JarvisLocal | Local-first assistant, approved local capabilities and future remote access | Do not place corporate tokens or unrestricted execution shortcuts in snippets. |
| NaraWorkstation | Deliberately selected workstation configuration and restore validation | Do not include browser profiles, secrets or raw personal history. |

## Duplication review checklist

Before adding a PowerShell or Python collector:

1. Search existing entry points and similar parameters in both `M365OpsToolkit` and `microsoft-cloud-ops`.
2. Decide which repository owns the implementation; put only a link and usage instructions in the other repository.
3. Keep a read-only/default-safe mode and separate any write-capable operation behind explicit authorization.
4. Store synthetic fixtures in the repository; keep real exports and identifiers outside version control.
5. Add parsing, offline tests and a CI check before proposing merge.
6. Record supported PowerShell/runtime versions, required roles/scopes, expected output, and failure modes.

## Proposed next decision (not implemented)

Consider separating `M365OpsToolkit` into a standalone repository **only after** checking dependency links, issue history, workflow paths, maintainers and downstream consumers. A move without that inventory would create more work and could break links.

## References

- [M365OpsToolkit README](../M365OpsToolkit/README.md)
- [Microsoft Cloud Ops](https://github.com/NaraOli0304/microsoft-cloud-ops)
- [ChangePack365](https://github.com/NaraOli0304/ChangePack365)
- [JarvisLocal](https://github.com/NaraOli0304/JarvisLocal)
