return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x", -- or the latest stable branch
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				hijack_netrw_behavior = "open_default",
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},
		})

		vim.keymap.set("n", "<leader>e", function()
			require("neo-tree.command").execute({ toggle = true, reveal = true })
		end, { desc = "Toggle NeoTree" })
	end,
}
