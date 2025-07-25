{
  config,
  x,
  ...
}: let
  inherit (config.resource) consul_acl_role;
  inherit (x) host_name consul;

  dns_policies = {
    base = {
      # fixes DNS error and enable consul-template to write certs
      agent.${host_name} = {policy = "write";};
      # fixes DNS agent: Coordinate update warning
      node.${host_name} = {policy = "write";};
    };
    consul_template = {
      # reload consul for consul-template to work
      agent.${host_name} = {policy = "write";};
    };
    nomad = {
      service = {
        vault.policy = "write";
        nomad.policy = "write";
        nomad-client.policy = "write";
        nomad-gateway.policy = "write";
        cliarena-gateway.policy = "write";
        kasm.policy = "write";
        nginx.policy = "write";
        nginx-sidecar-proxy.policy = "write";
        echo.policy = "write";
        echo-sidecar-proxy.policy = "write";
        wolf.policy = "write";
        microvm.policy = "write";
        microvm-sidecar-proxy.policy = "write";
        count-api.policy = "write";
        count-api-sidecar-proxy.policy = "write";
        count-dashboard.policy = "write";
        count-dashboard-sidecar-proxy.policy = "write";
      };
      # facilitate cross-Consul datacenter requests of Connect services registered by Nomad
      agent_prefix."" = {policy = "read";};
      service_prefix."" = {policy = "read";};
      node_prefix."" = {policy = "read";};
      acl = "write";
      mesh = "write";
    };
  };
in {
  resource.consul_acl_policy = {
    dns_base_policy = {
      name = "dns_base_policy";
      rules = builtins.toJSON dns_policies.base;
    };
    dns_consul_template_policy = {
      name = "dns_consul_template_policy";
      rules = builtins.toJSON dns_policies.consul_template;
    };
    dns_nomad_policy = {
      name = "dns_nomad_policy";
      rules = builtins.toJSON dns_policies.nomad;
    };
  };

  resource.consul_acl_role.dns_role = {
    name = "dns_role";
    description = "DNS role";

    policies = [
      "\${consul_acl_policy.dns_base_policy.id}"
      "\${consul_acl_policy.dns_consul_template_policy.id}"
      "\${consul_acl_policy.dns_nomad_policy.id}"
    ];
  };

  # resource.consul_acl_token.dns_token = {
  # accessor_id = config.sops.secrets."CONSUL_ACL_DEFAULT_TOKEN".path;
  # description = "DNS Token";
  # roles = [ consul_acl_role.dns_role.name ];
  # };

  resource.consul_acl_token_role_attachment.default_token_dns_role_attachement = {
    depends_on = ["consul_acl_role.dns_role"];
    token_id = consul.default_token_id;
    # token_id = config.sops.secrets."CONSUL_ACL_DEFAULT_TOKEN".path;
    role = consul_acl_role.dns_role.name;
  };

  # Service Mesh
  resource.consul_config_entry.proxy_defaults = {
    kind = "proxy-defaults";
    name = "global";
    config_json = builtins.toJSON {
      config = {
        protocol = "http";
        envoy_prometheus_bind_addr = "0.0.0.0:8484";
      };
    };
  };

  resource.consul_config_entry.cliarena_cert = {
    kind = "inline-certificate";
    name = "cliarena-cert";
    config_json = builtins.toJSON {
      certificate = builtins.readFile /var/lib/acme/cliarena.com/cert.pem;
      privateKey = builtins.readFile /var/lib/acme/cliarena.com/key.pem;
    };
  };

  resource.consul_config_entry.cliarena_gateway = {
    kind = "api-gateway";
    name = "cliarena-gateway";
    config_json = builtins.toJSON {
      listeners = [
        {
          port = 443;
          name = "cliarena-http-listener";
          protocol = "http";
          tls = {
            certificates = [
              {
                kind = "inline-certificate";
                name = "cliarena-cert";
              }
            ];
          };
        }
      ];
    };
  };

  resource.consul_config_entry.nomad_gateway = {
    name = "nomad-gateway";
    kind = "terminating-gateway";

    config_json = builtins.toJSON {services = {name = "nomad";};};
  };

  resource.consul_config_entry.nginx_intentions = {
    name = "nginx";
    kind = "service-intentions";

    config_json = builtins.toJSON {
      sources = {
        name = config.resource.consul_config_entry.cliarena_gateway.name;
        type = "consul";
        action = "allow";
      };
    };
  };
  resource.consul_config_entry.echo_intentions = {
    name = "echo";
    kind = "service-intentions";

    config_json = builtins.toJSON {
      sources = {
        name = config.resource.consul_config_entry.cliarena_gateway.name;
        type = "consul";
        action = "allow";
      };
    };
  };
  resource.consul_config_entry.nomad_intentions = {
    name = "nomad";
    kind = "service-intentions";

    config_json = builtins.toJSON {
      sources = [
        {
          name = config.resource.consul_config_entry.cliarena_gateway.name;
          type = "consul";
          action = "allow";
        }
        {
          name = config.resource.consul_config_entry.nomad_gateway.name;
          type = "consul";
          action = "allow";
        }
      ];
    };
  };
  # resource.consul_config_entry.nomad_gateway_to_nomad_intentions = {
  #   name = "nomad-gateway";
  #   kind = "service-intentions";
  #
  #   config_json = builtins.toJSON {
  #     sources = {
  #       name = config.resource.consul_config_entry.nomad_intentions.name;
  #       # name = config.resource.consul_config_entry.nomad_client_gateway.name;
  #       type = "consul";
  #       action = "allow";
  #     };
  #   };
  # };
  resource.consul_config_entry.nomad_gateway_intentions = {
    name = "nomad-gateway";
    kind = "service-intentions";

    config_json = builtins.toJSON {
      sources = [
        {
          name = config.resource.consul_config_entry.cliarena_gateway.name;
          type = "consul";
          action = "allow";
        }
        {
          name = config.resource.consul_config_entry.nomad_intentions.name;
          type = "consul";
          action = "allow";
        }
      ];
    };
  };
  resource.consul_config_entry.microvm_intentions = {
    name = "microvm";
    kind = "service-intentions";

    config_json = builtins.toJSON {
      sources = {
        name = config.resource.consul_config_entry.cliarena_gateway.name;
        type = "consul";
        action = "allow";
      };
    };
  };

  resource.consul_config_entry.cliarena_http_routes = {
    name = "cliarena-http-routes";
    kind = "http-route";
    config_json = builtins.toJSON {
      rules = [
        {
          matches = [
            {
              path = {
                match = "prefix";
                value = "/";
              };
            }
          ];
          filters = {
            headers = [
              {
                add = {
                  X-Forwarded-For = "%DOWNSTREAM_REMOTE_ADDRESS_WITHOUT_PORT%";
                };
              }
            ];
            TimeoutFilter = {
              IdleTimeout = 500000000000;
              RequestTimeout = 500000000000;
            };
          };
          services = [{name = "nomad";}];
          # services = [{ name = "nomad-client-gateway"; }];
        }
        {
          matches = [
            {
              path = {
                match = "prefix";
                value = "/echo";
              };
            }
          ];
          services = [{name = "echo";}];
        }
      ];
      parents = [
        {
          inherit
            (config.resource.consul_config_entry.cliarena_gateway)
            kind
            name
            ;
          sectionName = "cliarena-http-listener";
        }
      ];
    };
  };
}
