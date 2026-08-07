pragma Singleton

// Изолированный слой доступа к Hyprland IPC (правило .clinerules §5 / изоляция ОС).
// Quickshell.Hyprland импортируется ТОЛЬКА здесь — остальной UI работает с экраном/геометрией.
// Если Hyprland недоступен (focusedMonitor === null) — fallback на Qt.primaryScreen.
import QtQuick 6.0
import Quickshell.Hyprland
import qs.config

QtObject {
    id: root

    // Фокусный монитор Hyprland (null вне Hyprland).
    readonly property var activeMonitor: Hyprland.focusedMonitor

    // Qt‑screen, соответствующий фокусному монитору (Qt.screen.name == monitor.name).
    // Ре‑evals, когда focusedMonitor меняется; перебор ≤4 экранов — дёшево.
    readonly property var activeScreen: resolveScreen()

    function resolveScreen() {
        var m = Hyprland.focusedMonitor;
        if (m) {
            var nm = m.name;
            for (var i = 0; i < Qt.screens.length; ++i)
                if (Qt.screens[i].name === nm) return Qt.screens[i];
        }
        return Qt.primaryScreen;                                // кросс‑дистрибутивный fallback
    }

    // Рабочая область активного монитора (availableGeometry — чтобы не залезть под панель).
    readonly property var activeGeometry: activeScreen ? activeScreen.availableGeometry
                                                       : Qt.rect(0, 0, 0, 0)

    readonly property real screenWidth: activeGeometry.width
    readonly property real screenHeight: activeGeometry.height
}
