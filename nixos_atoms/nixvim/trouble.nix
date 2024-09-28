{ config, lib, ... }:
let
  module = "_trouble";
  deskription = "prettier diagnostics, quickfix, document symbols..";
  inherit (lib) mkEnableOption mkIf;
in {

  options.${module}.enable = mkEnableOption deskription;

  config = mkIf config.${module}.enable {

    programs.nixvim.plugins.trouble = {
      enable = true;
      settings = {
        mode = "workspace_diagnostics";
        auto_open = false; # auto open the list when you have diagnostics
        auto_close = true; # auto close the list when you have no diagnostics
        auto_fold = false; # auto fold a file trouble list at creation
        fold_open = ""; # icon used for open folds
        fold_closed = ""; # icon used for closed folds
        padding = true; # add an extra new line on top of the list
        width = 30; # width of the list when position is left or right
        action_keys = { # key mappings for actions in the trouble list
          previous = "<Up>"; # previous item
          next = "<Down>"; # next item
          close = "q"; # close the list
          cancel =
            "<esc>"; # cancel the preview and get back to your last window / buffer / cursor
          refresh = "r"; # manually refresh
          jump =
            [ "<cr>" "<tab>" ]; # jump to the diagnostic or open / close folds
          open_split = [ "<c-x>" ]; # open buffer in new split
          open_vsplit = [ "<c-v>" ]; # open buffer in new vsplit
          open_tab = [ "<c-t>" ]; # open buffer in new tab
          jump_close = [ "o" ]; # jump to the diagnostic and close the list
          toggle_mode =
            "m"; # toggle between "workspace" and "document" diagnostics mode
          toggle_preview = "P"; # toggle auto_preview
          hover = "K"; # opens a small popup with the full multiline message
          preview = "p"; # preview the diagnostic location
          close_folds = [ "zM" "zm" ]; # close all folds
          open_folds = [ "zR" "zr" ]; # open all folds
          toggle_fold = [ "zA" "za" ]; # toggle fold of current file
        };
        signs = {
          error = "";
          warning = "";
          hint = "";
          information = "";
          other = "﫠";
        };
      };
    };

  };
}
