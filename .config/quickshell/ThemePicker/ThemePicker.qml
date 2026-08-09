import QtQuick
import Quickshell
import Quickshell.Wayland
import "./theme"
import "./services"
import "./ui"

// Корневой компонент Theme Picker: полноэкранный overlay с каруселью обоев.
// Только декларативный UI. Навигация, жизненный цикл и применение темы
// делегируются ThemePickerController (см. services/).
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

    // Экспортируем элементы, которыми управляет контроллер (id недоступны
    // через объект, поэтому нужны явные alias).
    property alias contentRootItem: contentRoot
    property alias fadeAnimation: fadeAnim

    // Связываем контроллер с этим окном, чтобы он мог управлять visible/opacity.
    Component.onCompleted: {
        ThemePickerController.view = root;
        WallpaperService.load();
        ThemePickerController.open();
    }

    // Видимая анимация fade-out. Логика завершения — в контроллере.
    PropertyAnimation {
        id: fadeAnim
        target: contentRoot
        property: "opacity"
        to: 0
        duration: Motion.fade
        easing.type: Motion.easeOut

        property bool applyTheme: false

        onFinished: {
            ThemePickerController.onFadeFinished(applyTheme);
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

        // Клик вне карусели — закрыть без применения темы
        TapHandler {
            acceptedButtons: Qt.LeftButton
            onTapped: ThemePickerController.fadeOut(false)
        }

        Carousel {
            id: carousel
            anchors.centerIn: parent
            width: parent.width
            height: parent.height * Configs.cardHeightRatio
            model: WallpaperService.wallpapers
            currentIndex: ThemePickerController.currentIndex
            cardHeight: height
            cardWidth: height * Configs.cardAspect
            spacing: cardWidth * Configs.spacingRatio
            bevel: height * Configs.bevelRatio
        }

        Keys.onLeftPressed: event => {
            ThemePickerController.navigate(-1);
            event.accepted = true;
        }
        Keys.onRightPressed: event => {
            ThemePickerController.navigate(1);
            event.accepted = true;
        }
        Keys.onReturnPressed: ThemePickerController.fadeOut(true)
        Keys.onEscapePressed: ThemePickerController.fadeOut(false)
    }
}