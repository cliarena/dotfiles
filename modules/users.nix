{ pkgs, host, ... }: {
  users.users.${host.user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = host.ssh_authorized_keys;
  };
  # Use sudo with no password
  security = {
    sudo.wheelNeedsPassword = false;
    sudo.execWheelOnly = true;
  };
}
