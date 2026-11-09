local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Save / quit
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map({ "i", "v" }, "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Delete buffer without ever quitting vim: switch to another listed
-- buffer (or a fresh empty one) before wiping the current one out.
map("n", "<leader>bd", function()
  local cur = vim.api.nvim_get_current_buf()
  if vim.bo[cur].modified then
    local choice = vim.fn.confirm("Buffer has unsaved changes", "&Save\n&Discard\n&Cancel", 3)
    if choice == 1 then
      vim.cmd("write")
    elseif choice == 2 then
      -- discard below via force
    else
      return
    end
  end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted then
      vim.api.nvim_set_current_buf(b)
      vim.api.nvim_buf_delete(cur, { force = true })
      return
    end
  end
  vim.cmd("enew")
  vim.api.nvim_buf_delete(cur, { force = true })
end, { desc = "Delete buffer" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Exit terminal mode (build/run terminal)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keep selection while indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
