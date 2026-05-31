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
        base07 = "#ffffff",            -- bright white
        base08 = "#bf6a5e",         -- constants, numbers, errors
        base09 = "#e09a5a",            -- numbers/booleans (orange — distinct from brick by hue+lum)
        base0A = "#d4a574",            -- types, classes (warm amber)
        base0B = "#87a882",            -- strings (muted sage green)
        base0C = "#6fb3d6",            -- regex, special strings
        base0D = "#4a9eff",            -- functions, links
        base0E = "#74b4ff",            -- keywords
        base0F = "#4a3f3f",            -- deprecated/embedded (dim — clearly dead code)
      },
      use_cterm = true,
    })

  end,
}
