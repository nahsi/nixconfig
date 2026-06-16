_: {
  imports = [
    ./nix.nix
  ];

  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      inlayHints.enable = true;
    };

    diagnostics = {
      enable = true;
      config.virtual_lines.current_line = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = true;

      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      yaml.enable = true;
      terraform.enable = true;
      bash.enable = true;
      markdown.enable = true;
      lua.enable = true;
      toml.enable = true;
    };
  };
}
