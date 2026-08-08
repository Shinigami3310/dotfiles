// Точка входа Quickshell 0.3. Корень — Scope (docs: root shell.qml = Scope);
// окна объявляются дочерними. Синглетоны services/ auto‑создаются по мере
// использования; окно открывается само (Component.onCompleted → scan + fadeIn).
// Открытие/закрытие по Hyprland‑бинду — через scripts/toggleThemePicker.sh.
import QtQuick 6.0
import Quickshell          // Scope
import qs.ui               // ThemePickerWindow (сам импортирует qs.config + qs.services)

Scope {
    id: root
    ThemePickerWindow { }        // fullscreen overlay на активном мониторе
}
