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
    inputs.nvf.homeManagerModules.default
    inputs.nix-index-database.homeModules.default

    programs/hyprland
    programs/ashell.nix
    programs/ghostty
    programs/qutebrowser
    programs/git.nix
    programs/shell.nix
    programs/desktop.nix
    programs/nvim
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
      # network
      wireguard-tools
      iperf
      tcpdump
      termshark
      xh
      doggo
      gping

      # hardware
      dmidecode
      powertop

      # nix
      nix-melt
      statix
      deadnix
      nix-output-monitor
      nix-update
      nixos-generators
      devenv

      # devops
      awscli2
      talosctl
      kustomize
      kubernetes-helm
      kubectl
      vault
      terraform
      kubevirt
      hclfmt
      lazygit
      dive

      # ai
      qwen-code
      codex
      claude-code
      terraform-mcp-server

      # media
      yt-dlp
      mkvtoolnix
      mediainfo
      ffmpeg
      exiftool

      # fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      fira-code
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.fira-code
      roboto
      roboto-slab
    ]);
  };

  services = {
    mpris-proxy.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Fira Code"
        "FiraCode Nerd Font"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "Fira Sans"
        "Noto Sans CJK JP"
      ];
      serif = [
        "Roboto Slab"
        "Noto Serif CJK JP"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
    # gtk.enable = true;
  };
}
