import QtQuick
import "./shared/theme"
import "./theme"
import "./services"
import "./ui"

Item {
    focus: true

    Component.onCompleted: {
        ThemePickerController.contentRootItem = contentRoot;
        ThemePickerController.fadeAnimation = fadeAnim;
        ThemePickerController.enterAnimation = enterAnim;
        ThemePickerController.open();
    }

    PropertyAnimation {
        id: enterAnim
        target: contentRoot
        property: "opacity"
        to: 1
        duration: Motion.durationSlow
        easing.type: Motion.curveOpacityIn
    }

    PropertyAnimation {
        id: fadeAnim
        target: contentRoot
        property: "opacity"
        to: 0
        duration: Motion.durationSlow
        easing.type: Motion.curveOpacityOut

        property bool applyTheme: false

        onFinished: {
            ThemePickerController.onFadeFinished(applyTheme);
        }
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true
        opacity: 0

        Rectangle {
            anchors.fill: parent
            color: Configs.overlayColor
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

        Keys.onLeftPressed: event => { ThemePickerController.navigate(-1); event.accepted = true; }
        Keys.onRightPressed: event => { ThemePickerController.navigate(1); event.accepted = true; }
        Keys.onReturnPressed: ThemePickerController.fadeOut(true)
        Keys.onEscapePressed: ThemePickerController.fadeOut(false)
    }
}
