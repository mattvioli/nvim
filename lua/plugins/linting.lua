return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	opts = {
		linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
		},
	},
	config = function(_, opts)
		-- npm install -g eslint_d
		local lint = require("lint")
		lint.linters_by_ft = opts.linters_by_ft

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
			-- group = vim.api.augroup "Lint",
			group = vim.api.nvim_create_augroup("Lint", { clear = true }),
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}

-- https://github.com/mfussenegger/nvim-lint/issues/610 for a way around the eslint_d
