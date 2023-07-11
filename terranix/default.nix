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
        terraform_approle_id = "3a7b90e4-e26f-501f-09a4-ee17de56bdbd";
      };
      consul = {
        CONSUL_ADDR = "http://10.10.0.10:8500";
        consul_domain = "dc1.consul";
        dns_token_id = "";
      };
      nomad = { NOMAD_ADDR = "http://10.10.0.10:4646"; };
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
        (import ./nomad { inherit nix-nomad; })
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
