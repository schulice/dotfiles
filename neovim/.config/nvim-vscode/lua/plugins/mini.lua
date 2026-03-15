return {
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.move",
		event = "VeryLazy",
		config = function()
			require("mini.move").setup({
				mappings = {
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",
				},
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		config = function()
			require("mini.pairs").setup()
		end,
	},
}
