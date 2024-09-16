-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	-- cmdheight = 2 ,-- more space in the neovim command line for displaying messages
	laststatus = 3, -- one status bar for all splits
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	foldmethod = "manual", -- folding set to "expr" for treesitter based folding
	foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
	hidden = true, -- required to keep multiple buffers and open multiple buffers
	hlsearch = false, -- keep highlighting matches of the previous search
	ignorecase = true, -- ignore case in search patterns
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 0, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 500, -- time to wait for a mapped sequence to complete (in milliseconds)
	title = true, -- set the title of window to the value of the titlestring
	titlestring = "%<%F%=%l/%L - nvim", -- what the title of the window will be set to
	undodir = vim.fn.stdpath("cache") .. "/undo",
	undofile = true, -- enable persistent undo
	updatetime = 300, -- faster completion
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 3, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	linebreak = true,
	breakindent = true,
	spell = false,
	spelllang = "en",
	scrolloff = 8, -- lines away from bottom
	sidescrolloff = 8, -- columns away from side
	--[[ statuscolumn = "%s%{v:relnum?v:relnum:v:lnum}%C", -- align relative number with line number ]]
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
