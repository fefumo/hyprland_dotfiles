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

local block = vim.fn.expand("~/my-coding/os-course")

local grp = vim.api.nvim_create_augroup("DisableAutoformatForOSCourse", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufEnter" }, {
  group = grp,
  callback = function(ev)
    local file = ev.file ~= "" and ev.file or vim.api.nvim_buf_get_name(ev.buf)
    if file:sub(1, #block) == block then
      vim.b[ev.buf].autoformat = false
      vim.bo[ev.buf].formatexpr = ""
    end
  end,
})
