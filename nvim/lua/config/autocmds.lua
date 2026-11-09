local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore-cursor", { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lines = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close transient windows with q
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close-with-q", { clear = true }),
  pattern = { "help", "man", "lspinfo", "checkhealth", "qf", "query" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Equalize splits when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize-splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Persist colorscheme choice across sessions (picked with <leader>fc)
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("save-colorscheme", { clear = true }),
  callback = function(event)
    local f = io.open(vim.fn.stdpath("data") .. "/colorscheme.txt", "w")
    if f then
      f:write(event.match)
      f:close()
    end
  end,
})
