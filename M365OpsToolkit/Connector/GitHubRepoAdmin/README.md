# GitHubRepoAdmin MCP

Small custom MCP server for repository-admin actions missing from the current GitHub connector, starting with repository creation.

## Security

Use a fine-grained GitHub token with the minimum repository-creation permissions required. Never commit the token.

## Run

```bash
npm install
npm run build
GITHUB_TOKEN=... npm start
```

## Exposed tools

- `create_repository`
- `get_repository`

The initial target use case is creating a private `M365OpsToolkit` repository, after which normal GitHub connector operations can manage files, branches and PRs.
