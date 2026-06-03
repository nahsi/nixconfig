{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.programs.ferrosonic;
  localPkgs = inputs.self.packages.${system};
in
{
  options.programs.ferrosonic = {
    enable = lib.mkEnableOption "Ferrosonic Subsonic TUI client";

    package = lib.mkOption {
      type = lib.types.package;
      default = localPkgs.ferrosonic-ng;
    };

    # TODO: declarative config — `settings` for ~/.config/ferrosonic/config.toml
    # and `themes` for ~/.config/ferrosonic/themes/*.toml. Credentials (BaseURL /
    # Username / Password) must come from ragenix, not the store.
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.cava
    ];
  };
}
