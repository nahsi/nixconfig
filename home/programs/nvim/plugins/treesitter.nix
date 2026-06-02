{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    extraPackages = [ pkgs.tree-sitter ];

    treesitter = {
      textobjects.enable = true;
      context.enable = true;
    };
  };
}
