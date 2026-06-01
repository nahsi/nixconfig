{ pkgs, ... }:
{
  programs.nixvim.extraPackages = [ pkgs.tree-sitter ];

  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = false;
      };
      folding.enable = false;
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 2;
      };
    };
  };
}
