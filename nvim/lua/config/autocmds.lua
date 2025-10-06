-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local_expandtab = true
  end,
})

local block = vim.fs.normalize(vim.fn.expand("~") .. "~/my-coding/os-course")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { block .. "/**" },
  callback = function(ev)
    vim.b[ev.buf].autoformat = false
  end,
})
