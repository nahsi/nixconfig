{
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "nahsi" ];
          keepEnv = true;
          noPass = true;
        }
      ];
    };
  };
}
