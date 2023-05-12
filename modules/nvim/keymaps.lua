local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

map({ "n", "x" }, "n", "<Down>", opts)
map({ "n", "x" }, "e", "<Up>", opts)
map({ "n", "x" }, "h", "<Right>", opts)
map({ "n", "x" }, "k", "<Left>", opts)
--map({"n","x"}, "l", "<insert>", opts)
-- TODO: CamelCase Motion
-- map({"n","x"}, ",w", "<Plug>CamelCaseMotion_w", opts)
-- map({"n","x"}, ",b", "<Plug>CamelCaseMotion_b", opts)

-- Normal --
-- Better window navigation
map("n", "<C-n>", "<C-w>j", opts)
map("n", "<C-e>", "<C-w>k", opts)
map("n", "<C-h>", "<C-w><Right>", opts)
map("n", "<C-k>", "<C-w><Left>", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
map("n", "<S-h>", ":bnext<CR>", opts)
map("n", "<S-k>", ":bprevious<CR>", opts)

-- Navigate Lsp
-- map("n", "<S-h>", ":bnext<CR>", opts)

-- Move text up and down
map({ "n", "x" }, "<A-n>", "<Esc>:m .-2<CR>==", opts)
map({ "n", "x" }, "<A-e>", "<Esc>:m .+1<CR>==", opts)

-- Keeps original yanked text after past
map("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
--[[ map("i", "ii", "<ESC>", opts) ]]

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Toggle Auto-save
-- map("n", "<leader>n", ":ASToggle<CR>", opts)

-- Move text up and down
--map("v", "<A-k>", ":m .-2<CR>==", opts)
--map("v", "<A-j>", ":m .+1<CR>==", opts)

-- Visual Block --
-- Move text up and down
--map("x", "J", ":move '>+1<CR>gv-gv", opts)
--map("x", "K", ":move '<-2<CR>gv-gv", opts)
--map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
--map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)

-- Spliting
-- map("n", "<leader>ss", "<cmd>:vsplit<cr>", opts)
-- map("n", "<leader>sh", "<cmd>:split<cr>", opts)
--
--
-- map("n", "<leader>w", "<cmd>:w<cr>", opts)
-- map("n", "<leader>c", "<cmd>:bdelete<cr>", opts)
--
--
--
--
-- -- Nvimtree
-- map("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
--
--
-- -- Telescope
-- map("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
-- map("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = true }))<cr>", opts)
-- map("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)
-- map("n", "<leader>P", "<cmd>Telescope projects<cr>", opts)
