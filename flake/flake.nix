{
  description = "Nixos configuration";

  inputs = {
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

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # wolf should follow nixpkgs since it needs to use the same vaapi driver version of the host
    # wolf.url = "gitlab:clxarena/wolf";
    wolf.url = "github:games-on-whales/wolf/dev-nix";
    wolf.inputs.nixpkgs.follows = "nixpkgs"; # follow may break pkg dependencies

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

    zig-overlay.url = "github:mitchellh/zig-overlay";
    zls-overlay.url = "github:zigtools/zls";

    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    # };
  };

  outputs = inputs @ {
    self,
    flakelight,
    ...
  }: let
    forAllSystems = import ./helpers/forAllSystems.nix;
    #      flakelight_extended = flakelight.lib.mkFlake.extend [
    #        {
    #          options.hydraJobs = inputs.nixpkgs.lib.mkOption {
    #            type = flakelight.lib.types.nullable flakelight.lib.types.packageDef;
    #            default = null;
    #          };
    #        }
    #      ];
  in
    flakelight ./. ({
      lib,
      types,
      outputs,
      ...
    }: {
      inherit inputs;
      systems = ["x86_64-linux"];
      formatter = pkgs: pkgs.alejandra;

      withOverlays = [
        (final: prev: {
          zig = inputs.zig-overlay.packages.${prev.system}.master;
          # zls = inputs.zls-overlay.packages.${prev.system}.default;
          zls = inputs.zls-overlay.packages.x86_64-linux.zls.overrideAttrs (old: {
            nativeBuildInputs = [inputs.zig-overlay.packages.${prev.system}.master];
          });
        })
      ];

      nixDir = ../.;
      nixDirAliases = {
        nixosConfigurations = ["hosts"];
        # nixosModules = [ "nixos_modules" ];
        # homeModules = [ "home_modules" ];
      };

      nixpkgs.config = {
        allowUnfree = true;
        allowBroken = true;
        permittedInsecurePackages = [
          "freeimage-3.18.0-unstable-2024-04-18" # needed by colmap
        ];
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
          nixfmt-rfc-style
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

      apps = pkgs: import ../terranix {inherit inputs pkgs;};

      package = pkgs: import ../images/main.nix {inherit lib pkgs inputs;};
      # package = pkgs: pkgs.hello;
      # perSystem = pkgs: { hydraJobs ={ x = { inherit (pkgs) cowsay;}; };};

      # use perSystem is module option not available natively bu flakelight
      perSystem = pkgs: {
        hydraJobs = {main = import ../images/main.nix {inherit lib pkgs inputs;};};
      };

      #      packages.x86_64-linux = {
      #      packages = {
      #        packages.retro = inputs.nixos-generators.nixosGenerate {
      #          system = "x86_64-linux";
      #          format = "docker";

      #          modules = lib: [
      #            ../modules/hardware/amd.nix
      #            {
      #                 environment.systemPackages = pkgs : with pkgs; [
      #                  cacert
      #
      #                  fuse
      #                  libnss_nis
      #                  wget
      #                  curl
      #                  jq
      #                  gosu
      #
      #                  pulseaudioFull
      #                  noto-fonts
      #                  kitty nano
      #                  psmisc
      #
      #                ];
      #                xdg.portal = {
      #                  enable =true;
      #                  extraPortals = pkgs: with pkgs; [ xdg-desktop-portal xdg-desktop-portal-gtk];
      #                };

      #          programs.sway = {
      #            enable = true;
      #            extraSessionCommands = ''
      #              export SWAYSOCK=/tmp/sway.sock
      #              export XDG_CURRENT_DESKTOP=sway
      #              export XDG_SESSIONN_DESKTOP=sway
      #              export XDG_SESSION_TYPE=wayland
      #            '';
      #          };
      #          services.getty = {
      #            autologinUser = "retro";
      #            autologinOnce = true;
      #          };
      #          environment.loginShellInit = ''
      #            [[ "$(tty)" == /dev/tty1 ]] && sway
      #          '';
      #
      #          users.users.retro = {
      #            uid = 1000;
      #            isNormalUser= true;
      #            initialPassword = true;
      #            extraGroups = [
      #              "wheel"
      #              "video"
      #              "sound"
      #              "input"
      #              "uinput"
      #            ];
      #           };
      #          _pipewire.enable = true;
      #          _local.enable = true;
      #              }
      #            ] ++ lib.fileset.toList ../profiles;

      #        };
      #      };

      # TODO: Change age.key and all sops secrets since age.key is exposed
      # checks = forAllSystems (system:
      #   let
      #     pkgs = import inputs.nixpkgs { inherit system; };
      #     inherit (pkgs) nixosTest;
      #   in {
      #     x = nixosTest (import ./hosts/x/checks.nix { inherit inputs; });
      #     svr = nixosTest (import ./hosts/svr/checks.nix { inherit inputs; });
      #   });
    });
}
