hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	match = { class = ".*" },
	no_blur = true,
})

hl.window_rule({
	match = { class = "zen" },
	workspace = "2",
	no_blur = false,
})
