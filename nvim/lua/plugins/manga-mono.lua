return {
  "echasnovski/mini.base16",
  version = false,
  priority = 1000,
  config = function()
    require("mini.base16").setup({
      palette = {
        base00 = "#0d1117",        -- background
        base01 = "#161b22",       -- surface / cursorline
        base02 = "#1c2128",        -- selection / raised
        base03 = "#6e7681",          -- comments
        base04 = "#9aa3ad",        -- inactive fg / line numbers
        base05 = "#e8eaed",          -- default fg
        base06 = "#b9c1cb",          -- light fg
        base07 = "#e8eaed",       -- bright white
        base08 = "#bf6a5e",         -- constants, numbers, errors
        base09 = "#d0746e",  -- bold errors
        base0A = "#9aa3ad",        -- types, classes
        base0B = "#8fa6b5",       -- strings
        base0C = "#6fb3d6",    -- regex, special strings
        base0D = "#4a9eff",          -- functions, links
        base0E = "#74b4ff",   -- keywords
        base0F = "#bf6a5e",         -- deprecated/embedded
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
