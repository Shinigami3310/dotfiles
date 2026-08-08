#!/usr/bin/gawk -f
# Парсер .desktop-файлов: извлекает id, Name, Icon, Exec, Terminal.
# Вызывается из AppService через find | xargs gawk -f.
function getval() {
    val = substr($0, index($0, "=") + 1);
    sub(/^[ \t]+/, "", val);
    sub(/[ \t\r]+$/, "", val);
    return val;
}
BEGIN { FS = "=" }
BEGINFILE { n = split(FILENAME, a, "/"); id = a[n]; }
/^\[Desktop Entry\]/ { in_entry = 1; next }
/^\[/ { in_entry = 0; next }
in_entry {
    if (/^Name=/) { if (!name_general) name_general = getval() }
    else if (/^Name\[/) { if (!name_localized) name_localized = getval() }
    else if (/^Icon=/) { if (!icon) icon = getval() }
    else if (/^Exec=/) { if (!exec) exec = getval() }
    else if (/^NoDisplay=/) { nodisplay = tolower(getval()) }
    else if (/^Hidden=/) { hidden = tolower(getval()) }
    else if (/^Type=/) { type = tolower(getval()) }
    else if (/^Terminal=/) { terminal = tolower(getval()) }
}
ENDFILE {
    name = (name_general ? name_general : name_localized);
    if (id && name && exec && nodisplay != "true" && hidden != "true" && !seen[id] && (!type || type == "application")) {
        gsub(/ %[a-zA-Z]+/, "", exec);
        sub(/^%[a-zA-Z]+ /, "", exec);
        sub(/ +$/, "", exec);
        printf "%s\037%s\037%s\037%s\037%s\n", id, name, icon, exec, terminal;
        seen[id] = 1;
    }
    name_general = name_localized = icon = exec = nodisplay = hidden = type = terminal = "";
}