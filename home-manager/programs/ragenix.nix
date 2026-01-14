{ inputs, pkgs, ... }:
let
  ragenix = inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ ragenix ];
}
