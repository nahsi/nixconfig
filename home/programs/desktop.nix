{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    brightnessctl
    playerctl
    chromium
    slack
    super-productivity
    imv
    rawtherapee
    keymapp
  ];

  # launcher
  programs.fuzzel.enable = true;

  # notifications: stays on mako until ashell 0.9.0 adds the Notifications module
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 3000;
      max-visible = 5;
      max-history = 50;
      group-by = "app-name";

      anchor = "top-right";
      layer = "top";
      margin = 12;

      width = 360;
      height = 140;
      border-size = 2;
      border-radius = 8;
      icons = true;
      max-icon-size = 48;

      "urgency=critical" = {
        default-timeout = 0;
        border-size = 3;
      };
    };
  };

  catppuccin.cursors.enable = true;
  home.pointerCursor.size = 32;

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # apps
  programs.element-desktop.enable = true;
  programs.anki.enable = true;
  programs.zathura.enable = true;
  programs.ferrosonic.enable = true;
  programs.tanin.enable = true;
}
