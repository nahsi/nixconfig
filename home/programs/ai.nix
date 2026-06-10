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
      flux.command = pkgs.lib.getExe pkgs.fluxcd-operator-mcp;
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
  };
}
