{
  inputs,
  system,
  pkgs,
  lib,
  ...
}:
let
  dpms = action: "hyprctl dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";

  can-suspend = pkgs.writeShellApplication {
    name = "can-suspend";
    runtimeInputs = [ pkgs.playerctl ];
    text = ''
      blocked=$(busctl get-property org.freedesktop.login1 /org/freedesktop/login1 \
        org.freedesktop.login1.Manager BlockInhibited)

      [[ "$(playerctl -a status 2>/dev/null)" != *Playing* ]]
      [[ "$blocked" != *@(idle|sleep)* ]]
    '';
  };
in
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
    package = inputs.nixpkgs-unstable.legacyPackages.${system}.hypridle;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${dpms "enable"} && hyprctl reload";
        ignore_systemd_inhibit = true;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = dpms "disable";
          on-resume = dpms "enable";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
          condition_cmd = lib.getExe can-suspend;
          condition_retry = 60;
        }
      ];
    };
  };
}
