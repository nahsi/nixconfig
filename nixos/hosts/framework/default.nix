{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./fprintd.nix
    ./plymouth.nix
    ./nfs.nix
    ./sing-box.nix
    ../../system
  ];

  networking.hostName = "framework";

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true;
    earlySetup = true;
  };

  boot.loader.systemd-boot.consoleMode = "auto";
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  system.stateVersion = "26.05";
}
