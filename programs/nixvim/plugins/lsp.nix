{
  programs = {
    nixvim = {
      plugins = {
        lsp.enable = true;
        lsp.servers.rust-analyzer.enable = true;
        lsp.servers.rust-analyzer.installCargo = false;
        lsp.servers.rust-analyzer.installRustc = false;
      };
    };
  };
}
