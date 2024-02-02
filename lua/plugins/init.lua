return {

  {"nvim-lua/plenary.nvim"}, -- lua functions that many plugins use

	-- essential plugins
	{"inkarkat/vim-ReplaceWithRegister"}, -- replace with register contents using motion (gr + motion)

	-- lazy git
    {
        "kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

	-- autocompletion
	{"hrsh7th/cmp-buffer"}, -- source for text in buffer
	{"hrsh7th/cmp-path"}, -- source for file system paths

	-- enhanced lsp uis
	{"jose-elias-alvarez/typescript.nvim"}, -- additional functionality for typescript server (e.g. rename file & update imports)
	{"onsails/lspkind.nvim"}, -- vs-code like icons for autocompletion

	-- Better terminal experience

	{ "folke/neodev.nvim", opts = {} },

}
