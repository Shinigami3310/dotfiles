pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../shared/theme"
import "../theme"
import "helpers"

QtObject {
    id: root

    property var allApps: []
    readonly property ListModel filteredApps: ListModel {}
    readonly property list<string> blackList: ["Avahi SSH Server Browser", "Avahi VNC Server Browser", "Avahi Zeroconf Browser", "mpv Media Player", "Qt V4L2 test Utility", "Qt V4L2 video capture utility"]

    property var _rawAppsBuffer: []
    property string _pendingQuery: ""

    property ListModelDiff listModelDiff: ListModelDiff {}

    // Дебаунс фильтрации: не пересчитываем список на каждое нажатие клавиши.
    property Timer filterDebounce: Timer {
        interval: 100
        onTriggered: root._applyFilter()
    }

    property Process appFetcher: Process {
        // Парсер .desktop вынесен в services/scripts/desktop_scan.awk
        command: ["sh", "-c", `find ${Paths.appDirs.join(" ")} -type f -name "*.desktop" -print0 2>/dev/null | xargs -0 gawk -f "${Paths.scriptsDir}desktop_scan.awk"`]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split("\x1F");
                if (parts.length >= 5) {
                    root._rawAppsBuffer.push({
                        id: parts[0],
                        name: parts[1],
                        icon: parts[2],
                        exec: parts[3],
                        terminal: parts[4] === "true"
                    });
                }
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0) {
                console.warn(`[AppService] desktop_scan завершился с кодом ${exitCode}`);
            }
            root._rawAppsBuffer.sort((a, b) => a.name.localeCompare(b.name));
            root.allApps = root._rawAppsBuffer.filter(app => !blackList.includes(app.id) && !blackList.includes(app.name));
            root._applyFilter();
            root._rawAppsBuffer = [];
        }
    }

    function filter(query: string) {
        root._pendingQuery = query || "";
        filterDebounce.restart();
    }

    function _applyFilter() {
        let q = root._pendingQuery.toLowerCase();

        let targetApps = q === "" ? root.allApps : root.allApps.filter(app => app.name.toLowerCase().includes(q));
        root.listModelDiff.sync(root.filteredApps, targetApps, "id", []);
    }

    // Exec из .desktop — это не просто команда, а строка с кавычками и
    // экранированием. Передаём её в execDetached как argv-массив, а не через
    // sh -c, чтобы исключить shell-инъекции из имени файла/аргументов.
    function parseExec(execString: string): var {
        const args = [];
        let current = "";
        let inSingle = false;
        let inDouble = false;
        let hasToken = false;

        for (let i = 0; i < execString.length; i++) {
            const c = execString[i];

            if (inSingle) {
                if (c === "'") {
                    inSingle = false;
                } else {
                    current += c;
                }
                hasToken = true;
                continue;
            }

            if (inDouble) {
                if (c === "\\") {
                    i++;
                    if (i < execString.length) {
                        current += execString[i];
                    }
                } else if (c === '"') {
                    inDouble = false;
                } else {
                    current += c;
                }
                hasToken = true;
                continue;
            }

            if (c === "'") {
                inSingle = true;
                hasToken = true;
            } else if (c === '"') {
                inDouble = true;
                hasToken = true;
            } else if (c === "\\") {
                i++;
                if (i < execString.length) {
                    current += execString[i];
                    hasToken = true;
                }
            } else if (c === " " || c === "\t") {
                if (hasToken) {
                    args.push(current);
                    current = "";
                    hasToken = false;
                }
            } else {
                current += c;
                hasToken = true;
            }
        }

        if (hasToken) {
            args.push(current);
        }

        return args;
    }

    function launchApp(arg: var) {
        if (!arg?.exec)
            return;

        let argv = parseExec(arg.exec);
        if (argv.length === 0)
            return;

        if (arg.terminal) {
            argv = [Paths.defaultTerminal, "-e", ...argv];
        }

        Quickshell.execDetached(argv);
    }
}
