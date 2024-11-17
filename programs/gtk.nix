{ pkgs, ... }:
{
  home.pointerCursor = {
    size = 64;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
