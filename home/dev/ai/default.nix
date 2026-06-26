{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  shared = {
    rules = ''
      # Tools
      - Prefer `rg` over grep, `fd` over find, `sd` over sed.
      - Use `ast-grep` for structural/code search; `jq`/`yq` for JSON/YAML.
      - Prefer built-in Grep/Glob/Read tools over shelling out.

      # Behavior
      - Verify before asserting — read docs/source/`--help`. Don't guess APIs, flags, or options.

      # Comments
      - Default to ZERO comments. Write self-explanatory code, not annotated code.
      - Add a comment ONLY for genuinely non-obvious rationale, trade-off, edge case, workaround, or assumption — never to restate what the code does.
      - Never narrate edits or config values (e.g. "set X to 0", "neutralizes default"). If it's visible in the code, don't comment it.
      - No TODOs (open issue), no commented-out code (use git).
      - Don't write a comment a likely code change would make stale.
    '';

    skills =
      let
        src = inputs.mattpocock-skills;
      in
      {
        diagnose = "${src}/skills/engineering/diagnose";
        zoom-out = "${src}/skills/engineering/zoom-out";
        tdd = "${src}/skills/engineering/tdd";
        grill-me = "${src}/skills/productivity/grill-me";
        handoff = "${src}/skills/productivity/handoff";
        teach = "${src}/skills/productivity/teach";
        caveman = "${src}/skills/productivity/caveman";
        write-a-skill = "${src}/skills/productivity/write-a-skill";
      };

    mcpServers = {
      terraform.command = lib.getExe pkgs.terraform-mcp-server;
      nixos.command = lib.getExe pkgs.mcp-nixos;
    };
  };
in
{
  imports = [
    ./claude.nix
    ./oh-my-pi
  ];

  _module.args.aiShared = shared;

  programs.mcp = {
    enable = true;
    servers = shared.mcpServers;
  };
}
