{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.hyprpicker
    pkgs.hyprshot
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "/home/nahsi/Wallpapers/wallhaven-w5m6yr.jpg" ];
      wallpaper = [
        {
          monitor = "";
          path = "/home/nahsi/Wallpapers/wallhaven-w5m6yr.jpg";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings.general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on && hyprctl reload";
    };
  };
}
