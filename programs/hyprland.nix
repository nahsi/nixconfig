{ config, pkgs, ... }:
{
  home.sessionVariables = {
    HYPRCUROS_SIZE = 48;
    HYPRCUROR_THEME = "captuccin-mocha-blue-cursors";
    NIXOS_OZONE_WL = 1;
  };

  home.packages = [
    pkgs.hyprpaper
    pkgs.hyprcursor
    pkgs.hyprpicker
  ];

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        preload = [ "/home/nahsi/Wallpapers/wallhaven-m9wm98.jpg" ];
        wallpaper = [ ", /home/nahsi/Wallpapers/wallhaven-m9wm98.jpg" ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      ################
      ### MONITORS ###
      ################
      monitor = [
        "eDP-1,preferred,auto,1.6"
        "DP-2,preferred,auto,1.875"
        "DP-3,preferred,auto,1.875"
      ];

      ###################
      ### AUTOSTART ###
      ###################
      # exec-once = [ "waybar" ];

      #####################
      ### LOOK AND FEEL ###
      #####################
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";

        "col.active_border" = "$accent";
        "col.inactive_border" = "$base";

      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
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
      };

      #############
      ### INPUT ###
      #############
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures.workspace_swipe = true;

      ###################
      ### KEYBINDINGS ###
      ###################
      "$mod" = "SUPER";
      "$secondMod" = "ALT";

      bind = [
        # Standard keybindings
        "$mod, return, exec, kitty"
        "$mod, Q, exec, qutebrowser"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating"
        "$mod, R, exec, fuzzel"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$secondMod, J, cyclenext"
        "$secondMod SHIFT, J, cyclenext, prev"

        # Workspace bindings
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Special workspace
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

      ];
      bindm = [
        # Move/resize windows with mouse dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        # Multimedia keys
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        "SHIFT, XF86MonBrightnessUp, exec, ddcutil --display 1 setvcp 10 + 5"
        "SHIFT, XF86MonBrightnessDown, exec, ddcutil --display 1 setvcp 10 - 5"
      ];

      bindl = [
        # Player controls
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"

        # Laptop lid triggers
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1,preferred,auto,1.6\""
      ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      windowrulev2 = [
        # Ignore maximize requests from apps
        "suppressevent maximize, class:.*"

        # Fix dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
