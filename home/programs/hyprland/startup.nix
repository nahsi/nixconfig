{ pkgs, ... }:
let
  applyLidState = pkgs.writeShellApplication {
    name = "hypr-apply-lid-state";
    runtimeInputs = [
      pkgs.dbus
      pkgs.hyprland
    ];
    text = ''
      closed=$(dbus-send --print-reply=literal --system \
        --dest=org.freedesktop.UPower /org/freedesktop/UPower \
        org.freedesktop.DBus.Properties.Get \
        string:org.freedesktop.UPower string:LidIsClosed \
        | awk '{print $NF}')
      if [ "$closed" = "true" ]; then
        hyprctl eval 'hl.monitor({output="eDP-1", disabled=true})'
      fi
    '';
  };
in
{
  home.packages = [
    pkgs.hyprpaper
    pkgs.hyprcursor
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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enableXdgAutostart = true;
  };

  systemd.user.services = {
    hypr-apply-lid-state = {
      Unit = {
        Description = "Apply Hyprland monitor config based on lid state at startup";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${applyLidState}/bin/hypr-apply-lid-state";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    super-productivity = {
      Unit = {
        Description = "Super Productivity";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.super-productivity}/bin/super-productivity";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
