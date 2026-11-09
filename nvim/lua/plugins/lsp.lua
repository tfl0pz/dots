-- LSP: servers, installer, progress UI
-- Servers are installed by mason-tool-installer and enabled by mason-lspconfig
-- via nvim 0.11+ vim.lsp.config / vim.lsp.enable.
return {
  -- Proper lua_ls support for editing this very config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
    },
    config = function()
      ----------------------------------------------------------------
      -- Keymaps that exist only while an LSP is attached
      ----------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local telescope = require("telescope.builtin")

          map("gd", telescope.lsp_definitions, "Goto definition")
          map("gr", telescope.lsp_references, "Goto references")
          map("gI", telescope.lsp_implementations, "Goto implementation")
          map("gy", telescope.lsp_type_definitions, "Goto type definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover documentation")
          map("<leader>cs", telescope.lsp_document_symbols, "Document symbols")
          map("<leader>cS", telescope.lsp_dynamic_workspace_symbols, "Workspace symbols")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint", event.buf) then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
            end, "Toggle inlay hints")
          end
        end,
      })

      ----------------------------------------------------------------
      -- Diagnostics appearance
      ----------------------------------------------------------------
      vim.diagnostic.config({
        severity_sort = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        float = { border = "rounded" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      -- Merge blink.cmp capabilities into every server
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      ----------------------------------------------------------------
      -- Per-server settings
      ----------------------------------------------------------------
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            staticcheck = true,
            analyses = { unusedparams = true, shadow = true },
            hints = {
              parameterNames = true,
              assignVariableTypes = true,
              constantValues = true,
              rangeVariableTypes = true,
              compositeLiteralTypes = true,
              compositeLiteralFields = true,
              functionTypeParameters = true,
            },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            check = { command = "clippy" },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            validate = true,
            completion = true,
            hover = true,
            schemaStore = { enable = true },
            -- Kubernetes manifests (schemastore covers the rest: CI, compose, ...)
            schemas = {
              kubernetes = {
                "*.k8s.yaml",
                "*.k8s.yml",
                "k8s/*.yaml",
                "k8s/**/*.yaml",
                "manifests/*.yaml",
                "manifests/**/*.yaml",
              },
            },
          },
        },
      })

      vim.lsp.config("helm_ls", {
        settings = {
          ["helm-ls"] = {
            yamlls = { path = "yaml-language-server" },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
          },
        },
      })

      ----------------------------------------------------------------
      -- Install servers + tools, then enable the servers
      ----------------------------------------------------------------
      require("mason-lspconfig").setup({ automatic_enable = true })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "gopls", -- Go
          "rust_analyzer", -- Rust
          "ols", -- Odin
          "zls", -- Zig
          "clangd", -- C / C++
          "neocmake", -- CMake
          "pyright", -- Python (types/navigation)
          "ruff", -- Python (lint/format)
          "yamlls", -- YAML
          "helm_ls", -- Helm charts (Kubernetes)
          "dockerls", -- Dockerfile
          "docker_compose_language_service", -- docker-compose
          "bashls", -- Bash
          "jsonls", -- JSON
          "taplo", -- TOML
          "lua_ls", -- Lua
          "marksman", -- Markdown
          -- Formatters / linters (used by conform.nvim)
          "stylua",
          "shfmt",
          "prettier",
          "goimports",
          "clang-format",
        },
        run_on_start = true,
      })
    end,
  },
}
