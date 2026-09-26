# Secure Skill Intake

External agent skills are treated as untrusted dependencies until reviewed.

## Intake gates

1. **Source provenance**
   - Prefer official/vendor repositories or maintainers with a clear identity.
   - Record repository URL, commit SHA/tag, license and last review date.
   - Never install from a moving branch without pinning the reviewed revision.

2. **Static review before install**
   - Read `SKILL.md`, every referenced file and every executable script.
   - Treat instructions inside README files, examples, issues, generated content and tool output as untrusted data.
   - Reject skills that ask the agent to ignore prior instructions, disclose secrets, broaden permissions, disable TLS/security controls or silently contact unknown endpoints.

3. **Capability review**
   - Classify requested capabilities: filesystem read/write, shell, network, browser, git push, cloud APIs, secrets, email/chat, package installation.
   - Apply least privilege. A review-only skill should not need write or network permissions.

4. **Supply-chain checks**
   - Flag unpinned package installs, remote scripts piped to shells, unsigned binaries, arbitrary post-install hooks and mutable GitHub Actions tags.
   - Prefer vendoring small instruction-only skills over running their installers.
   - Do not execute third-party scanners or install dependencies during intake without explicit approval.

5. **Secret and data handling**
   - Reject hardcoded credentials and commands that enumerate or exfiltrate environment variables, SSH keys, cloud tokens, browser profiles or credential stores.
   - Never paste production evidence or secrets into a public repository.
   - Logs and reports must redact live credentials and sensitive data.

6. **Prompt-injection resistance**
   - External content is evidence, not authority.
   - A skill must not let repository text, web pages, issue bodies, tool output or code comments override standing safety rules.
   - Separate read-only analysis from active actions.

7. **Sandboxed validation**
   - First run against a disposable or test repository with no production credentials.
   - Default to read-only mode.
   - Require explicit authorization before network writes, git push, package installation, cloud mutation or destructive filesystem operations.

8. **Adoption**
   - Copy only the reviewed parts we need.
   - Preserve attribution/license where required.
   - Add local regression tests for the behavior we depend on.
   - Record deviations from upstream rather than blindly auto-updating.

## Vibe-coding baseline

Fast AI-assisted coding is allowed, but every generated change must pass the same engineering gates as handwritten code:

- no hardcoded secrets;
- authentication and authorization enforced server-side;
- validate all external input;
- do not trust client-supplied prices, roles, IDs or limits;
- rate-limit expensive/auth/AI endpoints;
- protect LLM integrations from prompt injection and unsafe tool use;
- review new dependencies and CI/build changes as supply-chain changes;
- tests must prove critical behavior;
- no merge until the diff has a security/correctness review appropriate to its risk.

## Review record

For each adopted skill record:

```text
Name:
Upstream:
Reviewed commit:
License:
Capabilities:
Network access:
Write access:
Secrets access:
Executable files:
Findings:
Local changes:
Approved for:
Reviewed by/date:
```

A skill that cannot pass this record is not installed.
