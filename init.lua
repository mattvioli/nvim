-- install lazy if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- lazy dependencies leader mapping to happend before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.rustfmt_autosave = 1

vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])

require("config.options")
require("config.keymaps")
require("config.lsp")
require("lazy").setup("plugins")
