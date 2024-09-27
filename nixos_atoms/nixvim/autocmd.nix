{ config, lib, ... }:
let
  module = "_auto_cmds";
  deskription = "auto commands";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.autoCmd = [{
      desc = "Auto-refresh buffer if file changed externally";
      command = "if mode() != 'c' | checktime | endif";
      event = [ "FocusGained" "BufEnter" "CursorHold" "CursorHoldI" ];
      pattern = [ "*" ];
    }];
  };

}
