{
  description = "Nixos configuration";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/9957cd48326fe8dbd52fdc50dd2502307f188b0d";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    terranix.url = "github:terranix/terranix";

    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    nix-nomad.url = "github:tristanpemble/nix-nomad";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.flake-compat.follows = "";

    black-hosts.url = "github:StevenBlack/hosts";

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

      devShells = import ./devenv.nix { inherit inputs; };

      apps = import ./terranix { inherit inputs forAllSystems; };

      # TODO: Change age.key and all sops secrets since age.key is exposed
      checks = forAllSystems (system:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          inherit (pkgs) nixosTest;
        in {
          x = nixosTest (import ./hosts/x/checks.nix { inherit inputs; });
          svr = nixosTest (import ./hosts/svr/checks.nix { inherit inputs; });
        });
    };
}
