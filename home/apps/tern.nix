{
  programs.tern = {
    enable = true;

    settings = {
      native_prompt = false;

      theme = "Dark";
      theme_dark = "ghostty-mocha";
      material = "Solid";
      density = "Compact";
      tabs = "Horizontal";
      status_bar = true;

      font_family = "Fira Code, FiraCode Nerd Font";
      code_font = "Fira Code, FiraCode Nerd Font";
      ui_font = "Fira Code";
      font_size = 19;
      padding_x = 2;
      padding_y = 2;
      snap_text = true;

      smooth_scroll = false;
      overscroll = false;
      copy_on_select = true;
      surface_chat = "Console";

      keymap = "ghostty";
      keybinds = {
        "ctrl+shift+h" = "previous_tab";
        "ctrl+shift+l" = "next_tab";
        "ctrl+shift+j" = "next_pane";
        "ctrl+shift+k" = "previous_pane";
      };
    };

    themes.ghostty-mocha = ''
      @import "dark-catppuccin";

      :root {
        color-scheme: dark;
        --tv-bg: #1e1e2e;
        --tv-fg: #cdd6f4;
        --tv-cur: #f5e0dc;
        --tv-cur-ink: #11111b;
        --tv-sel: #353749;
        --page: #1e1e2e;
        --accent: #b4befe;
        --ansi0: #45475a;
        --ansi1: #f38ba8;
        --ansi2: #a6e3a1;
        --ansi3: #f9e2af;
        --ansi4: #89b4fa;
        --ansi5: #f5c2e7;
        --ansi6: #94e2d5;
        --ansi7: #a6adc8;
        --ansi8: #585b70;
        --ansi9: #f38ba8;
        --ansi10: #a6e3a1;
        --ansi11: #f9e2af;
        --ansi12: #89b4fa;
        --ansi13: #f5c2e7;
        --ansi14: #94e2d5;
        --ansi15: #bac2de;
      }
    '';
  };
}
