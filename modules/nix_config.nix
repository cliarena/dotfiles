{ pkgs, ... }: {
  nix = {
    # Constrain access to nix daemon
    settings.allowed-users = [ "@wheel" "hydra" ];

    # Enable Flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
    '';

    # Garbage Collection
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
