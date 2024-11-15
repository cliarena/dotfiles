{ config, lib, pkgs, host, ... }:
let
  module = "_users";
  description = "users config";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {

    users.users.${host.user} = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [
        "avahi" # needed to read /var/lib/acme files for terranix apply
        "wheel"
        "input"
        "video"
        "sound"
      ];
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
