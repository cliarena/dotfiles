{ config, ... }: {
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
    knownHosts = {
      # This to avoid fingerprints verification prompt on git clone
      "gitlab.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      "github.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };
}
# Host gitlab.com
# PreferredAuthentications publickey
#  IdentityFile ~/.ssh/gitlab
