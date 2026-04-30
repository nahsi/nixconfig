{ hostConfig, ... }:

let
  fontFamily = "Fira Code";

  tabsCss = ''
    headerbar,
    tabbar,
    tabbar tabbox {
      margin: 0;
      padding: 0;
      background: #181825;
      border: 0;
      box-shadow: none;
    }

    tabbar,
    tabbar tabbox,
    tabbar tabbox tab,
    tabbar tabbox tabboxchild {
      min-height: 0;
    }

    tabbar tabbox tab,
    tabbar tabbox tabboxchild {
      border-radius: 0;
      box-shadow: none;
    }

    tabbar tabbox tab {
      background: #181825;
      color: #a6adc8;
      border-right: 1px solid #313244;
    }

    tabbar tabbox tab:hover {
      background: #313244;
      color: #cdd6f4;
    }

    tabbar tabbox tab:selected,
    tabbar tabbox tab:checked,
    tabbar tabbox tabboxchild:selected,
    tabbar tabbox tabboxchild:checked {
      background: #cba6f7;
      color: #11111b;
    }

    tabbar tabbox tab label,
    tabbar tabbox tab button {
      color: inherit;
      font-family: "${fontFamily}", monospace;
      font-weight: 600;
    }

    tabbar tabbox tab label {
      padding-top: 0;
      padding-bottom: 0;
    }

    tabbar tabbox tab button {
      min-width: 0;
      min-height: 0;
      padding-top: 0;
      padding-bottom: 0;
      background: transparent;
      border: 0;
    }

    tabbar tabbox tab button:hover {
      color: #f38ba8;
      background: transparent;
    }
  '';
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      font-family = fontFamily;
      font-size = hostConfig.fontSize;
      theme = "catppuccin-mocha";

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

  xdg.configFile."ghostty/tabs.css".text = tabsCss;
}
