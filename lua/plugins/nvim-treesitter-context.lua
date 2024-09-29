return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	opts = { mode = "cursor", enable = true, multiline_threshold = 1 },
}
