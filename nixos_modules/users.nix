{ config, lib, pkgs, host, ... }:
let
  module = "_users";
  deskription = "users config";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    users.users.${host.user} = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" "corectrl" ];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = host.ssh_authorized_keys;
    };
    # Use sudo with no password
    security = {
      sudo.wheelNeedsPassword = false;
      sudo.execWheelOnly = true;
    };
  };

}