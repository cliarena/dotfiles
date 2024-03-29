{ ... }: {
  _module.args = rec {
    DOMAIN = "cliarena.com";
    # CONSUL_ADDR = "https://consul.${DOMAIN}";
    CONSUL_ADDR = "http://10.10.0.10:8500";
    #VAULT_ADDR = "https://vault.${DOMAIN}";
    VAULT_ADDR = "http://10.10.0.10:8200";
    CONSUL = rec {
      agent_certs_dir = "/srv/consul/agent-certs";
      grpc_ca_file = "${agent_certs_dir}/ca.crt";
      ca_file = "${agent_certs_dir}/ca.crt";
      cert_file = "${agent_certs_dir}/agent.crt";
      key_file = "${agent_certs_dir}/agent.key";
    };
    NOMAD = rec {
      agent_certs_dir = "/srv/nomad/agent-certs";
      ca_file = "${agent_certs_dir}/ca.crt";
      cert_file = "${agent_certs_dir}/agent.crt";
      key_file = "${agent_certs_dir}/agent.key";
    };
  };

  imports = [
    ./pdns
    ./acme.nix
    ./cloudflare-dyndns.nix
    # ../podman.nix
    ../docker.nix
    ./consul
    ./vault
    ./nomad.nix
    ./envoy.nix
    ./vault_initializer.nix
    # ./consul_template.nix
  ];
}
