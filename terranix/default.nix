{ inputs, pkgs, ... }:
let
  inherit (inputs) terranix nix-nomad microvm self;

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

  system = "x86_64-linux";
  # nomad_jobs = nix-nomad.lib.mkNomadJobs {
  #   inherit system;
  #   config = [ ./nomad/nginx.nix ];
  # };

  terraform = pkgs.terraform.withPlugins
    (p: [ p.local p.remote p.consul p.vault p.nomad ]);

  terraformConfiguration = terranix.lib.terranixConfiguration {
    inherit system;
    extraArgs = {
      inherit self x microvm nix-nomad
        # nomad_jobs
      ;
    };
    modules = [
      ./backend.nix
      ./providers
      ./vault
      ./consul.nix
      # ./nomad
    ];
  };

in {

  # TODO: write files in terranix folder
  # nix run ".#apply"
  apply = toString (pkgs.writers.writeBash "apply" ''
    if [[ -e ./config.tf.json ]]; then rm -f ./config.tf.json; fi
    cp ${terraformConfiguration} ./config.tf.json \
      && ${terraform}/bin/terraform init \
      && ${terraform}/bin/terraform apply
  '');
  # nix run ".#destroy"
  destroy = toString (pkgs.writers.writeBash "destroy" ''
    if [[ -e ./config.tf.json ]]; then rm -f ./config.tf.json; fi
    cp ${terraformConfiguration} ./config.tf.json \
      && ${terraform}/bin/terraform init \
      && ${terraform}/bin/terraform destroy
  '');
  # build = toString (pkgs.writers.writeBash "build"
  # "cp -rf ${nomad_jobs}/* ./terranix/nomad/jobs ");

}
