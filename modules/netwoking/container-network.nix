{
  lib,
  pkgs,
  host,
  ...
}: let
  inherit
    (host)
    user
    tcp_ports
    udp_ports
    wan_ips
    wan_gateway
    dns_server
    is_dns_server
    ;
in {
  # Disable if this server is a dns server
  services.resolved.enable = !is_dns_server;

  networking = {
    hostName = user;
    extraHosts = "127.0.0.1 local.cliarena.com";
    useDHCP = false;
    useNetworkd = true;
    # nameservers = [ "1.1.1.1" ];
    resolvconf.enable = pkgs.lib.mkForce false;
    useHostResolvConf = pkgs.lib.mkForce false;
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
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
        "20-mv-qub0" = {
          enable = true;
          name = "mv-qub0";
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
