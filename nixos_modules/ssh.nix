{ config, lib, inputs, host, ... }:
let
  module = "_ssh_home";
  description = "ssh client config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;
in {

  imports = [ home-manager.nixosModules.home-manager ];
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = { config, ... }: {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          pi = {
            host = "PI";
            hostname = "10.10.0.2";
            user = "pi";
            port = 4729;
            identityFile = config.sops.secrets.PI_SSH_KEY.path;
          };
          svr = {
            host = "SVR";
            hostname = "10.10.0.10";
            user = "svr";
            port = 6523;
            identityFile = config.sops.secrets.SVR_SSH_KEY.path;
          };
          dev-space = {
            host = "DS";
            hostname = "10.10.2.100";
            user = "x";
            port = 22;
            identityFile = config.sops.secrets.DS_SSH_KEY.path;
          };
          gitlab = {
            host = "gitlab.com";
            identityFile = config.sops.secrets.GL_SSH_KEY.path;
            extraOptions = { PreferredAuthentications = "publickey"; };
          };
          github = {
            host = "github.com";
            identityFile = config.sops.secrets.GH_SSH_KEY.path;
            extraOptions = { PreferredAuthentications = "publickey"; };
          };
        };
      };
    };
  };
}
