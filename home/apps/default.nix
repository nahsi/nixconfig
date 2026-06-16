{ pkgs, ... }:
{
  imports = [
    ./qutebrowser
    ./mpv.nix
    ./aerc.nix
    ./kdeconnect.nix
  ];

  programs.imv.enable = true;
  programs.element-desktop.enable = true;
  programs.anki.enable = true;
  programs.zathura.enable = true;
  programs.ferrosonic.enable = true;
  programs.tanin.enable = true;

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
