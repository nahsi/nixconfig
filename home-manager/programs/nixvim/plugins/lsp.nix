{
  programs = {
    nixvim = {
      plugins = {
        lsp = {
          enable = true;
          servers = {
            rust_analyzer.enable = true;
            rust_analyzer.installCargo = false;
            rust_analyzer.installRustc = false;
            nil_ls.enable = true;
          };
        };
      };
    };
  };
}
