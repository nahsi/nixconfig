{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  package = import ./package.nix {
    upstream = inputs.led-matrix-monitoring.packages.${system}.default;
  };
  yaml = pkgs.formats.yaml { };
  configFile = "${config.xdg.configHome}/led-matrix/config.yaml";
in
{
  home.packages = [ package ];

  xdg.configFile."led-matrix/config.yaml".source = yaml.generate "led-matrix-config.yaml" {
    duration = 10;
    quadrants = {
      top-left = [
        {
          app = null;
          name = "cpu";
        }
      ];
      bottom-left = [
        {
          app = null;
          name = "mem-bat";
        }
      ];
      top-right = [
        {
          app = null;
          name = "omp-context";
          scope = "panel";
        }
      ];
      bottom-right = [
        {
          app = null;
          name = "net";
          display = false;
        }
      ];
    };
  };

  systemd.user.services.led-matrix-monitoring = {
    Unit = {
      Description = "Framework LED Matrix system monitor";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      # Only omp_context_plugin.py is packaged; never listen to raw keyboard devices.
      ExecStart = "${lib.getExe package} --no-key-listener --config-file ${lib.escapeShellArg configFile}";
      RuntimeDirectory = "led-matrix";
      RuntimeDirectoryMode = "0700";
      UMask = "0077";
      Environment = [ "LOG_LEVEL=info" ];
      # Upstream exits successfully when no panels are present; retry on reconnect.
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
