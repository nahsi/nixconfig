_: {
  wayland.windowManager.hyprland.settings.window_rule = [
    # Ignore maximize requests from apps
    {
      match.class = ".*";
      suppress_event = "maximize";
    }

    # Fix dragging issues with XWayland
    {
      match = {
        class = "^$";
        title = "^$";
        xwayland = true;
        float = true;
        fullscreen = false;
        pin = false;
      };
      no_focus = true;
    }

    # Ferrosonic scratchpad
    {
      match.class = "^(ferrosonic)$";
      workspace = "special:music silent";
    }

    # Pin apps to workspaces
    {
      match.class = "^superproductivity$";
      workspace = "3 silent";
    }
    {
      match.class = "^element$";
      workspace = "4 silent";
    }
    {
      match.class = "^slack$";
      workspace = "5 silent";
    }
  ];
}
