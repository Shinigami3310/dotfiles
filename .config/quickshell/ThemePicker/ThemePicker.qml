import QtQuick
import "./theme"
import "./services"
import "./ui"

Item {
    id: root
    focus: true

    property alias contentRootItem: contentRoot
    property alias fadeAnimation: fadeAnim

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

        Rectangle {
            anchors.fill: parent
            color: Configs.overlayColor
        }

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