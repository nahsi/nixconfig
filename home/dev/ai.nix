{
  pkgs,
  inputs,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  programs.mcp = {
    enable = true;
    servers = {
      terraform.command = pkgs.lib.getExe pkgs.terraform-mcp-server;
      nixos.command = pkgs.lib.getExe pkgs.mcp-nixos;
      kubernetes.command = pkgs.lib.getExe inputs.self.packages.${system}.kubernetes-mcp-server;
      flux = {
        command = pkgs.lib.getExe pkgs.fluxcd-operator-mcp;
        args = [ "serve" ];
      };
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      theme = "auto";
      effortLevel = "xhigh";
      remoteControlAtStartup = false;
      includeCoAuthoredBy = false;
      enabledPlugins."rust-analyzer-lsp@claude-plugins-official" = true;

      autoMemoryEnabled = false;

      permissions = {
        allow = [
          # git (read-only)
          "Bash(git status *)"
          "Bash(git diff *)"
          "Bash(git log *)"
          "Bash(git show *)"
          "Bash(git blame *)"
          "Bash(git rev-parse *)"
          "Bash(git remote *)"
          # nix
          "Bash(nix eval *)"
          "Bash(nix flake *)"
          "Bash(nix build *)"
          # view / search
          "Bash(rg *)"
          "Bash(jq *)"
          "Bash(yq *)"
          "Bash(cat *)"
          "Bash(head *)"
          "Bash(tail *)"
          "Bash(ls *)"
          "Bash(pwd)"
          "Bash(wc *)"
          "Bash(sort *)"
          "Bash(which *)"
          "Bash(journalctl *)"
        ];
        deny = [
          "Bash(rm -rf /)"
          "Bash(rm -rf /*)"
          "Bash(sudo *)"
          "Bash(git push *)"
          "Bash(git reset --hard *)"
          "Bash(git clean *)"
          "Bash(git branch -D *)"
        ];
      };

      env = {
        DISABLE_TELEMETRY = "1";
        DISABLE_ERROR_REPORTING = "1";
      };
    };

    context = ''
      # Tools
      - Prefer `rg` over grep, `fd` over find, `sd` over sed.
      - Use `ast-grep` for structural/code search; `jq`/`yq` for JSON/YAML.
      - Prefer built-in Grep/Glob/Read tools over shelling out.

      # Behavior
      - Verify before asserting — read docs/source/`--help`. Don't guess APIs, flags, or options.

      # Comments
      - Comment *why*, not *what*. Never restate code.
      - Only when non-obvious: rationale, trade-off, edge case, workaround, assumption.
      - Prefer clear names over comments. No TODOs (open issue), no commented-out code (use git).
      - Don't write a comment a likely code change would make stale.
    '';

    skills =
      let
        src = inputs.mattpocock-skills;
      in
      {
        # engineering
        diagnose = "${src}/skills/engineering/diagnose";
        zoom-out = "${src}/skills/engineering/zoom-out";
        tdd = "${src}/skills/engineering/tdd";
        # productivity
        grill-me = "${src}/skills/productivity/grill-me";
        handoff = "${src}/skills/productivity/handoff";
        teach = "${src}/skills/productivity/teach";
        caveman = "${src}/skills/productivity/caveman";
        write-a-skill = "${src}/skills/productivity/write-a-skill";
      };

    lspServers.nix = {
      command = pkgs.lib.getExe pkgs.nixd;
      extensionToLanguage.".nix" = "nix";
    };
  };
}
