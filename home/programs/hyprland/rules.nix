{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # Ignore maximize requests from apps
      "suppressevent maximize, class:.*"

      # Fix dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # Pin apps to workspaces
      "workspace 3 silent,class:^(superProductivity)$"
      "workspace 4 silent,class:^(org.telegram.desktop)$"
      "workspace 5 silent,class:^(Slack)$"
    ];
  };
}
