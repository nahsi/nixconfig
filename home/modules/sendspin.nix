{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sendspin;
  escapeExecArgs = lib.concatMapStringsSep " " (
    arg: lib.replaceStrings [ "%" "$" ] [ "%%" "$$" ] (builtins.toJSON arg)
  );
in
{
  options.services.sendspin = {
    enable = lib.mkEnableOption "Sendspin audio player daemon";

    package = lib.mkPackageOption pkgs [ "python3Packages" "sendspin" ] { };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--name"
        "Living Room"
        "--hardware-volume"
        "false"
      ];
      description = ''
        Arguments passed to `sendspin daemon`. These override saved settings.
        Sendspin manages its writable settings, identity, and pairing records
        in `~/.config/sendspin`; this module does not generate a settings file.
        Without `--url`, the daemon advertises itself using mDNS. MPRIS is
        enabled by default. Firewall access must be configured separately.
      '';
    };

    systemdTarget = lib.mkOption {
      type = lib.types.str;
      default = "graphical-session.target";
      description = ''
        User systemd target that starts and stops the daemon. For headless
        use, `default.target` requires a working user audio and D-Bus session;
        starting at boot also requires user lingering outside Home Manager.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.sendspin" pkgs lib.platforms.linux)
    ];

    home.packages = [ cfg.package ];

    systemd.user.services.sendspin = {
      Unit = {
        Description = "Sendspin audio player";
        Documentation = [ "https://github.com/Sendspin/sendspin-python-cli" ];
        After = [ cfg.systemdTarget ];
        PartOf = [ cfg.systemdTarget ];
      };
      Service = {
        ExecStart = escapeExecArgs (
          [
            (lib.getExe' cfg.package "sendspin")
            "daemon"
          ]
          ++ cfg.extraArgs
        );
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ cfg.systemdTarget ];
    };
  };
}
