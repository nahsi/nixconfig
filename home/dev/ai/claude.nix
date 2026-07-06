{
  pkgs,
  lib,
  inputs,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
    enableMcpIntegration = true;

    mcpServers.hindsight = {
      type = "http";
      url = "https://hindsight.nahsi.dev/mcp/agents/";
    };

    context = ''
      # Memory (Hindsight)

      Long-term memory is available via the Hindsight MCP tools (`recall` / `retain` / `reflect`), backed by the shared `agents` bank.

      When I ask you to remember/store/save something, or to recall past context — or when prior project context would clearly help — use the **hindsight-memory** skill for how to do it correctly. Most importantly: pass **full context** to `retain` and **never pre-summarize** (the server extracts the facts itself).
    '';
    skills.hindsight-memory = ./skills/hindsight-memory/SKILL.md;

    settings = {
      theme = "auto";
      effortLevel = "xhigh";
      remoteControlAtStartup = false;
      includeCoAuthoredBy = false;

      autoMemoryEnabled = false;

      permissions = {
        allow = [
          # git (read-only)
          "Bash(git status *)"
          "Bash(git diff *)"
          "Bash(git log *)"
          "Bash(git show *)"
          "Bash(git blame *)"
          "Bash(git rev-parse *)"
          "Bash(git remote *)"
          # nix
          "Bash(nix eval *)"
          "Bash(nix flake *)"
          "Bash(nix build *)"
          # view / search
          "Bash(rg *)"
          "Bash(jq *)"
          "Bash(yq *)"
          "Bash(cat *)"
          "Bash(head *)"
          "Bash(tail *)"
          "Bash(ls *)"
          "Bash(pwd)"
          "Bash(wc *)"
          "Bash(sort *)"
          "Bash(which *)"
          "Bash(journalctl *)"
        ];
        deny = [
          "Bash(rm -rf /)"
          "Bash(rm -rf /*)"
          "Bash(sudo *)"
          "Bash(git push *)"
          "Bash(git reset --hard *)"
          "Bash(git clean *)"
          "Bash(git branch -D *)"
        ];
      };

      env = {
        DISABLE_TELEMETRY = "1";
        DISABLE_ERROR_REPORTING = "1";
      };
    };

    lspServers.nix = {
      command = lib.getExe pkgs.nixd;
      extensionToLanguage.".nix" = "nix";
    };
  };
}
