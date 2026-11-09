-- Go buffer-local commands: <leader>o{b,r,c,t}
local run = function(cmd)
  require("config.runner").run(cmd)
end
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { buffer = true, desc = desc })
end

map("<leader>ob", function() run("go build ./...") end, "Go: build")
map("<leader>or", function() run("go run .") end, "Go: run")
map("<leader>oc", function() run("go vet ./...") end, "Go: vet")
map("<leader>ot", function() run("go test ./...") end, "Go: test")

vim.bo.makeprg = "go build %:p:h"
vim.bo.errorformat = "%f:%l:%c: %m,%f:%l: %m"
