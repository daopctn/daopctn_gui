return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function(plugin)
    -- Add the runtime queries to Neovim's runtimepath
    vim.opt.runtimepath:append(plugin.dir .. "/runtime")

    -- Also expose parsers restored from the offline bundle (offline/treesitter-parsers.tar.gz
    -- is extracted into ~/.local/share/nvim/site/parser/ by install.sh)
    local site_dir = vim.fn.stdpath("data") .. "/site"
    vim.opt.runtimepath:prepend(site_dir)

    -- Skip ensure_installed if parsers are already present (plugin dir or offline restore).
    -- This prevents failed download attempts when running without internet.
    local plugin_parser_dir = plugin.dir .. "/parser"
    local site_parser_dir   = site_dir .. "/parser"
    local has_parsers =
      (#vim.fn.glob(plugin_parser_dir .. "/*.so", false, true) > 0) or
      (#vim.fn.glob(site_parser_dir   .. "/*.so", false, true) > 0)

    require("nvim-treesitter").setup({
      ensure_installed = has_parsers and {} or {
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
