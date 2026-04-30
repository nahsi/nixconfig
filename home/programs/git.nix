{
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      push = {
        autoSetupRemote = true;
      };
      user = {
        name = "nahsi";
        email = "nahsi@nahsi.dev";
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
