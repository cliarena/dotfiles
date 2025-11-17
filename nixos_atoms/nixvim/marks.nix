{
  config,
  lib,
  ...
}: let
  module = "_marks";
  description = "better mark navigations";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim.plugins.marks = {enable = true;

settings ={
  cyclic = true;
  mappings = {
    delete = "md";
    # delete_buf = "<Leader>mc";
    # delete_line = "<Leader>mD";
    next = "mm";
    prev = "mM";
    set = "m,";
    toggle = "m;";
  };
  refreshInterval = 150;
};
    };
  };
}
