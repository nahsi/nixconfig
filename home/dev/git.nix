{
  programs.gh.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      ".codebase-memory"
      ".omp/"
      ".scratch/"
      ".teach/"
      "AGENTS.md"
      "AGENTS.local.md"
      "CLAUDE.md"
      "CLAUDE.local.md"
      "CONTEXT.md"
      "NOTES.md"
      "docs/adr/"
      "docs/agents/"
      "tickets.md"
    ];
    settings = {
      user = {
        name = "nahsi";
        email = "git@nahsi.dev";
      };
      alias = {
        c = "commit";
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      init.defaultBranch = "main";
      fetch.prune = true;
      push.autoSetupRemote = true;
      merge.conflictStyle = "zdiff3";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      diff.algorithm = "histogram";
      commit.verbose = true;
    };
  };
}
