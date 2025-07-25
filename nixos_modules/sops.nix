{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  module = "_sops_hosting";
  description = "secrets for hosting profile";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) sops-nix;
in {
  imports = [sops-nix.nixosModules.sops];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    sops = {
      defaultSopsFile = ../secrets/default.yaml;
      age.keyFile = "/srv/secrets/SOPS_AGE_KEY";
      age.sshKeyPaths =
        pkgs.lib.mkForce []; # Must set to empty list for age heyfile to work
      gnupg.sshKeyPaths =
        pkgs.lib.mkForce []; # Must set to empty list for age heyfile to work

      secrets = {
        ACME_VAULT_CERT_CREDENTIALS = {};
        CLOUDFLARE_API_TOKEN = {};
        VICTORIA_METRICS_VAULT_TOKEN = {
          # owner = config.users.groups.vmagent.name;
          # group = config.users.groups.vmagent.name;
        };

        "NOMAD_GOSSIP_ENCRYPTION_KEY.hcl" = {};

        # VAULT_ROOT_TOKEN = { sopsFile = ../../secrets/vault.yaml; };

        CONSUL_HTTP_TOKEN = {sopsFile = ../secrets/consul.yaml;};
        "CONSUL_GOSSIP_ENCRYPTION_KEY.hcl" = {
          owner = config.users.groups.consul.name;
          group = config.users.groups.consul.name;
          sopsFile = ../secrets/consul.yaml;
        };
        "CONSUL_ACL_INITIAL_MANAGEMENT_TOKEN.hcl" = {
          owner = config.users.groups.consul.name;
          group = config.users.groups.consul.name;
          sopsFile = ../secrets/consul.yaml;
        };
        CONSUL_VAULT_ROLE_ID = {
          owner = config.users.groups.consul.name;
          group = config.users.groups.consul.name;
          sopsFile = ../secrets/consul.yaml;
        };
        CONSUL_VAULT_SECRET_ID = {
          owner = config.users.groups.consul.name;
          group = config.users.groups.consul.name;
          sopsFile = ../secrets/consul.yaml;
        };
        # CONSUL_ACL_DEFAULT_TOKEN = { };

        # SURREALDB_USER = { };
        # SURREALDB_PASSWORD = { };
      };
    };
  };
}
