{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.programs.tern;
  jsonFormat = pkgs.formats.json { };
  settingsPath = "${config.xdg.configHome}/tern/settings.json";
in
{
  options.programs.tern = {
    enable = lib.mkEnableOption "Tern, Stencil's terminal workspace";

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.self.packages.${system}.tern;
    };

    settings = lib.mkOption {
      inherit (jsonFormat) type;
      default = { };
      example = {
        native_prompt = false;
        font_family = "JetBrains Mono";
        keybinds."ctrl+shift+t" = "new_tab";
      };
      description = ''
        Keys merged into `$XDG_CONFIG_HOME/tern/settings.json` on activation.
        Tern rewrites that file by rename on every save and keeps runtime
        state in it, so it stays writable: declared keys win at each
        activation, objects merge recursively, lists and scalars are
        replaced, and every other key is left to Tern. A running Tern picks
        the merged file up on its next launch or `reload_config`.
      '';
    };

    themes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.lines lib.types.path);
      default = { };
      example = {
        campfire = ''
          @import "gruvbox";
          :root { --background: #1d2021; }
        '';
      };
      description = "CSS themes written to `$XDG_CONFIG_HOME/tern/themes/<name>.css`.";
    };

    plugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = ''
        Plugin packages linked to `$XDG_CONFIG_HOME/tern/plugins/<id>`, each a
        directory holding `plugin.toml`. The attribute name must match the
        manifest's `id`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "programs.tern" pkgs lib.platforms.linux)
    ];

    home.packages = [ cfg.package ];

    xdg.configFile =
      lib.mapAttrs' (
        name: theme:
        lib.nameValuePair "tern/themes/${name}.css" (
          if builtins.isPath theme || lib.isStorePath theme then { source = theme; } else { text = theme; }
        )
      ) cfg.themes
      // lib.mapAttrs' (
        id: source: lib.nameValuePair "tern/plugins/${id}" { inherit source; }
      ) cfg.plugins;

    home.activation.ternSettings = lib.mkIf (cfg.settings != { }) (
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        settings=${lib.escapeShellArg settingsPath}
        declared=${jsonFormat.generate "tern-settings.json" cfg.settings}
        run mkdir -p "$(dirname "$settings")"
        if [[ -s $settings ]]; then
          merged=$(${lib.getExe pkgs.jq} -s '.[0] * .[1]' "$settings" "$declared")
        else
          merged=$(<"$declared")
        fi
        if [[ -v DRY_RUN ]]; then
          verboseEcho "Would merge $declared into $settings"
        else
          printf '%s\n' "$merged" > "$settings.hm-tmp"
          mv "$settings.hm-tmp" "$settings"
        fi
        unset settings declared merged
      ''
    );
  };
}
