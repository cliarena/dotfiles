{
  config,
  lib,
  pkgs,
  microvm,
  ...
}: {
  microvm.vms = {
    my-microvm = {
      # The package set to use for the microvm. This also determines the microvm's architecture.
      # Defaults to the host system's package set if not given.
      autostart = false;
      inherit pkgs;

      # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
      #specialArgs = {};

      # The configuration for the MicroVM.
      # Multiple definitions will be merged as expected.
      config = {
        # imports = [ ../modules/nix_config.nix ];
        # microvm.hypervisor = "cloud-hypervisor";
        # microvm.mem = 200;
        # microvm.balloonMem = 512;
        # It is highly recommended to share the host's nix-store
        # with the VMs to prevent building huge images.
        microvm.shares = [
          {
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
            socket = "/tmp/test.sock";
          }
        ];
        # services.nginx.enable = true;
        # environment.systemPackages = with pkgs; [ socat dig curl bottom ];
        # networking.firewall.enable = false;
        # systemd.services.hello = {
        # wantedBy = [ "multi-user.target" ];
        # script = ''
        # ${pkgs.http-server}/bin/http-server -p 8080
        # '';
        # };
        # systemd.services.socat = {
        # wantedBy = [ "multi-user.target" ];
        # script = ''
        # ${pkgs.socat}/bin/socat VSOCK-LISTEN:2000,reuseaddr,fork TCP:localhost:8080
        # '';
        # };
        # services.iperf3 = {
        # enable = true;
        # port = 8081;
        # verbose = true;
        # debug = true;
        # };

        microvm.vsock.cid = 5;
        # microvm.interfaces = [
        # # {
        # # id = "eth0";
        # # type = "bridge";
        # # mac = "02:00:00:00:00:01";
        # # bridge = "default";
        # # }
        # {
        # type = "user";
        # # interface name on the host
        # id = "microvm-tap";
        # # Ethernet address of the MicroVM's interface, not the host's
        # #
        # # Locally administered have one of 2/6/A/E in the second nibble.
        # mac = "02:00:00:00:00:01";
        # }
        # ];
        # systemd.network.enable = true;
        # systemd.network.networks."20-lan" = {
        # matchConfig.Type = "ether";
        # networkConfig = {
        # Address = [ "192.168.1.3/24" "2001:db8::b/64" ];
        # Gateway = "192.168.1.1";
        # DNS = [ "192.168.1.1" ];
        # IPv6AcceptRA = true;
        # DHCP = "no";
        # };
        # };
        # Disable if this server is a dns server
        # Rename network interface to wan
        # services.udev.extraRules = ''
        # KERNEL=="e*", NAME="wan"
        # '';
        # Disable if this server is a dns server
        # services.resolved.enable = false;
        # services.openssh.enable = true;
        # users.users.microvm = {
        # isNormalUser = true;
        # initialPassword = "nixos";
        # extraGroups = [ "wheel" "corectrl" ];
        # shell = pkgs.nushell;
        # };

        # networking = {
        # hostName = "microvm";
        # # extraHosts = "127.0.0.1 local.cliarena.com";
        # # useDHCP = false;
        # useNetworkd = true;
        # # nameservers = [ "1.1.1.1" ];
        # # resolvconf.enable = pkgs.lib.mkForce false;
        # # dhcpcd.extraConfig = "nohook resolv.conf";
        # # networkmanager.dns = "none";
        # firewall = {
        # enable = false;
        # # interfaces.wan = {
        # # allowedTCPPorts = tcp_ports;
        # # allowedUDPPorts = udp_ports;
        # # };
        # };
        # };
        # systemd = {
        # network = {
        # enable = true;
        # wait-online.anyInterface = true;
        # networks = {
        # "20-wired" = {
        # enable = true;
        # matchConfig.Type = "ether";
        # # name = "wan";
        # address = [ "192.168.246.222/24" ];
        # gateway = [ "192.168.246.1" ];
        # dns = [ "192.168.246.1" ];
        # # if you want dhcp uncomment this and comment address,gateway and dns
        # # DHCP = "ipv4";
        # };
        # };
        # };
        # };
        # networking.nat = {
        # enable = true;
        # externalInterface = "eth0";
        # internalInterfaces = [ "microvm-tap" ];
        # forwardPorts = [{
        # proto = "tcp";
        # sourcePort = 8080;
        # destination = "0.0.0.0:8080";
        # }
        # # {
        # # proto = "tcp";
        # # sourcePort = 443;
        # # destination = my-addresses.https-reverse-proxy.ip4;
        # # }
        # ];
        # };

        # microvm.forwardPorts =
        # [ # forward local port 2222 -> 22, to ssh into the VM
        # {
        # from = "host";
        # host.port = 8080;
        # guest.port = 8080;
        # }
        # {
        # from = "host";
        # host.port = 8081;
        # guest.port = 8081;
        # }
        # {
        # from = "host";
        # host.port = 22;
        # guest.port = 22;
        # }
        # ];
        # Any other configuration for your MicroVM
        # [...]
      };
    };
  };
}
