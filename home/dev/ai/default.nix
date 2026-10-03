{
  config,
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
in
{
  imports = [
    inputs.omp-nix.homeManagerModules.omp
  ];

  oh-my-pi = {
    enable = true;
    package = inputs.omp-upstream.packages.${system}.default;

    mcp.mcpServers = {
      codebase-memory.command = lib.getExe pkgs-unstable.codebase-memory-mcp;
    };

    appendSystemPrompt = ''
      Delegation transfers execution ownership of that work slice to the subagent.
      Until it finishes, the parent MUST NOT investigate, edit, validate, or redelegate the same scope.
      The parent may work only on explicitly disjoint slices; if none exist, it MUST wait.

      Prefer codebase-memory for codebase-wide structural exploration and relationship tracing.
      Treat its graph as an index: verify current source before editing or making exact claims.

      Conventional commits style applied only to PR title and commits to main, commits inside branch do not use conventional commits.
    '';

    models = import ./models.nix;

    settings = {
      modelRoles = {
        default = "openai-codex/gpt-6.1-sol:medium";
        slow = "openai-codex/gpt-6-astra:auto";
        plan = "openai-codex/gpt-6-astra:medium";
        task = "openai-codex/gpt-6.1-sol";
        smol = "openai-codex/gpt-6-luna";
        tiny = "local/lfm2.5-230m";
        advisor = "openai-codex/gpt-6-astra:medium";
        local = "nahsilabs/Qwen/Qwen3.8-27B";
        judge = "openrouter/~typesafe/jev-latest";
        web = "web/parallel";
      };
      defaultThinkingLevel = "medium";
      disabledProviders = [
        "claude"
        "codex"
        "cursor"
        "opencode"
        "gemini"
        "github"
      ];
      providers.streamFirstEventTimeoutSeconds = 300;
      retry.fallbackChains = {
        web = [
          "web/exa"
          "web/duckduckgo"
          "openai-codex/gpt-6-luna"
        ];
        tiny = [ ];
      };

      personality = "pragmatic";
      theme = {
        dark = "dark-catppuccin";
        light = "light-catppuccin";
      };
      symbolPreset = "nerd";
      display = {
        showTokenUsage = true;
        cacheMissMarker = true;
      };
      tui.vimMode = true;
      composer.tokenRate = true;
      completion.notify = "off";
      ask.notify = "off";

      tools = {
        approvalMode = "yolo";
        approval.retain = "deny";
      };
      secrets.enabled = true;
      eval.autoBackground.enabled = true;
      bashInterceptor.enabled = true;
      astGrep.enabled = true;
      find.enabled = "on";
      computer.enabled = false;
      searxng.endpoint = "https://search.nahsi.dev";

      task = {
        disabledAgents = [
          "sonic"
          "security-reviewer"
        ];
        maxConcurrency = 4;
        enableEffort = true;
        enableLsp = true;
        maxEffort = "high";
        isolation.enabled = true;
        showResolvedModelBadge = true;
      };
      plan.enabled = false;
      goal.enabled = false;
      steeringMode = "all";
      followUpMode = "all";

      extendedContext = true;
      compaction.methodOrder = [
        "snapcompact"
        "handoff"
        "shake"
        "soft"
      ];
      branchSummary.enabled = true;
      ttsr.repeatMode = "after-gap";

      setupVersion = 2;
      startup = {
        checkUpdate = false;
        setupWizard = false;
      };
    };
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
      ".omp/agent/config.yml".enable = false;

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

    # OMP resolves config.yml before saving, so it needs a writable copy, not a store symlink.
    activation.ompWritableConfig =
      let
        yamlFormat = pkgs.formats.yaml { };
        ompConfig = yamlFormat.generate "omp-config.yml" config.oh-my-pi.settings;
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.omp/agent"
        $DRY_RUN_CMD install -m 600 ${ompConfig} "$HOME/.omp/agent/config.yml"
      '';
  };
}
