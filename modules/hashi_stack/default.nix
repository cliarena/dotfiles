{ ... }: {
  _module.args = rec {
    system = "x86_64-linux";
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

    envoy_nixpkgs = import (builtins.fetchGit {

      # NOTE: consul supports envoy version which is 0.7 to 0.10 higher
      # EXAMPLE: consul 1.19.x supports envoy 1.29.x

      # Use https://lazamar.co.uk/nix-versions/ to find nixpkgs revisions

      # Descriptive name to make the store path easier to identify
      name = "envoy-1.27.3";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "e89cf1c932006531f454de7d652163a9a5c86668";
    }) {
      inherit system;
      config.allowUnfree = true;
    };
  };

  imports = [
    # ../podman.nix
    ./consul
    ./vault
    ./envoy.nix
    # ./consul_template.nix
  ];
}
