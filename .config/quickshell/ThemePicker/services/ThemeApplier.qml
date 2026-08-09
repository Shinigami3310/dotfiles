pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

// Сервис применения темы: запускает scripts/set-theme с именем обоев.
// Не решает о жизненном цикле приложения — только эмитит сигнал applied().
// Таймаут на 10 сек защищает от зависшего процесса.
QtObject {
    id: root

    signal applied(bool ok)

    // Валидация имени: запрещаем path traversal (слэши и ".."),
    // но разрешаем пробелы и юникод — реальные имена файлов бывают разными.
    // Двойная защита: QML-сторона + bash-скрипт.
    function apply(wallpaperName) {
        if (!wallpaperName) {
            console.warn("[ThemeApplier] Пустое имя обоев, пропускаю.");
            root.applied(false);
            return;
        }
        if (wallpaperName.indexOf("/") !== -1 || wallpaperName.indexOf("..") !== -1) {
            console.warn("[ThemeApplier] Недопустимое имя обоев:", wallpaperName);
            root.applied(false);
            return;
        }

        root.applierProc.command = ["bash", Configs.setThemeScriptPath, wallpaperName];
        root.timeoutTimer.start();
        root.applierProc.running = true;
    }

    property Process applierProc: Process {
        command: []
        running: false
        onExited: exitCode => {
            root.timeoutTimer.stop();
            if (exitCode !== 0)
                console.warn("[ThemeApplier] set-theme завершился с кодом:", exitCode);
            root.applied(exitCode === 0);
        }
    }

    // Таймаут: если скрипт завис, сообщаем об ошибке и разблокируем UI.
    property Timer timeoutTimer: Timer {
        interval: 10000
        repeat: false
        onTriggered: {
            console.warn("[ThemeApplier] set-theme превысил таймаут (10с).");
            root.applierProc.running = false;
            root.applied(false);
        }
    }
}