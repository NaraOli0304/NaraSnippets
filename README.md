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

## Validate a ChangePack365 case

In PowerShell 7.2 or newer, load the ChangePack365 module:

```powershell
Import-Module "$HOME\Projects\ChangePack365\ChangePack365.psd1"
```

Create a case with `New-CP365Case`, assigning its returned object to `$Case`, as shown in the [ChangePack365 workflow](https://github.com/NaraOli0304/ChangePack365#core-workflow). In that same session, type `:cpverify` and review the expansion before pressing Enter:

```powershell
Test-CP365Ledger -CasePath $Case.Path | Format-List
```

The returned case object has a `Path` property; it is not a directory object with `FullName`. This command validates the local ledger. It does not query Microsoft 365, modify the tenant, or verify an exported ZIP package.

The offline compatibility test executes the actual expansion against a temporary fictional case, then removes the fixture:

```powershell
pwsh ./scripts/Test-ChangePackSnippet.ps1 -ChangePackRoot ../ChangePack365
```

CI runs this test on Windows and Linux against ChangePack365 commit `e65606625e06a1f90743269bb9d11ecef3143164`.

## Install

Prerequisites: Windows, Espanso 2.4+ and PowerShell 7.2 or newer.

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
