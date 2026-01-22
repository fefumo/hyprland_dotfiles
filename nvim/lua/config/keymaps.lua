-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "terminal -> normal" })
vim.keymap.set("n", "<Leader>qw","<cmd>wqall<cr>", { desc = "write & quit all buffers"} )
