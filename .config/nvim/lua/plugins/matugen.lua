return {
	{
		"Senal-D-A-Gunaratna/matugen.nvim",
		lazy = false,
		priority = 999,
		opts = {
			load_theme = true,
			palette_path = vim.fn.expand("~/.config/nvim/nvim-colors.json"),
		},
		config = function(_, opts)
			-- 1. Применяем тему matugen
			require("matugen").setup(opts)

			-- 2. Сразу после применения затираем фон через transparent.nvim
			local ok, transparent = pcall(require, "transparent")
			if ok then
				transparent.clear()
			end
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "matugen",
		},
	},
}
