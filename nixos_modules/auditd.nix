{
  config,
  lib,
  ...
}: let
  module = "_auditd";
  description = "super powerful monitoring";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    security.auditd.enable = true;
    security.audit.enable = true;
    security.audit.rules = ["-a exit,always -F arch=b64 -S execve"];
  };
}
