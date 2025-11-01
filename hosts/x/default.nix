{inputs, ...}: let
  inherit (inputs) home-manager sops-nix disko kmonad hyprland;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  host = rec {
    user = "x";
    wan_ips = ["10.10.2.222/24"];
    wan_gateway = ["10.10.2.1"];
    is_dns_server = false; # for testing hashi_stack
    dns_server = wan_gateway;
    dns_extra_hosts = "";
    ports = {
      dns = 53;
    };
    # open the least amount possible
    tcp_ports = with ports; [dns 8080];
    udp_ports = with ports; [dns];
    ssh_authorized_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE8IGiyQMdIau7bIL63er9C9O3o/6wxNX7x8CL0DC0Ot SVR"
    ];
  };
  system = "aarch64-linux";
  nixpkgs = {
    inherit system;
    config.allowUnfree = true;
  };
in {
  inherit system;
  specialArgs = {inherit inputs nixpkgs home-manager host system;};
  modules = [./configuration.nix];
}
