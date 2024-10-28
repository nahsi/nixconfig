{ pkgs, config, ... }:
{
  programs.hyprland = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  boot.kernelParams = [ "console=tty1" ];
  boot.consoleLogLevel = 0;

  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%H:%M | %a • %h | %F' --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  environment.sessionVariables = {
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    NIXOS_OZONE_WL = "1";
  };
}
