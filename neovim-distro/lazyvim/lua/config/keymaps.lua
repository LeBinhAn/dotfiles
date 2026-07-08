-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Move Lines
map("n", "∆", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "˚", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "∆", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "˚", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "∆", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "˚", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
map("n", "<leader>re", ":lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<CR>")

map("i", "jj", "<esc>", { silent = true })

-- Sử dụng Ctrl + Option (Meta) để resize window
-- Phù hợp cho cả layout HJKL và Phím mũi tên

-- 1. Phiên bản dùng HJKL (Tối ưu cho home row)
map("n", "<C-M-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-M-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- 2. Phiên bản dùng Phím mũi tên (Cho các bàn phím có cụm điều hướng tách biệt)
map("n", "<C-M-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
