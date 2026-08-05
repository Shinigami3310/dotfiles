pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property var allApps: []
    readonly property ListModel filteredApps: ListModel {}
    readonly property list<string> blackList: ["Avahi SSH Server Browser", "Avahi VNC Server Browser", "Avahi Zeroconf Browser", "mpv Media Player"]

    property var _rawAppsBuffer: []

    property Process appFetcher: Process {
        command: ["sh", "-c", "find \"$HOME/.local/share/applications\" /usr/share/applications -type f -name \"*.desktop\" -print0 2>/dev/null | xargs -0 gawk 'function getval() { val = substr($0, index($0, \"=\") + 1); sub(/^[ \\t]+/, \"\", val); sub(/[ \\t\\r]+$/, \"\", val); return val; } BEGIN { FS = \"=\" } BEGINFILE { n = split(FILENAME, a, \"/\"); id = a[n]; } /^\\[Desktop Entry\\]/ { in_entry = 1; next } /^\\[/ { in_entry = 0; next } in_entry { if (/^Name=/) { if (!name_general) name_general = getval() } else if (/^Name\\[/) { if (!name_localized) name_localized = getval() } else if (/^Icon=/) { if (!icon) icon = getval() } else if (/^Exec=/) { if (!exec) exec = getval() } else if (/^NoDisplay=/) { nodisplay = tolower(getval()) } else if (/^Hidden=/) { hidden = tolower(getval()) } else if (/^Type=/) { type = tolower(getval()) } else if (/^Terminal=/) { terminal = tolower(getval()) } } ENDFILE { name = (name_general ? name_general : name_localized); if (id && name && exec && nodisplay != \"true\" && hidden != \"true\" && !seen[id] && (!type || type == \"application\")) { gsub(/ %[a-zA-Z]+/, \"\", exec); sub(/^%[a-zA-Z]+ /, \"\", exec); sub(/ +$/, \"\", exec); printf \"%s\\037%s\\037%s\\037%s\\037%s\\n\", id, name, icon, exec, terminal; seen[id] = 1; } name_general = name_localized = icon = exec = nodisplay = hidden = type = terminal = \"\"; }'"]
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

        onExited: {
            root._rawAppsBuffer.sort((a, b) => a.name.localeCompare(b.name));
            root.allApps = root._rawAppsBuffer.filter(app => !blackList.includes(app.id) && !blackList.includes(app.name));
            root.filter("");
            root._rawAppsBuffer = [];
        }
    }

    function filter(query: string) {
        let q = (query || "").toLowerCase();

        let targetApps = q === "" ? root.allApps : root.allApps.filter(app => app.name.toLowerCase().includes(q));
        let targetIds = new Set(targetApps.map(app => app.id));

        for (let i = root.filteredApps.count - 1; i >= 0; i--) {
            if (!targetIds.has(root.filteredApps.get(i).id)) {
                root.filteredApps.remove(i);
            }
        }

        for (let i = 0; i < targetApps.length; i++) {
            let targetApp = targetApps[i];
            let foundIdx = -1;

            for (let j = 0; j < root.filteredApps.count; j++) {
                if (root.filteredApps.get(j).id === targetApp.id) {
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

    function launchApp(arg: var) {
        let execCommand = arg.exec;
        if (!execCommand)
            return;

        if (arg.terminal) {
            execCommand = `kitty -e ${execCommand}`;
        }

        Quickshell.execDetached(["sh", "-c", execCommand]);
    }
}
