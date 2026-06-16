_: {
  programs.nvf.settings.vim = {
    utility = {
      surround.enable = true;
      oil-nvim = {
        enable = true;
        setupOpts.default_file_explorer = true;
      };
    };

    keymaps = [
      {
        key = "-";
        mode = "n";
        action = "<cmd>Oil<cr>";
        desc = "Open parent directory";
        silent = true;
      }
    ];
  };
}
