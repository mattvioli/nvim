return {
	"romgrk/barbar.nvim",
	lazy = false,
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
		animation = true,
		insert_at_start = true,
	},
	keys = {
		{ "<A-,>", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },
		{ "<A-.>", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
		{ "<A-<>", "<Cmd>BufferMovePrevious<CR>", desc = "Move previous buffer" },
		{ "<A->>", "<Cmd>BufferMoveNext<CR>", desc = "Move next buffer" },
		{ "<A-1>", "<Cmd>BufferGoto 1<CR>", desc = "Go to buffer 1" },
		{ "<A-2>", "<Cmd>BufferGoto 2<CR>", desc = "Go to buffer 2" },
		{ "<A-3>", "<Cmd>BufferGoto 3<CR>", desc = "Go to buffer 3" },
		{ "<A-4>", "<Cmd>BufferGoto 4<CR>", desc = "Go to buffer 4" },
		{ "<A-5>", "<Cmd>BufferGoto 5<CR>", desc = "Go to buffer 5" },
		{ "<A-6>", "<Cmd>BufferGoto 6<CR>", desc = "Go to buffer 6" },
		{ "<A-7>", "<Cmd>BufferGoto 7<CR>", desc = "Go to buffer 7" },
		{ "<A-8>", "<Cmd>BufferGoto 8<CR>", desc = "Go to buffer 8" },
		{ "<A-9>", "<Cmd>BufferGoto 9<CR>", desc = "Go to buffer 9" },
		{ "<A-0>", "<Cmd>BufferLast<CR>", desc = "Go to last buffer" },
		{ "<A-p>", "<Cmd>BufferPin<CR>", desc = "Pin/unpin buffer" },
		{
			"<A-c>",
			function()
				if vim.bo.modified then
					local choice =
						vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
					if choice == 1 then -- Yes
						vim.cmd.write()
						vim.cmd("BufferClose")
					elseif choice == 2 then -- No
						vim.cmd("BufferClose")
					end
				else
					vim.cmd("BufferClose")
				end
			end,
			desc = "Close buffer",
		},
		-- Wipeout buffer
		--                 :BufferWipeout
		-- Close commands
		{ "<leader>bac", "<Cmd>BufferCloseAllButCurrent<CR>", desc = "Close all but current" },

		{ "<leader>bac", "<Cmd>BufferCloseAllButPinned<CR>", desc = "Close all but pinned" },
		{ "<leader>bap", "<Cmd>BufferCloseAllButCurrent<CR>", desc = "Close all but current" },
		{ "<leader>ban", "<Cmd>BufferCloseAllButCurrentOrPinned<CR>", desc = "Close all but current or pinned" },
		{ "<leader>bcl", "<Cmd>BufferCloseBuffersLeft<CR>", desc = "Close buffers left" },
		{ "<leader>bcr", "<Cmd>BufferCloseBuffersRight<CR>", desc = "Close buffers right" },
		-- Magic buffer-picking mode
		{ "<C-p>", "<Cmd>BufferPick<CR>", desc = "Magic buffer-picking mode" },
		-- Sort automatically by...
		{ "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", desc = "Order buffer by number" },
		{ "<leader>bn", "<Cmd>BufferOrderByName<CR>", desc = "Order buffer by name" },
		{ "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", desc = "Order buffer by director" },
		{ "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", desc = "Order buffer by language" },
		{ "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", desc = "Order buffer by window number" },
	},
	version = "^1.0.0", -- optional: only update when a new 1.x version is released
}
