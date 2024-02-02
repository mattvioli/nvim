return {
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
     key = {
   { "<leader>lg", ":LazyGit<CR>", desc = "Open lazygit" }
  }
}
