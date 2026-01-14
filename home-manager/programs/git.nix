{
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    aliases = {
      c = "commit";
      ci = "commit";
      co = "checkout";
      s = "status";
    };
    settings = {
      push = {
        autoSetupRemote = true;
      };
      user = {
        name = "nahsi";
        email = "nahsi@nahsi.dev";
      };
    };
  };
}
