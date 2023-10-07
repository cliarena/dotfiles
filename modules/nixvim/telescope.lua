local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local trouble = require("trouble.providers.telescope")
local actions = require "telescope.actions"



telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    layout_config ={
      horizontal = { preview_width = 0.6 },
    },

    mappings = {
      i = {
        ["<C-h>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,

        ["<C-n>"] = actions.move_selection_next,
        ["<C-e>"] = actions.move_selection_previous,

        ["<esc>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-Up>"] = actions.preview_scrolling_up,
        ["<C-Down>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,

        ["<c-T>"] = trouble.open_with_trouble,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["n"] = actions.move_selection_next,
        ["e"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-Up>"] = actions.preview_scrolling_up,
        ["<C-Down>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<c-T>"] = trouble.open_with_trouble,
        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
     fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    media_files = {
        -- filetypes whitelist
        -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        filetypes = {"png", "webp", "jpg", "jpeg"},
        find_cmd = "rg" -- find command (defaults to `fd`)
      }
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
  tailiscope = {
			-- register to copy classes to on selection
			register = "a",
		 	-- indicates what picker opens when running Telescope tailiscope
			-- can be any file inside of docs dir but most useful opts are
			-- all, base, categories, classes
			-- These are also accesible by running Telescope tailiscope <picker>
			default = "base",
			-- icon indicates an item which can be opened in tailwind docs
			-- can be icon or false
			doc_icon = " ",
		  	-- if you would prefer to copy with/without class selector
		 	-- dot is maintained in display to differentiate class from other pickers
			no_dot = true,
			maps = {
				i = {
					back = "<C-h>",
					open_doc = "<C-o>",
				},
				n = {
					back = "b",
					open_doc = "od",
				},
			},
	}
}


-- telescope.load_extension('luasnip')
telescope.load_extension('media_files')
telescope.load_extension('fzf')
-- telescope.load_extension('tailiscope')
telescope.load_extension('manix')
