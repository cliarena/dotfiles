{ ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 4729 ];
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
