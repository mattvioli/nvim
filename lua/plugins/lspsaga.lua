return {
    'nvimdev/lspsaga.nvim',
   event = 'LspAttach',
    opts = {
    -- keybinds for navigation in lspsaga window
    scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
    -- use enter to open file with definition preview
    definition = {
      edit = "<CR>",
    },
    ui = {
      colors = {
        normal_bg = "#022746",
      },
    },
  },
   dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" }
		},
}
