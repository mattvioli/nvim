-- import plugin safely
local setup, neotest = pcall(require, "neotest")
if not setup then
  return
end

neotest.setup({
    adapters = {
    require('neotest-jest')({
          jestCommand = "npm test --",
        }),
            require('neotest-mocha')({
          command = "npm test --",

        }),

  }  }
    )

