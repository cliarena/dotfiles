local configs = require("nvim-treesitter.configs")

configs.setup({
	-- keep ensure_installed emply to avoid treesitter creating parsers dir in nix/strore which gives Errors
	ensure_installed = {},
	auto_install = false,
	sync_install = false,
	ignore_install = { "" }, -- List of parsers to ignore installing

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},

	autopairs = {
		enable = true,
	},

	autotag = {
		enable = true,
	},

	indent = { enable = true, disable = { "yaml" } },

	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	},


	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
})
