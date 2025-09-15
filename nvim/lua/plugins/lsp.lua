return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        -- Pass flags to enable clang-tidy checks and use your project's clang-format file.
        cmd = { "clangd", "--fallback-style=file" },
        -- Optionally, set up an on_attach function to autoformat on save.
        --on_attach = function(client, bufnr)
        --  if client.server_capabilities.documentFormattingProvider then
        --    vim.api.nvim_create_autocmd("BufWritePre", {
        --      buffer = bufnr,
        --      callback = function()
        --        vim.lsp.buf.format({ async = false })
        --      end,
        --    })
        --  end
        --end,
      },
      pyright = {},
    },
  },
}
