return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "p", "<Plug>(YankyPutAfter)" },
		{ "P", "<Plug>(YankyPutBefore)" },
		{ "<c-n>", "<Plug>(YankyCycleForward)" },
		{ "<c-p>", "<Plug>(YankyCycleBackward)" },
	},
}
