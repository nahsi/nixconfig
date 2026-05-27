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

  age.secrets = {
    bidpointBidpoint = {
      file = secrets/bidpoint-bidpoint.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  age.secrets = {
    bidpointAnsibleVault = {
      file = secrets/bidpoint-ansible-vault.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  environment.variables = {
    BIDPOINT_SECRETS_infra = "${config.age.secrets.bidpointInfra.path}";
    BIDPOINT_SECRETS_bidpoint = "${config.age.secrets.bidpointInfra.path}";
  };
}
