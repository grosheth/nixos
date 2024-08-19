return { 
  
  -- Kaolin
  --
  -- local plugins need to be explicitly configured with dir
  { dir = "~/work/kaolin.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    -- config = function()
    --   -- load the colorscheme here
    --   vim.cmd([[colorscheme kaolin]])
    -- end,
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kaolin",
    },
  },

  -- Tokyonight
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "tokyonight",
  --   },
  -- },

  -- Dracula
  -- {
  --   "mofiqul/dracula.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "dracula",
  --   },
  -- },

  -- Kanagawa
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "kanagawa-wave",
  --   },
  -- }, 
}
