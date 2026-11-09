-- Odin buffer-local commands: <leader>o{b,r,c,t}
local run = function(cmd)
  require("config.runner").run(cmd)
end
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { buffer = true, desc = desc })
end

map("<leader>ob", function() run("odin build .") end, "Odin: build package")
map("<leader>or", function() run("odin run .") end, "Odin: run package")
map("<leader>oc", function() run("odin check .") end, "Odin: type-check package")
map("<leader>ot", function() run("odin test .") end, "Odin: test package")

-- :make -> compiler errors land in the quickfix list (<leader>xq)
vim.bo.makeprg = "odin build %:p:h"
vim.bo.errorformat = "%f(%l:%c) %m"
