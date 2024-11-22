{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    style = pkgs.lib.readFile ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "cpu"
          "battery"
          "hyprland/language"
          "clock"
        ];
        "hyprland/language" = {
          format = "{short}";
        };
        "hyprland/workspaces" = {
          format = "{icon}";
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
          format = "{:%a, %b %d - %H:%M}";
        };
        "cpu" = {
          states = {
            critical = 75;
          };
          format = "{usage}% ";
          tooltip = false;
        };
        "battery" = {
          states = {
            "awesome" = 90;
            "good" = 80;
            "warning" = 30;
            "critical" = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-awesome = "";
        };
        "tray" = {
          spacing = 10;
        };
      };
    };
  };
}
