{ config, lib, inputs, host, pkgs, ... }:
let
  module = "_ssh_home";
  description = "ssh client config";
  inherit (lib) mkEnableOption mkIf;
  inherit (inputs) home-manager;

  gitlab_pub_key_file = (pkgs.writeText "gitlab"
    "gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf");
  github_pub_key_file = (pkgs.writeText "github"
    "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl");
in {

  imports = [ home-manager.nixosModules.home-manager ];
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    home-manager.users.${host.user} = { config, ... }:
      let inherit (config.home) homeDirectory;
      in {
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
              hostname = "10.10.2.1";
              user = "svr";
              port = 6523;
              identityFile = config.sops.secrets.SVR_SSH_KEY.path;
            };
            space-x = {
              host = "DS";
              hostname = "10.10.2.1";
              user = "x";
              port = 10001;
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
          # This to avoid fingerprints verification prompt on git clone
          userKnownHostsFile =
            "${homeDirectory}/.ssh/known_hosts ${gitlab_pub_key_file}  ${github_pub_key_file}";
        };
      };
  };
}
