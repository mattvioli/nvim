return {

	{ "nvim-lua/plenary.nvim" }, -- lua functions that many plugins use

	-- essential plugins
	{ "inkarkat/vim-ReplaceWithRegister" }, -- replace with register contents using motion (gr + motion)

	-- enhanced lsp uis
	{ "jose-elias-alvarez/typescript.nvim" }, -- additional functionality for typescript server (e.g. rename file & update imports)
	{ "onsails/lspkind.nvim" }, -- vs-code like icons for autocompletion

	-- Better terminal experience
	{ "folke/neodev.nvim", opts = {} },
}
