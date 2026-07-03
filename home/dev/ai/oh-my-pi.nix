{
  pkgs,
  inputs,
  ...
}:
let
  provider = "nahsilabs";
  ids = {
    default = "Qwen/Qwen3.6-27B";
    smol = "deepseek-ai/DeepSeek-V4-Flash";
    slow = "deepseek-ai/DeepSeek-V4-Pro";
    tiny = "Qwen/Qwen3.5-2B";
  };
  ref = role: "${provider}/${ids.${role}}";

  trafilatura = pkgs.runCommandLocal "trafilatura" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.python3.withPackages (ps: [ ps.trafilatura ])}/bin/trafilatura $out/bin/
  '';

  endpoint = {
    baseUrl = "https://ai.nahsi.dev/v1";
    apiKey = "AI_GATEWAY_KEY";
    api = "openai-completions";
  };
in
{
  imports = [ inputs.omp-nix.homeManagerModules.omp ];

  oh-my-pi = {
    enable = true;

    settings = {
      modelRoles = {
        default = ref "default";
        smol = "${ref "smol"}:low";
        slow = ref "slow";
        plan = ref "slow";
        task = "${ref "smol"}:medium";
        tiny = ref "tiny";
      };
      retry.fallbackChains.${ref "default"} = [ (ref "slow") ];

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

      tools.approvalMode = "write";
      task.maxConcurrency = 4;
      task.agentModelOverrides.Tester = ref "slow";
      bash.autoBackground.enabled = true;
      browser.enabled = false;
      astEdit.enabled = false;
      eval = {
        py = false;
        js = false;
      };

      edit.mode = "hashline";

      providers = {
        webSearch = "searxng";
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

    models.providers.${provider} = endpoint // {
      models = [
        {
          id = ids.default;
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
            };
          };
        }
        {
          id = ids.smol;
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
          id = ids.slow;
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
          id = ids.tiny;
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

  home.packages = [
    trafilatura
    pkgs.nixd
    pkgs.rust-analyzer
    pkgs.yaml-language-server
    pkgs.terraform-ls
    pkgs.bash-language-server
  ];
}
