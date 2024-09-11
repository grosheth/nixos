return { 
  { 
    dir = "~/work/kaolin.nvim",
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
  -- {
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     vim.cmd([[colorscheme onedark]])
  --   end,
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "onedark",
  --   },
  -- },
}
