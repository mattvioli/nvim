return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  enabled = true,
  opts = { mode = "cursor" }
}
