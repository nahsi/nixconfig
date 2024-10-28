{
  osConfig,
  config,
  pgks,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = ''
            * {
                font-family: FantasqueSansMono Nerd Font;
                font-size: 17px;
                min-height: 0;
              }

              #waybar {
                background: @base;
                color: @text;
                margin: 5px 5px;
              }

              #workspaces {
                border-radius: 1rem;
                margin: 5px;
                background-color: @surface0;
                margin-left: 1rem;
              }

              #workspaces button {
                color: @lavender;
                border-radius: 1rem;
                padding: 0.4rem;
              }

              #workspaces button.active {
                color: @sky;
                border-radius: 1rem;
              }

              #workspaces button:hover {
                color: @sapphire;
                border-radius: 1rem;
              }

              #custom-music,
              #tray,
              #backlight,
              #clock,
              #battery,
              #pulseaudio,
              #custom-lock,
              #custom-power {
                background-color: @surface0;
                padding: 0.5rem 1rem;
                margin: 5px 0;
              }

      	#language {
      	  margin: 1rem;
      	}

              #clock {
                color: @blue;
                border-radius: 0px 1rem 1rem 0px;
                margin-right: 1rem;
              }

              #battery {
                color: @green;
              }

              #battery.charging {
                color: @green;
              }

              #battery.warning:not(.charging) {
                color: @red;
              }

              #backlight {
                color: @yellow;
              }

              #backlight, #battery {
                  border-radius: 0;
              }

              #pulseaudio {
                color: @maroon; border-radius: 1rem 0px 0px 1rem;
                margin-left: 1rem;
              }

              #custom-music {
                color: @mauve;
                border-radius: 1rem;
              }

              #custom-lock {
                  border-radius: 1rem 0px 0px 1rem;
                  color: @lavender;
              }

              #custom-power {
                  margin-right: 1rem;
                  border-radius: 0px 1rem 1rem 0px;
                  color: @red;
              }

              #tray {
                margin-right: 1rem;
                border-radius: 1rem;
              }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "hyprland/language"
          "battery"
          "clock"
        ];
        "hyprland/language" = {
          format = "{}";
          format-en = "EN";
          format-ru = "RU";
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
        "tray" = {
          spacing = 10;
        };
      };
    };
  };
}
