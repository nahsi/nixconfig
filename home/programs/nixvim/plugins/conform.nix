{ pkgs, lib, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      prettierd
      rustfmt
    ];

    plugins.conform-nvim = {
      enable = true;
      settings.formatters.nixfmt.command = "${lib.getExe pkgs.nixfmt-rfc-style}";
      settings.formatters_by_ft = {
        markdown = [ "prettierd" ];
        yaml = [ "prettierd" ];
        json = [ "prettierd" ];
        nix = [ "nixfmt" ];
        rust = [ "rustfmt" ];
      };
    };

    keymaps = [
      {
        mode = "";
        key = "<leader>f";
        action.__raw = ''
          function()
            require('conform').format { async = true, lsp_fallback = true }
          end
        '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
