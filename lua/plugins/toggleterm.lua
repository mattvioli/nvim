return  {
  'akinsho/toggleterm.nvim',
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  version = "*",
  config = true,
  key = {
  { "<leader>tt", ":ToggleTerm<CR>", desc = "Toggle terminal" }
}
}

