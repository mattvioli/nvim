return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    -- used to enable autocompletion (assign to every lsp server config)

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local base_on_attach = vim.lsp.config.eslint.on_attach
    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.lsp.config['eslint'] = {
      capabilities = capabilities,
      -- Command and arguments to start the server.
      cmd = { 'vscode-eslint-language-server', '--stdio' },
      -- Filetypes to automatically attach to.
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' },
      -- Sets the "workspace" to the directory where any of these files is found.
      -- Files that share a root directory will reuse the LSP server connection.
      -- Nested lists indicate equal priority, see |vim.lsp.Config|.
      root_markers = { { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' } },
      init_options = {
        provideFormatter = true, -- Enable formatting support
        codeAction = {
          disableRuleComment = {
            location = "separateLine",
          },
          showDocumentation = {
            enable = true,
          }
        }
      },
      on_attach = function(client, bufnr)
        if not base_on_attach then return end

        base_on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "LspEslintFixAll",
        })
      end,
    }

    vim.lsp.config['html'] = {
      capabilities = capabilities,
      -- Command and arguments to start the server.
      cmd = { "vscode-html-language-server", "--stdio" },
      -- Filetypes to automatically attach to.
      filetypes = { 'html', 'markdown' },
      -- Sets the "workspace" to the directory where any of these files is found.
      -- Files that share a root directory will reuse the LSP server connection.
      -- Nested lists indicate equal priority, see |vim.lsp.Config|.
      root_markers = { { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' } },
      init_options = {
        provideFormatter = true, -- Enable formatting support
      },
    }

    vim.lsp.config['ts_ls'] = {
      capabilities = capabilities,
      -- Command and arguments to start the server.
      cmd = { 'typescript-language-server', '--stdio' },
      -- Filetypes to automatically attach to.
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      -- Sets the "workspace" to the directory where any of these files is found.
      -- Files that share a root directory will reuse the LSP server connection.
      -- Nested lists indicate equal priority, see |vim.lsp.Config|.
      root_markers = { { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' } },
      init_options = {
        hostInfo = "neovim"
      },
    }

    vim.lsp.config['cssls'] = {
      capabilities = capabilities,
      cmd = { 'vscode-css-language-server', '--stdio' },
      filetypes = { 'css', 'scss', 'less' },
      init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
      root_markers = { 'package.json', '.git' },
      settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
      },
    }

    vim.lsp.config['hls'] = {
      capabilities = capabilities,
      cmd = { 'haskell-language-server-wrapper', '--lsp' },
      filetypes = { 'haskell', 'lhaskell' },
   }

    vim.lsp.config['emmet_ls'] = {
      capabilities = capabilities,
      cmd = { 'emmet-ls', '--stdio' },
      filetypes = {
        'astro',
        'css',
        'eruby',
        'html',
        'htmlangular',
        'htmldjango',
        'javascriptreact',
        'less',
        'pug',
        'sass',
        'scss',
        'svelte',
        'templ',
        'typescriptreact',
        'vue',
      },
      root_markers = { '.git' },
    }

    vim.lsp.config['luals'] = {
      capabilities = capabilities,
      -- Command and arguments to start the server.
      cmd = { 'lua-language-server' },
      -- Filetypes to automatically attach to.
      filetypes = { 'lua' },
      -- Sets the "workspace" to the directory where any of these files is found.
      -- Files that share a root directory will reuse the LSP server connection.
      -- Nested lists indicate equal priority, see |vim.lsp.Config|.
      root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
              path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most
            -- likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
              'lua/?.lua',
              'lua/?/init.lua',
            },
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths
              -- here.
              -- '${3rd}/luv/library'
              -- '${3rd}/busted/library'
            }
            -- Or pull in all of 'runtimepath'.
            -- NOTE: this is a lot slower and will cause issues when working on
            -- your own configuration.
            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
            -- library = {
            --   vim.api.nvim_get_runtime_file('', true),
            -- }
          }
        })
      end,
      -- Specific settings to send to the server. The schema is server-defined.
      -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          }
        }
      }
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my.lsp', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- if not client then
        --   return
        -- end
        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|

        -- if client:supports_method('textDocument/completion') then
        --   -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        --   -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        --   -- client.server_capabilities.completionProvider.triggerCharacters = chars
        --
        --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        -- end
        --
        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            end,
          })
        end
      end,
    })
  end,
}
