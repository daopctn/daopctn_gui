return {
  "echasnovski/mini.base16",
  version = false,
  priority = 1000,
  config = function()
    require("mini.base16").setup({
      palette = {
        base00 = "#0d1117", -- background
        base01 = "#161b22", -- surface / cursorline
        base02 = "#1c2128", -- selection / raised
        base03 = "#6e7681", -- comments (readable but dim)
        base04 = "#9aa3ad", -- inactive fg / line numbers
        base05 = "#e8eaed", -- default fg — snow
        base06 = "#b9c1cb", -- light fg
        base07 = "#ffffff", -- bright white
        base08 = "#bf6a5e", -- brick — constants, numbers, errors
        base09 = "#d0746e", -- bright brick — bold errors
        base0A = "#9aa3ad", -- warm grey — types, classes
        base0B = "#8a97a3", -- muted grey — strings (distinct from snow)
        base0C = "#6fb3d6", -- light blue — regex, special strings
        base0D = "#4a9eff", -- THE blue — functions, links
        base0E = "#74b4ff", -- bright blue — keywords
        base0F = "#bf6a5e", -- brick repeat — deprecated/embedded
      },
      use_cterm = true,
    })

    -- Transparent background (match terminal)
    vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC",    { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn",  { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr",      { bg = "none" })
  end,
}
