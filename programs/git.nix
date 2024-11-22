{
  programs.gh.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "nahsi";
    userEmail = "nahsi@nahsi.dev";
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
    aliases = {
      c = "commit";
      ci = "commit";
      co = "checkout";
      s = "status";
    };
  };
}
