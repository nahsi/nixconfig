{ config, ... }:
{
  age.secrets = {
    nahsilabs = {
      file = secrets/nahsilabs.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
    singbox = {
      file = secrets/singbox.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
    mail-personal-password = {
      file = secrets/mail-personal-password.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
    mail-trash-password = {
      file = secrets/mail-trash-password.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  environment.variables = {
    NAHSILABS_SECRETS = "${config.age.secrets.nahsilabs.path}";
  };
}
