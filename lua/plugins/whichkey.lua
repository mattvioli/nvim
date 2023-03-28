local setup, whichkey = pcall(require, "which-key")

if not setup then
	return
end

vim.o.timeout = true
vim.o.timeoutlen = 300

whichkey.setup()
