{ inputs, pkgs, lib, config, nixpkgs, ... }:

let
  baseSystem = inputs.nixpkgs.lib.nixosSystem {
    inherit (pkgs) system;
    modules = [
      ({ lib, ... }: {
        networking = {
          firewall.enable = false;
          useDHCP = false;
        };
        system = { inherit (config.system) stateVersion; };
      })
    ];
  };
  baseServices = builtins.concatLists
    (map builtins.attrNames baseSystem.options.systemd.services.definitions);
in {
  options.multiple = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
  config = {
    systemd.services = lib.mkMerge (map (x:
      lib.mapAttrs' (name: value: {
        name = name + "-custom";
        value = value // {
          serviceConfig =
            (if value ? serviceConfig then value.serviceConfig else { });
          # // {
          #   NetworkNamespacePath = "/var/run/netns/asdf";
          # };
        };
      }) (builtins.removeAttrs x baseServices))
      (inputs.nixpkgs.lib.nixosSystem {
        inherit (pkgs) system;
        modules = [
          ({ ... }: {
            networking = {
              firewall.enable = lib.mkDefault false;
              useDHCP = lib.mkDefault false;
            };
            system = { inherit (config.system) stateVersion; };
          })
          ({ ... }: config.multiple)
        ];
      }).options.systemd.services.definitions);
  };
}
