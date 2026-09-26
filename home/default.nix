{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.homeModules.default

    ./packages.nix
    ./fonts.nix
    ./theme.nix
    ./ragenix.nix

    ./modules
    ./desktop
    ./dev
    ./apps
    ./shell
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "26.05";
    username = "nahsi";
    homeDirectory = "/home/nahsi";
    language.base = "en_DK.UTF-8";
  };

  services = {
    home-manager.autoExpire = {
      enable = true;
      timestamp = "-30 days";
      frequency = "weekly";
    };
    mpris-proxy.enable = true;
  };
}
