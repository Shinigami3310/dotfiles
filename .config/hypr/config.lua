-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
local colors_path = os.getenv("HOME") .. "/.config/hypr/colors.lua"
local ok, colors = pcall(dofile, colors_path)

-- Функция: убирает '#' и приводит к формату "rgba(RRGGBBAA)"
local function c(hex, alpha)
	if not hex then
		return nil
	end
	return "rgba(" .. hex:gsub("#", "") .. (alpha or "ff") .. ")"
end

-- Формируем финальные цвета с нужной прозрачностью
local active_1 = ok and c(colors.primary, "ee") or "rgba(33ccffee)"
local active_2 = ok and c(colors.tertiary, "ee") or "rgba(00ff99ee)"
local inactive = ok and c(colors.inactive, "aa") or "rgba(595959aa)"
--------------
--- Visual ---
--------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 25,
		border_size = 1,

		col = {
			active_border = { colors = { active_1, active_2 }, angle = 45 },
			inactive_border = inactive,
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "scrolling",
		no_focus_fallback = true,
	},

	decoration = {
		rounding = 20,
		rounding_power = 10,

		active_opacity = 1.0,
		inactive_opacity = 0.8,

		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			vibrancy = 0.1696,
			new_optimizations = true,
		},
	},

	animations = {
		enabled = true,
		workspace_wraparound = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
		session_lock_xray = true,
		session_lock_blur = true,
		lockdead_screen_delay = 0,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us,ru",
		kb_options = "grp:alt_shift_toggle",

		follow_mouse = 1,
		sensitivity = 0,

		repeat_rate = 50,
		repeat_delay = 300,

		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			scroll_factor = 0.5,
		},
	},

	cursor = {
		hide_on_key_press = true,
	},

	ecosystem = {
		no_update_news = true,
	},
})

---------------
--- GESTURE ---
---------------

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

---------------
--- DEVICES ---
---------------

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
