_: {
  imports = [
    ./completion.nix
    ./treesitter.nix
    ./snacks.nix
    ./assistant.nix
    ./editor.nix
  ];

  programs.nvf.settings.vim = {
    statusline.lualine.enable = true;
    binds.whichKey.enable = true;
    git.gitsigns.enable = true;
  };
}
