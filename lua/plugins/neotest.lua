return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"haydenmeade/neotest-jest",
		},
		opts = {
			adapters = {
				-- "neotest-jest",
				-- ["neotest-jest"] = {
				--   args = { "--detectOpenHandles", "--forceExit" },
				-- },
				["neotest-jest"] = {
					jestCommand = "pnpm test --bail -- --passWithNoTests",
					jestConfigFile = "jest.config.ts",
					jest_test_discovery = true,
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				},
			},
			discovery = {
				enabled = false,
			},
			status = { virtual_text = true },
			output = { open_on_run = true },
			running = {
				concurrent = true,
			},
		},
		config = function(_, opts)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						-- Replace newline and tab characters with space for more compact diagnostics
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			if opts.adapters then
				local adapters = {}
				for name, config in pairs(opts.adapters or {}) do
					if type(name) == "number" then
						if type(config) == "string" then
							config = require(config)
						end
						adapters[#adapters + 1] = config
					elseif config ~= false then
						local adapter = require(name)
						if type(config) == "table" and not vim.tbl_isempty(config) then
							local meta = getmetatable(adapter)
							if adapter.setup then
								adapter.setup(config)
							elseif meta and meta.__call then
								adapter(config)
							else
								error("Adapter " .. name .. " does not support setup")
							end
						end
						adapters[#adapters + 1] = adapter
					end
				end
				opts.adapters = adapters
			end

			require("neotest").setup(opts)
		end,
  -- stylua: ignore
  keys = {
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
  },
	},
}

-- return {
-- 	"nvim-neotest/neotest",
-- 	dependencies = {
-- 		"nvim-treesitter/nvim-treesitter",
-- 		"nvim-neotest/neotest-jest",
-- 	},
-- 	config = function()
-- 		require("neotest").setup({
-- 			adapters = {
-- 				require("neotest-jest")({
-- 					jestCommand = "pnpm test --bail --",
-- 					jestConfigFile = function(file)
-- 						if string.find(file, "/apps/") then
-- 							return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
-- 						end
-- 						if string.find(file, "/packages/") then
-- 							return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
-- 						end
--
-- 						if string.find(file, "/sites/") then
-- 							return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
-- 						end
--
-- 						return vim.fn.getcwd() .. "/jest.config.ts"
-- 					end,
-- 					env = { CI = true },
-- 					cwd = function(path)
-- 						return vim.fn.getcwd()
-- 					end,
-- 				}),
-- 			},
-- 		})
-- 	end,
-- 	keys = {
-- 		{
-- 			"<leader>tt",
-- 			function()
-- 				require("neotest").run.run(vim.fn.expand("%"))
-- 			end,
-- 			desc = "Run File",
-- 		},
-- 		{
-- 			"<leader>tT",
-- 			function()
-- 				require("neotest").run.run(vim.uv.cwd())
-- 			end,
-- 			desc = "Run All Test Files",
-- 		},
-- 		{
-- 			"<leader>tr",
-- 			function()
-- 				require("neotest").run.run()
-- 			end,
-- 			desc = "Run Nearest",
-- 		},
-- 		{
-- 			"<leader>tl",
-- 			function()
-- 				require("neotest").run.run_last()
-- 			end,
-- 			desc = "Run Last",
-- 		},
-- 		{
-- 			"<leader>ts",
-- 			function()
-- 				require("neotest").summary.toggle()
-- 			end,
-- 			desc = "Toggle Summary",
-- 		},
-- 		{
-- 			"<leader>to",
-- 			function()
-- 				require("neotest").output.open({ enter = true, auto_close = true })
-- 			end,
-- 			desc = "Show Output",
-- 		},
-- 		{
-- 			"<leader>tO",
-- 			function()
-- 				require("neotest").output_panel.toggle()
-- 			end,
-- 			desc = "Toggle Output Panel",
-- 		},
-- 		{
-- 			"<leader>tS",
-- 			function()
-- 				require("neotest").run.stop()
-- 			end,
-- 			desc = "Stop",
-- 		},
-- 	},
-- }
