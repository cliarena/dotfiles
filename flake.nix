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

    kmonad.url = "github:kmonad/kmonad?dir=nix";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ ... }:

    let forAllSystems = import ./helpers/forAllSystems.nix;
    in {
      nixosConfigurations = {
        x = import ./hosts/x { inherit inputs; };
        svr = import ./hosts/svr { inherit inputs; };
      };

      # apps = import ./terranix { inherit inputs forAllSystems; };

      # TODO: Change age.key and all sops secrets since age.key is exposed
      checks = forAllSystems (system:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          inherit (pkgs) nixosTest;
        in {
          svr = nixosTest (import ./hosts/svr/checks.nix { inherit inputs; });
        });
    };
}
