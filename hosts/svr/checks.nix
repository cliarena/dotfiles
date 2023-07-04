{ inputs, forAllSystems, ... }:

forAllSystems (system:
  let pkgs = import inputs.nixpkgs { inherit system; };
  in {
    test = pkgs.nixosTest {
      name = "default";
      # node.specialArgs = { user = "pi"; };
      nodes = {
        svr = {
          imports = [ (import ./default.nix { inherit inputs pkgs; }) ];
          # disabledModules = [ ];
        };
      };
      testScript = ''
        start_all()
        svr.wait_for_unit("multi-user.target")

        svr.succeed("podman -v")
        # TODO: Test Vault needs auto-unseal
        # Pi.succeed("vault status")
      '';
    };
  })
