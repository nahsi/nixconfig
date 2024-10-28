{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    programs/hyprland.nix
    programs/kitty.nix
    programs/qutebrowser.nix
    programs/git.nix
    programs/bash.nix
    programs/starship.nix
    programs/waybar.nix
    programs/fuzzel.nix
    programs/spicetify.nix
    programs/mako.nix
    programs/btop.nix
    programs/nixvim
    programs/ragenix.nix
    programs/direnv.nix
  ];

  home.username = "nahsi";
  home.homeDirectory = "/home/nahsi";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.language.base = "en_US.UTF-8";

  xresources.properties = {
    "Xft.dpi" = 259;
  };

  home.packages = [
    pkgs.brightnessctl
    pkgs.just
    pkgs.wl-clipboard

    pkgs.tdesktop
    pkgs.slack

    pkgs.nomad
    pkgs.consul
    pkgs.vault
    pkgs.terraform
    pkgs.packer

    # fonts
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.fira-code
    pkgs.nerdfonts
    pkgs.roboto
    pkgs.roboto-slab
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [
      "Fira Code"
      "FiraCode Nerd Font"
    ];
    defaultFonts.sansSerif = [ "Fira Sans" ];
    defaultFonts.serif = [ "Roboto Slab" ];
    defaultFonts.emoji = [ "Noto Color Emoji" ];
  };

  programs.neomutt.enable = true;

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
  #catppuccin.accent = "blue";

}
