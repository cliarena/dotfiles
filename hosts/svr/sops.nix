{ config, ... }: {
  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = ../../secrets/age.key;

    secrets = {
      ACME_VAULT_CERT_CREDENTIALS = { };
      CLOUDFLARE_API_TOKEN = { };

      "NOMAD_GOSSIP_ENCRYPTION_KEY.hcl" = { };

      VAULT_ROOT_TOKEN = { sopsFile = ../../secrets/vault.yaml; };

      CONSUL_HTTP_TOKEN = { sopsFile = ../../secrets/consul.yaml; };
      "CONSUL_GOSSIP_ENCRYPTION_KEY.hcl" = {
        owner = config.users.groups.consul.name;
        group = config.users.groups.consul.name;
        sopsFile = ../../secrets/consul.yaml;
      };
      "CONSUL_ACL_INITIAL_MANAGEMENT_TOKEN.hcl" = {
        owner = config.users.groups.consul.name;
        group = config.users.groups.consul.name;
        sopsFile = ../../secrets/consul.yaml;
      };
      # CONSUL_ACL_DEFAULT_TOKEN = { };

      # SURREALDB_USER = { };
      # SURREALDB_PASSWORD = { };

    };
  };
}
