{
  inputs,
  system,
  aiShared,
  ...
}:
{
  imports = [ ./module.nix ];

  programs.oh-my-pi = {
    enable = true;
    package = inputs.llm-agents.packages.${system}.omp;

    agentsMd = aiShared.rules;
    inherit (aiShared) skills mcpServers;

    settings = {
      theme = {
        dark = "dark-catppuccin";
        light = "light-catppuccin";
      };
      edit.mode = "hashline";
      startup.setupWizard = false;
    };

    customProviders.providers.gateway = {
      baseUrl = "https://ai.nahsi.dev/v1";
      apiKey = "AI_GATEWAY_KEY";
      api = "openai-completions";
      models = [
        {
          id = "Qwen/Qwen3.6-27B";
          contextWindow = 81920;
          maxTokens = 16384;
        }
      ];
    };
  };

  home.sessionVariables.PI_STREAM_FIRST_EVENT_TIMEOUT_MS = "300000";
}
