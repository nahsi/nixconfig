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
  home.packages = [
    localPkgs.kroki-cli
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

    # media
    yt-dlp
    mkvtoolnix
    mediainfo
    ffmpeg
    exiftool

    # desktop
    wl-clipboard
    brightnessctl
    playerctl
    chromium
    slack
    rawtherapee
    keymapp
  ]);
}
