-- Navigation
-- CTRL + hjkl to move in insert mode
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")


-- Split screens
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")

-- Plugin related keybindings--


-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- LazyGit
vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- ZenMode
vim.api.nvim_set_keymap('n', '<leader>z', ':ZenMode<CR>', { desc = "Enable/Disable ZenMode" })

-- Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree<CR>", { desc = "Open Neotree" })
vim.keymap.set("n", "<leader>br", ":Neotree toggle show buffers right<CR>", { desc = "Open Neotree on the right" })
vim.keymap.set("n", "<leader>gs", ":Neotree float git_status<CR>", { desc = "Open Neotree git status " })

-- Toggleterm
-- Terminal
vim.keymap.set("n", "<leader>t", ":ToggleTerm direction=horizontal<CR>")


-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
