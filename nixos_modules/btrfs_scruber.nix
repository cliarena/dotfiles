{
  config,
  lib,
  ...
}:
let
  module = "_btrfs_scruber";
  description = "BTRFS auto scrub";
  inherit (lib) mkEnableOption mkIf;
in
{
  # imports = [ inputs.comin.nixosModules.comin ];

  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    services.btrfs.autoScrub.enable = true;
  };
}
