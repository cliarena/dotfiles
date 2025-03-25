{
  description = "Nixos configuration";

  inputs = {
    # Cloned on boot
    # Update project urls when needed
    # home_notes.url = "gitlab:persona_code/notes";
    # home_dotfiles.url = "gitlab:cliarena_dotfiles/nixos";
    # home_project_main.url = "gitlab:mallx/products";
    # home_project_scondary.url = "gitlab:mallx/products";

    # nixpkgs.url = "github:NixOS/nixpkgs/9957cd48326fe8dbd52fdc50dd2502307f188b0d";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-registry.url = "github:NixOS/flake-registry";
    flake-registry.flake = false;

    flakelight.url = "github:nix-community/flakelight";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    catppuccin.url = "github:catppuccin/nix";

    # wolf should follow nixpkgs since it needs to use the same vaapi driver version of the host
    # wolf.url = "gitlab:clxarena/wolf";
    wolf.url = "github:games-on-whales/wolf/dev-nix";
    # wolf.inputs.nixpkgs.follows = "nixpkgs"; # follow may break pkg dependencies

    devenv.url = "github:cachix/devenv";

    comin.url = "github:nlewo/comin";

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

    zig-overlay.url = "github:mitchellh/zig-overlay";
    zls-overlay.url = "github:zigtools/zls";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
  };

  outputs = inputs@{ flakelight, ... }:

    let forAllSystems = import ./helpers/forAllSystems.nix;

    in flakelight ./. {
      inherit inputs;

      withOverlays = [
        (final: prev: {
          zig = inputs.zig-overlay.packages.${prev.system}.master;
          zls = inputs.zls-overlay.packages.${prev.system}.default;
        })
      ];

      nixDir = ./.;
      nixDirAliases = {
        nixosConfigurations = [ "hosts" ];
        # nixosModules = [ "nixos_modules" ];
        # homeModules = [ "home_modules" ];
      };

      nixpkgs.config = {
        allowUnfree = true;
        allowBroken = true;
        permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];
      };

      devShell = pkgs: {
        packages = with pkgs; [
          vault
          consul
          nomad
          terraform
          sops
          dig
          openssl
          libuuid
          wander

          # for nix
          nixfmt
          nil
          nixd
          terraform-ls
          deadnix
          stylua
          lua-language-server
        ];
        env = {
          NOMAD_ADDR = "http://10.10.0.10:4646";
          CONSUL_HTTP_ADDR = "http://10.10.0.10:8500";
          VAULT_ADDR = "https://vault.cliarena.com:8200";
        };
      };

      apps = pkgs: import ./terranix { inherit inputs pkgs; };

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
