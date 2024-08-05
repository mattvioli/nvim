return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			{ "<leader><tab>", group = "tabs" },
			{ "<leader>t", group = "test" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>c", group = "code" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>n", group = "swap next" },
			{ "<leader>p", group = "swap previous" },
			{ "<leader>s", group = "split window" },
			{ "<leader>f", group = "file/find" },
			{ "<leader>r", group = "refactor" },
			{ "<leader>g", group = "git" },
			{ "<leader>x", group = "diagnostics/quickfix" },
			{ "[", group = "prev" },
			{ "]", group = "next" },
			{ "g", group = "goto" },
			{ "gs", group = "surround" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add(opts.defaults)
	end,
	keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
}
