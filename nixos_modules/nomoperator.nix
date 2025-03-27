{ config, lib, inputs, pkgs, ... }:
let
  module = "_nomoperator";
  description = "nomad gitops operator";
  inherit (lib) mkEnableOption mkIf;

  nomoperator = pkgs.buildGoModule {
    pname = "nomoperator";
    version = "0.1.2";
    vendorHash = "sha256-p4MAPHh/mUjN4KANc1OtGRMOv897ISfeVM3IPc7rcYs=";
    src = pkgs.fetchFromGitHub {
      owner = "jonasvinther";
      repo = "nomad-gitops-operator";
      rev = "4d852f7ba1ed1404ca3d1836685c49fabed7c00c";
      hash = "sha256-opUHc5mbHxMZn2r1fq3n7QOu6vjIvlFrBqOZe/Df6/Q=";
      # hash = lib.fakeHash;
    };
  };
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    systemd.services.nomoperator = {
      enable = true;
      description = "nomad gitops operator";
      # path = with pkgs; [ steam inputs.wolf.packages.x86_64-linux.default ];

      script = ''
        ${nomoperator}/bin/nomad-gitops-operator bootstrap \
           git --url https://gitlab.com/cliarena_dotfiles/nixos.git \
           --branch main \
           --path terranix/nomad/jobs/*.tf \
           --delete  --watch
      '';
      serviceConfig = {
        Restart = "on-failure";
        TimeoutSec = 3;
        # avoid error start request repeated too quickly since RestartSec defaults to 100ms
        RestartSec = 3;
      };
      wantedBy = [ "vault.service" "consul.service" "nomad.service" ];
      partOf = [ "vault.service" "consul.service" "nomad.service" ];
      after = [ "vault.service" "consul.service" "nomad.service" ];
    };
  };
}
