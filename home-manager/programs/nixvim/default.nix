{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./colorscheme.nix
    ./plugins/lightline.nix
    ./plugins/rainbow-delimeters.nix
    ./plugins/treesitter.nix
    ./plugins/conform.nix
    ./plugins/lsp.nix
    ./plugins/nvim-cmp.nix
    ./plugins/comment.nix
    ./plugins/neorg.nix
  ];

  programs.nixvim = {
    enable = true;
    globals.mapleader = ",";
    opts = {
      swapfile = false;

      # Spaces instead of tabs
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
      softtabstop = 4;

      # Show line numbers and have relative-line numbers
      number = true;
      relativenumber = true;

      # Set highlight on search
      hlsearch = true;

      # Enable mouse usage
      mouse = "a";

      # Allow clipboard to access system clipboard
      # Setting this to both "unnamed" and "unnamedplus" allows for copy-paste to work
      # even if NixOS is running as a VM Guest.
      clipboard = [
        "unnamed"
        "unnamedplus"
      ];

      # Enable break indent
      breakindent = true;

      # Enable undo history
      undofile = true;
      undolevels = 10000;

      # Case-insensitive searching UNLESS \C or capital in search
      ignorecase = true;
      smartcase = true;

      # Decrease update time
      updatetime = 100;
      timeoutlen = 300;
    };
  };
}
