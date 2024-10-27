{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 2;
      };
    };
  };
}
