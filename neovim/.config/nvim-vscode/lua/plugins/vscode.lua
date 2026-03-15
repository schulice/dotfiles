if not vim.g.vscode then
	return {}
end

-- use vscode notifications
-- vim.notify = require("vscode").notify
vim.notify = function(msg, level)
  if level == vim.log.levels.ERROR then
    require("vscode").notify(msg)
  end
end

vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.ruler = false
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.opt.timeoutlen = 400

return {
	{
		"lazy.nvim",
		opts = function()
			local vscode = require("vscode")

			local map = vim.keymap.set

			-- basic actions
			map("n", "<leader>q", function()
				vscode.action("workbench.action.closeWindow")
			end)
			map("n", "<leader>w", function()
				vscode.action("workbench.action.files.save")
			end)
			map("n", "<leader>n", function()
				vscode.action("welcome.showNewFileEntries")
			end)

			-- splits
			map("n", "|", function()
				vscode.action("workbench.action.splitEditor")
			end)
			map("n", "\\", function()
				vscode.action("workbench.action.splitEditorDown")
			end)

			map("n", "<C-h>", function()
				vscode.action("workbench.action.navigateLeft")
			end)
			map("n", "<C-j>", function()
				vscode.action("workbench.action.navigateDown")
			end)
			map("n", "<C-k>", function()
				vscode.action("workbench.action.navigateUp")
			end)
			map("n", "<C-l>", function()
				vscode.action("workbench.action.navigateRight")
			end)

			-- terminal
			map("n", "<F7>", function()
				vscode.action("workbench.action.terminal.toggleTerminal")
			end)
			map("n", "<C-'>", function()
				vscode.action("workbench.action.terminal.toggleTerminal")
			end)

			-- buffers
			map("n", "]b", "<cmd>Tabnext<CR>")
			map("n", "[b", "<cmd>Tabprevious<CR>")
			map("n", "<leader>c", "<cmd>Tabclose<CR>")
			map("n", "<leader>C", "<cmd>Tabclose!<CR>")
			map("n", "<leader>bp", "<cmd>Tablast<CR>")

			map("n", "<leader>bc", function()
				vscode.action("workbench.action.closeOtherEditors")
			end)

			-- explorer
			map("n", "<leader>e", function()
				vscode.action("workbench.files.action.focusFilesExplorer")
			end)

			map("n", "<leader>o", function()
				vscode.action("workbench.files.action.focusFilesExplorer")
			end)

			-- indentation
			map("v", "<Tab>", function()
				vscode.action("editor.action.indentLines")
			end)
			map("v", "<S-Tab>", function()
				vscode.action("editor.action.outdentLines")
			end)

			-- diagnostics
			map("n", "]d", function()
				vscode.action("editor.action.marker.nextInFiles")
			end)
			map("n", "[d", function()
				vscode.action("editor.action.marker.prevInFiles")
			end)

			-- search / pickers
			map("n", "<leader>fc", function()
				vscode.action("workbench.action.findInFiles", {
					args = { query = vim.fn.expand("<cword>") },
				})
			end)

			map("n", "<leader>fC", function()
				vscode.action("workbench.action.showCommands")
			end)
			map("n", "<leader>ff", function()
				vscode.action("workbench.action.quickOpen")
			end)
			map("n", "<leader>fn", function()
				vscode.action("notifications.showList")
			end)
			map("n", "<leader>fo", function()
				vscode.action("workbench.action.openRecent")
			end)
			map("n", "<leader>ft", function()
				vscode.action("workbench.action.selectTheme")
			end)
			map("n", "<leader>fw", function()
				vscode.action("workbench.action.findInFiles")
			end)
			map("n", "<leader>fb", function()
				vscode.action("workbench.action.showEditorsInGroup")
			end)

			-- git
			map("n", "<leader>gg", function()
				vscode.action("workbench.view.scm")
			end)

			-- LSP
			map("n", "K", function()
				vscode.action("editor.action.showHover")
			end)
			map("n", "gd", function()
				vscode.action("editor.action.revealDefinition")
			end)
			map("n", "gD", function()
				vscode.action("editor.action.revealDeclaration")
			end)
			map("n", "gI", function()
				vscode.action("editor.action.goToImplementation")
			end)
			map("n", "gr", function()
				vscode.action("editor.action.goToReferences")
			end)
			map("n", "gy", function()
				vscode.action("editor.action.goToTypeDefinition")
			end)

			map("n", "<leader>la", function()
				vscode.action("editor.action.quickFix")
			end)
			map("n", "<leader>lr", function()
				vscode.action("editor.action.rename")
			end)
			map("n", "<leader>ls", function()
				vscode.action("workbench.action.gotoSymbol")
			end)
			map("n", "<leader>lf", function()
				vscode.action("editor.action.formatDocument")
			end)
			map("n", "<leader>lG", function()
				vscode.action("workbench.action.showAllSymbols")
			end)
			map("n", "<leader>lR", function()
				vscode.action("editor.action.goToReferences")
			end)
		end,
	},

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
