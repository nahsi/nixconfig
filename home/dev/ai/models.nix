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
        id = "dealignai/Bonsai-2-27B";
        name = "Bonsai 2 27B";
        reasoning = true;
        tokenizer = "qwen3";
        input = [
          "text"
          "image"
        ];
        imageInputDecoder = "stb";
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
            "medium"
            "high"
            "xhigh"
          ];
          defaultLevel = "medium";
          requiresEffort = false;
        };
        compat = {
          supportsDeveloperRole = false;
          supportsMultipleSystemMessages = false;
          supportsReasoningEffort = true;
          thinkingFormat = "qwen-chat-template";
          qwenTemplateReasoningEffort = true;
          reasoningEffortMap = {
            minimal = "medium";
            low = "medium";
            high = "xhigh";
            max = "xhigh";
          };
          reasoningContentField = "reasoning_content";
          replayReasoningContent = false;
          maxTokensField = "max_tokens";
          alwaysSendMaxTokens = true;
          supportsStrictMode = false;
          extraBody = {
            temperature = 0.7;
            top_p = 0.8;
            top_k = 20;
            min_p = 0.0;
            presence_penalty = 1.5;
            repeat_penalty = 1.0;
          };
          whenThinking.extraBody = {
            temperature = 1.0;
            top_p = 0.95;
            top_k = 20;
            min_p = 0.05;
            presence_penalty = 0.0;
            repeat_penalty = 1.0;
          };
        };
      }
    ];
  };
}
