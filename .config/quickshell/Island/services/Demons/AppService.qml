pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property var allApps: []
    // Теперь это ListModel для правильной работы анимаций в QML
    readonly property ListModel filteredApps: ListModel {}

    property Process appFetcher: Process {
        // Скрипт собран в единую строку для читаемости
        command: ["sh", "-c", "for dir in /usr/share/applications \"$HOME/.local/share/applications\"; do if [ -d \"$dir\" ]; then for f in \"$dir\"/*.desktop; do if [ -f \"$f\" ]; then name=$(grep -m 1 \"^Name=\" \"$f\" | cut -d '=' -f 2-); icon=$(grep -m 1 \"^Icon=\" \"$f\" | cut -d '=' -f 2-); exec=$(grep -m 1 \"^Exec=\" \"$f\" | cut -d '=' -f 2- | sed 's/ %[a-zA-Z]//g'); nodisplay=$(grep -m 1 \"^NoDisplay=\" \"$f\" | cut -d '=' -f 2-); if [ \"$nodisplay\" != \"true\" ] && [ -n \"$name\" ] && [ -n \"$exec\" ]; then echo \"$name|$icon|$exec\"; fi; fi; done; fi; done"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let line = data.trim();
                if (line === "")
                    return;

                let parts = line.split("|");
                if (parts.length >= 3) {
                    let app = {
                        name: parts[0],
                        icon: parts[1],
                        exec: parts[2]
                    };

                    let tempAll = root.allApps.slice();
                    tempAll.push(app);
                    root.allApps = tempAll;

                    // Добавляем в модель сразу
                    root.filteredApps.append(app);
                }
            }
        }
    }

    function filter(query) {
        let q = (query || "").toLowerCase();
        let targetApps = root.allApps;

        if (q !== "") {
            targetApps = root.allApps.filter(app => app.name.toLowerCase().indexOf(q) !== -1);
        }

        // Шаг 1: Удаляем из ListModel то, чего нет в отфильтрованном списке
        for (let i = root.filteredApps.count - 1; i >= 0; i--) {
            let currentName = root.filteredApps.get(i).name;
            let shouldKeep = targetApps.some(app => app.name === currentName);
            if (!shouldKeep) {
                root.filteredApps.remove(i);
            }
        }

        // Шаг 2: Вставляем или двигаем элементы на их правильные позиции
        for (let i = 0; i < targetApps.length; i++) {
            let targetApp = targetApps[i];
            let foundIdx = -1;

            for (let j = 0; j < root.filteredApps.count; j++) {
                if (root.filteredApps.get(j).name === targetApp.name) {
                    foundIdx = j;
                    break;
                }
            }

            if (foundIdx !== -1) {
                if (foundIdx !== i) {
                    root.filteredApps.move(foundIdx, i, 1);
                }
            } else {
                root.filteredApps.insert(i, targetApp);
            }
        }
    }

    function launchApp(execCommand) {
        if (execCommand && execCommand !== "") {
            Quickshell.execDetached(["sh", "-c", execCommand]);
        }
    }
}
