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
    ];
  };
}
