return {
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		config = function()
			require("lsp_lines").setup()
		end,
	}
