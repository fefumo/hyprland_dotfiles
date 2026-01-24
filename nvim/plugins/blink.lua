return {
  "Saghen/blink.cmp",
  opts = {
    completion = {
      list = {
        selection = {
          preselect = false,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      ghost_text = {
        enabled = false,
      },
    },
  },
}
