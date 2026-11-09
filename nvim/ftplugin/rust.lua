-- Rust buffer-local commands: <leader>o{b,r,c,t} (cargo finds Cargo.toml upwards)
local run = function(cmd)
  require("config.runner").run(cmd)
end
local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { buffer = true, desc = desc })
end

map("<leader>ob", function() run("cargo build") end, "Rust: cargo build")
map("<leader>or", function() run("cargo run") end, "Rust: cargo run")
map("<leader>oc", function() run("cargo clippy") end, "Rust: cargo clippy")
map("<leader>ot", function() run("cargo test") end, "Rust: cargo test")
