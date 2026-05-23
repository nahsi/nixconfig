{ config, ... }:
{
  age.secrets = {
    bidpointInfra = {
      file = secrets/bidpoint-infra.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  environment.variables = {
    BIDPOINT_SECRETS_infra = "${config.age.secrets.bidpointInfra.path}";
  };
}
