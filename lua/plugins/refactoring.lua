return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader>re", ":Refactor extract ", mode = "x" },
		{ "<leader>rv", ":Refactor extract_var ", mode = "x" },
		{ "<leader>rf", ":Refactor extract_to_file ", mode = "x" },
		{ "<leader>ri", ":Refactor inline_var", mode = { "n", "x" } },
		{ "<leader>rb", ":Refactor extract_block", mode = "n" },
		{ "<leader>rbf", ":Refactor extract_block_to_file", mode = "n" },
	},
	config = function()
		require("refactoring").setup()
	end,
}
