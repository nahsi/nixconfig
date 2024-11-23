{
  programs = {
    nixvim = {
      plugins = {
        lsp = {
          enable = true;
          servers = {
            rust-analyzer.enable = true;
            rust-analyzer.installCargo = false;
            rust-analyzer.installRustc = false;
            nil-ls.enable = true;
          };
        };
      };
    };
  };
}
