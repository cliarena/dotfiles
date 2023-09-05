{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  host = rec {
    user = "svr";
    ip_addr = "10.10.0.10";
    wan_ips = [ "${ip_addr}/24" ];
    wan_gateway = [ "10.10.0.1" ];
    wan_mac = "1c:83:41:32:6a:3c";
    lan_mac = "c8:4d:44:23:95:db";
    is_dns_server = true;
    dns_server = wan_gateway;
    dns_extra_hosts = "127.0.0.1 local.cliarena.com";
    # open the least amount possible
    ports = {
      dns = 53;
      ssh = 6523;
      nomad = 4646;
      consul = 8500;
      vault = 8200;
      surrealDB = 8000;
      kasm = 3003;
      kasm_wizard = 3000;
    };

    tcp_ports = with ports; [
      dns
      ssh
      nomad
      consul
      vault
      surrealDB
      kasm
      kasm_wizard
    ];
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
