{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  host = rec {
    user = "svr";
    wan_ips = [ "10.10.0.10/24" ];
    wan_gateway = [ "10.10.0.1" ];
    is_dns_server = true;
    dns_server = wan_gateway;
    # open the least amount possible
    ports = {
      dns = 53;
      ssh = 6523;
      nomad = 4646;
      consul = 8500;
      vault = 8200;
      surrealDB = 8000;
    };

    tcp_ports = with ports; [ dns ssh nomad consul vault surrealDB ];
    udp_ports = with ports; [ dns ];
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
  specialArgs = { inherit inputs nixpkgs host; };
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
