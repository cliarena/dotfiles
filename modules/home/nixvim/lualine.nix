{ ... }: {
  enable = true;
  globalstatus = true;
  componentSeparators = {
    left = "";
    right = "";
  };
  sectionSeparators = {
    left = "";
    right = "";
  };
  disabledFiletypes.statusline = [ "dashboard" "NvimTree" "Outline" ];
  sections = {
    lualine_a = [ "branch" "diagnostics" ];
    lualine_b = [ "mode" ];
    lualine_c = [ "filename" ];
    lualine_x = [ "diff" "filetype" ];
    # lualine_x = [ "diff" "spaces" "encoding" "filetype " ];
    lualine_y = [ "location" ];
    lualine_z = [ "progress" ];
  };

}
