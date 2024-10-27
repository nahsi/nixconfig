{ inputs, pkgs, ... }:
let
  ragenix = inputs.ragenix.packages.${pkgs.system}.default;
in
{
  home.packages = [ ragenix ];
}
