local dap_install = require("DapInstall.nvim")

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})
