import QtQuick 6.0
import Quickshell        // QsWindow
import qs.config         // Theme
import qs.services       // ThemeModel, WallpaperLoader, WallpaperApplier, HyprlandMonitor

// Главное окно: прозрачный затемнённый overlay на активном мониторе.
QsWindow {
    id: win

    // Размещение: на активный экран, размером с него. Без x/y — Wayland (правило §5).
    screen: HyprlandMonitor.activeScreen
    implicitWidth: HyprlandMonitor.screenWidth
    implicitHeight: HyprlandMonitor.screenHeight

    // Прозрачность/затемнение ДО первого показа (иначе окно становится опозь навсегда).
    color: "transparent"
    surfaceFormat.opaque: false
    visible: true
    opacity: 0            // fadeIn с нуля
    focus: true

    OverlayBackground { anchors.fill: parent }
    WallpaperCarousel { anchors.centerIn: parent }

    // Приём клавиш на невидимом фокусном Item — надёжно на Wayland/Win (а не onValueChanged).
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) { onAccepted(); event.accepted = true; }
            else if (event.key === Qt.Key_Escape) { onRejected(); event.accepted = true; }
        }
    }

    // --- вход / выход ---
    function open() {
        WallpaperLoader.scan();        // асинхронно — не блокирует UI
        fadeIn.start();
    }
    function onAccepted() {
        // скрипт выживает после quit (execDetached) → aww/matugen дотянутся
        WallpaperApplier.apply(ThemeModel.currentPath);
        fadeOut.start();
    }
    function onRejected() {
        fadeOut.start();
    }
    Component.onCompleted: { open(); keysItem.forceActiveFocus(); }

    NumberAnimation { id: fadeIn;  property: "opacity"; from: 0; to: 1; duration: Theme.fadeDurationMs; easing.type: Easing.OutQuad }
    NumberAnimation { id: fadeOut; property: "opacity"; from: 1; to: 0; duration: Theme.fadeDurationMs; easing.type: Easing.InQuad;
        onFinished: { win.visible = false; Qt.quit(); } }   // полное выгружение shell из памяти
}
