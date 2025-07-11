{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      };
    };
  };

  services.dbus.enable = true;

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
    QT_QPA_PLATFORM = "wayland";
  };
}
