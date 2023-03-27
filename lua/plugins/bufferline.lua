local setup, bufferline = pcall(require, "bufferline")

if not setup then
	return
end

bufferline.setup({
	options = {
		numbers = "none",
		diagnostics = "nvim_lsp",
		separator_style = "slant" or "padded_slant",
		show_tab_indicators = true,
	},
})
