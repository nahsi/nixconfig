{
  pkgs,
  lib,
  config,
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

  skills = lib.mapAttrs (_: sub: "${inputs.mattpocock-skills}/skills/${sub}") {
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
    grill-me = "productivity/grill-me"; # relentless interview to sharpen a plan
    handoff = "productivity/handoff"; # compact the conversation into a handoff doc
    teach = "productivity/teach"; # teach a concept/skill in this workspace
    writing-great-skills = "productivity/writing-great-skills"; # reference for writing skills well
  };

  ompSkills = lib.mapAttrs (_: p: {
    src = p;
    subdir = "";
  }) skills;

in
{
  imports = [
    ./claude.nix
    ./oh-my-pi.nix
  ];

  programs = {
    mcp = {
      enable = true;
      servers = {
        codebase-memory.command = lib.getExe pkgs-unstable.codebase-memory-mcp;
      };
    };

    claude-code = {
      inherit skills;
    };
  };

  oh-my-pi = {
    skills = ompSkills;
    mcp.mcpServers = config.programs.mcp.servers;
  };

  home.packages = [
    pkgs-unstable.codebase-memory-mcp
    pkgs.terraform-mcp-server
    pkgs.mcp-grafana
    pkgs.fluxcd-operator-mcp
    localPkgs.mcp-victorialogs
    localPkgs.mcp-victoriametrics
  ];
}
