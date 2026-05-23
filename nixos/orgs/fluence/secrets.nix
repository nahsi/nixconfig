{ config, ... }:
{
  age.secrets = {
    fluence = {
      file = secrets/fluence.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };

    sshFluence = {
      file = secrets/ssh/fluence.age;
      path = "${config.users.users.nahsi.home}/.ssh/fluence/id_rsa";
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  environment.variables = {
    FLUENCE_SECRETS = "${config.age.secrets.fluence.path}";
  };
}
