{
  modelRoles = {
    default = "anthropic/claude-opus-5-5";
    slow = "openai-codex/gpt-6-astra";
    plan = "openai-codex/gpt-6-astra";
    task = "openai-codex/gpt-6.1-sol";
    reviewer = "anthropic/claude-fable-5-2";
    smol = "openai-codex/gpt-6.1-sol";
    tiny = "local/lfm2.5-230m";
    advisor = "openai-codex/gpt-6-astra";
    local = "nahsilabs/Qwen/Qwen3.8-Flash-Next";
    commit = "@local";
    judge = "nahsilabs/LiquidAI/d1-Omni-2B";
    speech = "nahsilabs/Qwen/Qwen3-TTS";
    dictation = "nahsilabs/nvidia/nemotron-3.5-asr-streaming-0.6b";
    web = "web/parallel";
  };
  defaultThinkingLevel = "auto";
  disabledProviders = [
    "claude"
    "codex"
    "cursor"
    "opencode"
    "gemini"
    "github"
  ];
  providers = {
    streamFirstEventTimeoutSeconds = 300;
    autoThinkingMaxEffort = "high";
  };
  retry.fallbackChains = {
    web = [
      "web/exa"
      "web/duckduckgo"
      "openai-codex/gpt-6-luna"
    ];
    judge = [ "openrouter/typesafe/jev-1.14" ];
    tiny = [ ];
    speech = [ ];
    dictation = [ ];
  };
  judgment.attemptTimeoutMs = 15000;

  personality = "pragmatic";
  theme = {
    dark = "dark-catppuccin";
    light = "light-catppuccin";
  };
  symbolPreset = "nerd";
  display = {
    showTokenUsage = true;
    cacheMissMarker = true;
    subagentLivePreview = true;
  };
  tui.vimMode = true;
  composer.tokenRate = true;
  completion.notify = "off";
  stt.enabled = true;
  speechgen.enabled = true;
  ask.notify = "off";

  tools = {
    approvalMode = "yolo";
    approval.retain = "deny";
  };
  secrets.enabled = true;
  dev.autoqaConsent = "denied";
  eval.autoBackground.enabled = true;
  bashInterceptor.enabled = true;
  astGrep.enabled = true;
  find.enabled = "on";
  computer.enabled = false;
  searxng.endpoint = "https://search.nahsi.dev";

  memory.backend = "hindsight";
  hindsight = {
    apiUrl = "https://hindsight.nahsi.dev";
    bankId = "personal";
    scoping = "per-project-tagged";
    recallTimeoutMs = 120000;
    reflectTimeoutMs = 660000;
    # Leave bankMission and retainMission unset; the shared bank owns policy.
    autoRetain = true;
    retainMode = "full-session";
    retainEveryNTurns = 3;
    autoRecall = true;
    recallTypes = [
      "world"
      "experience"
      "observation"
    ];
    recallBudget = "mid";
    recallMaxTokens = 1024;
    mentalModelsEnabled = true;
    mentalModelAutoSeed = false;
    mentalModelMaxRenderChars = 16000;
  };

  task = {
    disabledAgents = [
      "sonic"
      "security-reviewer"
    ];
    maxConcurrency = 4;
    enableEffort = false;
    perCallModel = "on";
    enableLsp = true;
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
}
