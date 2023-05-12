{ pkgs, user, tcp_ports, udp_ports, wan_ips, wan_gateway, ... }: {
  # Rename network interface to wan
  services.udev.extraRules = ''
    KERNEL=="e*", NAME="wan"
  '';
  services.resolved.enable = false;

  networking = {
    hostName = user;
    # extraHosts = "127.0.0.1 local.cliarena.com";
    useDHCP = false;
    useNetworkd = true;
    # nameservers = [ "1.1.1.1" ];
    resolvconf.enable = pkgs.lib.mkForce false;
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
    firewall = {
      enable = false;
      interfaces.wan = {
        allowedTCPPorts = tcp_ports;
        allowedUDPPorts = udp_ports;
      };
    };
  };
  systemd = {
    network = {
      enable = true;
      wait-online.anyInterface = true;
      networks = {
        "20-wired" = {
          enable = true;
          name = "wan";
          address = wan_ips;
          gateway = wan_gateway;
          # dns = [ "1.1.1.1" ];
        };
      };
    };
  };

}
