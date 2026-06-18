{
  pkgs,
  inputs,
  system,
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

  systemd.user.services = {
    super-productivity = {
      Unit = {
        Description = "Super Productivity";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${inputs.self.packages.${system}.super-productivity}/bin/superproductivity";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
