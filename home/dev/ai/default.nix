{
  pkgs,
  lib,
  config,
  inputs,
  system,
  ...
}:
let
  localPkgs = inputs.self.packages.${system};

  mp = "${inputs.mattpocock-skills}";
  mpSkills = lib.mapAttrs (_: sub: "${mp}/skills/${sub}") {
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
    grilling = "productivity/grilling";
    grill-me = "productivity/grill-me";
    handoff = "productivity/handoff";
    teach = "productivity/teach";
    writing-great-skills = "productivity/writing-great-skills";
  };

  cavemanSkills = {
    caveman = "${inputs.caveman}/plugins/caveman/skills/caveman";
  };

  skills = mpSkills // cavemanSkills;

  ompSkills = lib.mapAttrs (_: p: {
    src = p;
    subdir = "";
  }) skills;

  cmd =
    name: (builtins.fromTOML (builtins.readFile "${inputs.caveman}/commands/${name}.toml")).prompt;
  commands = {
    caveman-commit = cmd "caveman-commit";
    caveman = cmd "caveman";
  };
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
        terraform.command = lib.getExe pkgs.terraform-mcp-server;
        nixos.command = lib.getExe pkgs.mcp-nixos;
        exa.url = "https://mcp.exa.ai/mcp";
      };
    };

    claude-code = {
      inherit skills commands;
    };
  };

  oh-my-pi = {
    inherit commands;
    skills = ompSkills;
    mcp.mcpServers = config.programs.mcp.servers;
  };

  home.packages = [
    pkgs.mcp-grafana
    pkgs.fluxcd-operator-mcp
    localPkgs.mcp-victorialogs
    localPkgs.mcp-victoriametrics
  ];
}
