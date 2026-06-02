_: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;

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
    };

    systemd.enable = true;
  };

  xdg.configFile."ghostty/tabs.css".source = ./tabs.css;
}
