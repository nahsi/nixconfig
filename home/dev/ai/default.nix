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
  yamlFormat = pkgs.formats.yaml { };
  ompConfig = yamlFormat.generate "omp-config.yml" config.oh-my-pi.settings;

  localSkillNames = [
    "architect-work"
    "context-map"
    "contract-review"
    "create-skill"
    "implement"
    "in-depth-research"
    "prime-delegate"
    "primestack"
    "proof-repair"
    "prototype"
    "recall"
    "reflect"
    "resolving-merge-conflicts"
    "shape-work"
    "tdd"
    "technical-writing"
    "unslop"
    "verticalize-work"
  ];

  skills =
    lib.genAttrs localSkillNames (name: {
      src = ./skills;
      subdir = name;
    })
    // (lib.mapAttrs
      (_: path: {
        src = "${inputs.mattpocock-skills}/skills/${path}";
        subdir = "";
      })
      {
        to-questionnaire = "productivity/to-questionnaire";
        wait-what = "productivity/wait-what";
        wizard = "engineering/wizard";
        writing-for-agents = "productivity/writing-for-agents";
      }
    );

  # Python 3.13.14's urllib.robotparser dropped the `groups` attribute before
  # parse(), which breaks courlan 1.3.2's test_from_html. Skip that test.
  python = pkgs.python3.override {
    packageOverrides = _final: prev: {
      courlan = prev.courlan.overridePythonAttrs (old: {
        disabledTests = (old.disabledTests or [ ]) ++ [ "test_from_html" ];
      });
    };
  };

  trafilatura = pkgs.runCommandLocal "trafilatura" { } ''
    mkdir -p $out/bin
    ln -s ${python.withPackages (ps: [ ps.trafilatura ])}/bin/trafilatura $out/bin/
  '';

  endpoint = {
    baseUrl = "https://ai.nahsi.dev/v1";
    apiKey = "AI_GATEWAY_KEY";
    api = "openai-completions";
  };
