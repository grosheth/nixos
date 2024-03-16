return {
    {
        "numToStr/Comment.nvim",
        opts = {},
        event = { "BufReadPost", "BufNewFile" },
				config = function()
						require("Comment").setup()
				end
    }
}
