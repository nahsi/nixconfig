{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      folding = true;
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 2;
      };
    };
  };
}
