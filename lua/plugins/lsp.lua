local lsp = vim.lsp

local eslint_config_files = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local util = require 'lspconfig.util'
    vim.lsp.config['eslint'] = {
      cmd = { 'vscode-eslint-language-server', '--stdio' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
        'svelte',
        'astro',
        'htmlangular',
      },
      workspace_required = true,
      on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(0, 'LspEslintFixAll', function()
          client:request_sync('workspace/executeCommand', {
            command = 'eslint.applyAllFixes',
            arguments = {
              {
                uri = vim.uri_from_bufnr(bufnr),
                version = lsp.util.buf_versions[bufnr],
              },
            },
          }, nil, bufnr)
        end, {})
      end,
      root_dir = function(bufnr, on_dir)
        -- The project root is where the LSP can be started from
        -- As stated in the documentation above, this LSP supports monorepos and simple projects.
        -- We select then from the project root, which is identified by the presence of a package
        -- manager lock file.
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        -- Give the root markers equal priority by wrapping them in a table
        root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
            or vim.list_extend(root_markers, { '.git' })
        -- We fallback to the current working directory if no project root is found
        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

        -- We know that the buffer is using ESLint if it has a config file
        -- in its directory tree.
        --
        -- Eslint used to support package.json files as config files, but it doesn't anymore.
        -- We keep this for backward compatibility.
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local eslint_config_files_with_package_json =
            util.insert_package_json(eslint_config_files, 'eslintConfig', filename)
        local is_buffer_using_eslint = vim.fs.find(eslint_config_files_with_package_json, {
          path = filename,
          type = 'file',
          limit = 1,
          upward = true,
          stop = vim.fs.dirname(project_root),
        })[1]
        if not is_buffer_using_eslint then
          return
        end

        on_dir(project_root)
      end,
      -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
      settings = {
        validate = 'on',
        packageManager = nil,
        useESLintClass = false,
        experimental = {
          useFlatConfig = true,
        },
        codeActionOnSave = {
          enable = true,
          mode = 'all',
        },
        format = true,
        quiet = false,
        onIgnoredFiles = 'off',
        rulesCustomizations = {},
        run = 'onType',
        problems = {
          shortenToSingleLine = false,
        },
        -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
        -- This path is relative to the workspace folder (root dir) of the server instance.
        nodePath = '',
        -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
        workingDirectory = { mode = 'auto' },
        codeAction = {
          disableRuleComment = {
            enable = true,
            location = 'separateLine',
          },
          showDocumentation = {
            enable = true,
          },
        },
      },
      before_init = function(_, config)
        -- The "workspaceFolder" is a VSCode concept. It limits how far the
        -- server will traverse the file system when locating the ESLint config
        -- file (e.g., .eslintrc).
        local root_dir = config.root_dir

        if root_dir then
          config.settings = config.settings or {}
          config.settings.workspaceFolder = {
            uri = root_dir,
            name = vim.fn.fnamemodify(root_dir, ':t'),
          }

          -- Support flat config files
          -- They contain 'config' in the file name
          local flat_config_files = vim.tbl_filter(function(file)
            return file:match('config')
          end, eslint_config_files)

          for _, file in ipairs(flat_config_files) do
            local found_files = vim.fn.globpath(root_dir, file, true, true)

            -- Filter out files inside node_modules
            local filtered_files = {}
            for _, found_file in ipairs(found_files) do
              if string.find(found_file, '[/\\]node_modules[/\\]') == nil then
                table.insert(filtered_files, found_file)
              end
            end

            if #filtered_files > 0 then
              config.settings.experimental = config.settings.experimental or {}
              config.settings.experimental.useFlatConfig = true
              break
            end
          end

          -- Support Yarn2 (PnP) projects
          local pnp_cjs = root_dir .. '/.pnp.cjs'
          local pnp_js = root_dir .. '/.pnp.js'
          if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
            local cmd = config.cmd
            config.cmd = vim.list_extend({ 'yarn', 'exec' }, cmd)
          end
        end
      end,
      handlers = {
        ['eslint/openDoc'] = function(_, result)
          if result then
            vim.ui.open(result.url)
          end
          return {}
        end,
        ['eslint/confirmESLintExecution'] = function(_, result)
          if not result then
            return
          end
          return 4 -- approved
        end,
        ['eslint/probeFailed'] = function()
          vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
          return {}
        end,
        ['eslint/noLibrary'] = function()
          vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
          return {}
        end,
      },
    }


    -- {
    --   capabilities = capabilities,
    --   -- Command and arguments to start the server.
    --   cmd = { 'vscode-eslint-language-server', '--stdio' },
    --   -- Filetypes to automatically attach to.
    --   filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' },
    --   -- Sets the "workspace" to the directory where any of these files is found.
    --   -- Files that share a root directory will reuse the LSP server connection.
    --   -- Nested lists indicate equal priority, see |vim.lsp.Config|.
    --   root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
    --   init_options = {
    --     provideFormatter = true, -- Enable formatting support
    --     codeAction = {
    --       disableRuleComment = {
    --         location = "separateLine",
    --       },
    --       showDocumentation = {
    --         enable = true,
    --       }
    --     }
    --   },
    --   on_attach = function(client, bufnr)
    --     if not base_on_attach then return end
    --
    --     base_on_attach(client, bufnr)
    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --       buffer = bufnr,
    --       command = "LspEslintFixAll",
    --     })
    --   end,
    -- }

    vim.lsp.config['html'] = {
      capabilities = capabilities,
      -- Command and arguments to start the server.
      cmd = { "vscode-html-language-server", "--stdio" },
      -- Filetypes to automatically attach to.
      filetypes = { 'html', 'markdown' },
      -- Sets the "workspace" to the directory where any of these files is found.
      -- Files that share a root directory will reuse the LSP server connection.
      -- Nested lists indicate equal priority, see |vim.lsp.Config|.
      root_markers = { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' },
      init_options = {
        provideFormatter = true, -- Enable formatting support
      },
    }

    vim.lsp.config['ts_ls'] = {
      capabilities = capabilities,
      init_options = { hostInfo = 'neovim' },
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      root_markers = { 'tsconfig.json', 'tsconfig.base.json', 'jsconfig.json', 'package.json', '.git' },
      handlers = {
        -- handle rename request for certain code actions like extracting functions / types
        ['_typescript.rename'] = function(_, result, ctx)
          local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
          vim.lsp.util.show_document({
            uri = result.textDocument.uri,
            range = {
              start = result.position,
              ['end'] = result.position,
            },
          }, client.offset_encoding)
          vim.lsp.buf.rename()
          return vim.NIL
        end,
      },
      commands = {
        ['editor.action.showReferences'] = function(command, ctx)
          local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
          local file_uri, position, references = unpack(command.arguments)

          local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
          vim.fn.setqflist({}, ' ', {
            title = command.title,
            items = quickfix_items,
            context = {
              command = command,
              bufnr = ctx.bufnr,
            },
          })

          vim.lsp.util.show_document({
            uri = file_uri,
            range = {
              start = position,
              ['end'] = position,
            },
          }, client.offset_encoding)

          vim.cmd('botright copen')
        end,
      },
      on_attach = function(client, bufnr)
        -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
        -- `vim.lsp.buf.code_action()` if specified in `context.only`.
        vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
          local source_actions = vim.tbl_filter(function(action)
            return vim.startswith(action, 'source.')
          end, client.server_capabilities.codeActionProvider.codeActionKinds)

          vim.lsp.buf.code_action({
            context = {
              only = source_actions,
            },
          })
        end, {})
      end,
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

    vim.lsp.config['markdown_oxide'] = {
      root_markers = { '.git', '.obsidian', '.moxide.toml' },
      filetypes = { 'markdown' },
      cmd = { 'markdown-oxide' },
      on_attach = function(_, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspToday', function()
          vim.lsp.buf.execute_command { command = 'jump', arguments = { 'today' } }
        end, {
          desc = "Open today's daily note",
        })
        vim.api.nvim_buf_create_user_command(bufnr, 'LspTomorrow', function()
          vim.lsp.buf.execute_command { command = 'jump', arguments = { 'tomorrow' } }
        end, {
          desc = "Open tomorrow's daily note",
        })
        vim.api.nvim_buf_create_user_command(bufnr, 'LspYesterday', function()
          vim.lsp.buf.execute_command { command = 'jump', arguments = { 'yesterday' } }
        end, {
          desc = "Open yesterday's daily note",
        })
      end,
    }

    vim.lsp.config('rust_analyzer', {
      cmd = { "rust-analyzer" },
      settings = {
        ['rust-analyzer'] = {
          formatOnSave = true,
          diagnostics = {
            enable = false,
          }
        }
      }
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my.lsp', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if not client then
          return
        end
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
        -- if not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 5000 })
          end,
        })
        --   end
      end,
    })
  end,
  keys = {
    { "gR",         "<cmd>Telescope lsp_references<CR>",       desc = "Show LSP references" },
    { "gD",         vim.lsp.buf.declaration,                   desc = "Go to declaration" },
    { "gd",         "<cmd>Telescope lsp_definitions<CR>",      desc = "Show LSP definitions" },
    { "gi",         "<cmd>Telescope lsp_implementations<CR>",  desc = "Show LSP implementations" },
    { "gt",         "<cmd>Telescope lsp_type_definitions<CR>", desc = "Show LSP type definitions" },
    { "<leader>D",  "<cmd>Telescope diagnostics bufnr=0<CR>",  desc = "Show buffer diagnostics" },
    { "<leader>d",  vim.diagnostic.open_float,                 desc = "Show line diagnostics" },
    { "[d",         vim.diagnostic.goto_prev,                  desc = "Go to previous diagnostic" },
    { "]d",         vim.diagnostic.goto_next,                  desc = "Go to next diagnostic" },
    { "K",          vim.lsp.buf.hover,                         desc = "Show documentation for what is under cursor" },
    { "<leader>rs", ":LspRestart<CR>",                         desc = "Restart LSP" },
  },
}
