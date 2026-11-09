-- Fuzzy finder
return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      local map = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      map("n", "<leader>fs", builtin.grep_string, { desc = "Grep word under cursor" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
      map("n", "<leader>fc", function()
        builtin.colorscheme({ enable_preview = true })
      end, { desc = "Colorscheme (live preview)" })
      map("n", "<leader>ft", builtin.builtin, { desc = "Telescope pickers" })
      map("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })
      map("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Find in nvim config" })
      map("n", "<leader>f.", function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = "Find all files (incl. hidden)" })
    end,
  },
}
