import QtQuick
import Quickshell
import Quickshell.Wayland
import "./theme"
import "./services"
import "./ui"

// Корневой компонент Theme Picker: полноэкранный overlay с каруселью обоев.
// Навигация — стрелки влево/вправо, Enter — применить тему, Esc — закрыть.
PanelWindow {
    id: root

    visible: false
    focusable: true
    color: "transparent"
    surfaceFormat.opaque: false

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    function open() {
        visible = true;
        Qt.callLater(() => contentRoot.forceActiveFocus());
    }

    function close() {
        visible = false;
        Qt.quit();
    }

    // Плавный fade-out, затем действие (применить тему или просто закрыть)
    function fadeOut(applyTheme) {
        fadeAnim.applyTheme = applyTheme;
        fadeAnim.start();
    }

    PropertyAnimation {
        id: fadeAnim
        target: contentRoot
        property: "opacity"
        to: 0
        duration: Motion.fade
        easing.type: Motion.easeOut

        property bool applyTheme: false

        onFinished: {
            if (applyTheme)
                ThemeApplier.apply(WallpaperService.wallpapers[carousel.currentIndex]);
            root.close();
        }
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true
        opacity: 1

        // Затемнённый фон overlay
        Rectangle {
            anchors.fill: parent
            color: Configs.overlayColor
        }

        // Клик вне карусели — закрыть
        TapHandler {
            acceptedButtons: Qt.LeftButton
            onTapped: root.fadeOut(false)
        }

        Carousel {
            id: carousel
            anchors.centerIn: parent
            width: parent.width
            height: parent.height * Configs.cardHeightRatio
            model: WallpaperService.wallpapers
            currentIndex: 0
            cardHeight: height
            cardWidth: height * Configs.cardAspect
            spacing: cardWidth * Configs.spacingRatio
            bevel: height * Configs.bevelRatio
        }

        Keys.onLeftPressed: {
            if (carousel.currentIndex > 0)
                carousel.currentIndex--;
        }
        Keys.onRightPressed: {
            if (carousel.currentIndex < carousel.model.length - 1)
                carousel.currentIndex++;
        }
        Keys.onReturnPressed: root.fadeOut(true)
        Keys.onEscapePressed: root.fadeOut(false)
    }
}
