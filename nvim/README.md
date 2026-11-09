# Neovim Configuration

Neovim 0.12+ setup for Go, Rust, Odin, Zig, C/C++, Python, YAML/Kubernetes, Docker and more — with LSP, autocompletion, file explorer, fuzzy finding, formatting and git integration.

Everything is auto-installed and verified: LSP servers attach and tree-sitter highlighting works for all configured languages.

## Structure

```
~/.config/nvim/
├── init.lua                  # entry point
└── lua/
    ├── config/
    │   ├── options.lua       # editor options, leader keys
    │   ├── keymaps.lua       # general keymaps
    │   ├── autocmds.lua      # yank highlight, cursor restore, ...
    │   └── lazy.lua          # lazy.nvim bootstrap
    └── plugins/
        ├── lsp.lua           # Mason, LSP servers + settings
        ├── completion.lua    # blink.cmp
        ├── treesitter.lua    # parsers + highlighting
        ├── telescope.lua     # fuzzy finder
        ├── editor.lua        # neo-tree, git, trouble, surround, ...
        ├── ui.lua            # theme, statusline, which-key
        └── formatting.lua    # conform.nvim (format on save)
```

The old config remains untouched in `~/.config/nvim-bak`.

## LSP servers (auto-installed via Mason)

| Language | Server | Notes |
|---|---|---|
| Go | gopls | inlay hints, staticcheck |
| Rust | rust-analyzer | clippy on save |
| Odin | ols | |
| Zig | zls | see note below |
| C / C++ | clangd | + neocmake for CMake |
| Python | pyright + ruff | types/navigation + lint/format |
| YAML | yamlls | schemastore + Kubernetes schemas (`*.k8s.yaml`, `k8s/`, `manifests/`) |
| Helm | helm-ls | |
| Docker | dockerls + docker-compose-language-service | |
| Bash | bashls | |
| JSON / TOML / Lua / Markdown | jsonls / taplo / lua_ls / marksman | |

## Features

- **Autocompletion:** blink.cmp (LSP + snippets + paths + buffer). `Enter` accepts, `Tab`/`S-Tab` navigates, docs and signature help auto-show.
- **File explorer:** neo-tree (`<leader>e`)
- **Fuzzy finder:** telescope (files, grep, buffers, help, diagnostics, ...)
- **Search & replace:** grug-far (`<leader>sr`)
- **Formatting:** conform.nvim, format on save (goimports, rustfmt, ruff, clang-format, prettier, stylua, shfmt)
- **Syntax:** nvim-treesitter, 34 parsers
- **Git:** neogit, gitsigns (hunks, blame, diff), diffview
- **Diagnostics:** trouble.nvim panel
- **UI:** tokyonight theme, lualine statusline, which-key, indent guides, todo-comments, autopairs, nvim-surround

## Key bindings (leader = `Space`)

| Keys | Action |
|---|---|
| `<leader>e` / `<leader>ff` / `<leader>fg` | File tree / find files / live grep |
| `gd` `gr` `gI` `K` | Definition / references / implementation / docs |
| `<leader>ca` `cr` `cf` | Code action / rename / format |
| `<leader>cs` `<leader>cS` | Document / workspace symbols |
| `<leader>ch` | Toggle inlay hints |
| `<leader>gg` / `]h` `[h` | Neogit / next, previous git hunk |
| `<leader>gs` `gp` `gb` `gd` | Stage / preview / blame / diff hunk |
| `<leader>xx` / `<leader>cd` | Diagnostics panel / line diagnostics |
| `<leader>fb` `<leader>fr` | Buffers / recent files |
| `<leader>/` | Search in current buffer |
| `<leader>fn` | Find files in nvim config |
| `S-h` `S-l` / `<leader>bd` | Prev / next buffer, delete buffer |
| `C-h/j/k/l` | Window navigation |
| `gcc`, `ys`/`ds`/`cs` | Comment, surround add/delete/change |

## Running & building (per-language, `<leader>o`)

Output appears in a persistent terminal split at the bottom (`q` closes the
window, the shell stays alive; `<Esc><Esc>` leaves terminal mode). The same
keys work in every language; the command depends on the filetype:

| Keys | Odin | Go | Rust | Zig | Python | C / C++ |
|---|---|---|---|---|---|---|
| `<leader>ob` | `odin build .` | `go build ./...` | `cargo build` | `zig build` | — | clang compile |
| `<leader>or` | `odin run .` | `go run .` | `cargo run` | `zig build run` | run file | compile + run |
| `<leader>oc` | `odin check .` | `go vet` | `cargo clippy` | `zig ast-check` | `ruff check` | — |
| `<leader>ot` | `odin test .` | `go test ./...` | `cargo test` | `zig build test` | pytest | — |

Commands run from the current file's directory (cargo walks up to
`Cargo.toml`). For Odin and Go, `:make` also populates the quickfix list
with compiler errors — browse with `<leader>xq` and jump to each
file:line directly.

## Maintenance

- `:Lazy` — manage plugins
- `:Mason` — manage LSP servers / formatters
- `:TSUpdate` — update tree-sitter parsers
- `:FormatToggle` — toggle format-on-save (`:FormatToggle!` for current buffer only)
- `:checkhealth` — diagnose problems

## Notes

- Requires a Nerd Font in the terminal for icons.
- The `tree-sitter` CLI (`brew install tree-sitter-cli`) is required for compiling parsers — installed during setup.
- **Zig:** Mason's zls (0.16.0) lags behind Zig 0.17.0, so zls prints a version-mismatch warning. It still attaches; update via `:Mason` once zls 0.17 ships, or build zls from source.
