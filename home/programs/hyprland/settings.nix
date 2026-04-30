{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    xwayland = {
      force_zero_scaling = true;
    };

    monitor = [
      "eDP-1,preferred,0x0,1.6"
      # "DP-2,preferred,auto,1,mirror,eDP-1"
      "DP-2,preferred,auto,2"
      "DP-3,preferred,auto-up,2"
      "DP-4,preferred,auto-up,2"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      resize_on_border = true;
      allow_tearing = false;
      layout = "dwindle";

      "col.active_border" = "$accent";
      "col.inactive_border" = "$base";
    };

    decoration = {
      rounding = 0;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
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

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    master = {
      new_status = "master";
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };

    input = {
      kb_layout = "us,ru";
      kb_options = "grp:alt_shift_toggle,compose:rctrl";
      follow_mouse = 1;
      sensitivity = 0;
      touchpad = {
        natural_scroll = false;
        clickfinger_behavior = true;
        drag_lock = true;
      };
    };

    # gestures = {
    #   workspace_swipe = true;
    # };
  };
}
