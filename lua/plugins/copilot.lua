return {
	"github/copilot.vim",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<leader>ce", "<Cmd>Copilot enable<CR>", desc = "Enable Co-pilot" },
		{ "<leader>cd", "<Cmd>Copilot disable<CR>", desc = "Disable Co-pilot" },
	},
	init = function()
		vim.cmd("silent! Copilot disable")
	end,
}
