{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    fontPackages = [
      pkgs.corefonts
      pkgs.vistafonts
    ];
  };

  fonts.fontconfig = {
    enable = true;
  };
}
