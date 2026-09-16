-- ~/.config/nvim-minimal/init.lua

-- Basic editing performance settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 2 -- 4 spaces per tab
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true -- Nice colors if your terminal supports it
vim.opt.swapfile = false -- Fast load, no swap clutter for quick edits
vim.opt.undofile = true -- Keep undo history

-- Standard clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Space as leader key
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
