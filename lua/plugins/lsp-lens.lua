-- import plugin safely
local setup, lsplens = pcall(require, "lsp-lens")
if not setup then
  return
end

-- configure/enable gitsigns
lsplens.setup()
