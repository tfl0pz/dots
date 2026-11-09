-- Python buffer-local commands: <leader>o{r,c,t}
local run = function(cmd)
  require("config.runner").run(cmd)
end
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { buffer = true, desc = desc })
end

map("<leader>or", function() run("python3 " .. vim.fn.shellescape(vim.fn.expand("%:t"))) end, "Python: run file")
map("<leader>oc", function() run("ruff check .") end, "Python: lint (ruff)")
map("<leader>ot", function() run("python3 -m pytest -q") end, "Python: run tests (pytest)")
