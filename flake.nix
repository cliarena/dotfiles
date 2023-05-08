{
  description = "Nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.flake-compat.follows = "";

    nixvim.url = "github:pta2002/nixvim";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ ... }:
    # let inherit (nixpkgs.lib) nixosSystem;

    {
      nixosConfigurations = {

        x = import ./hosts/x { inherit inputs; };
        system.stateVersion = "22.11";

      };
    };
}
