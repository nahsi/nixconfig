{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$secondMod" = "ALT";

    bind = [
      # Standard keybindings
      "$mod, return, exec, ghostty +new-window"
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
      "$mod, L, exec, hyprlock"

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
      "$mod, S, togglespecialworkspace, scratch"
      "$mod SHIFT, S, movetoworkspace, special:scratch"

      # Ferrosonic music scratchpad
      "$mod, F, togglespecialworkspace, music"

      # Scroll through existing workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Screenshot a monitor
      "$mod, PRINT, exec, hyprshot -m output --clipboard-only"
      "$secondMod SHIFT, P, exec, hyprshot -m output --clipboard-only"
      # Screenshot a region
      ",PRINT, exec, hyprshot -m region --clipboard-only"
      "$secondMod, P, exec, hyprshot -m region --clipboard-only"
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
      ", XF86AudioNext, exec, playerctl -p ferrosonic next"
      ", XF86AudioPause, exec, playerctl -p ferrosonic play-pause"
      ", XF86AudioPlay, exec, playerctl -p ferrosonic play-pause"
      ", XF86AudioPrev, exec, playerctl -p ferrosonic previous"

      # Laptop lid triggers
      ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
      ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1,preferred,auto,1.6\""
    ];
  };
}
