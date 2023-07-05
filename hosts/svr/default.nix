{ inputs, ... }:
let
  inherit (inputs) home-manager sops-nix disko kmonad hyprland;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  host = rec {
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

    # home-manager.nixosModules.home-manager
    # {
    #   inherit nixpkgs;
    #   home-manager.useGlobalPkgs = true;
    #   home-manager.useUserPackages = true;
    #   home-manager.users.${user} = { imports = [ ./home.nix ]; };
    #
    #   # Optionally, use home-manager.extraSpecialArgs to pass
    #   # arguments to home.nix
    #   home-manager.extraSpecialArgs = {
    #     inherit inputs nixpkgs home-manager sops-nix hyprland;
    #   };
    # }
  ];
}
