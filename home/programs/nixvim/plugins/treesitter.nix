{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = false;
      };
      folding = false;
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 2;
      };
    };
  };
}
