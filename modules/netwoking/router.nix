{ pkgs, host, ... }:
let
  inherit (host)
    user tcp_ports udp_ports wan_ips wan_gateway dns_server is_dns_server;
in {
  # Rename network interface to wan
  services.udev.extraRules = ''
    KERNEL=="eth0", NAME="lan"
    KERNEL=="eth1", NAME="wan"
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
        "20-wired" = {
          enable = true;
          name = "wan";
          address = wan_ips;
          gateway = wan_gateway;
          dns = dns_server;
          # if you want dhcp uncomment this and comment address,gateway and dns
          # DHCP = "ipv4";
        };
        "30-wired" = {
          enable = true;
          name = "lan";
          address = wan_ips;
          gateway = wan_gateway;
          dns = dns_server;
          # if you want dhcp uncomment this and comment address,gateway and dns
          # DHCP = "ipv4";
        };
      };
    };
  };

}
