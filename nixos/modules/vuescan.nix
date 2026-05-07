{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = pkgs.callPackage ../../pkgs/vuescan { };
in
{
  options.programs.vuescan.enable = lib.mkEnableOption "VueScan scanner software";

  config = lib.mkIf config.programs.vuescan.enable {
    environment.systemPackages = [ package ];
    services.udev.packages = [ package ];
  };
}
