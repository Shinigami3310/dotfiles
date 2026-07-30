import QtQuick
import Quickshell
import Quickshell.Io

Singleton // Используем синглтон для удобного доступа из любого модуля

QtObject {
    id: root

    // Текущий режим (синхронизируется с системой через команды)
    readonly property string currentMode: "balanced"

    function setMode(mode) {
        // mode: "power-saver", "balanced", "performance"
        if (currentMode!== mode) {
            Quickshell.execDetached(["powerprofilesctl", "set", mode]);
            // В реальном приложении здесь стоит добавить проверку через Process,
            // чтобы подтвердить успешную смену режима.
            currentMode = mode;
        }
    }
}