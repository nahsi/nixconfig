{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [ nixfmt-rfc-style ];

    plugins.conform-nvim = {
      enable = true;
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
