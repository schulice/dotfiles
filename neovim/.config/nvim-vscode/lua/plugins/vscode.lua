if not vim.g.vscode then
	return {}
end

return {
	-- disable treesitter highlight in vscode
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = {
				enable = false,
			},
		},
	},
}
