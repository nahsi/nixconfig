{ config, ... }:
{
  age.secrets = {
    fluence = {
      file = ../secrets/fluence.age;
      owner = config.users.users.nahsi.name;
      group = config.users.users.nahsi.group;
      mode = "400";
    };
  };

  environment.variables = {
    FLUENCE_SECRETS = "${config.age.secrets.fluence.path}";
  };
}
