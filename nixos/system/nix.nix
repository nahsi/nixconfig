{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.nix_2_35;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      system-features = [ "uid-range" ];
      auto-optimise-store = true;
      auto-allocate-uids = true;
      trusted-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;
  # Reducing disk usage
  boot.loader.systemd-boot.configurationLimit = 10;
}
