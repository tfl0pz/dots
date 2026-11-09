-- Leader keys (must be set before lazy.nvim loads plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Use system clipboard for all yank/delete/paste
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.scrolloff = 8

-- Indentation (vim-sleuth adjusts per-file)
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.wrap = false

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Files / undo
vim.o.undofile = true
vim.o.confirm = true

-- UI
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.pumheight = 10
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.mouse = "a"

-- Whitespace guides rely on a Nerd Font; icons degrade gracefully without one
vim.g.have_nerd_font = true
