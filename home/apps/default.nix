{ pkgs, ... }:
{
  imports = [
    ./qutebrowser
    ./mpv.nix
    ./aerc.nix
    ./kdeconnect.nix
    ./taskwarrior.nix
    ./tomat.nix
    ./sendspin.nix
    ./tern.nix
  ];

  programs = {
    imv.enable = true;
    element-desktop.enable = true;
    anki.enable = true;
    zathura.enable = true;
    ferrosonic.enable = true;
    chromium = {
      enable = true;
      # Capturing the camera directly resets its controls to defaults, so go through PipeWire.
      # Repeats the wrapper's Wayland feature because only the last --enable-features applies.
      commandLineArgs = [ "--enable-features=WaylandWindowDecorations,WebRtcPipeWireCamera" ];
    };
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
