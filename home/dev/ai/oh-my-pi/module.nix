{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.oh-my-pi;
  yaml = pkgs.formats.yaml { };

  mkAgentFile =
    value: { force = true; } // (if lib.isPath value then { source = value; } else { text = value; });
in
{
  options.programs.oh-my-pi = {
    enable = lib.mkEnableOption "oh-my-pi (omp) coding agent";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The omp package to install.";
    };

    settings = lib.mkOption {
      inherit (yaml) type;
      default = { };
      description = "Written to ~/.omp/agent/config.yml.";
    };

    customProviders = lib.mkOption {
      inherit (yaml) type;
      default = { };
      description = "Written to ~/.omp/agent/models.yml.";
    };

    mcpServers = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Written to ~/.omp/agent/mcp.json.";
    };

    keybindings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Written to ~/.omp/agent/keybindings.json.";
    };

    agentsMd = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Written to ~/.omp/agent/AGENTS.md.";
    };

    rules = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.path lib.types.lines);
      default = { };
      description = "Written to ~/.omp/agent/rules/<name>.md.";
    };

    skills = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.path lib.types.str);
      default = { };
      description = "Symlinked to ~/.omp/agent/skills/<name>/.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file = lib.mkMerge [
      (lib.mkIf (cfg.settings != { }) {
        ".omp/agent/config.yml" = {
          source = yaml.generate "omp-config.yml" cfg.settings;
          force = true;
        };
      })
      (lib.mkIf (cfg.customProviders != { }) {
        ".omp/agent/models.yml" = {
          source = yaml.generate "omp-models.yml" cfg.customProviders;
          force = true;
        };
      })
      (lib.mkIf (cfg.mcpServers != { }) {
        ".omp/agent/mcp.json" = {
          text = builtins.toJSON {
            "$schema" =
              "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json";
            inherit (cfg) mcpServers;
          };
          force = true;
        };
      })
      (lib.mkIf (cfg.keybindings != { }) {
        ".omp/agent/keybindings.json" = {
          text = builtins.toJSON cfg.keybindings;
          force = true;
        };
      })
      (lib.mkIf (cfg.agentsMd != null) {
        ".omp/agent/AGENTS.md" = {
          text = cfg.agentsMd;
          force = true;
        };
      })
      (lib.mapAttrs' (
        name: value: lib.nameValuePair ".omp/agent/rules/${name}.md" (mkAgentFile value)
      ) cfg.rules)
      (lib.mapAttrs' (
        name: src:
        lib.nameValuePair ".omp/agent/skills/${name}" {
          source = src;
          force = true;
        }
      ) cfg.skills)
    ];
  };
}
