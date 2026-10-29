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

    impermanence.url = "github:nix-community/impermanence";

    catppuccin.url = "github:catppuccin/nix";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    comin.url = "github:nlewo/comin";

    terranix.url = "github:terranix/terranix";

    # microvm.url = "github:astro/microvm.nix";
    # microvm.inputs.nixpkgs.follows = "nixpkgs";

    # nix-nomad.url = "github:tristanpemble/nix-nomad";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # lanzaboote.url = "github:nix-community/lanzaboote";
    # lanzaboote.inputs.flake-compat.follows = "";

    black-hosts.url = "github:StevenBlack/hosts";

    kmonad.url = "github:kmonad/kmonad?dir=nix";

    zig_overlay.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = func: (nixpkgs.lib.genAttrs systems func);

    in
    {

      nixosConfigurations = {
        svr = import ./hosts/svr { inherit inputs; };
        img_desk = import ./hosts/img_desk_2.nix { inherit inputs; };
      };

          hydraJobs = {
             main = self.nixosConfigurations.img_desk.config.system.build.images.docker;
};
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              sops
            ];
          };
        }
      );

    };

}
