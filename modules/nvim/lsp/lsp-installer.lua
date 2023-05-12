local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local nvim_lsp = require("lspconfig")
	nvim_lsp.tsserver.setup({
		-- Omitting some options
		root_dir = nvim_lsp.util.root_pattern("package.json"),
	})
	nvim_lsp.denols.setup({
		-- Omitting some options
		root_dir = nvim_lsp.util.root_pattern("deno.json"),
	})

	if server.name == "jsonls" then
		local jsonls_opts = require("user.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server.name == "yamlls" then
		local yamlls_opts = require("user.lsp.settings.yamlls")
		opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
	end

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("user.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server.name == "pyright" then
		local pyright_opts = require("user.lsp.settings.pyright")
		opts = vim.tbl_deep_extend("force", pyright_opts, opts)
	end

	if server.name == "rust_analyzer" then
		local rust_opts = require("user.lsp.settings.rust")
		-- opts = vim.tbl_deep_extend("force", rust_opts, opts)
		local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
		if not rust_tools_status_ok then
			return
		end

		rust_tools.setup(rust_opts)
		goto continue
	end

	if server.name == "tailwindcss" then
		opts = {
			-- capabilities = require('lsp.servers.tsserver').capabilities,
			filetypes = require("user.lsp.settings.tailwindcss").filetypes,
			-- handlers = handlers,
			init_options = require("user.lsp.settings.tailwindcss").init_options,
			on_attach = require("user.lsp.settings.tailwindcss").on_attach,
			settings = require("user.lsp.settings.tailwindcss").settings,
		}
	end
	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
	::continue::
end)
