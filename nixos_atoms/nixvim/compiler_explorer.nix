{
  config,
  lib,
  pkgs,
  ...
}: let
  module = "_compiler_explorer";
  description = "Assembly explorer";
  inherit (lib) mkEnableOption mkIf;
in {
  options.${module}.enable = mkEnableOption description;

  config = mkIf config.${module}.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [compiler-explorer-nvim];

      extraConfigLua = ''
require("compiler-explorer").setup({
  url = "http://10.10.0.10:10240",
  infer_lang = true, -- Try to infer possible language based on file extension.
  line_match = {
    highlight = true, -- highlight the matching line(s) in the other buffer.
    jump = false, -- move the cursor in the other buffer to the first matching line.
  },
  open_qflist = true, --  Open qflist after compilation if there are diagnostics.
  split = "vsplit", -- How to split the window after the second compile (split/vsplit).
  compiler_flags = "", -- Default flags passed to the compiler.
  job_timeout_ms = 25000, -- Timeout for libuv job in milliseconds.
  languages = { -- Language specific default compiler/flags
    zig = {
      compiler = "zig",
      compiler_flags = "-O ReleaseFast -target x86_64-linux -mcpu=znver3",
    },
  },
})
       '';
    };
  };
}
