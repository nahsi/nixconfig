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
      formatters.nixfmt.command = "${lib.getExe pkgs.nixfmt-rfc-style}";
      formattersByFt = {
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
