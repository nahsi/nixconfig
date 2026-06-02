_: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = false;

      searchCase = "smart";
      preventJunkFiles = true;
      undoFile.enable = true;
      clipboard = {
        enable = true;
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

        tm = 300;
        breakindent = true;

        cursorline = true;
        scrolloff = 8;
        sidescrolloff = 8;

        inccommand = "split";
        showmode = false;
        laststatus = 3;
        pumheight = 10;
        confirm = true;

        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };

        grepprg = "rg --vimgrep";
      };

      lsp = {
        enable = true;
        inlayHints.enable = true;
        servers.nixd.settings.nixd = {
          nixpkgs.expr = ''import (builtins.getFlake "/home/nahsi/nixfiles").inputs.nixpkgs.outPath { }'';
          options = {
            nixos.expr = ''(builtins.getFlake "/home/nahsi/nixfiles").nixosConfigurations.framework.options'';
            home-manager.expr = ''(builtins.getFlake "/home/nahsi/nixfiles").homeConfigurations.nahsi.options'';
          };
        };
      };

      diagnostics = {
        enable = true;
        config.virtual_lines.current_line = true;
      };

      autocomplete.blink-cmp = {
        enable = true;
        setupOpts.keymap.preset = "enter";
      };
      statusline.lualine.enable = true;

      treesitter = {
        textobjects.enable = true;
        context.enable = true;
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        rust = {
          enable = true;
          extensions.crates-nvim.enable = true;
        };
        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
        };
        yaml.enable = true;
        terraform.enable = true;
        bash.enable = true;
        markdown.enable = true;
        lua.enable = true;
        toml.enable = true;
      };

      git.gitsigns.enable = true;
      binds.whichKey.enable = true;

      assistant.codecompanion-nvim = {
        enable = true;
        setupOpts = {
          strategies = {
            chat.adapter = "claude_code";
            inline.adapter = "claude_code";
          };
        };
      };

      utility = {
        surround.enable = true;
        oil-nvim = {
          enable = true;
          setupOpts.default_file_explorer = true;
        };
        snacks-nvim = {
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
      };

      keymaps = [
        {
          key = "-";
          mode = "n";
          action = "<cmd>Oil<cr>";
          desc = "Open parent directory";
          silent = true;
        }
        {
          key = "<leader>gg";
          mode = "n";
          action = "<cmd>lua Snacks.lazygit()<cr>";
          desc = "Lazygit";
          silent = true;
        }
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
        {
          key = "<leader>aa";
          mode = [
            "n"
            "v"
          ];
          action = "<cmd>CodeCompanionActions<cr>";
          desc = "AI: actions";
          silent = true;
        }
        {
          key = "<leader>ac";
          mode = [
            "n"
            "v"
          ];
          action = "<cmd>CodeCompanionChat Toggle<cr>";
          desc = "AI: toggle chat";
          silent = true;
        }
        {
          key = "<leader>ad";
          mode = "v";
          action = "<cmd>CodeCompanionChat Add<cr>";
          desc = "AI: add selection to chat";
          silent = true;
        }
      ];
    };
  };
}
