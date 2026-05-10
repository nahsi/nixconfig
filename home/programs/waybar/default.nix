{ pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    style = lib.readFile ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "mpris" ];
        modules-right = [
          "tray"
          "wireplumber"
          "cpu"
          "memory"
          "battery"
          "hyprland/language"
          "clock"
        ];
        "mpris" = {
          player = "ferrosonic";
          format = "󰎆  {title} — {artist}";
          format-paused = "󰏤  {title} — {artist}";
          tooltip-format = "{title}\n{artist}\n{album}";
        };
        "hyprland/language" = {
          format = "{short}";
        };
        "hyprland/workspaces" = {
          format = "{name}";
          show-special = true;
          on-scroll-up = "hyprctl dispatch workspace r-1";
          on-scroll-down = "hyprctl dispatch workspace r+1";
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
          ignore-workspaces = [ "special:hdrop" ];
        };
        "hyprland/window" = {
          icon = true;
          rewrite = {
            ".+" = "";
          };
        };
        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%a, %b %d, %Y - %R}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              today = "<b><u>{}</u></b>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        "wireplumber" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 {volume}%";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          reverse-scrolling = 1;
          tooltip = false;
        };
        "memory" = {
          format = "󰍛 {used:0.1f}G";
          tooltip = false;
        };
        "cpu" = {
          states = {
            critical = 75;
          };
          format = " {usage}%";
          tooltip = false;
        };
        "battery" = {
          states = {
            "warning" = 30;
            "critical" = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = "󱐋 {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          tooltip-format = "{timeTo}\n{power}W";
        };
        "tray" = {
          spacing = 10;
        };
      };
    };
  };
}
