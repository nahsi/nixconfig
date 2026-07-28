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

  skills =
    (lib.mapAttrs
      (_: path: {
        src = "${inputs.mattpocock-skills}/skills/${path}";
        subdir = "";
      })
      {
        diagnosing-bugs = "engineering/diagnosing-bugs"; # diagnosis loop for hard bugs & perf regressions
        tdd = "engineering/tdd"; # test-first: red → green
        codebase-design = "engineering/codebase-design"; # design deep modules & interfaces
        domain-modeling = "engineering/domain-modeling"; # pin down domain terms / ubiquitous language
        prototype = "engineering/prototype"; # throwaway prototype to answer a design question
        resolving-merge-conflicts = "engineering/resolving-merge-conflicts"; # resolve in-progress merge/rebase conflicts
        grill-with-docs = "engineering/grill-with-docs"; # grilling interview that also writes ADRs/glossary
        improve-codebase-architecture = "engineering/improve-codebase-architecture"; # scan for deepening opportunities, report + grill
        implement = "engineering/implement"; # implement work from a spec or tickets
        ask-matt = "engineering/ask-matt"; # router: which skill/flow fits the situation
        to-spec = "engineering/to-spec"; # synthesize the conversation into a spec
        to-tickets = "engineering/to-tickets"; # break a plan/spec into tracer-bullet tickets
        wayfinder = "engineering/wayfinder"; # map a huge multi-session effort as investigation tickets
        research = "engineering/research"; # background agent research against primary sources
        triage = "engineering/triage"; # move issues/PRs through a triage state machine
        code-review = "engineering/code-review"; # review the diff vs repo standards + spec
        setup-matt-pocock-skills = "engineering/setup-matt-pocock-skills"; # one-time repo setup for these skills
        grilling = "productivity/grilling"; # relentlessly grill a plan/design to stress-test it
        handoff = "productivity/handoff"; # compact the conversation into a handoff doc
        teach = "productivity/teach"; # teach a concept/skill in this workspace
        writing-great-skills = "productivity/writing-great-skills"; # reference for writing skills well
      }
    )
    // {
      ketch = {
        src = ./skills/ketch;
        subdir = "";
      };
    };

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
    inherit skills;
    agents = {
      scout = ./agents/scout.md;
      librarian = ./agents/librarian.md;
      reviewer = ./agents/reviewer.md;
    };
    mcp.mcpServers = {
      codebase-memory.command = lib.getExe pkgs-unstable.codebase-memory-mcp;
      ketch = {
        command = lib.getExe localPkgs.ketch;
        args = [
          "mcp"
          "serve"
        ];
      };
    };

    appendSystemPrompt = ''
      Delegation transfers execution ownership of that work slice to the subagent.
      Until it finishes, the parent MUST NOT investigate, edit, validate, or redelegate the same scope.
      The parent may work only on explicitly disjoint slices; if none exist, it MUST wait.

      Prefer codebase-memory for codebase-wide structural exploration and relationship tracing.
      Treat its graph as an index: verify current source before editing or making exact claims.

      Use Ketch for web discovery.
      Handle Ketch provider failures with Ketch random fallback. Use read for ordinary known URLs.
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
        default = "openai-codex/gpt-5.6-terra";
        slow = "openai-codex/gpt-5.6-sol:high";
        plan = "openai-codex/gpt-5.6-sol:high";
        # smol = "nahsilabs/Qwen/Qwen3.6-27B";
        smol = "openai-codex/gpt-5.6-luna";
        tiny = "nahsilabs/Qwen/Qwen3.5-2B";
        advisor = "nahsilabs/deepseek-ai/DeepSeek-V4-Pro";
      };
      # retry.fallbackChains."nahsilabs/Qwen/Qwen3.6-27B" = [ "openai-codex/gpt-5.6-luna" ];
      task.agentModelOverrides.Tester = "openai-codex/gpt-5.6-terra:high";

      defaultThinkingLevel = "high";
      disabledProviders = [
        "claude"
        "codex"
        "cursor"
        "opencode"
        "gemini"
        "github"
        "agents-md"
      ];

      tools.approvalMode = "always-ask";
      tools.approval.retain = "deny";
      ttsr.repeatMode = "after-gap";
      ttsr.repeatGap = 10;
      secrets.enabled = true;
      task.maxConcurrency = 8;

      advisor.subagents = false;
      bash.autoBackground.enabled = true;
      browser.enabled = false;
      web_search.enabled = false;
      astEdit.enabled = false;
      eval = {
        py = false;
        js = false;
      };

      edit.mode = "hashline";

      providers = {
        webSearchOrder = [
          "tavily"
          "exa"
        ];
        fetch = "trafilatura";
        tinyModel = "online";
        streamFirstEventTimeoutSeconds = 300;
      };
      searxng.endpoint = "https://search.nahsi.dev";
      exa.enabled = true;

      compaction = {
        remoteEnabled = false;
        reserveTokens = 16384;
      };

      # memory.backend = "hindsight";
      # hindsight = {
      #   apiUrl = "https://hindsight.nahsi.dev";
      #   bankId = "agents";
      #   scoping = "per-project-tagged";
      # };

      branchSummary.enabled = true;

      steeringMode = "all";
      followUpMode = "all";

      theme = {
        dark = "dark-catppuccin";
        light = "light-catppuccin";
      };
      symbolPreset = "nerd";
      display.showTokenUsage = true;

      startup.checkUpdate = false;
    };

    models.providers.nahsilabs = endpoint // {
      models = [
        {
          id = "Qwen/Qwen3.6-27B";
          name = "Qwen3.6 27B";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 131072;
          maxTokens = 32768;
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          thinking = {
            minLevel = "medium";
            maxLevel = "high";
            mode = "effort";
          };
          compat = {
            supportsDeveloperRole = false;
            supportsReasoningEffort = false;
            thinkingFormat = "qwen-chat-template";
            qwenPreserveThinking = true;
            reasoningContentField = "reasoning";
            maxTokensField = "max_tokens";
            extraBody = {
              temperature = 0.6;
              top_p = 0.95;
              top_k = 20;
              min_p = 0;
              presence_penalty = 1.0;
            };
          };
        }
        {
          id = "deepseek-ai/DeepSeek-V4-Flash";
          name = "DeepSeek V4 Flash";
          reasoning = true;
          thinking = {
            minLevel = "low";
            maxLevel = "high";
            mode = "effort";
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
          id = "deepseek-ai/DeepSeek-V4-Pro";
          name = "DeepSeek V4 Pro";
          reasoning = true;
          thinking = {
            minLevel = "high";
            maxLevel = "xhigh";
            mode = "effort";
          };
          input = [
            "text"
            "image"
          ];
          contextWindow = 1048576;
          maxTokens = 131072;
          cost = {
            input = 0.435;
            output = 0.87;
            cacheRead = 0.003625;
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
          id = "Qwen/Qwen3.5-2B";
          name = "Qwen3.5 2B";
          reasoning = false;
          input = [ "text" ];
          contextWindow = 16384;
          maxTokens = 2048;
          cost = {
            input = 0;
            output = 0;
            cacheRead = 0;
            cacheWrite = 0;
          };
          compat = {
            supportsDeveloperRole = false;
            maxTokensField = "max_tokens";
            extraBody = {
              temperature = 1.0;
              top_p = 1.0;
              top_k = 20;
              min_p = 0;
              presence_penalty = 2.0;
              repetition_penalty = 1.0;
            };
          };
        }
      ];
    };
  };

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
    localPkgs.ketch
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
