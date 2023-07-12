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
        terraform_approle_id = "90879367-35b0-0520-86c2-de2f051265bc";
      };
      consul = {
        CONSUL_ADDR = "http://10.10.0.10:8500";
        consul_domain = "dc1.consul";
        # default_token_id = "383b5a9e-1ab4-45fd-82e8-736e57c6f10c";
        default_token_id = "00000000-0000-0000-0000-000000000002";
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
