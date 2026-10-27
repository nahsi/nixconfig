{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.dbus.enable = true;

  boot.kernelParams = [ "console=tty1" ];
  boot.consoleLogLevel = 0;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%H:%M | %a • %h | %F' --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  environment.sessionVariables = {
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_SCALE = 2;
  };
}
