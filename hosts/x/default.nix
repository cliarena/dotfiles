{ inputs, ... }:
let
  inherit (inputs) home-manager nixvim kmonad hyprland;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  user = "x";
  system = "x86_64-linux";
  nixpkgs = {
    inherit system;
    config.allowUnfree = true;
  };
  wan_ips = [ "10.0.2.222/24" ];
  wan_gateway = [ "10.0.2.2" ];
  dns = wan_gateway;
  # open the least amount possible
  tcp_ports = [ ];
  udp_ports = [ ];
in nixosSystem {
  inherit system;
  specialArgs = {
    inherit inputs nixpkgs home-manager user wan_ips wan_gateway dns tcp_ports
      udp_ports;
  };
  modules = [
    ./configuration.nix

    kmonad.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      inherit nixpkgs;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = { imports = [ ./home.nix ]; };

      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
      home-manager.extraSpecialArgs = {
        inherit inputs nixpkgs home-manager nixvim;
      };
    }
  ];
}
