{ config, CONSUL, VAULT_ADDR, ... }: {
  services.consul = {
    enable = true;
    webUi = true;
    dropPrivileges = false;
    interface = {
      bind = "wan0";
      advertise = "wan0";
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
      ## tls = { 
      ## defaults = { 
      ## inherit (CONSUL) ca_file cert_file key_file; 
      # FIX: nomad consul grpc_ca_file gives bad certificate
      # verify_incoming = true;
      # verify_outgoing = true;
      ##};
      ## internal_rpc = { verify_server_hostname = true; }; 
      ## }; */
      # auto_encrypt = { allow_tls = true; }; 

      ports = {
        grpc = 8502;
        # http = 8500;
        # https = 8501;
        # 8503: recommended port number for compatibility with other tools
        # grpc_tls = 8503;
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

      # acl = {
      # enabled = true;
      # default_policy = "deny";
      # enable_token_persistence = true;
      # # bootstraped using sops secret file see above
      # };

      connect = {
        enabled = true;
        # ca_provider = "vault";
        # ca_config = {
        # address = VAULT_ADDR;
        # # token = "<vault-token-with-necessary-policy>";
        # auth_method = {
        # type = "approle";
        # mount_path = "approle";
        # params = {
        # role_id_file_path = config.sops.secrets.CONSUL_VAULT_ROLE_ID.path;
        # secret_id_file_path =
        # config.sops.secrets.CONSUL_VAULT_SECRET_ID.path;
        # };
        # };
        # root_pki_path = "pki";
        # intermediate_pki_path = "pki_int";
        # };
      };

      config_entries = {
        # if you change or delete any existing entry you need to delete it using `consul config delete -kind http-route -name cliarena_http_routes` and restart consul to take effect
        bootstrap = [
          {
            kind = "proxy-defaults";
            name = "global";
            config = { protocol = "tcp"; };
          }
          {
            name = "cliarena-gateway";
            kind = "api-gateway";
            listeners = [{
              port = 443;
              name = "cliarena-http-listener";
              protocol = "tcp";
              tls = {
                # minVersion = "TLSv1_3";
                # maxVersion = "TLSv1_3";
                certificates = [{
                  kind = "inline-certificate";
                  name = "cliarena-cert";
                }];
              };
            }];
          }
          {
            kind = "inline-certificate";
            name = "cliarena-cert";
            certificate = builtins.readFile /var/lib/acme/cliarena.com/cert.pem;
            privateKey = builtins.readFile /var/lib/acme/cliarena.com/key.pem;
          }
          {
            name = "cliarena-http-routes";
            kind = "http-route";
            rules = [
              # {
              # matches = [{
              # path = {
              # match = "prefix";
              # value = "/";
              # };
              # }];
              # services = [
              # {
              # name = "ui";
              # weight = 90;
              # }
              # {
              # name = "experimental-ui";
              # weight = 10;
              # }
              # ];
              # }
              {
                matches = [{
                  path = {
                    match = "prefix";
                    value = "/";
                  };
                }];
                services = [{ name = "echo"; }];
              }
            ];
            parents = [{
              kind = "api-gateway";
              name = "cliarena-gateway";
              sectionName = "cliarena-http-listener";
            }];
          }
        ];
      };
    };
  };
}
