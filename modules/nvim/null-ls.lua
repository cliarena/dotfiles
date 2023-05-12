local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- IMPORTANT: null_ls is jus a workaround if lsp server or functionnality is not available
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local hover = null_ls.builtins.hover

null_ls.setup({
	debug = false,
	sources = {
		formatting.deno_fmt,
		formatting.stylua,
		formatting.rustfmt,
		formatting.taplo,
		formatting.nixfmt,

		hover.dictionary,
		hover.printenv,
	},
	on_attach = function(client, bufnr)
		--[[ require("lsp-format").on_attach(client) ]]
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
