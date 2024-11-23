{ inputs, pkgs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    programs/hyprland
    programs/waybar
    programs/kitty.nix
    programs/nnn.nix
    programs/qutebrowser.nix
    programs/zathura.nix
    programs/git.nix
    programs/bash.nix
    programs/fzf.nix
    programs/ripgrep.nix
    programs/starship.nix
    programs/fuzzel.nix
    programs/spicetify.nix
    programs/mako.nix
    programs/btop.nix
    programs/nixvim
    programs/ragenix.nix
    programs/direnv.nix
    programs/mpv.nix
    programs/gtk.nix

    languages/rust.nix
  ];

  home.username = "nahsi";
  home.homeDirectory = "/home/nahsi";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.language.base = "en_US.UTF-8";

  home.packages = [
    pkgs.brightnessctl
    pkgs.just
    pkgs.wl-clipboard
    pkgs.jq
    pkgs.bitwarden-cli
    pkgs.wireguard-tools
    pkgs.talosctl
    pkgs.hclfmt
    pkgs.pwgen
    pkgs.fastfetch
    #pkgs.qbittorrent
    pkgs.chromium

    # messaging
    pkgs.tdesktop
    pkgs.slack

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
    defaultFonts = {
      monospace = [
        "Fira Code"
        "FiraCode Nerd Font"
      ];
      sansSerif = [ "Fira Sans" ];
      serif = [ "Roboto Slab" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
