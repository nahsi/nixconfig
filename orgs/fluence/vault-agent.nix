{ config, ... }:
let
  pki = {
    ca_cert = "/var/lib/certs/fluence/ca.pem";
    cert = "/var/lib/certs/fluence/cert.pem";
    key = "/var/lib/certs/fluence/key.pem";
  };
in
{
  services.vault-agent.instances.fluence = {
    enable = true;
    settings = {
      vault.address = "https://vault.fluence.dev";
      template = [
        {
          destination = pki.ca_cert;
          perms = "0400";
          uid = config.users.users.nahsi.uid;
          contents = ''
            {{- with secret "pki/issue/internal" "ttl=30d" "common_name=framework.node.consul" -}}
            {{ .Data.issuing_ca }}{{ end }}
          '';
        }
        {
          destination = pki.cert;
          perms = "0400";
          uid = config.users.users.nahsi.uid;
          contents = ''
            {{- with secret "pki/issue/internal" "ttl=30d" "common_name=framework.node.consul" -}}
            {{ .Data.certificate }}{{ end }}
          '';
        }
        {
          destination = pki.key;
          perms = "0400";
          uid = config.users.users.nahsi.uid;
          contents = ''
            {{- with secret "pki/issue/internal" "ttl=30d" "common_name=framework.node.consul" -}}
            {{ .Data.private_key }}{{ end }}
          '';
        }
      ];
      auto_auth = {
        method = [
          {
            type = "approle";
            config = {
              role_id_file_path = "${config.age.secrets.vaultAgentFluenceRoleId.path}";
              secret_id_file_path = "${config.age.secrets.vaultAgentFluenceSecretId.path}";
              remove_secret_id_file_after_reading = false;
            };
          }
        ];
      };
    };
  };
  environment.variables = {
    FLUENCE_PKI_CA_CERT_PATH = "${pki.ca_cert}";
    FLUENCE_PKI_CERT_PATH = "${pki.cert}";
    FLUENCE_PKI_KEY_PATH = "${pki.key}";
  };
}
