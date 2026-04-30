{ pkgs, ... }:
{
  services.fprintd.enable = true;

  # Prevent fprintd from starting when lid is closed.
  # fprintd is D-Bus activated — each auth attempt triggers a fresh start.
  # ExecStartPre fails when lid is closed → fprintd doesn't start →
  # pam_fprintd returns PAM_AUTHINFO_UNAVAIL → PAM falls through to pam_unix (password).
  # Works for all PAM services (doas, polkit-1, greetd, hyprlock) with no per-service config.
  systemd.services.fprintd.serviceConfig.ExecStartPre =
    "${pkgs.gnugrep}/bin/grep -q open /proc/acpi/button/lid/LID0/state";

  # Pipewire real-time priority limits (previously buried in raw PAM text)
  security.pam.loginLimits = [
    {
      domain = "@pipewire";
      type = "-";
      item = "rtprio";
      value = "95";
    }
    {
      domain = "@pipewire";
      type = "-";
      item = "nice";
      value = "-19";
    }
    {
      domain = "@pipewire";
      type = "-";
      item = "memlock";
      value = "4194304";
    }
  ];
}
