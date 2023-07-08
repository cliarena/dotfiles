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
in {
  devShells = forAllSystems (system:
    let pkgs = import nixpkgs { inherit system; };
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [{
          env = {
            CONSUL_HTTP_ADDR = "http://10.10.0.10:8500";
            VAULT_ADDR = "https://vault.cliarena.com";
          };
          processes = { };
          packages = with pkgs; [
            vault
            consul
            nomad
            sops
            dig
            openssl
            cowsay
            libuuid
          ];

          enterShell = ''
            cowsay salam to you
          '';
        }];
      };
    });
}
