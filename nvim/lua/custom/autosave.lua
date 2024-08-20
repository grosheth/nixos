local bufnr = 68

vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "hello", "world" })


