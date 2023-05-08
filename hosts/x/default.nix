{ inputs, ... }:
let
  user = "x";
  system = "x86_64-linux";
  inherit (inputs) nixpkgs home-manager kmonad hyprland;
  # nixpkgs = inputs.nixpkgs {
  #   inherit system;
  #   config.allowUnfree = true;
  # };
  inherit (nixpkgs.lib) nixosSystem;
in nixosSystem {
  inherit system;
  specialArgs = { inherit inputs nixpkgs home-manager; };
  modules = [
    ./configuration.nix

    # hyprland.homeManagerModules.default
    # {
    #   wayland.windowManager.hyprland.enable = true;
    # }
    # kmonad.nixosModules.default
    # home-manager.nixosModules.home-manager
    # {
    #   # nixpkgs = nixpkgsConfig;
    #   inherit nixpkgs;
    #   home-manager.useGlobalPkgs = true;
    #   home-manager.useUserPackages = true;
    #   # home-manager.users.${user} = { imports = [ ./home.nix ]; };
    #
    #   # Optionally, use home-manager.extraSpecialArgs to pass
    #   # arguments to home.nix
    #   home-manager.extraSpecialArgs = {
    #     inherit inputs nixpkgs home-manager user;
    #   };
    # }
  ];
}
