_: {
  imports = [
    ./lsp
    ./plugins
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = false;
      searchCase = "smart";
      preventJunkFiles = true;
      undoFile.enable = true;

      clipboard = {
        enable = true;
        # system clipboard register; without this, yank stays nvim-internal
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = true;
      };

      options = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        breakindent = true;

        cursorline = true;
        scrolloff = 8;
        sidescrolloff = 8;

        showmode = false;
        laststatus = 3;
        pumheight = 10;
        confirm = true;
        inccommand = "split";

        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };

        tm = 300;
        grepprg = "rg --vimgrep";
      };
    };
  };
}
