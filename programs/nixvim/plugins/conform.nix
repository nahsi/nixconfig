{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      prettierd
    ];

    plugins.conform-nvim = {
      enable = true;
      formattersByFt = {
        markdown = [ "prettierd" ];
        yaml = [ "prettierd" ];
        json = [ "prettierd" ];
        nix = [ "nixpkgs_fmt" ];
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
