{ config, ... }:
{
  age.secrets = {
    nahsilabs = {
      file = secrets/nahsilabs.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  environment.variables = {
    NAHSILABS_SECRETS = "${config.age.secrets.nahsilabs.path}";
  };
}
