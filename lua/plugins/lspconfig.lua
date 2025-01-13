return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap -- for conciseness
		-- NOTE: This is incase linting doesn't work with nvim-lint
		-- lspconfig.eslint.setup({
		-- 	settings = { experimental = {
		-- 		useFlatConfig = false,
		-- 	} },
		-- 	on_attach = function(client, bufnr)
		-- 		vim.api.nvim_create_autocmd("BufWritePost", {
		-- 			buffer = bufnr,
		-- 			command = "EslintFixAll",
		-- 		})
		-- 	end,
		-- })
		local opts = { noremap = true, silent = true }
		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()
		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			detached = false,
			opts = {
				root_dir = function(fname)
					local util = require("lspconfig.util")
					return util.root_pattern(".git")(fname)
						or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
				end,
			},
		})
		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
		-- configure tailwindcss server
		-- lspconfig["tailwindcss"].setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = on_attach,
		-- })
		-- configure svelte server
		-- lspconfig["svelte"].setup({
		-- 	capabilities = capabilities,
		-- 	on_attach = function(client, bufnr)
		-- 		on_attach(client, bufnr)
		-- 		vim.api.nvim_create_autocmd("BufWritePost", {
		-- 			pattern = { "*.js", "*.ts" },
		-- 			callback = function(ctx)
		-- 				if client.name == "svelte" then
		-- 					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
		-- 				end
		-- 			end,
		-- 		})
		-- 	end,
		-- })
		-- configure prisma orm server
		lspconfig["prismals"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})
		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})
		-- configure python server
		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
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
