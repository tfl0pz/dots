-- Zig buffer-local commands: <leader>o{b,r,c,t}
local run = function(cmd)
  require("config.runner").run(cmd)
end
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { buffer = true, desc = desc })
end

map("<leader>ob", function() run("zig build") end, "Zig: build")
map("<leader>or", function() run("zig build run") end, "Zig: build + run")
map("<leader>oc", function() run("zig ast-check " .. vim.fn.shellescape(vim.fn.expand("%:t"))) end, "Zig: check current file")
map("<leader>ot", function() run("zig build test") end, "Zig: build + test")
