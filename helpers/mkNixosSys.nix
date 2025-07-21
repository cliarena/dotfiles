{
  inputs,
  user,
  system,
  modules,
  ...
}: let
  inherit (inputs) nixpkgs;
  pkgs = import nixpkgs {
    inherit system;
    config = {allowUnfree = true;};
  };
in {
  ${user} = nixpkgs.lib.nixosSystem {
    inherit system modules;
    specialArgs = {inherit inputs nixpkgs pkgs user;};
  };
}
