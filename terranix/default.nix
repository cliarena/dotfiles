{ inputs, forAllSystems, ... }:
forAllSystems (system:
  let
    inherit (inputs) nixpkgs terranix nix-nomad;
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    x = {
      time = rec {
        minute = 60;
        hour = 60 * minute;
        day = 24 * hour;
        year = 365 * day;
      };
      host_name = "svr";
      vault = {
        VAULT_ADDR = "https://vault.cliarena.com:8200";
        # VAULT_ADDR = "http://10.10.0.10:8200";
        terraform_approle_id = "d3ba0e3b-d7d9-6484-2328-661505806d34";
      };
      consul = {
        CONSUL_ADDR = "http://10.10.0.10:8500";
        consul_domain = "dc1.consul";
        # default_token_id = "383b5a9e-1ab4-45fd-82e8-736e57c6f10c";
        default_token_id = "00000000-0000-0000-0000-000000000002";
      };
      nomad = {
        NOMAD_ADDR = "http://10.10.0.10:4646";
        domain = "global.nomad";
      };
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
