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
    programs/qutebrowser
    programs/git.nix
    programs/shell.nix
    programs/desktop.nix
    programs/nixvim
    programs/ragenix.nix
    programs/mpv.nix
    programs/aerc.nix
    programs/ferrosonic.nix
    programs/kdeconnect.nix

    languages/rust.nix
    languages/python.nix
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion = "26.05";
    username = "nahsi";
    homeDirectory = "/home/nahsi";
    language.base = "en_US.UTF-8";

    packages = [
      localPkgs.kroki-cli
      localPkgs.mcp-victorialogs
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
      skopeo

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
      nsxiv

      # photo
      rawtherapee
      exiftool

      # productivity
      super-productivity
      chromium
      keymapp

      # messaging
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
      hclfmt

      # mcp
      terraform-mcp-server

      # ai
      qwen-code
      codex
      claude-code

      # nix
      nix-melt
      statix
      deadnix
      nix-output-monitor
      nix-update
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
    network-manager-applet.enable = true;
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
