{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    bootspec.enable = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot =
        if !config.boot.lanzaboote.enable then
          {
            enable = true;
          }
        else
          { enable = lib.mkForce false; };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
  environment.systemPackages = [ pkgs.sbctl ];
}
