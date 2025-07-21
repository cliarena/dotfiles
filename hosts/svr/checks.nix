{inputs, ...}: {
  name = "default";
  # node.specialArgs = { user = "svr"; };
  nodes = {
    svr = {
      _module.args.host = rec {
        user = "svr";
        wan_ips = ["10.10.0.10/24"];
        wan_gateway = ["10.10.0.1"];
        dns = wan_gateway;
        # open the least amount possible
        tcp_ports = [8080];
        udp_ports = [];
        ssh_authorized_keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8IGiyQMdIau7bIL63er9C9O3o/6wxNX7x8CL0DC0Ot SVR"
        ];
      };
      imports = [(import ./configuration.nix {inherit inputs;})];
      # disabledModules = [];
    };
  };
  testScript = ''
    start_all()
    svr.wait_for_unit("multi-user.target")

    #with subtest("is nomad running"):
      # svr.execute("export NOMAD_ADDR=0.0.0.0:4646")
     # svr.wait_until_succeeds("NOMAD_ADDR=http://0.0.0.0:4646 nomad node status")

    # TODO: Test Vault needs auto-unseal
    # Pi.succeed("vault status")
  '';
}
