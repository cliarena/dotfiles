{ pkgs, user, ... }: {
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    shell = pkgs.nushell;
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1NKQdwVosRxqoSOfBcjIuTNidrd1Ob4Cw6z6IbZ5KA PI"
    # ];
  };
  # Use sudo with no password
  security = { sudo.wheelNeedsPassword = false; };
}
