{ pkgs, host, ... }:
let
  inherit (host)
    user wan_mac lan_mac tcp_ports udp_ports wan_ips lan_ips wlan_ips
    wan_gateway dns_server is_dns_server;

in {
  # Rename network interface to wan
  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="1c:83:41:32:6a:3c", NAME="wan0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="c8:4d:44:23:95:db", NAME="lan0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="10:6f:d9:d0:16:6d", NAME="wlan0"
  '';
  # Disable if this server is a dns server
  services.resolved.enable = !is_dns_server;
  #services.dhcpd4 = {
  #  enable = true;
  #  interfaces = [ "lan0" ];
  #  extraConfig = ''
  #    option routers 10.10.2.1;
  #    option domain-name-servers 8.8.8.8, 8.8.4.4;
  #    option domain-name "local";
  #    subnet 10.10.2.0 netmask 255.255.255.0 {
  #      range 10.10.2.100 10.10.2.254;
  #    }
  #  '';
  #};
  services.hostapd = {
    enable = true;
    radios = {
      # Simple 2.4GHz AP
      wlan0 = {
        band = "5g"; # 5g radio
        countryCode = "US";
        wifi6 = {
          enable = true;
          operatingChannelWidth = "80";
          multiUserBeamformer = true;
        };
        channel = 52;
        networks.wlan0 = {
          ssid = "AVX_test";
          authentication = {
            mode = "wpa2-sha256";
            wpaPassword = "ilounane123";
          };
        };
      };
      # wlan0 = {
      # band = "5g"; # 5g radio
      # # countryCode = "US";
      # wifi6.enable = true;
      # channel = 40;
      # networks.wlan0 = {
      # ssid = "AVX_test2";
      # authentication = {
      # mode = "wpa2-sha256";
      # wpaPassword = "ilounane123";
      # };
      # };
      # };
    };

  };

  networking = {
    hostName = user;
    useDHCP = false;
    useNetworkd = true;
    wireless.enable = true;
    stevenBlackHosts = {
      enable = true;
      blockFakenews = true;
      blockGambling = true;
      blockPorn = true;
      blockSocial = true;
    };
    bridges.br0.interfaces = [ "wan0" "wlan0" ];
    # nameservers = [ "1.1.1.1" ];
    resolvconf.enable =
      pkgs.lib.mkForce true; # must be true. for nixos-containers to work
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
    firewall = {
      enable = false;
      interfaces.wan = {
        allowedTCPPorts = tcp_ports;
        allowedUDPPorts = udp_ports;
      };
    };
    nftables = {
      enable = true;
      ruleset = ''
        flush ruleset

        define LAN_SPACE = 10.10.2.0/24
        define WLAN_SPACE = 10.10.5.0/24
        define LAN6_SPACE = fd00::/64

        table inet global {
          chain inbound_wan {
            # https://shouldiblockicmp.com/
            # that said, icmp has some dangerous packet types, so limit it to
            # some extent
            ip protocol icmp icmp type { destination-unreachable, echo-request, time-exceeded, parameter-problem } accept
            ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, echo-request, time-exceeded, parameter-problem, packet-too-big } accept
          }
          chain inbound_lan {
            # I trust my LAN, however you might have different requirements
            accept
          }
          chain inbound {
            type filter hook input priority 0; policy accept; # workaround to nomad containers reach localhost. basically like no firewall

            ct state vmap { established : accept, related : accept, invalid : drop }

            iifname vmap { lo : accept, wan0 : jump inbound_wan, lan0 : jump inbound_lan, wlan0 : jump inbound_lan }
          }
          chain forward {
            # FIX: Change this to drop and only accept docker
            # type filter hook forward priority 10; policy drop;
            type filter hook forward priority 10; policy accept; # workaround to accept docker. basically like no firewall

            ct state vmap { established : accept, related : accept, invalid : drop }

            iifname lan0 accept
            iifname wlan0 accept
          }
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            ip saddr $WLAN_SPACE oifname wan0 masquerade
            ip saddr $LAN_SPACE oifname wan0 masquerade
            ip6 saddr $LAN6_SPACE oifname wan0 masquerade
          }
        }
      '';
    };
  };
  systemd = {
    network = {
      enable = true;
      wait-online.anyInterface = true;
      networks = {
        "10-wan0" = {
          enable = true;
          name = "wan0";
          address = wan_ips;
          # gateway = wan_gateway;
          # dns = dns_server;
          # if you want dhcp uncomment this and comment address,gateway and dns
          DHCP = "ipv4";
        };
        "20-lan0" = {
          enable = true;
          name = "lan0";
          address = lan_ips;
          # gateway = wan_gateway;
          # dns = dns_server;
          # if you want dhcp uncomment this and comment address,gateway and dns
          # DHCP = "ipv4";
          networkConfig = { DHCPServer = true; };
          dhcpServerConfig = {
            PoolOffset = 100;
            PoolSize = 100;
            EmitDNS = true;
            DNS = "8.8.8.8";
          };
          macvlan = [ "vlan0" ];
        };
        "30-wlan0" = {
          enable = true;
          name = "wlan0";
          address = wlan_ips;
          # gateway = wan_gateway;
          # dns = dns_server;
          # if you want dhcp uncomment this and comment address,gateway and dns
          # DHCP = "ipv4";
          networkConfig = { DHCPServer = true; };
          dhcpServerConfig = {
            PoolOffset = 100;
            PoolSize = 100;
            EmitDNS = true;
            DNS = "8.8.8.8";
          };
        };
      };
    };
  };

}
