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
    package = null;
    portalPackage = null;
    systemd.enableXdgAutostart = true;
  };
}
