{ config, CONSUL, ... }: {
  services.consul = {
    enable = true;
    webUi = true;
    dropPrivileges = false;
    interface = {
      bind = "wan";
      advertise = "wan";
    };
    extraConfigFiles = [
      config.sops.secrets."CONSUL_GOSSIP_ENCRYPTION_KEY.hcl".path
      config.sops.secrets."CONSUL_ACL_INITIAL_MANAGEMENT_TOKEN.hcl".path
    ];
    extraConfig = {
      server = true;
      bootstrap_expect = 1; # for demo; no fault tolerance
      client_addr = "0.0.0.0";
      data_dir = "/srv/consul/data";

      encrypt_verify_incoming = true;
      encrypt_verify_outgoing = true;

      # TLS Encryption
      tls = {
        defaults = {
          inherit (CONSUL) ca_file cert_file key_file;
          verify_incoming = true;
          verify_outgoing = true;
        };
        internal_rpc = { verify_server_hostname = true; };
      };
      auto_encrypt = { allow_tls = true; };

      ports = {
        grpc_tls =
          8503; # recommended port number for compatibility with other tools
      };

      dns_config = {
        node_ttl = "10s";
        service_ttl = {
          "*" = "5s";
          "web*" = "30s";
          "db*" = "10s";
          "db-master" = "3s";
        };
      };

      acl = {
        enabled = true;
        default_policy = "deny";
        enable_token_persistence = true;
        # bootstraped using sops secret file see above
      };

      connect = {
        enabled = true;
        #     # ca_provider = "vault";
        #     # ca_config = {
        #     #   address = "http://0.0.0.0:8200";
        #     #   token = "<vault-token-with-necessary-policy>";
        #     #   root_pki_path = "connect-root";
        #     #   intermediate_pki_path = "connect-dc1-intermediate";
        #     # };
      };

      config_entries = {
        bootstrap = [{
          kind = "proxy-defaults";
          name = "global";
          config = { protocol = "http"; };
        }];
      };
    };
  };
}
