return {
  {
    "folke/zen-mode.nvim",
    opts = {
      vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { desc = 'Enable ZenMode' })
    }
  },
}
