# NaraSnippets

Privacy-safe [Espanso](https://github.com/espanso/espanso) snippets for PowerShell, GitHub and Microsoft 365 workflows.

## Why

NaraSnippets turns recurring commands and links into short, memorable triggers that work across Windows applications. The repository is deliberately curated for public use: no passwords, tokens, corporate addresses, tenant IDs or customer data.

## Included triggers

| Trigger | Expansion |
|---|---|
| `:cpdir` | Opens the ChangePack365 project directory command |
| `:mgctx` | Shows the active Microsoft Graph context |
| `:ghruns` | Lists recent ChangePack365 CI runs |
| `:gitcheck` | Shows concise Git status |
| `:cpverify` | Validates a ChangePack365 ledger |
| `:meugit` | Opens Nara's GitHub profile URL |
| `:meuprojeto` | Opens the ChangePack365 repository URL |

Espanso writes the expansion but does not press Enter. Review commands before executing them.

## Install

Prerequisites: Windows, Espanso 2.4+ and PowerShell 7.

```powershell
git clone https://github.com/NaraOli0304/NaraSnippets.git
Set-Location NaraSnippets
pwsh ./install.ps1
```

The installer backs up an existing `nara.yml`, copies the curated file and restarts Espanso.

## Privacy rule

Never commit:

- passwords, API keys, access tokens or certificates;
- tenant, subscription or customer identifiers;
- corporate email addresses or internal URLs;
- commands that perform destructive or tenant-wide changes.

## License

MIT
