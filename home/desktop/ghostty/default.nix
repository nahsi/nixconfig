_: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      font-family = "Fira Code";
      font-size = "14";

      gtk-tabs-location = "bottom";
      gtk-wide-tabs = false;
      gtk-toolbar-style = "flat";
      gtk-custom-css = "tabs.css";

      shell-integration-features = "ssh-env,ssh-terminfo";

      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";

      keybind = [
        "ctrl+shift+h=previous_tab"
        "ctrl+shift+l=next_tab"
        "ctrl+shift+j=goto_split:next"
        "ctrl+shift+k=goto_split:previous"
      ];
    };

    systemd.enable = true;
  };

  xdg.configFile."ghostty/tabs.css".source = ./tabs.css;
}
