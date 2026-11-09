-- C++ buffer-local commands: <leader>o{b,r} (single-file compile with clang++)
local run = function(cmd)
  require("config.runner").run(cmd)
end
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { buffer = true, desc = desc })
end

local function compile_cmd(run_after)
  local src = vim.fn.shellescape(vim.fn.expand("%:t"))
  local out = "/tmp/" .. vim.fn.expand("%:t:r") .. ".out"
  local base = string.format("clang++ -Wall -Wextra -std=c++17 %s -o %s", src, out)
  return run_after and (base .. " && " .. out) or base
end

map("<leader>ob", function() run(compile_cmd(false)) end, "C++: compile (clang++)")
map("<leader>or", function() run(compile_cmd(true)) end, "C++: compile + run")
