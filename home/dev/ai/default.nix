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
        diagnosing-bugs = "engineering/diagnosing-bugs";
        tdd = "engineering/tdd";
        codebase-design = "engineering/codebase-design";
        resolving-merge-conflicts = "engineering/resolving-merge-conflicts";

        wizard = "engineering/wizard";
        grilling = "productivity/grilling";
        handoff = "productivity/handoff";
        wait-what = "productivity/wait-what";
        to-questionnaire = "productivity/to-questionnaire";
        writing-for-agents = "productivity/writing-for-agents";
      }
    )
    // (lib.mapAttrs
      (_: path: {
        src = "${inputs.pstack-skills}/pstack/skills/${path}";
        subdir = "";
      })
      {
        blast-radius = "blast-radius";
        why = "why";
        unslop = "unslop";
        how = "how";
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
    inherit skills;
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
        default = "nahsilabs/Qwen/Qwen3.8-27B:medium";
        slow = "openai-codex/gpt-5.6-sol:xhigh";
        plan = "openai-codex/gpt-5.6-sol:max";
        task = "openai-codex/gpt-5.6-terra:high";
        smol = "openai-codex/gpt-5.6-luna";
        tiny = "nahsilabs/Qwen/Qwen3.5-2B";
        advisor = "openai-codex/gpt-5.6-sol:xhigh";
      };
      retry.fallbackChains."nahsilabs/Qwen/Qwen3.8-27B" = [ "openai-codex/gpt-5.6-luna" ];

      defaultThinkingLevel = "medium";
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
      secrets.enabled = true;
      task.maxConcurrency = 8;

      bash.autoBackground.enabled = true;
      browser.enabled = false;
      astEdit.enabled = false;
      eval = {
        py = false;
        js = false;
      };

      edit.mode = "hashline";

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
        reserveTokens = 16384;
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

      startup.checkUpdate = false;
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
          id = "deepseek-ai/DeepSeek-V4-Pro";
          name = "DeepSeek V4 Pro";
          reasoning = true;
          tokenizer = "deepseek-v3";
          thinking = {
            mode = "effort";
            efforts = [
              "high"
              "xhigh"
            ];
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
          tokenizer = "qwen3";
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
