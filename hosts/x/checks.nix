{ inputs, ... }: {

  name = "default";
  # node.specialArgs = { user = "svr"; };
  nodes = {
    x = {
      _module.args.host = rec {
        user = "x";
        wan_ips = [ "10.10.0.2/24" ];
        wan_gateway = [ "10.10.0.1" ];
        dns = wan_gateway;
        # open the least amount possible
        tcp_ports = [ 8080 ];
        udp_ports = [ ];
        ssh_authorized_keys = [ ];
      };
      imports = [ (import ./configuration.nix { inherit inputs; }) ];
      disabledModules = [ ../../modules/video_acceleration.nix ];
    };
  };
  testScript = ''
    start_all()
    x.wait_for_unit("multi-user.target")
    # not working since vm is not able to reach internet
    # with subtest("is gitlab ssh connection working"):
    #  x.succeed("ssh -T git@gitlab.com")

    # TODO: Test Vault needs auto-unseal
    # Pi.succeed("vault status")
  '';
}
