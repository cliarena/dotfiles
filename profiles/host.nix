{ config, lib, ... }:
let
  module = "host";
  deskription = "host profile";
  inherit (lib) mkEnableOption mkIf fileset;
in {

  # imports = nixos_modules_list;
  imports = fileset.toList ../nixos_modules;

  options.profiles.${module}.enable = mkEnableOption deskription;

  config = mkIf config.profiles.${module}.enable {

    _swap.enable = true;
    _local.enable = true;
    _comin.enable = true;

  };

}
