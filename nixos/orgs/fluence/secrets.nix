{ config, ... }:
{
  age.secrets = {
    fluence = {
      file = secrets/fluence.age;
      owner = config.users.users.nahsi.name;
      group = config.users.users.nahsi.group;
      mode = "400";
    };

    sshFluence = {
      file = secrets/ssh/fluence.age;
      path = "${config.users.users.nahsi.home}/.ssh/fluence/id_rsa";
      owner = config.users.users.nahsi.name;
      group = config.users.users.nahsi.group;
      mode = "400";
    };

    vaultAgentFluenceRoleId = {
      file = secrets/vault-agent/role_id.age;
      owner = config.services.vault-agent.instances.fluence.user;
      group = config.services.vault-agent.instances.fluence.group;
      mode = "400";
    };
    vaultAgentFluenceSecretId = {
      file = secrets/vault-agent/secret_id.age;
      owner = config.services.vault-agent.instances.fluence.user;
      group = config.services.vault-agent.instances.fluence.group;
      mode = "400";
    };
  };

  environment.variables = {
    FLUENCE_SECRETS = "${config.age.secrets.fluence.path}";
  };
}
