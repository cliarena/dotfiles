{ config, CONSUL, VAULT_ADDR, ... }: {
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
        # grpc = 8502;
        https = 8501;
        # 8503: recommended port number for compatibility with other tools
        grpc_tls = 8503;
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
        ca_provider = "vault";
        ca_config = {
          address = VAULT_ADDR;
          # token = "<vault-token-with-necessary-policy>";
          auth_method = {
            type = "approle";
            mount_path = "approle";
            params = {
              role_id_file_path = config.sops.secrets.CONSUL_VAULT_ROLE_ID.path;
              secret_id_file_path =
                config.sops.secrets.CONSUL_VAULT_SECRET_ID.path;
            };
          };
          root_pki_path = "pki";
          intermediate_pki_path = "pki_int";
        };
      };

      config_entries = {
        bootstrap = [
          {
            kind = "proxy-defaults";
            name = "global";
            config = { protocol = "http"; };
          }
          {
            name = "cliarena_gateway";
            kind = "api_gateway";

            listeners = [{
              port = 8443;
              name = "cliarena-http-listener";
              protocol = "http";
              # tls = {
              # certificates = [{
              # kind = "inline-certificate";
              # name = "cliarena_cert";
              # }];
              # };
            }];
          }
          {
            name = "cliarena_http_routes";
            kind = "http-route";

            rules = [
              {
                matches = [{
                  path = {
                    match = "prefix";
                    value = "/";
                  };
                }];
                services = [
                  {
                    name = "ui";
                    weight = 90;
                  }
                  {
                    name = "experimental-ui";
                    weight = 10;
                  }
                ];
              }
              {
                matches = [{
                  path = {
                    match = "prefix";
                    value = "/nginx";
                  };
                }];
                services = [{ name = "nginx"; }];
              }
            ];

            parents = [{
              kind = "api-gateway";
              name = "cliarena_gateway";
              # section_name = "my-http-listener";
            }];

          }
        ];
      };
    };
  };
}
