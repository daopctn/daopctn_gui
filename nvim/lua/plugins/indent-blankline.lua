return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local hooks = require("ibl.hooks")

      -- Set highlights before setup
      local function set_ibl_highlights()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b3f51" })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#3b3f51" })
      end

      -- Register so they survive colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, set_ibl_highlights)

      -- Also re-apply after any colorscheme load
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_ibl_highlights,
      })

      -- Apply now
      set_ibl_highlights()

      require("ibl").setup({
        indent = {
          char = "│",
          highlight = "IblIndent",
        },
        scope = {
          enabled = false, -- handled by mini.indentscope
        },
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      local scope = require("mini.indentscope")
      scope.setup({
        symbol = "│",
        draw = {
          delay = 50,
          animation = scope.gen_animation.cubic({ easing = "in-out", duration = 100, unit = "total" }),
        },
      })

      local function set_scope_hl()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#ff79c6" })
      end

      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_scope_hl })
      set_scope_hl()
    end,
  },
}
