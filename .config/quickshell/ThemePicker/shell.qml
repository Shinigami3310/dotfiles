import QtQuick
import Quickshell
import "./services"

ShellRoot {
    ThemePicker {
        id: themePicker

        Component.onCompleted: {
            WallpaperService.load();
            themePicker.open();
        }
    }
}