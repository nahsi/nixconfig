{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    extraPackages = [ pkgs.claude-agent-acp ];

    assistant.codecompanion-nvim = {
      enable = true;
      setupOpts = {
        strategies = {
          chat.adapter = "claude_code";
          inline.adapter = "claude_code";
        };
      };
    };

    keymaps = [
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
}
