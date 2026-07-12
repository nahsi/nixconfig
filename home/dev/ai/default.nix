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
    diagnosing-bugs = "engineering/diagnosing-bugs";
    tdd = "engineering/tdd";
    codebase-design = "engineering/codebase-design";
    domain-modeling = "engineering/domain-modeling";
    prototype = "engineering/prototype";
    resolving-merge-conflicts = "engineering/resolving-merge-conflicts";
    grill-with-docs = "engineering/grill-with-docs";
    improve-codebase-architecture = "engineering/improve-codebase-architecture";
    implement = "engineering/implement";
    ask-matt = "engineering/ask-matt";
    to-prd = "engineering/to-prd";
    to-issues = "engineering/to-issues";
    triage = "engineering/triage";
    code-review = "engineering/code-review";
    setup-matt-pocock-skills = "engineering/setup-matt-pocock-skills";
    grilling = "productivity/grilling";
    grill-me = "productivity/grill-me";
    handoff = "productivity/handoff";
    teach = "productivity/teach";
    writing-great-skills = "productivity/writing-great-skills";
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
