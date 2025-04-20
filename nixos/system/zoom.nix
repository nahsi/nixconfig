{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /usr/share/xdg-desktop-portal/portals - - - - /run/current-system/sw/share/xdg-desktop-portal/portals "
    "L+ /usr/libexec/xdg-desktop-portal-gtk - - - - ${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk "
    "L+ /usr/libexec/xdg-desktop-portal-wlr - - - - ${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr "
    "L+ /usr/libexec/xdg-desktop-portal - - - - ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal "
  ];

  environment.systemPackages = with pkgs; [
    zoom-us
  ];
}
