{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./colorscheme.nix
    ./plugins/lightline.nix
    ./plugins/treesitter.nix
    ./plugins/conform.nix
    ./plugins/rainbow-delimeters.nix
  ];
  programs.nixvim = {
    enable = true;
    globals.mapleader = ",";
    opts = {
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

      # Case-insensitive searching UNLESS \C or capital in search
      ignorecase = true;
      smartcase = true;

      # Decrease update time
      updatetime = 250;
      timeoutlen = 300;

      # Set completeopt to have a better completion experience
      completeopt = [
        "menuone"
        "noinsert"
        "noselect"
      ];
    };
  };
}
