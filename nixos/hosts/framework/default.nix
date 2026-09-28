{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./fprintd.nix
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
  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;

    # Tag the serial devices before systemd's 73-seat-late.rules applies seat ACLs.
    udev.packages = [
      (pkgs.writeTextDir "lib/udev/rules.d/70-framework-led-matrix.rules" ''
        SUBSYSTEM=="tty", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0020", MODE="0660", TAG+="uaccess"
      '')
    ];
  };

  system.stateVersion = "26.05";
}
