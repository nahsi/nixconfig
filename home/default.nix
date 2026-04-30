{
  inputs,
  pkgs,
  system,
  ...
}:
let
  localPkgs = inputs.self.packages."${system}";
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    programs/hyprland
    programs/waybar
    programs/ghostty
    programs/nnn.nix
    programs/qutebrowser.nix
    programs/git.nix
    programs/shell.nix
    programs/desktop.nix
    programs/nixvim
    programs/ragenix.nix
    programs/mpv.nix

    languages/rust.nix
    languages/python.nix
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.05";
    username = "nahsi";
    homeDirectory = "/home/nahsi";
    language.base = "en_US.UTF-8";

    packages = [
      localPkgs.kroki-cli
    ]
    ++ (with pkgs; [
      # utilities
      brightnessctl
      just
      wl-clipboard
      unzip
      jq
      tree
      pwgen
      mkpasswd
      fastfetch
      openssl
      ncdu
      dust

      # network
      wireguard-tools
      mtr
      iperf
      tcpdump
      wireshark

      # hardware
      dmidecode
      powertop

      # media
      yt-dlp
      mkvtoolnix
      mediainfo
      ffmpeg
      blanket
      stremio
      nsxiv

      # photo
      rawtherapee
      exiftool

      # productivity
      super-productivity
      chromium
      keymapp

      # messaging
      telegram-desktop
      slack

      # devops stuff
      awscli2
      talosctl
      kustomize
      kubernetes-helm
      kubectl
      vault
      terraform
      kubevirt
      kdash
      hclfmt
      bitwarden-cli

      # ai
      qwen-code
      codex
      claude-code

      # nix
      nix-melt
      statix
      deadnix
      nom
      nixos-generators
      devenv

      # fonts
      noto-fonts
      noto-fonts-cjk-sans
      fira-code
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.fira-code
      roboto
      roboto-slab
    ]);
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
    # gtk.enable = true;
  };
}
