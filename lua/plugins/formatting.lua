return {
	"stevearc/conform.nvim",
	event = { "BufReadPre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			javascript = { "prettierd", "eslint_d" },
			typescript = { "prettierd", "eslint_d" },
			javascriptreact = { "prettierd", "eslint_d" },
			typescriptreact = { "eslint_d", "eslint_d" },
			css = { "prettierd", "eslint_d" },
			html = { "prettierd", "eslint_d" },
			json = { "prettierd", "eslint_d" },
			yaml = { "prettierd", "eslint_d" },
			markdown = { "prettierd", "eslint_d" },
			graphql = { "prettierd", "eslint_d" },
			lua = { "stylua" },
			python = { "isort", "black" },
		},
		format_on_save = {
			lsp_fallback = true,
			timeout_ms = 5000,
		},
	},
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>mp",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
