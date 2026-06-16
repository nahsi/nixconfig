_: {
  programs.nvf.settings.vim = {
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        picker.enabled = true;
        lazygit.enabled = true;
        terminal.enabled = true;
        notifier.enabled = true;
        indent.enabled = true;
        words.enabled = true;
        input.enabled = true;
        statuscolumn.enabled = true;
        scroll.enabled = true;
        rename.enabled = true;
      };
    };

    keymaps = [
      # Lazygit
      {
        key = "<leader>gg";
        mode = "n";
        action = "<cmd>lua Snacks.lazygit()<cr>";
        desc = "Lazygit";
        silent = true;
      }

      # Terminal
      {
        key = "<C-/>";
        mode = "n";
        action = "<cmd>lua Snacks.terminal()<cr>";
        desc = "Toggle terminal";
        silent = true;
      }
      {
        key = "<C-/>";
        mode = "t";
        action = "<cmd>close<cr>";
        desc = "Hide terminal";
        silent = true;
      }

      # Pickers
      {
        key = "<leader>ff";
        mode = "n";
        action = "<cmd>lua Snacks.picker.files()<cr>";
        desc = "Find files";
        silent = true;
      }
      {
        key = "<leader>fg";
        mode = "n";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        desc = "Live grep";
        silent = true;
      }
      {
        key = "<leader>fb";
        mode = "n";
        action = "<cmd>lua Snacks.picker.buffers()<cr>";
        desc = "Buffers";
        silent = true;
      }
      {
        key = "<leader>fr";
        mode = "n";
        action = "<cmd>lua Snacks.picker.recent()<cr>";
        desc = "Recent files";
        silent = true;
      }
      {
        key = "<leader>fd";
        mode = "n";
        action = "<cmd>lua Snacks.picker.diagnostics()<cr>";
        desc = "Diagnostics";
        silent = true;
      }
      {
        key = "<leader>fh";
        mode = "n";
        action = "<cmd>lua Snacks.picker.help()<cr>";
        desc = "Help";
        silent = true;
      }
    ];
  };
}
