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
            if (!applyTheme)
                Qt.quit();
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

        // Задержка автоповтора: при зажатой клавише листаем медленнее
        property bool _navLocked: false

        function navigate(step) {
            if (contentRoot._navLocked)
                return;
            const next = carousel.currentIndex + step;
            if (next < 0 || next >= carousel.model.length)
                return;
            carousel.currentIndex = next;
            contentRoot._navLocked = true;
            navTimer.start();
        }

        Timer {
            id: navTimer
            interval: 80
            repeat: false
            onTriggered: contentRoot._navLocked = false
        }

        Keys.onLeftPressed: event => {
            contentRoot.navigate(-1);
            event.accepted = true;
        }
        Keys.onRightPressed: event => {
            contentRoot.navigate(1);
            event.accepted = true;
        }
        Keys.onReturnPressed: root.fadeOut(true)
        Keys.onEscapePressed: root.fadeOut(false)
    }
}
