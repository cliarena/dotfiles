{ ... }: {
  _module.args = rec {
    DOMAIN = "cliarena.com";
    CONSUL_ADDR = "https://consul.${DOMAIN}";
    VAULT_ADDR = "https://vault.${DOMAIN}";
    agent_certs_dir = "/srv/consul/agent-certs/";
    CONSUL = {
      ca_file = "${agent_certs_dir}/ca.crt";
      cert_file = "${agent_certs_dir}/agent.crt";
      key_file = "${agent_certs_dir}/agent.key";
    };
  };

  imports = [
    ./acme.nix
    ./cloudflare-dyndns.nix
    ./consul.nix
    ./vault.nix
    ./nomad.nix
    ./vault_initializer.nix
    ./consul_template.nix
  ];
}
