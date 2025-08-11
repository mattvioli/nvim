return {

  { "nvim-lua/plenary.nvim" }, -- lua functions that many plugins use

  -- enhanced lsp uis
  { "jose-elias-alvarez/typescript.nvim" }, -- additional functionality for typescript server (e.g. rename file & update imports)
  { "onsails/lspkind.nvim" },               -- vs-code like icons for autocompletion
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
