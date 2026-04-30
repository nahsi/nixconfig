{ pkgs, ... }:
{
  home.sessionVariables = {
    HYPRCURSOR_SIZE = 48;
    HYPRCURSOR_THEME = "catppuccin-mocha-blue-cursors";
    GDK_SCALE = 2;
    XCURSOR_SIZE = 32;
  };

  home.packages = [
    pkgs.hyprpaper
    pkgs.hyprcursor
    pkgs.hyprpicker
    pkgs.hyprshot
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "/home/nahsi/Wallpapers/wallhaven-o36epm.png" ];
      wallpaper = [ ", /home/nahsi/Wallpapers/wallhaven-o36epm.png" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings.exec-once = [
      "nm-applet"
      "Telegram"
      "super-productivity"
    ];
  };
}
