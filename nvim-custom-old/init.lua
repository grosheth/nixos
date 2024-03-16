if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	-- Might need to define leader before importing lazy
	vim.g.mapleader = " "
	vim.opt.termguicolors = true
	-- Set font
	vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14:#h-slight"
	-- Disable netrw for oil
	-- vim.g.loaded_netrw = 1
	-- vim.g.loaded_netrwPlugin = 1

	require("lazy").setup("plugins", {
		dev = {
			path = "~/.local/share/nvim/nix",
			fallback = false,
		}
	})

	require("salledelavage")
end

