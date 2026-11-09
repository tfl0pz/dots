-- Persistent bottom terminal for build/run commands.
-- The same terminal is reused across runs; q closes the window but
-- keeps the shell alive in the background.
local M = {}

local state = { buf = nil, job = nil }

local function open_term()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) and state.job then
    local win = vim.fn.bufwinid(state.buf)
    if win == -1 then
      vim.cmd("botright 12split")
      vim.api.nvim_set_current_buf(state.buf)
    else
      vim.api.nvim_set_current_win(win)
    end
    return
  end

  vim.cmd("botright 12split")
  vim.cmd("enew")
  state.buf = vim.api.nvim_get_current_buf()
  state.job = vim.fn.jobstart(vim.o.shell, { term = true })
  vim.bo[state.buf].buflisted = false
  vim.bo[state.buf].filetype = "runner"
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = state.buf, silent = true, desc = "Close runner" })
end

--- Run a shell command in the runner terminal, from the current file's directory.
--- @param cmd string
function M.run(cmd)
  local cwd = vim.fn.expand("%:p:h")
  open_term()
  vim.fn.chansend(state.job, string.format("cd %s && %s\n", vim.fn.shellescape(cwd), cmd))
  vim.cmd("startinsert")
end

return M
