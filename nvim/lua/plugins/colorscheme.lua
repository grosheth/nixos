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
}
