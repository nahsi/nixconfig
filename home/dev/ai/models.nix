{
  providers.nahsilabs = {
    baseUrl = "https://ai.nahsi.dev/v1";
    apiKey = "AI_GATEWAY_KEY";
    api = "openai-completions";

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
          replayReasoningContent = true;
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
        input = [ "text" ];
        contextWindow = 1048576;
        maxTokens = 32768;
        cost = {
          input = 0.10;
          output = 0.20;
          cacheRead = 0.02;
          cacheWrite = 0;
        };
        thinking = {
          mode = "effort";
          efforts = [
            "low"
            "medium"
            "high"
          ];
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
}
