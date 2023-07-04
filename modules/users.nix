{ pkgs, user, ... }: {
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    shell = pkgs.nushell;
  };
  # Use sudo with no password
  security = {
    sudo.wheelNeedsPassword = false;
    sudo.execWheelOnly = true;
  };
}
