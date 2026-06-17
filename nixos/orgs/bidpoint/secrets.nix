{ config, ... }:
{
  age.secrets = {
    bidpointInfra = {
      file = secrets/bidpoint-infra.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };

    bidpointStaging = {
      file = secrets/bidpoint-staging.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };

    bidpointProduction = {
      file = secrets/bidpoint-production.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };

    bidpointBidpoint = {
      file = secrets/bidpoint-bidpoint.age;
      owner = config.users.users.nahsi.name;
      inherit (config.users.users.nahsi) group;
      mode = "400";
    };
  };

  environment.variables = {
    BIDPOINT_SECRETS_infra = "${config.age.secrets.bidpointInfra.path}";
    BIDPOINT_SECRETS_staging = "${config.age.secrets.bidpointStaging.path}";
    BIDPOINT_SECRETS_production = "${config.age.secrets.bidpointProduction.path}";
    BIDPOINT_SECRETS_bidpoint = "${config.age.secrets.bidpointBidpoint.path}";
  };
}
