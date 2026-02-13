return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",           -- Lua
          "pyright",          -- Python
          "clangd",           -- C/C++
          "rust_analyzer",    -- Rust
          "ts_ls",            -- TypeScript/JavaScript
          "bashls",           -- Bash
          "jsonls",           -- JSON
          "yamlls",           -- YAML
        },
      })
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {})

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("ts_ls", {})
      vim.lsp.config("bashls", {})
      vim.lsp.config("jsonls", {})
      vim.lsp.config("yamlls", {})

      vim.lsp.enable({
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "pyright",
        "ts_ls",
        "bashls",
        "jsonls",
        "yamlls",
      })

      -- Diagnostic float window background
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#f8f8f2", bg = "#1e1f29" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#6272a4", bg = "#1e1f29" })

      -- Show diagnostic messages as virtual text and in float
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        float = {
          border = "rounded",
          source = true,
        },
      })

      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show diagnostic" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })

    end,
  },
}
