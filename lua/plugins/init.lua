return {	{"nvim-lua/plenary.nvim"}, -- lua functions that many plugins use

	{"bluz71/vim-nightfly-guicolors"}, -- preferred colorscheme

	{"christoomey/vim-tmux-navigator"}, -- tmux & split window navigation

	{"szw/vim-maximizer"}, -- maximizej and restores current window

	-- essential plugins
	{"tpope/vim-surround"}, -- add, delete, change surroundings (it's awesome)
	{"inkarkat/vim-ReplaceWithRegister"}, -- replace with register contents using motion (gr + motion)

	-- commenting with gc
 {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    },
    lazy = false,
},

	-- file explorer
	{"nvim-tree/nvim-tree.lua"},

	-- vs-code like icons
	{"nvim-tree/nvim-web-devicons"},

	-- lazy git
	{"kdheepak/lazygit.nvim"},

	-- fuzzy finding w/ telescope
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	}, -- fuzzy finder via telescope

	-- autocompletion
	{"hrsh7th/cmp-buffer"}, -- source for text in buffer
	{"hrsh7th/cmp-path"}, -- source for file system paths

	-- snippets
	{"L3MON4D3/LuaSnip"}, -- snippet engine
	{"saadparwaiz1/cmp_luasnip"}, -- for autocompletion
	{"rafamadriz/friendly-snippets"}, -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	{"williamboman/mason-lspconfig.nvim"}, -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	{"hrsh7th/cmp-nvim-lsp"}, -- for autocompletion

	-- enhanced lsp uis
	{"jose-elias-alvarez/typescript.nvim"}, -- additional functionality for typescript server (e.g. rename file & update imports)
	{"onsails/lspkind.nvim"}, -- vs-code like icons for autocompletion

	-- formatting & linting
	{"nvimtools/none-ls.nvim"}, -- configure formatters & linters
	{"jay-babu/mason-null-ls.nvim",
    dependencies = {
			{ "williamboman/mason.nvim" },
			{ "nvimtools/none-ls.nvim" },
		}}, -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag" -- autoclose tags
    }
	},

	-- auto closing
	{"windwp/nvim-autopairs"}, -- autoclose parens, brackets, quotes, etc...

	-- git integration
	{"lewis6991/gitsigns.nvim"}, -- show line modifications on left hand side


	-- Displays possible keybindings
	{ "folke/which-key.nvim" },

	-- Better terminal experience
	{ "akinsho/toggleterm.nvim"},

	-- Code folding
	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },

	{ "folke/neodev.nvim", opts = {} },

	-- better error line displays
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},


  -- code refactoring
 {
      "ThePrimeagen/refactoring.nvim",
     dependencies = {
          {"nvim-lua/plenary.nvim"},
          {"nvim-treesitter/nvim-treesitter"}
      }
  },

  -- React extracting
	{ "napmn/react-extract.nvim" },

  -- lsp-lens
 {'VidocqH/lsp-lens.nvim'},

}
