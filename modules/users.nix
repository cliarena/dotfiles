{ config, user, ... }: {
  users.users.x = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1NKQdwVosRxqoSOfBcjIuTNidrd1Ob4Cw6z6IbZ5KA PI"
    # ];
  };
}
