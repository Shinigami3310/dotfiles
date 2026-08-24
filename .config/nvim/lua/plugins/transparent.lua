return {
	"xiyaowong/transparent.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local transparent = require("transparent")

		transparent.setup({
			extra_groups = {
				"NormalFloat",
				"FloatBorder",
				"FloatTitle",
				"Pmenu",
				"PmenuSel",
				"PmenuSbar",
				"PmenuThumb",
				"CursorLine",
				"StatusLine",
				"StatusLineNC",
			},
		})

		-- Очищает все группы, начинающиеся с этих префиксов (где используется surface_container)
		transparent.clear_prefix("BufferLine")
		transparent.clear_prefix("NeoTree")
		transparent.clear_prefix("Telescope")
		transparent.clear_prefix("Snacks")
		transparent.clear_prefix("BlinkCmp")
		transparent.clear_prefix("Noice")
		transparent.clear_prefix("WhichKey")
		transparent.clear_prefix("Lazy")
		transparent.clear_prefix("Mason")
	end,
}
