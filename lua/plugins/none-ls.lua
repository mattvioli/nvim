return 	{"nvimtools/none-ls.nvim",
config = function()
-- import none-ls plugin safely
local setup, none_ls = pcall(require, "none-ls")
if not setup then
	return
end

-- for conciseness
local formatting = none_ls.builtins.formatting -- to setup formatters
local diagnostics = none_ls.builtins.diagnostics -- to setup linters
local completion = none_ls.builtins.completion
local code_actions = none_ls.builtins.code_actions

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
none_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		--  "fo:checkhealtrmatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
		formatting.prettier, -- js/ts formatter
		formatting.stylua, -- lua formatter
		diagnostics.eslint_d,
		completion.spell,
		code_actions.refactoring,
		code_actions.xo,
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "none-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
  end}
