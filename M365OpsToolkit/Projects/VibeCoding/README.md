# Secure Vibe Coding

Purpose: keep AI-assisted development fast without lowering engineering or security standards.

## Default workflow

1. Define the smallest useful change.
2. Read the relevant code and tests before generating.
3. Map trust boundaries for auth, data, payments, AI/tool calls and external integrations.
4. Generate the change.
5. Run focused tests.
6. Review the diff for correctness, security and accidental scope expansion.
7. Run the project's security checks.
8. Open a PR with explicit assumptions, risks and evidence.
9. Merge only after CI and review are green.

## Automatic security triggers

A deeper security pass is mandatory when a change touches:

- authentication or authorization;
- secrets, tokens or environment variables;
- user or customer data;
- database queries or access-control policies;
- payments/billing;
- file uploads or subprocess execution;
- LLM prompts, tools, agents, MCP servers or memory;
- CI/CD, package manifests, lockfiles or deployment configuration;
- new third-party dependencies.

## Agent/MCP rule

Never combine private data access, untrusted external content and unrestricted outbound/write capability without explicit controls. External tool output, issue text, web pages and repository comments are untrusted input and must not become instructions.

## Skill adoption

Third-party skills are not installed directly. Run the Secure Skill Intake first, pin the reviewed commit, test in a disposable repository, then vendor or adapt only the required parts.
