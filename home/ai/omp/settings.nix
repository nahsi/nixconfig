{
  modelRoles = {
    default = "anthropic/claude-opus-5-5:auto";
    slow = "openai-codex/gpt-6-astra:auto";
    plan = "openai-codex/gpt-6-astra:medium";
    task = "openai-codex/gpt-6.1-sol";
    smol = "openai-codex/gpt-6.1-sol:low";
    tiny = "local/lfm2.5-230m";
    advisor = "openai-codex/gpt-6-astra:medium";
    local = "nahsilabs/Qwen/Qwen3.8-Flash-Next";
    judge = "openrouter/typesafe/jev-1.14";
    web = "web/parallel";
  };
  defaultThinkingLevel = "medium";
  disabledProviders = [
    "claude"
    "codex"
    "cursor"
    "opencode"
    "gemini"
    "github"
  ];
  providers.streamFirstEventTimeoutSeconds = 300;
  retry.fallbackChains = {
    web = [
      "web/exa"
      "web/duckduckgo"
      "openai-codex/gpt-6-luna"
    ];
    tiny = [ ];
  };

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
    bankId = "oh-my-pi";
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
    enableEffort = true;
    enableLsp = true;
    maxEffort = "high";
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
