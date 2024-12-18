{ inputs, pkgs, ... }:
let
  package = inputs.inputmodule-control.legacyPackages.${pkgs.system};
in
{

  home = {
    packages = [
      package.fw-inputmodule
    ];
  };
}
