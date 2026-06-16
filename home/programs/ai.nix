{
  pkgs,
  inputs,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  programs.mcp = {
    enable = true;
    servers = {
      terraform.command = pkgs.lib.getExe pkgs.terraform-mcp-server;
      nixos.command = pkgs.lib.getExe pkgs.mcp-nixos;
      kubernetes.command = pkgs.lib.getExe inputs.self.packages.${system}.kubernetes-mcp-server;
      flux = {
        command = pkgs.lib.getExe pkgs.fluxcd-operator-mcp;
        args = [ "serve" ];
      };
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      theme = "auto";
      effortLevel = "xhigh";
      remoteControlAtStartup = false;
      includeCoAuthoredBy = false;
      enabledPlugins."rust-analyzer-lsp@claude-plugins-official" = true;

      env = {
        DISABLE_TELEMETRY = "1";
        DISABLE_ERROR_REPORTING = "1";
      };
    };

    skills =
      let
        src = inputs.mattpocock-skills;
      in
      {
        # engineering
        diagnose = "${src}/skills/engineering/diagnose";
        zoom-out = "${src}/skills/engineering/zoom-out";
        tdd = "${src}/skills/engineering/tdd";
        # productivity
        grill-me = "${src}/skills/productivity/grill-me";
        handoff = "${src}/skills/productivity/handoff";
        teach = "${src}/skills/productivity/teach";
        caveman = "${src}/skills/productivity/caveman";
        write-a-skill = "${src}/skills/productivity/write-a-skill";
      };
  };
}
