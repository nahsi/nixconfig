{ inputs, pkgs, ... }:
let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
  pinnedZoomPkgs =
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
        sha256 = "0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
      })
      {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

  pinnedZoom = pinnedZoomPkgs.zoom-us;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

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
      pkgs.ncdu
      pkgs.mkvtoolnix

      unstablePkgs.talosctl
      pkgs.kubectl
      pkgs.nomad
      pkgs.consul
      pkgs.vault
      pkgs.terraform
      pkgs.kubevirt
      pkgs.cilium-cli
      pkgs.hubble

      # messaging
      pkgs.tdesktop
      pkgs.slack
      #pkgs.zoom-us
      pinnedZoom

      # nix
      pkgs.nix-melt
      pkgs.statix
      pkgs.deadnix
      pkgs.nom
      pkgs.nixos-generators

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
