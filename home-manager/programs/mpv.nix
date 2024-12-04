{
  programs.mpv = {
    enable = true;
    config = {
      osc = "no";
      osd-bar = "no";
    };
    bindings = {
      "l" = "seek 60";
      "h" = "seek -60";
      "k" = "seek -5";
      "j" = "seek 5";
    };
  };
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float,class:^(mpv)$"
  ];
}
