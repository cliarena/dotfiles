{ config, ... }: {
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = ../../secrets/age.key;

    secrets = {
      VAULT_ROOT_TOKEN = { };
      CONSUL_HTTP_TOKEN = { };
      CLOUDFLARE_API_TOKEN = { };
      ACME_VAULT_CERT_CREDENTIALS = { };
      # "CONSUL_GOSSIP_ENCRYPTION_KEY.hcl" = {
      # owner = config.users.groups.consul.name;
      # group = config.users.groups.consul.name;
      # };
      # "CONSUL_ACL_INITIAL_MANAGEMENT_TOKEN.hcl" = {
      # owner = config.users.groups.consul.name;
      # group = config.users.groups.consul.name;
      # };
      # CONSUL_ACL_DEFAULT_TOKEN = { };
      # "NOMAD_GOSSIP_ENCRYPTION_KEY.hcl" = { };
      # SURREALDB_USER = { };
      # SURREALDB_PASSWORD = { };

    };
  };
}
