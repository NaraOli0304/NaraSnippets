import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { Octokit } from "@octokit/rest";
import { z } from "zod";

const token = process.env.GITHUB_TOKEN;
if (!token) throw new Error("GITHUB_TOKEN is required");

const octokit = new Octokit({ auth: token });
const server = new McpServer({ name: "github-repo-admin", version: "0.1.0" });

server.tool(
  "create_repository",
  "Create a repository in the authenticated GitHub account.",
  {
    name: z.string().min(1),
    description: z.string().optional(),
    private: z.boolean().default(true),
    auto_init: z.boolean().default(true)
  },
  async ({ name, description, private: isPrivate, auto_init }) => {
    const { data } = await octokit.repos.createForAuthenticatedUser({
      name,
      description,
      private: isPrivate,
      auto_init
    });

    return {
      content: [{
        type: "text",
        text: JSON.stringify({
          full_name: data.full_name,
          html_url: data.html_url,
          private: data.private,
          default_branch: data.default_branch
        })
      }]
    };
  }
);

server.tool(
  "get_repository",
  "Get repository metadata.",
  { owner: z.string(), repo: z.string() },
  async ({ owner, repo }) => {
    const { data } = await octokit.repos.get({ owner, repo });
    return {
      content: [{
        type: "text",
        text: JSON.stringify({
          full_name: data.full_name,
          html_url: data.html_url,
          private: data.private,
          default_branch: data.default_branch
        })
      }]
    };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
