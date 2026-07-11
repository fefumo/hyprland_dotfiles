return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          "<leader>ch",
          "<cmd>LspClangdSwitchSourceHeader<cr>",
          desc = "Switch Source/Header",
          icon = { cat = "filetype", name = "cpp" },
        },
      },
    },
  },
}
