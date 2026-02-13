return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat({
            "                                                                      ",
            "       ▄▄                                                             ",
            "       ██                                            ██               ",
            "  ▄███▄██   ▄█████▄   ▄████▄   ██▄███▄    ▄█████▄  ███████   ██▄████▄ ",
            " ██▀  ▀██   ▀ ▄▄▄██  ██▀  ▀██  ██▀  ▀██  ██▀    ▀    ██      ██▀   ██ ",
            " ██    ██  ▄██▀▀▀██  ██    ██  ██    ██  ██          ██      ██    ██ ",
            " ▀██▄▄███  ██▄▄▄███  ▀██▄▄██▀  ███▄▄██▀  ▀██▄▄▄▄█    ██▄▄▄   ██    ██ ",
            "   ▀▀▀ ▀▀   ▀▀▀▀ ▀▀    ▀▀▀▀    ██ ▀▀▀      ▀▀▀▀▀      ▀▀▀▀   ▀▀    ▀▀ ",
            "                               ██                                     ",
            "                                                                      ",
          }, "\n"),
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            { icon = " ", key = "w", desc = "Find Word", action = ":Telescope live_grep" },
            { icon = " ", key = "s", desc = "Find in Files", action = ":Telescope grep_string" },
            { icon = " ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "d", desc = "Show Docs", action = ":help" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
