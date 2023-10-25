{ inputs, nixpkgs, ... }: let
  
    user = "x";
    wan_ips = [ "10.10.0.100/24" ];
    wan_gateway = [ "10.10.0.10" ];
    is_dns_server = false; # for testing hashi_stack
    dns_server = wan_gateway;
    dns_extra_hosts = "";
    ports = {

      dns = 53;
      ssh = 22;
    };
    # open the least amount possible
    tcp_ports = with ports; [ dns ssh 8080 ];
    udp_ports = with ports; [ dns ];

in {

  containers.hello = {
    autoStart = true;
    /* privateNetwork = true; */
    /* hostAddress = "10.10.0.10"; */
    /* localAddress = "10.10.0.100"; */
    /* ephemeral = true; */
    config = {config, pkgs, ...} : {
      systemd.services.hello = {
        wantedBy = [ "multi-user.target" ];
        script = ''
          while true; do
            echo hello | ${pkgs.netcat}/bin/nc -lN 50
          done
        '';
      };
    }
  }
}
