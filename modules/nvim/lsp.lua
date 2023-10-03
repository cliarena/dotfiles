local lspconfig = require("lspconfig")
lspconfig.bashls.setup({})
lspconfig.dockerls.setup({})
lspconfig.yamlls.setup({})
lspconfig.nil_ls.setup({})
lspconfig.denols.setup({})
lspconfig.grammarly.setup({})
lspconfig.jsonls.setup({})
lspconfig.rust_analyzer.setup({
	--[[ settings = { ]]
    --[[ ["rust-analyzer"] = { ]]
    --[[     -- enable clippy on save ]]
    --[[     checkOnSave = { ]]
    --[[       command = "clippy", ]]
    --[[     }, ]]
    --[[]]
    --[[   -- Other Settings ... ]]
    --[[   procMacro = { ]]
				--[[ enable = true, ]]
    --[[     ignored = { ]]
    --[[         leptos_macro = { ]]
    --[[             "server", ]]
    --[[             "component", ]]
    --[[         }, ]]
    --[[     }, ]]
    --[[   }, ]]
			-- Fix showing ssr blocks as dead code
			--[[ cargo = { ]]
   --[[      features = { "ssr" } -- features = ssr, for LSP support in leptos SSR functions ]]
   --[[    } ]]
  --[[ } ]]
  --[[ } ]]
})
lspconfig.jsonls.setup({})
lspconfig.html.setup({})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

lspconfig.tailwindcss.setup({
	filetypes = {
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"django-html",
		"edge",
		"eelixir",
		"ejs",
		"erb",
		"eruby",
		"gohtml",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"html-eex",
		"jade",
		"leaf",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"rust"
	},
	init_options = {
		userLanguages = {
			eelixir = "html-eex",
			eruby = "erb",
		},
	},
	settings = {
		tailwindCSS = {
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			experimental = {
				classRegex = {
					"tw`([^`]*)",
					'tw="([^"]*)',
					'tw={"([^"}]*)',
					"tw\\.\\w+`([^`]*)",
					"tw\\(.*?\\)`([^`]*)",
					"classes([^`]*$)",
				},
			},
			validate = true,
		},
	},
})
