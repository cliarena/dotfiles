{ inputs, ... }:
let
  inherit (inputs) home-manager sops-nix disko kmonad hyprland;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  host = rec {
    user = "x";
    wan_ips = [ "10.10.1.222/24" ];
    wan_gateway = [ "10.10.1.1" ];
    dns = wan_gateway;
    # open the least amount possible
    tcp_ports = [ 8080 ];
    udp_ports = [ ];
  };
  system = "x86_64-linux";
  nixpkgs = {
    inherit system;
    config.allowUnfree = true;
  };

in nixosSystem {
  inherit system;
  specialArgs = { inherit inputs nixpkgs home-manager host; };
  modules = [
    ./configuration.nix

    # ./sops.nix
    # sops-nix.nixosModules.sops
    disko.nixosModules.disko
    kmonad.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      inherit nixpkgs;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${host.user} = { imports = [ ./home.nix ]; };

      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
      home-manager.extraSpecialArgs = {
        inherit inputs nixpkgs home-manager sops-nix hyprland;
      };
    }
  ];
}