in
{
  imports = [
    inputs.omp-nix.homeManagerModules.omp
  ];

  oh-my-pi = {
    enable = true;
    package = inputs.omp-upstream.packages.${system}.default;
    inherit skills;
    agents.scout = ./agents/scout.md;
    agents.scout-deep = ./agents/scout-deep.md;
    agents.task = ./agents/task.md;
    agents.sonic = ./agents/sonic.md;
    agents.reviewer = ./agents/reviewer.md;
    agents.researcher = ./agents/researcher.md;
    agents.researcher-deep = ./agents/researcher-deep.md;
    mcp.mcpServers = {
      codebase-memory.command = lib.getExe pkgs-unstable.codebase-memory-mcp;
    };

    appendSystemPrompt = ''
      Delegation transfers execution ownership of that work slice to the subagent.
      Until it finishes, the parent MUST NOT investigate, edit, validate, or redelegate the same scope.
      The parent may work only on explicitly disjoint slices; if none exist, it MUST wait.

      Prefer codebase-memory for codebase-wide structural exploration and relationship tracing.
      Treat its graph as an index: verify current source before editing or making exact claims.
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

    settings = {
      modelRoles = {
        default = "openai-codex/gpt-6-astra:medium";
        slow = "openai-codex/gpt-5.6-sol:xhigh";
        plan = "openai-codex/gpt-6-astra:high";
        task = "openai-codex/gpt-5.6-sol:high";
        smol = "openai-codex/gpt-5.6-luna:low";
        fast = "openai-codex/gpt-5.6-terra:medium";
        review = "openai-codex/gpt-6-astra:high";
        tiny = "nahsilabs/google/gemma-4-12B-it";
        advisor = "openai-codex/gpt-6-astra:high";
      };
      extendedContext = true;

      defaultThinkingLevel = "medium";
      disabledProviders = [
        "claude"
        "codex"
        "cursor"
        "opencode"
        "gemini"
        "github"
      ];

      tools.approvalMode = "always-ask";
      tools.approval.retain = "deny";
      ttsr.repeatMode = "after-gap";
      secrets.enabled = true;
      task.maxConcurrency = 4;
      task.enableEffort = true;
      task.maxEffort = "high";
      task.isolation.enabled = true;
      task.showResolvedModelBadge = true;
      task.agentModelOverrides = {
        security-reviewer = "@review";
      };

      bash.autoBackground.enabled = true;
      bashInterceptor.enabled = true;
      computer.enabled = true;

      providers = {
        webSearchOrder = [ "exa" ];
        fetch = "trafilatura";
        streamFirstEventTimeoutSeconds = 300;
      };
      searxng.endpoint = "https://search.nahsi.dev";

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

      theme = {
        dark = "dark-catppuccin";
        light = "light-catppuccin";
      };
      symbolPreset = "nerd";
      display.showTokenUsage = true;

      setupVersion = 2;
      composer.shape = "box";
      startup = {
        checkUpdate = false;
        setupWizard = false;
      };
    };

    models.providers.nahsilabs = endpoint // {
      models = [
        {
          id = "Qwen/Qwen3.8-27B";
          name = "Qwen3.8 27B";
          reasoning = true;
          tokenizer = "qwen3";
          input = [
            "text"
            "image"
          ];
          contextWindow = 262144;
          maxTokens = 32768;
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          thinking = {
            mode = "effort";
            efforts = [
              "low"
              "medium"
              "xhigh"
            ];
          };
          compat = {
            supportsDeveloperRole = true;
            supportsReasoningEffort = true;
            thinkingFormat = "openai";
            qwenTemplateReasoningEffort = false;
            reasoningContentField = "reasoning_content";
            maxTokensField = "max_tokens";
            supportsForcedToolChoice = false;
            supportsStrictMode = false;
            extraBody.chat_template_kwargs.preserve_thinking = true;
          };
        }
        {
          id = "deepseek-ai/DeepSeek-V4-Flash";
          name = "DeepSeek V4 Flash";
          reasoning = true;
          tokenizer = "deepseek-v3";
          thinking = {
            mode = "effort";
            efforts = [
              "low"
              "medium"
              "high"
            ];
          };
          input = [ "text" ];
          contextWindow = 1048576;
          maxTokens = 32768;
          cost = {
            input = 0.10;
            output = 0.20;
            cacheRead = 0.02;
            cacheWrite = 0;
          };
          compat = {
            supportsDeveloperRole = false;
            supportsReasoningEffort = true;
            reasoningContentField = "reasoning_content";
            maxTokensField = "max_tokens";
            reasoningEffortMap = {
              high = "high";
              xhigh = "max";
            };
            supportsToolChoice = false;
            requiresReasoningContentForToolCalls = true;
            requiresAssistantContentForToolCalls = true;
            extraBody.thinking.type = "enabled";
          };
        }
        {
          id = "google/gemma-4-12B-it";
          name = "Gemma 4 12B IT";
          reasoning = false;
          input = [ "text" ];
          contextWindow = 16384;
          maxTokens = 16384;
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          compat = {
            supportsStore = false;
            supportsDeveloperRole = false;
            supportsReasoningEffort = false;
            supportsReasoningParams = false;
            maxTokensField = "max_tokens";
            supportsForcedToolChoice = false;
          };
        }
      ];
    };
  };
  # omp-nix installs config.yml as a Nix store symlink, but OMP resolves the
  # link before atomically saving settings. Install a writable copy instead.
  home.file.".omp/agent/config.yml".enable = lib.mkForce false;
  home.activation.ompWritableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.omp/agent"
    $DRY_RUN_CMD install -m 600 ${ompConfig} "$HOME/.omp/agent/config.yml"
  '';

  programs.zsh.zsh-abbr.abbreviations = {
    ompy = "omp --approval-mode yolo";
  };

  home.packages = [
    pkgs-unstable.codebase-memory-mcp
    pkgs.terraform-mcp-server
    pkgs.mcp-grafana
    pkgs.fluxcd-operator-mcp
    localPkgs.mcp-victorialogs
    localPkgs.mcp-victoriametrics
    trafilatura
    pkgs.nixd
    pkgs.rust-analyzer
    pkgs.yaml-language-server
    pkgs.terraform-ls
    pkgs.bash-language-server
    pkgs.typescript-language-server
    pkgs.typescript
    pkgs.lua-language-server
    pkgs.marksman
  ];
}
