{ pkgs, host, ... }:
let
  inherit (host)
    user wan_mac lan_mac tcp_ports udp_ports wan_ips wan_gateway dns_server
    is_dns_server;

in {
  # Rename network interface to wan
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="1c:83:41:32:6a:3c", NAME="wan0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="c8:4d:44:23:95:db", NAME="lan0"
  '';
  # Disable if this server is a dns server
  services.resolved.enable = !is_dns_server;

  networking = {
    hostName = user;
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
        "20-wan0" = {
          enable = true;
          name = "wan0";
          # address = wan_ips;
          # gateway = wan_gateway;
          # dns = dns_server;
          # if you want dhcp uncomment this and comment address,gateway and dns
          DHCP = "ipv4";
        };
        # "30-lan0" = {
        #   enable = true;
        #   name = "lan0";
        #   address = wan_ips;
        #  gateway = wan_gateway;
        #  dns = dns_server;
        # if you want dhcp uncomment this and comment address,gateway and dns
        # DHCP = "ipv4";
        # };
      };
    };
  };

}
