pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"
import "helpers"

QtObject {
    id: root

    property var allApps: []
    readonly property ListModel filteredApps: ListModel {}
    readonly property list<string> blackList: ["Avahi SSH Server Browser", "Avahi VNC Server Browser", "Avahi Zeroconf Browser", "mpv Media Player"]

    property var _rawAppsBuffer: []

    property ListModelDiff listModelDiff: ListModelDiff {}

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
        root.listModelDiff.sync(root.filteredApps, targetApps, "id", []);
    }

    // Разбирает строку Exec из .desktop на массив argv,
    // корректно обрабатывая одинарные/двойные кавычки и экранирование.
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
