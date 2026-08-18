return {
	{
		"Senal-D-A-Gunaratna/matugen.nvim",
		lazy = false,
		priority = 999,
		opts = {
			load_theme = true, -- Automatically apply the theme
			-- Point this to the output_path from your config.toml
			palette_path = vim.fn.expand("~/.config/nvim/nvim-colors.json"),
		},
	},
	-- Tell LazyVim to use matugen as the default colorscheme
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "matugen",
		},
	},
}
