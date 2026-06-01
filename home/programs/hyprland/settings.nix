{ lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    mod = {
      _var = "SUPER";
    };

    secondMod = {
      _var = "ALT";
    };

    config = {
      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
        col = {
          active_border = lib.generators.mkLuaInline "colors.mauve";
          inactive_border = lib.generators.mkLuaInline "colors.base";
        };
      };

      decoration = {
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      master = {
        new_status = "master";
      };

      dwindle = {
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        vrr = 2;
      };

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle,compose:rctrl";
        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
          drag_lock = true;
        };
      };
    };

    gesture = [
      {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      }
    ];

    monitor = [
      {
        output = "eDP-1";
        mode = "preferred";
        position = "0x0";
        scale = 1.6;
      }
      {
        output = "DP-2";
        mode = "preferred";
        position = "auto";
        scale = 2;
      }
      {
        output = "DP-3";
        mode = "preferred";
        position = "auto-up";
        scale = 2;
      }
      {
        output = "DP-4";
        mode = "preferred";
        position = "auto-up";
        scale = 2;
      }
    ];

    curve = {
      _args = [
        "myBezier"
        {
          type = "bezier";
          points = [
            [
              0.05
              0.9
            ]
            [
              0.1
              1.05
            ]
          ];
        }
      ];
    };

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 7;
        bezier = "myBezier";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 7;
        bezier = "default";
        style = "popin 80%";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 10;
        bezier = "default";
      }
      {
        leaf = "borderangle";
        enabled = true;
        speed = 8;
        bezier = "default";
      }
      {
        leaf = "fade";
        enabled = true;
        speed = 7;
        bezier = "default";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 6;
        bezier = "default";
      }
    ];
  };
}
