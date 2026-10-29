{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (inputs) home-manager;
  host = rec {
    user = "x";
    ip_addr = "10.10.0.10";
    wan_ips = [ "${ip_addr}/24" ];
    wan_gateway = [ "10.10.0.1" ];
    wan_mac = "1c:83:41:32:6a:3c";
    lan_mac = "c8:4d:44:23:95:db";
    lan_ip_addr = "10.10.2.1";
    lan_ips = [ "${lan_ip_addr}/24" ];
    wlan_ip_addr = "10.10.5.1";
    wlan_ips = [ "${wlan_ip_addr}/24" ];
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
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  system = "x86_64-linux";
  # pkgs = {
  #   inherit system;
  #   config = {
  #     allowUnfree = true;
  #     # permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];
  #   };
  # };
in
nixosSystem {
  inherit system;
  specialArgs = {
    inherit
      inputs
      pkgs
      host
      system
      ;
  };
  modules = [
    home-manager.nixosModules.home-manager
    {
      # inherit (inputs)nixpkgs;
      # home-manager.useGlobalPkgs = true;
      # home-manager.useUserPackages = true;
      # home-manager.users.${host.user} = {
      #   imports = [ ./home.nix ];
      # };
      #
      # Optionally, use home-manager.extraSpecialArgs to pass
      # arguments to home.nix
      home-manager.extraSpecialArgs = {
        inherit
          # inputs
          pkgs
          # home-manager
          # sops-nix
          # hyprland
          ;
      };
    }
    {
      # _home_gitter.enable = true;
      profiles.common.enable = true;
      profiles.desktop.enable = true;

image.modules = {
docker = ./docker.nix;
};
# system.build.image.docker=  nixosSystem {};
    }
  ]
  ++ inputs.nixpkgs.lib.fileset.toList ../profiles;
}
