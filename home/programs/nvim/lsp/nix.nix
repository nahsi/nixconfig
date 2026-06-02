_: {
  programs.nvf.settings.vim = {
    languages.nix = {
      enable = true;
      lsp.servers = [ "nixd" ];
    };

    # Schemas nixd evaluates for module-option completion.
    # `home-manager` points at the standalone homeConfigurations output
    # in flake.nix because HM-as-NixOS-module's getSubOptions doesn't expose
    # user-imported modules (nvf, catppuccin, ...).
    lsp.servers.nixd.settings.nixd = {
      nixpkgs.expr = ''import (builtins.getFlake "/home/nahsi/nixfiles").inputs.nixpkgs.outPath { }'';
      options = {
        nixos.expr = ''(builtins.getFlake "/home/nahsi/nixfiles").nixosConfigurations.framework.options'';
        home-manager.expr = ''(builtins.getFlake "/home/nahsi/nixfiles").homeConfigurations.nahsi.options'';
      };
    };
  };
}
