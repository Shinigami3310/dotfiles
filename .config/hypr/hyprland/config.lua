local colors = require("hyprland/colors")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 30,
		border_size = 2,

		col = {
			active_border = colors.primary,
			inactive_border = colors.inactive,
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "master",
		no_focus_fallback = true,
	},

	decoration = {
		rounding = 20,
		rounding_power = 10,

		active_opacity = 1.0,
		inactive_opacity = 0.7,

		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			vibrancy = 0.1696,
			new_optimizations = true,
		},
	},

	ecosystem = {
		no_update_news = true,
	},
})
