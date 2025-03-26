{ config, lib, pkgs, inputs, host, ... }:
let
  module = "_home_files";
  description = "files to add to home dir";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = { config, lib, ... }: {

      home.activation = {
        makePotato = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ${pkgs.git}/bin/git clone git@gitlab.com:persona_code/notes ~/potato \
            --config core.sshCommand="${pkgs.openssh}/bin/ssh -i ${config.sops.secrets.GL_SSH_KEY.path}"
        '';
      };
      # home.file = {
      #   notes.source = inputs.home_notes.outPath;
      #   notes.recursive = true;
      # };
    };
  };
}
