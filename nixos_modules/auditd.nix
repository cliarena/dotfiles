{ config, lib, ... }:
let
  module = "_auditd";
  deskription = "super powerful monitoring";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    security.auditd.enable = true;
    security.audit.enable = true;
    security.audit.rules = [ "-a exit,always -F arch=b64 -S execve" ];

  };

}
