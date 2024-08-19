return {
  {
    "folke/zen-mode.nvim",
    opts = {
      vim.keymap.set('n', '<leader>z', ':ZenMode', { desc = 'Enable ZenMode' })
    }
  },
}
