-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal -> Normal" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

local map = vim.keymap.set

map("n", "<leader>yf", function()
  local s = vim.fn.expand("%:t")
  vim.fn.setreg(vim.v.register, s)
  vim.notify("Yanked filename: " .. s)
end, { desc = "Yank Filename" })

map("n", "<leader>yp", function()
  local s = vim.fn.expand("%")
  vim.fn.setreg(vim.v.register, s)
  vim.notify("Yanked relative path: " .. s)
end, { desc = "Yank Relative Path" })

map("n", "<leader>yP", function()
  local s = vim.fn.expand("%:p")
  vim.fn.setreg(vim.v.register, s)
  vim.notify("Yanked absolute path: " .. s)
end, { desc = "Yank Absolute Path" })
