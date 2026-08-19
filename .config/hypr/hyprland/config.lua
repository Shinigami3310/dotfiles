local colors = require("hyprland/colors")

hl.config({
	general = {
		gaps_out = 30,
		border_size = 2,

		col = {
			active_border = colors.primary,
			inactive_border = colors.inactive,
		},

		resize_on_border = false,

		layout = "master",
		no_focus_fallback = true,
	},

	decoration = {
		rounding = 20,
		rounding_power = 4,

		inactive_opacity = 0.6,

		blur = {
			size = 4,
			passes = 3,
		},
	},
})
