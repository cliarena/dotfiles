{ config, lib, pkgs, microvm, ... }: {
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
        # It is highly recommended to share the host's nix-store
        # with the VMs to prevent building huge images.
        microvm.shares = [{
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "9p";
        }];
        # services.nginx.enable = true;
        environment.systemPackages = with pkgs; [ curl bottom ];
        networking.firewall.enable = false;
        systemd.services.hello = {
          wantedBy = [ "multi-user.target" ];
          script = ''
            ${pkgs.http-server}/bin/http-server -p 8080
              # while true; do
              #   echo hello | ${pkgs.netcat}/bin/nc -lN 80
              # done
          '';
        };
        microvm.interfaces = [
          # {
          # id = "eth0";
          # type = "bridge";
          # mac = "02:00:00:00:00:01";
          # bridge = "default";
          # }
          {
            type = "tap";
            # interface name on the host
            id = "default";
            # Ethernet address of the MicroVM's interface, not the host's
            #
            # Locally administered have one of 2/6/A/E in the second nibble.
            mac = "02:00:00:00:00:01";
          }
        ];

        # Any other configuration for your MicroVM
        # [...]
      };
    };
  };
}
