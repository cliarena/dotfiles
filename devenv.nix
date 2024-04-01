{ inputs, ... }:
let
  inherit (inputs) nixpkgs devenv;
  systems = [
    "x86_64-linux"
    "i686-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];
  forAllSystems = f:
    builtins.listToAttrs (map (name: {
      inherit name;
      value = f name;
    }) systems);
in forAllSystems (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in {
    default = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [{
        env = {
          NOMAD_ADDR = "http://10.10.0.10:4646";
          CONSUL_HTTP_ADDR = "http://10.10.0.10:8500";
          VAULT_ADDR = "https://vault.cliarena.com:8200";
          # VAULT_ADDR = "http://10.10.0.10:8200";
        };
        processes = { };
        packages = with pkgs; [
          vault
          consul
          nomad
          terraform
          sops
          dig
          openssl
          cowsay
          libuuid
          wander

          # for nix
          nixfmt
          nil
        ];

        enterShell = ''
          cowsay salam to you
        '';
      }];
    };
  })
