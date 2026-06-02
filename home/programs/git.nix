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
    settings = {
      push = {
        autoSetupRemote = true;
      };
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
    };
  };
}
