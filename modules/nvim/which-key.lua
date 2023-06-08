local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 40, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "◇", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "n", "e" },
		v = { "n", "e" },
	},
}

local goto_opts = {
	mode = "n", -- NORMAL mode
	prefix = "g",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local goto_mappings = {
	l = {
		name = "LSP",
		d = { "<cmd>Lspsaga peek_definition<cr>", "Peek Definition" },
		D = { "<cmd>Lspsaga goto_definition<cr>", "Definition" },
		t = { "<cmd>Lspsaga peek_type_definition<cr>", "Peek Type definition" },
		T = { "<cmd>Lspsaga goto_type_definition<cr>", "Type definition" },
		f = { "<cmd>Lspsaga lsp_finder<cr>", "Find symbol's definition" },
		a = { "<cmd>Lspsaga code_action<cr>", "Code action" },
		r = { "<cmd>Lspsaga rename<cr>", "Rename" },
		R = { "<cmd>Lspsaga rename ++project<cr>", "Rename in all project" },
		l = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Line diagnostics" },
		b = { "<cmd>Lspsaga show_buf_diagnostics<cr>", "Buffer diagnostics" },
		w = { "<cmd>Lspsaga show_workspace_diagnostics<cr>", "Workspace diagnostics" },
		c = { "<cmd>Lspsaga show_cursor_diagnostics<cr>", "Cursor diagnostics" },
		n = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diagnostic" },
		N = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev diagnostic" },
		o = { "<cmd>Lspsaga outline<cr>", "Outline" },
		h = { "<cmd>Lspsaga hover_doc<cr>", "Hover documentation" },
		H = { "<cmd>Lspsaga hover_doc ++keep<cr>", "Hover documentation in buffer" },
		i = { "<cmd>Lspsaga incoming_calls<cr>", "Incoming calls" },
		I = { "<cmd>Lspsaga outgoing_calls<cr>", "Incoming calls" },
	},
	a = {
		name = "Case Convert",

		u = { "<cmd>lua require('textcase').current_word('to_upper_case')<cr>", "Upper Case" },
		l = { "<cmd>lua require('textcase').current_word('to_lower_case')<cr>", "Lower Case" },
		s = { "<cmd>lua require('textcase').current_word('to_snake_case')<cr>", "Snake Case" },
		d = { "<cmd>lua require('textcase').current_word('to_dash_case')<cr>", "Dash Case" },
		n = { "<cmd>lua require('textcase').current_word('to_constant_case')<cr>", "Constant Case" },
		o = { "<cmd>lua require('textcase').current_word('to_dot_case')<cr>", "Dot Case" },
		a = { "<cmd>lua require('textcase').current_word('to_phrase_case')<cr>", "Phrase Case" },
		c = { "<cmd>lua require('textcase').current_word('to_camel_case')<cr>", "Camel Case" },
		p = { "<cmd>lua require('textcase').current_word('to_pascal_case')<cr>", "Pascal Case" },
		t = { "<cmd>lua require('textcase').current_word('to_title_case')<cr>", "Title Case" },
		f = { "<cmd>lua require('textcase').current_word('to_path_case')<cr>", "Path Case" },
		U = { "<cmd>lua require('textcase').lsp_rename('to_upper_case')<cr>", "Upper Case" },
		L = { "<cmd>lua require('textcase').lsp_rename('to_lower_case')<cr>", "Lower Case" },
		S = { "<cmd>lua require('textcase').lsp_rename('to_snake_case')<cr>", "Snake Case" },
		D = { "<cmd>lua require('textcase').lsp_rename('to_dash_case')<cr>", "Dash Case" },
		N = { "<cmd>lua require('textcase').lsp_rename('to_constant_case')<cr>", "Constant Case" },
		O = { "<cmd>lua require('textcase').lsp_rename('to_dot_case')<cr>", "Dot Case" },
		A = { "<cmd>lua require('textcase').lsp_rename('to_phrase_case')<cr>", "Phrase Case" },
		C = { "<cmd>lua require('textcase').lsp_rename('to_camel_case')<cr>", "Camel Case" },
		P = { "<cmd>lua require('textcase').lsp_rename('to_pascal_case')<cr>", "Pascal Case" },
		T = { "<cmd>lua require('textcase').lsp_rename('to_title_case')<cr>", "Title Case" },
		F = { "<cmd>lua require('textcase').lsp_rename('to_path_case')<cr>", "Path Case" },
	},

	r = {
		name = "rename",
		s = { "<cmd>RenameState<cr>", "State" },
		r = { "<cmd>IncRename<cr>", "Rename Symbole" },
		R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Buffer" },
	},
	s = {
		name = "surround",
		s = { "<Plug>SurroundAddVisual", "Add Visual" },
		y = { "<Plug>SurroundAddNormal", "Add Normal" },
		d = { "<Plug>SurroundDelete", "Delete" },
		r = { "<Plug>SurroundReplace", "Replace" },
		q = { "<Plug>SurroundToggleQuotes", "Toggle Quotes" },
		b = { "<Plug>SurroundToggleBrackets", "Toggle Brackets" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["b"] = {
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		"Buffers",
	},
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["q"] = { "<cmd>q!<CR>", "Quit" },
	["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
	["f"] = {
		"<cmd>Telescope find_files<cr>",
		"Find files",
	},

	a = {
		name = "Aerial",
		a = { "<cmd>AerialToggle<cr>", "Toggle" },
		O = { "<cmd>AerialOpenAll<cr>", "Open All" },
		C = { "<cmd>AerialCloseAll<cr>", "Close All" },
		t = { "<cmd>AerialTreeToggle<cr>", "Tree Toggle" },
		c = { "<cmd>AerialTreeCloseAll<cr>", "Tree Close ALL" },
		n = { "<cmd>AerialNext<cr>", "Next" },
		N = { "<cmd>AerialPrev<cr>", "Next" },
	},
	d = {
		name = "Diagnostics",
		l = { "<cmd>Telescope diagnostics<cr>", "list diagnostics" },
		n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "next diagnostic" },
		e = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "previous diagnostic" },
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint" },
		B = { "<cmd>lua require'dap'.toggle_breakpoint(vim.fn.input('Log point message: '))<cr>", "toggle breakpoint" },
		h = { "<cmd>lua require'dap'.continue()<cr>", "Launch/resume execution" },
	},
	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	g = {
		name = "Git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		n = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		e = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
	},

	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = {
			"<cmd>Telescope lsp_document_diagnostics<cr>",
			"Document Diagnostics",
		},
		w = {
			"<cmd>Telescope lsp_workspace_diagnostics<cr>",
			"Workspace Diagnostics",
		},
		f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
		n = {
			"<cmd>lua vim.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},
		e = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
	},

	r = {
		name = "Rust",
		{
			r = { "<cmd>lua _CARGO_RUN()<cr>", "Cargo run" },
		},
	},

	S = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		E = { "<cmd>Noice errors<cr>", "Errors" },
		H = { "<cmd>Noice history<cr>", "Message History" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		m = { "<cmd>Telescope media_files<cr>", "Media files" },
		N = { "<cmd>Telescope manix<cr>", "Nix Docs" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		T = { "<cmd>TodoTelescope<CR>", "Todos" },
		F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
		P = { "<cmd>Telescope projects<cr>", "Projects" },
		S = { "<cmd>Telescope luasnip<cr>", "Snippets" },
		U = { "<cmd>UrlView<cr>", "Url viewer" },
	},

	s = {
		name = "Split",
		S = { "<cmd>wincmd=<cr>", "Evenly" },
		s = { "<cmd>vsplit<cr>", "Right" },
		h = { "<cmd>split<cr>", "Bottom" },
	},

	T = {
		name = "Tab",
		T = { "<cmd>tabnext<cr>", "Next" },
		t = { "<cmd>tabnew<cr>", "New" },
		c = { "<cmd>tabclose<cr>", "Close" },
	},

	t = {
		name = "Toggle",
		a = { "<cmd>Alpha<cr>", "Alpha" },
		d = { "<cmd>lua _DENO_TOGGLE()<cr>", "Deno" },
		u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
		s = { "<cmd>lua _BTM_TOGGLE()<cr>", "Bottom" },
		g = { "<cmd>lua _GLOW_TOGGLE()<cr>", "GLOW" },
		p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
		t = { "<cmd>ToggleTerm direction=float<cr>", "Terminal Float" },
		--[[ h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" }, ]]
		--[[ v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" }, ]]
		A = { "<cmd>ASToggle<CR>", "Auto-Save" },
		C = { "<cmd>HighlightColorsToggle<CR>", "Highlight Colors" },
		T = { "<cmd>TodoTrouble<CR>", "Todos" },
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(goto_mappings, goto_opts)
