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
    programs/fw-inputmodule.nix
    programs/aerc.nix

    languages/rust.nix
  ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "24.05";
    username = "nahsi";
    homeDirectory = "/home/nahsi";
    language.base = "en_US.UTF-8";

    packages = [
      pkgs.brightnessctl
      pkgs.just
      pkgs.wl-clipboard
      pkgs.unzip
      pkgs.jq
      pkgs.bitwarden-cli
      pkgs.wireguard-tools
      pkgs.hclfmt
      pkgs.pwgen
      pkgs.mkpasswd
      pkgs.fastfetch
      pkgs.chromium
      pkgs.blanket
      pkgs.stremio
      pkgs.wireshark
      pkgs.yt-dlp
      pkgs.mtr
      pkgs.dmidecode
      pkgs.iperf
      pkgs.powertop

      pkgs.talosctl
      pkgs.kubectl
      pkgs.nomad
      pkgs.consul
      pkgs.vault
      pkgs.terraform
      pkgs.talosctl
      pkgs.kubevirt
      pkgs.cilium-cli
      pkgs.hubble

      # messaging
      pkgs.tdesktop
      pkgs.slack
      pkgs.zoom-us

      # nix
      pkgs.nix-melt
      pkgs.statix

      # fonts
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.fira-code
      pkgs.nerdfonts
      pkgs.roboto
      pkgs.roboto-slab
    ];
  };

  services = {
    mpris-proxy.enable = true;
    blueman-applet.enable = true;
  };

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
    gtk.enable = true;
  };
}
