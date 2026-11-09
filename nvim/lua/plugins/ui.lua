-- Theme, statusline, keymap hints, visual aids
return {
  -- Extra themes (browsable via <leader>fc)
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "rebelot/kanagawa.nvim", priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "EdenEast/nightfox.nvim", priority = 1000 },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      -- Apply the theme saved by the ColorScheme autocmd, defaulting to tokyonight
      local saved
      local f = io.open(vim.fn.stdpath("data") .. "/colorscheme.txt", "r")
      if f then
        saved = f:read("*l")
        f:close()
      end
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          if not saved or not pcall(vim.cmd.colorscheme, saved) then
            pcall(vim.cmd.colorscheme, "tokyonight-night")
          end
        end,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search/replace" },
        { "<leader>o", group = "run/build" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>b", group = "buffer" },
        { "<leader>q", group = "quit" },
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo comments (Trouble)" },
    },
  },
}
