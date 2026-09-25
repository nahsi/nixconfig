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
    package = inputs.omp-upstream.packages.${system}.default.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./patches/omp-mode-badges.patch
        ./patches/omp-task-effort-levels.patch
      ];
    });

    skills = lib.pipe (builtins.readDir ./skills) [
      (lib.filterAttrs (
        name: type: type == "directory" && builtins.pathExists (./skills + "/${name}/SKILL.md")
      ))
      (lib.mapAttrs (
        name: _: {
          src = ./skills;
          subdir = name;
        }
      ))
    ];

    agents = lib.pipe (builtins.readDir ./agents) [
      (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".md" name))
      (lib.mapAttrs' (name: _: lib.nameValuePair (lib.removeSuffix ".md" name) (./agents + "/${name}")))
    ];

    mcp.mcpServers = {
      codebase-memory.command = lib.getExe pkgs-unstable.codebase-memory-mcp;
    };

    appendSystemPrompt = ''
      Delegation transfers execution ownership of that work slice to the subagent.
      Until it finishes, the parent MUST NOT investigate, edit, validate, or redelegate the same scope.
      The parent may work only on explicitly disjoint slices; if none exist, it MUST wait.

      Prefer codebase-memory for codebase-wide structural exploration and relationship tracing.
      Treat its graph as an index: verify current source before editing or making exact claims.

      Conventional commits style applied only to PR title, commits inside branch do not use conventional commits.
    '';

    rules.prohibit-memory-retention = ''
      ---
      name: prohibit-memory-retention
      description: "Prohibit writes to long-term memory"
      condition: "xd://retain"
      scope: "tool:write"
      interruptMode: always
      ---

      Long-term memory retention is prohibited. Never invoke retain.
    '';

    models = import ./models.nix;

    settings = {
      modelRoles = {
        default = "openai-codex/gpt-6-sol:auto";
        slow = "openai-codex/gpt-6-astra:medium";
        plan = "openai-codex/gpt-6-astra:medium";
        task = "openai-codex/gpt-6-luna:high";
        smol = "openai-codex/gpt-6-luna:medium";
        tiny = "nahsilabs/google/gemma-4-12B-it";
        advisor = "openai-codex/gpt-6-astra:medium";
        local = "nahsilabs/Qwen/Qwen3.8-27B:medium";
        judge = "openrouter/~typesafe/jev-latest";
        web = "web/parallel";
      };
      retry.fallbackChains.web = [
        "web/exa"
        "web/duckduckgo"
        "openai-codex/gpt-6-luna"
      ];
      defaultThinkingLevel = "medium";
      disabledProviders = [
        "claude"
        "codex"
        "cursor"
        "opencode"
        "gemini"
        "github"
      ];

      theme = {
        dark = "dark-catppuccin";
        light = "light-catppuccin";
      };
      symbolPreset = "nerd";
      display.showTokenUsage = true;

      composer.shape = "box";

      task = {
        maxConcurrency = 4;
        enableEffort = true;
        enableLsp = true;
        maxEffort = "high";
        isolation.enabled = true;
        agentModelOverrides = {
          task = "@task";
          poteto-agent = "@task";
          scout = "@smol";
          sonic = "@smol:low";
          reviewer = "@slow";
          security-reviewer = "@slow";
          comment-sicko = "@slow:low";
          grunt = "@local";
          poteto-grunt = "@local";
        };
        showResolvedModelBadge = true;
      };

      tools = {
        approvalMode = "yolo";
        approval.retain = "deny";
      };
      secrets.enabled = true;

      bash.autoBackground.enabled = true;
      eval.autoBackground.enabled = true;
      bashInterceptor.enabled = true;
      computer.enabled = true;

      providers = {
        autoThinkingMaxEffort = "xhigh";
        fetch = "trafilatura";
        streamFirstEventTimeoutSeconds = 300;
      };
      searxng.endpoint = "https://search.nahsi.dev";

      extendedContext = true;
      compaction = {
        methodOrder = [
          "snapcompact"
          "handoff"
          "shake"
          "soft"
        ];
      };
      branchSummary.enabled = true;
      steeringMode = "all";
      followUpMode = "all";
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

    file =
      lib.mapAttrs' (
        name: type:
        lib.nameValuePair ".omp/agent/extensions/${name}" {
          source = ./extensions + "/${name}";
          recursive = type == "directory";
        }
      ) (builtins.readDir ./extensions)
      // {
        ".omp/agent/config.yml".enable = lib.mkForce false;
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
