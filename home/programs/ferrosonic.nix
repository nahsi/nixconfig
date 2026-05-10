{
  pkgs,
  inputs,
  system,
  ...
}:
let
  localPkgs = inputs.self.packages."${system}";
in
{
  home.packages = [
    localPkgs.ferrosonic-ng
    pkgs.cava
  ];
}
