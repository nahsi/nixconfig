{ pkgs, lib, ... }:

{
  services.fprintd.enable = true;

  # Only use fingerprint auth when lid open
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/security/pam.nix#L686C13-L686C158
  security.pam.services =
    let
      check-lid = pkgs.writeShellScript "lid.sh" ''
        #https://unix.stackexchange.com/a/743941
        if ${pkgs.gnugrep}/bin/grep -q closed /proc/acpi/button/lid/LID0/state
        then
          # If state is closed
          exit 1
        else
          # If state is anything besides closed
          exit 0
        fi
      '';
      limitsConf = pkgs.writeText "limits.conf" ''
        @pipewire - rtprio 95
        @pipewire - nice -19
        @pipewire - memlock 4194304
      '';
      fprintConfig = ''
         # Account management.
        account required ${pkgs.linux-pam}/lib/security/pam_unix.so # unix (order 10900)
        # Authentication management.
        # Skip fingerprint if lid closed
        auth   [success=ignore default=1]  pam_exec.so quiet ${check-lid}
        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so # fprintd (order 11300)
        auth sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so likeauth try_first_pass # unix (order 11500)
        auth required ${pkgs.linux-pam}/lib/security/pam_deny.so # deny (order 12300)
        # Password management.
        password sufficient ${pkgs.linux-pam}/lib/security/pam_unix.so nullok yescrypt # unix (order 10200)
        # Session management.
        session required ${pkgs.linux-pam}/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
        session required ${pkgs.linux-pam}/lib/security/pam_unix.so # unix (order 10200)
        session required ${pkgs.linux-pam}/lib/security/pam_limits.so conf=${limitsConf} # limits (order 12200)
      '';
    in
    {
      doas.text = lib.mkForce fprintConfig;
      #greetd.text = lib.mkForce fprintConfig;
      polkit-1.text = lib.mkForce fprintConfig;
    };
}
