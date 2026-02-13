return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- C / C++ / Qt
          -- Formatters
          null_ls.builtins.formatting.clang_format.with({
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
            extra_args = {
              "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 100}",
            },
          }),
          -- Linters
          null_ls.builtins.diagnostics.cppcheck.with({
            extra_args = { "--enable=warning,style,performance,portability", "--language=c++" },
          }),
          require("none-ls.diagnostics.cpplint"),

          -- Python
          -- Formatters
          null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length", "100" },
          }),
          null_ls.builtins.formatting.isort,
          -- Linters
          require("none-ls.diagnostics.flake8").with({
            extra_args = { "--max-line-length", "100" },
          }),

          -- CMake
          null_ls.builtins.formatting.cmake_format,
          null_ls.builtins.diagnostics.cmake_lint,

          -- XML (ROS launch files)
          null_ls.builtins.formatting.xmllint,
        },

        -- Format on save
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
              end,
            })
          end
        end,
      })

      -- Format keymap
      vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, { desc = "Format file" })
      vim.keymap.set('v', '<leader>gf', function()
        vim.lsp.buf.format({ range = {} })
      end, { desc = "Format selection" })
    end,
  },
}
