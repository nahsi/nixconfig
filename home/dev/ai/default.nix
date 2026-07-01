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
  skillsSrc = inputs.mattpocock-skills;

  skills = {
    diagnose = skillsSrc + "/skills/engineering/diagnose";
    zoom-out = skillsSrc + "/skills/engineering/zoom-out";
    tdd = skillsSrc + "/skills/engineering/tdd";
    grill-me = skillsSrc + "/skills/productivity/grill-me";
    handoff = skillsSrc + "/skills/productivity/handoff";
    teach = skillsSrc + "/skills/productivity/teach";
    caveman = skillsSrc + "/skills/productivity/caveman";
    write-a-skill = skillsSrc + "/skills/productivity/write-a-skill";
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
      };
    };

    claude-code.skills = skills;
  };

  oh-my-pi = {
    inherit skills;
    mcp.mcpServers = config.programs.mcp.servers;
  };

  home.packages = [
    pkgs.mcp-grafana
    pkgs.fluxcd-operator-mcp
    localPkgs.mcp-victorialogs
    localPkgs.mcp-victoriametrics
  ];
}
