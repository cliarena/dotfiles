{ config, x, ... }:
let
  inherit (config.resource) consul_acl_role;
  inherit (x) host_name consul;

  dns_policies = {
    base = {
      # fixes DNS error and enable consul-template to write certs
      agent.${host_name} = { policy = "write"; };
      # fixes DNS agent: Coordinate update warning
      node.${host_name} = { policy = "write"; };

    };
    consul_template = {
      # reload consul for consul-template to work
      agent.${host_name} = { policy = "write"; };
    };
    nomad = {
      service = {
        vault.policy = "write";
        nomad.policy = "write";
        nomad-client.policy = "write";
        kasm.policy = "write";
        nginx.policy = "write";
        nginx-sidecar-proxy.policy = "write";
        count-api.policy = "write";
        count-api-sidecar-proxy.policy = "write";
        count-dashboard.policy = "write";
        count-dashboard-sidecar-proxy.policy = "write";
      };
      # facilitate cross-Consul datacenter requests of Connect services registered by Nomad
      agent_prefix."" = { policy = "read"; };
      service_prefix."" = { policy = "read"; };
      node_prefix."" = { policy = "read"; };
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

  resource.consul_acl_token_role_attachment.default_token_dns_role_attachement =
    {
      depends_on = [ "consul_acl_role.dns_role" ];
      token_id = consul.default_token_id;
      # token_id = config.sops.secrets."CONSUL_ACL_DEFAULT_TOKEN".path;
      role = consul_acl_role.dns_role.name;
    };
}
