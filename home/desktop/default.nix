{ ... }:
{
  imports = [
    ./hyprland
    ./ghostty
    ./ashell.nix
    ./notifications.nix
  ];

  programs.fuzzel.enable = true;
}
