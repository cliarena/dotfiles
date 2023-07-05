{ inputs, ... }: {

  name = "default";
  # node.specialArgs = { user = "svr"; };
  nodes = {
    svr = {
      _module.args.host = rec {
        user = "svr";
        wan_ips = [ "10.10.0.10/24" ];
        wan_gateway = [ "10.10.0.1" ];
        dns = wan_gateway;
        # open the least amount possible
        tcp_ports = [ 8080 ];
        udp_ports = [ ];
        ssh_authorized_keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8IGiyQMdIau7bIL63er9C9O3o/6wxNX7x8CL0DC0Ot SVR"
        ];
      };
      imports = [ (import ./configuration.nix { inherit inputs; }) ];
      # disabledModules = [];
    };
  };
  testScript = ''
    start_all()
    svr.wait_for_unit("multi-user.target")
    with subtest("is podman installed"):
      svr.succeed("podman -v")

    # TODO: Test Vault needs auto-unseal
    # Pi.succeed("vault status")
  '';
}
