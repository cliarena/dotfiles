{
  config,
  lib,
  host,
  ...
}: let
  module = "_sshd";
  description = "openssh server daemon";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.openssh = {
      enable = true;
      ports = [host.ports.ssh];
      permitRootLogin = "no";
      passwordAuthentication = false;
      allowSFTP = false;
      challengeResponseAuthentication = false;
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
      knownHosts = {
        # This to avoid fingerprints verification prompt on git clone
        "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
  };
}
