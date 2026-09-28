{ ... }:
{
  imports = [
    ./hyprland
    ./ghostty
    ./ashell
    ./led-matrix
  ];

  programs.fuzzel.enable = true;
}
