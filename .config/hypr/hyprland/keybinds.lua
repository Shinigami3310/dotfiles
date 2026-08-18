local terminal = "kitty"
local browser = "zen-browser"
local editor = terminal .. " -e nvim"
local filemgr = terminal .. " -e yazi"
local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("qs ipc -c Island call island openSurface appLauncher"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" })) -- Убрали SHIFT для удобства

hl.bind(
	mainMod .. " + SHIFT + E",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.local/bin/toggle-powermenu"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("qs ipc -c NotificationCenter call notification-center toggle"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("qs ipc -c Island call island openSurface musicPlayer"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.local/bin/toggle-themepicker"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("qs ipc -c Island call island openSurface batteryProfile"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("qs ipc -c Island call island openSurface controlPanel"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(filemgr))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

for i = 1, 6 do
	local key = tostring(i)
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
