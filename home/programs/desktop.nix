{ pkgs, ... }:
{
  # launcher
  programs.fuzzel.enable = true;

  # notifications
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 3000;
    };
  };

  # system monitor
  programs.btop = {
    enable = true;
    settings = {
      show_coretemp = false;
    };
  };

  # gtk theming
  home.pointerCursor = {
    size = 64;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

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
  programs.anki.enable = true;
  programs.zathura.enable = true;
  programs.aerc.enable = true;
}
