return {
  "Mofiqul/dracula.nvim",
  priority = 1000,
  config = function()
    require("dracula").setup({
      italic_comment = true,
      transparent_bg = true,  -- Enable transparent background
    })
    vim.cmd.colorscheme "dracula"

    -- Additional transparency settings to match Terminator background
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
  end,
}
