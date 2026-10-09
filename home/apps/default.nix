{ pkgs, ... }:
{
  imports = [
    ./qutebrowser
    ./mpv.nix
    ./aerc.nix
    ./kdeconnect.nix
    ./taskwarrior.nix
    ./tomat.nix
  ];

  programs = {
    imv.enable = true;
    element-desktop.enable = true;
    anki.enable = true;
    zathura.enable = true;
    ferrosonic.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/slack" = "slack.desktop";
    };
    defaultApplicationPackages = [
      pkgs.imv
      pkgs.zathura
    ];
  };
}
