vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 2  -- Set line number column width to 2
vim.opt.background = "dark"  -- Options: "dark" or "light"
vim.opt.autoread = true
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath .. "/lua/lazy/init.lua") then
  -- lazy.nvim not found (not installed and not restored from offline bundle)
  -- Try to clone from GitHub
  vim.fn.system({ "rm", "-rf", lazypath })
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nIf offline, run bundle.sh first then install.sh to restore plugins.", "WarningMsg" },
      { "\nPress any key to exit..." },
    },   true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opts = {}

require("lazy").setup("plugins", opts)

-- Ensure line number settings are applied after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = false
    vim.opt.numberwidth = 2
  end,
})

-- Also set immediately
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 2

