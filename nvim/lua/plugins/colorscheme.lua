return { 
  
  -- Kaolin
  { dir = "~/work/kaolin.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme kaolin]])
    end,
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
