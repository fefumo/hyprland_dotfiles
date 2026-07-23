-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "terminal -> normal" })
vim.keymap.set("n", "<Leader>qw", "<cmd>wqall<cr>", { desc = "write & quit all buffers" })

vim.keymap.set("n", "<leader>yd", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", dir)
  vim.notify("Copied: " .. dir)
end, { desc = "Copy absolute dirpath" })

vim.keymap.set("n", "<leader>yf", function()
  local dir = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg("+", dir)
  vim.notify("Copied: " .. dir)
end, { desc = "Copy absolute filepath" })

vim.keymap.set("n", "<leader>yF", function()
  local relativeDir = vim.fn.expand("%:p:.")
  vim.fn.setreg("+", relativeDir)
  vim.notify("Copied: " .. relativeDir)
end, {desc = "Copy relative filepath"})

