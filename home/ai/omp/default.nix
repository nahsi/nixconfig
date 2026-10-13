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

  localPkgs = inputs.self.packages.${system};
  yamlFormat = pkgs.formats.yaml { };
in
{
  imports = [
    inputs.omp.homeManagerModules.omp
  ];

  programs.omp = {
    enable = true;
    settings = import ./settings.nix;
  };

  home = {
    packages = [
      pkgs-unstable.codebase-memory-mcp
      pkgs.terraform-mcp-server
      pkgs.mcp-grafana
      pkgs.fluxcd-operator-mcp
      localPkgs.mcp-victorialogs
      localPkgs.mcp-victoriametrics

      pkgs.python3Packages.trafilatura
      localPkgs.wayfinder-maps

      pkgs.nixd
      pkgs.rust-analyzer
      pkgs.pyright
      pkgs.yaml-language-server
      pkgs.terraform-ls
      pkgs.bash-language-server
      pkgs.typescript-language-server
      pkgs.typescript
      pkgs.lua-language-server
      pkgs.marksman
    ];

    file = {
      ".omp/agent/models.yml".source = yamlFormat.generate "omp-models.yml" (import ./models.nix);
      ".omp/agent/mcp.json".text = builtins.toJSON {
        mcpServers.codebase-memory.command = lib.getExe pkgs-unstable.codebase-memory-mcp;
      };
      ".omp/agent/APPEND_SYSTEM.md".text = ''
        Delegation transfers execution ownership of that work slice to the subagent.
        Until it finishes, the parent MUST NOT investigate, edit, validate, or redelegate the same scope.
        The parent may work only on explicitly disjoint slices; if none exist, it MUST wait.

        Prefer codebase-memory for codebase-wide structural exploration and relationship tracing.
        Treat its graph as an index: verify current source before editing or making exact claims.

        Conventional commits style applied only to PR title and commits to main, commits inside branch do not use conventional commits.
      '';

      ".omp/agent/skills" = {
        source = ./skills;
        recursive = false;
      };
      ".omp/agent/agents" = {
        source = ./agents;
        recursive = false;
      };
      ".omp/agent/extensions" = {
        source = ./extensions;
        recursive = false;
      };
    };

  };

  programs.zsh.zsh-abbr.abbreviations.ompl = "omp --model nahsilabs/Qwen/Qwen3.8-Flash-Next";
}
