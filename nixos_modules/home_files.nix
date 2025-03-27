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

    home-manager.users.${host.user} = { config, ... }:
      let
        git_config =
          "core.sshCommand='${pkgs.openssh}/bin/ssh -i ${config.sops.secrets.GL_SSH_KEY.path}'";
      in {

        # home.activation = {
        #   makePotato = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        #     ${pkgs.git}/bin/git clone git@gitlab.com:persona_code/notes ~/potato \
        #       --config core.sshCommand="${pkgs.openssh}/bin/ssh -i ${config.sops.secrets.GL_SSH_KEY.path}"
        #   '';
        # };
        # home.file = {
        #   notes.source = inputs.home_notes.outPath;
        #   notes.recursive = true;
        # };
        systemd.user.services.gitter = {
          Unit = {
            Description = "Push nix store changes to attic binary cache.";
          };
          Install = { WantedBy = [ "default.target" ]; };

          Service.ExecStart = pkgs.writeShellScript "watch-store" ''
            ${pkgs.git}/bin/git  clone --config ${git_config} git@gitlab.com:persona_code/notes ~/notes
          '';
          #!/run/current-system/sw/bin/bash
          # enable = false;
          # description = "clone git repos";
          # path = with pkgs; [ openssh ];

          # environment = {
          #   WOLF_CFG_FILE = "/srv/wolf/cfg/config.toml";
          #   WOLF_PRIVATE_KEY_FILE = "/srv/wolf/cfg/key.pem";
          #   WOLF_PRIVATE_CERT_FILE = "/srv/wolf/cfg/cert.pem";
          #   HOST_APPS_STATE_FOLDER = "/srv/wolf/state";
          #   XDG_RUNTIME_DIR = "/run/user/1000";
          #
          #   # For Debuging
          #   # GST_DEBUG = "4";
          #   # WOLF_LOG_LEVEL = "DEBUG";
          #   # RUST_LOG = "DEBUG";
          # };
          # serviceConfig = {
          #   # User = "root";
          #   Group = "pulse-access";
          #   Restart = "on-failure";
          #   TimeoutSec = 3;
          #   # avoid error start request repeated too quickly since RestartSec defaults to 100ms
          #   RestartSec = 3;
          # };
        };
        # home.file = {
        #   notes = builtins.fetchGit {
        #     url = "git@gitlab.com:persona_code/notes";
        #     # ref = "main";
        #     shallow = true;
        #   };
        # };
      };
  };
}
