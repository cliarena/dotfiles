local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 50,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "vertical",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		height = 80,
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "ii", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-n>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-e>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

local cargo_run = Terminal:new({
	cmd = "nix run",
	direction = "horizontal",
	size = 12,
	close_on_exit = false,
	hidden = true,
})

function _CARGO_RUN()
	cargo_run:toggle()
end

local deno = Terminal:new({ cmd = "deno", direction = "float", hidden = true })

function _DENO_TOGGLE()
	deno:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", direction = "float", hidden = true })

function _NCDU_TOGGLE()
	ncdu:toggle()
end

local btm = Terminal:new({ cmd = "btm", direction = "float", hidden = true })

function _BTM_TOGGLE()
	btm:toggle()
end

local glow = Terminal:new({ cmd = "glow", direction = "float", hidden = true })

function _GLOW_TOGGLE()
	glow:toggle()
end

local python = Terminal:new({ cmd = "python", direction = "float", hidden = true })

function _PYTHON_TOGGLE()
	python:toggle()
end
