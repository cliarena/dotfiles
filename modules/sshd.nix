{ host, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ host.ports.ssh ];
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
  };
}
