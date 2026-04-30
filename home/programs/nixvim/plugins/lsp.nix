{
  programs = {
    nixvim = {
      plugins = {
        lsp = {
          enable = true;
          servers = {
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
            nil_ls.enable = true;
          };
        };
      };
    };
  };
}
