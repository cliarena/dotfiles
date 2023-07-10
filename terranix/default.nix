{ inputs, forAllSystems, ... }:
forAllSystems (system:
  let
    inherit (inputs) nixpkgs terranix nix-nomad;
    pkgs = import nixpkgs { inherit system; };

    x = {
      time = rec {
        minute = 60;
        hour = 60 * minute;
        day = 24 * hour;
        year = 365 * day;
      };
      host_name = "svr";
      vault = {
        VAULT_ADDR = "https://vault.cliarena.com";
        terraform_approle_id = "";
      };
      consul = {
        CONSUL_ADDR = "http://10.10.0.2:8500";
        consul_domain = "dc1.consul";
        dns_token_id = "";
      };
      nomad = { NOMAD_ADDR = "http://10.10.0.2:4646"; };
    };

    terraform = pkgs.terraform.withPlugins
      (p: [ p.local p.remote p.consul p.vault p.nomad ]);

    terraformConfiguration = terranix.lib.terranixConfiguration {
      inherit system;
      extraArgs = { inherit x; };
      modules = [
        ./backend.nix
        ./providers
        ./vault
        ./consul.nix
        (import ./modules { inherit pkgs nix-nomad; })
      ];
    };

  in {
    # TODO: write files in terranix folder
    # nix run ".#apply"
    apply = {
      type = "app";
      program = toString (pkgs.writers.writeBash "apply" ''
        if [[ -e ./config.tf.json ]]; then rm -f ./config.tf.json; fi
        cp ${terraformConfiguration} ./config.tf.json \
          && ${terraform}/bin/terraform init \
          && ${terraform}/bin/terraform apply
      '');
    };
    # nix run ".#destroy"
    destroy = {
      type = "app";
      program = toString (pkgs.writers.writeBash "destroy" ''
        if [[ -e ./config.tf.json ]]; then rm -f ./config.tf.json; fi
        cp ${terraformConfiguration} ./config.tf.json \
          && ${terraform}/bin/terraform init \
          && ${terraform}/bin/terraform destroy
      '');
    };
  })
