return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	opts = {
		servers = {
			lua_ls = {},
			ts_ls = {
				root_dir = function(fname)
					local util = require("lspconfig.util")
					return util.root_pattern(".git")(fname)
						or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
				end,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "relative",
						importModuleSpecifierEnding = "minimal",
					},
				},
			},
			html = {},
			emmet_ls = {
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			},
			cssls = {},
			pyright = {},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.servers) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- `opts[server].capabilities, if you've defined it
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
	keys = {
		{ "gR", "<cmd>Telescope lsp_references<CR>", desc = "Show LSP references" },
		{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
		{ "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "Show LSP definitions" },
		{ "gi", "<cmd>Telescope lsp_implementations<CR>", desc = "Show LSP implementations" },
		{ "gt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Show LSP type definitions" },
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions", mode = { "n", "v" } },
		{ "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename" },
		{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics" },
		{ "<leader>d", vim.diagnostic.open_float, desc = "Show line diagnostics" },
		{ "[d", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
		{ "]d", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
		{ "K", vim.lsp.buf.hover, desc = "Show documentation for what is under cursor" },
		{ "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP" },
	},
}
