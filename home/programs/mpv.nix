{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.mpris ];
    config = {
      osc = "no";
      osd-bar = "no";
    };
    bindings = {
      "l" = "seek 30";
      "h" = "seek -30";
      "k" = "seek -5";
      "j" = "seek 5";
    };
  };
  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match.class = "^(mpv)$";
      float = true;
    }
  ];
}
