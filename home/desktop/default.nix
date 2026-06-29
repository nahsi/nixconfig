{ ... }:
{
  imports = [
    ./hyprland
    ./ghostty
    ./ashell.nix
  ];

  programs.fuzzel.enable = true;
}
