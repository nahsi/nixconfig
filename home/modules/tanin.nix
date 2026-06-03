{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.programs.tanin;
  toml = pkgs.formats.toml { };
  localPkgs = inputs.self.packages.${system};
in
{
  options.programs.tanin = {
    enable = lib.mkEnableOption "Tanin ambient noise TUI";

    package = lib.mkOption {
      type = lib.types.package;
      default = localPkgs.tanin;
    };

    settings = lib.mkOption {
      inherit (toml) type;
      default = { };
      example = {
        general = {
          hidden_categories = [ "rain" ];
          category_order = [
            "nature"
            "noise"
          ];
        };
      };
      description = "Written to ~/.config/tanin/config.toml.";
    };

    sounds = lib.mkOption {
      inherit (toml) type;
      default = { };
      description = "Written to ~/.config/tanin/sounds.toml.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "tanin/config.toml" = lib.mkIf (cfg.settings != { }) {
        source = toml.generate "tanin-config.toml" cfg.settings;
      };
      "tanin/sounds.toml" = lib.mkIf (cfg.sounds != { }) {
        source = toml.generate "tanin-sounds.toml" cfg.sounds;
      };
    };
  };
}
