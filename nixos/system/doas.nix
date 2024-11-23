{
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = [ "nahsi" ];
      keepEnv = true;
      noPass = true;
    }
  ];
}
