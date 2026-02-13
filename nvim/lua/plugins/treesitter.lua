return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function(plugin)
    -- Add the runtime queries to Neovim's runtimepath
    vim.opt.runtimepath:append(plugin.dir .. "/runtime")

    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash", "c", "cpp", "diff", "html", "javascript",
        "json", "lua", "markdown", "python",
        "vim", "vimdoc", "yaml",
      },
    })

    -- Auto-enable treesitter highlighting for all buffers
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
