{
  pkgs,
  lib,
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
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
    enableMcpIntegration = true;

    settings = {
      theme = "auto";
      effortLevel = "xhigh";
      remoteControlAtStartup = false;
      includeCoAuthoredBy = false;

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

    lspServers.nix = {
      command = lib.getExe pkgs.nixd;
      extensionToLanguage.".nix" = "nix";
    };
  };
}
