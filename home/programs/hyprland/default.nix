{
  imports = [
    ./services.nix
    ./settings.nix
    ./keybindings.nix
    ./rules.nix
    ./hyprlock.nix
    ./hyprsunset.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enableXdgAutostart = true;
  };
}
